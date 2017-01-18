---------------------------------------------------------------------------------------
--
-- Game.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)

-- FORWARD CALLS
local mapsDone=false
local displayedRegions={}
local spawnedEnemies={}

local regionSettings = {
		halls = 5,
		tileSize = 200,
		wallFirst = true,
		requestDimensions = 5,
		fixDimensions = 5,
		maxRegions = 10,
	}
local fullTileMultiplier = 1.0
local wallTileMultiplier = 0.3
local centerMap = {  x = 0, y = 0 }
local displayedRows = { }

local debugPos

---------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
---------------------------------------------------------------------------------------

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

local function getPlayerCurrents()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local current = { }
	local regionSize = regionSettings.halls * regionSettings.tileSize
	local mapSize = regionSize * regionSettings.maxRegions * 2
	-- LOCAL FUNCTIONS
	
	-- # BODY

	local fixedPlayerCoords = {
		x = p1.x,
		y = p1.y
	}
	
	while (fixedPlayerCoords.x < 0) do
		fixedPlayerCoords.x = fixedPlayerCoords.x + mapSize
	end
	
	while (fixedPlayerCoords.y < 0) do
		fixedPlayerCoords.y = fixedPlayerCoords.y + mapSize
	end
	
	
	fixedPlayerCoords.x = fixedPlayerCoords.x % mapSize
	
	fixedPlayerCoords.y = fixedPlayerCoords.y % mapSize
	
	current.regionSize = regionSize
	
	current.mapSize = mapSize
	
	current.inMapPixels = { x = math.floor(fixedPlayerCoords.x), y = math.floor(fixedPlayerCoords.y) }
	
	current.realPixels = { x = math.floor(p1.x), y = math.floor(p1.y) }
	
	current.globalTile = {
		x = math.ceil(current.inMapPixels.x / regionSettings.tileSize),
		y = math.ceil(current.inMapPixels.y / regionSettings.tileSize)
	}
	
	current.region = {
		x = math.ceil(current.globalTile.x / regionSettings.halls),
		y = math.ceil(current.globalTile.y / regionSettings.halls)
	}
	
	current.regionPixels = {
		x = current.inMapPixels.x - ((current.region.x - 1) * regionSize),
		y = current.inMapPixels.y - ((current.region.y - 1) * regionSize)
	}
	
	current.regionalTile = {
		x = current.globalTile.x - ((current.region.x - 1) * regionSettings.halls),
		y = current.globalTile.y - ((current.region.y - 1) * regionSettings.halls)
	}

	-- # CLOSING
	return current
end

local function playerCheckRefresh()
	local current = getPlayerCurrents()
	
	if (not debugPos) then
		debugPos = display.newGroup()
		debugPos.y = 10
		debugPos.x = -60
		-- debugPos.anchorY = 
		
		local square = display.newRect(0,0,360,210)
		square.anchorX = 0
		square.anchorY = 0
		debugPos:insert(square)
		
		debugPos .texts = { }
		
		local i = 1
		for k,v in pairs(current) do
		
			local fullString
			
			if (type(v) == "table") then
				fullString = k .. ":  " .. v.x .. ", " .. v.y
			else
				fullString = k .. ":  " .. v
			end
			
			debugPos .texts [i] = display.newText(fullString, 0, 0, native.systemFont, 25)
			debugPos .texts [i] .anchorX = 0
			debugPos .texts [i] .anchorY = 0
			debugPos .texts [i] .y = (i - 1) * 25
			debugPos .texts [i] .x = 5
			debugPos .texts [i]:setTextColor(0,0,0)
			debugPos:insert(debugPos .texts [i])
			i = i + 1
		end
		
		-- debugPos.x = 100
		-- debugPos.y = 60
	else
		local i = 1
		for k,v in pairs(current) do
		
			local fullString
			
			if (type(v) == "table") then
				fullString = k .. ":  " .. v.x .. ", " .. v.y
			else
				fullString = k .. ":  " .. v
			end
			
			debugPos .texts [i] .text = fullString
			i = i + 1
		end
	end
end


---------------------------------------------------------------------------------------
-- STARTUP
---------------------------------------------------------------------------------------

Initial = { }


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
	local slot=require("lua.slot")
	-- FORWARD CALLS
	local data
	-- LOCAL FUNCTIONS
	
	-- # BODY
	print "LOAD SCREEN SKIPPED"
	-- Initial:loadScreen()
	print "SET SAVE SLOT SKIPPED"
	-- save.setSlot(slot)
	-- print "VIEW CREATION SKIPPED"
	view=per.createView()
	print "LOAD SAVE SLOT SKIPPED"
	-- data=save.Load:retrieveData()
	-- print "CREATE PLAYER SKIPPED"
	p1=entity.CreatePlayer( value or "Player" )
	print (p1.x,p1.y)
	print "SET PLAYER VALUES SKIPPED"
	-- if (data) then
		-- LoadData:setPlayerValues(data)
	-- end
	
	-- # CLOSING
	-- print "CONTINUE ACTIONS SKIPPED"
	-- Initial:wait()
	Initial:Continue()	
	-- print "REGION DISPLAY SKIPPED"
	HandleRows:requestRows()
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
	-- for i=LoadingScreen.numChildren,1,-1 do
		-- if (LoadingScreen[i]) then
			-- display.remove(LoadingScreen[i])
			-- LoadingScreen[i]=nil
		-- end
	-- end
	-- LoadingScreen=nil
	
	ui.Essentials()
	ui.Controls:show()
	view:add(p1,2,true)
	view:setBounds(false)
	view:track()
	-- HandleEnemies:start()
	-- Initial:firstSave()
	Runtime:addEventListener("enterFrame",HandleRows.movementEvents)
	-- Runtime:addEventListener("enterFrame",HandleEnemies.frameChecks)
	-- Runtime:addEventListener("enterFrame",checkPlayerCoordinates)
	
	displayedRows = { }
	
	for region = 1, regionSettings.maxRegions * 2 do
		displayedRows [region] = { }
		for row = 1, regionSettings.halls * regionSettings.maxRegions do
			displayedRows [region] [row] = { }
		end
	end
	
	-- # CLOSING
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


HandleRows = { }

function HandleRows:requestRows()
	-- # OPENING
	-- DEPENDENCIES
	local builder=require("lua.builder")
	-- local save=require("lua.save")
	-- FORWARD CALLS
	local mapSize = regionSettings.halls * regionSettings.tileSize
	local scale = 0.2
	local current = getPlayerCurrents()
	local centerX = current.globalTile.x
	local centerY = current.globalTile.y
	-- LOCAL FUNCTIONS
	
	-- # BODY
	mapsDone=false
	
	local pendingRows = { }
	
	for rowX = centerX - regionSettings.requestDimensions, centerX + regionSettings.requestDimensions do
		for rowY = centerY - regionSettings.requestDimensions, centerY + regionSettings.requestDimensions do
		
			local fixedRowX = rowX
			fixedRowX = (fixedRowX % (regionSettings.maxRegions * regionSettings.halls))
			while (fixedRowX < 1) do
				fixedRowX = fixedRowX + (regionSettings.maxRegions * regionSettings.halls)
			end
			local fixedMapX = math.ceil(fixedRowX / regionSettings.halls)
			
			
			local fixedRowY = rowY
			fixedRowY = (fixedRowY % (regionSettings.maxRegions * regionSettings.halls))
			while (fixedRowY < 1) do
				fixedRowY = fixedRowY + (regionSettings.maxRegions * regionSettings.halls)
			end
			local fixedMapY = math.ceil(fixedRowY / regionSettings.halls)
			
			
			
			parameters = { }
			parameters.region = { x = fixedMapX, y = fixedMapY }
			parameters.row = fixedRowY - ((fixedMapY - 1) * regionSettings.halls)
			parameters.globalRow = fixedRowY
			parameters.halls = regionSettings.halls
			parameters.tileSize = regionSettings.tileSize
			parameters.wallFirst = regionSettings.wallFirst
			parameters.create = true
			pendingRows[table.maxn(pendingRows) + 1] = parameters
			-- builder.Create:Start( parameters )
		end
	end
	
	for region in ipairs(displayedRows) do
		for row in ipairs(displayedRows[region]) do
			displayedRows[region][row].passed = false
		end
	end
	
	local create = true
	for i = 1, table.maxn (pendingRows) do
		local row = pendingRows[i].globalRow
		local region = pendingRows[i].region.x
		
		-- print ("CHECK ",region,row)
		
		if (displayedRows [region] [row] .created) then
			displayedRows [region] [row] .passed = true
		elseif ( create ) then
			create = false
			-- builder.Create:start (pendingRows [i])
			
			print ("REQUESTING", region, row, displayedRows [region] [row] .created, displayedRows [region] [row] .passed)
			
			amaga(pendingRows[i])
		end
	end
	
	mapsDone = create
	
	for region in ipairs(displayedRows) do
		for row in ipairs(displayedRows[region]) do
			if (displayedRows[region][row].passed == false and displayedRows[region][row].created) then
				HandleRows:cleanRow(region, row)
			end
		end
	end
	
	-- if (not mapsDone) then
	
		-- HandleRows:requestRows()
	
	-- end
	
	-- # CLOSING
end

function HandleRows:fixRegionPosition()
	-- # OPENING
	-- print "FIXING POSITIONS"
	-- DEPENDENCIES
	-- FORWARD CALLS
	local current = getPlayerCurrents()
	local centerX
	local centerY
	local centerRegionX
	local centerRegionY
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
	centerX = current.region.x
	centerY = current.region.y
	
	-- print ("CENTER ",centerX, centerY)
	
	centerRegionX = current.realPixels.x - current.regionPixels.x
	centerRegionY = current.realPixels.y - current.regionPixels.y
	
	-- print (centerRegionX, centerRegionY)
	
	for regionX = centerX - regionSettings.fixDimensions, centerX + regionSettings.fixDimensions do
	
		local fixedRegionX = regionX % regionSettings.maxRegions
		while (fixedRegionX < 1) do
			fixedRegionX = fixedRegionX + regionSettings.maxRegions
		end
		
		-- print ("REGIONX",fixedRegionX)
		
		for regionY = centerY - regionSettings.fixDimensions, centerY + regionSettings.fixDimensions do
			local fixedRegionY = regionY % regionSettings.maxRegions
			while (fixedRegionY < 1) do
				fixedRegionY = fixedRegionY + regionSettings.maxRegions
			end
		
			-- print ("REGIONY",fixedRegionY)
		
			local distanceX = centerX - regionX
			distanceX = distanceX * regionSettings.halls * regionSettings.tileSize
			distanceX = centerRegionX - distanceX
			
			local distanceY = centerY - regionY
			distanceY = distanceY * regionSettings.halls * regionSettings.tileSize
			distanceY = centerRegionY - distanceY
			
			
			for row = 1, regionSettings.halls do
				local thisDistanceY = distanceY + ((row - 1) * regionSettings.tileSize)
				
				
				local globalRow = ((fixedRegionY - 1) * regionSettings.halls) + row
				
				
				-- print ("ROW",row,"or",globalRow)
				
				displayedRows[fixedRegionX][globalRow].x = distanceX
				displayedRows[fixedRegionX][globalRow].y = thisDistanceY
				
				-- print (distanceX, thisDistanceY)
			end
		end
	end
	
end

function HandleRows:addRegion( regionParam, regionIndex, globalRow )
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
	
	-- regionParam.xScale = regionParam.xScale * 0.2
	-- regionParam.yScale = regionParam.yScale * 0.2
	
	HandleRows:fixRegionPosition()
	
	-- print ("RECEIVING",regionIndex,globalRow)
	
	regionParam .x = displayedRows [regionIndex] [globalRow] .x
	regionParam .y = displayedRows [regionIndex] [globalRow] .y
	
	-- print ("IN POSITION",regionParam .x, regionParam .y)
	
	regionParam.created = true
	
	displayedRows [regionIndex] [globalRow] = regionParam
	
	if (regionParam.y < p1.y) then
		view:add(displayedRows [regionIndex] [globalRow], 3, false)
	else
		view:add(displayedRows [regionIndex] [globalRow], 1, false)
	end
	
	-- # CLOSING
end

function HandleRows:cleanRow( victimRegion, victimRow )
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if (displayedRows[victimRegion][victimRow]["PHYSICS"]) then
		for a in ipairs(displayedRows[victimRegion][victimRow]["PHYSICS"]) do
			display.remove(displayedRows[victimRegion][victimRow]["PHYSICS"][a])
			displayedRows[victimRegion][victimRow]["PHYSICS"][a]=nil
		end
	-- else
		-- print ("PHYSICS "..victimRow.." + "..victimRegion.." doesnt exist?")
	end
	
	if (displayedRows[victimRegion][victimRow]["TOP"]) then
		for a in ipairs(displayedRows[victimRegion][victimRow]["TOP"]) do
			display.remove(displayedRows[victimRegion][victimRow]["TOP"][a])
			displayedRows[victimRegion][victimRow]["TOP"][a]=nil
		end
	-- else
		-- print ("TOP "..victimRow.." + "..victimRegion.." doesnt exist?")
	end
	
	if (displayedRows[victimRegion][victimRow]["SIDE"]) then
		for a in ipairs(displayedRows[victimRegion][victimRow]["SIDE"]) do
			display.remove(displayedRows[victimRegion][victimRow]["SIDE"][a])
			displayedRows[victimRegion][victimRow]["SIDE"][a]=nil
		end
	-- else
		-- print ("SIDE "..victimRow.." + "..victimRegion.." doesnt exist?")
	end
	
	if (displayedRows[victimRegion][victimRow]["TILE"]) then
		for a in ipairs(displayedRows[victimRegion][victimRow]["TILE"]) do
			display.remove(displayedRows[victimRegion][victimRow]["TILE"][a])
			displayedRows[victimRegion][victimRow]["TILE"][a]=nil
		end
	-- else
		-- print ("TILE "..victimRow.." + "..victimRegion.." doesnt exist?")
	end
	
	if (displayedRows[victimRegion][victimRow]["Gradients"]) then
		for a in ipairs(displayedRows[victimRegion][victimRow]["Gradients"]) do
			for b in ipairs(displayedRows[victimRegion][victimRow]["Gradients"][a]) do
				display.remove(displayedRows[victimRegion][victimRow]["Gradients"][a][b])
				displayedRows[victimRegion][victimRow]["Gradients"][a][b]=nil
			end
		end
	-- else
		-- print ("GRADS "..victimRow.." + "..victimRegion.." doesnt exist?")
	end
	
	
	for i = displayedRows[victimRegion][victimRow].numChildren, 1, -1 do
		local child = displayedRows[victimRegion][victimRow][i]
		displayedRows[victimRegion][victimRow].parent:remove( child )
		display.remove( child )
	end
	
	-- print ("CLEANING",victimRegion,victimRow)
	
	displayedRows[victimRegion][victimRow]={}
	
	-- # CLOSING
end

function HandleRows:movementEvents()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- local pastx
	-- local pasty
	-- local newx
	-- local newy
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
	HandleRows:requestRows()
	
	playerCheckRefresh()
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
	
	-- HandleRows:mapSwitch()
	
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

function amaga( params )
	
	local group = display.newGroup()
	
	local square = display.newRect(0, 0, regionSettings.tileSize * regionSettings.halls, regionSettings.tileSize)
	square:setFillColor( math.random(1,9)/10, math.random(1,9)/10, math.random(1,9)/10, 0.3)
	square.anchorX = 0
	square.anchorY = 0
	-- square.xScale = 0.95
	-- square.yScale = 0.95
	group:insert(square)
	
	local string1 = "Region:  " .. params.region.x .. ", " .. params.region.y
	
	local string2 = "Row:  " .. params.row .. "/" .. params.halls .. " or " .. params.globalRow
	
	local text1 = display.newText(string1,0,0,native.systemFont,30)
	text1.y = 0.3 * regionSettings.tileSize
	text1.x = 0.5 * regionSettings.tileSize * regionSettings.halls
	group:insert(text1)
	
	local text2 = display.newText(string2,0,0,native.systemFont,30)
	text2.y = 0.6 * regionSettings.tileSize
	text2.x = 0.5 * regionSettings.tileSize * regionSettings.halls
	group:insert(text2)
	
	HandleRows:addRegion( group, params.region.x, params.globalRow	 )

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
	
	HandleRows:movementEvents()
	
	-- # CLOSING
end

function Controls:buttonPress()

	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
		HandleRows:requestRows()
	-- # BODY
	-- p1:setSequence("SWING")
	-- Runtime:addEventListener("enterFrame",checkPlayerAttackContact)
	
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


