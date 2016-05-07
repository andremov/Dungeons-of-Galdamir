-----------------------------------------------------------------------------------------
--
-- MapBuilder.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local col=require("Ltileevents")
local ui=require("Lui")
local su=require("Lstartup")
local handler=require("Lmaphandler")
local wdow=require("Lwindow")
local mob=require("Lmobai")
local m=require("Lmovement")
local WD=require("Lprogress")
local bin=require("Lgarbage")
local p=require("Lplayers")
local q=require("Lquest")
-- Tile Sprite Sheets
local portalbacksheet
local rockbreaksheet
local EnergyPadsheet
local portalredsheet
local HealPadsheet
local ManaPadsheet
local spawnersheet
local portalsheet
local watersheet
local lavasheet
-- General Map Values
local Destructibles
local LavaBlocks
local WaterBlocks
local boundary
local mbounds
local loadtxt
local Chests
local hidden
local Shops
local Level
local walls
local count
local scale
local map2
local side
local fog
-- Extra Tiles
local OrangePortal
local BluePortal
local EnergyPad
local SmallKey
local Spawner
local HealPad
local ManaPad
local finish
local mobs
-- Extra Tiles other values
local keytriescount
local KeySpawned
local dmobs
local BP
local OP
local HP
local MP
local EP
local MS
local ShopCount
-- Constants
local TileIDsNum=false
local Peaceful=false
local didStair
local xinicial
local yinicial
local espacioy
local espaciox
local mapsize
local TSet

function Essentials()
	ui.CleanSlate()
	scale=1.2
	espacio=80*scale
	xinicial=display.contentCenterX-(espacio)
	yinicial=display.contentCenterY-(espacio)
	ShopCount=0
	OrangePortal=false
	KeySpawned=false
	BluePortal=false
	EnergyPad=false
	RedPortal=false
	didStair=false
	HealPad=false
	ManaPad=false
	Spawner=false
	Level=display.newGroup()
	dmobs=display.newGroup()
	Destructibles={}
	WaterBlocks={}
	LavaBlocks={}
	boundary={}
	mbounds={}
	hidden={}
	Chests={}
	Shops={}
	walls={}
	mobs={}
	fog={}
	if (map2) and (map2[1]=="Map") then
		table.remove(map2,1)
		map2[#map2+1]="Map"
	else
		map2={}
	end
	Tiles()
	bkg=ui.Background()
end

function BuildMap()
	if not(loadtxt)then
		loadtxt=display.newText(("Loading the loading text..."),0,0,"Game Over",120)
		loadtxt.x=display.contentCenterX
		loadtxt.y=display.contentCenterY
	end
	if not(count)then
	--	print "Starting Map Generation..."
		Essentials()
		count=0
	end
	map=handler.GetCMap()
	mapsize=table.maxn( map )
	
	BuildTile()
	
	BuildTile()
	
	BuildTile()
	
	BuildTile()
	
	BuildTile()
	
	if count<mapsize+1 then
		timer.performWithDelay(0.2,BuildMap)
	else
		loadtxt.text=("Testing Map...")
		loadtxt:toFront()
		local CanBeDone=Pathfinding()
		if CanBeDone==false then
			loadtxt.text=("Map Failed.\n   Retrying...")
			loadtxt:toFront()
	--		print "Map failed."
			timer.performWithDelay(500,Rebuild)
		else
			count=0
	--		print "Map passed."
			DisplayMap()
		end
	end
end

function DisplayMap()
	local map=handler.GetCMap()
	mapsize=table.maxn( map )
	
	if (count==0)then
	--	print "Starting Map Display..."
	end
	
	DisplayTile()
	
	DisplayTile()
	
	DisplayTile()
	
	DisplayTile()
	
	DisplayTile()
	
	if count==mapsize then
		loadtxt.text=("Done.")
		loadtxt:toFront()
	end
	
	if count~=mapsize then
		timer.performWithDelay(0.2,DisplayMap)
	else
		mob.ReceiveMobs(mobs)
		local check=su.ShowContinue()
		display.remove(loadtxt)
		loadtxt=nil
		if check==false then
			Level:insert( dmobs )
			Level:toBack()
			bkg:toBack()
			if map2[#map2]=="Map" then
			else
				Extras()
			end
			q.CreateQuest()
			
			local CurRound=WD.Circle()
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
			if (EnergyPad==true) then
				ui.MapIndicators("EP")
			end
			if KeySpawned==false then
				ui.MapIndicators("KEY")
			end
			if not(side)then
				side=false
			end
			if side==true then
				p.PlayerLoc(false)
			--	m.Visibility()
				if CurRound%2==0 then
	--				print "Abnormal Progression, Even Floor"
				else
	--				print "Abnormal Progression, Odd Floor"
					Level.x=Level.x-((math.sqrt(mapsize)-3)*espacio)
					Level.y=Level.y-((math.sqrt(mapsize)-3)*espacio)
				end
			elseif side==false then
				p.PlayerLoc(true)
			--	m.Visibility()
				if CurRound%2==0 then
	--				print "Normal Progression, Even Floor"
					Level.x=Level.x-((math.sqrt(mapsize)-3)*espacio)
					Level.y=Level.y-((math.sqrt(mapsize)-3)*espacio)
				else
	--				print "Normal Progression, Odd Floor"
				end
			end
		end
	--	print "Map Built."
	end
end

function Extras()
	
--	print "Adding Sprinkles to Map..."
	
	for i=1, mapsize do
		if i~=(math.sqrt(mapsize)+2) and map2[i]=="x" then
		
			if mbounds[i]==1 and KeySpawned==false then
				local isKey=math.random(1,500)
				if isKey>=490 then
					mbounds[i]=0	
					SmallKey=display.newImageRect( "tiles/"..TSet.."/smallkey.png", 80, 80)
					SmallKey.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espacio)
					SmallKey.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacio)
					SmallKey.isVisible=false
					SmallKey.loc=(i)
					map2[i]="k"
					SmallKey.xScale=scale
					SmallKey.yScale=SmallKey.xScale
					Level:insert( SmallKey )
					KeySpawned=true
				end
			end
			
			if mbounds[i]==1 then
				local isChest=math.random(1,100)
				if isChest>=90 then
					mbounds[i]=0	
					Chests[i]=display.newImageRect( "tiles/"..TSet.."/treasure.png", 80, 80)
					Chests[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espacio)
					Chests[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacio)
					Chests[i].isVisible=false
					map2[i]="t"
					Chests[i].xScale=scale
					Chests[i].yScale=Chests[i].xScale
					Level:insert( Chests[i] )
				end
			end
			if Peaceful==false then
				if mbounds[i]==1 then
					local isMob=math.random(1,30)
					if isMob>28 then
						mobs[i]=display.newImageRect( "tiles/"..TSet.."/mob.png",80,80)
						mobs[i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espacio)
						mobs[i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacio)
						mobs[i].isVisible=false
						mobs[i].loc=(i)
						map2[i]="-"
						mobs[i].xScale=scale
						mobs[i].yScale=mobs[i].xScale
						dmobs:insert( mobs[i] )
					end
				end
			end
			
		end
	end
	
	if KeySpawned==false then
		mbounds[finish]=1
		boundary[finish]=1
	else
		mbounds[finish]=0
		boundary[finish]=0
		Gate=walls[finish]
		Gate=display.newImageRect( "tiles/"..TSet.."/jail.png", 80, 80)
		Gate.x=xinicial+((((finish-1)%math.sqrt(mapsize)))*espacio)
		Gate.y=yinicial+(math.floor((finish-1)/math.sqrt(mapsize))*espacio)
		Gate.isVisible=false
		Gate.xScale=scale
		Gate.yScale=Gate.xScale
		Level:insert( Gate )
	end
end

function BuildTile()

	count=count+1
	if math.floor((count/mapsize)*100)<10 then
		loadtxt.text=("Generating Map...\n".."             0"..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	else
		loadtxt.text=("Generating Map...\n".."              "..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	end
	
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
			if HealPad==false then
				HealPad=true
				map2[count]="h"
			elseif HealPad==true then
				map2[count]="x"
			end
		end
		
		if(map[count]=="i")then
			mbounds[count]=1
			boundary[count]=1
			if EnergyPad==false then
				EnergyPad=true
				map2[count]="i"
			elseif EnergyPad==true then
				map2[count]="x"
			end
		end
		
		if(map[count]=="j")then
			mbounds[count]=1
			boundary[count]=1
			if ManaPad==false then
				ManaPad=true
				map2[count]="j"
			elseif ManaPad==true then
				map2[count]="x"
			end
		end
		
		if(map[count]=="k")then
			boundary[count]=1
			if KeySpawned==true then
				mbounds[i]=1
				map2[i]="x"
			else
				KeySpawned=true
				map2[i]="k"
				mbounds[i]=0
			end
		end

		if(map[count]=="l")then
			mbounds[count]=0
			boundary[count]=1
			map2[count]="l"
		end	
		
		if(map[count]=="m")then
			boundary[count]=1
			mbounds[count]=1
			if(OrangePortal==false)then
				OrangePortal=true
				OPLoc=count
				map2[count]="m"
			elseif(OrangePortal==true)then
				map2[count]="x"
			end
		end
		
		if(map[count]=="n")then
			boundary[count]=1
			mbounds[count]=1
			if(BluePortal==false)then
				BluePortal=true
				BPLoc=count
				map2[count]="n"
			elseif(BluePortal==true)then
				map2[count]="x"
			end
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
		
		if(map[count]=="s")and(ShopCount~=(mapsize/10)*(mapsize/10))then
			boundary[count]=1
			mbounds[count]=1
			map2[count]="s"
			ShopCount=ShopCount+1
		end
		
		if(map[count]=="t")then
			mbounds[count]=1
			boundary[count]=1
			map2[count]="t"
		end
	
		if(map[count]=="u") then
			boundary[count]=1
			mbounds[count]=1
			if Spawner==false then
				Spawner=true
				map2[count]="u"
			elseif Spawner==true then
				map2[count]="x"
			end
		end
		
		if(map[count]=="w")then
			boundary[count]=1
			mbounds[count]=0
			map2[count]="w"
		end
		
		if(map[count]=="x")then
			mbounds[count]=1
			boundary[count]=1
			map2[count]="x"
		end
		
		if(map[count]=="z")then
			mbounds[count]=0
			boundary[count]=1
			map2[count]="z"
		end
		
	elseif count~=mapsize+1 then
		
		if(map2[count]=="b")then
			boundary[count]=0
			mbounds[count]=0
		end
		
		if(map2[count]=="h")then
			mbounds[count]=1
			boundary[count]=1
			HealPad=true
		end
		
		if(map2[count]=="i")then
			mbounds[count]=1
			boundary[count]=1
			EnergyPad=true
		end
		
		if(map2[count]=="j")then
			mbounds[count]=1
			boundary[count]=1
			ManaPad=true
		end
		
		if(map2[count]=="k")then
			boundary[count]=1
			mbounds[i]=0
			KeySpawned=true
		end

		if(map2[count]=="l")then
			mbounds[count]=0
			boundary[count]=1
		end	
		
		if(map2[count]=="m")then
			boundary[count]=1
			mbounds[count]=1
			OrangePortal=true
		end
		
		if(map2[count]=="n")then
			boundary[count]=1
			mbounds[count]=1
			BluePortal=true
			map2[count]="n"
		end
	
		if(map2[count]=="ñ")then
			boundary[count]=1
			mbounds[count]=1
			RedPortal=true
			map2[count]="ñ"
		end
		
		if(map2[count]=="o")then
			boundary[count]=0
			mbounds[count]=0
		end
		
		if(map2[count]=="q")then
			boundary[count]=1
			mbounds[count]=0
		end
		
		if(map2[count]=="s")then
			boundary[count]=1
			mbounds[count]=1
			ShopCount=ShopCount+1
		end
		
		if(map2[count]=="t")then
			boundary[count]=1
			mbounds[count]=1
		end
	
		if(map2[count]=="u") then
			boundary[count]=1
			mbounds[count]=1
			Spawner=true
		end
		
		if(map2[count]=="w")then
			boundary[count]=1
			mbounds[count]=0
		end
		
		if(map2[count]=="x")then
			mbounds[count]=1
			boundary[count]=1
		end
		
		if(map2[count]=="z")then
			mbounds[count]=0
			boundary[count]=1
		end
		
	end
	
	RandomizeTile()
end

function RandomizeTile()
	local map=handler.GetCMap()
	mapsize=table.maxn( map )
	
	if count==1 then
	--	print "Starting Map Randomization..."
	end
	
	if count~=mapsize+1 and not(map2[count]) then
		if (map[count]=="r") then
			if i~=(math.sqrt(mapsize)+2) then
				local TileRoll=math.random(1, 100)
			
				if (TileRoll>=1) and (TileRoll<10) then
					boundary[count]=1
					mbounds[count]=1
					local port=math.random(200,205)
					if OrangePortal==false and (port==200) then
						map2[count]="m"
						OrangePortal=true
						OPLoc=count
					elseif HealPad==false and (port==201) then
						map2[count]="h"
						HealPad=true
					elseif ManaPad==false and (port==202) then
						map2[count]="j"
						ManaPad=true
					elseif Spawner==false and (port==203) then
						map2[count]="u"
						Spawner=true
					elseif EnergyPad==false and (port==204) then
						map2[count]="i"
						EnergyPad=true
					elseif (port==205) and (ShopCount~=((math.sqrt(mapsize))/10)*((math.sqrt(mapsize))/10)) then
						local TimeIsMoney=true
						for i=1,mapsize do
							if map2[i]=="s" then
								local SZoneX=math.floor(i%(math.sqrt(mapsize)))
								local SZoneY=math.floor(i/(math.sqrt(mapsize)))+1
								local SZone=1
								if( SZoneX>(math.sqrt(mapsize))/2 )then
									SZone=SZone+1
								end
								if( SZoneY>(math.sqrt(mapsize))/2 )then
									SZone=SZone+2
								end
								local CZoneX=math.floor(count%(math.sqrt(mapsize)))
								local CZoneY=math.floor(count/(math.sqrt(mapsize)))+1
								local CZone=1
								if( CZoneX>(math.sqrt(mapsize))/2 )then
									CZone=CZone+1
								end
								if( CZoneY>(math.sqrt(mapsize))/2 )then
									CZone=CZone+2
								end
								if CZone==SZone then
									TimeIsMoney=false
								end
							end
						end
						
						if TimeIsMoney==true then
							map2[count]="s"
							ShopCount=ShopCount+1
						else
							map2[count]="x"
						end
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
						local BZoneX=math.floor(count%(math.sqrt(mapsize)))
						local BZoneY=math.floor(count/(math.sqrt(mapsize)))+1
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
							map2[count]="n"
							BluePortal=true
							BPLoc=count
						else
							map2[count]="x"
						end
					else
						map2[count]="x"
					end
				end
			
				if (TileRoll>=10) and (TileRoll<15) then
					boundary[count]=1
					mbounds[count]=0
					map2[count]="l"
				end

				if (TileRoll>=15) and (TileRoll<20) then
					boundary[count]=1
					mbounds[count]=0
					map2[count]="w"
				end
				
				if (TileRoll>=20) and (TileRoll<50)then
					local canitbreak=math.random(1,10)
					if canitbreak>=8 then
						boundary[count]=1
						mbounds[count]=0
						map2[count]="q"
					else
						boundary[count]=0
						mbounds[count]=0
						map2[count]="o"
					end
				end
				
				if (TileRoll>=50) then
					boundary[count]=1
					mbounds[count]=1
					map2[count]="x"
				end
			end
		end
	end
	
	if count~=mapsize+1 then
	else
		local sz=math.sqrt(mapsize)
		if OrangePortal==true and (OPLoc) then
			if boundary[OPLoc+1]==0 and boundary[OPLoc-1]==0 and boundary[OPLoc-sz]==0 and boundary[OPLoc+sz]==0 then
				OrangePortal=false
				map2[OPLoc]="o"
				OPLoc=nil
			end
		end
		if BluePortal==true and (BPLoc) then
			if boundary[BPLoc+1]==0 and boundary[BPLoc-1]==0 and boundary[BPLoc-sz]==0 and boundary[BPLoc+sz]==0 then
				BluePortal=false
				map2[BPLoc]="o"
				BPLoc=nil
			end
		end
		if (OPLoc) and OrangePortal==true and BluePortal==false then
			map2[OPLoc]="x"
			OrangePortal=false
			OPLoc=nil
		end
	end
end

function DisplayTile()
	count=count+1
	if math.floor((count/mapsize)*100)<10 then
		loadtxt.text=("Displaying Map...\n".."            0"..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	else
		loadtxt.text=("Displaying Map...\n".."             "..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	end
	if TileIDsNum==true then
		num={}
	end
	
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
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
		end
		
		if(map2[count]=="h")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			HP=walls[count]
			HP=display.newSprite( HealPadsheet, { name="HP", start=1, count=30, time=2000 }  )
			HP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			HP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			HP.isVisible=false
			HP.loc=(count)
			HP.xScale=scale
			HP.yScale=HP.xScale
			Level:insert( HP )
		end
		
		if(map2[count]=="i")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			EP=walls[count]
			EP=display.newSprite( EnergyPadsheet, { name="EP", start=1, count=30, time=2000 }  )
			EP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			EP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			EP.isVisible=false
			EP.loc=(count)
			EP.xScale=scale
			EP.yScale=EP.xScale
			Level:insert( EP )
		end
		
		if(map2[count]=="j")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			MP=walls[count]
			MP=display.newSprite( ManaPadsheet, { name="MP", start=1, count=30, time=2000 }  )
			MP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			MP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			MP.isVisible=false
			MP.loc=(count)
			MP.xScale=scale
			MP.yScale=MP.xScale
			Level:insert( MP )
		end
		
		if(map2[count]=="k")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			SmallKey=display.newImageRect( "tiles/"..TSet.."/smallkey.png", 80, 80)
			SmallKey.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			SmallKey.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			SmallKey.isVisible=false
			SmallKey.loc=(count)
			SmallKey.xScale=scale
			SmallKey.yScale=SmallKey.xScale
			Level:insert( SmallKey )
		end
		
		if(map2[count]=="l")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			LavaBlocks[count]=walls[count]
			LavaBlocks[count]=display.newSprite( lavasheet, { name="lava", start=1, count=20, time=4000 }  )
			LavaBlocks[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			LavaBlocks[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			LavaBlocks[count].isVisible=false
			LavaBlocks[count].xScale=scale
			LavaBlocks[count].yScale=LavaBlocks[count].xScale
			Level:insert( LavaBlocks[count] )
		end	
		
		if(map2[count]=="m")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			OP=display.newSprite( portalsheet, { name="portal", start=1, count=20, time=1750 }  )
			OP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			OP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			OP.isVisible=false
			OP.loc=(count)
			OP.xScale=scale
			OP.yScale=OP.xScale
			Level:insert( OP )
		end
		
		if(map2[count]=="n")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			BP=display.newSprite( portalbacksheet, { name="portalback", start=1, count=20, time=1750 }  )
			BP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			BP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			BP.isVisible=false
			BP.loc=(count)
			BP.xScale=scale
			BP.yScale=BP.xScale
			Level:insert( BP )
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
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
		end
		
		if(map2[count]=="q")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert(  walls[count] )
			
			Destructibles[count]=display.newSprite(rockbreaksheet,{name="rock",start=1,count=14,time=400,loopCount=1})
			Destructibles[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			Destructibles[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Destructibles[count].isVisible=false
			Destructibles[count].exist=true
			Destructibles[count].xScale=scale
			Destructibles[count].yScale=Destructibles[count].xScale
			Level:insert( Destructibles[count] )
		end
		
		if(map2[count]=="s")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			Shops[count]=display.newImageRect( "tiles/"..TSet.."/shop.png", 80, 80)
			Shops[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			Shops[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Shops[count].isVisible=false
			Shops[count].xScale=scale
			Shops[count].yScale=Shops[count].xScale
			Level:insert(Shops[count])
		end
		
		if(map2[count]=="t")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			Chests[count]=walls[count]
			Chests[count]=display.newImageRect( "tiles/"..TSet.."/treasure.png", 80, 80)
			Chests[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			Chests[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Chests[count].isVisible=false
			Chests[count].xScale=scale
			Chests[count].yScale=Chests[count].xScale
			Level:insert( Chests[count] )
		end
		
		if(map2[count]=="u") then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			MS=display.newSprite( spawnersheet, { name="mobspawner", start=1, count=20, time=1750 }  )
			MS.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			MS.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			MS.isVisible=false
			MS.loc=(count)
			MS.xScale=scale
			MS.yScale=MS.xScale
			Level:insert( MS )
		end
		
		if(map2[count]=="w")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
			
			WaterBlocks[count]=walls[count]
			WaterBlocks[count]=display.newSprite( watersheet, { name="water", start=1, count=30, time=3000 }  )
			WaterBlocks[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			WaterBlocks[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			WaterBlocks[count].isVisible=false
			WaterBlocks[count].xScale=scale
			WaterBlocks[count].yScale=WaterBlocks[count].xScale
			Level:insert( WaterBlocks[count] )
		end
		
		if(map2[count]=="x")then
			walls[count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[count].isVisible=false
			walls[count].xScale=scale
			walls[count].yScale=walls[count].xScale
			Level:insert( walls[count] )
		end	
		
		if(map2[count]=="z")then
			local curround=WD.Circle()
			if didStair==false then
				walls[count]=walls[count]
				walls[count]=display.newImageRect( "tiles/"..TSet.."/stairup.png", 80, 80)
				walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
				walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
				walls[count].isVisible=false
				walls[count].xScale=scale
				walls[count].yScale=walls[count].xScale
				Level:insert( walls[count] )
				didStair=true
				if curround%2==0  then
					finish=(count)
				end
			elseif didStair==true then
				walls[count]=display.newImageRect( "tiles/"..TSet.."/stairdown.png", 80, 80)
				walls[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
				walls[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
				walls[count].isVisible=false
				walls[count].xScale=scale
				walls[count].yScale=walls[count].xScale
				Level:insert( walls[count] )
				didStair=false
				if curround%2~=0  then
					finish=(count)
				end
			end
		end
		
		fog[count]=display.newImageRect( "tiles/"..TSet.."/fog.png", 80, 80)
		fog[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
		fog[count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
		fog[count].isVisible=false
		fog[count].xScale=scale
		fog[count].yScale=fog[count].xScale
		Level:insert( fog[count] )
		
		if TileIDsNum==true then
			local NZoneX=math.floor(count%(math.sqrt(mapsize)))
			local NZoneY=math.floor(count/(math.sqrt(mapsize)))+1
			local NZone=1
			if( NZoneX>(math.sqrt(mapsize))/2 )then
				NZone=NZone+1
			end
			if( NZoneY>(math.sqrt(mapsize))/2 )then
				NZone=NZone+2
			end
			
			num[count]=display.newText( (NZone.."-"..count),0,0,"MoolBoran",40 )
			num[count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			num[count].y=yinicial+10+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Level:insert( num[count] )
		end
		
	end
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
	
	EnergyPadsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/energypadsprite.png", 
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

function Show(IDs)
	for i in pairs(hidden) do
		hidden[i]=nil
		fog[i].isVisible=true
		fog[i]:toFront()
		for m in pairs(mobs)do
			if (mobs[m].loc==i) then
	--			print ("HIDING "..mobs[m].loc)
				mobs[m].isVisible=false
			end
		end
		if (LavaBlocks[i]) then
			LavaBlocks[i]:pause()
		end
		if (WaterBlocks[i]) then
			WaterBlocks[i]:pause()
		end
		if (OrangePortal==true) and (OP.loc==i) then
			OP:pause()
		end
		if (BluePortal==true) and (BP.loc==i) then
			BP:pause()
		end
		if (RedPortal==true) and (RP.loc==i) then
			RP:pause()
		end
		if (Spawner==true) and (MS.loc==i) then
			MS:pause()
		end
		if (ManaPad==true) and (MP.loc==i) then
			MP:pause()
		end
		if (HealPad==true) and (HP.loc==i) then
			HP:pause()
		end
		if (EnergyPad==true) and (EP.loc==i) then
			EP:pause()
		end
	end
	for i in pairs(IDs) do
		if (fog[i]) then
			fog[i].isVisible=false
			hidden[i]=true
		end
		if (walls[i]) then
			walls[i].isVisible=true
		end
		if (Destructibles[i]) then
			Destructibles[i].isVisible=true
		end
		if (Shops[i]) then
			Shops[i].isVisible=true
		end
		if (LavaBlocks[i]) then
			LavaBlocks[i].isVisible=true
			LavaBlocks[i]:play()
		end
		if (WaterBlocks[i]) then
			WaterBlocks[i].isVisible=true
			WaterBlocks[i]:play()
		end
		if (OrangePortal==true) and (OP.loc==i) then
			OP.isVisible=true
			OP:play()
		end
		if (BluePortal==true) and (BP.loc==i) then
			BP.isVisible=true
			BP:play()
		end
		if (RedPortal==true) and (RP.loc==i) then
			RP.isVisible=true
			RP:play()
		end
		if (Spawner==true) and (MS.loc==i) then
			MS.isVisible=true
			MS:play()
		end
		if (ManaPad==true) and (MP.loc==i) then
			MP.isVisible=true
			MP:play()
		end
		if (HealPad==true) and (HP.loc==i) then
			HP.isVisible=true
			HP:play()
		end
		if (EnergyPad==true) and (EP.loc==i) then
			EP.isVisible=true
			EP:play()
		end
		if (KeySpawned==true) and (SmallKey) and (SmallKey.loc==i) then
			SmallKey.isVisible=true
		end
		for m=1,table.maxn(mobs)do
			if (mobs[m])and (mobs[m].loc==i) then
				mobs[m].isVisible=true
			end
		end
		if (Chests[i]) then
			Chests[i].isVisible=true
		end
		if (finish==i) and (Gate) then
			Gate.isVisible=true
		end
	end
	local canArr=wdow.OpenWindow()
	if canArr==false then
		m.ShowArrows()
	end
end

function Rebuild(val)
	if (val==true) or (val==false) then
		side=val
	end
	for i=table.maxn(boundary),1,-1 do
		boundary[i]=nil
	end
	WipeMap()
	if not(Level)and not(boundary)and not(count) then
		BuildMap()
	end
	bkg:toBack()
end

function WipeMap()
	mob.WipeMobs()
	if (Level) then
		for i=Level.numChildren,1,-1 do
			display.remove(Level[i])
			Level[i]=nil
		end
	end
	if (dmobs) then
		for i=Level.numChildren,1,-1 do
			display.remove(Level[i])
			Level[i]=nil
		end
	end
	dmobs=nil
	boundary=nil
	Level=nil
	count=nil
	bkg:toBack()
end

function Pathfinding(start,finish)
	tiles={}
	done={}
	if (start) and type(start)=="number" then
		tiles[start]=1
		done[start]=false
	else
		tiles[math.sqrt(mapsize)+2]=1
		done[math.sqrt(mapsize)+2]=false
	end
	if (finish) and type(finish)=="number" then
		target=finish
	else
		target=mapsize-(math.sqrt(mapsize)+1)
	end
	postiles={}
	isDone=false
	while isDone==false do
		for i in pairs(tiles) do
			if done[i]==false then
				local col=math.floor((i-1)%math.sqrt(mapsize))
				local row=math.floor((i-1)/math.sqrt(mapsize))
				if boundary[i+math.sqrt(mapsize)]==1 then
					postiles[#postiles+1]=i+math.sqrt(mapsize)
				end
				if boundary[i+1]==1 then
					postiles[#postiles+1]=i+1
				end
				if boundary[i-math.sqrt(mapsize)]==1 then
					postiles[#postiles+1]=i-math.sqrt(mapsize)
				end
				if boundary[i-1]==1 then
					postiles[#postiles+1]=i-1
				end
				--Overwrite check
				for s in pairs(tiles) do
					for p=table.maxn(postiles),1,-1 do
						if postiles[p]==s then
							table.remove(postiles,p)
						end
					end
				end
				if (table.maxn(postiles)~=0) then
					for i=1,table.maxn(postiles) do
						tiles[postiles[i]]=1
						done[postiles[i]]=false
					end
					for p=table.maxn(postiles),1,-1 do
						table.remove(postiles,p)
					end
				else
					done[i]=true
				end
			end
			isDone=true
			for i in pairs(done) do
				if done[i]~=true then
					isDone=false
				end
			end
		end
	end
	local canDo=false
	for t in pairs(tiles) do
		if target==t then
			canDo=true
		end
	end
	if canDo==false then
		if BPLoc and OPLoc then
			local isBP=false
			local isOP=false
			for t in pairs(tiles) do
				if BPLoc==t then
					isBP=true
				end
			end
			for t in pairs(tiles) do
				if OPLoc==t then
					isOP=true
				end
			end
			local portDo=false
			if isOP==true and isBP==true then
				portDo=false
			elseif isOP==true and isBP==false then
				portDo=Pathfinding(BPLoc)
			elseif isOP==false and isBP==true then
				portDo=Pathfinding(OPLoc)
			else
				portDo=false
			end
			canDo=portDo
		end
	end
	return canDo
	--[[
		steps={}
		curpos=math.sqrt(mapsize)+2
		posmoves={}
		closed={}
		
		while curpos~=true and curpos~=false do
			if curpos==target then
				curpos=true
			else
				if boundary[curpos+math.sqrt(mapsize)]==1 then
					posmoves[#posmoves+1]=curpos+math.sqrt(mapsize)
				end
				if boundary[curpos+1]==1 then
					posmoves[#posmoves+1]=curpos+1
				end
				if boundary[curpos-math.sqrt(mapsize)]==1 then
					posmoves[#posmoves+1]=curpos-math.sqrt(mapsize)
				end
				if boundary[curpos-1]==1 then
					posmoves[#posmoves+1]=curpos-1
				end
				for s=1,table.maxn(steps)do
					for p=table.maxn(posmoves),1,-1 do
						if posmoves[p]==steps[s] then
							table.remove(posmoves,p)
						end
					end
				end
				for d=1,table.maxn(closed)do
					for p=table.maxn(posmoves),1,-1 do
						if posmoves[p]==closed[d] then
							table.remove(posmoves,p)
						end
					end
				end
				if (posmoves[1]) then
					steps[#steps+1]=curpos
					curpos=posmoves[1]
					for p=table.maxn(posmoves),1,-1 do
						table.remove(posmoves,p)
					end
				elseif (steps[#steps]) then
					closed[#closed+1]=curpos
					curpos=steps[#steps]
					table.remove(steps,table.maxn(steps))
					for p=table.maxn(posmoves),1,-1 do
						table.remove(posmoves,p)
					end
				else
					curpos=false
				end
			end
		end
		return curpos
	--]]
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
		mbounds[finish]=1
		boundary[finish]=1
	end
end

function GetPad(int)
	if int==1 and HealPad==true and (HP) then
		return HP.loc
	elseif int==2 and ManaPad==true and (MP) then
		return MP.loc
	elseif int==3 and EnergyPad==true and (EP) then
		return EP.loc
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
	elseif val==8 then
		return map2
	elseif val==9 then
		return WaterBlocks
	elseif val==10 then
		return fog
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

function ModMap(id)
	map2[id]="x"
end

function ReceiveMap(value)
	map2=value
end
