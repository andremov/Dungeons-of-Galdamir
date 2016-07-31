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

function Create:Start(paramx,paramy,info,posx,posy,regcap)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local side
	local tile
	local delta
	local regSizeX
	local regSizeY
	-- LOCAL FUNCTIONS
	
	-- # BODY
	side=14
	tile=200
	
	delta=side/2
	regSizeX=(delta*tile)+(delta*(tile/3))
	regSizeY=(delta*(tile/1.5))+(delta*(tile/3))
	
	Create["POSITION"]={}
	Create["POSITION"]["REGION"]={x=paramx,y=paramy}
	Create["POSITION"]["TILE"]={x=(regcap+paramx)*(side/2),y=(regcap+paramy)*(side/2)}
	Create["POSITION"]["BEGIN"]={x=posx,y=posy}
	Create["POSITION"]["MID"]={x=posx+(regSizeX/2),y=posy+(regSizeY/2)}
	Create["POSITION"]["END"]={x=posx+regSizeX,y=posy+regSizeY}
	Create["loadinfo"]=info
	
	-- # CLOSING
	Create:Progress()
end

function Create:sheet()
	-- # OPENING
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
	Create:Progress()
end

function Create:Template()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local side
	local tile
	-- LOCAL FUNCTIONS
	
	-- # BODY
	side=14
	tile=200
	Region={}
	Region.side=side
	Region.tile=tile
	
	Region["POSITION"]=Create["POSITION"]
	
	Region.regRows={}
	Region.Gradients=display.newGroup()
	Region.Gradients.isVisible=false
	Region.Level=display.newGroup()
	Region.Level.isVisible=false
	
	Region["REGION"]={}
	for i=1,Region.side^2 do
		Region["REGION"][i]={}
		Region["REGION"][i].col=getColumn(i)
		Region["REGION"][i].row=getRow(i)
	end
	Region["PLAIN"]={}
	for i=1,Region.side do
		Region["PLAIN"][i]={}
	end
	
	-- # CLOSING
	Create:Progress()
end

function Create:Walls()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local plainrow
	local plaincol
	local surroundings
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for i=1,Region.side^2 do
		plaincol=Region["REGION"][i].col+1
		plainrow=Region["REGION"][i].row+1
		if Region["REGION"][i].row%2==0 and Region["REGION"][i].col%2==0 then
			Region["REGION"][i].class="CORNER"
			Region["REGION"][i].wall=true
			if ( Create["loadinfo"] ) then
				Region["REGION"][i].open=( Create["loadinfo"][plainrow][plaincol]==0 )
				Region["PLAIN"][plainrow][plaincol]=Create["loadinfo"][plainrow][plaincol]
			end
		elseif Region["REGION"][i].col%2==0 then
			Region["REGION"][i].class="WALLX"
			Region["REGION"][i].wall=true
			if ( Create["loadinfo"] ) then
				Region["REGION"][i].open=( Create["loadinfo"][plainrow][plaincol]==0 )
				Region["PLAIN"][plainrow][plaincol]=Create["loadinfo"][plainrow][plaincol]
			else
				Region["REGION"][i].open=math.random(0,1)
				Region["PLAIN"][plainrow][plaincol]=Region["REGION"][i].open
				Region["REGION"][i].open=(Region["REGION"][i].open==0)
			end
		elseif Region["REGION"][i].row%2==0 then
			Region["REGION"][i].class="WALLY"
			Region["REGION"][i].wall=true
			if ( Create["loadinfo"] ) then
				Region["REGION"][i].open=( Create["loadinfo"][plainrow][plaincol]==0 )
				Region["PLAIN"][plainrow][plaincol]=Create["loadinfo"][plainrow][plaincol]
			else
				Region["REGION"][i].open=math.random(0,1)
				Region["PLAIN"][plainrow][plaincol]=Region["REGION"][i].open
				Region["REGION"][i].open=(Region["REGION"][i].open==0)
			end
		else
			Region["REGION"][i].class="TILE"
			Region["REGION"][i].wall=false
			if ( Create["loadinfo"] ) then
				Region["REGION"][i].open=( Create["loadinfo"][plainrow][plaincol]==0 )
				Region["PLAIN"][plainrow][plaincol]=Create["loadinfo"][plainrow][plaincol]
			else
				Region["REGION"][i].open=true
				Region["PLAIN"][plainrow][plaincol]=0
			end
		end
		Region["REGION"][i].roomed=false
	end
	if not( Create["loadinfo"] ) then
		for i=1,Region.side^2 do
			plaincol=Region["REGION"][i].col+1
			plainrow=Region["REGION"][i].row+1
			if Region["REGION"][i].class=="CORNER" then
				surroundings={ i-Region.side, i-1, i+1, i+Region.side }
				for j=1,4 do
					surroundings[j]=Region["REGION"][surroundings[j]]
					if plaincol==1 and j==2 then
						surroundings[j]=nil
					end
					if plainrow==1 and j==1 then
						surroundings[j]=nil
					end
					if surroundings[j] then
						surroundings[j]=not surroundings[j].open
					else
						surroundings[j]=true
					end
				end
				surroundings=surroundings[1] or surroundings[2] or surroundings[3] or surroundings[4]
				if surroundings then
					Region["PLAIN"][plainrow][plaincol]=1
					Region["REGION"][i].open=false
				else
					Region["REGION"][i].open=math.random(0,10)
					if Region["REGION"][i].open>5 then
						Region["REGION"][i].open=0
					else
						Region["REGION"][i].open=1
					end
					Region["PLAIN"][plainrow][plaincol]=Region["REGION"][i].open
					Region["REGION"][i].open=(Region["REGION"][i].open==0)
				end
			end
		end
	end
	
	-- # CLOSING
	Create:Progress()
end

function Create:Pathfinding()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local tiles2
	local numTiles
	local done
	local obj
	local cont
	local walls
	local curdir
	local plainrow
	local plaincol
	local curtile
	local curwall
	local pick
	-- LOCAL FUNCTIONS
	
	-- # BODY
	tiles2={}
	numTiles=0
	done=false
	for i=1,table.maxn(Region["REGION"]) do
		tiles2[i]={}
		tiles2[i].open=false
		tiles2[i].done=false
		tiles2[i].walls={}
	end
	tiles2[Region.side+2].open=true
	while done==false and numTiles<(Region.side^2)/4 do
		obj=nil
		cont=1
		while not(obj) and cont<=table.maxn(Region["REGION"]) do
			if tiles2[cont].open==true and tiles2[cont].done==false then
				obj=cont
			end
			cont=cont+1
		end
		if not (obj) then
			cont=1
			while not(obj) and cont<=table.maxn(Region["REGION"]) do
				if tiles2[cont].open==false and Region["REGION"][cont].class=="TILE" then
					obj=cont
					-- print ("BREAKING: "..obj)
					walls={obj-Region.side,obj-1,obj+1,obj+Region.side}
					for v=1,table.maxn(walls) do
						curdir=walls[v]
						if (Region["REGION"][curdir]) then
							Region["REGION"][curdir].roomed=true
							Region["REGION"][curdir].open=true
							plainrow=Region["REGION"][curdir].row+1
							plaincol=Region["REGION"][curdir].col+1
							Region["PLAIN"][plainrow][plaincol]=0
						end
					end
				end
				cont=cont+1
			end
		end
		if not (obj) and numTiles==(Region.side^2)/4 then
			done=true
		end
		if (obj) then
			-- print ("OBJ>"..obj)
			walls={"U","L","R","D"}
			for i=1,table.maxn(walls) do
				curdir=walls[i]
				if curdir=="U" then
					curtile=obj-(Region.side*2)
					curwall=obj-Region.side
				elseif curdir=="L" then
					curtile=obj-2
					curwall=obj-1
				elseif curdir=="R" then
					curtile=obj+2
					curwall=obj+1
				elseif curdir=="D" then
					curtile=obj+(Region.side*2)
					curwall=obj+Region.side
				end
				if (getRow(curwall)==0 and curdir=="U") or 
				   (getColumn(curwall)==0 and curdir=="L") then
					curtile=nil
				end
				if (getRow(obj)==Region.side-1 and curdir=="D") or 
				   (getColumn(obj)==Region.side-1 and curdir=="R") then
					curwall=nil
				end

				if (curwall) and (Region["REGION"][curwall].open==true) then
					Region["REGION"][curwall].roomed=true
					if (curtile) then
						tiles2[curtile].open=true
					end
				else
					if (curwall) and (curtile) and (tiles2[curtile].open==false) then
						tiles2[curtile].walls[#tiles2[curtile].walls+1]=curwall
						if table.maxn(tiles2[curtile].walls)>=2 then
							for w=1,table.maxn(tiles2[curtile].walls) do
								pick=tiles2[curtile].walls[w]
								Region["REGION"][pick].roomed=true
								Region["REGION"][pick].open=true
								plainrow=Region["REGION"][pick].row+1
								plaincol=Region["REGION"][pick].col+1
								Region["PLAIN"][plainrow][plaincol]=0
							end
							tiles2[curtile].open=true
						end
					end
				end
			end
			tiles2[obj].done=true
			Region["REGION"][obj].roomed=true
			numTiles=numTiles+1
		end
	end
	
	-- # CLOSING
	Create:Progress()
end

function Create:Visualize()
	-- # OPENING
	-- DEPENDENCIES
	local physics = require "physics"
	-- FORWARD CALLS
	local rowval
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if (Region["PHYSICS"]) then
		for i=1,table.maxn(Region["REGION"]) do
			display.remove(Region["PHYSICS"][i])
			Region["PHYSICS"][i]=nil
			display.remove(Region["TOP"][i])
			Region["TOP"][i]=nil
			display.remove(Region["SIDE"][i])
			Region["SIDE"][i]=nil
			display.remove(Region["TILE"][i])
			Region["TILE"][i]=nil
		end
		for i=1,Region["Gradients"].numChildren do
			display.remove(Region["Gradients"][i])
			Region["Gradients"][i]=nil
		end
	end
	Region["PHYSICS"]=nil
	Region["PHYSICS"]={}
	Region["TOP"]=nil
	Region["TOP"]={}
	Region["SIDE"]=nil
	Region["SIDE"]={}
	Region["TILE"]=nil
	Region["TILE"]={}
	Region["Gradients"]=nil
	Region["Gradients"]={}
	for i=1,table.maxn(Region["REGION"]) do
		grads={}
		if Region["REGION"][i].class=="WALLY" then
			if Region["REGION"][i].open==false then
				Region["SIDE"][i]=display.newImageRect("tiles/SideWall.png",Region.tile,Region.tile)
				Region["TOP"][i]=display.newImage("tiles/TopWall.png",Region.tile,Region.tile/3)
				Region["PHYSICS"][i]=display.newRect(0,0,Region.tile,Region.tile/3)
				
				
				Region["TOP"][i].yScale=0.4
			else
				Region["TILE"][i]=display.newImageRect("tiles/FloorWall2.png",Region.tile,Region.tile/3)
			end
		elseif Region["REGION"][i].class=="WALLX" then
			if Region["REGION"][i].open==false then
				Region["TOP"][i]=display.newImage("tiles/TopWall.png",Region.tile/1.5,Region.tile/3)
				Region["SIDE"][i]=display.newImageRect("tiles/SidePillar.png",Region.tile/3,Region.tile)
				Region["PHYSICS"][i]=display.newRect(0,0,Region.tile/3,Region.tile/1.5)
				
				Region["TOP"][i]:rotate(90)
				Region["TOP"][i].xScale=0.85
				Region["TOP"][i].yScale=0.95
				Region["SIDE"][i].yScale=0.8
			else
				Region["TILE"][i]=display.newImageRect("tiles/FloorWall1.png",Region.tile/1.5,Region.tile/3)
				Region["TILE"][i]:rotate(90)
			end
		elseif Region["REGION"][i].class=="CORNER" then
			if Region["REGION"][i].open==false then
				Region["SIDE"][i]=display.newImageRect("tiles/SidePillar.png",Region.tile/3,Region.tile)
				Region["TOP"][i]=display.newImage("tiles/TopPillar.png",Region.tile/3,Region.tile/3)
				Region["PHYSICS"][i]=display.newRect(0,0,Region.tile/3,Region.tile/3)
				
				Region["TOP"][i].yScale=0.4
				Region["TOP"][i].xScale=0.95
			else
				Region["TILE"][i]=display.newImageRect("tiles/FloorCorner.png",Region.tile/3,Region.tile/3)
			end
		elseif Region["REGION"][i].class=="TILE" then
			Region["TILE"][i]=display.newImageRect("tiles/FloorTile.png",Region.tile,Region.tile/1.5)
		end
		if (Region["PHYSICS"][i]) then
			Region["PHYSICS"][i].x=Create.POSITION.BEGIN.x+((Region.tile/1.5)*(Region["REGION"][i].col))
			Region["PHYSICS"][i].y=Create.POSITION.BEGIN.y+((Region.tile/2)*(Region["REGION"][i].row))
			Region["PHYSICS"][i]:setFillColor(0.8,0.4,0.4)
			physics.addBody(Region["PHYSICS"][i],"static",{friction=0.5,filter={categoryBits=1,maskBits=2}})
		end
		if (Region["TOP"][i]) then
			Region["TOP"][i].x=Region["PHYSICS"][i].x
			Region["TOP"][i].y=Region["PHYSICS"][i].y-(Region.tile*0.9)
		end
		if (Region["SIDE"][i]) then
			Region["SIDE"][i].x=Region["PHYSICS"][i].x
			Region["SIDE"][i].y=Region["PHYSICS"][i].y-(Region.tile/3)
			if Region["REGION"][i].class=="WALLX" then
				Region["SIDE"][i].y=Region["PHYSICS"][i].y-13
			end
		end
		if (Region["TILE"][i]) then
			Region["TILE"][i].x=Create.POSITION.BEGIN.x+((Region.tile/1.5)*(Region["REGION"][i].col))
			Region["TILE"][i].y=Create.POSITION.BEGIN.y+((Region.tile/2)*(Region["REGION"][i].row))
			if Region["TILE"][i].col==1 or Region["TILE"][i].col==13 or Region["TILE"][i].row==1 or Region["TILE"][i].row==13 then
				Region["TILE"][i]:setFillColor(0,0,1)
			end
		end
		if (grads) then
			local basetile=Region["TILE"][i] or Region["PHYSICS"][i]
			for a in ipairs(grads) do
				if Region["REGION"][i].class=="TILE" or Region["REGION"][i].class=="WALLX" then
					if (grads[2]) then
						if a==1 then
							grads[a].x=basetile.x-50
						elseif a==2 then
							grads[a].x=basetile.x+50
						end
					else
						grads[a].x=basetile.x
					end
					grads[a].y=basetile.y-17
				elseif Region["REGION"][i].class=="WALLY" then
					if a==1 then
						grads[a].x=basetile.x-50
					elseif a==2 then
						grads[a].x=basetile.x+50
					end
					grads[a].y=basetile.y-16
				end
			end
		end
		Region["Gradients"][i]=grads
	end
	
	
	for i=1,Region.side^2 do
		rowval=Region["REGION"][i].row+1
		if not (Region.regRows[rowval]) then
			Region.regRows[rowval]=display.newGroup()
			Region.regRows[rowval].toLayer=function() end
			Region.regRows[rowval].row=rowval
			Region.regRows[rowval].isVisible=false
		end
		
		if (Region["SIDE"][i]) then
			Region.regRows[rowval]:insert(Region["SIDE"][i])
			Region.regRows[rowval].askedY=Region["SIDE"][i].contentBounds.yMax
		end
		if (Region["TOP"][i]) then
			Region.regRows[rowval]:insert(Region["TOP"][i])
		end
	end
	
	for i=1,Region.side^2 do
		if (Region["TILE"][i]) then
			Region.Level:insert(Region["TILE"][i])
		end
		if (Region["PHYSICS"][i]) then
			Region.Level:insert(Region["PHYSICS"][i])
		end
	end
	for i=1,Region.side^2 do
		if (Region["Gradients"][i]) then
			for a in ipairs(Region["Gradients"][i]) do
				Region.Level:insert(Region["Gradients"][i][a])
			end
		end
	end
	
	-- # CLOSING
	Create:Progress()
end

function Create:Progress()
	-- # OPENING
	-- DEPENDENCIES
	local game=require("lua.game")
	-- FORWARD CALLS
	local funcs
	local funcnames
	-- LOCAL FUNCTIONS
	
	-- # BODY
	funcs={
		Create.sheet,Create.Template,Create.Walls,Create.Pathfinding,Create.Visualize
	}
	funcnames={
		"Sheet","Template","Walls","Pathfinding","Visualize"
	}
	if not (Create.progress) then
		Create.progress=0
	end
	Create.progress=Create.progress+1
	if (Create["loadinfo"] and funcnames[Create.progress]=="Pathfinding") then
		Create.progress=Create.progress+1
	end
	if Create.progress>table.maxn(funcs) then
		Create.progress=0
		game.HandleRegions:setRegion(Region)
	else
		print (funcnames[Create.progress])
		funcs[Create.progress]()
	end
	
	-- # CLOSING
end


