STATION_LEFT_SPRITE=32
STATION_RIGHT_SPRITE=33

DEFAULT_GUN_ID=34

function create_upgrade(x,y,id)
	return {
		x=x,
		y=y,
		id=id
	}
end



function draw_upgrade(u)
	palt(0,false)
	palt(2,true)

	spr(STATION_LEFT_SPRITE, u.x,u.y)
	spr(STATION_LEFT_SPRITE, u.x+8,u.y,1,1,true)
	spr(u.id, u.x+4, u.y-5)
	
	palt()
end

