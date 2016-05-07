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
local TileIDsNum=true
local Peaceful=true
local didStair
local xinicial
local yinicial
local espacio
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
	Level.x=Level.x+xinicial
	Level.y=Level.y+yinicial
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
	room={}
	fog={}
	if TileIDsNum==true then
		num={}
	end
	local round=WD.Circle()
--	rooms=math.floor(math.random(round/2,round))
	rooms=2
	if rooms<1 then
		rooms=1
	elseif rooms>25 then
		rooms=25
	end
	curroom=1
	roomid=1
	layout={
		1,0,0,0,0,
		0,0,0,0,0,
		0,0,0,0,0,
		0,0,0,0,0,
		0,0,0,0,0,
	}
	for i=2,rooms do
		local posrooms={}
		for r=1,table.maxn(layout)do
			if layout[r]==1 then
				if layout[r+1]==0 then
					posrooms[#posrooms+1]=r+1
				end
				if layout[r+5]==0 then
					posrooms[#posrooms+1]=r+5
				end
			end
		end
		local chosen=math.random(1,table.maxn(posrooms))
		layout[posrooms[chosen]]=1
	end
	for r=1,table.maxn(layout) do
		if layout[r]==1 then
			room[r]={}
			Destructibles[r]={}
			WaterBlocks[r]={}
			LavaBlocks[r]={}
			boundary[r]={}
			mbounds[r]={}
			hidden[r]={}
			Chests[r]={}
			Shops[r]={}
			walls[r]={}
			mobs[r]={}
			fog[r]={}
			if TileIDsNum==true then
				num[r]={}
			end
		else
			room[r]=false
		end
	end
	--[[
	if (map2) and (map2[1]=="Map") then
		table.remove(map2,1)
		map2[#map2+1]="Map"
	else
		map2={}
	end]]
	Tiles()
	bkg=ui.Background()
	print (layout[1].." "..layout[2].." "..layout[3].." "..layout[4].." "..layout[5])
	print (layout[6].." "..layout[7].." "..layout[8].." "..layout[9].." "..layout[10])
	print (layout[11].." "..layout[12].." "..layout[13].." "..layout[14].." "..layout[15])
	print (layout[16].." "..layout[17].." "..layout[18].." "..layout[19].." "..layout[20])
	print (layout[21].." "..layout[22].." "..layout[23].." "..layout[24].." "..layout[25])
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
	
	if room[curroom]~=false and curroom<table.maxn(layout)+1 then
		BuildTile()
		BuildTile()
		BuildTile()
		BuildTile()
		BuildTile()
	elseif curroom==table.maxn(layout)+1 then
		count=mapsize+1
	else
		curroom=curroom+1
	end
	
	if count<mapsize+1 then
		timer.performWithDelay(0.2,BuildMap)
	else
		if curroom~=table.maxn(layout)+1  then
			count=0
			curroom=curroom+1
			timer.performWithDelay(0.2,BuildMap)
		else
			loadtxt.text=("Testing Map...")
			loadtxt:toFront()
			local CanBeDone=Pathfinding()
			if CanBeDone==false then
		--		print "Map failed."
				loadtxt.text=("Map Failed.\n   Retrying...")
				loadtxt:toFront()
				timer.performWithDelay(500,Rebuild)
			else
		--		print "Map passed."
				count=0
				curroom=1
				DisplayMap()
			end
		end
	end
end

function DisplayMap()
	if (count==0)then
	--	print "Starting Map Display..."
	end
	local map=handler.GetCMap()
	mapsize=table.maxn( map )
	xinicial=math.floor((curroom-1)%5)*(math.sqrt(mapsize)*espacio)
	yinicial=math.floor((curroom-1)/5)*(math.sqrt(mapsize)*espacio)
	
	if room[curroom]~=false and curroom<table.maxn(layout)+1 then
		DisplayTile()
		DisplayTile()
		DisplayTile()
		DisplayTile()
		DisplayTile()
	elseif curroom==table.maxn(layout)+1 then
		count=mapsize
	else
		curroom=curroom+1
	end
	
	if count~=mapsize then
		timer.performWithDelay(0.2,DisplayMap)
	else
		if curroom~=table.maxn(layout)+1  then
			count=0
			curroom=curroom+1
			timer.performWithDelay(0.2,DisplayMap)
		else
			loadtxt.text=("Done.")
			loadtxt:toFront()
			mob.ReceiveMobs(mobs)
			local check=su.ShowContinue()
			display.remove(loadtxt)
			loadtxt=nil
			if check==false then
				Level:insert( dmobs )
				Level:toBack()
				bkg:toBack()
		--		if map2[#map2]=="Map" then
		--		else
					Extras()
		--		end
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
					--	print "Abnormal Progression, Even Floor"
					else
					--	print "Abnormal Progression, Odd Floor"
						Level.x=Level.x-((math.sqrt(mapsize)-3)*espacio)
						Level.y=Level.y-((math.sqrt(mapsize)-3)*espacio)
					end
				elseif side==false then
					p.PlayerLoc(true)
				--	m.Visibility()
					if CurRound%2==0 then
					--	print "Normal Progression, Even Floor"
						Level.x=Level.x-((math.sqrt(mapsize)-3)*espacio)
						Level.y=Level.y-((math.sqrt(mapsize)-3)*espacio)
					else
					--	print "Normal Progression, Odd Floor"
					end
				end
			end
		--	print "Map Built."
		end
	end
end

function Extras()
--	print "Adding Sprinkles to Map..."
	for r=1,25 do
		if layout[r]==1 then
			local map=handler.GetCMap()
			mapsize=table.maxn( map )
			for i=1, mapsize do
				if i~=(math.sqrt(mapsize)+2) and room[r][i]=="x" then
				
					if mbounds[r][i]==1 and KeySpawned==false then
						local isKey=math.random(1,500)
						if isKey>=490 then
							mbounds[r][i]=0	
							SmallKey=display.newImageRect( "tiles/"..TSet.."/smallkey.png", 80, 80)
							SmallKey.x=xinicial+((((i-1)%math.sqrt(mapsize)))*espacio)
							SmallKey.y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacio)
							SmallKey.isVisible=false
							SmallKey.loc=(i)
							room[r][i]="k"
							SmallKey.xScale=scale
							SmallKey.yScale=SmallKey.xScale
							Level:insert( SmallKey )
							KeySpawned=true
						end
					end
					
					if mbounds[r][i]==1 then
						local isChest=math.random(1,100)
						if isChest>=90 then
							mbounds[r][i]=0	
							Chests[r][i]=display.newImageRect( "tiles/"..TSet.."/treasure.png", 80, 80)
							Chests[r][i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espacio)
							Chests[r][i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacio)
							Chests[r][i].isVisible=false
							room[r][i]="t"
							Chests[r][i].xScale=scale
							Chests[r][i].yScale=Chests[r][i].xScale
							Level:insert( Chests[r][i] )
							print (r)
							print (i)
						end
					end
					
					if Peaceful==false then
						if mbounds[r][i]==1 then
							local isMob=math.random(1,30)
							if isMob>28 then
								mobs[r][i]=display.newImageRect( "tiles/"..TSet.."/mob.png",80,80)
								mobs[r][i].x=xinicial+((((i-1)%math.sqrt(mapsize)))*espacio)
								mobs[r][i].y=yinicial+(math.floor((i-1)/math.sqrt(mapsize))*espacio)
								mobs[r][i].isVisible=false
								mobs[r][i].loc=(i)
								mobs[r][i].room=(r)
								room[r][i]="-"
								mobs[r][i].xScale=scale
								mobs[r][i].yScale=mobs[r][i].xScale
								dmobs:insert( mobs[r][i] )
							end
						end
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
		loadtxt.text=("Generating Room "..curroom.."...\n".."             0"..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	else
		loadtxt.text=("Generating Room "..curroom.."...\n".."              "..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	end
	
	if count~=mapsize+1 and not(room[curroom][count]) then
	
		if(map[count]=="b")then
			boundary[curroom][count]=0
			mbounds[curroom][count]=0
			room[curroom][count]="b"
		end
		
		if(map[count]=="1")then
			if (room[curroom-5]) and room[curroom-5]~=false then
				boundary[curroom][count]=1
				mbounds[curroom][count]=1
				room[curroom][count]="x"
			else
				boundary[curroom][count]=0
				mbounds[curroom][count]=0
				room[curroom][count]="b"
			end
		end
		
		if(map[count]=="2")then
			if (room[curroom-1]) and room[curroom-1]~=false then
				boundary[curroom][count]=1
				mbounds[curroom][count]=1
				room[curroom][count]="x"
			else
				boundary[curroom][count]=0
				mbounds[curroom][count]=0
				room[curroom][count]="b"
			end
		end
		
		if(map[count]=="3")then
			if (room[curroom+1]) and room[curroom+1]~=false then
				boundary[curroom][count]=1
				mbounds[curroom][count]=1
				room[curroom][count]="x"
			else
				boundary[curroom][count]=0
				mbounds[curroom][count]=0
				room[curroom][count]="b"
			end
		end
		
		if(map[count]=="4")then
			if (room[curroom+5]) and room[curroom+5]~=false then
				boundary[curroom][count]=1
				mbounds[curroom][count]=1
				room[curroom][count]="x"
			else
				boundary[curroom][count]=0
				mbounds[curroom][count]=0
				room[curroom][count]="b"
			end
		end
		
		if(map[count]=="d")then
			local canitbreak=math.random(1,10)
			if canitbreak>=7 then
				boundary[curroom][count]=1
				mbounds[curroom][count]=0
				room[curroom][count]="q"
			else
				boundary[curroom][count]=0
				mbounds[curroom][count]=0
				room[curroom][count]="o"
			end
		end	
		
		if(map[count]=="h")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
			if HealPad==false then
				HealPad=true
				room[curroom][count]="h"
			elseif HealPad==true then
				room[curroom][count]="x"
			end
		end
		
		if(map[count]=="i")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
			if EnergyPad==false then
				EnergyPad=true
				room[curroom][count]="i"
			elseif EnergyPad==true then
				room[curroom][count]="x"
			end
		end
		
		if(map[count]=="j")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
			if ManaPad==false then
				ManaPad=true
				room[curroom][count]="j"
			elseif ManaPad==true then
				room[curroom][count]="x"
			end
		end
		
		if(map[count]=="k")then
			boundary[curroom][count]=1
			if KeySpawned==true then
				mbounds[curroom][count]=1
				room[curroom][count]="x"
			else
				KeySpawned=true
				room[curroom][count]="k"
				mbounds[curroom][count]=0
			end
		end

		if(map[count]=="l")then
			mbounds[curroom][count]=0
			boundary[curroom][count]=1
			room[curroom][count]="l"
		end	
		
		if(map[count]=="m")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			if(OrangePortal==false)then
				OrangePortal=true
				OPLoc=count
				room[curroom][count]="m"
			elseif(OrangePortal==true)then
				room[curroom][count]="x"
			end
		end
		
		if(map[count]=="n")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			if(BluePortal==false)then
				BluePortal=true
				BPLoc=count
				room[curroom][count]="n"
			elseif(BluePortal==true)then
				room[curroom][count]="x"
			end
		end
		
		if(map[count]=="o")then
			boundary[curroom][count]=0
			mbounds[curroom][count]=0
			room[curroom][count]="o"
		end
		
		if(map[count]=="q")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=0
			room[curroom][count]="q"
		end	
		
		if(map[count]=="s")and(ShopCount~=(mapsize/10)*(mapsize/10))then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			room[curroom][count]="s"
			ShopCount=ShopCount+1
		end
		
		if(map[count]=="t")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
			room[curroom][count]="t"
		end
	
		if(map[count]=="u") then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			if Spawner==false then
				Spawner=true
				room[curroom][count]="u"
			elseif Spawner==true then
				room[curroom][count]="x"
			end
		end
		
		if(map[count]=="w")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=0
			room[curroom][count]="w"
		end
		
		if(map[count]=="x")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
			room[curroom][count]="x"
		end
		
		if(map[count]=="z")then
			mbounds[curroom][count]=0
			boundary[curroom][count]=1
			room[curroom][count]="z"
		end
		
	elseif count~=mapsize+1 then
		
		if(room[curroom][count]=="b")then
			boundary[curroom][count]=0
			mbounds[curroom][count]=0
		end
		
		if(room[curroom][count]=="h")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
			HealPad=true
		end
		
		if(room[curroom][count]=="i")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
			EnergyPad=true
		end
		
		if(room[curroom][count]=="j")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
			ManaPad=true
		end
		
		if(room[curroom][count]=="k")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=0
			KeySpawned=true
		end

		if(room[curroom][count]=="l")then
			mbounds[curroom][count]=0
			boundary[curroom][count]=1
		end	
		
		if(room[curroom][count]=="m")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			OrangePortal=true
		end
		
		if(room[curroom][count]=="n")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			BluePortal=true
			room[curroom][count]="n"
		end
	
		if(room[curroom][count]=="ñ")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			RedPortal=true
			room[curroom][count]="ñ"
		end
		
		if(room[curroom][count]=="o")then
			boundary[curroom][count]=0
			mbounds[curroom][count]=0
		end
		
		if(room[curroom][count]=="q")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=0
		end
		
		if(room[curroom][count]=="s")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			ShopCount=ShopCount+1
		end
		
		if(room[curroom][count]=="t")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
		end
	
		if(room[curroom][count]=="u") then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			Spawner=true
		end
		
		if(room[curroom][count]=="w")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=0
		end
		
		if(room[curroom][count]=="x")then
			mbounds[curroom][count]=1
			boundary[curroom][count]=1
		end
		
		if(room[curroom][count]=="z")then
			mbounds[curroom][count]=0
			boundary[curroom][count]=1
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
	
	if count~=mapsize+1 and not(room[curroom][count]) then
		if (map[curroom][count]=="r") then
			if i~=(math.sqrt(mapsize)+2) then
				local TileRoll=math.random(1, 100)
			
				if (TileRoll>=1) and (TileRoll<10) then
					boundary[curroom][count]=1
					mbounds[curroom][count]=1
					local port=math.random(200,205)
					if OrangePortal==false and (port==200) then
						room[curroom][count]="m"
						OrangePortal=true
						OPLoc=count
					elseif HealPad==false and (port==201) then
						room[curroom][count]="h"
						HealPad=true
					elseif ManaPad==false and (port==202) then
						room[curroom][count]="j"
						ManaPad=true
					elseif Spawner==false and (port==203) then
						room[curroom][count]="u"
						Spawner=true
					elseif EnergyPad==false and (port==204) then
						room[curroom][count]="i"
						EnergyPad=true
					elseif (port==205) and (ShopCount~=((math.sqrt(mapsize))/10)*((math.sqrt(mapsize))/10)) then
						local TimeIsMoney=true
						for i=1,mapsize do
							if room[curroom][i]=="s" then
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
							room[curroom][count]="s"
							ShopCount=ShopCount+1
						else
							room[curroom][count]="x"
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
							room[curroom][count]="n"
							BluePortal=true
							BPLoc=count
						else
							room[curroom][count]="x"
						end
					else
						room[curroom][count]="x"
					end
				end
			
				if (TileRoll>=10) and (TileRoll<15) then
					boundary[curroom][count]=1
					mbounds[curroom][count]=0
					room[curroom][count]="l"
				end

				if (TileRoll>=15) and (TileRoll<20) then
					boundary[curroom][count]=1
					mbounds[curroom][count]=0
					room[curroom][count]="w"
				end
				
				if (TileRoll>=20) and (TileRoll<50)then
					local canitbreak=math.random(1,10)
					if canitbreak>=8 then
						boundary[curroom][count]=1
						mbounds[curroom][count]=0
						room[curroom][count]="q"
					else
						boundary[curroom][count]=0
						mbounds[curroom][count]=0
						room[curroom][count]="o"
					end
				end
				
				if (TileRoll>=50) then
					boundary[curroom][count]=1
					mbounds[curroom][count]=1
					room[curroom][count]="x"
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
				room[curroom][OPLoc]="o"
				OPLoc=nil
			end
		end
		if BluePortal==true and (BPLoc) then
			if boundary[BPLoc+1]==0 and boundary[BPLoc-1]==0 and boundary[BPLoc-sz]==0 and boundary[BPLoc+sz]==0 then
				BluePortal=false
				room[curroom][BPLoc]="o"
				BPLoc=nil
			end
		end
		if (OPLoc) and OrangePortal==true and BluePortal==false then
			room[curroom][OPLoc]="x"
			OrangePortal=false
			OPLoc=nil
		end
	end
end

function DisplayTile()
	count=count+1
	if math.floor((count/mapsize)*100)<10 then
		loadtxt.text=("Displaying Room "..curroom.."...\n".."            0"..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	else
		loadtxt.text=("Displaying Room "..curroom.."...\n".."             "..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	end
	
	if count~=mapsize+1 then
	
		if(room[curroom][count]=="b")then
			local roll=math.random(1,18)
			if roll<=9 then
				roll=1
			elseif roll<=15 then
				roll=2
			elseif roll<=18 then
				roll=3
			end
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/wall"..(roll)..".png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
		end
		
		if(room[curroom][count]=="h")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			HP=walls[curroom][count]
			HP=display.newSprite( HealPadsheet, { name="HP", start=1, count=30, time=2000 }  )
			HP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			HP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			HP.isVisible=false
			HP.loc=(count)
			HP.room=(curroom)
			HP.xScale=scale
			HP.yScale=HP.xScale
			Level:insert( HP )
		end
		
		if(room[curroom][count]=="i")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			EP=walls[curroom][count]
			EP=display.newSprite( EnergyPadsheet, { name="EP", start=1, count=30, time=2000 }  )
			EP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			EP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			EP.isVisible=false
			EP.loc=(count)
			EP.room=(curroom)
			EP.xScale=scale
			EP.yScale=EP.xScale
			Level:insert( EP )
		end
		
		if(room[curroom][count]=="j")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			MP=walls[curroom][count]
			MP=display.newSprite( ManaPadsheet, { name="MP", start=1, count=30, time=2000 }  )
			MP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			MP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			MP.isVisible=false
			MP.loc=(count)
			MP.room=(curroom)
			MP.xScale=scale
			MP.yScale=MP.xScale
			Level:insert( MP )
		end
		
		if(room[curroom][count]=="k")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			SmallKey=display.newImageRect( "tiles/"..TSet.."/smallkey.png", 80, 80)
			SmallKey.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			SmallKey.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			SmallKey.isVisible=false
			SmallKey.loc=(count)
			SmallKey.room=(curroom)
			SmallKey.xScale=scale
			SmallKey.yScale=SmallKey.xScale
			Level:insert( SmallKey )
		end
		
		if(room[curroom][count]=="l")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			LavaBlocks[curroom][count]=walls[curroom][count]
			LavaBlocks[curroom][count]=display.newSprite( lavasheet, { name="lava", start=1, count=20, time=4000 }  )
			LavaBlocks[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			LavaBlocks[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			LavaBlocks[curroom][count].isVisible=false
			LavaBlocks[curroom][count].xScale=scale
			LavaBlocks[curroom][count].yScale=LavaBlocks[curroom][count].xScale
			Level:insert( LavaBlocks[curroom][count] )
		end	
		
		if(room[curroom][count]=="m")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			OP=display.newSprite( portalsheet, { name="portal", start=1, count=20, time=1750 }  )
			OP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			OP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			OP.isVisible=false
			OP.loc=(count)
			OP.room=(curroom)
			OP.xScale=scale
			OP.yScale=OP.xScale
			Level:insert( OP )
		end
		
		if(room[curroom][count]=="n")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			BP=display.newSprite( portalbacksheet, { name="portalback", start=1, count=20, time=1750 }  )
			BP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			BP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			BP.isVisible=false
			BP.loc=(count)
			BP.room=(curroom)
			BP.xScale=scale
			BP.yScale=BP.xScale
			Level:insert( BP )
		end
		
		if(room[curroom][count]=="o")then
			local roll=math.random(1,18)
			if roll<=9 then
				roll=1
			elseif roll<=15 then
				roll=2
			elseif roll<=18 then
				roll=3
			end
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/wall"..(roll)..".png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
		end
		
		if(room[curroom][count]=="q")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert(  walls[curroom][count] )
			
			Destructibles[curroom][count]=display.newSprite(rockbreaksheet,{name="rock",start=1,count=14,time=400,loopCount=1})
			Destructibles[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			Destructibles[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Destructibles[curroom][count].isVisible=false
			Destructibles[curroom][count].exist=true
			Destructibles[curroom][count].xScale=scale
			Destructibles[curroom][count].yScale=Destructibles[curroom][count].xScale
			Level:insert( Destructibles[curroom][count] )
		end
		
		if(room[curroom][count]=="s")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			Shops[curroom][count]=display.newImageRect( "tiles/"..TSet.."/shop.png", 80, 80)
			Shops[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			Shops[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Shops[curroom][count].isVisible=false
			Shops[curroom][count].xScale=scale
			Shops[curroom][count].yScale=Shops[curroom][count].xScale
			Level:insert(Shops[curroom][count])
		end
		
		if(room[curroom][count]=="t")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			Chests[curroom][count]=walls[curroom][count]
			Chests[curroom][count]=display.newImageRect( "tiles/"..TSet.."/treasure.png", 80, 80)
			Chests[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			Chests[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Chests[curroom][count].isVisible=false
			Chests[curroom][count].xScale=scale
			Chests[curroom][count].yScale=Chests[curroom][count].xScale
			Level:insert( Chests[curroom][count] )
		end
		
		if(room[curroom][count]=="u") then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			MS=display.newSprite( spawnersheet, { name="mobspawner", start=1, count=20, time=1750 }  )
			MS.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			MS.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			MS.isVisible=false
			MS.loc=(count)
			MS.room=(curroom)
			MS.xScale=scale
			MS.yScale=MS.xScale
			Level:insert( MS )
		end
		
		if(room[curroom][count]=="w")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			WaterBlocks[curroom][count]=walls[curroom][count]
			WaterBlocks[curroom][count]=display.newSprite( watersheet, { name="water", start=1, count=30, time=3000 }  )
			WaterBlocks[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			WaterBlocks[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			WaterBlocks[curroom][count].isVisible=false
			WaterBlocks[curroom][count].xScale=scale
			WaterBlocks[curroom][count].yScale=WaterBlocks[curroom][count].xScale
			Level:insert( WaterBlocks[curroom][count] )
		end
		
		if(room[curroom][count]=="x")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walkable.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
		end	
		
		if(room[curroom][count]=="z")then
			local curround=WD.Circle()
			if didStair==false then
				walls[curroom][count]=walls[curroom][count]
				walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/stairup.png", 80, 80)
				walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
				walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
				walls[curroom][count].isVisible=false
				walls[curroom][count].xScale=scale
				walls[curroom][count].yScale=walls[curroom][count].xScale
				Level:insert( walls[curroom][count] )
				didStair=true
				if curround%2==0  then
					finish=(count)
				end
			elseif didStair==true then
				walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/stairdown.png", 80, 80)
				walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
				walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
				walls[curroom][count].isVisible=false
				walls[curroom][count].xScale=scale
				walls[curroom][count].yScale=walls[curroom][count].xScale
				Level:insert( walls[curroom][count] )
				didStair=false
				if curround%2~=0  then
					finish=(count)
				end
			end
		end
		
		fog[curroom][count]=display.newImageRect( "tiles/"..TSet.."/fog.png", 80, 80)
		fog[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
		fog[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
		fog[curroom][count].isVisible=false
		fog[curroom][count].xScale=scale
		fog[curroom][count].yScale=fog[curroom][count].xScale
		Level:insert( fog[curroom][count] )
		
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
			
			num[curroom][count]=display.newText( (curroom.."\n   "..NZone.."-"..count),0,0,"MoolBoran",40 )
			num[curroom][count]:setTextColor(70,255,70)
			num[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			num[curroom][count].y=yinicial+10+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Level:insert( num[curroom][count] )
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
	local p1=p.GetPlayer()
	roomid=p1.room
	for i in pairs(hidden) do
		hidden[roomid][i]=nil
		fog[roomid][i].isVisible=true
		fog[roomid][i]:toFront()
		for m in pairs(mobs)do
			if (mobs[m].loc==i) and mobs[m].room==roomid then
				mobs[m].isVisible=false
			end
		end
		if (LavaBlocks[roomid][i]) then
			LavaBlocks[roomid][i]:pause()
		end
		if (WaterBlocks[roomid][i]) then
			WaterBlocks[roomid][i]:pause()
		end
		if (OrangePortal==true) and (OP.loc==i) and (OP.room==roomid) then
			OP:pause()
		end
		if (BluePortal==true) and (BP.loc==i) and (BP.room==roomid) then
			BP:pause()
		end
		if (Spawner==true) and (MS.loc==i) and (MS.room==roomid) then
			MS:pause()
		end
		if (ManaPad==true) and (MP.loc==i) and (MP.room==roomid) then
			MP:pause()
		end
		if (HealPad==true) and (HP.loc==i) and (HP.room==roomid) then
			HP:pause()
		end
		if (EnergyPad==true) and (EP.loc==i) and (EP.room==roomid) then
			EP:pause()
		end
	end
	for i in pairs(IDs) do
		if (fog[roomid][i]) then
			fog[roomid][i].isVisible=false
			hidden[roomid][i]=true
		end
		if (walls[roomid][i]) then
			walls[roomid][i].isVisible=true
		end
		if (Destructibles[roomid][i]) then
			Destructibles[roomid][i].isVisible=true
		end
		if (Shops[roomid][i]) then
			Shops[roomid][i].isVisible=true
		end
		if (LavaBlocks[roomid][i]) then
			LavaBlocks[roomid][i].isVisible=true
			LavaBlocks[roomid][i]:play()
		end
		if (WaterBlocks[roomid][i]) then
			WaterBlocks[roomid][i].isVisible=true
			WaterBlocks[roomid][i]:play()
		end
		if (OrangePortal==true) and (OP.loc==i) and (BP.room==roomid) then
			OP.isVisible=true
			OP:play()
		end
		if (BluePortal==true) and (BP.loc==i) and (BP.room==roomid) then
			BP.isVisible=true
			BP:play()
		end
		if (Spawner==true) and (MS.loc==i) and (MS.room==roomid) then
			MS.isVisible=true
			MS:play()
		end
		if (ManaPad==true) and (MP.loc==i) and (MP.room==roomid) then
			MP.isVisible=true
			MP:play()
		end
		if (HealPad==true) and (HP.loc==i) and (HP.room==roomid) then
			HP.isVisible=true
			HP:play()
		end
		if (EnergyPad==true) and (EP.loc==i) and (EP.room==roomid) then
			EP.isVisible=true
			EP:play()
		end
		if (KeySpawned==true) and (SmallKey) and (SmallKey.loc==i) and (SmallKey.room==roomid) then
			SmallKey.isVisible=true
		end
		for m=1,table.maxn(mobs)do
			if (mobs[m])and (mobs[m].loc==i) then
				mobs[m].isVisible=true
			end
		end
		if (Chests[roomid][i]) then
			Chests[roomid][i].isVisible=true
		end
		if (finish==i) and (Gate) then
			Gate.isVisible=true
		end
		if (num[roomid][i]) then
			num[roomid][i]:toFront()
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
				if boundary[1][i+math.sqrt(mapsize)]==1 then
					postiles[#postiles+1]=i+math.sqrt(mapsize)
				end
				if boundary[1][i+1]==1 then
					postiles[#postiles+1]=i+1
				end
				if boundary[1][i-math.sqrt(mapsize)]==1 then
					postiles[#postiles+1]=i-math.sqrt(mapsize)
				end
				if boundary[1][i-1]==1 then
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
	local p1=p.GetPlayer()
	roomid=p1.room
	if val==0 then
		return mapsize
	elseif val==1 then
		return boundary[roomid]
	elseif val==2 then
		return mbounds[roomid]
	elseif val==3 then
		return Level
	elseif val==4 then
		return LavaBlocks[roomid]
	elseif val==5 then
		return Chests[roomid]
	elseif val==6 then
		return Destructibles[roomid]
	elseif val==7 then
		return Shops[roomid]
	elseif val==8 then
		return room[roomid]
	elseif val==9 then
		return WaterBlocks[roomid]
	elseif val==10 then
		return fog[roomid]
	else
		return walls[roomid]
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
	local p1=p.GetPlayer()
	roomid=p1.room
	room[roomid][id]="x"
end

function ReceiveMap(value)
	map2=value
end
