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
end

function _draw()
    cls(col2)
    circfill(px, py, prad, col1)
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
