system = {
	room_source = {},
	room_list = {},
	crnt_room = 1,
	plr = {}
}

upgrade = create_upgrade(32,32,34)

function _init()
	system.plr = create_plr()
	add(system.room_list, create_room(0,0))
	add(system.room_source, create_room(1,0))
	add(system.room_source, create_room(2,0))
end

function _update60()
	update_room(system.room_list[system.crnt_room])
	update_plr(system)
end

function _draw()
	--cls(0)
	local room = system.room_list[system.crnt_room]
	draw_room(room)
	--draw_upgrade(upgrade)
	draw_ui(system)
	draw_plr(system)
end
