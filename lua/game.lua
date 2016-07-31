---------------------------------------------------------------------------------------
--
-- Game.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)

-- FORWARD CALLS
local mapsDone=false
local maxmap=1000
local displayedRegions={}
local spawnedEnemies={}

---------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
---------------------------------------------------------------------------------------

local function getLowestMap()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local xi
	local yi
	local map
	local compx
	local compy
	-- LOCAL FUNCTIONS
	
	-- # BODY
	xi=displayedRegions[1].POSITION.BEGIN.x
	yi=displayedRegions[1].POSITION.BEGIN.y
	
	map=1
	for i=1,4 do
		if (displayedRegions[i]) then
			compx=displayedRegions[i].POSITION.BEGIN.x
			compy=displayedRegions[i].POSITION.BEGIN.y
			if (compx<=xi) and (compy<=yi) then
				map=i
			end
		end
	end
	
	-- # CLOSING
	return map
end

local function getLowestMapPosition()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local xi
	local yi
	-- LOCAL FUNCTIONS
	
	-- # BODY
	xi=displayedRegions[getLowestMap()].POSITION.BEGIN.x
	yi=displayedRegions[getLowestMap()].POSITION.BEGIN.y
	
	-- # CLOSING
	return xi,yi
end

local function getLowestMapCoordinates()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local xi
	local yi
	-- LOCAL FUNCTIONS
	
	-- # BODY
	xi=displayedRegions[getLowestMap()]["MAPX"]
	yi=displayedRegions[getLowestMap()]["MAPY"]
	
	-- # CLOSING
	return xi,yi
end

local function getLowestMapTileCoordinates()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local xi
	local yi
	-- LOCAL FUNCTIONS
	
	-- # BODY
	xi=displayedRegions[getLowestMap()].POSITION.TILE.x
	yi=displayedRegions[getLowestMap()].POSITION.TILE.y
	
	-- # CLOSING
	return xi,yi
end

local function checkPlayerAttackContact()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local framecheck
	local hitSomeone
	local obj1
	local obj2
	local left
	local right
	local up
	local down
	local thisCycle
	local damageDealt
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if p1["SEQUENCE"]=="SWING" then
		framecheck=p1["CURFRAME"]>10 and p1["CURFRAME"]<20
		if framecheck then
			hitSomeone=false
			obj1=p1["WEAPON"]
			if (obj1) then
				for i=1,table.maxn(spawnedEnemies) do
					if (spawnedEnemies[i]) then
						obj2=spawnedEnemies[i]["HitBox"]
						if (obj2) then
							
							left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
							right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
							up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
							down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
							
							thisCycle=(left or right) and (up or down)
							if thisCycle==true then
								damageDealt=obj1.basedamage
								if damageDealt>0 then
									damageDealt=damageDealt*-1
								end
								-- print "WHAM!"
								spawnedEnemies[i]:ModifyHealth(damageDealt)
							end
							
							hitSomeone=hitSomeone or thisCycle
						end
					end
				end
			end
		end
	end
	
	-- # CLOSING
	if p1["SEQUENCE"]~="SWING" or hitSomeone==true then
		Runtime:removeEventListener("enterFrame",Controls.playerHits)
	end
end

local function quadCheck()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local xm
	local ym
	local newquad
	-- LOCAL FUNCTIONS
	
	-- # BODY
	xm=displayedRegions[1].POSITION.MID.x
	ym=displayedRegions[1].POSITION.MID.y
	
	if (xm) and (ym) then
		newquad=1
		
		if p1.x>xm then
			newquad=newquad+1
		end
		
		if p1.y>ym then
			newquad=newquad+2
		end
	end
	
	-- # CLOSING
	if p1.POSITION.REGION.q~=newquad then
		return newquad
	end
	return nil
end

local function checkPlayerCoordinates()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local lowestX
	local lowestY
	local lowestTileX
	local lowestTileY
	local deltaY
	local tileSizeY
	local tileY
	local deltaX
	local tileSizeX
	local tileX
	local xi
	local yi
	local xf
	local yf
	local newmapx
	local newmapy
	local quadchange
	-- LOCAL FUNCTIONS
	
	-- # BODY
	lowestX,lowestY=getLowestMapPosition()
	lowestTileX,lowestTileY=getLowestMapTileCoordinates()
	
	deltaY=p1.y-lowestY
	tileSizeY=200
	tileSizeY=(tileSizeY/1.5)+(tileSizeY/3)
	tileY=math.floor(deltaY/tileSizeY)+1
	-- tileY=tileY+lowestTileY
	
	deltaX=p1.x-lowestX
	tileSizeX=200
	tileSizeX=(tileSizeX)+(tileSizeX/3)
	tileX=math.floor(deltaX/tileSizeX)+1
	-- tileX=tileX+lowestTileX
	
	if p1.POSITION.REGIONAL.x~=tileX or p1.POSITION.REGIONAL.y~=tileY then
	
		p1.POSITION.REGIONAL.x=tileX
		p1.POSITION.REGIONAL.y=tileY
		
		p1.POSITION.GLOBAL.x=tileX+lowestTileX
		p1.POSITION.GLOBAL.y=tileY+lowestTileY
		
		if p1.POSITION.REGIONAL.y~=tileY then
			print ("PLAYER Y: "..tileY)
		end
		
		xi=displayedRegions[1].POSITION.BEGIN.x
		yi=displayedRegions[1].POSITION.BEGIN.y
		
		xf=displayedRegions[1].POSITION.END.x
		yf=displayedRegions[1].POSITION.END.y
		
		newmapx=0
		newmapy=0
		
		if p1.x>xf then
			-- print "OVER X"
			newmapx=newmapx+1
		elseif p1.x<xi then
			-- print "UNDER X"
			newmapx=newmapx-1
		end
		
		if p1.y>yf then
			-- print "OVER Y"
			newmapy=newmapy+1
		elseif p1.y<yi then
			-- print "UNDER Y"
			newmapy=newmapy-1
		end
		
		quadchange=quadCheck()
		
		if newmapx~=0 or newmapy~=0 or (quadchange) then
			HandleRegions:regionSwitch(newmapx,newmapy,quadchange)
		end
	end
	
	-- # CLOSING
end



---------------------------------------------------------------------------------------
-- STARTUP
---------------------------------------------------------------------------------------

Initial={}


function Initial:loadScreen()
	-- # OPENING
	-- DEPENDENCIES
	local splash=require("lua.splash")
	local ui=require("lua.ui")
	-- FORWARD CALLS
	LoadingScreen=display.newGroup()
	local loadsheet
	local loadbkg
	local load1
	local load2
	local load3
	local loadtxt
	local tip
	local tipbkg
	-- LOCAL FUNCTIONS
	
	-- # BODY
	loadsheet = graphics.newImageSheet( "ui/spriteload.png", { width=50, height=50, numFrames=8 } )
	
	loadbkg=ui.CreateWindow(420,180,2)
	loadbkg.x = display.contentWidth-160
	loadbkg.y = display.contentHeight-130
	loadbkg:setFillColor(0.75,0.1,0.1)
	LoadingScreen:insert(loadbkg)
	
	load1 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load1.x = display.contentWidth-50
	load1.y = display.contentHeight-100
	load1:play()
	LoadingScreen:insert( load1 )
	
	load2 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load2.x = load1.x-55
	load2.y = load1.y
	load2:play()
	LoadingScreen:insert( load2 )
	
	load3 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load3.x = load2.x+30
	load3.y = load2.y-50
	load3:play()
	LoadingScreen:insert( load3 )
	
	loadtxt = display.newText("Loading...", 0,0,"Game Over",100)
	loadtxt.x = load2.x-150
	loadtxt.y = load1.y
	LoadingScreen:insert( loadtxt )
	
	tip=splash.GetTip()
	LoadingScreen:insert( tip )
	
	tipbkg=ui.CreateWindow(tip.width+40,tip.height+30,2)
	tipbkg.x=tip.x
	tipbkg.y=tip.y-15+(((tip.height/64)-1)*30)
	tipbkg:setFillColor(0.4,0.4,0.4)
	LoadingScreen:insert(tipbkg)
	
	-- # CLOSING
	tip:toFront()
end

function Initial:create(slot,value)
	-- # OPENING
	-- DEPENDENCIES
	local entity=require("lua.entities")
	local per=require("lua.perspective")
	local save=require("lua.save")
	-- FORWARD CALLS
	local data
	-- LOCAL FUNCTIONS
	
	-- # BODY
	Initial:loadScreen()
	save.setSlot(slot)
	view=per.createView()
	data=save.Load:retrieveData()
	p1=entity.CreatePlayer( value )
	if (data) then
		LoadData:setPlayerValues(data)
	end
	
	-- # CLOSING
	Initial:wait()
	HandleRegions:regionDisplay()
end

function Initial:wait()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if (mapsDone==false) then
		timer.performWithDelay(250,Initial.wait)
	else
		Initial:Continue()
	end
	
	-- # CLOSING
end

function Initial:Continue()
	-- # OPENING
	-- DEPENDENCIES
	local ui=require("lua.ui")
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for i=LoadingScreen.numChildren,1,-1 do
		if (LoadingScreen[i]) then
			display.remove(LoadingScreen[i])
			LoadingScreen[i]=nil
		end
	end
	LoadingScreen=nil
	
	ui.Essentials()
	ui.Controls:show()
	view:add(p1,35,true)
	view:setBounds(false)
	view:track()
	-- HandleEnemies:start()
	-- Initial:firstSave()
	Runtime:addEventListener("enterFrame",HandleEnemies.frameChecks)
	Runtime:addEventListener("enterFrame",checkPlayerCoordinates)
	
	-- # CLOSING
	Controls:Move(0,0)
end

function Initial:firstSave()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for map=1,table.maxn(displayedRegions) do
		if (displayedRegions[map]) then
			save.Save:keepMapData(displayedRegions[map])
		end
	end
	
	-- # CLOSING
	save.Save:keepPlayerData(p1)
	save.Save:recordData()
end



---------------------------------------------------------------------------------------
-- HANDLE MAPS
---------------------------------------------------------------------------------------

HandleRegions={}


function HandleRegions:getEmptyRegion()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local spot
	local found
	-- LOCAL FUNCTIONS
	
	-- # BODY
	spot=1
	found=false
	while spot<=1 and found==false do
		if displayedRegions[spot]==nil then
			found=true
		else
			spot=spot+1
		end
	end
	if found==false then
		spot=nil
	end
	
	-- # CLOSING
	return spot
end

function HandleRegions:regionDisplay()
	-- # OPENING
	-- DEPENDENCIES
	local builder=require("lua.builder")
	local save=require("lua.save")
	-- FORWARD CALLS
	local mapstodisplay
	local side
	local tile
	local deltaX
	local deltaY
	local result
	local nx
	local ny
	local npx
	local npy
	local mapinfo
	-- LOCAL FUNCTIONS
	
	-- # BODY
	mapsDone=false
	mapstodisplay={
		{ p1.POSITION.REGION.x,p1.POSITION.REGION.y},
		{},
		{},
		{}
	}
	
	side=14
	tile=200
	deltaX=side/2
	deltaX=(deltaX*tile)+(deltaX*(tile/3))
	deltaY=side/2
	deltaY=(deltaY*(tile/1.5))+(deltaY*(tile/3))
	
	if (displayedRegions[1]) then
		mapstodisplay[1][3]=displayedRegions[1].Xi or display.contentCenterX-(tile/2)
		mapstodisplay[1][4]=displayedRegions[1].Yi or display.contentCenterY-(tile/2)
	else
		mapstodisplay[1][3]=display.contentCenterX-(tile/2)
		mapstodisplay[1][4]=display.contentCenterY-(tile/2)
	end
	
	if p1.POSITION.REGION.q%2==0 then
		mapstodisplay[2]={
			mapstodisplay[1][1]+1,
			mapstodisplay[1][2],
		}
		mapstodisplay[2][3]=mapstodisplay[1][3]+deltaX
	else
		mapstodisplay[2]={
			mapstodisplay[1][1]-1,
			mapstodisplay[1][2],
		}
		mapstodisplay[2][3]=mapstodisplay[1][3]-deltaX
	end
	mapstodisplay[2][4]=mapstodisplay[1][4]
	
	if p1.POSITION.REGION.q<3 then
		mapstodisplay[3]={
			mapstodisplay[1][1],
			mapstodisplay[1][2]-1,
		}
		mapstodisplay[3][4]=mapstodisplay[1][4]-deltaY
	else
		mapstodisplay[3]={
			mapstodisplay[1][1],
			mapstodisplay[1][2]+1,
		}
		mapstodisplay[3][4]=mapstodisplay[1][4]+deltaY
	end
	mapstodisplay[3][3]=mapstodisplay[1][3]
	
	for m=2,3 do
		for v=1,2 do
			if mapstodisplay[m][v]>maxmap then
				mapstodisplay[m][v]=-maxmap
			elseif  mapstodisplay[m][v]<-maxmap then
				mapstodisplay[m][v]=maxmap
			end
		end
	end
	
	mapstodisplay[4]={mapstodisplay[2][1],mapstodisplay[3][2],mapstodisplay[2][3],mapstodisplay[3][4]}
	
	for m in ipairs(displayedRegions) do
		if (displayedRegions[m].POSITION.REGION.x~=mapstodisplay[m][1]) or (displayedRegions[m].POSITION.REGION.y~=mapstodisplay[m][2]) then
			HandleRegions:cleanRegion(m)
		end
	end
	
	result=HandleRegions:getEmptyRegion()
	if (result) then
		nx=mapstodisplay[result][1]
		ny=mapstodisplay[result][2]
		npx=mapstodisplay[result][3]
		npy=mapstodisplay[result][4]
		
		mapinfo=save.Load:getMap(nx,ny)
		-- print ("SEQUENCING: "..nx,ny,mapinfo)
		builder.Create:Start(nx,ny,mapinfo,npx,npy,maxmap)
	else
		for m in ipairs(displayedRegions) do
			displayedRegions[m].Level.isVisible=true
			for r in ipairs(displayedRegions[m].regRows) do
				displayedRegions[m].regRows[r].isVisible=true
			end
		end
		HandleRegions:buildBoundary()
		-- HandleRows:InitialLayering()
		mapsDone=true
	end
	
	-- # CLOSING
end

function HandleRegions:buildBoundary()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	--[[
	local order={}
	if displayedRegions[4] then
		if displayedRegions[4]["MAPY"]<displayedRegions[1]["MAPY"] then
			if displayedRegions[4]["MAPX"]<displayedRegions[1]["MAPX"] then
				-- map4 is northwest
				order={4,3,2,1}
			else
				-- map4 is northeast
				order={3,4,1,2}
			end
		else
			if displayedRegions[4]["MAPX"]<displayedRegions[1]["MAPX"] then
				-- map4 is southwest
				order={2,1,4,3}
			else
				-- map4 is southeast
				order={1,2,3,4}
			end
		end
	else
		order={1}
	end
	local mapsize=table.maxn(displayedRegions[1]["PLAIN"])
	if (displayb) then
		for x=1,mapsize*2 do
			for y=1,mapsize*2 do
				display.remove(displayb[x][y])
			end
		end
	end
	
	if (displayb) then
		if (displayb["MAP"]) then
			for i=1,4 do
			display.remove(displayb["MAP"][i])
			end
		end
	end
	
	displayb={}
	local boundary={}
	for x=1,mapsize*2 do
		boundary[x]={}
		displayb[x]={}
		for y=1,mapsize*2 do
			local orderpos=1
			ax=x
			if ax>mapsize then
				ax=ax-mapsize
				orderpos=orderpos+1
			end
			local ay=y
			if ay>mapsize then
				ay=ay-mapsize
				orderpos=orderpos+2
			end
			
			displayb[x][y]=display.newRect(x*10,y*10,10,10)
			
			if order[orderpos] then
				boundary[x][y]=displayedRegions[order[orderpos] ]["PLAIN"][ay][ax]
			else
				boundary[x][y]=2
			end
			if boundary[x][y]==1 then
				displayb[x][y]:setFillColor(0.5,0,0,0.8)
			elseif boundary[x][y]==0 then
				displayb[x][y]:setFillColor(1,1,1,0.4)
			else
				display.remove(displayb[x][y])
			end
		end
	end
	
	displayedRegions["BOUNDS"]=boundary
	]]
	
	-- # CLOSING
end

function HandleRegions:setRegion(regionParam)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local result
	local row
	-- LOCAL FUNCTIONS
	
	-- # BODY
	result=HandleRegions:getEmptyRegion()
	if (result) then
		displayedRegions[result]=regionParam
		
		for i=1,table.maxn(regionParam["regRows"]) do
			row=regionParam["regRows"][i]
			view:add(row,69,false)
		end
		view:add(regionParam.Level,70,false)
		
		HandleRegions:regionDisplay()
	end
	
	-- # CLOSING
end

function HandleRegions:getRegion(mapx,mapy)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local id
	local map
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for i=1,table.maxn(displayedRegions) do
		if (displayedRegions[i]) then
			if displayedRegions[i]["MAPX"]==mapx and displayedRegions[i]["MAPY"]==mapy then
				id=i
				map=displayedRegions[i]
			end
		end
	end
	
	-- # CLOSING
	return id,map
end

function HandleRegions:cleanRegion(victim)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if (displayedRegions[victim]["PHYSICS"]) then
		for a in ipairs(displayedRegions[victim]["PHYSICS"]) do
			display.remove(displayedRegions[victim]["PHYSICS"][a])
			displayedRegions[victim]["PHYSICS"][a]=nil
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	if (displayedRegions[victim]["TOP"]) then
		for a in ipairs(displayedRegions[victim]["TOP"]) do
			display.remove(displayedRegions[victim]["TOP"][a])
			displayedRegions[victim]["TOP"][a]=nil
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	if (displayedRegions[victim]["SIDE"]) then
		for a in ipairs(displayedRegions[victim]["SIDE"]) do
			display.remove(displayedRegions[victim]["SIDE"][a])
			displayedRegions[victim]["SIDE"][a]=nil
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	if (displayedRegions[victim]["TILE"]) then
		for a in ipairs(displayedRegions[victim]["TILE"]) do
			display.remove(displayedRegions[victim]["TILE"][a])
			displayedRegions[victim]["TILE"][a]=nil
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	if (displayedRegions[victim]["Gradients"]) then
		for a in ipairs(displayedRegions[victim]["Gradients"]) do
			for b in ipairs(displayedRegions[victim]["Gradients"][a]) do
				display.remove(displayedRegions[victim]["Gradients"][a][b])
				displayedRegions[victim]["Gradients"][a][b]=nil
			end
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	displayedRegions[victim]=nil
	
	-- # CLOSING
end

--[[
function HandleRegions:movementEvents()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local pastx
	local pasty
	local newx
	local newy
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
	-- pastx,pasty=p1.POSITION.GLOBAL.x*2,p1.POSITION.GLOBAL.y*2
	-- if displayedRegions[4]["MAPX"]<displayedRegions[1]["MAPX"] then
		-- pastx=pastx+table.maxn(displayedRegions[1]["PLAIN"])
	-- end
	-- if displayedRegions[4]["MAPY"]<displayedRegions[1]["MAPY"] then
		-- pasty=pasty+table.maxn(displayedRegions[1]["PLAIN"])
	-- end
	-- if (pastx) and (pasty) then
		-- displayb[pastx][pasty]:setFillColor(1,1,1,0.4)
	-- end
	
	-- HandleRegions:mapSwitch()
	
	-- local newx,newy=deltaX*2,deltaY*2
	-- newx,newy=p1.POSITION.GLOBAL.x*2,p1.POSITION.GLOBAL.y*2
	-- if displayedRegions[4]["MAPX"]<displayedRegions[1]["MAPX"] then
		-- newx=newx+table.maxn(displayedRegions[1]["PLAIN"])
	-- end
	-- if displayedRegions[4]["MAPY"]<displayedRegions[1]["MAPY"] then
		-- newy=newy+table.maxn(displayedRegions[1]["PLAIN"])
	-- end
	
	-- displayb[newx][newy]:setFillColor(0,0,1,0.8)
	
	-- # CLOSING
end
--]]

function HandleRegions:regionSwitch(mapxparam,mapyparam,quadparam)
	-- # OPENING
	-- DEPENDENCIES
	local save=require("lua.save")
	-- FORWARD CALLS
	local temp
	local constant
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if mapxparam~=0 or mapyparam~=0 then
		p1.POSITION.REGION.x=p1.POSITION.REGION.x+mapxparam
		p1.POSITION.REGION.y=p1.POSITION.REGION.y+mapyparam
		
		if math.abs(p1.POSITION.REGION.x)>maxmap then
			p1.POSITION.REGION.x=(p1.POSITION.REGION.x/math.abs(p1["MAPX"]))
			p1.POSITION.REGION.x=p1.POSITION.REGION.x*-1
			p1.POSITION.REGION.x=maxmap*p1.POSITION.REGION.x
		end
		if math.abs(p1.POSITION.REGION.y)>maxmap then
			p1.POSITION.REGION.y=(p1.POSITION.REGION.y/math.abs(p1["MAPY"]))
			p1.POSITION.REGION.y=p1.POSITION.REGION.y*-1
			p1.POSITION.REGION.y=maxmap*p1.POSITION.REGION.y
		end
		
		for i in ipairs(displayedRegions) do
			if displayedRegions[i].POSITION.REGION.x==p1.POSITION.REGION.x and 
			displayedRegions[i].POSITION.REGION.y==p1.POSITION.REGION.y then
				temp=displayedRegions[i]
				displayedRegions[i]=displayedRegions[1]
				displayedRegions[1]=temp
			end
		end
		
		for i in ipairs(displayedRegions) do
			if displayedRegions[i].POSITION.REGION.x~=p1.POSITION.REGION.x and 
			displayedRegions[i].POSITION.REGION.y==p1.POSITION.REGION.y then
				temp=displayedRegions[i]
				displayedRegions[i]=displayedRegions[2]
				displayedRegions[2]=temp
			end
		end
		if (displayedRegions[4]) then
			if displayedRegions[4].POSITION.REGION.x==p1.POSITION.REGION.x and 
			displayedRegions[4].POSITION.REGION.y~=p1.POSITION.REGION.y then
				temp=displayedRegions[4]
				displayedRegions[4]=displayedRegions[3]
				displayedRegions[3]=temp
			end
		end
		p1.POSITION.REGION.q=quadCheck()
		if not(p1.POSITION.REGION.q) then
			p1.POSITION.REGION.q=-1
		end
		-- print ("MAP CHANGE: "..p1["MAPX"],p1["MAPY"],p1["QUAD"])
		-- HandleRows:InitialLayering()
	elseif (quadparam) then
	
		for i in ipairs(displayedRegions) do
			save.Save:keepMapData(displayedRegions[i])
		end
		
		constant="X"
		if quadparam%2==0 and p1.POSITION.REGION.q%2==0 then
			constant="Y"
		elseif quadparam%2==1 and p1.POSITION.REGION.q%2==1 then
			constant="Y"
		end
		
		p1.POSITION.REGION.q=quadparam
		
		for i in ipairs(displayedRegions) do
			if displayedRegions[i].POSITION.REGION.x~=p1.POSITION.REGION.x and constant=="X" then
				HandleRegions:cleanRegion(i)
			elseif displayedRegions[i].POSITION.REGION.y~=p1.POSITION.REGION.y and constant=="Y" then
				HandleRegions:cleanRegion(i)
			end
		end
		
		-- print ("QUAD CHANGE: "..p1["MAPX"],p1["MAPY"],p1["QUAD"])
		HandleRegions:regionDisplay()
	end

	-- # CLOSING
end




---------------------------------------------------------------------------------------
-- ENEMIES
---------------------------------------------------------------------------------------

HandleEnemies={}


function HandleEnemies:start()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if( HandleEnemies:findSpot() ) then
		HandleEnemies:spawn()
	end
	
	-- # CLOSING
	-- timer.performWithDelay(2500,HandleEnemies.start)
end

function HandleEnemies:findSpot()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local spot
	local found
	-- LOCAL FUNCTIONS
	
	-- # BODY
	spot=1
	found=false
	while spot<=20 and found==false do
		if spawnedEnemies[spot]==nil then
			found=true
		else
			spot=spot+1
		end
	end
	if found==false then
		spot=nil
	end
	
	-- # CLOSING
	return spot
end

function HandleEnemies:spawn()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local result
	local angle
	local radius
	local x
	local y
	local enemy
	-- LOCAL FUNCTIONS
	
	-- # BODY
	result=HandleEnemies:findSpot()
	if (result) then
		angle=math.random(0,359)
		-- local angle=50
		-- local radius=800
		radius=200
		angle=math.rad(angle)
		x=radius*( math.cos(angle) )
		y=radius*( math.sin(angle) )
		x=x+p1.x
		y=y+p1.y
		enemy=require('Lenemy')
		spawnedEnemies[result]=enemy.Spawn(x,y)
		view:add(spawnedEnemies[result],36,false)
	end
	
	-- # CLOSING
end

function HandleEnemies:frameChecks()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for i=1,table.maxn(spawnedEnemies) do
		if (spawnedEnemies[i]) then
	
			local pastx,pasty=spawnedEnemies[i]["CURX"]*2,spawnedEnemies[i]["CURY"]*2
			local mapsize=table.maxn(displayedRegions[1]["PLAIN"])
			local em=spawnedEnemies[i]["DMAP"]
			if displayedRegions[4]["MAPX"]<displayedRegions[1]["MAPX"] then
				if em==1 or em==3 then
					pastx=pastx+mapsize
				end
				-- pastx=pastx+table.maxn(displayedRegions[1]["PLAIN"])
			end
			if displayedRegions[4]["MAPY"]<displayedRegions[1]["MAPY"] then
				if em==1 or em==2 then
					pasty=pasty+mapsize
				end
				-- pasty=pasty+table.maxn(displayedRegions[1]["PLAIN"])
			end
			-- print (pastx,pasty)
			-- print (spawnedEnemies[i]["CURY"])
			if (displayb[pastx]) then
				if (displayb[pastx][pasty]) then
					displayb[pastx][pasty]:setFillColor(1,1,1,0.4)
				end
			end
			
			HandleEnemies:coordsCheck(i)
			HandleEnemies:enemyHits(i)
			HandleEnemies:getPath(i)
			if spawnedEnemies[i].isAlive==false then
				HandleEnemies:removeEnemy(i)
			end
			-- HandleEnemies:removeCheck(i)
			
			if (spawnedEnemies[i]) then
				-- local newx,newy=deltaX*2,deltaY*2
				local newx,newy=spawnedEnemies[i]["CURX"]*2,spawnedEnemies[i]["CURY"]*2
				local em=spawnedEnemies[i]["DMAP"]
				if displayedRegions[4]["MAPX"]<displayedRegions[1]["MAPX"] then
					if em==1 or em==3 then
						newx=newx+mapsize
					end
					-- newx=newx+table.maxn(displayedRegions[1]["PLAIN"])
				end
				if displayedRegions[4]["MAPY"]<displayedRegions[1]["MAPY"] then
					if em==1 or em==2 then
						newy=newy+mapsize
					end
					-- newy=newy+table.maxn(displayedRegions[1]["PLAIN"])
				end
				
				-- print (newx,newy)
				if (displayb[newx]) then
					if (displayb[newx][newy]) then
						displayb[newx][newy]:setFillColor(0.6,0.2,0.8,0.4)
					end
				end
			end
		end
	end
	
	-- # CLOSING
end

function HandleEnemies:removeEnemy(target)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	-- timer.cancel(spawnedEnemies[target].refreshtimer)
	Runtime:removeEventListener("enterFrame",spawnedEnemies[target].refresh)
	-- timer.cancel(spawnedEnemies[target].radartimer)
	
	-- display.remove(spawnedEnemies[target].shadow)
	-- spawnedEnemies[target].shadow=nil
	
	-- display.remove(spawnedEnemies[target].radar)
	-- spawnedEnemies[target].radar=nil
	
	display.remove(spawnedEnemies[target])
	spawnedEnemies[target]=nil
	
	-- # CLOSING
end

function HandleEnemies:enemyHits(i)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local obj1
	local thisEnemy
	local obj2
	local over10
	local under20
	local left
	local right
	local up
	local down
	local thisCycle
	local damageDealt
	-- LOCAL FUNCTIONS
	
	-- # BODY
	obj1=p1["HitBox"]
	thisEnemy=spawnedEnemies[i]
	obj2=thisEnemy["WEAPON"]
	if (obj1) and (obj2) and thisEnemy["SEQUENCE"]=="SWING" then
		over10=thisEnemy["CURFRAME"]>10
		under20=thisEnemy["CURFRAME"]<20
		if (over10) and (under20) then
			if (obj2.canDamage==true) then
				left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
				right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
				up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
				down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
				
				thisCycle=(left or right) and (up or down)
				if thisCycle==true then
					obj2.canDamage=false
					print "WHAM!"
					damageDealt=obj2.basedamage
					if damageDealt>0 then
						damageDealt=damageDealt*-1
					end
					p1:ModifyHealth(damageDealt)
				else
					print "SWISH!"
				end
			end
		elseif (over10) then
			if (obj2.canDamage==true) then
				thisEnemy["MODE"]="IDLE"
				print "enemy air swinging!!"
			else
				obj2.canDamage=true
			end
		end
	end
	
	-- # CLOSING
end

--[[
function HandleEnemies:doPostRowPosition( value )
	value:toLayer(34)
	value:toBack()
end

function HandleEnemies:doPreRowPosition( value )
	value:toLayer(36)
	value:toFront()
end
]]

function HandleEnemies:coordsCheck(i)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local xi
	local yi
	local map
	local xf
	local yf
	local deltaY
	local tileY
	local deltaX
	-- LOCAL FUNCTIONS
	
	-- # BODY
	xi=displayedRegions[1]["Xi"]
	yi=displayedRegions[1]["Yi"]
	map=1
	for i=1,4 do
		if (displayedRegions[i]) then
			if (displayedRegions[i]["Xi"]<=xi) and (displayedRegions[i]["Yi"]<=yi) then
				xi=displayedRegions[i]["Xi"]
				yi=displayedRegions[i]["Yi"]
				map=i
			end
		end
	end
	
	-- if (deltaY<0) or (deltaX<0) then
	-- if (spawnedEnemies[i].y<yi) or (spawnedEnemies[i].y<xi) then
		-- spawnedEnemies[i].isAlive=false
		-- print ("enemy out of bounds: north or west")
	-- end
	
	-- if spawnedEnemies[i].isAlive==true then
		xf=displayedRegions[1]["Xf"]
		yf=displayedRegions[1]["Yf"]
		for i=1,4 do
			if (displayedRegions[i]) then
				if (displayedRegions[i]["Xf"]>=xf) and (displayedRegions[i]["Yf"]>=yf) then
					xf=displayedRegions[i]["Xf"]
					yf=displayedRegions[i]["Yf"]
				end
			end
		end
		-- if (spawnedEnemies[i].y>yf) or (spawnedEnemies[i].y>xf) then
			-- spawnedEnemies[i].isAlive=false
			-- print ("enemy out of bounds: south or east")
		-- end
	-- end
	
	
	deltaY=spawnedEnemies[i].y-yi
	tileY=200
	tileY=(tileY/1.5)+(tileY/3)
	deltaY=math.floor(deltaY/tileY)+1
	
	deltaX=spawnedEnemies[i].x-xi
	deltaX=math.floor(deltaX/270)+1
	
	if (deltaX<0) or (deltaY<0) then
		spawnedEnemies[i].isAlive=false
		-- print ("enemy out of bounds: north or west")
	elseif (deltaX>14) or (deltaY>14) then
		spawnedEnemies[i].isAlive=false
		-- print ("enemy out of bounds: south or east")
	else
		if (deltaX>7) then
			map=map+1
		end
		if (deltaY>7) then
			map=map+2
		end
	end
	
	
	--[[
	local comp1=p1["CURY"]
	
	if (displayedRegions[4]) then
		if displayedRegions[4]["MAPY"]<displayedRegions[1]["MAPY"] then
			-- deltaY=deltaY+8
			comp1=comp1+8
		end
	end
	
	-- if (displayedRegions[4]) then
		-- if displayedRegions[4]["MAPX"]<displayedRegions[1]["MAPX"] then
			-- deltaX=deltaX+8
			-- comp1=comp1+8
		-- end
	-- end
	
	if deltaY>8 then
		deltaY=deltaY-8
		map=map+2
	elseif deltaY<1 then
		deltaY=deltaY+8
		map=map+2
	-- else
	end
	
	if deltaX>8 then
		deltaX=deltaX-8
		map=map+1
	elseif deltaX<1 then
		deltaX=deltaX+8
		map=map+1
	end
	--]]
	
	if spawnedEnemies[i].isAlive==true then
		-- if spawnedEnemies[i]["CURX"]~=deltaX then
			spawnedEnemies[i]["CURX"]=deltaX
			-- spawnedEnemies[i]["DMAP"]=map
			-- spawnedEnemies[i]["MAPX"]=displayedRegions[map]["MAPX"]
			-- spawnedEnemies[i]["MAPY"]=displayedRegions[map]["MAPY"]
		-- end
		-- if spawnedEnemies[i]["CURY"]~=deltaY then
			spawnedEnemies[i]["CURY"]=deltaY
			spawnedEnemies[i]["DMAP"]=map
			spawnedEnemies[i]["MAPX"]=displayedRegions[map]["MAPX"]
			spawnedEnemies[i]["MAPY"]=displayedRegions[map]["MAPY"]
			--[[
			if deltaY>comp1 then
				local layertomodify=view:layer(34)
				
				HandleEnemies:doPostRowPosition( spawnedEnemies[i] )
				
				local front=math.abs(deltaY-comp1)*2
				local i=layertomodify.numChildren
				local done=false
				local cyclecap=1
				while (i>=cyclecap and done==false) do
					layertomodify[i]:toBack()
					if (layertomodify[i].row) then
						front=front-1
					end
					
					i=i-1
					if front==0 then
						done=true
					end
				end
			else
				local layertomodify=view:layer(36)
				
				HandleEnemies:doPreRowPosition( spawnedEnemies[i] )
				
				local front=math.abs(deltaY-comp1)*2
				local done=false
				local cyclecap=layertomodify.numChildren
				local i=cyclecap-(front+2)
				while (i<=cyclecap and done==false) do
					layertomodify[i]:toFront()
					if (layertomodify[i].row) then
						front=front-1
					end
					
					i=i+1
					if front==0 then
						done=true
					end
				end
			end
			]]
		-- end
	end
	
	-- # CLOSING
end

function HandleEnemies:getPath(i)
	-- # OPENING
	-- DEPENDENCIES
	local Grid = require ("jumper.grid") -- The grid class
	local Pathfinder = require ("jumper.pathfinder") -- The pathfinder class
	-- FORWARD CALLS
	local thisEnemy
	local shortX
	local shortY
	local ex
	local ey
	local em
	local px
	local py
	local pm
	local mapsize
	local walkable
	local grid
	local pather
	local path
	-- LOCAL FUNCTIONS	
	local function flip(original)
		local result={}
		for i=1,table.maxn(original) do
			result[i]={}
			for j=1,table.maxn(original) do
				result[i][j]=original[j][i]
			end
		end
		return result
	end
	
	-- # BODY
	thisEnemy=spawnedEnemies[i]
	walkable = 0
	if thisEnemy["MODE"]=="PURSUIT" then
		shortX=thisEnemy["AIVALS"]["TARGET"]["TILE"]["X"]
		shortY=thisEnemy["AIVALS"]["TARGET"]["TILE"]["Y"]
		if shortX or shortY then
			-- print ("!!",shortX,shortY)
			thisEnemy["AIVALS"]["REPATH"]=thisEnemy["AIVALS"]["REPATH"]-1
			if thisEnemy["AIVALS"]["REPATH"]<0 then
				-- thisEnemy["AIVALS"]["TARGET"]["TILE"]["Y"]=nil
				-- thisEnemy["AIVALS"]["TARGET"]["TILE"]["X"]=nil
				-- thisEnemy["AIVALS"][""]=
				-- thisEnemy["MODE"]="IDLE"
				-- thisEnemy["AIVALS"]["UNIT"]["CATEGORY"]=nil
				thisEnemy:cleanTarget()
				thisEnemy["AIVALS"]["REPATH"]=1000
			end
		elseif not(shortX) and not(shortY) then
			-- print "FOUND IN PURSUIT"
			
			ex,ey=thisEnemy["CURX"]*2,thisEnemy["CURY"]*2
			em=thisEnemy["DMAP"]
			px,py=thisEnemy["AIVALS"]["UNIT"]["TILE"]["X"]*2,thisEnemy["AIVALS"]["UNIT"]["TILE"]["Y"]*2
			pm=HandleRegions:getMap(thisEnemy["AIVALS"]["UNIT"]["MAP"]["X"],thisEnemy["AIVALS"]["UNIT"]["MAP"]["Y"])
			
			-- print ("RAW: "..ex,ey,"to",px,py)
			
			mapsize=table.maxn(displayedRegions[1]["PLAIN"])
			if displayedRegions[4]["MAPX"]<displayedRegions[1]["MAPX"] then
				px=px+mapsize
				-- if em==1 or em==3 then
					-- print ("adding "..mapsize.." to enemy X coord because of offset. (currentx: "..ex..")")
					-- ex=ex+mapsize
				-- end
			end
			if displayedRegions[4]["MAPY"]<displayedRegions[1]["MAPY"] then
				py=py+mapsize
				-- if em==1 or em==2 then
					-- print ("adding "..mapsize.." to enemy Y coord because of offset. (currentx: "..ey..")")
					-- ey=ey+mapsize
				-- end
			end
			
			-- print (ex,ey,"to",px,py)
			
			
			-- Runtime:removeEventListener("enterFrame",HandleEnemies.frameChecks)
			
			flip(displayedRegions["BOUNDS"])
			-- Creates a grid object
			-- local grid = Grid(displayedRegions["BOUNDS"])
			grid = Grid(flip(displayedRegions["BOUNDS"]))
			-- Creates a pathfinder object using Jump Point Search
			pather = Pathfinder(grid, 'DIJKSTRA', walkable) -- I like DIJKSTRA, but others work too. Check the pathfinding module for more info on the types of pathfinding algorithm.
			pather:setMode('ORTHOGONAL')
			
			path = pather:getPath(ex,ey,px,py)

			if path then
				-- print "REMOVING LISTENER"
				-- Runtime:removeEventListener("enterFrame",HandleEnemies.frameChecks)
				
				-- asd=path:nodes()
				-- print (asd)
				if (pathsteps) then
					for i=1,table.maxn(pathsteps) do
						display.remove(pathsteps[i])
					end
				end
				
				pathsteps={}

				-- print ("enemy now trying to go to",firstX,firstY,"from",ex,ey)
				print ("ENEMY NEW PATH:")
				for node, count in path:nodes() do
					if (count==3) then
						firstX=node:getX()
						firstY=node:getY()
					end
					print ("STEP "..count..":", "("..node:getX()..",", node:getY()..")")
					
					pathsteps[count]=display.newRect(0,0,8,8)
					pathsteps[count].x=displayb[node:getX()][node:getY()].x
					pathsteps[count].y=displayb[node:getX()][node:getY()].y
					pathsteps[count]:setFillColor(1,0.64,0)
					-- if (displayb[pastx]) then
						-- if (displayb[pastx][pasty]) then
							-- displayb[pastx][pasty]:setFillColor(1,1,1,0.4)
						-- end
					-- end
				end
				thisEnemy["AIVALS"]["TARGET"]["TILE"]["X"]=firstX
				thisEnemy["AIVALS"]["TARGET"]["TILE"]["Y"]=firstY
				thisEnemy["AIVALS"]["UNIT"]["!TILE"]["X"]=px
				thisEnemy["AIVALS"]["UNIT"]["!TILE"]["Y"]=py
				thisEnemy["AIVALS"]["REPATH"]=1000
			else 
				print "no path found"
			end
		end
	end
	
	-- # CLOSING
end


---------------------------------------------------------------------------------------
-- MOVEMENT
---------------------------------------------------------------------------------------

Controls={}


function Controls:joystickMovementCheck(px,py)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local value
	-- LOCAL FUNCTIONS
	
	-- # BODY
	value=0
	if p1["SEQUENCE"]~="SWING" then
		if math.abs(px)>value or math.abs(py)>value then
			if px>value then
				p1:setSequence("WALK",1)
			else
				p1:setSequence("WALK",-1)
			end
			Controls:Move(px,py)
		else
			p1:setSequence("IDLE")
		end
	end
	
	-- # CLOSING
end

function Controls:Move(px,py)

	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local cruisecontrol
	-- LOCAL FUNCTIONS
	
	-- # BODY
	cruisecontrol=40
	p1.x=p1.x+(px*p1["STATS"]["Speed"]/cruisecontrol)
	p1.y=p1.y+(py*p1["STATS"]["Speed"]/cruisecontrol)
	
	-- HandleRegions:movementEvents()
	
	-- # CLOSING
end

function Controls:buttonPress()

	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	p1:setSequence("SWING")
	Runtime:addEventListener("enterFrame",checkPlayerAttackContact)
	
	-- Tests:
	-- g.CallAddCoins(100)
	-- p1["STATS"]["Experience"]=p1["STATS"]["Experience"]+10
	-- p1:ModifyHealth(-20,"Sux2BU")
	-- p1:ModifyMana(-10)
	-- p1:ModifyEnergy(-10)
	-- spawnedEnemies[1]["AIVALS"]["TARGET"]["TILE"]["X"]=nil
	-- spawnedEnemies[1]["AIVALS"]["TARGET"]["TILE"]["Y"]=nil
	-- print (spawnedEnemies[1]["CURX"],spawnedEnemies[1]["CURY"])
	
	-- # CLOSING
end


---------------------------------------------------------------------------------------
-- LOAD DATA
---------------------------------------------------------------------------------------

LoadData={}


function LoadData:setPlayerValues(data)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	p1["NAME"]=data["!N"]
	p1["GOLD"]=tonumber(data["!G"])
	
	p1["MAPX"]=tonumber(data["!MX"])
	p1["MAPY"]=tonumber(data["!MY"])
	p1["CURX"]=tonumber(data["!CX"])
	p1["CURY"]=tonumber(data["!CY"])
	
	for i=1,table.maxn(data["!S"]) do
		p1["STATS"][i]=data["!S"][i]
		p1["STATS"][i]["BOOST"]=tonumber(p1["STATS"][i]["!B"])
		p1["STATS"][i]["NATURAL"]=tonumber(p1["STATS"][i]["!N"])
	end
	
	p1["STATS"]["Energy"]=tonumber(data["!E"])
	p1["STATS"]["Free"]=tonumber(data["!F"])
	p1["STATS"]["Health"]=tonumber(data["!H"])
	p1["STATS"]["Mana"]=tonumber(data["!M"])
	p1["STATS"]["Level"]=tonumber(data["!L"])
	p1["STATS"]["Experience"]=tonumber(data["!X"])
	
	p1["SPELLS"]=data["!S"]
	p1["INVENTORY"]=data["!I"]
	
	for i=1,table.maxn(p1["INVENTORY"]) do
		p1["INVENTORY"][i]["AMOUNT"]=tonumber(p1["INVENTORY"][i]["!A"])
		p1["INVENTORY"][i]["ID"]=tonumber(p1["INVENTORY"][i]["!ID"])
		p1["INVENTORY"][i]["!A"]=nil
		p1["INVENTORY"][i]["!I"]=nil
	end
	
	p1["EQUIPMENT"]=data["!C"]
	p1["QUESTS"]=data["!Q"]
	
	-- # CLOSING
	p1:generateStats()
end


