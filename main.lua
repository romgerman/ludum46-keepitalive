local scene1 = require("story.scenes.part1-introduction")
local scene2 = require("story.scenes.part2-thehouse")
local scene3 = require("story.scenes.part3-thething")
local testscene = require("story.scenes.testback")
local scenetransition = require("story.scenetransition")
local gstate = require("story.globalstate")

local transition = nil
local curscene = nil

-- part 3 will call transition callback with argument = "from basement" so need to go to part2 scene

function love.load()
	love.window.setMode(1280, 720)
	love.window.setTitle("One Day Outside")
	love.graphics.setDefaultFilter("nearest", "nearest", 1)

	-- gstate.wasinkitchen = true
	-- gstate.wasupstairs = true
	-- gstate.livingroom = true

	scene1:load(function ()
		transition = scenetransition(scene1, scene2, 1, function ()
			scene2:load(function ()
				transition = scenetransition(scene2, scene3, 1, function ()
					scene3:load(function (arg)
						if arg == "from basement" then
							transition = scenetransition(scene3, scene2, 1, function ()
								scene2:load(function ()
									transition = scenetransition(scene2, scene3, 1, function ()
										scene3:load()
										curscene = scene3
									end)
								end)

								curscene = scene2
							end)
						end
					end)

					curscene = scene3
				end)
			end)

			curscene = scene2
		end)
	end)

	-- scene3:load(function (arg)
	-- 	if arg == "from basement" then
	-- 		transition = scenetransition(scene3, scene2, 1, function ()
	-- 			scene2:load(function ()
	-- 				transition = scenetransition(scene2, scene3, 1, function ()
	-- 					scene3:load()
	-- 					curscene = scene3
	-- 				end)
	-- 			end)
	-- 			curscene = scene2
	-- 		end)
	-- 	end
	-- end)

	curscene = scene1
end

function love.draw()
	curscene:draw()

	if transition then
		transition()
	end
end

function love.mousepressed(x, y, button)
	curscene:mouseclick(x, y, button)
end