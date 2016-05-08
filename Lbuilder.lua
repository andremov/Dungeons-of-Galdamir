---------------------------------------------------------------------------------------
--
-- Builder.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)

---------------------------------------------------------------------------------------
-- GLOBAL
---------------------------------------------------------------------------------------

local side=14
local tile=200

function getColumn(id)
	local column=((id-1)%side)
	return column
end

function getRow(id)
	local row=math.floor((id-1)/side)
	return row
end

local function readAsset(assname)
	local JSON = require("JSON")
	-- call JSON read func to receive lua table with JSON info
	
	filename = system.pathForFile( assname )
	file = assert(io.open(filename, "r"))
	
	-- use JSON library to decode it to a LUA table
	-- then return table
	
	-- local output = J:decode(file:read("*all"))
	local output = JSON:decode(file:read("*all"))
	output=output["frames"]
	
	-- arrange JSON info to a better array
	-- i used for id of animation
	-- first name is animation name
	-- animation subdivision -> parts
	-- part name is asset name
	-- for every frame of animation, save asset info
	-- x, y, xScale, yScale, rotation, depth
	-- depth is layering, who is in front of who
	-- then arrange color matrix to regular RGBA channels
	
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
	return parsed
end


---------------------------------------------------------------------------------------
-- CREATE
---------------------------------------------------------------------------------------

local Map
Create={}

function Create:Start(paramx,paramy,info,posx,posy)
	Create["MAPX"]=paramx
	Create["MAPY"]=paramy
	Create["loadinfo"]=info
	
	
	local deltaX=side/2
	local deltaY=(deltaX*(tile/1.5))+(deltaX*(tile/3))
	deltaX=(deltaX*tile)+(deltaX*(tile/3))
	Create["Xi"]=posx
	Create["Yi"]=posy
	
	Create["X"]=Create["Xi"]+(deltaX/2)
	Create["Y"]=Create["Yi"]+(deltaY/2)
	
	Create["Xf"]=Create["X"]+(deltaX/2)
	Create["Yf"]=Create["Y"]+(deltaY/2)
	
	Create:Progress()
end

function Create:sheet()
	-- local options=readAsset('tiles/Tiles.json')
	-- Create.TSheet=graphics.newImageSheet( "/Tiles/Tiles.png", options )
	-- Create.TilesRef={}
	-- for i=1,table.maxn(options["frames"]) do
		-- Create.TilesRef[options["frames"][i]["filename"]]=i
	-- end
	Create:Progress()
end

function Create:Template()
	-- Create={}
	-- Create.CreateRows={}
	Map={}
	Map.side=side
	Map.tile=tile
	
	Map["MAPX"]=Create["MAPX"]
	Map["MAPY"]=Create["MAPY"]
	
	Map["X"]=Create["X"]
	Map["Y"]=Create["Y"]
	
	Map["Xi"]=Create["Xi"]
	Map["Yi"]=Create["Yi"]
	
	Map["Xf"]=Create["Xf"]
	Map["Yf"]=Create["Yf"]
	
	Map.MapRows={}
	-- for i=1,8 do
		-- Map.MapRows[i]=display.newGroup()
		-- Map.MapRows[i].toLayer=function() end
		-- Map.MapRows[i].row=i
		-- Map.MapRows[i].isVisible=false
	-- end
	Map.Gradients=display.newGroup()
	Map.Gradients.isVisible=false
	Map.Level=display.newGroup()
	Map.Level.isVisible=false
	
	Map["MAP"]={}
	for i=1,Map.side^2 do
		Map["MAP"][i]={}
		Map["MAP"][i].col=getColumn(i)
		Map["MAP"][i].row=getRow(i)
	end
	Map["PLAIN"]={}
	for i=1,Map.side do
		Map["PLAIN"][i]={}
	end
	Create:Progress()
end

function Create:Walls()
	for i=1,Map.side^2 do
		local plaincol=Map["MAP"][i].col+1
		local plainrow=Map["MAP"][i].row+1
		if Map["MAP"][i].row%2==0 and Map["MAP"][i].col%2==0 then
			Map["MAP"][i].class="CORNER"
			Map["MAP"][i].wall=true
			if ( Create["loadinfo"] ) then
				Map["MAP"][i].open=( Create["loadinfo"][i]==0 )
				Map["PLAIN"][plainrow][plaincol]=Create["loadinfo"][i]
			else
				Map["PLAIN"][plainrow][plaincol]=1
				Map["MAP"][i].open=false
			end
		elseif Map["MAP"][i].col%2==0 then
			Map["MAP"][i].class="WALLX"
			Map["MAP"][i].wall=true
			if ( Create["loadinfo"] ) then
				Map["MAP"][i].open=( Create["loadinfo"][i]==0 )
				Map["PLAIN"][plainrow][plaincol]=Create["loadinfo"][i]
			else
				Map["MAP"][i].open=math.random(0,1)
				Map["PLAIN"][plainrow][plaincol]=Map["MAP"][i].open
				Map["MAP"][i].open=(Map["MAP"][i].open==0)
			end
		elseif Map["MAP"][i].row%2==0 then
			Map["MAP"][i].class="WALLY"
			Map["MAP"][i].wall=true
			if ( Create["loadinfo"] ) then
				Map["MAP"][i].open=( Create["loadinfo"][i]==0 )
				Map["PLAIN"][plainrow][plaincol]=Create["loadinfo"][i]
			else
				Map["MAP"][i].open=math.random(0,1)
				Map["PLAIN"][plainrow][plaincol]=Map["MAP"][i].open
				Map["MAP"][i].open=(Map["MAP"][i].open==0)
			end
		else
			Map["MAP"][i].class="TILE"
			Map["MAP"][i].wall=false
			if ( Create["loadinfo"] ) then
				Map["MAP"][i].open=( Create["loadinfo"][i]==0 )
				Map["PLAIN"][plainrow][plaincol]=Create["loadinfo"][i]
			else
				Map["MAP"][i].open=true
				Map["PLAIN"][plainrow][plaincol]=0
			end
		end
		Map["MAP"][i].roomed=false
	end
	
	Create:Progress()
end

function Create:Pathfinding()
	local tiles2={}
	local numTiles=0
	local done=false
	for i=1,table.maxn(Map["MAP"]) do
		tiles2[i]={}
		tiles2[i].open=false
		tiles2[i].done=false
		tiles2[i].walls={}
	end
	tiles2[Map.side+2].open=true
	local obj
	local cont
	while done==false and numTiles<(Map.side^2)/4 do
		obj=nil
		cont=1
		while not(obj) and cont<=table.maxn(Map["MAP"]) do
			if tiles2[cont].open==true and tiles2[cont].done==false then
				obj=cont
			end
			cont=cont+1
		end
		if not (obj) then
			cont=1
			while not(obj) and cont<=table.maxn(Map["MAP"]) do
				if tiles2[cont].open==false and Map["MAP"][cont].class=="TILE" then
					obj=cont
					-- print ("BREAKING: "..obj)
					local walls={obj-Map.side,obj-1,obj+1,obj+Map.side}
					for v=1,table.maxn(walls) do
						local curdir=walls[v]
						if (Map["MAP"][curdir]) then
							Map["MAP"][curdir].roomed=true
							Map["MAP"][curdir].open=true
							local plainrow=Map["MAP"][curdir].row+1
							local plaincol=Map["MAP"][curdir].col+1
							Map["PLAIN"][plainrow][plaincol]=0
						end
					end
				end
				cont=cont+1
			end
		end
		if not (obj) and numTiles==(Map.side^2)/4 then
			done=true
		end
		if (obj) then
			-- print ("OBJ>"..obj)
			local walls={"U","L","R","D"}
			for i=1,table.maxn(walls) do
				local curdir=walls[i]
				local curtile
				local curwall
				if curdir=="U" then
					curtile=obj-(Map.side*2)
					curwall=obj-Map.side
				elseif curdir=="L" then
					curtile=obj-2
					curwall=obj-1
				elseif curdir=="R" then
					curtile=obj+2
					curwall=obj+1
				elseif curdir=="D" then
					curtile=obj+(Map.side*2)
					curwall=obj+Map.side
				end
				-- print ("   >WALL>"..curwall)
				-- print ("        >TILE>"..curtile)
				if (getRow(curwall)==0 and curdir=="U") or 
				   (getColumn(curwall)==0 and curdir=="L") then
					curtile=nil
				end
				if (getRow(obj)==Map.side-1 and curdir=="D") or 
				   (getColumn(obj)==Map.side-1 and curdir=="R") then
					curwall=nil
				end

				if (curwall) and (Map["MAP"][curwall].open==true) then
					Map["MAP"][curwall].roomed=true
					if (curtile) then
						tiles2[curtile].open=true
						-- print ("             >isOpen")
					end
				else
					-- print ("             >isNot")
					if (curwall) and (curtile) and (tiles2[curtile].open==false) then
						tiles2[curtile].walls[#tiles2[curtile].walls+1]=curwall
						if table.maxn(tiles2[curtile].walls)>=2 then
							for w=1,table.maxn(tiles2[curtile].walls) do
								local v=tiles2[curtile].walls[w]
								Map["MAP"][v].roomed=true
								Map["MAP"][v].open=true
								local plainrow=Map["MAP"][v].row+1
								local plaincol=Map["MAP"][v].col+1
								Map["PLAIN"][plainrow][plaincol]=0
							end
							tiles2[curtile].open=true
							-- print ("             >nowOpen")
						end
					end
				end
			end
			tiles2[obj].done=true
			Map["MAP"][obj].roomed=true
			numTiles=numTiles+1
		end
	end
	-- print ("NumTiles: "..numTiles)
	Create:Progress()
end

function Create:Visualize()
	local physics = require "physics"
	if (Map["PHYSICS"]) then
		for i=1,table.maxn(Map["MAP"]) do
			display.remove(Map["PHYSICS"][i])
			Map["PHYSICS"][i]=nil
			display.remove(Map["TOP"][i])
			Map["TOP"][i]=nil
			display.remove(Map["SIDE"][i])
			Map["SIDE"][i]=nil
			display.remove(Map["TILE"][i])
			Map["TILE"][i]=nil
		end
		for i=1,Map["Gradients"].numChildren do
			display.remove(Map["Gradients"][i])
			Map["Gradients"][i]=nil
		end
	end
	Map["PHYSICS"]=nil
	Map["PHYSICS"]={}
	Map["TOP"]=nil
	Map["TOP"]={}
	Map["SIDE"]=nil
	Map["SIDE"]={}
	Map["TILE"]=nil
	Map["TILE"]={}
	Map["Gradients"]=nil
	Map["Gradients"]={}
	for i=1,table.maxn(Map["MAP"]) do
		grads={}
		if Map["MAP"][i].class=="WALLY" then
			if Map["MAP"][i].open==false then
				Map["SIDE"][i]=display.newImageRect("tiles/SideWall.png",Map.tile,Map.tile)
				Map["TOP"][i]=display.newImage("tiles/TopWall.png",Map.tile,Map.tile/3)
				Map["PHYSICS"][i]=display.newRect(0,0,Map.tile,Map.tile/3)
				
				
				Map["TOP"][i].yScale=0.4
			else
				Map["TILE"][i]=display.newImageRect("tiles/FloorWall.png",Map.tile,Map.tile/3)
				
				grads[#grads+1]=display.newImageRect("tiles/CornerGrad.png",Map.tile/2,Map.tile/2)
				grads[#grads]:rotate(270)
				grads[#grads+1]=display.newImageRect("tiles/CornerGrad.png",Map.tile/2,Map.tile/2)
				grads[#grads]:rotate(180)
			end
		elseif Map["MAP"][i].class=="WALLX" then
			if Map["MAP"][i].open==false then
				Map["TOP"][i]=display.newImage("tiles/TopWall.png",Map.tile/1.5,Map.tile/3)
				Map["SIDE"][i]=display.newImageRect("tiles/SidePillar.png",Map.tile/3,Map.tile)
				Map["PHYSICS"][i]=display.newRect(0,0,Map.tile/3,Map.tile/1.5)
				
				Map["TOP"][i]:rotate(90)
				Map["TOP"][i].xScale=0.85
				Map["TOP"][i].yScale=0.95
				Map["SIDE"][i].yScale=0.8
			else
				Map["TILE"][i]=display.newImageRect("tiles/FloorWall.png",Map.tile/1.5,Map.tile/3)
				Map["TILE"][i]:rotate(90)
				
				grads[#grads+1]=display.newImageRect("tiles/WallGrad.png",Map.tile/3,Map.tile/2)
			end
		elseif Map["MAP"][i].class=="CORNER" then
			Map["SIDE"][i]=display.newImageRect("tiles/SidePillar.png",Map.tile/3,Map.tile)
			Map["TOP"][i]=display.newImage("tiles/TopPillar.png",Map.tile/3,Map.tile/3)
			Map["PHYSICS"][i]=display.newRect(0,0,Map.tile/3,Map.tile/3)
			
			Map["TOP"][i].yScale=0.4
			Map["TOP"][i].xScale=0.95
		elseif Map["MAP"][i].class=="TILE" then
			Map["TILE"][i]=display.newImageRect("tiles/FloorTile.png",Map.tile,Map.tile/1.5)
			if Map["MAP"][i-Map.side].open==false then
				grads[#grads+1]=display.newImageRect("tiles/WallGrad.png",Map.tile,Map.tile/2)
			else
				grads[#grads+1]=display.newImageRect("tiles/CornerGrad.png",Map.tile/2,Map.tile/2)
				grads[#grads+1]=display.newImageRect("tiles/CornerGrad.png",Map.tile/2,Map.tile/2)
				grads[#grads]:rotate(90)
			end
		end
		if (Map["PHYSICS"][i]) then
			Map["PHYSICS"][i].x=Map["Xi"]+((Map.tile/1.5)*(Map["MAP"][i].col))
			Map["PHYSICS"][i].y=Map["Yi"]+((Map.tile/2)*(Map["MAP"][i].row))
			Map["PHYSICS"][i]:setFillColor(0.8,0.4,0.4)
			physics.addBody(Map["PHYSICS"][i],"static",{friction=0.5,filter={categoryBits=1,maskBits=2}})
		end
		if (Map["TOP"][i]) then
			Map["TOP"][i].x=Map["PHYSICS"][i].x
			Map["TOP"][i].y=Map["PHYSICS"][i].y-(Map.tile*0.9)
		end
		if (Map["SIDE"][i]) then
			Map["SIDE"][i].x=Map["PHYSICS"][i].x
			Map["SIDE"][i].y=Map["PHYSICS"][i].y-(Map.tile/3)
			if Map["MAP"][i].class=="WALLX" then
				Map["SIDE"][i].y=Map["PHYSICS"][i].y-13
			end
		end
		if (Map["TILE"][i]) then
			Map["TILE"][i].x=Map["Xi"]+((Map.tile/1.5)*(Map["MAP"][i].col))
			Map["TILE"][i].y=Map["Yi"]+((Map.tile/2)*(Map["MAP"][i].row))
			if Map["TILE"][i].col==1 or Map["TILE"][i].col==13 or Map["TILE"][i].row==1 or Map["TILE"][i].row==13 then
				Map["TILE"][i]:setFillColor(0,0,1)
			end
		end
		if (grads) then
			local basetile=Map["TILE"][i] or Map["PHYSICS"][i]
			for a in ipairs(grads) do
				if Map["MAP"][i].class=="TILE" or Map["MAP"][i].class=="WALLX" then
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
				elseif Map["MAP"][i].class=="WALLY" then
					if a==1 then
						grads[a].x=basetile.x-50
					elseif a==2 then
						grads[a].x=basetile.x+50
					end
					grads[a].y=basetile.y-16
				end
			end
		end
		Map["Gradients"][i]=grads
	end
	
	
	for i=1,Map.side^2 do
		local rowval=Map["MAP"][i].row+1
		if not (Map.MapRows[rowval]) then
			Map.MapRows[rowval]=display.newGroup()
			Map.MapRows[rowval].toLayer=function() end
			Map.MapRows[rowval].row=rowval
			Map.MapRows[rowval].isVisible=false
		end
		
		if (Map["SIDE"][i]) then
			Map.MapRows[rowval]:insert(Map["SIDE"][i])
		end
		if (Map["TOP"][i]) then
			Map.MapRows[rowval]:insert(Map["TOP"][i])
		end
	end
	
	-- for i=1,Map.side^2 do
		-- local rowval=Map["MAP"][i].row+1
		-- if (Map["Gradients"][i]) then
			-- for a in ipairs(Map["Gradients"][i]) do
				-- Map.MapRows[rowval]:insert(Map["Gradients"][i][a])
			-- end
		-- end
	-- end
	
	for i=1,Map.side^2 do
		if (Map["TILE"][i]) then
			Map.Level:insert(Map["TILE"][i])
		end
		if (Map["PHYSICS"][i]) then
			Map.Level:insert(Map["PHYSICS"][i])
		end
	end
	for i=1,Map.side^2 do
		if (Map["Gradients"][i]) then
			for a in ipairs(Map["Gradients"][i]) do
				Map.Level:insert(Map["Gradients"][i][a])
			end
		end
	end
	Create:Progress()
end

function Create:Progress()
	local game=require("Lgame")
	local funcs={
		Create.sheet,Create.Template,Create.Walls,Create.Pathfinding,Create.Visualize--,Create.Join,
	}
	local funcnames={
		"Sheet","Template","Walls","Pathfinding","Visualize"--,"Join",
	}
	if not (Create.progress) then
		Create.progress=0
	end
	Create.progress=Create.progress+1
	if (Create["loadinfo"] and funcnames[Create.progress]=="Pathfinding") then
		Create.progress=Create.progress+1
	end
	if Create.progress>table.maxn(funcs) then
		-- print "Done."
		
			-- local str
			-- str=""
			-- Map["MAP"].open
		Create.progress=0
		game.HandleMaps:getMap(Map)
	else
		-- print (funcnames[Create.progress])
		-- timer.performWithDelay(1,funcs[Create.progress])
		funcs[Create.progress]()
	end
end


