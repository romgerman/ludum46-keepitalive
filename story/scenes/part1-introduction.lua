local b = require("ui.button")
local gstate = require("story.globalstate")
local sequence = require("story.branch.sequence")

local scene = {}

local function setupscene()
  local phonecall_end = sequence.create(nil, {
    "*Phone beeping*"
  }, nil, nil, function ()
    if scene.transitioncallback then
      scene.transitioncallback()
    end
  end)
  
  local phonecall_after_yes = sequence.create("Agent Brook Swatson", {
    "Good. See you later at the location. Bye!"
  }, phonecall_end)
  
  local phonecall_after_thinking1 = sequence.create("Agent Brook Swatson", {
    "And yes. We've tried to take that object with us but the dome is bolted to a table which... i don't know... was weighted like a ton. It wasn't like a typical house table with legs.",
    "It was solid. Made from some kind of metal... Well, anyway.",
    "We did fence an area around the house. So you can come and see it yourself. Maybe also try to get that potato-looking thing from the inside or, heck, take the full table with you.",
    "So... are you interested in this? Because i don't know what to do with all that stuff."
  }, nil, {
    ["Yes"] = phonecall_after_yes
  })
  
  local phonecall_thinking1 = sequence.create(nil, {
    '"A potato" you thought. "Weird".'
  }, phonecall_after_thinking1)
  
  local phonecall = sequence.create("Agent Brook Swatson", {
    "Hello, Cave. This is federal agent Brook Swatson. I thought maybe this will be interesting for you since you are a scientific researcher.",
    "Yesterday there was a call from a concerned old woman. She told me that there was a light and kind of a smoke in an abandoned house nearby which is empty since my birth day i think.",
    "I've told her that maybe there is a homeless person found out about the house. But she insisted. Told me that she checked the house not a long time ago and it was locked.",
    "Oh yeah and the police. The police have checked the house and this is why i am calling you right now.",
    "They found some strange things. That of course was strange to the police, but i'm sure you could be familiar with them.",
    "There were a seemingly old pc and an object inside a small glass dome that looked like a potato."
  }, phonecall_thinking1)
  
  local phonering = sequence.create(nil, {
    "*Phone ringing*"
  }, phonecall)

  return phonering
end

local runner = nil

function scene:load(callback)  
  scene.loaded = true
  scene.transitioncallback = callback
  
  b.loadassets()
  sequence.loadassets()

  gstate.location = "Lab"

  runner = sequence.run(setupscene())
end

function scene:draw()
  love.graphics.setBackgroundColor(106 / 255, 138 / 255, 109 / 255)
  
  runner:draw()

  love.graphics.setColor(250 / 255, 248 / 255, 236 / 255)
	love.graphics.print("Location: " .. gstate.location, 32, love.graphics.getHeight() - 72)
end

function scene:mouseclick(x, y, button)
	if button == 1 then
    if not sequence.handleclick(runner, x, y) then
      sequence.next(runner)
    end
	end
end

return scene