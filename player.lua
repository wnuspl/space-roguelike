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
		direction=0
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


		room = next_room(sys, exit_side)
		if room != nil then
			add(sys.room_list, room)
			sys.crnt_room = #sys.room_list

			plr.x = room.enter_tiles[ENTER_EXIT_PAIRS[exit_side]].x*8
			plr.y = room.enter_tiles[ENTER_EXIT_PAIRS[exit_side]].y*8
			
		end
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
end
