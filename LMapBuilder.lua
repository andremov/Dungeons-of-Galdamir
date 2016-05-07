-----------------------------------------------------------------------------------------
--
-- MapBuilder.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local col=require("LTileEvents")
local ui=require("LUI")
local su=require("LStartup")
local handler=require("LMapHandler")
local mob=require("Lmobai")
local m=require("Lmovement")
local WD=require("LProgress")
local bin=require("Lgarbage")
local p=require("Lplayers")
local q=require("LQuest")
local rockbreaksheet
local portalsheet
local portalredsheet
local watersheet
local HealPadsheet
local ManaPadsheet
local portalbacksheet
local spawnersheet
local lavasheet
local Level
local finish
local walls
local boundary
local mbounds
local Chests
local Destructibles
local Shops
local SmallKey
local LavaBlocks
local KeySpawned
local keytriescount
local OrangePortal
local BluePortal
local RedPortal
local HealPad
local ManaPad
local mapsize
local mobs
local dmobs
local RP
local BP
local OP
local HP
local MP
local Keys
local xinicial
local yinicial
local espacioy
local espaciox
local didStair
local Spawner
local MS
local TSet
local map2
local side

function Essentials()
	espaciox=80
	espacioy=80
	xinicial=304
	yinicial=432
	didStair=false
	HealPad=false
	ManaPad=false
	KeySpawned=false
	OrangePortal=false
	BluePortal=false
	RedPortal=false
	Spawner=false
	Level=display.newGroup()
	dmobs=display.newGroup()
	LavaBlocks={}
	Chests={}
	Shops={}
	Destructibles={}
	boundary={}
	mbounds={}
	walls={}
	mobs={}
	map2={}
	Tiles()
	ui.CleanSlate()
	bkg=ui.Background()
end

function Gen()
	Essentials()
	
	map=handler.GetCMap()
	mapsize=table.maxn( map )
	
	print "Starting Map Generation..."
	
	for i=1, mapsize do
	
		if(map[i]=="r")then
			boundary[i]=1
			mbounds[i]=1
			map2[i]="r"
		end	
		
		if(map[i]=="s")then
			boundary[i]=1
			mbounds[i]=1
			map2[i]="s"
		end
		
		if(map[i]=="o")then
			boundary[i]=0
			mbounds[i]=0
			map2[i]="o"
		end
		
		if(map[i]=="q")then
			boundary[i]=1
			mbounds[i]=0
			map2[i]="q"
		end	
		
		if(map[i]=="d")then
			local canitbreak=math.random(1,10)
			if canitbreak>=7 then
				boundary[i]=1
				mbounds[i]=0
				map2[i]="q"
			else
				boundary[i]=0
				mbounds[i]=0
				map2[i]="o"
			end
		end	
		
		if(map[i]=="b")then
			boundary[i]=0
			mbounds[i]=0
			map2[i]="b"
		end
		
		if(map[i]=="w")then
			boundary[i]=0
			mbounds[i]=0
			map2[i]="w"
		end
		
		if(map[i]=="m")then
			boundary[i]=1
			mbounds[i]=1
			if(OrangePortal==false)then
				OrangePortal=true
				map2[i]="m"
			elseif(OrangePortal==true)then
				map2[i]="x"
			end
		end
		
		if(map[i]=="n")then
			boundary[i]=1
			mbounds[i]=1
			if(BluePortal==false)then
				BluePortal=true
				map2[i]="n"
			elseif(BluePortal==true)then
				map2[i]="x"
			end
		end
	
		if(map[i]=="ñ")then
			boundary[i]=1
			mbounds[i]=1
			if(RedPortal==false)then
				RedPortal=true
				map2[i]="ñ"
			elseif(RedPortal==true)then
				map2[i]="x"
			end
		end
	
		if(map[i]=="u") then
			boundary[i]=1
			mbounds[i]=1
			if Spawner==false then
				Spawner=true
				map2[i]="u"
			elseif Spawner==true then
				map2[i]="x"
			end
		end
		
		if(map[i]=="z")then	
			mbounds[i]=0
			boundary[i]=1
			map2[i]="z"
		end

		if(map[i]=="l")then
			mbounds[i]=0
			boundary[i]=1
			map2[i]="l"
		end	
		
		if(map[i]=="h")then
			mbounds[i]=1
			boundary[i]=1
			if HealPad==false then
				HealPad=true
				map2[i]="h"
			elseif HealPad==true then
				map2[i]="x"
			end
		end
		
		if(map[i]=="j")then
			mbounds[i]=1
			boundary[i]=1
			if ManaPad==false then
				ManaPad=true
				map2[i]="j"
			elseif ManaPad==true then
				map2[i]="x"
			end
		end
		
		if(map[i]=="x")then
			mbounds[i]=1
			boundary[i]=1
			map2[i]="x"
		end
	end
	
	RandomMap()
	
	mbounds[(math.sqrt(mapsize))+2]=1
	boundary[(math.sqrt(mapsize))+2]=1
	
	local CanBeDone=bin.animate(boundary)
	if CanBeDone==false then
		print "Map failed."
		timer.performWithDelay(20,YouShallNowPass)
	else
		print "Map passed."
		DisplayMap()
	end
	
end

function RandomMap()
	local map=handler.GetCMap()
	mapsize=table.maxn( map )
	local OPLoc=nil
	
	print "Starting Map Randomization..."
	
	for i=1, mapsize do
		if (map[i]=="r") then
			if i~=(math.sqrt(mapsize)+2) then
				local TileRoll=math.random(1, 100)
			
				if (TileRoll>=1) and (TileRoll<10) then
					boundary[i]=1
					mbounds[i]=1
					local port=math.random(200,204)
					if (port==200) and OrangePortal==false then
						map2[i]="m"
						OrangePortal=true
						OPLoc=i
					elseif (port==201) and HealPad==false then
						map2[i]="h"
						HealPad=true
					elseif ManaPad==false and (port==202) then
						map2[i]="j"
						ManaPad=true
					elseif Spawner==false and (port==203) then
						map2[i]="u"
						Spawner=true
					elseif (port==204) then
						map2[i]="s"
					elseif OrangePortal==true and BluePortal==false then
						local ThinkinWithPortals=true
						local OZoneX=math.floor(OPLoc%(math.sqrt(mapsize)))
						local OZoneY=math.floor(OPLoc/(math.sqrt(mapsize)))+1
						local OZone=1
						if( OZoneX>(math.sqrt(mapsize))/2 )then
							OZone=OZone+1
						end
						if( OZoneY>(math.sqrt(mapsize))/2 )then
							OZone=OZone+2
						end
						local BZoneX=math.floor(i%(math.sqrt(mapsize)))
						local BZoneY=math.floor(i/(math.sqrt(mapsize)))+1
						local BZone=1
						if( BZoneX>(math.sqrt(mapsize))/2 )then
							BZone=BZone+1
						end
						if( BZoneY>(math.sqrt(mapsize))/2 )then
							BZone=BZone+2
						end
						if BZone==OZone then
							ThinkinWithPortals=false
						end
						if (BZoneX-4)<OZoneX and (BZoneX+4)>OZoneX then
							ThinkinWithPortals=false
						end
						if (BZoneY-4)<OZoneY and (BZoneY+4)>OZoneY then
							ThinkinWithPortals=false
						end
						if ThinkinWithPortals==true then
							map2[i]="n"
							BluePortal=true
						else
							map2[i]="x"
						end
					else
						map2[i]="x"
					end
				end
			
				if (TileRoll>=10) and (TileRoll<15) then
					boundary[i]=1
					mbounds[i]=0
					map2[i]="l"
				end

				if (TileRoll>=15) and (TileRoll<20) then
					boundary[i]=0
					mbounds[i]=0
					map2[i]="w"
				end
				
				if (TileRoll>=20) and (TileRoll<50)then
					local canitbreak=math.random(1,10)
					if canitbreak>=8 then
						boundary[i]=1
						mbounds[i]=0
						map2[i]="q"
					else
						boundary[i]=0
						mbounds[i]=0
						map2[i]="o"
					end
				end
				
				if (TileRoll>=50) then
					boundary[i]=1
					mbounds[i]=1
					map2[i]="x"
				end
			end
		end
	end
	
	if OrangePortal==true and BluePortal==false and RedPortal==false then
		map2[OPLoc]="ñ"
		RedPortal=true
		OrangePortal=false
		OPLoc=nil
	end
end

function Extras()
	
	print "Adding Sprinkles to Map..."
	
	for i=1, mapsize do
		if i~=(math.sqrt(mapsize)+2) then
			if mbounds[i]==1 and KeySpawned==false then
				local isKey=math.random(1,500)
				if isKey>=490 then
					mbounds[i]=0	
					SmallKey=display.newImageRect( "tiles/"..TSet.."/smallkey.png", 80, 80)
					SmallKey.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
					SmallKey.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
					SmallKey.isVisible=false
					SmallKey.loc=(i)
					Level:insert( SmallKey )
					KeySpawned=true
				end
			end
			
			if mbounds[i]==1 then
				local isChest=math.random(1,100)
				if isChest>=90 then
					mbounds[i]=0	
					Chests[i]=display.newImageRect( "tiles/"..TSet.."/treasure.png", 80, 80)
					Chests[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
					Chests[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
					Chests[i].isVisible=false
					Level:insert( Chests[i] )
				end
			end
			
			if mbounds[i]==1 then
				local isMob=math.random(1,30)
				if isMob>28 then
					mobs[i]=display.newImageRect( "tiles/"..TSet.."/mob.png",80,80)
					mobs[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
					mobs[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
					mobs[i].isVisible=false
					mobs[i].loc=(i)
					dmobs:insert( mobs[i] )
				end
			end
			
		end
	end
	
	if KeySpawned==false then
		mbounds[finish.loc]=1
		boundary[finish.loc]=1
	else
		mbounds[finish.loc]=0
		boundary[finish.loc]=0
		Gate=walls[finish.loc]
		Gate=display.newImageRect( "tiles/"..TSet.."/jail.png", 80, 80)
		Gate.x=xinicial+((((finish.loc-1)%math.sqrt(mapsize)))*espaciox)
		Gate.y=yinicial+(math.floor((finish.loc-1)/math.sqrt(mapsize))*espacioy)
		Gate.isVisible=false
		Level:insert( Gate )
	end
end

function DisplayMap()
	local map=handler.GetCMap()
	mapsize=table.maxn( map )
	
	ui.UI()
	
	print "Starting Map Display..."
	
	for i=1, mapsize do
	
		if(map2[i]=="o")then
			local roll=math.random(1,18)
			if roll<=9 then
				roll=1
			elseif roll<=15 then
				roll=2
			elseif roll<=18 then
				roll=3
			end
			walls[i]=display.newImageRect( "tiles/"..TSet.."/wall"..(roll)..".png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
		end
		
		if(map2[i]=="q")then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert(  walls[i] )
			
			Destructibles[i]=display.newSprite(rockbreaksheet,{name="rock",start=1,count=14,time=400,loopCount=1})
			Destructibles[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			Destructibles[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			Destructibles[i].isVisible=false
			Destructibles[i].exist=true
			Level:insert( Destructibles[i] )
		end
		
		if(map2[i]=="b")then
			local roll=math.random(1,18)
			if roll<=9 then
				roll=1
			elseif roll<=15 then
				roll=2
			elseif roll<=18 then
				roll=3
			end
			walls[i]=display.newImageRect( "tiles/"..TSet.."/wall"..(roll)..".png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
		end
		
		if(map2[i]=="w")then
			walls[i]=display.newSprite( watersheet, { name="water", start=1, count=30, time=3000 }  )
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			walls[i]:play()
			Level:insert( walls[i] )
		end
		
		if(map2[i]=="m")then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
			
			OP=display.newSprite( portalsheet, { name="portal", start=1, count=20, time=1750 }  )
			OP.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			OP.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			OP.isVisible=false
			OP:play()
			OP.loc=(i)
			Level:insert( OP )
		end
		
		if(map2[i]=="n")then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
			
			BP=display.newSprite( portalbacksheet, { name="portalback", start=1, count=20, time=1750 }  )
			BP.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			BP.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			BP.isVisible=false
			BP:play()
			BP.loc=(i)
			Level:insert( BP )
		end
	
		if(map2[i]=="ñ")then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
			
			RP=display.newSprite( portalredsheet, { name="portalred", start=1, count=20, time=1750 }  )
			RP.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			RP.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			RP.isVisible=false
			RP:play()
			RP.loc=(i)
			Level:insert( RP )
		end
	
		if(map2[i]=="u") then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
			
			MS=display.newSprite( spawnersheet, { name="mobspawner", start=1, count=20, time=1750 }  )
			MS.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			MS.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			MS.isVisible=false
			MS:play()
			MS.loc=(i)
			Level:insert( MS )
		end
		
		if(map2[i]=="z")then
			local curround=WD.Circle()
			if curround%2==0 then
				if didStair==false then
					finish=walls[i]
					finish=display.newImageRect( "tiles/"..TSet.."/stairup.png", 80, 80)
					finish.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
					finish.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
					finish.isVisible=false
					finish.loc=(i)
					Level:insert( finish )
					didStair=true
				elseif didStair==true then
					walls[i]=display.newImageRect( "tiles/"..TSet.."/stairdown.png", 80, 80)
					walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
					walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
					walls[i].isVisible=false
					Level:insert( walls[i] )
					didStair=false
				end
			else
				if didStair==true then
					finish=walls[i]
					finish=display.newImageRect( "tiles/"..TSet.."/stairup.png", 80, 80)
					finish.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
					finish.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
					finish.isVisible=false
					finish.loc=(i)
					Level:insert( finish )
					didStair=false
				elseif didStair==false then
					walls[i]=display.newImageRect( "tiles/"..TSet.."/stairdown.png", 80, 80)
					walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
					walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
					walls[i].isVisible=false
					Level:insert( walls[i] )
					didStair=true
				end
			end
		end

		if(map2[i]=="l")then
			LavaBlocks[i]=walls[i]
			LavaBlocks[i]=display.newSprite( lavasheet, { name="lava", start=1, count=20, time=4000 }  )
			LavaBlocks[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			LavaBlocks[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			LavaBlocks[i].isVisible=false
			LavaBlocks[i]:play()
			Level:insert( LavaBlocks[i] )
		end	
		
		if(map2[i]=="h")then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
			
			HP=walls[i]
			HP=display.newSprite( HealPadsheet, { name="HP", start=1, count=30, time=2000 }  )
			HP.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			HP.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			HP.isVisible=false
			HP.loc=(i)
			HP:play()
			Level:insert( HP )
		end
		
		if(map2[i]=="j")then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
			
			MP=walls[i]
			MP=display.newSprite( ManaPadsheet, { name="MP", start=1, count=30, time=2000 }  )
			MP.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			MP.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			MP.isVisible=false
			MP.loc=(i)
			MP:play()
			Level:insert( MP )
		end
		
		if(map2[i]=="s")then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
			
			Shops[i]=display.newImageRect( "tiles/"..TSet.."/shop.png", 80, 80)
			Shops[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			Shops[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			Shops[i].isVisible=false
			Level:insert(Shops[i])
		end
		
		if(map2[i]=="x")then
			walls[i]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espaciox)
			walls[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacioy)
			walls[i].isVisible=false
			Level:insert( walls[i] )
		end	
		
	end
	
	
	Level:insert( dmobs )
	Level:toBack()
	bkg:toBack()
	su.Continue()
	Extras()
	mob.ReceiveMobs(mobs)
	q.CreateQuest()
	
	local CurRound=WD.Circle()
	if (RedPortal==true) then
		ui.MapIndicators("RP")
	end
	if (BluePortal==true) then
		ui.MapIndicators("BP")
	end
	if (Spawner==true) then
		ui.MapIndicators("MS")
	end
	if (ManaPad==true) then
		ui.MapIndicators("MP")
	end
	if (HealPad==true) then
		ui.MapIndicators("HP")
	end
	if KeySpawned==false then
		ui.MapIndicators("KEY")
	end
	if not(side)then
		side=false
	end
	if side==true then
		p.PlayerLoc(false)
		if CurRound%2==0 then
			print "Abnormal Progression, Even Floor"
		else
			print "Abnormal Progression, Odd Floor"
			Level.x=Level.x-((math.sqrt(mapsize)-3)*80)
			Level.y=Level.y-((math.sqrt(mapsize)-3)*80)
		end
	elseif side==false then
		p.PlayerLoc(true)
		if CurRound%2==0 then
			print "Normal Progression, Even Floor"
			Level.x=Level.x-((math.sqrt(mapsize)-3)*80)
			Level.y=Level.y-((math.sqrt(mapsize)-3)*80)
		else
			print "Normal Progression, Odd Floor"
		end
	end
	m.ShowArrows()
	print "Map Built."
	
end

function Tiles()
	TSet=handler.GetTiles()
	
	rockbreaksheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/break.png", 
		{ width=80, height=80, numFrames=14 }
	)
	
	portalsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/portalsprite.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	portalredsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/portalredsprite.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	watersheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/watersprite.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	HealPadsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/healpadsprite.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	ManaPadsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/manapadsprite.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	portalbacksheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/portalbacksprite.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	spawnersheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/spawner.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	lavasheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/spritelava.png", 
		{ width=80, height=80, numFrames=20 } 
	)
end

function Show(id)
	if (walls[id]) then
		walls[id].isVisible=true
	end
	if (Destructibles[id]) then
		Destructibles[id].isVisible=true
	end
	if (Shops[id]) then
		Shops[id].isVisible=true
	end
	if (LavaBlocks[id]) then
		LavaBlocks[id].isVisible=true
	end
	if (OrangePortal==true) and (OP.loc==id) then
		OP.isVisible=true
	end
	if (BluePortal==true) and (BP.loc==id) then
		BP.isVisible=true
	end
	if (RedPortal==true) and (RP.loc==id) then
		RP.isVisible=true
	end
	if (Spawner==true) and (MS.loc==id) then
		MS.isVisible=true
	end
	if (ManaPad==true) and (MP.loc==id) then
		MP.isVisible=true
	end
	if (HealPad==true) and (HP.loc==id) then
		HP.isVisible=true
	end
	if (KeySpawned==true) and (SmallKey) and (SmallKey.loc==id) then
		SmallKey.isVisible=true
	end
	for i=1,table.maxn(mobs)do
		if (mobs[i])and (mobs[i].loc==id) then
			mobs[i].isVisible=true
		end
	end
	if (Chests[id]) then
		Chests[id].isVisible=true
	end
	if (finish.loc==id) then
		finish.isVisible=true
		if (Gate) then
			Gate.isVisible=true
		end
	end
end

function YouShallNowPass(val)
	if (val==true) or (val==false) then
		side=val
	end
	
	for i=Level.numChildren,1,-1 do
		display.remove(Level[i])
		Level[i]=nil
	end
	if (Gate) then
		display.remove(Gate)
		Gate=nil
	end
	for i=table.maxn(boundary),1,-1 do
		boundary[i]=nil
	end
	if Level.numChildren==0 and table.maxn(boundary)==0 then
		boundary=nil
		Level=nil
		Gen()
	end
	bkg:toBack()
end

function WipeMap()
	mob.WipeMobs()
	for i=Level.numChildren,1,-1 do
		display.remove(Level[i])
		Level[i]=nil
	end
	bkg:toBack()
end

function TheGates(action)
	if action=="key" then
		return SmallKey
	elseif action=="open" then
		if (SmallKey) then
			display.remove(SmallKey)
			SmallKey=nil
		end
		display.remove(Gate)
		mbounds[finish.loc]=1
		boundary[finish.loc]=1
	end
end

function GetPad(int)
	if int==1 and HealPad==true and (HP) then
		return HP.loc
	elseif int==2 and ManaPad==true and (MP) then
		return MP.loc
	else
		return nil
	end
end

function GetData(val)
	if val==0 then
		return mapsize
	elseif val==1 then
		return boundary
	elseif val==2 then
		return mbounds
	elseif val==3 then
		return Level
	elseif val==4 then
		return LavaBlocks
	elseif val==5 then
		return Chests
	elseif val==6 then
		return Destructibles
	elseif val==7 then
		return Shops
	else
		return walls
	end
end

function GetFinish()
	return finish
end

function GetRedP()
	if RedPortal==true then
		return RP
	else
		return nil
	end
end

function GetMSpawner()
	if Spawner==true then
		return MS
	else
		return nil
	end
end

function GetPortal(Blue)
	if BluePortal==true and OrangePortal==true then
		if Blue==true then 
			return BP
		elseif Blue==false then
			return OP
		end
	else
		return nil
	end
end

