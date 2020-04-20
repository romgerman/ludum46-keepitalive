-- returns draw function
local function scenetransition(scene1, scene2, time, callback)
	local curfrac = 0.0
	local called = false
	local finished = false
	
	return function ()
		if finished then
			return
		end
		
		if curfrac >= 1.0 and not called then
			if callback then
				callback(scene2)
				called = true
			end
		end

		if curfrac <= 0.001 and called and not finished then
			finished = true
		end

		love.graphics.setColor(0, 0, 0, curfrac)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

		if not called then
			curfrac = curfrac + love.timer.getDelta() / time
		else
			curfrac = curfrac - love.timer.getDelta() / time
		end
	end
end

return scenetransition