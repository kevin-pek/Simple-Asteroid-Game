module(..., package.seeall)

function new(x, y, w, h, angle, hp)
	local object = {}
	local gun = require("gun")
	local bullet = require("bullet")
	
	object.x = x
	object.y = y
	object.w = w
	object.h = h

	object.v = 0
	object.a = 0
	object.ra = 0
	object.angle = angle
	
	object.score = 0
	object.hp = hp

	object.bullets = {}
	object.guns = {}
	object.newgun = function(offx, offy, r)
		object.guns[#object.guns + 1] = gun.new(offx, offy, r)
		object.guns[#object.guns].angle = math.atan2(offx, -offy)
		
		local distance = math.sqrt(object.guns[#object.guns].offx * object.guns[#object.guns].offx + object.guns[#object.guns].offy * object.guns[#object.guns].offy)
		local x = object.x + (math.sin(object.angle - object.guns[#object.guns].angle) * distance)
		local y = object.y - (math.cos(object.angle - object.guns[#object.guns].angle) * distance)
		
		object.guns[#object.guns].x = x
		object.guns[#object.guns].y = y
	end

	object.shoot = function()
		for i, v in pairs(object.guns) do
			if v.reload <= 0 then
				local mx, my = love.mouse.getPosition()
				local mx = mx + offx - love.graphics.getWidth() / 2
				local my = my + offy - love.graphics.getHeight() / 2
				local a = math.atan2(my - v.y, mx - v.x) + math.pi / 2
				
				object.bullets[#object.bullets + 1] = bullet.new(v.x, v.y, a, 4)
				v.reload = 10
			end
		end
	end
	
	object.move = function()
		object.v = object.v + object.a
		object.angle = object.angle + object.ra
		
		object.v = object.v * 0.98
		object.a = object.a * 0.97
		object.ra = object.ra * 0.99
		
		if object.v > 1.5 then
			object.v = 1.5
		elseif object.v < -1.5 then
			object.v = -1.5
		end
		if object.a > 0.03 then
			object.a = 0.03
		elseif object.a < -0.03 then
			object.a = -0.03
		end
		if object.ra > 0.01 then
			object.ra = 0.01
		elseif object.ra < -0.01 then
			object.ra = -0.01
		end
		
		if object.v < 0.0001 and object.v > -0.0001 then
			object.v = 0
		end
		if object.a < 0.0001 and object.a > -0.0001 then
			object.a = 0
		end
		if object.ra < 0.0001 and object.ra > -0.0001 then
			object.ra = 0
		end
		
		object.x = object.x + object.v * math.cos(object.angle - math.pi / 2);
        object.y = object.y + object.v * math.sin(object.angle - math.pi / 2);
	end
	
	object.check = function()
		--remove out of bounds bullets
		for f, k in pairs(object.bullets) do
			if k.x < -5 or k.x > 1600 + 5 or k.y < -5 or k.y > 900 + 5 then
				table.remove(object.bullets, f)
			end
		end
		
		--update gun positions based on player rotation and position
		for k, l in pairs(p.guns) do
			local distance = math.sqrt(l.offx * l.offx + l.offy * l.offy)
			local x = object.x + (math.sin(object.angle - l.angle) * distance)
			local y = object.y - (math.cos(object.angle - l.angle) * distance)
			
			l.x = x
			l.y = y
		end
	end

	return object
end