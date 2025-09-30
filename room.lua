ENTER_EXIT_PAIRS = {1,0,3,2}

function create_room(mapx,mapy, door_sides, enter_tiles)
	--find doors

	return {
		mapx=mapx,
		mapy=mapy,
		door_sides = door_sides, --left right up down
		enter_tiles = enter_tiles, -- door_tiles[i][1] == spawn
		links = {}
	}
end



function next_room(room_list, exit_side)
	local possible_rooms = {}
	for i,room in pairs(room_list) do
		for ei,side in pairs(room.door_sides) do
			if ENTER_EXIT_PAIRS[side+1] == exit_side then
				add(possible_rooms, {room_idx=i, entrance_idx=ei})
			end
		end
	end

	if (#possible_rooms == 0) return nil

	return rnd(possible_rooms)
end


function enter_room(sys, plr, room_idx, entrance_idx)
	sys.crnt_room = room_idx
	local entrance_pos = sys.room_list[room_idx].enter_tiles[entrance_idx]
	plr.x = entrance_pos.x*8
	plr.y = entrance_pos.y*8	
end
