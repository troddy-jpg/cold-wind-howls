--STATE
act_update = nil
act_draw = nil

--TITLE SCREEN / MENU
game_title = "\^w\^tbatnado"
title_y = 32
selections = {
   "play",
   "highscore",
}
cur_sel = 1
--highscore defaults
score = 0
highscores={	
   0,0,0,0,0,0,0,0,0,0
}
last_highscore = -1

--GLOBALS
enemies = {}
enemies_maxhp = 6
col1,col2 = 7,0 						-- COLOR SELECTIONS
px, py, prad = 0, 10, 2			-- PLAYER POSITION, RADIUS
pflipx = false
yvel, xvel = 0, 0									-- y,x axis velocity
gravity = 0.2							-- value added to velocity
terminal_velocity = 3				-- maximum downward y axis velocity
chute_deployed = false				-- this is the bool for whether the player has a chute deployed. basically, this should almost always return the same value as btnp(4) or whatever is Z
chute_terminal_velocity = -3.5		-- max upward y axis velocity
chute_lerp_factor = 0.2				-- higher values make the character lighter
drawupdater = 0						-- goes from 0-60 wrapping. incremented every time draw() is called (USED ONLY IN GAME DRAW ATM)
spritechoice = 16						-- sprite choice for player sprite (USED FOR ANIMATING PLAYER SPRITE)
t=0
wallspr = 9
--knife
chargeTime, maxChargeTime = 0, 50
knifeX, knifeY = 10, 50
knifeDX, knifeDDX = 0, -0.3
knifeHeld, isCharging = true, false

--enemies: x, y, hp
function enemy_dies(e) 
   del(enemies, e) 
   spawn_some_particles(e.x+5,e.y+10)
end
function init_enemy()
   col1,col2=1,0
   enemies = {}
   for i=1,20 do 
      enemies[i]={
         x = 140 + rnd(500), y = 10 + rnd(82), hp=enemies_maxhp
      }
   end
end
function update_enemies()
   -- if (time() < 500) return
   local ecounter = 0

   for s in all(enemies) do
      ecounter += 1
      s.y = s.y + sin(time() * 0.25 + ecounter * 0.1)
      s.x = s.x - 2
      if s.x < -30 then s.x = 130 end -- change this to them dying

      --COLLISIONS
      -- check if colliding with knife
      local knifeHB = {
         knifeX-1, knifeY-1, knifeX+22, knifeY+5
      }
      local knifeCol = true -- knife collision
      if (s.x+16 < knifeHB[1]) knifeCol = false -- enemy left of knife
      if (s.x > knifeHB[3]) knifeCol = false    -- enemy right of knife
      if (s.y+16 < knifeHB[2]) knifeCol = false -- enemy above knife
      if (s.y > knifeHB[4]) knifeCol = false    -- enemy below knife
      if (knifeCol) s.hp -= 0.9 
      if (s.hp < 0) enemy_dies(s)
      -- check if colliding with player
      local playerCol = true --player collision
      local playerHB = {
         px+1, py+1, px+6, py+6
      }
      if (s.x+16 < playerHB[1]) playerCol = false -- enemy left of knife
      if (s.x > playerHB[3]) playerCol = false    -- enemy right of knife
      if (s.y+16 < playerHB[2]) playerCol = false -- enemy above knife
      if (s.y > playerHB[4]) playerCol = false    -- enemy below knife
      if (playerCol) init_gameover()
   end
end

function draw_enemies()
   foreach(enemies, function(s)
      -- spr( 3, s.x, s.y, 2, 2)
      spr( 7, s.x, s.y, 2, 2)
      line(s.x, s.y + 18, s.x + ((s.hp / 6) * 16), s.y + 18, 7)
   end)
end

--particles
pTables = {}
spawn_some_particles = function(x,y)
   for i=5,1,-1 do 
      add(pTables, {
         x + (rnd(4)-2),      --x
         y + (rnd(4)-2),      --y
         rnd(20) + 3,          --lifetime
         11                   --color     
      })
   end
end
update_particles = function()
   foreach(pTables, function(p)
      p[3] -= 1
      if (rnd(5) < 4) p[2] += rnd(2)
      if (rnd(10) < 3) p[1] += rnd(2)-1
      if (p[3] <= 0) del(pTables, p)
   end)
end
draw_particles = function()
   foreach(pTables, function(p)
      rrect(p[1], p[2], 2, 2, 1, p[4])
   end)
end


knife_charging = function()
   isCharging = true
   if (chargeTime < maxChargeTime) chargeTime += 1
end
knife_throw = function()
   isCharging = false
   knifeDX = (chargeTime / 10) + 3
   knifeHeld = false
end
knife_throwing = function() 
   knifeDX += knifeDDX
   knifeX += knifeDX
   if (knifeX<0) knifeX = 0
end
knife_caught = function()
   knifeX = px+16 
   knifeDX = 0 
   chargeTime = 0
   knifeHeld = true
end

function update_knife()
   if (knifeHeld) then
      knifeY=py
      if (btn(4)) knife_charging()
      if (isCharging and (not btn(4))) knife_throw()  
   end 
   if (not knifeHeld) knife_throwing()
   if (knifeX < px+16) and (abs(knifeY-py)<12) then 
      knife_caught() -- assuming dist_to_player < 'catch' range
   end
end

 --spr sheet x,y,w,h
bat_spr_a = {0,8,10,10}
bat_spr_b = {16,8,10,10}

function drawspr(spr,x,y,flip)
   sspr(spr[1],spr[2],spr[3],spr[4],x,y,spr[3],spr[4], flip, false)
end
-- draw_player(px,py,pflipx)

-- player
function draw_player()
	-- local spr1, spr2 = 1 , 2
	local spr1, spr2 = 16 , 34
	if (spritechoice == 16) drawspr(bat_spr_a,px,py,pflipx)
	if (spritechoice == 34) sspr(16, 8, 10, 10, px, py, 10, 10, pflipx, false)
	-- spr(spritechoice,px,py, 2, 2, pflipx, false)
	-- spr(spritechoice,px,py, 1, 1, pflipx, false)
	if chute_deployed then 
		if drawupdater % 2 == 0 then 
			--do chute sound
			sfx(0)
			if spritechoice == spr1 then 
				spritechoice = spr2 
			else
			spritechoice = spr1 
			end
		end 
	end
	--todo: circle that closes as you charge the knife, only closing when fully charged
	
end
function update_player()
	--y wrapping
	if (py>140) py=10
	if (py<-5) py=10
	--y movement
	chute_deployed = false
	if (btn(2)) chute_deployed=true
	if not chute_deployed then
	  yvel += gravity
	  if (yvel > terminal_velocity) yvel = terminal_velocity
	else
	  yvel -= gravity*1.3
	  if (yvel < chute_terminal_velocity) yvel = chute_terminal_velocity
	end
	py += yvel
	--x movement
	-- local goingLeft, goingRight = btn(0), btn(1)
	-- if goingLeft then
	-- 	xvel = lerp(xvel, -2, 0.3)
	-- 	pflipx = true
	-- end
	-- if goingRight then
	-- 	xvel = lerp(xvel, 2, 0.3)
	-- 	pflipx = false
	-- end
	-- if ((goingLeft and goingRight) or ((not goingLeft) and (not goingRight))) xvel = 0
	-- px += xvel
end


---------------------------
---------- tools ----------
---------------------------

function print_center(str, y, col)
    print(str, 64 - #str*4 / 2, y, col)
end

function outline_print(str, x, y, col, out_col, weight)
	weight = weight or 1
	for _x=-weight, weight do
		for _y=-weight, weight do
			print(str, x+_x, y+_y, out_col)
		end        
	end
	print(str, x, y, col)      
end

function wrap_int(int, min_i, max_i, add_i)
	if not add_i then add_i = 0 end
	local new_i = int+add_i
	if new_i < min_i then return max_i end  
	if new_i > max_i then return min_i end
	return new_i
end
--highscore helpers
function delete_hightscores()
	for i=1, #highscores do
		highscores[i]=0
		dset(i,0)
	end
end
function save_highscores()
	for i=1, #highscores do
		dset(i,highscores[i])
	end
	dset(#highscores+1,last_highscore)
end
function add_highscore(score)
	last_highscore = score
	for i=1, #highscores do
		local temp = highscores[i]
		if score > highscores[i] then
			highscores[i] = score
			score = temp
		end
	end
	save_highscores()
end
function lerp(a, b, t)-- A simple linear interpolation function
	return a + (b - a) * t
end