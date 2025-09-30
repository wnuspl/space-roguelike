system = {
	room_list = {},
	crnt_room = 1
}

function _init()
	add(system.room_list, create_room(0,0, {1}, {{x=14,y=12}}))
	add(system.room_list, create_room(1,0, {0,3}, {{x=1,y=3},{x=11, y=14}}))
	add(system.room_list, create_room(2,0, {2,1}, {{x=4,y=1}, {x=14, y=11}}))
	player = create_plr(system)
end

function _update60()
	update_plr(player)
end


function _draw()
	cls(0)
	local room = player.sys.room_list[player.sys.crnt_room]
	map(room.mapx*16, room.mapy*16)
	draw_plr(player)
end
