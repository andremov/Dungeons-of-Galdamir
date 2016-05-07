-----------------------------------------------------------------------------------------
--
-- Tutorial.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local EnergyPadsheet = graphics.newImageSheet("tiles/0/epad.png",{ width=80, height=80, numFrames=30})
local HealPadsheet = graphics.newImageSheet("tiles/0/hpad.png",{ width=80, height=80, numFrames=30})
local ManaPadsheet = graphics.newImageSheet("tiles/0/mpad.png",{ width=80, height=80, numFrames=30})
local watersheet = graphics.newImageSheet("tiles/0/water.png",{ width=80, height=80, numFrames=30})
local heartnsheet = graphics.newImageSheet("heartemptysprite.png",{ width=25, height=25, numFrames=16})
local lavasheet = graphics.newImageSheet("tiles/0/lava.png",{ width=80, height=80, numFrames=20})
local coinsheet = graphics.newImageSheet( "coinsprite.png", { width=32, height=32, numFrames=8 } )
local energysheet = graphics.newImageSheet("energysprite.png",{ width=60, height=60, numFrames=4})
local dexatt3 = graphics.newImageSheet( "enemy/dexatt3.png",{ width=32, height=33, numFrames=24 })
local heartsheet = graphics.newImageSheet("heartsprite.png",{ width=25, height=25, numFrames=16})
local player1 = graphics.newImageSheet( "player/0.png", { width=39, height=46, numFrames=25 } )
local timersheet = graphics.newImageSheet( "timer.png",{ width=100, height=100, numFrames=25 })
local manasheet = graphics.newImageSheet("manasprite.png",{ width=60, height=60, numFrames=3})
local xpsheet = graphics.newImageSheet("xpbar.png",{ width=392, height=40, numFrames=50})
local hpsheet = graphics.newImageSheet("hp.png",{ width=200, height=30, numFrames=67 })
local mpsheet = graphics.newImageSheet("mp.png",{ width=200, height=30, numFrames=67 })
local epsheet = graphics.newImageSheet("ep.png",{ width=200, height=30, numFrames=67 })
local p=require("Lplayers")
local mh=require("Lmaphandler")
local physics = require "physics"
local widget = require "widget"
local menu = require ("Lmenu")
local interfaceb
local Narrator={}
local Progress
local Function
local eHits={}
local pHits={}

function FromTheTop()
	Function={
		One,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Eleven,Twelve,Thirteen,Fourteen,Fifteen,Sixteen,Seventeen,
		Eighteen,Nineteen,Twenty,TwentyOne,TwentyTwo,TwentyThree,TwentyFour,TwentyFive,TwentySix,TwentySeven,
		TwentyEight,TwentyNine,Thirty,ThirtyOne,ThirtyTwo,ThirtyThree,ThirtyFour,ThirtyFive,ThirtySix,ThirtySeven,
		ThirtyEight,ThirtyNine,Forty,FortyOne,FortyTwo,FortyThree,FortyFour,FortyFive,FortySix,FortySeven,FortyEight,
		FortyNine,Fifty,FiftyOne,FiftyTwo,FiftyThree,FiftyFour,FiftyFive,FiftySix,FiftySeven,FiftyEight,FiftyNine,
		Sixty,SixtyOne,SixtyTwo,SixtyThree,SixtyFour,SixtyFive
	}
	Progress=0
	timer.performWithDelay(500,Continue)
end

function Continue()
	Runtime:removeEventListener("tap",Continue)
	for n=table.maxn(Narrator),1,-1 do
		display.remove(Narrator[n])
		Narrator[n]=nil
	end
	Progress=Progress+1
	timer.performWithDelay(100,Function[Progress])
end

function One()
	Narrator[1]=display.newText("Hey!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Hello?",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function Two()
	Narrator[1]=display.newText("Can you hear me?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Do you comprehend basic interactions?",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function Essentials()
	Level=display.newGroup()
	boundary={}
	mbounds={}
	walls={}
	map2={}
	map={}
	TSet=0
end

function BuildMap()
	if not(count)then
		Essentials()
		count=0
	end
	mh.CallingZones()
	map=mh.GetCMap(-1)
	mapsize=table.maxn( map )
	
	BuildTile()
	
	BuildTile()
	
	BuildTile()
	
	BuildTile()
	
	BuildTile()
	
	if count<mapsize+1 then
		timer.performWithDelay(0.2,BuildMap)
	else
		count=0
		DisplayMap()
	end
end

function DisplayMap()
	
	DisplayTile()
	
	DisplayTile()
	
	DisplayTile()
	
	DisplayTile()
	
	DisplayTile()
	
	if count~=mapsize then
		timer.performWithDelay(0.2,DisplayMap)
	else
	end
end

function BuildTile()

	count=count+1
	
	if count~=mapsize+1 and not(map2[count]) then
	
		if(map[count]=="b")then
			boundary[count]=0
			mbounds[count]=0
			map2[count]="b"
		end
		
		if(map[count]=="d")then
			local canitbreak=math.random(1,10)
			if canitbreak>=7 then
				boundary[count]=1
				mbounds[count]=0
				map2[count]="q"
			else
				boundary[count]=0
				mbounds[count]=0
				map2[count]="o"
			end
		end	
		
		if(map[count]=="h")then
			mbounds[count]=1
			boundary[count]=1
			map2[count]="h"
		end
		
		if(map[count]=="i")then
			mbounds[count]=1
			boundary[count]=1
			map2[count]="i"
		end
		
		if(map[count]=="j")then
			mbounds[count]=1
			boundary[count]=1
			map2[count]="j"
		end
		
		if(map[count]=="k")then
			boundary[count]=1
			map2[i]="k"
			mbounds[i]=0
		end

		if(map[count]=="l")then
			mbounds[count]=0
			boundary[count]=1
			map2[count]="l"
		end	
		
		if(map[count]=="m")then
			boundary[count]=1
			mbounds[count]=1
			map2[count]="m"
		end
		
		if(map[count]=="n")then
			boundary[count]=1
			mbounds[count]=1
			map2[count]="n"
		end
	
		if(map[count]=="�")then
			boundary[count]=1
			mbounds[count]=1
			map2[count]="�"
		end
		
		if(map[count]=="o")then
			boundary[count]=0
			mbounds[count]=0
			map2[count]="o"
		end
		
		if(map[count]=="q")then
			boundary[count]=1
			mbounds[count]=0
			map2[count]="q"
		end	
		
		if(map[count]=="s")then
			boundary[count]=1
			mbounds[count]=1
			map2[count]="s"
		end
		
		if(map[count]=="t")then
			mbounds[count]=1
			boundary[count]=1
			map2[count]="t"
		end
	
		if(map[count]=="u") then
			boundary[count]=1
			mbounds[count]=1
			map2[count]="u"
		end
		
		if(map[count]=="w")then
			boundary[count]=0
			mbounds[count]=0
			map2[count]="w"
		end
		
		if(map[count]=="x")then
			mbounds[count]=1
			boundary[count]=1
			map2[count]="x"
		end
		
		if(map[count]=="#")then
			mbounds[count]=0
			boundary[count]=0
			map2[count]="#"
		end
		
		if(map[count]=="z")then
			mbounds[count]=0
			boundary[count]=1
			map2[count]="z"
		end
	end
end

function DisplayTile()
	count=count+1
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	
	if count~=mapsize+1 then
	
		if(map2[count]=="b")then
			local roll=math.random(1,18)
			if roll<=9 then
				roll=1
			elseif roll<=15 then
				roll=2
			elseif roll<=18 then
				roll=3
			end
			walls[count]=display.newImageRect( "tiles/"..TSet.."/wall"..(roll)..".png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
		end
		
		if(map2[count]=="h")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			HP=walls[count]
			HP=display.newSprite( HealPadsheet, { name="HP", start=1, count=30, time=2000 }  )
			HP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			HP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			HP.isVisible=false
			HP.loc=(count)
			HP:play()
			Level:insert( HP )
		end
		
		if(map2[count]=="i")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			EP=walls[count]
			EP=display.newSprite( EnergyPadsheet, { name="EP", start=1, count=30, time=2000 }  )
			EP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			EP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			EP.isVisible=false
			EP.loc=(count)
			EP:play()
			Level:insert( EP )
		end
		
		if(map2[count]=="j")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			MP=walls[count]
			MP=display.newSprite( ManaPadsheet, { name="MP", start=1, count=30, time=2000 }  )
			MP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			MP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			MP.isVisible=false
			MP.loc=(count)
			MP:play()
			Level:insert( MP )
		end
		
		if(map2[count]=="k")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			SmallKey=display.newImageRect( "tiles/"..TSet.."/smallkey.png", 80, 80)
			SmallKey.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			SmallKey.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			SmallKey.isVisible=false
			SmallKey.loc=(i)
			Level:insert( SmallKey )
		end
		
		if(map2[count]=="l")then
			walls[count]=walls[count]
			walls[count]=display.newSprite( lavasheet, { name="lava", start=1, count=20, time=4000 }  )
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			walls[count]:play()
			Level:insert( walls[count] )
		end	
		
		if(map2[count]=="m")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			OP=display.newSprite( portalsheet, { name="portal", start=1, count=20, time=1750 }  )
			OP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			OP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			OP.isVisible=false
			OP:play()
			OP.loc=(count)
			Level:insert( OP )
		end
		
		if(map2[count]=="n")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			BP=display.newSprite( portalbacksheet, { name="portalback", start=1, count=20, time=1750 }  )
			BP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			BP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			BP.isVisible=false
			BP:play()
			BP.loc=(count)
			Level:insert( BP )
		end
	
		if(map2[count]=="�")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			RP=display.newSprite( portalredsheet, { name="portalred", start=1, count=20, time=1750 }  )
			RP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			RP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			RP.isVisible=false
			RP:play()
			RP.loc=(count)
			Level:insert( RP )
		end
	
		if(map2[count]=="o")then
			local roll=math.random(1,18)
			if roll<=9 then
				roll=1
			elseif roll<=15 then
				roll=2
			elseif roll<=18 then
				roll=3
			end
			walls[count]=display.newImageRect( "tiles/"..TSet.."/wall"..(roll)..".png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
		end
		
		if(map2[count]=="q")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert(  walls[count] )
			
			Destructibles[count]=display.newSprite(rockbreaksheet,{name="rock",start=1,count=14,time=400,loopCount=1})
			Destructibles[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			Destructibles[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			Destructibles[count].isVisible=false
			Destructibles[count].exist=true
			Level:insert( Destructibles[count] )
		end
		
		if(map2[count]=="s")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			Shops[count]=display.newImageRect( "tiles/"..TSet.."/shop.png", 80, 80)
			Shops[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			Shops[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			Shops[count].isVisible=false
			Level:insert(Shops[count])
		end
		
		if(map2[count]=="t")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			Chests[count]=walls[count]
			Chests[count]=display.newImageRect( "tiles/"..TSet.."/treasure.png", 80, 80)
			Chests[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			Chests[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			Chests[count].isVisible=false
			Level:insert( Chests[count] )
		end
		
		if(map2[count]=="u") then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			MS=display.newSprite( spawnersheet, { name="mobspawner", start=1, count=20, time=1750 }  )
			MS.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			MS.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			MS.isVisible=false
			MS:play()
			MS.loc=(count)
			Level:insert( MS )
		end
		
		if(map2[count]=="w")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			Water=display.newSprite( watersheet, { name="water", start=1, count=30, time=3000 }  )
			Water.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			Water.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			Water.isVisible=false
			Water.loc=count
			Water:play()
			Level:insert( Water )
		end
		
		if(map2[count]=="x")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
		end	
		
		if(map2[count]=="#")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			walls[count].isVisible=false
			Level:insert( walls[count] )
			
			Gate=display.newImageRect( "tiles/"..TSet.."/jail.png", 80, 80)
			Gate.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			Gate.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			Gate.isVisible=false
			Gate.loc=(count)
			Level:insert( Gate )
		end	
		
		if(map2[count]=="z")then
			finish=display.newImageRect( "tiles/"..TSet.."/stairup.png", 80, 80)
			finish.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espaciox)
			finish.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacioy)
			finish.isVisible=false
			finish.loc=(count)
			Level:insert( finish )
		end
		
	end
end

function Show(id)
	if (walls[id]) then
		walls[id].isVisible=true
	end
	if (finish) then
		if (finish.loc==id) then
			finish.isVisible=true
		end
	end
	if (HP) then
		if (HP.loc==id) then
			HP.isVisible=true
		end
	end
	if (Water) then
		if (Water.loc==id) then
			Water.isVisible=true
		end
	end
	if (EP) then
		if (EP.loc==id) then
			EP.isVisible=true
		end
	end
	if (MP) then
		if (MP.loc==id) then
			MP.isVisible=true
		end
	end
	if (Gate) then
		if (Gate.loc==id) then
			Gate.isVisible=true
		end
	end
	if (Mob) then
		if (Mob.loc==id) then
			Mob.isVisible=true
		end
	end
	if (Chest) then
		if (Chest.loc==id) then
			Chest.isVisible=true
		end
	end
end

function ShowTiles(value)
	local loc
	if not (value) then
		loc=math.sqrt(mapsize)+2
	else 
		loc=value
	end
	Show(loc)
	for x=1,3 do
		for y=1,3 do
			Show(loc+(x-2)+((y-2)*math.sqrt(mapsize)))
		end
	end
end

function Three()
	BuildMap()
	
	Narrator[1]=display.newText("Let me just...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function Four()
	ShowTiles()
	
	Narrator[1]=display.newText("There we go.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Woah.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function Five()
	Narrator[1]=display.newText("Where are you?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Maybe I should ask if you even exist first.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function CPlayer()
	--Visual
	player=display.newImageRect( "chars/0/char.png", 76 ,76)
	player.x, player.y = display.contentWidth/2, display.contentHeight/2
	player:setStrokeColor(180, 180, 180)
	player.strokeWidth = 4
	--Secondary Stats
	player.MaxHP=100
	player.HP=player.MaxHP
	player.MaxMP=10
	player.MP=player.MaxMP
	player.MaxEP=10
	player.EP=player.MaxEP
	player.SPD=10
	player.loc=math.sqrt(mapsize)+2
	--
	if (player) then
		check=119
		Runtime:addEventListener("enterFrame",ShowStats)
	end
end

function StatCheck()
	player.SPD=10
	player.MaxHP=100
	player.MaxMP=10
	player.MaxEP=10
	if player.HP>player.MaxHP then
		player.HP=player.MaxHP
	end
	if player.MP>player.MaxMP then
		player.MP=player.MaxMP
	end
	if player.EP>player.MaxEP then
		player.EP=player.MaxEP
	end
end

function ShowStats()
	check=check+1
	if check==120 then
		StatCheck()
		check=-1
	end
	
-- Life
	if not(LifeDisplay) then
		transp=0
		
		LifeDisplay = display.newText( (player.HP.."/"..player.MaxHP), 0, 0, "Game Over", 100 )
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeDisplay.x = 160
		LifeDisplay.y = 35
		
		LifeWindow = display.newRect (0,0,#LifeDisplay.text*22,40)
		LifeWindow:setFillColor( 150, 150, 150,transp/2)
		LifeWindow.x=LifeDisplay.x
		LifeWindow.y=LifeDisplay.y+5
		
		LifeDisplay:toFront()
	end
	if not(LifeSymbol) then
		LifeSymbol=display.newSprite( heartsheet, {name="heart",start=1,count=16,time=(1800)} )
		LifeSymbol.yScale=3.75
		LifeSymbol.xScale=3.75
		LifeSymbol.x = 50
		LifeSymbol.y = 40
		LifeSymbol:play()
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
	
	if ((player.HP.."/"..player.MaxHP))~=LifeDisplay.text or StrongForce==true then
		transp=255
		LifeDisplay.text=((player.HP.."/"..player.MaxHP))
		
		display.remove(LifeWindow)
		LifeWindow = display.newRect (0,0,#LifeDisplay.text*22,40)
		LifeWindow:setFillColor( 150, 150, 150,transp/2)
		LifeWindow.x=LifeDisplay.x
		LifeWindow.y=LifeDisplay.y+5
		
		LifeDisplay:toFront()
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	elseif ((player.HP.."/"..player.MaxHP))==LifeDisplay.text and transp~=0 and player.HP==player.MaxHP and StrongForce~=true then
		transp=transp-(255/50)
		if transp<20 then
			transp=0
		end
		LifeWindow:setFillColor( 150, 150, 150,transp/2)
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
	
	if player.HP==0 then
		display.remove(LifeSymbol)
		LifeSymbol=display.newSprite( heartnsheet, { name="heart", start=1, count=16, time=(1800) }  )
		LifeSymbol.yScale=3.75
		LifeSymbol.xScale=3.75
		LifeSymbol.x = 50
		LifeSymbol.y = display.contentHeight-170
		LifeSymbol:play()
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
	
-- Mana
	if not(ManaDisplay) then
		transp3=0
		
		ManaDisplay = display.newText( (player.MP.."/"..player.MaxMP), 0, 0, "Game Over", 100 )
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaDisplay.x = LifeDisplay.x
		ManaDisplay.y = LifeDisplay.y+60
		
		ManaWindow = display.newRect (0,0,#ManaDisplay.text*22,40)
		ManaWindow:setFillColor( 150, 150, 150,transp3/2)
		ManaWindow.x=ManaDisplay.x
		ManaWindow.y=ManaDisplay.y+5
		
		ManaDisplay:toFront()
	end
	if not (ManaSymbol) then
		ManaSymbol=display.newSprite( manasheet, {name="mana",start=1,count=3,time=500} )
		ManaSymbol.yScale=1.0625
		ManaSymbol.xScale=1.0625
		ManaSymbol.x = LifeSymbol.x
		ManaSymbol.y = LifeSymbol.y+60
		ManaSymbol:play()
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
	end
	
	if ((player.MP.."/"..player.MaxMP))~=ManaDisplay.text or StrongForce==true then
		transp3=255
		ManaDisplay.text=((player.MP.."/"..player.MaxMP))
		
		display.remove(ManaWindow)
		ManaWindow = display.newRect (0,0,#ManaDisplay.text*22,40)
		ManaWindow:setFillColor( 150, 150, 150,transp3/2)
		ManaWindow.x=ManaDisplay.x
		ManaWindow.y=ManaDisplay.y+5
		
		ManaDisplay:toFront()
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
	elseif ((player.MP.."/"..player.MaxMP))==ManaDisplay.text and transp3~=0 and player.MP==player.MaxMP and StrongForce~=true then
		transp3=transp3-(255/50)
		if transp3<20 then
			transp3=0
		end
		ManaWindow:setFillColor( 150, 150, 150,transp3/2)
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
	end
	
-- Energy
	if not(EnergyDisplay) then
		transp5=0
		EnergyDisplay = display.newText( (player.EP.."/"..player.MaxEP), 0, 0, "Game Over", 100 )
		EnergyDisplay:setTextColor( 255, 255, 255,transp5)
		EnergyDisplay.x = ManaDisplay.x
		EnergyDisplay.y = ManaDisplay.y+60
		
		EnergyWindow = display.newRect (0,0,#EnergyDisplay.text*22,40)
		EnergyWindow:setFillColor( 150, 150, 150,transp5/2)
		EnergyWindow.x=EnergyDisplay.x
		EnergyWindow.y=EnergyDisplay.y+5
		
		EnergyDisplay:toFront()
	end
	
	if not (EnergySymbol) then
		EnergySymbol=display.newSprite( energysheet, {name="energy",start=1,count=4,time=500} )
		EnergySymbol.yScale=1.0625
		EnergySymbol.xScale=1.0625
		EnergySymbol.x = ManaSymbol.x
		EnergySymbol.y = ManaSymbol.y+60
		EnergySymbol:play()
		EnergySymbol:setFillColor(transp5,transp5,transp5,transp5)
	end
	
	if ((player.EP.."/"..player.MaxEP))~=EnergyDisplay.text or StrongForce==true then
		transp5=255
		EnergyDisplay.text=((player.EP.."/"..player.MaxEP))
		
		display.remove(EnergyWindow)
		EnergyWindow = display.newRect (0,0,#EnergyDisplay.text*22,40)
		EnergyWindow:setFillColor( 150, 150, 150,transp5/2)
		EnergyWindow.x=EnergyDisplay.x
		EnergyWindow.y=EnergyDisplay.y+5
		
		EnergyDisplay:toFront()
		EnergyDisplay:setTextColor( 255, 255, 255,transp5)
		EnergySymbol:setFillColor(transp5,transp5,transp5,transp5)
	elseif ((player.EP.."/"..player.MaxEP))==EnergyDisplay.text and transp5~=0 and player.EP==player.MaxEP and StrongForce~=true then
		transp5=transp5-(255/50)
		if transp5<20 then
			transp5=0
		end
		EnergyWindow:setFillColor( 150, 150, 150,transp5/2)
		EnergyDisplay:setTextColor( 255, 255, 255,transp5)
		EnergySymbol:setFillColor(transp5,transp5,transp5,transp5)
	end
end

function LetsYodaIt()
	if StrongForce~=true then
		StrongForce=true
	else
		StrongForce=false
	end
end

function Six()
	CPlayer()
	
	Narrator[1]=display.newText("Finally!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("He appears!",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250

	Runtime:addEventListener("tap",Continue)
end

function Seven()
	Narrator[1]=display.newText("Are you fine?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("That magic trick you did didn't look safe.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250

	Runtime:addEventListener("tap",Continue)
end

function ShowArrows(value)
	local espaciox=80
	local espacioy=80
	local yinicial=display.contentHeight/2
	local xinicial=display.contentWidth/2
	if value=="clean" then
		display.remove(mup)
		display.remove(mdown)
		display.remove(mleft)
		display.remove(mright)
		display.remove(inter)
	else
		ShowTiles(player.loc)
		CanMoveDown=true
		CanMoveLeft=true
		CanMoveUp=true
		CanMoveRight=true
		CanAttackRight=false
		local size=mapsize
		local p1=player
		col=((p1.loc)%math.sqrt(size))
		row=(math.floor((p1.loc)/math.sqrt(size)))
		
		display.remove(mup)
		display.remove(mleft)
		display.remove(mdown)
		display.remove(mright)
		display.remove(inter)
		
		--Boundary Checks
		if (row+1)==2 then
			CanMoveUp=false
		end
		
		if (row+1)==(math.sqrt(size)-1) then
			CanMoveDown=false
		end
		
		if col==2 then
			CanMoveLeft=false
		end
		
		if col==(math.sqrt(size)-1) then
			CanMoveRight=false
		end
		-- Mob Check
		if (Mob) and Progress<40 then
			if p1.loc+1==Mob.loc then
				CanMoveRight=false
				CanAttackRight=true
			end
		end
		
		--Wall Collision Checks
		if boundary[p1.loc-math.sqrt(size)]==0 then
			CanMoveUp=false
		end
		
		if boundary[p1.loc+math.sqrt(size)]==0 then
			CanMoveDown=false
		end
		
		if boundary[p1.loc-1]==0 then
			CanMoveLeft=false
		end
		
		if boundary[p1.loc+1]==0 then
			CanAttackRight=false
			CanMoveRight=false
		end
		
		--Movement Arrow Creation
		
		if CanMoveUp==true then
			mup=display.newImageRect("moveu.png",80,80)
			mup.x=xinicial
			mup.y=yinicial-espaciox
			mup:toFront()
			mup:addEventListener( "tap",moveplayerup)
		end

		if CanMoveDown==true then
			mdown=display.newImageRect("moved.png",80,80)
			mdown.x=xinicial
			mdown.y=yinicial+espacioy
			mdown:toFront()
			mdown:addEventListener( "tap",moveplayerdown)
		end
		
		if CanMoveLeft==true then
			mleft=display.newImageRect("movel.png",80,80)
			mleft.x=xinicial-espaciox
			mleft.y=yinicial
			mleft:toFront()
			mleft:addEventListener( "tap",moveplayerleft)
		end
		
		if CanAttackRight==true then
			mright=display.newImageRect("interact1.png",80,80)
			mright.x=xinicial+espaciox
			mright.y=yinicial
			mright:toFront()
			mright:addEventListener( "tap",Combat)
		elseif CanMoveRight==true then
			mright=display.newImageRect("mover.png",80,80)
			mright.x=xinicial+espaciox
			mright.y=yinicial
			mright:toFront()
			mright:addEventListener( "tap",moveplayerright)
		end
		
	end
end

function moveplayerup( event )
	Level.y=Level.y+80
	player.loc=player.loc-math.sqrt(mapsize)
	ShowArrows()
	MoveProgress()
end

function moveplayerdown( event )
	Level.y=Level.y-80
	player.loc=player.loc+math.sqrt(mapsize)
	ShowArrows()
	MoveProgress()
end	

function moveplayerleft( event )
	Level.x=Level.x+80
	player.loc=player.loc-1
	ShowArrows()
	MoveProgress()
end	

function moveplayerright( event )
	Level.x=Level.x-80
	player.loc=player.loc+1
	ShowArrows()
	MoveProgress()
end

function MoveProgress()
	if Progress==8 then
		Continue()
	elseif Progress==9 and player.loc==15 then
		Continue()
	elseif player.loc==16 then
		Burning()
		Continue()
	elseif player.loc==17 and Progress==11 then
		Continue()
	elseif Progress==12 then
		Continue()
	elseif player.loc==29 then
		Healing()
		Continue()
	elseif Progress==15 then
		Continue()
	elseif player.loc==35 then
		Continue()
	elseif player.loc==62 and Progress==17 then
		Continue()
	elseif player.loc==42 and Progress==18 then
		Continue()
	elseif player.loc==33 and Progress==46 then
		Continue()
	elseif player.loc==62 and Progress==45 then
		Continue()
	elseif player.loc==62 and Progress==47 then
		Continue()
	elseif player.loc==82 and Progress==48 then
		Continue()
	elseif player.loc==84 and Progress==49 then
		Continue()
	elseif player.loc==86 and Progress==52 then
		Continue()
	elseif player.loc==67 and Progress==53 then
		Continue()
	elseif player.loc==57 and Progress==54 then
		Continue()
		Healing()
	elseif player.loc==57 and Progress==55 then
		Healing()
	elseif player.loc==58 and Progress==55 then
		Healing()
	elseif player.loc==59 and Progress==55 then
		Healing()
	elseif player.loc==89 and Progress==55 then
		Continue()
	end
end

function Eight()
	ShowArrows()
	
	Narrator[1]=display.newText("Can you move?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Y'know, like any other normal human being.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Use the arrows to move",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Nine()
	
	Narrator[1]=display.newText("Can you talk?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("I feel like I'm talking to a toddler.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Ten()
	Narrator[1]=display.newText("Guessing that's a no.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("That's lava. Lava is bad. Stay away from it.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Walk on the lava",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Burning()
	if player.loc==16 and player.HP>1 then
		player.HP=player.HP-1
		timer.performWithDelay(250,Burning)
	end
end

function Eleven()
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	map2[15]="o"
	boundary[15]=0
	mbounds[15]=0
	display.remove(walls[15])
	walls[15]=display.newImageRect( "tiles/0/wall1.png", 80, 80)
	walls[15].x=xinicial+((((15-1)%math.sqrt(mapsize)))*espaciox)--+Level.x
	walls[15].y=yinicial+(math.floor((15-1)/math.sqrt(mapsize))*espacioy)--+Level.y
	walls[15].isVisible=true
	Level:insert( walls[15] )
	
	Fog()
	ShowTiles(player.loc)
	ShowArrows()
	
	Narrator[1]=display.newText("Can you even hear me?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Or are you willingly doing these idiotic things?",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Get off the lava",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Fog()
	for i=1,mapsize do
		if (walls[i]) then
			walls[i].isVisible=false
		end
	end
	if (finish) then
		finish.isVisible=false
	end
	if (HP) then
		HP.isVisible=false
	end
	if (MP) then
		MP.isVisible=false
	end
	if (EP) then
		EP.isVisible=false
	end
	if (Water) then
		Water.isVisible=false
	end
	if (Gate) then
		Gate.isVisible=false
	end
	if (Mob) then
		Mob.isVisible=false
	end
end

function Twelve()
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	map2[16]="o"
	boundary[16]=0
	mbounds[16]=0
	display.remove(walls[16])
	walls[16]=display.newImageRect( "tiles/0/wall1.png", 80, 80)
	walls[16].x=xinicial+((((16-1)%math.sqrt(mapsize)))*espaciox)--+Level.x
	walls[16].y=yinicial+(math.floor((16-1)/math.sqrt(mapsize))*espacioy)--+Level.y
	walls[16].isVisible=true
	Level:insert( walls[16] )
	
	Fog()
	ShowTiles(player.loc)
	ShowArrows()
	
	Narrator[1]=display.newText("You know your feet?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("They're scorched.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Thirteen()
	Narrator[1]=display.newText("Where is that healing pad?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Come on now, follow me.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Heal yourself on the healing pad",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-190
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Healing()
	if player.loc==29 and player.HP<player.MaxHP then
		player.HP=player.HP+1
		timer.performWithDelay(250,Healing)
	elseif player.loc==29 and Progress==14 and player.HP==player.MaxHP then
		Continue()
	elseif player.loc==57 and Progress==55 and player.HP<player.MaxHP then
		player.HP=player.HP+1
		timer.performWithDelay(250,Healing)
	elseif player.loc==58 and Progress==55 and player.MP<player.MaxMP then
		player.MP=player.MP+1
		timer.performWithDelay(250,Healing)
	elseif player.loc==59 and Progress==55 and player.EP<player.MaxEP then
		player.EP=player.EP+1
		timer.performWithDelay(250,Healing)
	end
end

function Fourteen()
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	map2[19]="o"
	boundary[19]=0
	mbounds[19]=0
	display.remove(walls[19])
	walls[19]=display.newImageRect( "tiles/0/wall1.png", 80, 80)
	walls[19].x=xinicial+((((19-1)%math.sqrt(mapsize)))*espaciox)--+Level.x
	walls[19].y=yinicial+(math.floor((19-1)/math.sqrt(mapsize))*espacioy)--+Level.y
	walls[19].isVisible=true
	Level:insert( walls[19] )
	
	map2[18]="o"
	boundary[18]=0
	mbounds[18]=0
	display.remove(walls[18])
	walls[18]=display.newImageRect( "tiles/0/wall1.png", 80, 80)
	walls[18].x=xinicial+((((18-1)%math.sqrt(mapsize)))*espaciox)--+Level.x
	walls[18].y=yinicial+(math.floor((18-1)/math.sqrt(mapsize))*espacioy)--+Level.y
	walls[18].isVisible=true
	Level:insert( walls[18] )
	
	Fog()
	ShowTiles(player.loc)
	ShowArrows()
	
	Narrator[1]=display.newText("Yes, better for you to follow me.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Remember what happened when you lead?",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Because you burnt your feet.",0, 0,"MoolBoran",40)
	Narrator[3].x=display.contentCenterX
	Narrator[3].y=Narrator[2].y+45
	
	Narrator[4]=display.newText("Wait for your wounds to heal",0, 0,"MoolBoran",40)
	Narrator[4]:setTextColor(70,255,70)
	Narrator[4].x=display.contentWidth-170
	Narrator[4].y=display.contentHeight-40
	
	Narrator[5]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[5]:setTextColor(255,255,70)
	Narrator[5].x=120
	Narrator[5].y=display.contentHeight-250
end

function Fifteen()
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	map2[39]="x"
	boundary[39]=1
	mbounds[39]=1
	display.remove(walls[39])
	walls[39]=display.newImageRect( "tiles/0/walkable.png", 80, 80)
	walls[39].x=xinicial+((((39-1)%math.sqrt(mapsize)))*espaciox)--+Level.x
	walls[39].y=yinicial+(math.floor((39-1)/math.sqrt(mapsize))*espacioy)--+Level.y
	walls[39].isVisible=true
	Level:insert( walls[39] )
	
	map2[38]="x"
	boundary[38]=1
	mbounds[38]=1
	display.remove(walls[38])
	walls[38]=display.newImageRect( "tiles/0/walkable.png", 80, 80)
	walls[38].x=xinicial+((((38-1)%math.sqrt(mapsize)))*espaciox)--+Level.x
	walls[38].y=yinicial+(math.floor((38-1)/math.sqrt(mapsize))*espacioy)--+Level.y
	walls[38].isVisible=true
	Level:insert( walls[38] )
	
	ShowTiles(player.loc)
	ShowArrows()
	Narrator[1]=display.newText("Finally!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("You're all healed up!",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Sixteen()
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	map2[29]="o"
	boundary[29]=0
	mbounds[29]=0
	display.remove(walls[29])
	walls[29]=display.newImageRect( "tiles/0/wall1.png", 80, 80)
	walls[29].x=xinicial+((((29-1)%math.sqrt(mapsize)))*espaciox)
	walls[29].y=yinicial+(math.floor((29-1)/math.sqrt(mapsize))*espacioy)
	walls[29].isVisible=true
	Level:insert( walls[29] )
	display.remove(HP)
	HP.loc=nil
	HP=nil
	
	Fog()
	ShowTiles(player.loc)
	ShowArrows()
	
	Narrator[1]=display.newText("Now that I think about it...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("You shouldn't have survived that.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Seventeen()
	Narrator[1]=display.newText("There should be a guard nearby.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Knock him out and I'll help you escape.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Deal?",0, 0,"MoolBoran",40)
	Narrator[3].x=display.contentCenterX
	Narrator[3].y=Narrator[2].y+90
	
	Narrator[4]=display.newText("Find the guard",0, 0,"MoolBoran",40)
	Narrator[4]:setTextColor(70,255,70)
	Narrator[4].x=display.contentWidth-120
	Narrator[4].y=display.contentHeight-40
	
	Narrator[5]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[5]:setTextColor(255,255,70)
	Narrator[5].x=120
	Narrator[5].y=display.contentHeight-250
end

function Eighteen()
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	map2[63]="o"
	boundary[63]=0
	mbounds[63]=0
	display.remove(walls[63])
	walls[63]=display.newImageRect( "tiles/0/wall1.png", 80, 80)
	walls[63].x=xinicial+((((63-1)%math.sqrt(mapsize)))*espaciox)
	walls[63].y=yinicial+(math.floor((63-1)/math.sqrt(mapsize))*espacioy)
	walls[63].isVisible=true
	Level:insert( walls[63] )
	--
	Mob=display.newImageRect( "tiles/0/mob.png", 80, 80)
	Mob.x=xinicial+((((33-1)%math.sqrt(mapsize)))*espaciox)
	Mob.y=yinicial+(math.floor((33-1)/math.sqrt(mapsize))*espacioy)
	Mob.loc=33
	Mob.isVisible=false
	Level:insert( Mob )
	
	Fog()
	ShowTiles(player.loc)
	ShowArrows()
	
	Narrator[1]=display.newText("That bastard guard closed the gate.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("He should be close by.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Find the guard",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Nineteen()

end

function Combat( event )
	ShowArrows("clean")
	Fog()
	BasicCombat()
end

function BasicCombat()
	Runtime:removeEventListener("enterFrame", ShowStats)
	Runtime:addEventListener("enterFrame", NoMansLand)
	HitGroup=display.newGroup()
	gcm=display.newGroup()
	hits={}
	Sorcery={}
	local yCoord=510
	local xCoord=display.contentWidth-250
	local yinvicial=156
	local xinvicial=75
	local espaciox=64
	local espacioy=64
	player.isVisible=false
	
	window2=display.newImage("window2.png",171,43)
	window2.x=display.contentWidth-192
	window2.y=yCoord-120
	window2.xScale=2.25
	window2.yScale=window2.xScale
	gcm:insert(window2)
	
	window1=display.newImage("window.png",171,65)
	window1.x=192
	window1.y=window2.y+26
	window1.xScale=window2.xScale
	window1.yScale=window1.xScale
	gcm:insert(window1)
	
	enemy=Mob
	enemy.classname="Guard"
	MobSprite(1)
	enemy.MaxHP=25
	enemy.HP=enemy.MaxHP
	enemy.SPD=2
	
	P1Sprite(1)
	UpdateStats(1)
	
	timersprite=display.newSprite(timersheet,{ name="timerid", start=1, count=25, loopCount=1, time=400})
	timersprite.x=display.contentCenterX
	timersprite.y=display.contentCenterY+100
	timersprite:play()
	gcm:insert(timersprite)
	
	CHideActions()
	
	--Progress count is 19 at combat start.
	
	timer.performWithDelay(500,Continue)
	modif=1
end

function Twenty()
	Narrator[1]=display.newText("...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function TwentyOne()
	Narrator[1]=display.newText("You're kidding.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function TwentyTwo()
	Narrator[1]=display.newText("You seriously have no idea what to do?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function TwentyThree()
	Narrator[1]=display.newText("Fine, I'll guide you through this too...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function TwentyFour()
	CAttackBtn()
	
	Narrator[1]=display.newText("See that button that says \"Attack\"?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Try pressing it.",0, 0,"MoolBoran",50)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Just try it.",0, 0,"MoolBoran",35)
	Narrator[3].x=display.contentCenterX
	Narrator[3].y=Narrator[2].y+45
	
	Narrator[4]=display.newText("Tap the Attack button",0, 0,"MoolBoran",40)
	Narrator[4]:setTextColor(70,255,70)
	Narrator[4].x=display.contentWidth-130
	Narrator[4].y=display.contentHeight-40
	
	Narrator[5]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[5]:setTextColor(255,255,70)
	Narrator[5].x=120
	Narrator[5].y=display.contentHeight-250
end

function Hits(damage,target)
	local hitmax=table.maxn(hits)
	hits[hitmax+1]=display.newText( ("-"..damage), 0, 0, "MoolBoran", 60 )
	hits[hitmax+1]:setTextColor( 255, 50, 50)
	physics.addBody(hits[hitmax+1], "dynamic", { friction=0.5,} )
	hits[hitmax+1].isFixedRotation = true
	if target==false then
		hits[hitmax+1].x=(display.contentWidth/2)-75
		hits[hitmax+1].y=(display.contentHeight/4)*1
		hits[hitmax+1]:setLinearVelocity(100,-300)
	elseif target==true then
		hits[hitmax+1].x=(display.contentWidth/2)+75
		hits[hitmax+1].y=(display.contentHeight/4)*1
		hits[hitmax+1]:setLinearVelocity(-100,-300)
	end
	HitGroup:insert( hits[hitmax+1] )
	HitGroup:toFront()
end

function CHideActions()
	
	if (AttackBtn) then
		display.remove(AttackBtn)
	end
	
	if (MagicBtn) then
		display.remove(MagicBtn)
	end
	
	if (ItemBtn) then
		display.remove(ItemBtn)
	end
	
	if (RunBtn) then
		display.remove(RunBtn)
	end
	
	AttackBtn=display.newImageRect("combataction3.png",342,86)
	AttackBtn.x=timersprite.x-172
	AttackBtn.y=timersprite.y-44
	gcm:insert( AttackBtn )
	
	MagicBtn=display.newImageRect("combataction3.png",342,86)
	MagicBtn.x = timersprite.x+172
	MagicBtn.y = AttackBtn.y
	gcm:insert( MagicBtn )
	
	ItemBtn=display.newImageRect("combataction3.png",342,86)
	ItemBtn.x = AttackBtn.x
	ItemBtn.y = timersprite.y+44
	gcm:insert( ItemBtn )
	
	RunBtn=display.newImageRect("combataction3.png",342,86)
	RunBtn.x = MagicBtn.x
	RunBtn.y = timersprite.y+44
	gcm:insert( RunBtn )
	
	timersprite:toFront()
end

function CAttackBtn()
	
	if (AttackBtn) then
		display.remove(AttackBtn)
		AttackBtn=nil
	end
	
	if not(AttackBtn)then
		AttackBtn= widget.newButton{
			label="Attack",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=35,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = PAttack}
		AttackBtn:setReferencePoint( display.CenterReferencePoint )
		AttackBtn.x = timersprite.x-172
		AttackBtn.y = timersprite.y-44
		gcm:insert( AttackBtn )
	end
	
	timersprite:toFront()
end

function MobSprite(value)
	if (value)==(1) then--Create
		eseqs={
			{name="walk", start=1, count=4, time=1000},
			{name="hit", start=9, count=4, loopCount=1, time=1000},
			{name="hurt", start=8, count=1, time=1000},
			{name="hitalt", start=17, count=3, loopCount=1, time=1000}
		}
		esprite=display.newSprite( dexatt3, eseqs  )
		esprite:setSequence( "walk" )
		esprite.x=(display.contentWidth/2)+50
		esprite.y=170
		esprite.xScale=3.5
		esprite.yScale=esprite.xScale
		esprite:play()
		gcm:insert(esprite)
	end
	if (value)==(2) then--Change to Hit
		local roll=math.random(1,2)
		if roll==1 then
			esprite:setSequence( "hit" )
			esprite:play()
		elseif roll==2 then
			esprite:setSequence( "hitalt" )
			esprite:play()
		end
	end
	if (value)==(3) then--Change to Hurt
		esprite:setSequence( "hurt" )
		esprite:play()
	end
	if (value~=1)and(value~=2)and(value~=3)and(value~=4)then--Go Default
		if (esprite)and(esprite.sequence~="walk")then
			if (esprite.frame==esprite.numFrames)then
				esprite:setSequence( "walk" )
				esprite:play()
			else
				timer.performWithDelay(20,MobSprite)
			end
		end
	end
end

function P1Sprite(value)
	if (value)==(1) then--Create
		pseqs={
			{name="walk", start=1, count=4, time=1000},
			{name="hit1", start=6, count=3, loopCount=1, time=1000},
			{name="hit2", start=11, count=4, loopCount=1, time=1000},
			{name="hit3", start=16, count=5, loopCount=1, time=1000},
			{name="cast", start=21, count=2, time=1000},
			{name="hurt", start=5, count=1, time=1000}
		}
		psprite=display.newSprite( player1, pseqs  )
		psprite:setSequence( "walk" )
		psprite.x=(display.contentWidth/2)-50
		psprite.y=170
		psprite.xScale=4.0
		psprite.yScale=psprite.xScale
		psprite:play()
		gcm:insert(psprite)
	end
	if (value)==(2) then--Change to Hit
		local hat=math.random(1,3)
		if hat==1 then
			psprite:setSequence( "hit1" )
		elseif hat==2 then
			psprite:setSequence( "hit2" )
		else
			psprite:setSequence( "hit3" )
		end
		psprite:play()
	end
	if (value)==(3) then--Change to Hurt
		psprite:setSequence( "hurt" )
		psprite:play()
	end
	if (value)==(4) then--Set to Casting
		psprite:setSequence( "cast" )
		psprite:play()
	end
	if (value~=1)and(value~=2)and(value~=3)and(value~=4) then--Go Default
		if (psprite)and(psprite.sequence~="walk")then
			if (psprite.frame==psprite.numFrames)or(psprite.sequence=="cast")then
				psprite:setSequence( "walk" )
				psprite:play()
			else
				timer.performWithDelay(20,P1Sprite)
			end
		end
	end
end

function UpdateStats(value)
	local yCoord=510
	local xCoord=display.contentWidth-250
	local yinvicial=156
	local xinvicial=75
	local espaciox=64
	local espacioy=64
	local p1=player
	
	if (value==1) then
	--[[ MOB ]]
	-- Life
		eHPcnt=enemy.HP
		hpBar=display.newSprite( hpsheet, { name="hpsheet", start=1, count=67, time=(1800) })
		hpBar.yScale=1.25
		hpBar.xScale=hpBar.yScale
		hpBar.x = xCoord+110
		hpBar.y = yCoord-135
		hpBar:toFront()
		gcm:insert(hpBar)
		hpBar:setFrame(math.floor(( (eHPcnt/enemy.MaxHP)*66 )+1))
		
		LifeSymbol3=display.newSprite( heartsheet, { name="heart", start=1, count=16, time=(1800) })
		LifeSymbol3.yScale=3.25
		LifeSymbol3.xScale=LifeSymbol3.yScale
		LifeSymbol3.x = xCoord-10
		LifeSymbol3.y = hpBar.y
		LifeSymbol3:play()
		LifeSymbol3:toFront()
		gcm:insert(LifeSymbol3)
		
		LifeDisplay3 = display.newText( (eHPcnt.."/"..enemy.MaxHP), 0, 0, "Game Over", 75 )
		LifeDisplay3:setTextColor( 0, 0, 0)
		LifeDisplay3.x = LifeSymbol3.x+140
		LifeDisplay3.y = LifeSymbol3.y-5
		LifeDisplay3:toFront()
		gcm:insert(LifeDisplay3)
		

	-- Level
		
		classdisplay= display.newText( (enemy.classname), 0, 0, "MoolBoran", 55 )
		classdisplay:setTextColor( 0, 0, 0)
		classdisplay.x = LifeDisplay.x-150
		classdisplay.y = LifeDisplay.y+50
		gcm:insert(classdisplay)
		
	--[[ PLAYER ]]
	-- Life
		pHPcnt=p1.HP
		hpBar2=display.newSprite( hpsheet, { name="hpsheet", start=1, count=67, time=(1800) })
		hpBar2.yScale=1.25
		hpBar2.xScale=hpBar2.yScale
		hpBar2.x = 140
		hpBar2.y = yCoord-135
		hpBar2:toFront()
		gcm:insert(hpBar2)
		hpBar2:setFrame(math.floor(( (pHPcnt/p1.MaxHP)*66 )+1))
		
		LifeSymbol2=display.newSprite( heartsheet, { name="heart", start=1, count=16, time=(1800) })
		LifeSymbol2.yScale=3.25
		LifeSymbol2.xScale=LifeSymbol2.yScale
		LifeSymbol2.x = 260
		LifeSymbol2.y = hpBar2.y
		LifeSymbol2:play()
		LifeSymbol2:toFront()
		gcm:insert(LifeSymbol2)
		
		LifeDisplay2 = display.newText( (pHPcnt.."/"..p1.MaxHP), 0, 0, "Game Over", 75 )
		LifeDisplay2:setTextColor( 0, 0, 0)
		LifeDisplay2.x = LifeSymbol2.x-140
		LifeDisplay2.y = LifeSymbol2.y-5
		LifeDisplay2:toFront()
		gcm:insert(LifeDisplay2)	
	end
	
	if (value==2) then
		pEPcnt=p1.EP
		epBar2=display.newSprite( epsheet, { name="epsheet", start=1, count=67, time=(1800) })
		epBar2.yScale=1.25
		epBar2.xScale=epBar2.yScale
		epBar2.x = 140
		epBar2.y = yCoord-55
		epBar2:toFront()
		gcm:insert(epBar2)
		epBar2:setFrame(math.floor(( (pEPcnt/p1.MaxEP)*66 )+1))
		
		EnergySymbol2=display.newSprite( energysheet, { name="energy", start=1, count=4, time=(500) })
		EnergySymbol2.yScale=0.9
		EnergySymbol2.xScale=EnergySymbol2.yScale
		EnergySymbol2.x = 260
		EnergySymbol2.y = epBar2.y
		EnergySymbol2:play()
		EnergySymbol2:toFront()
		gcm:insert(EnergySymbol2)
		
		EnergyDisplay2 = display.newText( (pEPcnt.."/"..p1.MaxEP), 0, 0, "Game Over", 75 )
		EnergyDisplay2:setTextColor( 0, 0, 0)
		EnergyDisplay2.x = EnergySymbol2.x-140
		EnergyDisplay2.y = EnergySymbol2.y-5
		EnergyDisplay2:toFront()
		gcm:insert(EnergyDisplay2)
	end
	
	if (value==3) then
		pMPcnt=p1.MP
		mpBar2=display.newSprite( mpsheet, { name="mpsheet", start=1, count=67, time=(1800) })
		mpBar2.yScale=1.25
		mpBar2.xScale=mpBar2.yScale
		mpBar2.x = 140
		mpBar2.y = yCoord-95
		mpBar2:toFront()
		gcm:insert(mpBar2)
		mpBar2:setFrame(math.floor(( (pMPcnt/p1.MaxMP)*66 )+1))
		
		ManaSymbol2=display.newSprite( manasheet, { name="mana", start=1, count=3, time=(500) })
		ManaSymbol2.yScale=0.9
		ManaSymbol2.xScale=ManaSymbol2.yScale
		ManaSymbol2.x = 260
		ManaSymbol2.y = mpBar2.y
		ManaSymbol2:play()
		ManaSymbol2:toFront()
		gcm:insert(ManaSymbol2)
		
		ManaDisplay2 = display.newText( (pMPcnt.."/"..p1.MaxMP), 0, 0, "Game Over", 75 )
		ManaDisplay2:setTextColor( 0, 0, 0)
		ManaDisplay2.x = ManaSymbol2.x-140
		ManaDisplay2.y = ManaSymbol2.y-5
		ManaDisplay2:toFront()
		gcm:insert(ManaDisplay2)
	end
	
	local done=true
	if p1.HP<0 then
		p1.HP=0
	end
	if p1.EP<0 then
		p1.EP=0
	end
	if enemy.HP<0 then
		enemy.HP=0
	end
	
	if pHPcnt-p1.HP==0 then
	elseif pHPcnt-p1.HP>0 then
		if pHPcnt-p1.HP>500 then
			pHPcnt=pHPcnt-25
			done=false
		elseif pHPcnt-p1.HP>200 then
			pHPcnt=pHPcnt-10
			done=false
		elseif pHPcnt-p1.HP>50 then
			pHPcnt=pHPcnt-5
			done=false
		elseif pHPcnt-p1.HP>20 then
			pHPcnt=pHPcnt-2
			done=false
		else
			pHPcnt=pHPcnt-1
			done=false
		end
	elseif pHPcnt-p1.HP<0 then
		if pHPcnt-p1.HP<-500 then
			pHPcnt=pHPcnt+25
			done=false
		elseif pHPcnt-p1.HP<-200 then
			pHPcnt=pHPcnt+10
			done=false
		elseif pHPcnt-p1.HP<-50 then
			pHPcnt=pHPcnt+5
			done=false
		elseif pHPcnt-p1.HP<-20 then
			pHPcnt=pHPcnt+2
			done=false
		else
			pHPcnt=pHPcnt+1
			done=false
		end
	end
	
	if (pEPcnt) and (p1.EP) then
		if pEPcnt-p1.EP==0 then
		elseif pEPcnt-p1.EP>0 then
			if pEPcnt-p1.EP>500 then
				pEPcnt=pEPcnt-25
				done=false
			elseif pEPcnt-p1.EP>200 then
				pEPcnt=pEPcnt-10
				done=false
			elseif pEPcnt-p1.EP>50 then
				pEPcnt=pEPcnt-5
				done=false
			elseif pEPcnt-p1.EP>20 then
				pEPcnt=pEPcnt-2
				done=false
			else
				pEPcnt=pEPcnt-1
				done=false
			end
		elseif pEPcnt-p1.EP<0 then
			if pEPcnt-p1.EP<-500 then
				pEPcnt=pEPcnt+25
				done=false
			elseif pEPcnt-p1.EP<-200 then
				pEPcnt=pEPcnt+10
				done=false
			elseif pEPcnt-p1.EP<-50 then
				pEPcnt=pEPcnt+5
				done=false
			elseif pEPcnt-p1.EP<-20 then
				pEPcnt=pEPcnt+2
				done=false
			else
				pEPcnt=pEPcnt+1
				done=false
			end
		end
	end
	
	if (pMPcnt) and (p1.MP) then
		if pMPcnt-p1.MP==0 then
		elseif pMPcnt-p1.MP>0 then
			if pMPcnt-p1.MP>500 then
				pMPcnt=pMPcnt-25
				done=false
			elseif pMPcnt-p1.MP>200 then
				pMPcnt=pMPcnt-10
				done=false
			elseif pMPcnt-p1.MP>50 then
				pMPcnt=pMPcnt-5
				done=false
			elseif pMPcnt-p1.MP>20 then
				pMPcnt=pMPcnt-2
				done=false
			else
				pMPcnt=pMPcnt-1
				done=false
			end
		elseif pMPcnt-p1.MP<0 then
			if pMPcnt-p1.MP<-500 then
				pMPcnt=pMPcnt+25
				done=false
			elseif pMPcnt-p1.MP<-200 then
				pMPcnt=pMPcnt+10
				done=false
			elseif pMPcnt-p1.MP<-50 then
				pMPcnt=pMPcnt+5
				done=false
			elseif pMPcnt-p1.MP<-20 then
				pMPcnt=pMPcnt+2
				done=false
			else
				pMPcnt=pMPcnt+1
				done=false
			end
		end
	end
	
	if eHPcnt-enemy.HP==0 then
	elseif eHPcnt-enemy.HP>500 then
		eHPcnt=eHPcnt-25
		done=false
	elseif eHPcnt-enemy.HP>200 then
		eHPcnt=eHPcnt-10
		done=false
	elseif eHPcnt-enemy.HP>50 then
		eHPcnt=eHPcnt-5
		done=false
	elseif eHPcnt-enemy.HP>20 then
		eHPcnt=eHPcnt-2
		done=false
	else
		eHPcnt=eHPcnt-1
		done=false
	end
	
	LifeDisplay2.text=(pHPcnt.."/"..p1.MaxHP)
	LifeDisplay3.text=(eHPcnt.."/"..enemy.MaxHP)
	if (EnergyDisplay2)and(epBar2)then
		epBar2:setFrame(math.floor(( (pEPcnt/p1.MaxEP)*66 )+1))
		EnergyDisplay2.text=(pEPcnt.."/"..p1.MaxEP)
	end
	if (ManaDisplay2)and(mpBar2)then
		ManaDisplay2.text=(pMPcnt.."/"..p1.MaxMP)
		mpBar2:setFrame(math.floor(( (pMPcnt/p1.MaxMP)*66 )+1))
	end
	hpBar2:setFrame(math.floor(( (pHPcnt/p1.MaxHP)*66 )+1))
	hpBar:setFrame(math.floor(( (eHPcnt/enemy.MaxHP)*66 )+1))
	if (done==true) and Created==true and (gcm) then
	elseif (done==true) and Created~=true and (gcm) then
		Created=true
	elseif (done~=true) and (Created==true) and (gcm) then
		timer.performWithDelay(25,UpdateStats)
	end
end

function NoMansLand()
	for h=1,table.maxn(hits) do
		if (hits[h]) and (hits[h].y) then
			if hits[h].y>=280 then
				display.remove(hits[h])
			end
		end
	end
end

function PAttack()
	CHideActions()
	if Progress==24 then
		enemy.HP=enemy.HP-1
		P1Sprite(2)
		MobSprite(3)
		Hits(1,true)
		Continue()
	elseif Progress==43 then
		enemy.HP=enemy.HP-6
		P1Sprite(2)
		MobSprite(3)
		Hits(6,true)
		Continue()
	end
	UpdateStats()
end

function EAttack()
	Runtime:removeEventListener("tap",EAttack)
	if Progress==27 then
		player.HP=player.HP-17
		MobSprite(2)
		P1Sprite(3)
		Hits(17,false)
		Continue()
	elseif Progress==35 then
		player.HP=player.HP-30
		MobSprite(2)
		P1Sprite(3)
		Hits(30,false)
		Continue()
	elseif Progress==42 then
		player.HP=player.HP-2
		MobSprite(2)
		P1Sprite(3)
		Hits(2,false)
		Continue()
	end
	UpdateStats()
end

function TwentyFive()
	UpdateStats(2)
	
	Narrator[1]=display.newText("Nice...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function TwentySix()
	MobSprite()
	P1Sprite()
	player.EP=player.EP-3
	UpdateStats()
	
	Narrator[1]=display.newText("You drained some of your energy though...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("I'm sure you'll recover it soon enough.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function TwentySeven()
	Narrator[1]=display.newText("Uh-oh, here comes his attack.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Get ready...",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",EAttack)
end

function TwentyEight()
	Narrator[1]=display.newText("Hmmm.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Seems like you're in trouble.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function TwentyNine()
	MobSprite()
	P1Sprite()
	
	Narrator[1]=display.newText("You'll need a miracle to beat him.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Or magic.",0, 0,"MoolBoran",50)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Oh wait.",0, 0,"MoolBoran",35)
	Narrator[3].x=display.contentCenterX
	Narrator[3].y=Narrator[2].y+45
	
	Narrator[4]=display.newText("Wait for your turn",0, 0,"MoolBoran",40)
	Narrator[4]:setTextColor(70,255,70)
	Narrator[4].x=display.contentWidth-120
	Narrator[4].y=display.contentHeight-40
	
	Narrator[5]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[5]:setTextColor(255,255,70)
	Narrator[5].x=120
	Narrator[5].y=display.contentHeight-250
	
	function Closure()
		timersprite:play()
		timer.performWithDelay(500,Continue)
	end
	timer.performWithDelay(2500,Closure)
end

function CMagicBtn()
	if (MagicBtn) then
		display.remove(MagicBtn)
		MagicBtn=nil
	end
	if not(MagicBtn)then
		MagicBtn= widget.newButton{
			label="Spellbook",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=35,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = PMagic}
		MagicBtn:setReferencePoint( display.CenterReferencePoint )
		MagicBtn.x = timersprite.x+172
		MagicBtn.y = AttackBtn.y
		gcm:insert( MagicBtn )
	end
	timersprite:toFront()
end

function Thirty()

	Narrator[1]=display.newText("'Kay.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250

	Runtime:addEventListener("tap",Continue)
end

function ThirtyOne()
	CMagicBtn()
	
	Narrator[1]=display.newText("Open your spellbook.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap the Spellbook button",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-160
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
end

function PMagic()
	CHideActions()
	Continue()
	local SorcIniX=display.contentCenterX-(300)
	local SorcIniY=display.contentHeight-120
	Sorcery[#Sorcery+1]=display.newText( "Fireball  10 MP  7 EP", SorcIniX, (SorcIniY-((#Sorcery-1)*50)), "Viner Hand ITC", 40)
	Sorcery[#Sorcery]:setTextColor(50,50,50)
	Sorcery[#Sorcery]:addEventListener("tap",CastSorcery)
	Sorcery[#Sorcery].isVisible=false
	
	function finishSpells()
		for i=1,table.maxn(Sorcery) do
			Sorcery[i].isVisible=true
			Sorcery[i]:toFront()
		end
	end
			
	SorceryUI=display.newImageRect("scrollui4.png", 460, 600)
	SorceryUI.x, SorceryUI.y = display.contentCenterX-90, display.contentHeight+300
	transition.to(SorceryUI, {time=(100*(#Sorcery)), y=(SorceryUI.y-(50+((#Sorcery)*44))),transition = easing.inExpo,onComplete=finishSpells})
end

function CleanSorcery()
	function deletion()
		display.remove(SorceryUI)
	end
	transition.to(SorceryUI, {time=(100*(#Sorcery)), y=(SorceryUI.y+(50+((#Sorcery)*44))),transition = easing.inExpo,onComplete=deletion})
	for i=table.maxn(Sorcery),1,-1 do
		display.remove(Sorcery[i])
		Sorcery[i]=nil
	end
end

function CastSorcery(name)
	P1Sprite(4)
	CleanSorcery()
	enemy.HP=enemy.HP-18
	MobSprite(3)
	Hits(18,true)
	Continue()
	
	UpdateStats()
end

function ThirtyTwo()
	Narrator[1]=display.newText("...and cast a Fireball.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap on Fireball",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
end

function ThirtyThree()
	MobSprite()
	P1Sprite()
	
	Narrator[1]=display.newText("Boom!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("He better watch out!",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function ThirtyFour()
	local p1=player
	UpdateStats(3)
	p1.MP=p1.MP-10
	p1.EP=p1.EP-7
	UpdateStats()
	
	Narrator[1]=display.newText("And you seem to be out of mana now.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("...and out of energy as well.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function ThirtyFive()
	Narrator[1]=display.newText("Here he comes...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-120
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",EAttack)
end

function ThirtySix()
	MobSprite()
	P1Sprite()
	
	Narrator[1]=display.newText("Ouch.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Looks like you'll need some extra help here...",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Wait for your turn",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	function Closure()
		timersprite:play()
		timer.performWithDelay(500,Continue)
	end
	timer.performWithDelay(2500,Closure)
end

function ThirtySeven()
	Narrator[1]=display.newText("Well, you can't fight like this.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("You're panting your lungs out...",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function ThirtyEight()
	Narrator[1]=display.newText("Let's try this potion here...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Old man Hank gave it to me before he passed away.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function CItemBtn()
	if (ItemBtn) then
		display.remove(ItemBtn)
		ItemBtn=nil
	end
	if not(ItemBtn)then
		ItemBtn= widget.newButton{
			label="Inventory",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=35,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = ShowBag}
		ItemBtn:setReferencePoint( display.CenterReferencePoint )
		ItemBtn.x = AttackBtn.x
		ItemBtn.y = timersprite.y+44
		gcm:insert( ItemBtn )
	end
	timersprite:toFront()
end

function ThirtyNine()
	CItemBtn()
	
	Narrator[1]=display.newText("Open your inventory...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap on the Items button",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-160
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
end

function ShowBag()
	local xinvicial=100
	local espaciox=64
	local espacioy=64
	
	Continue()
	CHideActions()
	
	ginv=display.newGroup()
	items={}
	items2={}
	
	items2[#items2+1]=display.newRect(0,0,65,65)
	items2[#items2]:setFillColor(50,50,50)
	items2[#items2].xScale=1.25
	items2[#items2].yScale=1.25
	items2[#items2].x = xinvicial+ (((#items2-1)%8)*((espaciox*items2[#items2].xScale)+4))
	items2[#items2].y = display.contentHeight-120
	items[#items+1]=display.newImageRect( "items/SuperPotion.png" ,64,64)
	items[#items].xScale=1.25
	items[#items].yScale=1.25
	items[#items].x = xinvicial+ (((#items-1)%8)*((espaciox*items[#items].xScale)+4))
	items[#items].y = display.contentHeight-120
	
	items2[#items2]:addEventListener("tap",UseItem)
	ginv:insert( items2[#items2] )
	ginv:insert( items[#items] )
	
	ginv:toFront()
end

function Forty()
	
	Narrator[1]=display.newText("Go ahead, use it.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap on the potion",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-140
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
end

function CleanInv()
	for i=table.maxn(items),1,-1 do
		display.remove(items[i])
		items[i]=nil
		display.remove(items2[i])
		items2[i]=nil
	end
	items=nil
	items2=nil
	for i=ginv.numChildren,1,-1 do
		display.remove(ginv[i])
		ginv[i]=nil
	end
	ginv=nil
end

function UseItem()
	CleanInv()
	player.HP=math.floor(player.MaxHP*.75)
	player.MP=math.floor(player.MaxMP*.6)
	player.EP=math.floor(player.MaxEP*.6)
	Continue()
	UpdateStats()
end

function FortyOne()
	
	Narrator[1]=display.newText("Would you look at that!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("That old rascal was finally useful!",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function FortyTwo()
	
	Narrator[1]=display.newText("You should be way tougher now.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Assuming the potion worked, that is.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",EAttack)
end

function FortyThree()
	MobSprite()
	P1Sprite()
	CAttackBtn()
	
	Narrator[1]=display.newText("A-ha!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Finish him!",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Apply what you've learned",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-150
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function FortyFour()
	Narrator[1]=display.newText("Yes!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Good job!",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-120
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function FortyFive()
	gcm:insert(HitGroup)
	for i=gcm.numChildren,1,-1 do
		display.remove(gcm[i])
		gcm[i]=nil
	end
	gcm=nil
	Runtime:addEventListener("enterFrame", ShowStats)
	Runtime:removeEventListener("enterFrame", NoMansLand)
	
	display.remove(Mob)
	Mob=nil
	player.isVisible=true
	ShowArrows()
	
	Narrator[1]=display.newText("Let's carry on.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("That was exciting.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function FortySix()
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	Chest=display.newImageRect( "tiles/0/treasure.png", 80, 80)
	Chest.x=xinicial+((((33-1)%math.sqrt(mapsize)))*espaciox)
	Chest.y=yinicial+(math.floor((33-1)/math.sqrt(mapsize))*espacioy)
	Chest.loc=33
	Chest.isVisible=false
	Level:insert( Chest )
	Fog()
	ShowTiles(player.loc)
	
	Narrator[1]=display.newText("Did you forget to take the key?",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("You did, didn't you?",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Go back for the key",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function FortySeven()
	display.remove(Chest)
	Chest=nil
	Fog()
	ShowTiles(player.loc)
	
	coins={}
	timer.performWithDelay(1,Coins,5)
	
	Narrator[1]=display.newText("There we go.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Now go and open the gate.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Open the gate",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function Coins()
	coins[#coins+1]=display.newSprite( coinsheet, { name="coin", start=1, count=8, time=500,}  )
	coins[#coins].x=(display.contentCenterX+(math.random(-5,5)))
	coins[#coins].y=(display.contentCenterY+(math.random(-50,-10)))
	physics.addBody(coins[#coins], "dynamic", { friction=0.5, radius=15.0} )
	coins[#coins]:setLinearVelocity((math.random(-200,200)),-300)
	coins[#coins]:play()
	coins[#coins]:toFront()
end

function FortyEight()
	ShowArrows("clean")
	display.remove(Gate)
	Gate=nil
	boundary[72]=1
	mbounds[72]=1
	
	Narrator[1]=display.newText("We're free!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Hurry up now, we'll be late.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	timer.performWithDelay(100,ShowArrows)
end

function FortyNine()
	ShowArrows("clean")
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	map2[57]="o"
	HP=display.newSprite( HealPadsheet, { name="HP", start=1, count=30, time=2000 }  )
	HP.x=xinicial+((((57-1)%math.sqrt(mapsize)))*espaciox)
	HP.y=yinicial+(math.floor((57-1)/math.sqrt(mapsize))*espacioy)
	HP.isVisible=false
	HP.loc=(57)
	HP:play()
	Level:insert( HP )
	
	boundary[72]=0
	mbounds[72]=0
	
	Gate=display.newImageRect( "tiles/"..TSet.."/jail.png", 80, 80)
	Gate.x=xinicial+((((72-1)%math.sqrt(mapsize)))*espaciox)
	Gate.y=yinicial+(math.floor((72-1)/math.sqrt(mapsize))*espacioy)
	Gate.isVisible=false
	Gate.loc=72
	Level:insert( Gate )
	
	Fog()
	ShowTiles(player.loc)
	
	Narrator[1]=display.newText("Woops.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Well, we're out anyway.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	timer.performWithDelay(100,ShowArrows)
end

function Fifty()
	Narrator[1]=display.newText("That's water.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("You can walk on it.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function FiftyOne()
	Narrator[1]=display.newText("You're joking.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("You willingly walk on lava...",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("...but don't even dare touch water?",0, 0,"MoolBoran",40)
	Narrator[3].x=display.contentCenterX
	Narrator[3].y=Narrator[2].y+45
	
	Narrator[4]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[4]:setTextColor(70,255,70)
	Narrator[4].x=display.contentWidth-140
	Narrator[4].y=display.contentHeight-40
	
	Narrator[5]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[5]:setTextColor(255,255,70)
	Narrator[5].x=120
	Narrator[5].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function FiftyTwo()
	ShowArrows("clean")
	boundary[85]=1
	mbounds[85]=1
	
	Narrator[1]=display.newText("You're unbelievable.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("If you don't go on that water right now...",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Walk on the water",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	timer.performWithDelay(100,ShowArrows)
end

function FiftyThree()
	Narrator[1]=display.newText("Only thing water does is slow you down.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("But no one is chasing you, so who cares.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
end

function FiftyFour()
	local xinicial=304
	local yinicial=432
	local espaciox=80
	local espacioy=80
	ShowArrows("clean")
	map2[77]="o"
	boundary[77]=0
	mbounds[77]=0
	display.remove(walls[77])
	walls[77]=display.newImageRect( "tiles/0/wall1.png", 80, 80)
	walls[77].x=xinicial+((((77-1)%math.sqrt(mapsize)))*espaciox)--+Level.x
	walls[77].y=yinicial+(math.floor((77-1)/math.sqrt(mapsize))*espacioy)--+Level.y
	walls[77].isVisible=true
	Level:insert( walls[77] )
	
	Fog()
	ShowTiles(player.loc)
	
	Narrator[1]=display.newText("Well, how convenient.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-140
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	timer.performWithDelay(100,ShowArrows)
end

function FiftyFive()
	Narrator[1]=display.newText("Continue down the path",0, 0,"MoolBoran",40)
	Narrator[1]:setTextColor(70,255,70)
	Narrator[1].x=display.contentWidth-140
	Narrator[1].y=display.contentHeight-40
end

function FiftySix()
	Runtime:removeEventListener("enterFrame",ShowStats)
	ShowArrows("clean")
	for i=Level.numChildren,1,-1 do
		display.remove(Level[i])
		Level[i]=nil
	end
	Level=nil
	count=nil
	for i=table.maxn(coins),1,-1 do
		display.remove(coins[i])
		coins[i]=nil
	end
	coins=nil	

	Narrator[1]=display.newText("Finally!",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("I made it out!",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function FiftySeven()
	Narrator[1]=display.newText("I lost count of the time I was stuck there.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("But no matter...",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function FiftyEight()
	Narrator[1]=display.newText("My time has come.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("And it's all thanks to you...",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function FiftyNine()
	Narrator[1]=display.newText("However...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("I'm afraid I can't let you be free.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function Sixty()
	Narrator[1]=display.newText("Your potential is greater than I expected.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("And I'm not going to let you stop me.",0, 0,"MoolBoran",40)
	Narrator[2].x=display.contentCenterX
	Narrator[2].y=Narrator[1].y+45
	
	Narrator[3]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[3]:setTextColor(70,255,70)
	Narrator[3].x=display.contentWidth-140
	Narrator[3].y=display.contentHeight-40
	
	Narrator[4]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[4]:setTextColor(255,255,70)
	Narrator[4].x=120
	Narrator[4].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function SixtyOne()
	Narrator[1]=display.newText("So excuse me while I...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-140
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("??? :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function SixtyTwo()
	Narrator[1]=display.newText("...throw you into MY dungeons for a change...",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-140
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("Gal'Darah :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function SixtyThree()
	Narrator[1]=display.newText("...forever.",0, 0,"MoolBoran",60)
	Narrator[1].x=display.contentCenterX
	Narrator[1].y=display.contentHeight-200
	
	Narrator[2]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
	Narrator[2]:setTextColor(70,255,70)
	Narrator[2].x=display.contentWidth-140
	Narrator[2].y=display.contentHeight-40
	
	Narrator[3]=display.newText("Gal'Darah :",0, 0,"MoolBoran",70)
	Narrator[3]:setTextColor(255,255,70)
	Narrator[3].x=120
	Narrator[3].y=display.contentHeight-250
	
	Runtime:addEventListener("tap",Continue)
end

function SixtyFour()
	physics.addBody(player, "dynamic", { friction=0.5} )
	player:applyAngularImpulse(2)
	
	boundary=display.newRect( 0,0,500,10)
	boundary.x=display.contentCenterX
	boundary.y=display.contentCenterY-100
	boundary.isVisible=false
	physics.addBody(boundary, "static", { friction=0.5} )
	
	titleLogo = display.newImageRect( "titleW.png", 477, 254 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = -500
	physics.addBody(titleLogo, "dynamic", { friction=0.5} )
	titleLogo.isFixedRotation=true
	
	Runtime:addEventListener("enterFrame",titleCheck)
end

function titleCheck()
	if (player) then
		if player.y>display.contentHeight+200 then
			display.remove(player)
			player=nil
		end
	end
	
	if titleLogo.isAwake==false and not (player) then
		Narrator[1]=display.newText("Tap to continue",0, 0,"MoolBoran",40)
		Narrator[1]:setTextColor(70,255,70)
		Narrator[1].x=display.contentWidth-140
		Narrator[1].y=display.contentHeight-40
		
		Runtime:removeEventListener("enterFrame",titleCheck)
		Runtime:addEventListener("tap",Continue)
	end
end

function SixtyFive()
	display.remove(LifeDisplay)
	display.remove(LifeWindow)
	display.remove(LifeSymbol)
	display.remove(ManaDisplay)
	display.remove(ManaWindow)
	display.remove(ManaSymbol)
	display.remove(EnergyDisplay)
	display.remove(EnergyWindow)
	display.remove(EnergySymbol)
	LifeDisplay=nil
	LifeWindow=nil
	LifeSymbol=nil
	ManaDisplay=nil
	ManaWindow=nil
	ManaSymbol=nil
	EnergyDisplay=nil
	EnergyWindow=nil
	EnergySymbol=nil
	display.remove(boundary)
	boundary=nil
	display.remove(titleLogo)
	titleLogo=nil
	menu.ShowMenu()
	timer.performWithDelay(100,menu.ReadySetGo)
end