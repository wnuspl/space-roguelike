PLR_LEFT_SPRITE = 1
PLR_DOWN_SPRITE = 17
PLR_UP_SPRITE = 16
PLR_SPEED = 1

function create_plr(system)
	return {
		x=20,
		y=20,
		w=8,
		h=8,
		direction=0,
		sys = system
	}
end


function update_plr(plr)	
	local room = player.sys.room_list[player.sys.crnt_room]

	if is_map_exit(plr.x, plr.y, room.mapx, room.mapy) then
		local tx,ty = plr.x\8, plr.y\8
		local side = 3
		if (tx==15) side = 1	
		if (tx==0) side = 0	
		if (ty==15) side = 3
		if (ty==0) side = 2
		local nr = next_room(plr.sys.room_list, side)
		enter_room(plr.sys, plr, nr.room_idx, nr.entrance_idx)
	end

		



	local dx = 0 ; local dy = 0
	if (btn(0)) dx -= 1
	if (btn(1)) dx += 1
	if (btn(2)) dy -= 1
	if (btn(3)) dy += 1


	--normalize movement vector
	local magnitude = sqrt(dx^2 + dy^2)
	dx *= (PLR_SPEED/magnitude)
	dy *= (PLR_SPEED/magnitude)


	--rotating player
	if dy>0 then player.direction = 3
	elseif dy<0 then player.direction = 2
	elseif dx>0 then player.direction = 1
	elseif dx<0 then player.direction = 0 end



	dx,dy = level_clamp_vec(player, dx, dy, room.mapx, room.mapy)
	
	player.x += dx
	player.y += dy
end



function draw_plr(plr)
	palt(0,false)
	palt(2,true)

	--get rotated sprite
	local n = PLR_LEFT_SPRITE
	local flipx = false
	if (player.direction==0) flipx = true
	if (player.direction==2) n = PLR_UP_SPRITE
	if (player.direction==3) n = PLR_DOWN_SPRITE

	spr(n, player.x, player.y, 1, 1, flipx)	

	palt()
end
