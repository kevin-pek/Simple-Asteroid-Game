module(..., package.seeall)

function new(x, y, a, v)
	local object = {}

	object.x = x
	object.y = y
	object.a = a
	object.v = v
	
	object.move = function()
		object.x = object.x + object.v * math.cos(object.a - math.pi / 2)
        object.y = object.y + object.v * math.sin(object.a - math.pi / 2)
	end
	
	return object
end