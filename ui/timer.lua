local function createtimer(delay, x, y, callback, behavior)
  local o = {
    running = false,
    showing = false
  }

  local start = nil
  local cur = delay
  local curtime = 0

  function o.draw()
    if o.showing then
      love.graphics.setColor(250 / 255, 248 / 255, 236 / 255)
      love.graphics.print(tostring(math.floor(cur)), x, y)
    end

    if o.running then
      if love.timer.getTime() >= start + delay then
        o.running = false
        o.show(false)
        if callback then
          callback()
        end
      end

      if behavior then
        if behavior.every and behavior.callback and curtime <= (delay - cur) / behavior.every then
          behavior.callback()
          curtime = curtime + 1
        end
      end

      cur = cur - love.timer.getDelta()
    end
  end

  function o.start()
    o.running = true
    start = love.timer.getTime()
  end

  function o.show(toggle)
    o.showing = toggle
  end

  function o.cancel()
    o.running = false
  end
  
  return o
end

return {
  create = createtimer
}