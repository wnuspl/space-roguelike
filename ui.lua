RED_HEART = 5
GREY_HEART = 21
HEART_SPACING = 0
function draw_ui(sys)
	palt(0,false)
	palt(2,true)
	for i=1,MAX_LIVES do
		n = GREY_HEART
		if (sys.plr.lives >= i) n = RED_HEART
		spr(n, (HEART_SPACING+8)*i, HEART_SPACING)
	end
	spr(COIN_ID, (1+MAX_LIVES)*8+8, HEART_SPACING)
	print(sys.plr.coins, (2+MAX_LIVES)*8+10, HEART_SPACING+1, 0)
	palt()
end

