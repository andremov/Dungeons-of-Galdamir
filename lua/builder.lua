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
-- CREATE
---------------------------------------------------------------------------------------

local Region
Create={}
Create.verbose = false
Create.obstaclePercentage = 0.45

function Create:start( parameters )
	-- # OPENING
	if (Create.verbose) then
		print "START REGION ROW CREATION"
	end
	-- DEPENDENCIES
	local slot=require("lua.slot")
	-- FORWARD CALLS
	
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
	-- Create["POSITION"] = { }
	-- Create["POSITION"]["REGION"] = parameters.region
	-- Create["POSITION"]["CREATE"] = parameters.position
	-- Create["ROW"] = parameters.row
	-- Create["HALLS"] = parameters.halls
	-- Create["TILESIZE"] = parameters.tileSize
	-- Create["WALLFIRST"] = parameters.wallFirst
	
	-- local region = slot.Load:getMap(mapx,mapy)
	
	-- # CLOSING
	if (slot.Load:regionExists(parameters.region.x,parameters.region.y)) then
		Create:sheet( parameters, slot.Load:getRegion(parameters.region.x,parameters.region.y) )
	else
		Create:buildTemplate( parameters )
	end
end

function Create:sheet( parameters, regionSave )
	-- # OPENING
	if (Create.verbose) then
		print "LOADING TILE SET"
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
	Create:visualize( parameters, regionSave )
end

function Create:visualize( parameters, regionSave )
	-- # OPENING
	if (Create.verbose) then
		print "CREATE VISUALIZATION OF REGION"
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
	
	-- regionRow ["SIDE"] = { }
	-- regionRow ["TOP"] = { }
	-- regionRow ["PHYSICS"] = { }
	-- regionRow ["TILE"] = { }
	regionRow ["GROUP"] = display.newGroup()
	
	-- regionRow ["GROUP"].y = parameters.position.y
	
	localRow = ((parameters.row*2) % (parameters.halls*2)) + 1
	
	for y = localRow, localRow + 1 do
		regionRowSave = regionSave [y]
		regionRow [y] = { }
		regionRow [y] ["SIDE"] = { }
		regionRow [y] ["TOP"] = { }
		regionRow [y] ["PHYSICS"] = { }
		regionRow [y] ["TILE"] = { }
		-- regionRow ["GROUP"] = display.newGroup()
		
		for x = 1, table.maxn(regionRowSave) do
			print (x)
			local wallTile = 0
			if ( parameters.wallFirst ) then
				wallTile = 1
			end
			
			if (y % 2 == wallTile  and x % 2 == wallTile) then -- CORNER
				if (regionRowSave[x] == 0) then
					regionRow[y]["SIDE"][x]=display.newImageRect("tiles/SidePillar.png",thirdTileSize,fullTileSize)
					regionRow[y]["TOP"][x]=display.newImageRect("tiles/TopPillar.png",thirdTileSize,thirdTileSize)
					regionRow[y]["PHYSICS"][x]=display.newRect(0,0,thirdTileSize,thirdTileSize)
					
					regionRow[y]["TOP"][x].yScale=0.4
				else
					regionRow[y]["TILE"][x]=display.newImageRect("tiles/FloorCorner.png",thirdTileSize,thirdTileSize)
				end
			elseif (y % 2 == wallTile) then -- HORIZONTAL WALL
				if (regionRowSave[x] == 0) then
					regionRow[y]["SIDE"][x]=display.newImageRect("tiles/SideWall.png",fullTileSize,fullTileSize)
					regionRow[y]["TOP"][x]=display.newImageRect("tiles/TopWall.png",fullTileSize,thirdTileSize)

					regionRow[y]["PHYSICS"][x]=display.newRect(0,0,fullTileSize,thirdTileSize)
					
					
					regionRow[y]["TOP"][x].yScale=0.4
				else
					regionRow[y]["TILE"][x]=display.newImageRect("tiles/FatFloor.png",fullTileSize,thirdTileSize)
				end
			elseif (x % 2 == wallTile) then -- VERTICAL WALL
				if (regionRowSave[x] == 0) then
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
				regionRow[y]["PHYSICS"][x].x=sevenTileSize*x
				regionRow[y]["PHYSICS"][x].y=(fullTileSize/2)*(y-localRow)
				regionRow[y]["PHYSICS"][x]:setFillColor(0.8,0.4,0.4)
				-- physics.addBody(regionRow[y]["PHYSICS"][x],"static",{friction=0.5,filter={categoryBits=1,maskBits=2}})
				
				regionRow ["GROUP"] :insert ( regionRow [y] ["PHYSICS"] [x] )
			end
			
			if (regionRow[y]["TOP"][x]) then
				regionRow[y]["TOP"][x].x=regionRow[y]["PHYSICS"][x].x
				regionRow[y]["TOP"][x].y=regionRow[y]["PHYSICS"][x].y-(fullTileSize*0.9)
				
				regionRow ["GROUP"] :insert ( regionRow [y] ["TOP"] [x] )
			end
			
			if (regionRow[y]["SIDE"][x]) then
				regionRow[y]["SIDE"][x].x=regionRow[y]["PHYSICS"][x].x
				regionRow[y]["SIDE"][x].y=regionRow[y]["PHYSICS"][x].y-14
				
				if (y % 2 == wallTile) then
					regionRow[y]["SIDE"][x].y=regionRow[y]["SIDE"][x].y-thirdTileSize+14
				end
				
				regionRow ["GROUP"] :insert ( regionRow [y] ["SIDE"] [x] )
			end
			
			if (regionRow[y]["TILE"][x]) then
				regionRow[y]["TILE"][x].x=sevenTileSize*x
				regionRow[y]["TILE"][x].y=(fullTileSize/2)*(y-localRow)
				
				regionRow ["GROUP"] :insert ( regionRow [y] ["TILE"] [x] )
			end
		end
	end
	
	-- # CLOSING
	Create:sendRegion( regionRow, parameters.row, parameters.region.x )
end

function Create:buildTemplate( parameters )
	-- # OPENING
	if (Create.verbose) then
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
	Create:buildWalls( parameters, buildingRegion )
end

function Create:buildWalls( parameters, buildingRegion )
	-- # OPENING
	if (Create.verbose) then
		print "RISING WALLS"
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
	
	cap = math.floor( table.maxn( walls ) * Create .obstaclePercentage )
	
	for i = 1, cap do
		local x = walls[i].x
		local y = walls[i].y
		buildingRegion [y] [x] .solid = true
		
		if ( not Create:checkOpen( parameters, buildingRegion ) ) then
			buildingRegion [y] [x] .solid = false
		end
	end
	
	-- # CLOSING
	Create:saveRegion( parameters, buildingRegion )
	Create:start( parameters )
end

function Create:saveRegion( parameters, buildingRegion )
	if (Create.verbose) then
		print "SAVING REGION"
	end
	
	local slot = require( "lua.slot" )
	
	slot.Save:keepRegionData( buildingRegion, parameters.region.x, parameters.region.y )
end

function Create:checkOpen( parameters, buildingRegion )
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local xCenter
	local yCenter
	local nonSolids = 0
	local openCount = 0
	local floodCheck = { }
	local floodDone
	-- LOCAL FUNCTIONS
	
	-- # BODY
	
	xCenter = parameters .halls
	yCenter = parameters .halls
	
	if (buildingRegion [yCenter] [xCenter] .class == "CORNER") then
		xCenter = xCenter + 1
		yCenter = yCenter + 1
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
			floodCheck [y] [x] = 1
			if ( not buildingRegion [y] [x] .solid ) then
				nonSolids = nonSolids + 1
				floodCheck [y] [x] = 0
			end
		end
	end
	
	floodCheck[yCenter][xCenter] = 2
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
end

function Create:sendRegion( region, row, regionIndex )
	if (Create.verbose) then
		print "SENDING REGION"
	end
	
	local game=require("lua.game")
	
	game.HandleRows:addRegion( region["GROUP"], row, regionIndex )
end



