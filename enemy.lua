module(..., package.seeall)

function new(x1, x2, y1, y2, r1, r2)
	local object = {}
	
	object.r = math.floor(math.random(r1, r2))
	
	if math.random() >= 0.5 then
		object.x = math.floor(math.random(x1, x2))
		if math.random() >= 0.5 then
			object.y = y1
		else
			object.y = y2
		end
	else
		if math.random() >= 0.5 then
			object.x = x1
		else
			object.x = x2
		end
		object.y = math.floor(math.random(y1, y2))
	end
	
	object.a = math.atan2(p.y - object.y, p.x - object.x)
	
	object.move = function()
		object.x = object.x - 3 * math.sin(object.a - math.pi / 2)
        object.y = object.y + 3 * math.cos(object.a - math.pi / 2)
	end
	
	return object
end