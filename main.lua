system = {
	room_source = {},
	room_list = {},
	crnt_room = 1,
	plr = {}
}

function _init()
	system.plr = create_plr()
	add(system.room_list, create_room(0,0))
	add(system.room_source, create_room(1,0))
end

function _update60()
	update_room(system.room_list[system.crnt_room])
	update_plr(system)
end

function _draw()
	--cls(0)
	local room = system.room_list[system.crnt_room]
	draw_room(room)
	draw_plr(system)
	draw_ui(system)
end
