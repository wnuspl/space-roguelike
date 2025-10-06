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

function create_pew()
	local out = {
		id=1,
		update=function(this,sys) end,
		draw=function(this,sys) end,
		projectiles = {} -- non-mandatory
	}

	out.update = function(this, sys)
		if btnp(4) then
			local pdx,pdy = 0,0
			local ox, oy = 0,0
			if (sys.plr.direction == 0) pdx = -2 oy=4 ox=-8
			if (sys.plr.direction == 1) pdx = 2 oy=4 ox=8
			if (sys.plr.direction == 2) pdy = -2 oy=-8
			if (sys.plr.direction == 3) pdy = 2 oy=8 ox=5
			
			add(this.projectiles, create_projectile(sys.plr.x+ox, sys.plr.y+oy,pdx,pdy))
		end

		for _, projectile in pairs(this.projectiles) do
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

	end

	out.draw = function(this,sys)
		for _, projectile in pairs(this.projectiles) do
			n = 18
			if (projectile.dx == 0) n = 20
			spr(n, projectile.x, projectile.y)
		end
	end

	return out

end








CHARGE_TIME = 30
SHOOT_TIME=60


function create_laserbeam()
	local out = {
		id = 2,
		update = nil,
		draw = nil,
		charge=0,
		shoot_duration=0,
		locked_direction=0
	}

	out.update = function(this, sys)

		local room = sys.room_list[sys.crnt_room]
		if (btn(4) and this.shoot_duration == 0) this.charge += 1
		if not btn(4) and this.charge>CHARGE_TIME then --go time
			this.shoot_duration = SHOOT_TIME
			this.locked_direction = sys.plr.direction
			this.charge = 0
		end

		if this.shoot_duration > 0 then
			local area = {
				x = sys.plr.x,
				y = sys.plr.y,
				w = 8,
				h = 8
			}
			if (this.locked_direction == 0) area.w = sys.plr.x area.x = 0
			if (this.locked_direction == 1) area.w = 128
			if (this.locked_direction == 2) area.h = sys.plr.y area.y = 0
			if (this.locked_direction == 3) area.h = 128
				
			
			for _,a in pairs(room.aliens) do
				if check_rects_intersect(area, a) then
					kill_alien(a, room)
				end
			end


			this.shoot_duration -= 1
		end
	end

	-- down 3 for lr
	-- left 2 for up
	-- right 4 for down
	out.draw = function(this, sys) 
		if this.shoot_duration > 0 then
			stepx, stepy = sys.plr.x, sys.plr.y
			dx,dy = 0,0
			ox,oy = 0,0
			sx,sy = 0,0
			n = 38
			if (this.locked_direction == 0) ox = -8 oy = 3 dx = -1
			if (this.locked_direction == 1) ox = 8 oy = 3 dx = 1 sx = 8
			if (this.locked_direction == 2) ox = -2 oy = -8 dy = -1 n = 40
			if (this.locked_direction == 3) ox = 4 oy = 8 dy = 1 n = 40 sy = 8

			stepx += ox stepy += oy

			local room = sys.room_list[sys.crnt_room]

			while not is_map_solid(stepx+sx, stepy+sy, room.mapx, room.mapy) do
				spr(n, stepx, stepy)
				stepx += dx*8
				stepy += dy*8
			end

			if this.locked_direction == 0 then
				spr(n+1, (8-stepx%8) + stepx, stepy)
			end
			if this.locked_direction == 1 then
				spr(n+1,  stepx-(stepx%8), stepy)
			end
			if this.locked_direction == 2 then
				spr(n+1,  stepx, (8-stepy%8)+stepy)
			end
			if this.locked_direction == 3 then
				spr(n+1,  stepx, stepy-(stepy%8))
			end
			
		end
	end

	return out
end



		



	
