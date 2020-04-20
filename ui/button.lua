local rectpointcollision = require("ui.rectcollision")

local assets = {}

local function createbutton(x, y, width, height, text, behavior)
  local coll = rectpointcollision(x, y, width, height)
  local animfinished = 0
  local lastanimtime = love.timer.getTime()

  local o = {}

  local ytextoffset = 24

  if behavior and behavior.nooffset then
    ytextoffset = 0
  end

  local render = function()
    if type(text) == "function" then
      text = text()
    end
    
    love.graphics.setColor(250 / 255, 248 / 255, 236 / 255)
    love.graphics.setFont(assets.font)

    love.graphics.rectangle("fill", x + 7, y - 5, width + 7, height + 9)

    love.graphics.draw(assets.top_left_corner, x, y - 9, 0)
    love.graphics.draw(assets.left_side, x, y, 0, 1, height)
    love.graphics.draw(assets.top_left_corner, x, y + height + 9, math.rad(-90))
    love.graphics.draw(assets.left_side, x + 9, y + height + 9, math.rad(-90), 1, width)
    love.graphics.draw(assets.top_left_corner, x + width + 9 + 7, y + height + 9, math.rad(-180))
    love.graphics.draw(assets.left_side, x + 7 + width + 9, y + height, 0, -1, -height)
    love.graphics.draw(assets.top_left_corner, x + width + 9 + 7, y - 9, math.rad(-270))
    love.graphics.draw(assets.left_side, x + 9, y - 9, math.rad(-90), -1, width)

    if text then
      love.graphics.setColor(0, 5 / 255, 16 / 255)

      if behavior and behavior.animate and animfinished <= string.len(text) then
        love.graphics.printf(string.sub(text, 0, animfinished), x + 18, y + ytextoffset, width - 16)

        if (love.timer.getTime() - lastanimtime) * 1000 >= behavior.animate then
          animfinished = animfinished + 1
          lastanimtime = love.timer.getTime()
        end
      else
        love.graphics.printf(text, x + 18, y + ytextoffset, width - 16)
      end
    end
  end

  local clickhandler = function (posx, posy)
    if coll(posx, posy) then
      if behavior and behavior.onclick then
        behavior.onclick(o)
        return true
      end
    end

    return false
  end

  local finishanimation = function ()
    animfinished = string.len(text)
  end

  o = {
    render = render,
    clickhandler = clickhandler,
    finishanimation = finishanimation,
    animating = function ()
      return behavior and behavior.animate and animfinished <= string.len(text)
    end,
    width = width,
    height = height,
    posx = x,
    posy = y
  }

  return o
end

local function loadassets()
  assets.left_side = love.graphics.newImage("assets/left_side_7x1.png")
  assets.top_left_corner = love.graphics.newImage("assets/top_left_corner_9x9.png")
  assets.font = love.graphics.newFont("assets/advanced-pixel-7/advanced_pixel-7.ttf", 45)
  assets.font:setLineHeight(0.9)
end

return {
  createbutton = createbutton,
  loadassets = loadassets
}