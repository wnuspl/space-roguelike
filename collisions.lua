function check_rects_intersect(a, b)
    return not (
        a.x + a.w <= b.x or
        b.x + b.w <= a.x or
        a.y + a.h <= b.y or
        b.y + b.h <= a.y
    )
end



function is_map_solid(x,y)
 local tx,ty=flr(x/8),flr(y/8)
 return fget(mget(tx,ty),0)
end

function map_penetration_vec(o,dx,dy)
	local nx=o.x+dx
	local ny=o.y+dy

 -- horizontal first
	if dx>0 then
		if is_map_solid(nx+o.w-1,o.y) or is_map_solid(nx+o.w-1,o.y+o.h-1) then
		   dx=((nx+o.w-1)\8)*8-o.x-o.w
		end
	elseif dx<0 then
		if is_map_solid(nx,o.y) or is_map_solid(nx,o.y+o.h-1) then
			dx=((nx\8)+1)*8-o.x
		end
	end

 -- vertical second
 ny=o.y+dy
 if dy>0 then
  if is_map_solid(o.x,ny+o.h-1) or is_map_solid(o.x+o.w-1,ny+o.h-1) then
   dy=((ny+o.h-1)\8)*8-o.y-o.h
  end
 elseif dy<0 then
  if is_map_solid(o.x,ny) or is_map_solid(o.x+o.w-1,ny) then
   dy=((ny\8)+1)*8-o.y
  end
 end

 return {x=dx,y=dy}
end


