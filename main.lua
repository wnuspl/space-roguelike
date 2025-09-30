player = {
	x=20,
	y=40,
	w=8,
	h=8
}

function _update()
	local dx = 1
	local dy = -1

	d = map_penetration_vec(player, dx, dy)
	player.x += d.x
	player.y += d.y
end


function _draw()
	cls(0)
	map()
	spr(1, player.x,player.y)
end
