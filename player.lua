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
	local dx = 0 ; local dy = 0
	if (btn(0)) dx -= 1
	if (btn(1)) dx += 1
	if (btn(2)) dy -= 1
	if (btn(3)) dy += 1


	--normalize movement vector
	local magnitude = sqrt(dx^2 + dy^2)
	dx *= (PLR_SPEED/magnitude)
	dy *= (PLR_SPEED/magnitude)


	local plr = sys.plr
	--rotating player
	if dy>0 then plr.direction = 3
	elseif dy<0 then plr.direction = 2
	elseif dx>0 then plr.direction = 1
	elseif dx<0 then plr.direction = 0 end


	local room = sys.room_list[sys.crnt_room]
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
