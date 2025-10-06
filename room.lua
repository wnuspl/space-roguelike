ENTER_EXIT_PAIRS = {[0]=1,0,3,2}
EXIT_SPRITE_FLAG = 1
CLOSED_DOOR_LEFT_SPRITE = 34
OPEN_DOOR_SPRITE = 22

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
		pickups = {},
		aliens = {},
		links = {[0]=nil,nil,nil,nil}
	}
end

function clone_room(room)
	return {
		mapx=room.mapx,
		mapy=room.mapy,
		enter_tiles = room.enter_tiles,
		pickups = {},
		aliens = {},
		links = {[0]=nil,nil,nil,nil}
	}
end

function update_room(room)
	if #room.aliens == 0 then
		open_doors(room)
	end
	for _, alien in pairs(room.aliens) do
		update_alien(alien, room)
	end
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
	generate_pickups(sys.room_list[#sys.room_list], 2)
	close_doors(sys.room_list[#sys.room_list])
	generate_aliens(sys.room_list[#sys.room_list], 4)
	enter_room(sys, #sys.room_list, enter_side)
end



function draw_room(room)
	palt(0,false)
	palt(2,true)
	map(room.mapx*16, room.mapy*16)
	for _,p in pairs(room.pickups) do
		draw_pickup(p)
	end
	for _,a in pairs(room.aliens) do
		draw_alien(a)
	end

	palt()
end


function generate_aliens(room, max)
	local c = flr(rnd(max+1))

	for i=1,c do
		local x,y
		repeat
			x = flr(rnd(14)+1)
			y = flr(rnd(14)+1)
		until not fget(mget(x+room.mapx*16, y+room.mapy*16), 0)
		add(room.aliens, create_alien(x*8,y*8))
	end
end



function generate_pickups(room, max)
	local c = flr(rnd(max+1))

	for i=1,c do
		local x,y
		repeat
			x = flr(rnd(14)+1)
			y = flr(rnd(14)+1)
		until not fget(mget(x+room.mapx*16, y+room.mapy*16), 0)
		add(room.pickups, create_pickup(rnd(AVAILABLE_PICKUPS), x,y))
	end
end


function get_door_tiles(room)
	local ox, oy = room.mapx*16, room.mapy*16
	local door_tiles = {[0]={}, {}, {}, {}}
	for s, e in pairs(room.enter_tiles) do
		local main = 0
		if s==0 or s==2 then --0 sides
			main = 0
		else
			main = 15
		end

		if s < 2 then
			add(door_tiles[s], {x=main+ox, y=e.y+oy})
			add(door_tiles[s], {x=main+ox, y=e.y+oy+1})
			add(door_tiles[s], {x=main+ox, y=e.y+oy-1})
		else
			add(door_tiles[s], {x=e.x+ox, y=main+oy})
			add(door_tiles[s], {x=e.x+ox+1, y=main+oy})
			add(door_tiles[s], {x=e.x+ox-1, y=main+oy})
		end


	end

	return door_tiles
end
function open_doors(room)
	for _, side in pairs(get_door_tiles(room)) do
		for _, tile in pairs(side) do
			mset(tile.x, tile.y, OPEN_DOOR_SPRITE)
		end
	end
end
			
function close_doors(room)
	for s, side in pairs(get_door_tiles(room)) do
		for _, tile in pairs(side) do
			mset(tile.x, tile.y, CLOSED_DOOR_LEFT_SPRITE+s)
		end
	end
end
