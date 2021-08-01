local enemy = require("enemy")
enemies = {}
local spawn = 0

function love.load()
	love.window.setMode(1280, 720)

	mx = 0
	my = 0
	local player = require("player")

	p = player.new(800, 450, 30, 45, 0, 10)
	p.newgun(-3 * p.w / 8, p.h / 8, 15)
	p.newgun(3 * p.w / 8, p.h / 8, 15)
end

function love.update()
	if p.x > 500 and p.x < 1100 then
		offx = p.x
	end
	if p.y > 280 and p.y < 720 then
		offy = p.y
	end

	for _, v in pairs(p.guns) do
		v.reload = v.reload - 1
	end
	spawn = spawn - 1

	if love.mouse.isDown(1) then
		p.shoot()
	end
	
	if spawn <= 0 then
		enemies[#enemies + 1] = enemy.new(0, 1600, 0, 900, 10, 30)
		spawn = 10
	end
	
	if love.keyboard.isDown("w") then
		p.a = p.a + 0.001
	elseif love.keyboard.isDown("s") then
		p.a = p.a - 0.001
	end

	if love.keyboard.isDown("d") then
		p.ra = p.ra + 0.0002
	elseif love.keyboard.isDown("a") then
		p.ra = p.ra - 0.0002
	end
	
	p.move()
	for _, v in pairs(p.bullets) do
		v.move()
	end
	p.check()
	
	for i, e in pairs(enemies) do
		e.move()
		
		for _, v in pairs(p.bullets) do
			local d = math.sqrt((v.x - e.x) * (v.x - e.x) + (v.y - e.y) * (v.y - e.y))
			if d < e.r + 2 then
				table.remove(enemies, i)
				p.score = p.score + 1
			end
		end
		
		if e.x < -5 or e.x > 1600 + 5 or e.y < -5 or e.y > 900 + 5 then
			table.remove(enemies, i)
		end
	end
	
	--rotating hitbox fail
	--love.graphics.rotate(p.a)
	--for i, e in pairs(enemies) do
	--	if e.x < p.x + p.w / 4 and e.x > p.x - p.w /4 and e.y < p.y + p.h / 2 and e.y > p.y - p.h / 2 then
	--		table.remove(enemies, i)
	--		p.hp = p.hp - 1
	--	end
	--end
	--love.graphics.origin()
end

function love.draw()
	love.graphics.translate(-offx + love.graphics.getWidth() / 2, -offy + love.graphics.getHeight() / 2)
	
	love.graphics.rectangle("line", 0, 0, 1600, 900)
	
	love.graphics.push()
		love.graphics.translate(p.x, p.y)
		love.graphics.rotate(p.angle)
		love.graphics.rectangle("line", - p.w / 4, - p.h / 2, p.w / 2, p.h)
		love.graphics.rectangle("line", - p.w / 2, 0, p.w / 4, p.h / 4)
		love.graphics.rectangle("line", p.w / 4, 0, p.w / 4, p.h / 4)
	love.graphics.pop()
	
	for _, e in pairs(enemies) do
		love.graphics.circle("line", e.x, e.y, e.r)
	end
	
	for k, l in pairs(p.guns) do
		love.graphics.circle("line", l.x, l.y, 2)
	end

	for j, v in pairs(p.bullets) do
		love.graphics.push()
			love.graphics.translate(v.x, v.y)
			love.graphics.rotate(v.a)
			love.graphics.line(0, -3, -2, 2)
			love.graphics.line(-2, 2, 2, 2)
			love.graphics.line(2, 2, 0, -3)
		love.graphics.pop()
	end

	love.graphics.print(p.score, offx - love.graphics.getWidth() / 2, offy - love.graphics.getHeight() / 2)
	love.graphics.print(p.x, offx - love.graphics.getWidth() / 2, 10 + offy - love.graphics.getHeight() / 2)
	love.graphics.print(p.y, offx - love.graphics.getWidth() / 2, 20 + offy - love.graphics.getHeight() / 2)
	love.graphics.print(p.angle, offx - love.graphics.getWidth() / 2, 30 + offy - love.graphics.getHeight() / 2)
	love.graphics.print(love.mouse.getX() + offx - love.graphics.getWidth() / 2, offx - love.graphics.getWidth() / 2, 40 + offy - love.graphics.getHeight() / 2)
	love.graphics.print(love.mouse.getY() + offy - love.graphics.getHeight() / 2, offx - love.graphics.getWidth() / 2, 50 + offy - love.graphics.getHeight() / 2)
	if #p.bullets > 0 then
		love.graphics.print(p.bullets[#p.bullets].a, offx - love.graphics.getWidth() / 2, 60 + offy - love.graphics.getHeight() / 2)
	end
	
	love.graphics.origin()
end