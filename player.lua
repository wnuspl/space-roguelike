MAX_LIVES = 5
PLR_LEFT_SPRITE = 1
PLR_DOWN_SPRITE = 17
PLR_UP_SPRITE = 16
PLR_SPEED = 1

function create_plr()
	return {
		x=20,
		y=20,
		w=8,
		h=8,
		direction=0,
		lives=MAX_LIVES,
		coins=0,
		iframes=0,
		projectiles = {}
	}
end


function update_plr(sys)	
	local room = sys.room_list[sys.crnt_room]
	local plr = sys.plr

	if is_map_exit(sys.plr.x,sys.plr.y,room.mapx,room.mapy) then
		local tx,ty = sys.plr.x\8, sys.plr.y\8
		local exit_side = -1
		if (tx == 0) exit_side = 0
		if (tx == 15) exit_side = 1
		if (ty == 0) exit_side = 2
		if (ty == 15) exit_side = 3

		enter_next_room(sys, exit_side)
		room = sys.room_list[sys.crnt_room]

	end

	plr.iframes = max(plr.iframes-1,0)


	for _, p in pairs(room.pickups) do
		if check_rects_intersect(sys.plr, p) then
			if p.id == HEART_ID then
				plr.lives = min(plr.lives+1, MAX_LIVES)
			end
			if p.id == COIN_ID then
				plr.coins += 1
			end
			del(room.pickups, p)
		end	
	end
	for _, a in pairs(room.aliens) do
		if check_rects_intersect(sys.plr, a) then
			if plr.iframes == 0 then
				plr.lives -= 1
				plr.iframes=30
			end
		end	
	end
	for _, p in pairs(plr.projectiles) do
		if update_projectile(p, sys) then
			del(plr.projectiles, p)
		end
	end


	local dx = 0 ; local dy = 0
	if (btn(0)) dx -= 1
	if (btn(1)) dx += 1
	if (btn(2)) dy -= 1
	if (btn(3)) dy += 1

	if btnp(4) then
		local pdx,pdy = 0,0
		local ox, oy = 0,0
		if (plr.direction == 0) pdx = -2 oy=4 ox=-8
		if (plr.direction == 1) pdx = 2 oy=4 ox=8
		if (plr.direction == 2) pdy = -2 oy=-8
		if (plr.direction == 3) pdy = 2 oy=8 ox=5
		
		add(plr.projectiles, create_projectile(plr.x+ox, plr.y+oy,pdx,pdy))
	end

	--normalize movement vector
	local magnitude = sqrt(dx^2 + dy^2)
	dx *= (PLR_SPEED/magnitude)
	dy *= (PLR_SPEED/magnitude)


	--rotating player
	if dy>0 then plr.direction = 3
	elseif dy<0 then plr.direction = 2
	elseif dx>0 then plr.direction = 1
	elseif dx<0 then plr.direction = 0 end


	dx,dy = level_clamp_vec(plr, dx, dy, room.mapx, room.mapy)
	
	plr.x += dx
	plr.y += dy
end



function draw_plr(sys)
	palt(0,false)
	palt(2,true)

	--get rotated sprite
	local n = PLR_LEFT_SPRITE
	local flipx = false
	if (sys.plr.direction==0) flipx = true
	if (sys.plr.direction==2) n = PLR_UP_SPRITE
	if (sys.plr.direction==3) n = PLR_DOWN_SPRITE

	spr(n, sys.plr.x, sys.plr.y, 1, 1, flipx)	

	palt()

	for _, p in pairs(sys.plr.projectiles) do
		draw_projectile(p)
	end
end



function create_projectile(x,y, dx,dy)
	return {
		x=x,
		y=y,
		dx=dx,
		dy=dy,
		w=8,
		h=3
	}
end
function update_projectile(projectile, sys)
	local room = sys.room_list[sys.crnt_room]


	projectile.x += projectile.dx
	projectile.y += projectile.dy	

	if is_map_solid(projectile.x, projectile.y, room.mapx, room.mapy) or
	   is_map_solid(projectile.x+projectile.w, projectile.y+projectile.h, room.mapx, room.mapy) then
		return 1;
	end



	for _,a in pairs(room.aliens) do
		if check_rects_intersect(projectile, a) then
			kill_alien(a, room)
		end
	end

end

function draw_projectile(projectile)
	n = 18
	if (projectile.dx == 0) n = 20
	spr(n, projectile.x, projectile.y)
end
