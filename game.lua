function init_game ()
	score = 0
   init_enemy()
	act_update = update_game
	act_draw = draw_game 
end
function update_game ()
   update_particles()
	--knife
   if (knife_held) then
      knife_y=py
      if (btn(4)) knife_charging()
      if (is_charging and (not btn(4))) knife_throw()  
   end 
   if (not knife_held) knife_throwing()
   if (knife_x < px+16) and (abs(knife_y-py)<12) then 
      knife_caught() -- assuming dist_to_player < 'catch' range
   end

	--update rain
	-- update_rain()()
	update_enemies()
	update_player()
end
function draw_game()
	draw_particles()
	drawupdater += 1
	if drawupdater > 60  then drawupdater = 0 end
	-- rain.drawr()
	draw_enemies()
	draw_player()
	--knife	
   print("knife", knife_x, knife_y, 7)

	--draw left wall 
	-- for i=0,16,1 do 
	-- 	if ((drawupdater+i)%7 == 0) wallspr=11
	-- 	if ((drawupdater+i)%5 == 0) wallspr=10
	-- 	if ((drawupdater+i)%3 == 0) wallspr=9
	-- 	spr(wallspr, 0, i*8)
	-- end
end

-- main menu state
function init_menu()
	score=0
	cur_sel = 1
	act_update = udpate_menu
	act_draw = draw_menu
end
function udpate_menu()
    if btn(❎) then
        if cur_sel == 1 then
            init_intro()
        end
        if cur_sel == 2 then
            init_highscore()
        end
    end
    if btnp(⬆️) then cur_sel = wrap_int(cur_sel, 1, 2, 1) end
    if btnp(⬇️) then cur_sel = wrap_int(cur_sel, 1, 2, -1) end
end
function draw_menu()
    rect(0,0,127,127,1)
   --  outline_print(game_title, 64 - #game_title*4 / 2, title_y, 7, 5, 3) -- for standard title text
	outline_print(game_title, 64 - (#game_title*4-15), title_y, 7, 5, 3) -- for double w, h title text
	for i=1, #selections do
		local pre = "   "
		if cur_sel == i then pre="❎ " end
		print(pre..selections[i], 24, title_y+28+(i-1)*9, 11)
	end
end

-- intro state
function init_intro()
   -- on screen:
      -- bat
      -- "press UP to fly"
      -- "press Z to stab"
      -- enemies should NOT be initialised or updating 
	act_update = update_intro
	act_draw = draw_intro
end
function update_intro()
   -- should switch to game state if UP or Z are pressed.
	if btnp(2) or btnp(4) then
		init_game()
	end
end
function draw_intro()
	draw_player()
   print_center("press UP to fly",20,13)
   print_center("press Z to stab",70,13)
end

-- highscore state
function init_highscore()
	for i=1, #highscores do
		highscores[i]=dget(i)
	end
	last_highscore = dget(#highscores+1)
    act_update = update_highscore
    act_draw = draw_highscore
end
function update_highscore()
	if btnp(🅾️) then init_menu() end
end
function draw_highscore()
	print("highscores:", 0, 0, 7)
	for i=1, #highscores do 
		print(""..highscores[i], 4, 12 + (i-1)*7, 7);
	end 
	print("back to menu 🅾️", 4, 123, 7);
end