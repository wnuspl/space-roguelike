MAX_LIVES = 5
PLR_LEFT_SPRITE = {1, 23}
PLR_DOWN_SPRITE = {17, 24}
PLR_UP_SPRITE = {16, 25}
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
		weapon=AVAILABLE_WEAPONS[1]
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

	plr.weapon.update(plr.weapon, sys)


	local dx = 0 ; local dy = 0
	if (btn(0)) dx -= 1
	if (btn(1)) dx += 1
	if (btn(2)) dy -= 1
	if (btn(3)) dy += 1

	if (btnp(5)) then
		plr.weapon = rnd(AVAILABLE_WEAPONS)
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
	sys.plr.weapon.draw(sys.plr.weapon, sys)
	local sprite_var = 0

	if sys.plr.weapon.id == 2 then
		if sys.plr.weapon.shoot_duration > 0 then
			sys.plr.direction = sys.plr.weapon.locked_direction
			sprite_var = 19
		end
		if sys.plr.weapon.charge > CHARGE_TIME then
			sprite_var = 19
		end
	end


	palt(0,false)
	palt(2,true)

	--get rotated sprite
	n = PLR_LEFT_SPRITE
	local flipx = false
	if (sys.plr.direction==0) flipx = true
	if (sys.plr.direction==2) n = PLR_UP_SPRITE
	if (sys.plr.direction==3) n = PLR_DOWN_SPRITE


	n = n[sys.plr.weapon.id] + sprite_var


	spr(n, sys.plr.x, sys.plr.y, 1, 1, flipx)	

	palt()



end



