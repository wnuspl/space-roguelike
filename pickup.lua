HEART_ID = 5
COIN_ID=6
AVAILABLE_PICKUPS = {HEART_ID,COIN_ID}

function create_pickup(id, tilex,tiley)
	return {
		x=tilex*8,
		y=tiley*8,
		id=id,
		w=8,
		h=8,
	}
end

function draw_pickup(pickup)	
	palt(0,false)
	palt(2,true)

	spr(pickup.id, pickup.x, pickup.y)

	palt()
end
