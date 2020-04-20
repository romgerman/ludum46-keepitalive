local b = require("ui.button")
local gstate = require("story.globalstate")
local sequence = require("story.branch.sequence")

local scene = {}

local function kitchenscene()
  local kitchenlook1 = sequence.create(nil, {
    "You are standing in the kitchen"
  }, nil, {
    ["Look around more"] = sequence.create(nil, {}),
    ["Go back to the hallway"] = "hallway"
  })
  
  local touchknobs = sequence.create(nil, {
    "You are trying to rotate the knobs. They sit pretty tight. But still...",
    "Nothing happens and you go back from the stove"
  }, kitchenlook1, nil, nil, "hallway")

  return touchknobs
end

local runner = nil

function scene:load(callback)
  scene.transitioncallback = callback
  
  b.loadassets()

  gstate.location = "House"
  gstate.part = "house"

  runner = sequence.run(kitchenscene())
end

function scene:draw()
  love.graphics.setBackgroundColor(106 / 255, 138 / 255, 109 / 255)
  
  runner:draw()

  love.graphics.setColor(138 / 255, 116 / 255, 106 / 255)
	love.graphics.print("Location: " .. gstate.location, 32, love.graphics.getHeight() - 72)
end

function scene:mouseclick(x, y, button)
	if button == 1 then
    sequence.handleclick(runner, x, y)
    sequence.next(runner)
	end
end

return scene