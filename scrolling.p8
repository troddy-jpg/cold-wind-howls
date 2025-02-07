pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    col1, col2 = 15, 1
    px, py, prad = 64, 10, 2
    yvel = 0				-- vertical movement parameters
    gravity = 0.2
    maxvel = 3
    chute_deployed = false  -- here false means “shorter balloon”
    chute_maxvel = -3      
    chute_lerp_factor = 0.05 
    xvel = 1                -- horizontal drifting parameters
    drift_lerp_factor = 0.1 
    margin = 10             
    function lerp(a, b, t) return a + (b - a) * t end
end

function _update()
    if (py > 128 - 2*(prad+1)) py = 128 - 2*(prad+1)
    if (py < 2*(prad+1)) py = 2*(prad+1)
    chute_deployed = false
    if (btn(4)) chute_deployed = true
    if not chute_deployed then
        yvel += gravity
        if (yvel > maxvel) yvel = maxvel
    else
        yvel = lerp(yvel, chute_maxvel, chute_lerp_factor)
    end
    py += yvel
    if (px < margin) then
        xvel = lerp(xvel, 1, drift_lerp_factor)
    elseif (px > 128 - margin) then
        xvel = lerp(xvel, -1, drift_lerp_factor)
    end
    px += xvel
    if (px < 0) then px = 0 end
    if (px > 128) then px = 128 end
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
