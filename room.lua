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
		links = {}
	}
end

function clone_room(room)
	return {
		mapx=room.mapx,
		mapy=room.mapy,
		enter_tiles = room.enter_tiles,
		links = {}
	}
end


function next_room(sys, exit_side)
	local possible_rooms = {}
	local enter_side = ENTER_EXIT_PAIRS[exit_side]
	print(enter_side)
	for i,room in pairs(sys.room_source) do
		if room.enter_tiles[enter_side] != nil then
			add(possible_rooms, i)
		end
	end

	if (#possible_rooms == 0) return nil	

	return clone_room(sys.room_source[rnd(possible_rooms)])
end

