function check_rects_intersect(a, b)
    return not (
        a.x + a.w <= b.x or
        b.x + b.w <= a.x or
        a.y + a.h <= b.y or
        b.y + b.h <= a.y
    )
end



function is_map_solid(x,y, mapx, mapy)
 local tx,ty = (x+mapx*128)\8, (y+mapy*128)\8
 return fget(mget(tx,ty),0)
end

function is_map_exit(x,y, mapx, mapy)
 local tx,ty = (x+mapx*128)\8, (y+mapy*128)\8
 return fget(mget(tx,ty),1)
end

function level_clamp_vec(o,dx,dy, mapx,mapy)
	local nx=o.x+dx
	local ny=o.y+dy

 -- horizontal first
	if dx>0 then
		if is_map_solid(nx+o.w-1,o.y, mapx,mapy) or is_map_solid(nx+o.w-1,o.y+o.h-1, mapx,mapy) then
		   dx=((nx+o.w-1)\8)*8-o.x-o.w
		end
	elseif dx<0 then
		if is_map_solid(nx,o.y, mapx,mapy) or is_map_solid(nx,o.y+o.h-1, mapx,mapy) then
			dx=((nx\8)+1)*8-o.x
		end
	end

 -- vertical second
	ny=o.y+dy
	if dy>0 then
		if is_map_solid(o.x,ny+o.h-1, mapx,mapy) or is_map_solid(o.x+o.w-1,ny+o.h-1, mapx,mapy) then
			dy=((ny+o.h-1)\8)*8-o.y-o.h
		end
	elseif dy<0 then
		if is_map_solid(o.x,ny, mapx,mapy) or is_map_solid(o.x+o.w-1,ny, mapx,mapy) then
			dy=((ny\8)+1)*8-o.y
		end
	end

	return dx,dy
end


