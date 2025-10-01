HEART_ID = 5
COIN_ID=6
AVAILABLE_PICKUPS = {HEART_ID,COIN_ID}
BOB_CYCLE_LEN = 120

function create_pickup(id, tilex,tiley)
	return {
		tilex=tilex,
		tiley=tiley,
		id=id,
		bob = flr(rnd(120))
	}
end

function draw_pickup(pickup)	
	pickup.bob += 1
	if pickup.bob > 60 then
		pickup.bob = 0
	end	

	up = 0
	if pickup.bob > 30 then
		up = 1
	end

	palt(0,false)
	palt(2,true)

	spr(pickup.id, pickup.tilex*8, pickup.tiley*8 + up)

	palt()
end
