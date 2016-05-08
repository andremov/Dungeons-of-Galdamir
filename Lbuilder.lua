-----------------------------------------------------------------------------------------
--
-- MapBuilder.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
--[[--]]
local physics = require "physics"
local o=require("Loptions")
local WD=require("Lprogress")
local su=require("Lstartup")
local col=require("Levents")
local mob=require("Lmobai")
local p=require("Lplayers")
local sv=require("Lsaving")
-- local m=require("Lmoves")
local q=require("Lquest")
local ui=require("Lui")
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
local WaterBlocks
local LavaBlocks
local boundary
-- local length=7
local mbounds
local loadtxt
local Chests
local hidden
local Shops
local Level
local walls
local count
local scale
-- local map2
local side
local fog
-- local map
-- Extra Tiles
local OrangePortal
local entranceroom
local entranceloc
local finishroom
local BluePortal
local DarkPortal
local EnergyPad
local RedPortal
local finishpos
local SmallKey
local exitroom
local Spawner
local HealPad
local ManaPad
local exitloc
local mobs
-- Extra Tiles other values
local keytriescount
local KeySpawned
local ShopCount
local dmobs
local BP
local OP
local DP
local RP
local HP
local MP
local EP
local MS
-- Constants
local TileIDsNum=false
local isLoaded=false
local Peaceful=false
local didStair
-- local xinicial
-- local yinicial
-- local espacio
local mapsize
local TSet

function Essentials()
	ShopCount=0
	OrangePortal=false
	KeySpawned=false
	BluePortal=false
	DarkPortal=false
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
	finishroom={}
	LavaBlocks={}
	finishpos={}
	boundary={}
	mbounds={}
	hidden={}
	Chests={}
	Shops={}
	walls={}
	mobs={}
	fog={}
	if isLoaded~=true then
		room={}
	end
	if TileIDsNum==true then
		num={}
	end
	layout={
		1,0,0,0,0,
		0,0,0,0,0,
		0,0,0,0,0,
		0,0,0,0,0,
		0,0,0,0,0,
	}
	local round=WD.Circle()
	if isLoaded~=true then
		rooms=math.floor(math.random(round/4,round*3))
		if rooms<1 then
			rooms=1
		elseif rooms>25 then
			rooms=25
		end
		curroom=1
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
			layout[posrooms[chosen] ]=1
		end
	else
		for r in pairs(room) do
			if(room[r]~=false)then
				layout[r]=1
				if not(curroom)then
					curroom=r
				end
			end
		end
	end
	for r=1,table.maxn(layout) do
		if layout[r]==1 then
			if isLoaded~=true then
				room[r]={}
			end
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
		elseif isLoaded~=true then
			room[r]=false
		end
	end
	Tiles()
	--[[
	print (layout[1].." "..layout[2].." "..layout[3].." "..layout[4].." "..layout[5])
	print (layout[6].." "..layout[7].." "..layout[8].." "..layout[9].." "..layout[10])
	print (layout[11].." "..layout[12].." "..layout[13].." "..layout[14].." "..layout[15])
	print (layout[16].." "..layout[17].." "..layout[18].." "..layout[19].." "..layout[20])
	print (layout[21].." "..layout[22].." "..layout[23].." "..layout[24].." "..layout[25])
	--]]
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
	
	if isLoaded==true then
		mapsize=table.maxn( room[1] )
	else
		doTemplate()
		mapsize=table.maxn( map )
	end
	
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
			if (OPLoc) and OrangePortal==true and RedPortal==false then
				room[OPRoom][OPLoc]="x"
				OrangePortal=false
				OPLoc=nil
			end
			if (RPLoc) and RedPortal==true and OrangePortal==false then
				room[RPRoom][RPLoc]="x"
				RedPortal=false
				RPLoc=nil
			end
			if (DPLoc) and DarkPortal==true and BluePortal==false then
				room[DPRoom][DPLoc]="x"
				DarkPortal=false
				DPLoc=nil
			end
			if (BPLoc) and BluePortal==true and DarkPortal==false then
				room[BPRoom][BPLoc]="x"
				BluePortal=false
				BPLoc=nil
			end
			local froll=math.random(1,table.maxn(finishpos))
			exitloc=finishpos[froll]
			exitroom=finishroom[froll]
			for t=1,table.maxn(finishpos) do
				if exitroom==finishroom[t] and exitloc==finishpos[t] then
					mbounds[exitroom][exitloc]=0
				else
					room[finishroom[t] ][finishpos[t] ]="x"
				end
			end
			loadtxt.text=("Testing Map...")
			loadtxt:toFront()
			local CanBeDone
			if isLoaded==true then
				CanBeDone=true
			else
				CanBeDone=Pathfinding(entranceloc,exitloc,exitroom)
			end
			if CanBeDone==false then
			--	print "Map failed."
				loadtxt.text=("Map Failed.\n Retrying...")
				loadtxt:toFront()
				timer.performWithDelay(500,Rebuild)
			else
				sv.SaveMap()
			--	print ("ENTRANCE LOC: "..entranceloc.." ENTRANCE ROOM: "..entranceroom)
			--	print ("EXIT LOC: "..exitloc.." EXIT ROOM: "..exitroom)
			--	print "Map passed."
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
	xinicial=math.floor((curroom-1)%5)*(math.sqrt(mapsize)*espacio)
	yinicial=math.floor((curroom-1)/5)*(math.sqrt(mapsize)*espacio)
	
	if room[curroom]~=false and curroom<table.maxn(layout)+1 then
		DisplayTile()
		DisplayTile()
		DisplayTile()
		DisplayTile()
		DisplayTile()
	elseif curroom==table.maxn(layout)+1 then
		count=mapsize+3
	else
		curroom=curroom+1
	end
	
	if count<mapsize+1 then
		timer.performWithDelay(0.2,DisplayMap)
	else
		if curroom~=table.maxn(layout)+1  then
			count=0
			curroom=curroom+1
			timer.performWithDelay(0.2,DisplayMap)
		else
			mob.ReceiveMobs(mobs)
			display.remove(loadtxt)
			loadtxt=nil
			Level:insert( dmobs )
			Level:toBack()
			Extras()
			q.CreateQuest()
			local CurRound=WD.Circle()
			if not(side)then
				side=false
			end
			if side==true then
				p.PlayerLoc(exitloc,exitroom)
				Level.x=Level.x+((math.floor((exitroom-1)%5))*(math.sqrt(mapsize)*espacio))
				Level.y=Level.y+((math.floor((exitroom-1)/5))*(math.sqrt(mapsize)*espacio))
				if CurRound%2==0 then
				--	print "Abnormal Progression, Even Floor"
				else
				--	print "Abnormal Progression, Odd Floor"
					Level.x=Level.x-((math.sqrt(mapsize)-3)*espacio)
					Level.y=Level.y-((math.sqrt(mapsize)-3)*espacio)
				end
			elseif side==false then
				p.PlayerLoc(entranceloc,entranceroom)
				if CurRound%2==0 then
				--	print "Normal Progression, Even Floor"
						Level.x=Level.x-((math.sqrt(mapsize)-3)*espacio)
						Level.y=Level.y-((math.sqrt(mapsize)-3)*espacio)
				else
				--	print "Normal Progression, Odd Floor"
				end
			end
			su.Continue()
			if isLoaded==true then
				isLoaded=false
			end
		--	print "Map Built."
		end
	end
end
--[[
function Extras()
--	print "Adding Sprinkles to Map..."
	for r=1,25 do
		xinicial=math.floor((r-1)%5)*(math.sqrt(mapsize)*espacio)
		yinicial=math.floor((r-1)/5)*(math.sqrt(mapsize)*espacio)
		if layout[r]==1 then
			for i=1, mapsize do
				if i~=(math.sqrt(mapsize)+2) and room[r][i]=="x" then
					
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
		mbounds[exitroom][exitloc]=1
		boundary[exitroom][exitloc]=1
	else
		xinicial=math.floor((exitroom-1)%5)*(math.sqrt(mapsize)*espacio)
		yinicial=math.floor((exitroom-1)/5)*(math.sqrt(mapsize)*espacio)
		mbounds[exitroom][exitloc]=0
		boundary[exitroom][exitloc]=0
		Gate=walls[exitroom][exitloc]
		Gate=display.newImageRect( "tiles/"..TSet.."/jail.png", 80, 80)
		Gate.x=xinicial+((((exitloc-1)%math.sqrt(mapsize)))*espacio)
		Gate.y=yinicial+(math.floor((exitloc-1)/math.sqrt(mapsize))*espacio)
		Gate.isVisible=false
		Gate.loc=exitloc
		Gate.room=exitroom
		Gate.xScale=scale
		Gate.yScale=Gate.xScale
		Level:insert( Gate )
	end
end
--]]
function BuildTile()

	count=count+1
	if math.floor((count/mapsize)*100)<10 then
		loadtxt.text=( "Generating Room "..curroom.."...\n".."             0"..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	else
		loadtxt.text=("Generating Room "..curroom.."...\n".."              "..math.floor((count/mapsize)*100).."%")
		loadtxt:toFront()
	end
	
	
	if count~=mapsize+1 and not(room[curroom][count]) then
		local CurRound=WD.Circle()
		if(map[count]=="1")then
			if (room[curroom-5]) and room[curroom-5]~=false then
				boundary[curroom][count]=1
				mbounds[curroom][count]=0
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
				mbounds[curroom][count]=0
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
				mbounds[curroom][count]=0
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
				mbounds[curroom][count]=0
				room[curroom][count]="x"
			else
				boundary[curroom][count]=0
				mbounds[curroom][count]=0
				room[curroom][count]="b"
			end
		end
		
		if(map[count]=="b")then
			boundary[curroom][count]=0
			mbounds[curroom][count]=0
			room[curroom][count]="b"
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
		
		if(map[count]=="e")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			if Spawner==false then
				Spawner=true
				room[curroom][count]="e"
			elseif Spawner==true then
				room[curroom][count]="x"
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
				SmallKey=display.newImageRect( "tiles/"..TSet.."/smallkey.png", 80, 80)
				SmallKey.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
				SmallKey.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
				SmallKey.isVisible=false
				SmallKey.loc=(count)
				SmallKey.room=(curroom)
				SmallKey.xScale=scale
				SmallKey.yScale=SmallKey.xScale
				Level:insert( SmallKey )
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
		
		if(map[count]=="ñ")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			if(RedPortal==false)then
				RedPortal=true
				RPLoc=count
				room[curroom][count]="ñ"
			elseif(RedPortal==true)then
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
			if(DarkPortal==false)then
				DarkPortal=true
				DPLoc=count
				room[curroom][count]="u"
			elseif(DarkPortal==true)then
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
		
		if(map[count]=="a")then
			if CurRound%2==0 then
				mbounds[curroom][count]=1
				boundary[curroom][count]=1
				room[curroom][count]="z"
				finishpos[#finishpos+1]=(count)
				finishroom[#finishroom+1]=(curroom)
			else
				if curroom==1 then
					mbounds[curroom][count]=0
					boundary[curroom][count]=1
					room[curroom][count]="a"
					entranceloc=(count)
					entranceroom=(curroom)
				else
					mbounds[curroom][count]=1
					boundary[curroom][count]=1
					room[curroom][count]="x"
				end
			end
		end
		
		if(map[count]=="z")then
			if CurRound%2==0 then
				if curroom==1 then
					mbounds[curroom][count]=0
					boundary[curroom][count]=1
					room[curroom][count]="a"
					entranceloc=(count)
					entranceroom=(curroom)
				else
					mbounds[curroom][count]=1
					boundary[curroom][count]=1
					room[curroom][count]="x"
				end
			else
				mbounds[curroom][count]=1
				boundary[curroom][count]=1
				room[curroom][count]="z"
				finishpos[#finishpos+1]=(count)
				finishroom[#finishroom+1]=(curroom)
			end
		end
		
		if map[count]=="x" and KeySpawned==false then
			local isKey=math.random(1,1000)
			if isKey>=995 then
				mbounds[curroom][count]=0	
				boundary[curroom][count]=1
				SmallKey=display.newImageRect( "tiles/"..TSet.."/smallkey.png", 80, 80)
				SmallKey.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
				SmallKey.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
				SmallKey.isVisible=false
				SmallKey.loc=(count)
				SmallKey.room=(curroom)
				SmallKey.xScale=scale
				SmallKey.yScale=SmallKey.xScale
				Level:insert( SmallKey )
				room[curroom][count]="k"
				KeySpawned=true
			end
		end
		
	elseif count~=mapsize+1 then
	
		if(room[curroom][count]=="b")then
			boundary[curroom][count]=0
			mbounds[curroom][count]=0
		end
		
		if(room[curroom][count]=="e") then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			Spawner=true
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
		end
	
		if(room[curroom][count]=="ñ")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=1
			RedPortal=true
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
			DarkPortal=true
		end
		
		if(room[curroom][count]=="w")then
			boundary[curroom][count]=1
			mbounds[curroom][count]=0
		end
		
		if(room[curroom][count]=="x")then
			local NZoneX=math.floor(count%(math.sqrt(mapsize)))
			local NZoneY=math.floor(count/(math.sqrt(mapsize)))+1
			if NZoneX==1 or NZoneX==math.sqrt(mapsize) or NZoneY==1 or NZoneY==math.sqrt(mapsize) then
				mbounds[curroom][count]=0
			else
				mbounds[curroom][count]=1
			end
			boundary[curroom][count]=1
		end
		
		if(room[curroom][count]=="a")then
			mbounds[curroom][count]=0
			boundary[curroom][count]=1
			entranceloc=(count)
			entranceroom=(curroom)
		end
		
		if(room[curroom][count]=="z")then
			mbounds[curroom][count]=0
			boundary[curroom][count]=1
			finishpos[#finishpos+1]=(count)
			finishroom[#finishroom+1]=(curroom)
		end
		
	end
	
	RandomizeTile()
end

function RandomizeTile()
	if count==1 then
	--	print "Starting Map Randomization..."
	end
	
	if count~=mapsize+1 and not(room[curroom][count]) then
		if (map[count]=="r") then
			if i~=(math.sqrt(mapsize)+2) then
				local TileRoll=math.random(1, 100)
				
				if (TileRoll>=1) and (TileRoll<8) then
					boundary[curroom][count]=1
					mbounds[curroom][count]=1
					local port=math.random(200,206)
					if OrangePortal==false and (port==200) then
						room[curroom][count]="m"
						OrangePortal=true
						OPLoc=count
						OPRoom=curroom
					elseif BluePortal==false and (port==200) then
						room[curroom][count]="n"
						BluePortal=true
						BPLoc=count
						BPRoom=curroom
					elseif HealPad==false and (port==202) then
						room[curroom][count]="h"
						HealPad=true
					elseif ManaPad==false and (port==203) then
						room[curroom][count]="j"
						ManaPad=true
					elseif Spawner==false and (port==204) then
						room[curroom][count]="e"
						Spawner=true
					elseif EnergyPad==false and (port==205) then
						room[curroom][count]="i"
						EnergyPad=true
					elseif (port==206) and (ShopCount~=((math.sqrt(mapsize))/10)*((math.sqrt(mapsize))/10)) then
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
					elseif OrangePortal==true and RedPortal==false then
						if OPRoom~=curroom then
							room[curroom][count]="ñ"
							RedPortal=true
							RPLoc=count
							RPRoom=curroom
						else
							local ThinkinWithPortals=true
							local AZoneX=math.floor(OPLoc%(math.sqrt(mapsize)))
							local AZoneY=math.floor(OPLoc/(math.sqrt(mapsize)))+1
							local AZone=1
							if( AZoneX>(math.sqrt(mapsize))/2 )then
								AZone=AZone+1
							end
							if( AZoneY>(math.sqrt(mapsize))/2 )then
								AZone=AZone+2
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
							if BZone==AZone then
								ThinkinWithPortals=false
							end
							if (BZoneX-4)<AZoneX and (BZoneX+4)>AZoneX then
								ThinkinWithPortals=false
							end
							if (BZoneY-4)<AZoneY and (BZoneY+4)>AZoneY then
								ThinkinWithPortals=false
							end
							if ThinkinWithPortals==true then
								room[curroom][count]="ñ"
								RedPortal=true
								RPLoc=count
								RPRoom=curroom
							else
								room[curroom][count]="x"
							end
						end
					elseif BluePortal==true and DarkPortal==false then
						if BPRoom~=curroom then
							room[curroom][count]="u"
							DarkPortal=true
							DPLoc=count
							DPRoom=curroom
						else
							local ThinkinWithPortals=true
							local AZoneX=math.floor(BPLoc%(math.sqrt(mapsize)))
							local AZoneY=math.floor(BPLoc/(math.sqrt(mapsize)))+1
							local AZone=1
							if( AZoneX>(math.sqrt(mapsize))/2 )then
								AZone=AZone+1
							end
							if( AZoneY>(math.sqrt(mapsize))/2 )then
								AZone=AZone+2
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
							if BZone==AZone then
								ThinkinWithPortals=false
							end
							if (BZoneX-4)<AZoneX and (BZoneX+4)>AZoneX then
								ThinkinWithPortals=false
							end
							if (BZoneY-4)<AZoneY and (BZoneY+4)>AZoneY then
								ThinkinWithPortals=false
							end
							if ThinkinWithPortals==true then
								room[curroom][count]="u"
								DarkPortal=true
								DPLoc=count
								DPRoom=curroom
							else
								room[curroom][count]="x"
							end
						end
					else
						room[curroom][count]="x"
					end
				end
			
				if (TileRoll>=8) and (TileRoll<15) then
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
		if RedPortal==true and (RPLoc) then
			if boundary[RPLoc+1]==0 and boundary[RPLoc-1]==0 and boundary[RPLoc-sz]==0 and boundary[RPLoc+sz]==0 then
				BluePortal=false
				room[curroom][RPLoc]="o"
				RPLoc=nil
			end
		end
		if DarkPortal==true and (DPLoc) then
			if boundary[DPLoc+1]==0 and boundary[DPLoc-1]==0 and boundary[DPLoc-sz]==0 and boundary[DPLoc+sz]==0 then
				BluePortal=false
				room[curroom][DPLoc]="o"
				DPLoc=nil
			end
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
		
		if(room[curroom][count]=="e") then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			MS=display.newSprite( spawnersheet, mseqs  )
			MS:setSequence("on")
			MS.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			MS.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			MS.isVisible=false
			MS.loc=(count)
			MS.room=(curroom)
			MS.cd=0
			MS.xScale=scale
			MS.yScale=MS.xScale
			Level:insert( MS )
			
			local size=mapsize
			local col=(math.floor(count%(math.sqrt(size))))
			local row=(math.floor(count/(math.sqrt(size))))+1
			local zonas=math.ceil((math.sqrt(size))/10)
			local round=WD.Circle()
			if round%2==0 then
				for z=1, zonas do
					if col>((math.sqrt(size)/zonas)*(zonas-z)) and col<=((math.sqrt(size)/zonas)*((zonas+1)-z)) and row>=((math.sqrt(size)/zonas)*(zonas-z)) then
						MS.req=(z+(zonas*(round-1)))
					elseif row>((math.sqrt(size)/zonas)*(zonas-z)) and row<=((math.sqrt(size)/zonas)*((zonas+1)-z)) and col>=((math.sqrt(size)/zonas)*((zonas+1)-z)) then
						MS.req=(z+(zonas*(round-1)))
					end
				end
			else
				for z=1, zonas do
					if col>((math.sqrt(size)/zonas)*(z-1)) and col<=((math.sqrt(size)/zonas)*z) and row<=((math.sqrt(size)/zonas)*z) then
						MS.req=(z+(zonas*(round-1)))
					elseif row>((math.sqrt(size)/zonas)*(z-1)) and row<=((math.sqrt(size)/zonas)*z) and col<=((math.sqrt(size)/zonas)*z) then
						MS.req=(z+(zonas*(round-1)))
					end
				end
			end
			if curroom~=1 then
				local roomx=math.floor((curroom-1)%5)
				local roomy=math.floor((curroom-1)/5)
				local maxroom
				if roomx>roomy then
					maxroom=roomx
				else
					maxroom=roomy
				end
				MS.req=MS.req+(zonas*maxroom)
			end
			MS.req=MS.req+(math.random(-1,5))
		end
		
		if(room[curroom][count]=="h")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			OP=display.newSprite( portalorangesheet, { name="porange", start=1, count=20, time=1750 }  )
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			BP=display.newSprite( portalbluesheet, { name="portalblue", start=1, count=20, time=1750 }  )
			BP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			BP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			BP.isVisible=false
			BP.loc=(count)
			BP.room=(curroom)
			BP.xScale=scale
			BP.yScale=BP.xScale
			Level:insert( BP )
		end
		
		if(room[curroom][count]=="ñ")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			RP=display.newSprite( portalredsheet, { name="pred", start=1, count=20, time=1750 }  )
			RP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			RP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			RP.isVisible=false
			RP.loc=(count)
			RP.room=(curroom)
			RP.xScale=scale
			RP.yScale=RP.xScale
			Level:insert( RP )
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert(  walls[curroom][count] )
			
			Destructibles[curroom][count]=display.newImageRect( "tiles/"..TSet.."/wall.png", 80, 80)
			Destructibles[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			Destructibles[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Destructibles[curroom][count].isVisible=false
			Destructibles[curroom][count].xScale=scale
			Destructibles[curroom][count].yScale=Destructibles[curroom][count].xScale
			Level:insert( Destructibles[curroom][count] )
			
			local size=mapsize
			local col=(math.floor(count%(math.sqrt(size))))
			local row=(math.floor(count/(math.sqrt(size))))+1
			local zonas=math.ceil((math.sqrt(size))/10)
			local round=WD.Circle()
			if round%2==0 then
				for z=1, zonas do
					if col>((math.sqrt(size)/zonas)*(zonas-z)) and col<=((math.sqrt(size)/zonas)*((zonas+1)-z)) and row>=((math.sqrt(size)/zonas)*(zonas-z)) then
						Destructibles[curroom][count].req=(z+(zonas*(round-1)))
					elseif row>((math.sqrt(size)/zonas)*(zonas-z)) and row<=((math.sqrt(size)/zonas)*((zonas+1)-z)) and col>=((math.sqrt(size)/zonas)*((zonas+1)-z)) then
						Destructibles[curroom][count].req=(z+(zonas*(round-1)))
					end
				end
			else
				for z=1, zonas do
					if col>((math.sqrt(size)/zonas)*(z-1)) and col<=((math.sqrt(size)/zonas)*z) and row<=((math.sqrt(size)/zonas)*z) then
						Destructibles[curroom][count].req=(z+(zonas*(round-1)))
					elseif row>((math.sqrt(size)/zonas)*(z-1)) and row<=((math.sqrt(size)/zonas)*z) and col<=((math.sqrt(size)/zonas)*z) then
						Destructibles[curroom][count].req=(z+(zonas*(round-1)))
					end
				end
			end
			if curroom~=1 then
				local roomx=math.floor((curroom-1)%5)
				local roomy=math.floor((curroom-1)/5)
				local maxroom
				if roomx>roomy then
					maxroom=roomx
				else
					maxroom=roomy
				end
				Destructibles[curroom][count].req=Destructibles[curroom][count].req+(zonas*maxroom)
			end
			Destructibles[curroom][count].req=Destructibles[curroom][count].req+(math.random(-3,3))
		end
		
		if(room[curroom][count]=="s")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
			
			DP=display.newSprite( portaldarkbluesheet, { name="pdarkblue", start=1, count=20, time=1750 }  )
			DP.x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			DP.y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			DP.isVisible=false
			DP.loc=(count)
			DP.room=(curroom)
			DP.xScale=scale
			DP.yScale=DP.xScale
			Level:insert( DP )
		end
		
		if(room[curroom][count]=="w")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
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
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/walk1.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
		end	
		
		if(room[curroom][count]=="a")then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/stairs.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
		end
		
		if(room[curroom][count]=="z")and(curroom==exitroom)and(count==exitloc)then
			walls[curroom][count]=display.newImageRect( "tiles/"..TSet.."/stairs.png", 80, 80)
			walls[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			walls[curroom][count].y=yinicial+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			walls[curroom][count].isVisible=false
			walls[curroom][count].rotation=180
			walls[curroom][count].xScale=scale
			walls[curroom][count].yScale=walls[curroom][count].xScale
			Level:insert( walls[curroom][count] )
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
			num[curroom][count]:setFillColor(0,0,0)
			num[curroom][count].x=xinicial+((((count-1)%math.sqrt(mapsize)))*espacio)
			num[curroom][count].y=yinicial+10+(math.floor((count-1)/math.sqrt(mapsize))*espacio)
			Level:insert( num[curroom][count] )
		end
		
	end
end

function Expand(get,value)
	if get==true then
		return length
	elseif get==false then
		length=value
	else
		length=length+1
	end
end

function Show(IDs)
	for r in pairs(hidden) do
		for t in pairs(hidden[r]) do
			hidden[r][t]=nil
			fog[r][t].isVisible=true
			fog[r][t]:toFront()
			for m in pairs(mobs[r]) do
				if (mobs[r][m].loc==t) then
					mobs[r][m].isVisible=false
				end
			end
			if (LavaBlocks[r][t]) then
				LavaBlocks[r][t]:pause()
			end
			if (WaterBlocks[r][t]) then
				WaterBlocks[r][t]:pause()
			end
			if (OrangePortal==true) and (OP.loc==t) and (OP.room==r) then
				OP:pause()
			end
			if (RedPortal==true) and (RP.loc==t) and (RP.room==r) then
				RP:pause()
			end
			if (DarkPortal==true) and (DP.loc==t) and (DP.room==r) then
				DP:pause()
			end
			if (BluePortal==true) and (BP.loc==t) and (BP.room==r) then
				BP:pause()
			end
			if (Spawner==true) and (MS.loc==t) and (MS.room==r) then
				if MS.cd==0 and MS.sequence~="on" then
					MS:setSequence( "on" )
				elseif MS.cd~=0 and MS.sequence~="off" then
					MS:setSequence( "off" )
				end
				MS:pause()
			end
			if (ManaPad==true) and (MP.loc==t) and (MP.room==r) then
				MP:pause()
			end
			if (HealPad==true) and (HP.loc==t) and (HP.room==r) then
				HP:pause()
			end
			if (EnergyPad==true) and (EP.loc==t) and (EP.room==r) then
				EP:pause()
			end
		end
	end
	for r in pairs(IDs) do
		for t in pairs(IDs[r]) do
		--	print (r..": "..t)
			if (fog[r][t]) then
				fog[r][t].isVisible=false
				hidden[r][t]=true
			end
			if (walls[r][t]) then
				walls[r][t].isVisible=true
			end
			if (Destructibles[r][t]) then
				Destructibles[r][t].isVisible=true
			end
			if (Shops[r][t]) then
				Shops[r][t].isVisible=true
			end
			if (KeySpawned==true) and (SmallKey) and (SmallKey.loc==t) and (SmallKey.room==r) then
				SmallKey.isVisible=true
			end
			for m in pairs(mobs[r]) do
				if (mobs[r][m].loc==t) then
					mobs[r][m].isVisible=true
				end
			end
			if (Chests[r][t]) then
				Chests[r][t].isVisible=true
			else
			end
			if (Gate) and Gate.room==r and Gate.loc==t then
				Gate.isVisible=true
			end
			if (LavaBlocks[r][t]) then
				LavaBlocks[r][t].isVisible=true
				LavaBlocks[r][t]:play()
			end
			if (WaterBlocks[r][t]) then
				WaterBlocks[r][t].isVisible=true
				WaterBlocks[r][t]:play()
			end
			if (OrangePortal==true) and (OP.loc==t) and (OP.room==r) then
				OP.isVisible=true
				OP:play()
			end
			if (RedPortal==true) and (RP.loc==t) and (RP.room==r) then
				RP.isVisible=true
				RP:play()
			end
			if (DarkPortal==true) and (DP.loc==t) and (DP.room==r) then
				DP.isVisible=true
				DP:play()
			end
			if (BluePortal==true) and (BP.loc==t) and (BP.room==r) then
				BP.isVisible=true
				BP:play()
			end
			if (Spawner==true) and (MS.loc==t) and (MS.room==r) then
				if MS.cd==0 and MS.sequence~="on" then
					MS:setSequence( "on" )
				elseif MS.cd~=0 and MS.sequence~="off" then
					MS:setSequence( "off" )
				end
				MS.isVisible=true
				MS:play()
			end
			if (ManaPad==true) and (MP.loc==t) and (MP.room==r) then
				MP.isVisible=true
				MP:play()
			end
			if (HealPad==true) and (HP.loc==t) and (HP.room==r) then
				HP.isVisible=true
				HP:play()
			end
			if (EnergyPad==true) and (EP.loc==t) and (EP.room==r) then
				EP.isVisible=true
				EP:play()
			end
			if TileIDsNum==true then
				if (num[r][t]) then
					num[r][t]:toFront()
				end
			end
		end
	end
	Level:toBack()
	local canArr=ui.isBusy()
	if canArr==false then
		-- m.ShowArrows()
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
		for i=dmobs.numChildren,1,-1 do
			display.remove(dmobs[i])
			dmobs[i]=nil
		end
	end
	dmobs=nil
	boundary=nil
	Level=nil
	count=nil
	curroom=1
end

function Pathfinding(start,finish,finishroom)
	local flroom=1
	local tiles={}
	local done={}
	local postiles={}
	local isDone=false
	local foundIt={}
	local foundK={}
--	print ("Processing room "..flroom.."...")
	tiles[flroom]={}
	done[flroom]={}
	sentIt={
		true,false,false,false,false,
		false,false,false,false,false,
		false,false,false,false,false,
		false,false,false,false,false,
		false,false,false,false,false
	}
	finishIt={false,false,false,false}
	if (start) and type(start)=="number" then
		tiles[flroom][start]=1
		done[flroom][start]=false
	else
		tiles[flroom][math.sqrt(mapsize)+2]=1
		done[flroom][math.sqrt(mapsize)+2]=false
	end
	if (finish) and type(finish)=="number" then
		target=finish
	else
		target=mapsize-(math.sqrt(mapsize)+1)
	end
	if (finishroom) and type(finishroom)=="number" then
		targetroom=finishroom
		if (layout[targetroom-5]) and layout[targetroom-5]==1 then
			finishIt[1]=false
		else
			finishIt[1]=true
		end
		if (layout[targetroom-1]) and layout[targetroom-1]==1 then
			finishIt[2]=false
		else
			finishIt[2]=true
		end
		if (layout[targetroom+1]) and layout[targetroom+1]==1 then
			finishIt[3]=false
		else
			finishIt[3]=true
		end
		if (layout[targetroom+5]) and layout[targetroom+5]==1 then
			finishIt[4]=false
		else
			finishIt[4]=true
		end
	else
		targetroom=1
		finishIt={true,true,false,false}
	end
	while isDone==false do
		for i in pairs(tiles[flroom]) do
			if done[flroom][i]==false then
				local col=math.floor((i-1)%math.sqrt(mapsize))
				local row=math.floor((i-1)/math.sqrt(mapsize))
				if boundary[flroom][i+math.sqrt(mapsize)]==1 then
					postiles[#postiles+1]=i+math.sqrt(mapsize)
				end
				if boundary[flroom][i+1]==1 then
					postiles[#postiles+1]=i+1
				end
				if boundary[flroom][i-math.sqrt(mapsize)]==1 then
					postiles[#postiles+1]=i-math.sqrt(mapsize)
				end
				if boundary[flroom][i-1]==1 then
					postiles[#postiles+1]=i-1
				end
				--Overwrite check
				for s in pairs(tiles[flroom]) do
					for p=table.maxn(postiles),1,-1 do
						if postiles[p]==s then
							table.remove(postiles,p)
						end
					end
				end
				if (table.maxn(postiles)~=0) then
					for i=1,table.maxn(postiles) do
						tiles[flroom][postiles[i] ]=1
						done[flroom][postiles[i] ]=false
						if map[postiles[i] ]=="1" and sentIt[flroom-5]==false then
							sentIt[flroom-5]=true
							foundIt[2],foundK[2]=ExtraFinding(flroom,flroom-5)
						elseif flroom-5==targetroom and finishIt[4]==false then
							finishIt[4]=true
							foundIt[2],foundK[2]=ExtraFinding(flroom,flroom-5)
						end
						if map[postiles[i] ]=="2" and sentIt[flroom-1]==false then
							sentIt[flroom-1]=true
							foundIt[3],foundK[3]=ExtraFinding(flroom,flroom-1)
						elseif flroom-1==targetroom and finishIt[3]==false then
							finishIt[3]=true
							foundIt[3],foundK[3]=ExtraFinding(flroom,flroom-1)
						end
						if map[postiles[i] ]=="3" and sentIt[flroom+1]==false then
							sentIt[flroom+1]=true
							foundIt[4],foundK[4]=ExtraFinding(flroom,flroom+1)
						elseif flroom+1==targetroom and finishIt[2]==false then
							finishIt[2]=true
							foundIt[4],foundK[4]=ExtraFinding(flroom,flroom+1)
						end
						if map[postiles[i] ]=="4" and sentIt[flroom+5]==false then
							sentIt[flroom+5]=true
							foundIt[5],foundK[5]=	ExtraFinding(flroom,flroom+5)
						elseif flroom+5==targetroom and finishIt[1]==false then
							finishIt[1]=true
							foundIt[5],foundK[5]=	ExtraFinding(flroom,flroom+5)
						end
					end
					for p=table.maxn(postiles),1,-1 do
						table.remove(postiles,p)
					end
				else
					done[flroom][i]=true
				end
			end
			isDone=true
			for i in pairs(done[flroom]) do
				if done[flroom][i]~=true then
					isDone=false
				end
			end
		end
	end
--	print ("Processed room "..flroom.."...")
	local canDo=false
	local canKey=false
	if targetroom==flroom then
		for t in pairs(tiles[flroom]) do
			if target==t then
				foundIt[1]=true
			end
		end
	end
	if foundIt[1]==false then
		if RPLoc and OPLoc then
			local isRP=false
			local isOP=false
			for t in pairs(tiles[flroom]) do
				if RPLoc==t then
					isRP=true
				end
			end
			for t in pairs(tiles[flroom]) do
				if OPLoc==t then
					isOP=true
				end
			end
			local portDo=false
			if isOP==true and isRP==true then
				portDo=false
			elseif isOP==true and isRP==false then
				portDo=Pathfinding(RPLoc)
			elseif isOP==false and isRP==true then
				portDo=Pathfinding(OPLoc)
			else
				portDo=false
			end
			foundIt[1]=portDo
		end
	end
	if foundIt[1]==false then
		if BPLoc and DPLoc then
			local isDP=false
			local isBP=false
			for t in pairs(tiles[flroom]) do
				if DPLoc==t then
					isDP=true
				end
			end
			for t in pairs(tiles[flroom]) do
				if BPLoc==t then
					isBP=true
				end
			end
			local portDo=false
			if isBP==true and isDP==true then
				portDo=false
			elseif isBP==true and isDP==false then
				portDo=Pathfinding(DPLoc)
			elseif isBP==false and isDP==true then
				portDo=Pathfinding(BPLoc)
			else
				portDo=false
			end
			foundIt[1]=portDo
		end
	end
	if KeySpawned==true then
		if SmallKey.room==flroom then
			for t in pairs(tiles[flroom]) do
				if SmallKey.loc==t then
					foundK[1]=true
				end
			end
		end
	else
		foundK[1]=true
	end
	for i=1,table.maxn(foundK)do
		if foundK[i]==true then
			canKey=true
		end
	end
	for i=1,table.maxn(foundIt)do
		if foundIt[i]==true then
			canDo=true
		end
	end
	if canKey==true and canDo==true then
		canDo=true
	else
		canDo=false
	end
	return canDo
end

function ExtraFinding(fromroom,toroom)
	local tiles={}
	local done={}
	local flroom=toroom
	local dif=toroom-fromroom
	local postiles={}
	local foundIt={}
	local foundK={}
	local isDone=false
--	print ("Processing room "..flroom.."...")
	tiles[flroom]={}
	done[flroom]={}
	if dif==1 then
		local size=math.sqrt(mapsize)
		tiles[flroom][((size/2)*size)+1]=1
		done[flroom][((size/2)*size)+1]=false
	elseif dif==5 then
		local size=math.sqrt(mapsize)
		tiles[flroom][size/2]=1
		done[flroom][size/2]=false
	elseif dif==-1 then
		local size=math.sqrt(mapsize)
		tiles[flroom][((size/2)*size)]=1
		done[flroom][((size/2)*size)]=false
	elseif dif==-5 then
		local size=math.sqrt(mapsize)
		tiles[flroom][(size/2)+((size-1)*size)]=1
		done[flroom][(size/2)+((size-1)*size)]=false
	end
	while isDone==false do
		for i in pairs(tiles[flroom]) do
			if done[flroom][i]==false then
				local col=math.floor((i-1)%math.sqrt(mapsize))
				local row=math.floor((i-1)/math.sqrt(mapsize))
				if boundary[flroom][i+math.sqrt(mapsize)]==1 then
					postiles[#postiles+1]=i+math.sqrt(mapsize)
				end
				if boundary[flroom][i+1]==1 then
					postiles[#postiles+1]=i+1
				end
				if boundary[flroom][i-math.sqrt(mapsize)]==1 then
					postiles[#postiles+1]=i-math.sqrt(mapsize)
				end
				if boundary[flroom][i-1]==1 then
					postiles[#postiles+1]=i-1
				end
				--Overwrite check
				for s in pairs(tiles[flroom]) do
					for p=table.maxn(postiles),1,-1 do
						if postiles[p]==s then
							table.remove(postiles,p)
						end
					end
				end
				if (table.maxn(postiles)~=0) then
					for i=1,table.maxn(postiles) do
						tiles[flroom][postiles[i] ]=1
						done[flroom][postiles[i] ]=false
						if map[postiles[i] ]=="1" and sentIt[flroom-5]==false then
							sentIt[flroom-5]=true
							foundIt[2]=ExtraFinding(flroom,flroom-5)
						elseif flroom-5==targetroom and finishIt[4]==false then
							finishIt[4]=true
							foundIt[2]=ExtraFinding(flroom,flroom-5)
						end
						if map[postiles[i] ]=="2" and sentIt[flroom-1]==false then
							sentIt[flroom-1]=true
							foundIt[3]=ExtraFinding(flroom,flroom-1)
						elseif flroom-1==targetroom and finishIt[3]==false then
							finishIt[3]=true
							foundIt[3]=ExtraFinding(flroom,flroom-1)
						end
						if map[postiles[i] ]=="3" and sentIt[flroom+1]==false then
							sentIt[flroom+1]=true
							foundIt[4]=ExtraFinding(flroom,flroom+1)
						elseif flroom+1==targetroom and finishIt[2]==false then
							finishIt[2]=true
							foundIt[4]=ExtraFinding(flroom,flroom+1)
						end
						if map[postiles[i] ]=="4" and sentIt[flroom+5]==false then
							sentIt[flroom+5]=true
							foundIt[5]=	ExtraFinding(flroom,flroom+5)
						elseif flroom+5==targetroom and finishIt[1]==false then
							finishIt[1]=true
							foundIt[5]=	ExtraFinding(flroom,flroom+5)
						end
					end
					for p=table.maxn(postiles),1,-1 do
						table.remove(postiles,p)
					end
				else
					done[flroom][i]=true
				end
			end
			isDone=true
			for i in pairs(done[flroom]) do
				if done[flroom][i]~=true then
					isDone=false
				end
			end
		end
	end
--	print ("Processed room "..flroom.."...")
	local canDo=false
	if targetroom==flroom then
		for t in pairs(tiles[flroom]) do
			if target==t then
				foundIt[1]=true
			end
		end
	end
	if foundIt[1]==false then
		if RPLoc and OPLoc then
			local isRP=false
			local isOP=false
			for t in pairs(tiles[flroom]) do
				if RPLoc==t then
					isRP=true
				end
			end
			for t in pairs(tiles[flroom]) do
				if OPLoc==t then
					isOP=true
				end
			end
			local portDo=false
			if isOP==true and isRP==true then
				portDo=false
			elseif isOP==true and isRP==false then
				portDo=Pathfinding(RPLoc)
			elseif isOP==false and isRP==true then
				portDo=Pathfinding(OPLoc)
			else
				portDo=false
			end
			foundIt[1]=portDo
		end
	end
	if foundIt[1]==false then
		if BPLoc and DPLoc then
			local isDP=false
			local isBP=false
			for t in pairs(tiles[flroom]) do
				if DPLoc==t then
					isDP=true
				end
			end
			for t in pairs(tiles[flroom]) do
				if BPLoc==t then
					isBP=true
				end
			end
			local portDo=false
			if isBP==true and isDP==true then
				portDo=false
			elseif isBP==true and isDP==false then
				portDo=Pathfinding(DPLoc)
			elseif isBP==false and isDP==true then
				portDo=Pathfinding(BPLoc)
			else
				portDo=false
			end
			foundIt[1]=portDo
		end
	end
	if KeySpawned==true then
		if SmallKey.room==flroom then
			for t in pairs(tiles[flroom]) do
				if SmallKey.loc==t then
					foundK[1]=true
				end
			end
		end
	else
		foundK[1]=true
	end
	for i=1,table.maxn(foundK)do
		if foundK[i]==true then
			canKey=true
		end
	end
	for i=1,table.maxn(foundIt)do
		if foundIt[i]==true then
			canDo=true
		end
	end
	return canDo,canKey
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
		mbounds[exitroom][exitloc]=1
		boundary[exitroom][exitloc]=1
	end
end

function GetPad(int)
	if int==1 and HealPad==true and (HP) then
		return HP
	elseif int==2 and ManaPad==true and (MP) then
		return MP
	elseif int==3 and EnergyPad==true and (EP) then
		return EP
	else
		return nil
	end
end
--[[
function GetData(val,val2)
	local p1=p.GetPlayer()
	roomid=p1.room
	if val==0 then
		return mapsize
	elseif val==1 then
		if val2==0 then
			return boundary
		else
			return boundary[roomid]
		end
	elseif val==2 then
		if val2==0 then
			return mbounds
		else
			return mbounds[roomid]
		end
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
		if val2==0 then
			return room
		else
			return room[roomid]
		end
	elseif val==9 then
		return WaterBlocks
	elseif val==10 then
		return fog[roomid]
	elseif val==11 then
		return exitloc,exitroom
	elseif val==12 then
		return entranceloc,entranceroom
	else
		return walls[roomid]
	end
end
]]
function GetMSpawner()
	if Spawner==true then
		return MS
	else
		return nil
	end
end

function GetPortal(lie)
	if lie==1 and OrangePortal==true then
		return OP
	elseif lie==2 and RedPortal==true then
		return RP
	elseif lie==3 and BluePortal==true then
		return BP
	elseif lie==4 and DarkPortal==true then
		return DP
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
	isLoaded=true
	room=value
	BuildMap()
end


	--[[ KEY
		1-upper opening
		2-left opening
		3-right opening
		4-lower opening
		a-start					b-boundary
		c-						d-break/wall
		e-mobspawner				f-
		g-						h-healpad
		i-energypad				j-manapad
		k-keyblock				l-lava
		m-orange					n-blue
		ñ-red					o-wall
		p-						q-alwaysbreakable
		r-random					s-shop
		t-						u-darkblue
		v-						w-water
		x-walkable				y-
		z-finish	

		H = 10x10
		S = 20x20
		M = 30x30
		L = 40x40
	--]]
	
local xside=	20
local yside=	20
local passed
local espacio=120
local xinicial=display.contentCenterX-(espacio)
local yinicial=display.contentCenterY-(espacio)
local mapprogress=0
local ptries=0

function Tiles()
	TSet=o.GetTiles()
	
	portalorangesheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/porange.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	portalbluesheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/pblue.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	portalredsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/pred.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	portaldarkbluesheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/pdarkblue.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	watersheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/water.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	HealPadsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/hpad.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	ManaPadsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/mpad.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	EnergyPadsheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/epad.png", 
		{ width=80, height=80, numFrames=30 }
	)
	
	spawnersheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/spawner.png", 
		{ width=80, height=80, numFrames=30 }
	)
	mseqs={
		{name="on", start=1, count=20, time=1750},
		{name="off", start=21, count=10, loopCount=1, time=900},
	}
	
	lavasheet = graphics.newImageSheet( 
		"tiles/"..TSet.."/lava.png", 
		{ width=80, height=80, numFrames=20 } 
	)
	
	Progress()
end

function Template()
	map={}
	map.xside=xside
	map.yside=yside
	map.portals={}
	for i=1,xside*yside do
		map[i]=0
		local x=(((i-1)%xside))
		local y=(math.floor((i-1)/xside))
		if x==0 or x==xside-1 or y==0 or y==yside-1 then
			if math.ceil(xside/2)==x+1 then
				if y==0 then
					map[i]=1
					map.upper1=i
				elseif y==yside-1 then
					map[i]=1
					map.lower1=i
				end
			elseif (xside/2)+1==x+1 then
				if y==0 then
					map[i]=1
					map.upper2=i
				elseif y==yside-1 then
					map[i]=1
					map.lower2=i
				end
			elseif math.ceil(yside/2)==y+1 then
				if x==0 then
					map[i]=1
					map.left1=i
				elseif x==xside-1 then
					map[i]=1
					map.right1=i
				end
			elseif (yside/2)+1==y+1 then
				if x==0 then
					map[i]=1
					map.left2=i
				elseif x==xside-1 then
					map[i]=1
					map.right2=i
				end
			else
				map[i]=1
			end
		else
			if i==xside+2 then
				map[i]=0
				map.start=i
			elseif i==(xside*yside)-(xside+1) then
				map[i]=0
				map.finish=i
			end
		end
	end
	Progress()
end

function Walls()
	for i=1,table.maxn(map) do
		if map[i]==0 and map.finish~=i and map.start~=i then
			local rand=math.random(1,10)
			if rand>7 then
				map[i]=1
			end
		end
	end
	Progress()
end

function toExitPortal()
	print "TRYING EXIT PORTALS"
	local number,ids=numTiles(map.finish)
	local number2,ids2=numTiles(map.start)
	if number>1 and number2>1 then
		-- print "EXIT PORTALS POSSIBLE"
		print "FIRST PORTAL"
		local portalone=nil
		local portaltwo=nil
		local foundtwo=false
		local spot=map.finish
		for i=1,table.maxn(ids) do
				print (i..". "..ids[i].."<"..spot.." ?")
			if ids[i]<spot then
				print ("Yes")
				spot=ids[i]
			else
				print ("No")
			end
		end
		portalone=spot
		print (portalone)
		-- print "PLANTED FIRST PORTAL"
		
		print "SECOND PORTAL"
		for i=1,table.maxn(tileavailable) do
			if tileavailable[i]==true and map[i]==0 and i~=map.start and i~=map.finish then
				local rand=math.random(1,10)
				if foundtwo==false and rand>1 then
					print ("!! "..i)
					foundtwo=true
					portaltwo=i
				end
			end
		end
		
		
		if foundtwo==true then
			print (portaltwo)
			mapprogress=mapprogress-1
			print "PLANTED SECOND PORTAL; CONTINUE"
			print "NOW SAVING"
			map[portalone]="@"
			map[portaltwo]="@"
			map.portals[#map.portals+1]=portalone
			map.portals[#map.portals+1]=portaltwo
			print (map.portals[1])
			print (portalone)
			print (map.portals[2])
			print (portaltwo)
			Expand(portalone)
			passed=true
			print "Passed."
			Progress()
		else
			print "FAILED TO PLANT SECOND PORTAL; RETRY"
			toExitPortal()
		end
	else
		print "EXIT PORTALS FAILED; RETRY MAP"
		mapprogress=0
		print "Failed."
		Progress()
	end
end

function ClosedPortal()
	print "TRYING CLOSED PORTALS"
	local foundone=false
	local didone=false
	local portalone=nil
	for i=1,table.maxn(tileavailable) do
		if tileavailable[i]==false and map[i]==0 then
			if foundone==false then
				foundone=true
				local amount=numTiles(i)
				if amount>=5 then
					didone=true
					-- print "GLaDOS"
					portalone=i
				else
					map[i]=1
				end
			end
		end
	end
	-- print "DID STEP ONE"
	-- local theportalexists=false
	-- for i=1,table.maxn(map) do
		-- if map[i]=="!!" then
			-- theportalexists=true
		-- end
	-- end
	-- print "GO FOR STEP TWO"
	-- if foundone==true and theportalexists==true then
	if foundone==true and didone==true then
		-- print "true ; true"
		local foundtwo=false
		local portaltwo=nil
		ptries=ptries+1
		print (ptries)
		for i=1,table.maxn(tileavailable) do
			if tileavailable[i]==true and map[i]==0 and i~=map.start and i~=map.finish then
				local rand=math.random(1,10)
				if foundtwo==false then
					if rand>9 or ptries>10 then
						foundtwo=true
						portaltwo=i
						-- print (i)
					end
				end
			end
		end
		-- print "DID STEP TWO"
		
		if foundtwo==true then
			print "OUT; SUCCESS"
			map[portalone]="@"
			map[portaltwo]="@"
			map.portals[#map.portals+1]=portalone
			map.portals[#map.portals+1]=portaltwo
			Expand(portalone)
			Progress()
		else
			print "RETRY STEP TWO"
			ClosedPortal()
		end
	elseif foundone==true and didone==false then
		print "RETRY"
		ClosedPortal()
	elseif foundone==false then
		print "OUT; FAILED"
		Progress()
	end
end

function Pathfinding()
	local done=false
	local tileexpanded={}
	tileavailable={}
	for i=1,table.maxn(map) do
		tileexpanded[i]=false
		tileavailable[i]=false
	end
	tileavailable[map.start]=true
	while done==false do
		for i=1,table.maxn(tileavailable) do
			if tileavailable[i]==true and tileexpanded[i]==false then
				-- tokens[i]:setFillColor(0,1,0)
				if map[i-1]==0 then
					tileavailable[i-1]=true
				else
					-- tokens[i-1]:setFillColor(1,0,0)
				end
				if map[i+1]==0 then
					tileavailable[i+1]=true
				else
					-- tokens[i+1]:setFillColor(1,0,0)
				end
				if map[i-xside]==0 then
					tileavailable[i-xside]=true
				else
					-- tokens[i-xside]:setFillColor(1,0,0)
				end
				if map[i+xside]==0 then
					tileavailable[i+xside]=true
				else
					-- tokens[i+xside]:setFillColor(1,0,0)
				end
				tileexpanded[i]=true
			end
		end
		done=true
		for i=1,table.maxn(tileavailable) do
			if tileavailable[i]==true and tileexpanded[i]==false then
				done=false
			end
		end
	end
	if tileavailable[map.finish]==true then
		passed=true
		print "Passed."
	else
		passed=false
		print "Failed."
	end
	Progress()
end

function Expand(start)
	local done=false
	local tileexpanded={}
	local tileavailable2={}
	for i=1,table.maxn(map) do
		tileexpanded[i]=false
		tileavailable2[i]=false
	end
	tileavailable2[start]=true
	while done==false do
		for i=1,table.maxn(tileavailable) do
			if tileavailable2[i]==true and tileexpanded[i]==false then
				-- tokens[i]:setFillColor(0,1,0)
				if map[i-1]==0 then
					tileavailable[i-1]=true
					tileavailable2[i-1]=true
				else
					-- tokens[i-1]:setFillColor(1,0,0)
				end
				if map[i+1]==0 then
					tileavailable[i+1]=true
					tileavailable2[i+1]=true
				else
					-- tokens[i+1]:setFillColor(1,0,0)
				end
				if map[i-xside]==0 then
					tileavailable[i-xside]=true
					tileavailable2[i-xside]=true
				else
					-- tokens[i-xside]:setFillColor(1,0,0)
				end
				if map[i+xside]==0 then
					tileavailable[i+xside]=true
					tileavailable2[i+xside]=true
				else
					-- tokens[i+xside]:setFillColor(1,0,0)
				end
				tileexpanded[i]=true
				if map[i]~="@" and map[i]~="@" then
					map[i]=0
				end
			end
		end
		done=true
		for i=1,table.maxn(tileavailable2) do
			if tileavailable2[i]==true and tileexpanded[i]==false then
				done=false
			end
		end
	end
end

function numTiles(start)
	local done=false
	local tileexpand={}
	local tileable={}
	local tiles=0
	local tileids={}
	for i=1,table.maxn(map) do
		tileexpand[i]=false
		tileable[i]=false
	end
	tileable[start]=true
	-- tileids[#tileids+1]=start
	-- tiles=tiles+1
	while done==false do
		for i=1,table.maxn(tileable) do
			if tileable[i]==true and tileexpand[i]==false then
				-- tokens[i]:setFillColor(0,1,0)
				if map[i-1]==0 then
					tileable[i-1]=true
				else
					-- tokens[i-1]:setFillColor(1,0,0)
				end
				if map[i+1]==0 then
					tileable[i+1]=true
				else
					-- tokens[i+1]:setFillColor(1,0,0)
				end
				if map[i-xside]==0 then
					tileable[i-xside]=true
				else
					-- tokens[i-xside]:setFillColor(1,0,0)
				end
				if map[i+xside]==0 then
					tileable[i+xside]=true
				else
					-- tokens[i+xside]:setFillColor(1,0,0)
				end
				tileexpand[i]=true
				tiles=tiles+1
				tileids[#tileids+1]=i
			end
		end
		done=true
		for i=1,table.maxn(tileable) do
			if tileable[i]==true and tileexpand[i]==false then
				done=false
			end
		end
	end
	return tiles, tileids
end

function Clean()
	for i=1,table.maxn(tileavailable) do
		if tileavailable[i]==false and map[i]==0 then
			map[i]=1
		end
	end
	Progress()
end

function Visualize()
	if not(tiles) then
		tiles={}
		specials={}
		Level=display.newGroup()
	end
	for i=1,table.maxn(map) do
		if not (tiles[i]) then
			-- tiles[i]=display.newRect(0,0,espacio,espacio)
			
			if map[i]==1 then -- WALL OR NAH
				tiles[i]=display.newImageRect("tiles/"..TSet.."/wall"..math.random(1,3)..".png",espacio,espacio)
				physics.addBody(tiles[i], "static", { friction=0.5} )
				tiles[i].type="wall"
			else
				tiles[i]=display.newImageRect("tiles/"..TSet.."/walk"..math.random(1,2)..".png",espacio,espacio)
				physics.addBody(tiles[i], "static",  { isSensor=true, friction=0.5} )
				function closure( event )
					-- print (event.phase.." - "..i)
					event.id=i
					col.Interact( event )
				end
				tiles[i]:addEventListener("collision",closure)
				tiles[i].type="path"
			end
			tiles[i].x=xinicial+((((i-1)%xside))*espacio)
			tiles[i].y=yinicial+(math.floor((i-1)/xside)*espacio)
			Level:insert(tiles[i])
			
			if map[i]=="@" then -- PORTAL
				local id=nil
				for b=1,table.maxn(map.portals) do
					print (b.. ". "..map.portals[b].." ?= "..i)
					if map.portals[b]==i then
						print ("FOUND PORTAL IN ID "..i.." WITH COLOR "..b)
						id=b
					end
				end
				
				local portalsprites={portalorangesheet,portalbluesheet,portalredsheet,portaldarkbluesheet}
				print ("@ - "..i..". color - "..id)
				
				specials[i]=display.newSprite( portalsprites[id], {name="sequence",	start=1, count=20, time=1750} )
				specials[i].type="portal"
				specials[i].color=id
				specials[i].id=i
				if id%2==0 then
					specials[i].link=map.portals[id-1]
				else
					specials[i].link=map.portals[id+1]
				end
			end
			
			if (specials[i]) then
				if specials[i].sequence=="sequence" then
					specials[i]:play()
					specials[i].xScale=espacio/80
					specials[i].yScale=espacio/80
				end
				specials[i].x=tiles[i].x
				specials[i].y=tiles[i].y
				Level:insert(specials[i])
			end
			
			-- if map[i]=="Q" then
				-- tiles[i].text=display.newText("P1",0,0,native.systemFont,40)
			-- elseif map[i]=="@" then
				-- tiles[i].text=display.newText("P2",0,0,native.systemFont,40)
			-- else
				-- tiles[i].text=display.newText(i,0,0,native.systemFont,40)
			-- end
				-- tiles[i].text:setFillColor(1,1,1)
				-- tiles[i].text.x=tiles[i].x
				-- tiles[i].text.y=tiles[i].y
				-- Level:insert(tiles[i].text)
			
			-- print ("start "..map.start)
			-- print ("finish "..map.finish)
			
			-- print ((i-1).." - "..tiles[i].y)
		end
	end
	Progress()
end

function removeVisuals()
	if (tiles) then
		local parent=tiles
		for i=table.maxn(parent),1,-1 do
			display.remove(parent[i])
			parent[i]=nil
		end
		parent=nil
	end
	if (specials) then
		local parent=specials
		for i=table.maxn(parent),1,-1 do
			display.remove(parent[i])
			parent[i]=nil
		end
		parent=nil
	end
	if (Level) then
		local parent=Level
		for i=parent.numChildren,1,-1 do
			display.remove(parent[i])
			parent[i]=nil
		end
		parent=nil
	end
end

function Extras()
	Progress()
end

function Progress()
	local funcs={Template,Walls,Pathfinding,ClosedPortal,Clean,Extras,Tiles,Visualize,Visualize}
	local funcnames={"Template","Walls","Pathfinding","Closed Portal","Clean","Extras","Tiles","Visualize","Visualize 2","Start"}
	mapprogress=mapprogress+1
	ptries=0
	if mapprogress==4 and passed==false then
		print ("toExitPortal")
		toExitPortal()
	else
		print (funcnames[mapprogress])
		if mapprogress>table.maxn(funcs) then
			p.getMap(Level)
			su.Continue()
		elseif mapprogress==table.maxn(funcs) then
			timer.performWithDelay(1,funcs[mapprogress])
		else
			timer.performWithDelay(500,funcs[mapprogress])
		end
	end
end

function getData( info )
	if info==0 then -- TILES
		return tiles
	end
	if info==1 then -- SPECIALS
		return specials
	end
end
