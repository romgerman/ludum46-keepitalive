local b = require("ui.button")

local scene = {}
local buttons = {}

function scene:load()
  b.loadassets()
  
  local testbutton = b.createbutton(100, 100, 700, 200, "Hello. This is federal agent Brook Swatson. I thought maybe it will be interesting for you since you are a scientific researcher.")
	

	table.insert(buttons, testbutton)
end

function scene:draw()
  for i, button in ipairs(buttons) do
		button.render()
	end

	love.graphics.setBackgroundColor(106 / 255, 138 / 255, 109 / 255)
end

function scene:mouseclick(x, y, button)
	if button == 1 then
		for i, button in ipairs(buttons) do
			button.clickhandler(x, y)
		end
	end
end

return scene