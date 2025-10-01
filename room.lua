ENTER_EXIT_PAIRS = {[0]=1,0,3,2}
EXIT_SPRITE_FLAG = 1

function create_room(mapx,mapy)
	--find doors
	local enter_tiles = {[0]=nil,nil,nil,nil}	
	for d=2,13 do
		if (fget(mget(mapx*16 + d, mapy*16), EXIT_SPRITE_FLAG)) enter_tiles[2] = {x=d-1, y=1}
		if (fget(mget(mapx*16 + d, mapy*16 + 15), EXIT_SPRITE_FLAG)) enter_tiles[3] = {x=d-1, y=14}
		if (fget(mget(mapx*16, mapy*16 + d), EXIT_SPRITE_FLAG)) enter_tiles[0] = {x=1, y=d-1}
		if (fget(mget(mapx*16 + 15, mapy*16 + d), EXIT_SPRITE_FLAG)) enter_tiles[1] = {x=14, y=d-1}	
	end

	for i,e in pairs(enter_tiles) do
		if e != nil then print(i) end
	end

	return {
		mapx=mapx,
		mapy=mapy,
		enter_tiles = enter_tiles,
		links = {[0]=nil,nil,nil,nil}
	}
end

function clone_room(room)
	return {
		mapx=room.mapx,
		mapy=room.mapy,
		enter_tiles = room.enter_tiles,
		links = {[0]=nil,nil,nil,nil}
	}
end

function enter_room(sys, idx, enter_side)
	local room = sys.room_list[idx]
	sys.crnt_room = idx
	sys.plr.x = room.enter_tiles[enter_side].x*8
	sys.plr.y = room.enter_tiles[enter_side].y*8
end


function enter_next_room(sys, exit_side)
	local enter_side = ENTER_EXIT_PAIRS[exit_side]

	local linked_room = sys.room_list[sys.crnt_room].links[exit_side]
	if linked_room != nil then
		print("thers a link")
		enter_room(sys, linked_room, enter_side)
		return
	end

	local possible_rooms = {}
	for i,room in pairs(sys.room_source) do
		if room.enter_tiles[enter_side] != nil then
			add(possible_rooms, i)
		end
	end

	if (#possible_rooms == 0) return nil	



	add(sys.room_list, clone_room(sys.room_source[rnd(possible_rooms)]))
	sys.room_list[sys.crnt_room].links[exit_side] = #sys.room_list
	sys.room_list[#sys.room_list].links[enter_side] = sys.crnt_room
	enter_room(sys, #sys.room_list, enter_side)
end

