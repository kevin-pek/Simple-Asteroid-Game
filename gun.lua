module(..., package.seeall)

function new(offx, offy, r)
	local object = {}

	object.angle = 0
	object.offx = offx
	object.offy = offy
	object.x = 0
	object.y = 0
	
	object.reload = r
	
	return object
end