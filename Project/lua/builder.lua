---------------------------------------------------------------------------------------
--
-- Builder.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)

	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
	-- # CLOSING
	
---------------------------------------------------------------------------------------
-- GLOBAL
---------------------------------------------------------------------------------------
local verbose = true

local function getColumn(id)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local side
	local column
	-- LOCAL FUNCTIONS
	
	-- # BODY
	side=14
	column=((id-1)%side)
	
	-- # CLOSING
	return column
end

local function getRow(id)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local side
	local row
	-- LOCAL FUNCTIONS
	
	-- # BODY
	side=14
	row=math.floor((id-1)/side)
	
	-- # CLOSING
	return row
end

local function readAsset(assname)
	-- # OPENING
	-- DEPENDENCIES
	local JSON = require("lua.json")
	-- FORWARD CALLS
	local filename
	local file
	local output
	local step
	local parsed
	-- LOCAL FUNCTIONS
	
	-- # BODY
	filename = system.pathForFile( assname )
	file = assert(io.open(filename, "r"))
	
	output = JSON:decode(file:read("*all"))
	output=output["frames"]
	
	step={}
	for i=1,table.maxn(output) do
		step[i] = {}
		step[i]["filename"]=output[i]["filename"]
		step[i]["width"]=output[i]["frame"]["w"]
		step[i]["height"]=output[i]["frame"]["h"]
		step[i]["x"]=output[i]["frame"]["x"]
		step[i]["y"]=output[i]["frame"]["y"]
	end
	parsed={}
	parsed["frames"]=step
	
	-- # CLOSING
	return parsed
end



---------------------------------------------------------------------------------------
-- GET REGION
---------------------------------------------------------------------------------------

function getRegion( parameters )
	-- # OPENING
	if (verbose) then
		print "STARTING REGION LOAD PROCESS"
	end
	-- DEPENDENCIES
	local slot=require("lua.slot")
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
		-- parameters.region = { x = fixedRegionX, y = fixedRegionY }
		-- parameters.halls = regionSettings.halls
		-- parameters.tileSize = regionSettings.tileSize

	-- # CLOSING
	if (slot.Load:regionExists(parameters.region.x,parameters.region.y)) then
		if (verbose) then
			print "REGION EXISTS"
		end
		
		Get:sheet( parameters, slot.Load:getRegion(parameters.region.x,parameters.region.y) )
	else
		if (verbose) then
			print "REGION DOES NOT EXIST"
		end
		
		local message = "REGION IN POSITION "
		
		local coordinates = "(" .. parameters .region .y .. ", ".. parameters .region .y .. ")"
		
		message = message .. coordinates .. " DOES NOT EXIST!?"
		
		
		
		assert(false, message)
		-- Build:template( parameters )
	end
end

function buildMap( parameters )
	-- # OPENING
	if (verbose) then
		print "STARTING MAP BUILD PROCESS"
	end
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
		-- parameters .seed = "27041997"
		-- parameters .regionHalls = regionSettings .halls
		-- parameters .maxRegions = regionSettings .maxRegions
		-- parameters .tileSize = regionSettings .tileSize
		-- parameters .radius = { min = 3, max = 10 }
		-- parameters .openPercent = 0.8

	-- # CLOSING
	Build:setSettings( parameters )
end

Get = {

	sheet = function ( self, parameters, regionSave )
		-- # OPENING
		if (verbose) then
			print "LOADING TILESET"
		end
		-- DEPENDENCIES
		-- FORWARD CALLS
		-- LOCAL FUNCTIONS
		
		-- # BODY
		-- local options=readAsset('tiles/Tiles.json')
		-- Create.TSheet=graphics.newImageSheet( "/Tiles/Tiles.png", options )
		-- Create.TilesRef={}
		-- for i=1,table.maxn(options["frames"]) do
			-- Create.TilesRef[options["frames"][i]["filename"]]=i
		-- end
		
		-- # CLOSING
		Get:visualize( parameters, regionSave )
	end,

	visualize = function ( self, parameters, regionSave )
		-- # OPENING
		if (verbose) then
			print "VISUALIZING REGION"
		end
		-- DEPENDENCIES
		local physics = require "physics"
		-- FORWARD CALLS
		-- local rowval
		local regionRow = { }
		local regionRowSave
		local localRow
		local sevenTileSize
		local thirdTileSize
		local fullTileSize
		-- LOCAL FUNCTIONS
		
		-- # BODY
		
		thirdTileSize = parameters.tileSize/3
		sevenTileSize = parameters.tileSize - thirdTileSize
		fullTileSize = parameters.tileSize
		buildTileSize = parameters.buildTileSize
		
		regionRow ["GROUP"] = display.newGroup()
		regionRow ["FLOOR"] = display.newGroup()
		-- regionRow ["SIDE"] = { }
		-- regionRow ["TOP"] = { }
		regionRow ["PHYSICS"] = { }
		regionRow ["TILE"] = { }
		-- regionRow ["BOUNDS"] = { }
		
		
		-- y = ((parameters.row*2) % (parameters.halls*2)) + 1
		
		for y = 1, parameters .halls do
			regionRowSave = regionSave [y]
			regionRow ["PHYSICS"][y] = { }
			regionRow ["TILE"][y] = { }
			
			for x = 1, parameters .halls do
			
				if (regionRowSave[x] == 1) then
					regionRow ["PHYSICS"][y][x]=display.newRect(0,0,fullTileSize,fullTileSize + 20)
					regionRow ["PHYSICS"][y][x]:setFillColor(0.85,0.55,0.55)
					regionRow ["PHYSICS"][y][x].isVisible = false
					regionRow ["PHYSICS"][y][x].anchorX = 0
					regionRow ["PHYSICS"][y][x].anchorY = 0
					
					
					regionRow ["TILE"][y][x]=display.newImageRect("asd.png",buildTileSize,buildTileSize)
					regionRow ["TILE"][y][x].anchorX = 0
					regionRow ["TILE"][y][x].anchorY = 0
					
					regionRow ["TILE"][y][x].x=parameters.position.x + ((x-1) * fullTileSize)
					regionRow ["TILE"][y][x].y=parameters.position.y
					
					
					regionRow ["PHYSICS"][y][x].x=regionRow ["TILE"][y][x].x
					regionRow ["PHYSICS"][y][x].y=regionRow ["TILE"][y][x].y + 20
					
					physics.addBody(regionRow ["PHYSICS"] [x], "static", {friction=0.5,filter={categoryBits=1,maskBits=2}})
					
					
					regionRow ["GROUP"] :insert ( regionRow ["PHYSICS"][y][x] )
					regionRow ["GROUP"] :insert ( regionRow ["TILE"][y][x] )
					
					
				end
				
				--[[
				if (y % 2 == wallTile  and x % 2 == wallTile) then -- CORNER
					if (regionRowSave[x] == 1) then
						regionRow[y]["SIDE"][x]=display.newImageRect("tiles/SidePillar.png",thirdTileSize,fullTileSize)
						regionRow[y]["TOP"][x]=display.newImageRect("tiles/TopPillar.png",thirdTileSize,thirdTileSize)
						regionRow[y]["PHYSICS"][x]=display.newRect(0,0,thirdTileSize,thirdTileSize)
						
						regionRow[y]["TOP"][x].yScale=0.4
					else
						regionRow[y]["TILE"][x]=display.newImageRect("tiles/FloorCorner.png",thirdTileSize,thirdTileSize)
					end
				elseif (y % 2 == wallTile) then -- HORIZONTAL WALL
					if (regionRowSave[x] == 1) then
						regionRow[y]["SIDE"][x]=display.newImageRect("tiles/SideWall.png",fullTileSize,fullTileSize)
						regionRow[y]["TOP"][x]=display.newImageRect("tiles/TopWall.png",fullTileSize,thirdTileSize)

						regionRow[y]["PHYSICS"][x]=display.newRect(0,0,fullTileSize,thirdTileSize)
						
						
						regionRow[y]["TOP"][x].yScale=0.4
					else
						regionRow[y]["TILE"][x]=display.newImageRect("tiles/FatFloor.png",fullTileSize,thirdTileSize)
					end
				elseif (x % 2 == wallTile) then -- VERTICAL WALL
					if (regionRowSave[x] == 1) then
						regionRow[y]["SIDE"][x]=display.newImageRect("tiles/SidePillar.png",thirdTileSize,fullTileSize)
						regionRow[y]["TOP"][x]=display.newImageRect("tiles/TopWall.png",fullTileSize,thirdTileSize)
						regionRow[y]["PHYSICS"][x]=display.newRect(0,0,thirdTileSize,sevenTileSize)
						
						regionRow[y]["TOP"][x]:rotate(90)
						regionRow[y]["TOP"][x].xScale=0.85
						regionRow[y]["SIDE"][x].yScale=0.8
					else
						regionRow[y]["TILE"][x]=display.newImageRect("tiles/SlimFloor.png",thirdTileSize,sevenTileSize)
					end
				else
					regionRow[y]["TILE"][x]=display.newImageRect("tiles/FloorTile.png",fullTileSize,sevenTileSize)
				end
				
				if (regionRow[y]["PHYSICS"][x]) then
					regionRow[y]["PHYSICS"][x].anchorX = 0
					regionRow[y]["PHYSICS"][x].anchorY = 0
					
					local xDiff = (math.floor(x/2)*fullTileSize) + (math.floor((x-1)/2)*thirdTileSize)
					regionRow[y]["PHYSICS"][x].x=parameters.position.x + xDiff
					regionRow[y]["PHYSICS"][x].y=parameters.position.y + ((sevenTileSize) * (y - localRow))
					
					regionRow[y]["PHYSICS"][x]:setFillColor(0.8,0.4,0.4)
					physics.addBody(regionRow[y]["PHYSICS"][x],"static",{friction=0.5,filter={categoryBits=1,maskBits=2}})
					
					regionRow ["GROUP"] :insert ( regionRow [y] ["PHYSICS"] [x] )
				end
				
				if (regionRow[y]["SIDE"][x]) then
					regionRow[y]["SIDE"][x].anchorX = 0
					regionRow[y]["SIDE"][x].anchorY = 0
					
					regionRow[y]["SIDE"][x].x=regionRow[y]["PHYSICS"][x].x
					regionRow[y]["SIDE"][x].y=regionRow[y]["PHYSICS"][x].y - sevenTileSize
					-- regionRow[y]["SIDE"][x]:setFillColor(1,1,1,0.5)
					
					if (y % 2 ~= wallTile) then
						regionRow[y]["SIDE"][x].y=regionRow[y]["SIDE"][x].y + (thirdTileSize * 1.6)
					end
					
					regionRow ["GROUP"] :insert ( regionRow [y] ["SIDE"] [x] )
				end
				
				if (regionRow[y]["TOP"][x]) then
					regionRow[y]["TOP"][x].anchorX = 0
					regionRow[y]["TOP"][x].anchorY = 0
					
					regionRow[y]["TOP"][x].x=regionRow[y]["SIDE"][x].x
					regionRow[y]["TOP"][x].y=regionRow[y]["SIDE"][x].y  - (thirdTileSize * 0.4)
					
					if (y % 2 ~= wallTile) then
						regionRow[y]["TOP"][x].y=regionRow[y]["TOP"][x].y - sevenTileSize - 10
						regionRow[y]["TOP"][x].x=regionRow[y]["TOP"][x].x + thirdTileSize
					end
					
					regionRow ["GROUP"] :insert ( regionRow [y] ["TOP"] [x] )
				end
				
				if (regionRow[y]["TILE"][x]) then
					regionRow[y]["TILE"][x].anchorX = 0
					regionRow[y]["TILE"][x].anchorY = 0
					
					local xDiff = (math.floor(x/2)*fullTileSize) + (math.floor((x-1)/2)*thirdTileSize)
					regionRow[y]["TILE"][x].x=parameters.position.x + xDiff
					
					regionRow[y]["TILE"][x].y=parameters.position.y + (sevenTileSize) * (y - localRow)
					
					regionRow ["FLOOR"] :insert ( regionRow [y] ["TILE"] [x] )
				end
				--]]
			end
		end
		
		
		-- # CLOSING
		Get:sendRegion( regionRow, parameters.region )
	end,

	sendRegion = function ( self, region, regionIndex )
		if (verbose) then
			print "SENDING REGION"
		end
		
		local game=require("lua.game")
		
		game.HandleRows:addRegion( region["GROUP"], regionIndex )
	end,

}

Build = {
	mapSettings = { },
	percent = 0,
	generatedMapInfo = { },

	setSettings = function( self, parameters )

		Build .mapSettings .seed = parameters .seed
		Build .mapSettings .regionHalls = parameters .regionHalls
		Build .mapSettings .maxRegions = parameters .maxRegions
		Build .mapSettings .maxRows = parameters .regionHalls * parameters .maxRegions
		Build .mapSettings .maxColumns = parameters .regionHalls * parameters .maxRegions
		Build .mapSettings .minOpenPercent = parameters .openPercent
		Build .mapSettings .maxRadius = parameters .radius .max
		Build .mapSettings .minRadius = parameters .radius .min
		
		Build:setTemplate()
	end,

	setTemplate = function()

		for y = 1, Build .mapSettings .maxColumns do
			Build .generatedMapInfo [y] = { }
			for x = 1, Build .mapSettings .maxRows do
				Build .generatedMapInfo [y][x] = { }
				Build .generatedMapInfo [y][x] .isSolid = false
				Build .generatedMapInfo [y][x] .isBreakable = false
				Build .generatedMapInfo [y][x] .isRoom = false
			end
		end

		Build:preGeneration()
	end,

	preGeneration = function()
		
		math.randomseed(Build .mapSettings .seed)
		
		math.random()
		math.random()
		
		Build:roomCreationHandler()
	end,

	roomCreationHandler = function()

		for i = 1, Build .mapSettings .maxRegions do
			Build:createRoom()
		end
		
		local check = Build:openPercentCheck()
		Build.percent = check / Build .mapSettings .minOpenPercent
		if (check < Build .mapSettings .minOpenPercent) then
			timer.performWithDelay(1, Build.roomCreationHandler)
		else
			Build:fillOpenings()
			Build:saveMap()
		end

	end,

	createRoom = function()

		local splash = { }
		splash .xRadius = math.random(Build .mapSettings .minRadius, Build .mapSettings .maxRadius)
		splash .yRadius = math.random(Build .mapSettings .minRadius, Build .mapSettings .maxRadius)
		
		splash .x = math.random(1, Build .mapSettings .maxColumns)
		splash .y = math.random(1, Build .mapSettings .maxRows)
		
		splash.start = { x = (splash .x - splash .xRadius), y = (splash .y - splash .yRadius)}
		splash.finish = { x = (splash .x + splash .xRadius), y = (splash .y + splash .yRadius)}
		
		for y = splash .start .y, splash .finish .y do
			for x = splash .start .x, splash .finish .x do
				
				local fixedX = (((x - 1) + Build .mapSettings .maxColumns) % Build .mapSettings .maxColumns) + 1
				local fixedY = (((y - 1) + Build .mapSettings .maxRows) % Build .mapSettings .maxRows) + 1
				
				local isWall 
				isWall = (x == splash .start .x) or (y == splash .start .y) or (x == splash .finish .x) or (y == splash .finish .y)
				
				if (isWall) then
					if (Build .generatedMapInfo [fixedY][fixedX] .isSolid) then
						Build .generatedMapInfo [fixedY][fixedX] .isBreakable = true
					elseif (not Build .generatedMapInfo [fixedY][fixedX] .isRoom) then
						Build .generatedMapInfo [fixedY][fixedX] .isSolid = true
					end
				else
					Build .generatedMapInfo [fixedY][fixedX] .isSolid = false
					Build .generatedMapInfo [fixedY][fixedX] .isRoom = true
				end
			end
		end
		
	end,

	openPercentCheck = function()
		local count = 0
		local total = 0
		
		for y = 1, Build .mapSettings .maxColumns do
			for x = 1, Build .mapSettings .maxRows do
				if (Build .generatedMapInfo [y][x] .isRoom) then
					count = count + 1
				end
				total = total + 1
			end
		end
		
		return count / total
	end,

	fillOpenings = function()

		for y = 1, Build .mapSettings .maxColumns do
			for x = 1, Build .mapSettings .maxRows do
				if (not Build .generatedMapInfo [y][x] .isSolid) then
				
					local directions = {
						-- ADYACENTS
						{ x, y + 1 },
						{ x, y - 1 },
						
						{ x + 1, y },
						{ x - 1, y },
						
						-- DIAGONALS
						{ x - 1, y - 1 },
						{ x + 1, y - 1 },
						
						{ x - 1, y + 1 },
						{ x + 1, y + 1 },
					}
					
					local count = 0
					for i = 1, 4 do
						local delta = { Build .mapSettings .maxColumns, Build .mapSettings .maxRows }
						for j = 1, 2 do
							directions [i][j] = (((directions [i][j] - 1) + delta [j]) % delta [j]) + 1
						end
						
						local adyacent = Build .generatedMapInfo [directions [i][2]][directions [i][1]]
						
						if (not adyacent .isSolid) then
							count = count + 1
						end
					end
					
					if (count == 0) then
						for i = 1, table.maxn(directions) do
							local delta = { Build .mapSettings .maxColumns, Build .mapSettings .maxRows }
							for j = 1, 2 do
								directions [i][j] = (((directions [i][j] - 1) + delta [j]) % delta [j]) + 1
							end
							
							local adyacent = Build .generatedMapInfo [directions [i][2]][directions [i][1]]
							
							if (adyacent .isSolid) then
								Build .generatedMapInfo [directions [i][2]][directions [i][1]] .isBreakable = true
							end
							
						end
						
					end
				end
			end
		end

	end,

	isDone = function()
		return (Build .percent >= 1.0)
	end,
	
	saveMap = function ()
		if (verbose) then
			print "SAVING REGION"
		end
		
		local slot = require( "lua.slot" )
		
		-- print (table.maxn(buildingRegion),table.maxn(buildingRegion[1]))
		
		slot.Save:keepMapData( Build .mapSettings, Build .generatedMapInfo )
	end,
	
--[[
	template = function ( self, parameters )
		-- # OPENING
		if (verbose) then
			print "BUILDING TEMPLATE"
		end
		-- DEPENDENCIES
		-- FORWARD CALLS
		-- LOCAL FUNCTIONS
		
		-- # BODY
		buildingRegion = { }
		
		for y = 1, parameters.halls * 2 do
			buildingRegion [y] = { }
			for x = 1, parameters.halls * 2 do
				buildingRegion [y] [x] = { }
				local wallTile = 0
				if ( parameters.wallFirst ) then
					wallTile = 1
				end
				if (y % 2 == wallTile and x % 2 == wallTile) then
					buildingRegion [y] [x] .class = "CORNER"
					buildingRegion [y] [x] .solid = true
				elseif (y % 2 == wallTile) then
					buildingRegion [y] [x] .class = "WALL"
					buildingRegion [y] [x] .solid = false
				elseif (x % 2 == wallTile) then
					buildingRegion [y] [x] .class = "WALL"
					buildingRegion [y] [x] .solid = false
				else
					buildingRegion [y] [x] .class = "TILE"
					buildingRegion [y] [x] .solid = false
				end
			end
		end
		
		-- # CLOSING
		Build:walls( parameters, buildingRegion )
	end,

	walls = function ( self, parameters, buildingRegion )
		-- # OPENING
		if (verbose) then
			print "BUILDING WALLS"
		end
		-- DEPENDENCIES
		-- FORWARD CALLS
		local walls = { }
		local cap
		-- LOCAL FUNCTIONS
		
		local function shuffle ( array )

			for i = 1, table.maxn (array) - 1 do

				local randomIndex = math.random ( i, table.maxn(array) )
				local tempItem = array [randomIndex]
				array [randomIndex] = array [i]
				array [i] = tempItem
				
			end

			return array
		end
		
		-- # BODY
		
		for y = 1, parameters .halls * 2 do
			for x = 1, parameters .halls * 2 do
				if ( buildingRegion [y] [x] .class == "WALL" ) then
					walls [table.maxn(walls) + 1] = { x = x, y = y }
				end
			end
		end
		
		walls = shuffle( walls )
		
		cap = math.floor( table.maxn( walls ) * Build .obstaclePercentage )
		
		for i = 1, cap do
			-- print ("Building wall " .. i .. " ...")
			local x = walls[i].x
			local y = walls[i].y
			buildingRegion [y] [x] .solid = true
			
			if ( not Build:checkOpen( parameters, buildingRegion ) ) then
				-- print ("It crumbled.")
				buildingRegion [y] [x] .solid = false
			end
		end
		
		-- # CLOSING
		Build:saveRegion( parameters, buildingRegion )
		start( parameters )
	end,

	checkOpen = function ( self, parameters, buildingRegion )
		-- # OPENING
		-- DEPENDENCIES
		-- FORWARD CALLS
		local xStart
		local yStart
		local nonSolids = 0
		local openCount = 0
		local floodCheck = { }
		local floodDone
		-- LOCAL FUNCTIONS
		
		-- # BODY
		
		xStart = 1
		yStart = 1
		
		if (buildingRegion [yStart] [xStart] .class == "CORNER") then
			xStart = xStart + 1
			yStart = yStart + 1
		end
		
		-- 
		-- FLOOD CHECK MEANING
		-- 
		-- 0 : SOLID
		-- 1 : NOT SOLID
		-- 2 : SPREAD MISSING
		-- 3 : SPREAD DONE
		-- 
		
		for y = 1, parameters .halls * 2 do
			floodCheck [y] = { }
			for x = 1, parameters .halls * 2 do
				floodCheck [y] [x] = 0
				if ( not buildingRegion [y] [x] .solid ) then
					nonSolids = nonSolids + 1
					floodCheck [y] [x] = 1
				end
			end
		end
		
		floodCheck[yStart][xStart] = 2
		floodDone = false
		while (not floodDone) do
			floodDone = true
			
			for y = 1, parameters .halls * 2 do
				for x = 1, parameters .halls * 2 do
					
					if (floodCheck [y] [x] == 2) then
						floodDone = false
						openCount = openCount + 1
						
						if (x > 1) then
							if (floodCheck [y] [x - 1] == 1) then
								floodCheck [y] [x - 1] = 2
							end
						end
						
						if (y > 1) then
							if (floodCheck [y - 1] [x] == 1) then
								floodCheck [y - 1] [x] = 2
							end
						end
						
						if (x < parameters.halls * 2) then
							if (floodCheck [y] [x + 1] == 1) then
								floodCheck [y] [x + 1] = 2
							end
						end
						
						if (y < parameters.halls * 2) then
							if (floodCheck [y + 1] [x] == 1) then
								floodCheck [y + 1] [x] = 2
							end
						end
						
						floodCheck [y] [x] = 3
					end
				end
			end
		
		end
		
		-- # CLOSING
		return (openCount == nonSolids)
	end,

	saveRegion = function ( self, parameters, buildingRegion )
		if (verbose) then
			print "SAVING REGION"
		end
		
		local slot = require( "lua.slot" )
		
		-- print (table.maxn(buildingRegion),table.maxn(buildingRegion[1]))
		
		slot.Save:keepRegionData( buildingRegion, parameters.region.x, parameters.region.y )
	end,
]]
}
