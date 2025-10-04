ALIEN_SPRITE = 2
ALIEN_SPEED = 0.4
CHANGE_DIRECTION_CHANGE = 120

function create_alien(x,y)
	return {
		x=x,
		y=y,
		w=8,
		h=8,
		direction=0
	}
end

function update_alien(alien, room)
	local c = flr(rnd(CHANGE_DIRECTION_CHANGE))
	if (c < 4) then
		alien.direction = c
	end

	local dx,dy = 0,0

	if (alien.direction == 0) dx = -1
	if (alien.direction == 1) dx = 1
	if (alien.direction == 2) dy = -1
	if (alien.direction == 3) dy = 1

	
	dx *= ALIEN_SPEED
	dy *= ALIEN_SPEED


	dx,dy = level_clamp_vec(alien, dx, dy, room.mapx, room.mapy)


	alien.x += dx
	alien.y += dy
end

function draw_alien(alien)
	palt(0, false)
	palt(2,true)

	n = ALIEN_SPRITE
	spr(n, alien.x, alien.y)

	palt()
end
	


function kill_alien(alien, room)
	local r = flr(rnd(3))
	if r == 0 then
		add(room.pickups, create_pickup(rnd(AVAILABLE_PICKUPS), alien.x\8, alien.y\8))
	end
	del(room.aliens, alien)
end
