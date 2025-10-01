HEART_ID = 2


function create_pickup(id, tilex,tiley)
	return {
		tilex=tilex,
		tiley=tiley,
		id=id
	}
end

function draw_pickup(pickup,mapx,mapy)	
	palt(0,false)
	palt(2,true)

	spr(pickup.id, pickup.tilex*8+mapx*128, pickup.tiley*8+mapy*128)

	palt()
end
