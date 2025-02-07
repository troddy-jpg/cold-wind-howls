pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    col1, col2 = 15, 1
    px, py, prad = 64, 10, 2
    yvel = 0
    gravity = 0.2
    maxvel = 3
    chute_deployed = false         
    chute_maxvel = -3              
    chute_lerp_factor = 0.05       
    xvel = 1                     
    drift_lerp_factor = 0.1      
    margin = 10                
    chute_target_multiplier = 30  
    base_target_speed = 1
    function lerp(a, b, t)
        return a + (b - a) * t
    end
	lerping=false
	speedlines={}
	for i=1,100 do
		speedlines[i]={
			x=rnd(margin*2)-margin, y=rnd(128)
		}
	end
end

function _update()
    if (py > 128 - 2*(prad+1)) then
        py = 128 - 2*(prad+1)
    end
    if (py < 2*(prad+1)) then
        py = 2*(prad+1)
    end
    chute_deployed = (btn(4) == true)
    if not chute_deployed then
        yvel += gravity
        if (yvel > maxvel) then
            yvel = maxvel
        end
    else
        yvel = lerp(yvel, chute_maxvel, chute_lerp_factor)
    end
    py += yvel
    local target_speed = base_target_speed
    if chute_deployed and lerping then
        target_speed = base_target_speed * chute_target_multiplier
    end
	lerping=false
    if (px < margin) then
		lerping=true
        xvel = lerp(xvel, target_speed, drift_lerp_factor)
    elseif (px > 128 - margin) then
		lerping=true
        xvel = lerp(xvel, -target_speed, drift_lerp_factor)
    end
    px += xvel
    if (px > 128 - 2*(prad+1)) then
		xvel=0
		yvel-=0.2
        px = 128 - 2*(prad+1)
    end
    if (px < 2*(prad+1)) then
		xvel=0
        px = 2*(prad+1)
    end
	--update speedlines
	for i=1,#speedlines do
        local s = speedlines[i]
		s.y -= (4 - i % 4)
        s.x += sin(time() * 0.25 + i * 0.1)
		if(s.y<0)s.y=126 s.x=rnd(margin)
		if(abs(s.x)>margin) s.x=rnd(margin*2)-margin
	end
end

function _draw()
    cls(col2)
    circfill(px, py, prad, col1)
	for i=1,#speedlines do
        local sl=speedlines[i]
		if(sl.x<0) then line(128+sl.x,sl.y,128+sl.x,sl.y+2,col1)
		else line(sl.x,sl.y,sl.x,sl.y+2,col1) end 
	end
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
