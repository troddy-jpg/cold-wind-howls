pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--main
cartdata(game_title)
function _init() 
	game_title = "cold-wind-blows"
	score = 0
    act_update = udpate_menu
    act_draw = draw_menu
	title_y = 32
	selections = {
		"play",
		"highscore",
	}
	cur_sel = 1
	--highscore things
	highscores={	
	0,0,0,0,0,0,0,0,0,0
	}
	last_highscore = -1
end
function _update() act_update() end
function _draw()
    cls()
    act_draw()
end

-->8
--main-menu
function udpate_menu()
    if btn(❎) then
        if cur_sel == 1 then
            init_game()
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
    outline_print(game_title, 64 - #game_title*4 / 2, title_y, 7, 5, 1)
    rectfill(32,title_y+7,98,title_y+7,7)
    rectfill(31,title_y+8,97,title_y+9,5)
    print("by Trevor", 24, title_y+14, 5)
    print("by Trevor", 23, title_y+13, 7)
    rectfill(73, title_y+12, 103, title_y+18, 8)
    print("1-bit jam #5", 75, title_y+13, 0)
	for i=1, #selections do
		local pre = "   "
		if cur_sel == i then pre="❎ " end
		print(pre..selections[i], 24, title_y+28+(i-1)*9, 11)
	end
end
-->8
--game state

init_game= function ()
	score = 0
    act_update = update_game
    act_draw = draw_game
end
update_game=function ()
	if btnp(❎) then 
        score += 1
    end
    if btnp(🅾️) then 
        add_highscore(score)
        _init()
    end
end
draw_game=function ()
	print_center("score: "..score, 64, 7)
    print("press: ❎ to score", 0, 0, 7)
    print("🅾️ to submit score & back", 0, 120, 10)
end

-->8
--highscore
init_highscore= function ()
	for i=1, #highscores do
		highscores[i]=dget(i)
	end
	last_highscore = dget(#highscores+1)
    act_update = update_highscore
    act_draw = draw_highscore
end
update_highscore = function ()
	if btnp(🅾️) then _init() end
end
draw_highscore = function ()
	print("highscores:", 0, 0, 7)
	for i=1, #highscores do 
		print(""..highscores[i], 4, 12 + (i-1)*7, 7);
	end 
	print("back to menu 🅾️", 4, 123, 7);
end


---------------------------
---------- tools ----------
---------------------------

function print_center(str, y, col)
    print(str, 64 - #str*4 / 2, y, col)
end

function outline_print(str, x, y, col, out_col, weight)
    if not weight then weight = 1 end 
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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
