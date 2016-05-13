---------------------------------------------------------------------------------------
--
-- Game.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)
local mapsDone=false
local displayedMaps={}

---------------------------------------------------------------------------------------
-- STARTUP
---------------------------------------------------------------------------------------
local save=require("Lsave")
local ui=require("Lui")
-- local col=require("Levents")

Initial={}


function Initial:loadScreen()
	local splash=require("Lsplashes")
	LoadingScreen=display.newGroup()
	
	local loadsheet = graphics.newImageSheet( "ui/spriteload.png", { width=50, height=50, numFrames=8 } )
	
	local loadbkg=ui.CreateWindow(420,180,2)
	loadbkg.x = display.contentWidth-160
	loadbkg.y = display.contentHeight-130
	loadbkg:setFillColor(0.75,0.1,0.1)
	LoadingScreen:insert(loadbkg)
	
	local load1 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load1.x = display.contentWidth-50
	load1.y = display.contentHeight-100
	load1:play()
	LoadingScreen:insert( load1 )
	
	local load2 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load2.x = load1.x-55
	load2.y = load1.y
	load2:play()
	LoadingScreen:insert( load2 )
	
	local load3 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load3.x = load2.x+30
	load3.y = load2.y-50
	load3:play()
	LoadingScreen:insert( load3 )
	
	local loadtxt = display.newText("Loading...", 0,0,"Game Over",100)
	loadtxt.x = load2.x-150
	loadtxt.y = load1.y
	LoadingScreen:insert( loadtxt )
	
	local tip=splash.GetTip()
	LoadingScreen:insert( tip )
	
	local tipbkg=ui.CreateWindow(tip.width+40,tip.height+30,2)
	tipbkg.x=tip.x
	tipbkg.y=tip.y-15+(((tip.height/64)-1)*30)
	tipbkg:setFillColor(0.4,0.4,0.4)
	LoadingScreen:insert(tipbkg)
	
	tip:toFront()
end

function Initial:create(slot,value)
	local player=require("Lplayer")
	local per=require("perspective")
	Initial:loadScreen()
	save.setSlot(slot)
	view=per.createView()
	local data=save.Load:retrieveData()
	p1=player.CreatePlayer( value )
	if (data) then
		LoadData:setPlayerValues(data)
	end
	Initial:wait()
	HandleMaps:mapDisplay()
end

function Initial:wait()
	if (mapsDone==false) then
		timer.performWithDelay(250,Initial.wait)
	else
		Initial:Continue()
	end
end

function Initial:Continue()
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
	HandleEnemies:start()
	-- Initial:firstSave()
	Runtime:addEventListener("enterFrame",HandleEnemies.frameChecks)
	Controls:Move(0,0)
end

function Initial:firstSave()
	for map=1,table.maxn(displayedMaps) do
		if (displayedMaps[map]) then
			save.Save:keepMapData(displayedMaps[map])
		end
	end
	save.Save:keepPlayerData(p1)
	save.Save:recordData()
end



---------------------------------------------------------------------------------------
-- HANDLE MAPS
---------------------------------------------------------------------------------------
local maxmap=1000

HandleMaps={}


function HandleMaps:findSpot()
	local spot=1
	local found=false
	while spot<=4 and found==false do
		if displayedMaps[spot]==nil then
			found=true
		else
			spot=spot+1
		end
	end
	if found==false then
		spot=nil
	end
	return spot
end

function HandleMaps:mapDisplay()
	local builder=require("Lbuilder")
	mapsDone=false
	local mapstodisplay={
		{ p1["MAPX"],p1["MAPY"]},
		{},
		{},
		{}
	}
	
	local side=14
	local tile=200
	local deltaX=side/2
	deltaX=(deltaX*tile)+(deltaX*(tile/3))
	local deltaY=side/2
	deltaY=(deltaY*(tile/1.5))+(deltaY*(tile/3))
	
	if (displayedMaps[1]) then
		mapstodisplay[1][3]=displayedMaps[1].Xi or display.contentCenterX-(tile/2)
		mapstodisplay[1][4]=displayedMaps[1].Yi or display.contentCenterY-(tile/2)
	else
		mapstodisplay[1][3]=display.contentCenterX-(tile/2)
		mapstodisplay[1][4]=display.contentCenterY-(tile/2)
	end
	
	if p1["QUAD"]%2==0 then
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
	
	if p1["QUAD"]<3 then
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
	
	for m in ipairs(displayedMaps) do
		if (displayedMaps[m]["MAPX"]~=mapstodisplay[m][1]) or (displayedMaps[m]["MAPY"]~=mapstodisplay[m][2]) then
			HandleMaps:cleanMap(m)
		end
	end
		
	local result=HandleMaps:findSpot()
	if  (result) then
		local nx=mapstodisplay[result][1]
		local ny=mapstodisplay[result][2]
		local npx=mapstodisplay[result][3]
		local npy=mapstodisplay[result][4]
		
		local mapinfo=save.Load:getMap(nx,ny)
		print ("SEQUENCING: "..nx,ny,mapinfo)
		builder.Create:Start(nx,ny,mapinfo,npx,npy)
	else
		for m in ipairs(displayedMaps) do
			displayedMaps[m].Level.isVisible=true
			for r in ipairs(displayedMaps[m].MapRows) do
				displayedMaps[m].MapRows[r].isVisible=true
			end
		end
		HandleMaps:buildBoundary()
		HandleRows:InitialLayering()
		mapsDone=true
	end
end

function HandleMaps:buildBoundary()
	local order={}
	if displayedMaps[4]["MAPY"]<displayedMaps[1]["MAPY"] then
		if displayedMaps[4]["MAPX"]<displayedMaps[1]["MAPX"] then
			-- map4 is northwest
			order={4,3,2,1}
		else
			-- map4 is northeast
			order={3,4,1,2}
		end
	else
		if displayedMaps[4]["MAPX"]<displayedMaps[1]["MAPX"] then
			-- map4 is southwest
			order={2,1,4,3}
		else
			-- map4 is southeast
			order={1,2,3,4}
		end
	end
	
	local mapsize=table.maxn(displayedMaps[1]["PLAIN"])
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
			
			boundary[x][y]=displayedMaps[order[orderpos]]["PLAIN"][ay][ax]
			if boundary[x][y]==1 then
				displayb[x][y]:setFillColor(0.5,0,0,0.8)
			else
				displayb[x][y]:setFillColor(1,1,1,0.4)
			end
		end
	end
	
	displayedMaps["BOUNDS"]=boundary
	
end

function HandleMaps:setMap(value)
	local result=HandleMaps:findSpot()
	if (result) then
		displayedMaps[result]=value
		
		for i=1,table.maxn(value["MapRows"]) do
			local row=value["MapRows"][i]
			view:add(row,69,false)
		end
		view:add(value.Level,70,false)
		
		HandleMaps:mapDisplay()
	end
end

function HandleMaps:getMap(mapx,mapy)
	for i=1,table.maxn(displayedMaps) do
		if (displayedMaps[i]) then
			if displayedMaps[i]["MAPX"]==mapx and displayedMaps[i]["MAPY"]==mapy then
				return i,displayedMaps[i]
			end
		end
	end
	return nil,nil
end


function HandleMaps:cleanMap(victim)
	if (displayedMaps[victim]["PHYSICS"]) then
		for a in ipairs(displayedMaps[victim]["PHYSICS"]) do
			display.remove(displayedMaps[victim]["PHYSICS"][a])
			displayedMaps[victim]["PHYSICS"][a]=nil
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	if (displayedMaps[victim]["TOP"]) then
		for a in ipairs(displayedMaps[victim]["TOP"]) do
			display.remove(displayedMaps[victim]["TOP"][a])
			displayedMaps[victim]["TOP"][a]=nil
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	if (displayedMaps[victim]["SIDE"]) then
		for a in ipairs(displayedMaps[victim]["SIDE"]) do
			display.remove(displayedMaps[victim]["SIDE"][a])
			displayedMaps[victim]["SIDE"][a]=nil
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	if (displayedMaps[victim]["TILE"]) then
		for a in ipairs(displayedMaps[victim]["TILE"]) do
			display.remove(displayedMaps[victim]["TILE"][a])
			displayedMaps[victim]["TILE"][a]=nil
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	if (displayedMaps[victim]["Gradients"]) then
		for a in ipairs(displayedMaps[victim]["Gradients"]) do
			for b in ipairs(displayedMaps[victim]["Gradients"][a]) do
				display.remove(displayedMaps[victim]["Gradients"][a][b])
				displayedMaps[victim]["Gradients"][a][b]=nil
			end
		end
	else
		print ("MAP "..victim.." doesnt exist?")
	end
	
	displayedMaps[victim]=nil
end

function HandleMaps:movementEvents()
	
	local pastx,pasty=p1["CURX"]*2,p1["CURY"]*2
	if displayedMaps[4]["MAPX"]<displayedMaps[1]["MAPX"] then
		pastx=pastx+table.maxn(displayedMaps[1]["PLAIN"])
	end
	if displayedMaps[4]["MAPY"]<displayedMaps[1]["MAPY"] then
		pasty=pasty+table.maxn(displayedMaps[1]["PLAIN"])
	end
	
	displayb[pastx][pasty]:setFillColor(1,1,1,0.4)
	
	HandleMaps:mapSwitch()
	HandleRows:coordsCheck()
	
	-- local newx,newy=deltaX*2,deltaY*2
	local newx,newy=p1["CURX"]*2,p1["CURY"]*2
	if displayedMaps[4]["MAPX"]<displayedMaps[1]["MAPX"] then
		newx=newx+table.maxn(displayedMaps[1]["PLAIN"])
	end
	if displayedMaps[4]["MAPY"]<displayedMaps[1]["MAPY"] then
		newy=newy+table.maxn(displayedMaps[1]["PLAIN"])
	end
	
	displayb[newx][newy]:setFillColor(0,0,1,0.8)
end

function HandleMaps:mapSwitch()
	local xi=displayedMaps[1]["Xi"]
	local yi=displayedMaps[1]["Yi"]
	
	local xf=displayedMaps[1]["Xf"]
	local yf=displayedMaps[1]["Yf"]
	
	local newmapx=0
	local newmapy=0
	
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
	
	local quadchange=HandleMaps:QuadCheck()
	
	if newmapx~=0 or newmapy~=0 then
		p1["MAPX"]=p1["MAPX"]+newmapx
		p1["MAPY"]=p1["MAPY"]+newmapy
		
		if math.abs(p1["MAPX"])>maxmap then
			p1["MAPX"]=(p1["MAPX"]/math.abs(p1["MAPX"]))
			p1["MAPX"]=p1["MAPX"]*-1
			p1["MAPX"]=maxmap*p1["MAPX"]
		end
		if math.abs(p1["MAPY"])>maxmap then
			p1["MAPY"]=(p1["MAPY"]/math.abs(p1["MAPY"]))
			p1["MAPY"]=p1["MAPY"]*-1
			p1["MAPY"]=maxmap*p1["MAPY"]
		end
		
		for i in ipairs(displayedMaps) do
			if displayedMaps[i]["MAPX"]==p1["MAPX"] and displayedMaps[i]["MAPY"]==p1["MAPY"] then
				local temp=displayedMaps[i]
				displayedMaps[i]=displayedMaps[1]
				displayedMaps[1]=temp
			end
		end
		
		for i in ipairs(displayedMaps) do
			if displayedMaps[i]["MAPX"]~=p1["MAPX"] and displayedMaps[i]["MAPY"]==p1["MAPY"] then
				local temp=displayedMaps[i]
				displayedMaps[i]=displayedMaps[2]
				displayedMaps[2]=temp
			end
		end
		if (displayedMaps[4]) then
			if displayedMaps[4]["MAPX"]==p1["MAPX"] and displayedMaps[4]["MAPY"]~=p1["MAPY"] then
				local temp=displayedMaps[4]
				displayedMaps[4]=displayedMaps[3]
				displayedMaps[3]=temp
			end
		end
		p1["QUAD"]=HandleMaps:QuadCheck()
		print ("MAP CHANGE: "..p1["MAPX"],p1["MAPY"],p1["QUAD"])
		HandleRows:InitialLayering()
	elseif (quadchange) then
	
		for i in ipairs(displayedMaps) do
			save.Save:keepMapData(displayedMaps[i])
		end
		
		local constant="X"
		if quadchange%2==0 and p1["QUAD"]%2==0 then
			constant="Y"
		elseif quadchange%2==1 and p1["QUAD"]%2==1 then
			constant="Y"
		end
		
		p1["QUAD"]=quadchange
		
		
		for i in ipairs(displayedMaps) do
			if displayedMaps[i]["MAPX"]~=p1["MAPX"] and constant=="X" then
				HandleMaps:cleanMap(i)
			elseif displayedMaps[i]["MAPY"]~=p1["MAPY"] and constant=="Y" then
				HandleMaps:cleanMap(i)
			end
		end
		
		print ("QUAD CHANGE: "..p1["MAPX"],p1["MAPY"],p1["QUAD"])
		HandleMaps:mapDisplay()
	end
end

function HandleMaps:QuadCheck()
	local xm=displayedMaps[1]["X"]
	local ym=displayedMaps[1]["Y"]
	local newquad=1
	
	if p1.x>xm then
		newquad=newquad+1
	end
	
	if p1.y>ym then
		newquad=newquad+2
	end
	
	if p1["QUAD"]~=newquad then
		return newquad
	end
	return false
end



---------------------------------------------------------------------------------------
-- HANDLE ROWS
---------------------------------------------------------------------------------------

HandleRows={}

function HandleRows:doPostRowPosition( value )
	value:toLayer(34)
	value:toBack()
end

function HandleRows:doPreRowPosition( value )
	value:toLayer(36)
	value:toFront()
end

function HandleRows:InitialLayering()
	for i in ipairs(displayedMaps) do
		local mapitem=displayedMaps[i]
		for j=table.maxn(mapitem.MapRows)-1,1,-2 do
			local item1=mapitem.MapRows[j]
			local item2=mapitem.MapRows[j+1]
			if (item1[1].y<p1.y) then
				HandleRows:doPreRowPosition(item1)
				HandleRows:doPreRowPosition(item2)
			else
				HandleRows:doPostRowPosition(item2)
				HandleRows:doPostRowPosition(item1)
			end
		end
	end
	HandleRows:FurtherLayering()
end

function HandleRows:FurtherLayering()
	local transvar=0.4
	for map=1,2 do
		-- LAYERS AFTER / VISUALLY DOWN
		for layer=5,2,-1 do
			local thislayer=(p1["CURY"]*2)+(layer-2)
			local thismap=map
			local thislayerobj
			if thislayer<1 then
				thislayer=thislayer+14
				thismap=thismap+2
			elseif thislayer>14 then
				thislayer=thislayer-14
				thismap=thismap+2
			end
			
			if (displayedMaps[thismap]) then
				thislayerobj=displayedMaps[thismap].MapRows[thislayer]
				-- print (map,layer,"->",thismap,thislayer)
				if not (thislayerobj) then
					print ("!E")
				end
				-- if (layer<1) then
				-- if (layer==1) then
					-- HandleRows:doPreRowPosition(thislayerobj)
				-- elseif (layer>1) then
				-- if (layer>1) then
					HandleRows:doPostRowPosition(thislayerobj)
				-- end
				if (layer==3) then
					transition.to( thislayerobj, { time=500, alpha=transvar } )
				else
					if (layer==4) and (thislayer==1) then
						transition.to( thislayerobj, { time=500, alpha=transvar } )
					else
						transition.to( thislayerobj, { time=500, alpha=1 } )
					end
				end
			end
		end
		-- LAYERS BEFORE / VISUALLY UP
		for layer=-3,1 do
			local thislayer=(p1["CURY"]*2)+(layer-2)
			local thismap=map
			local thislayerobj
			if thislayer<1 then
				thislayer=thislayer+14
				thismap=thismap+2
			elseif thislayer>14 then
				thislayer=thislayer-14
				thismap=thismap+2
			end
			
			if (displayedMaps[thismap]) then
				thislayerobj=displayedMaps[thismap].MapRows[thislayer]
				-- print (map,layer,"->",thismap,thislayer)
				if not (thislayerobj) then
					print ("!E")
				end
				HandleRows:doPreRowPosition(thislayerobj)
				transition.to( thislayerobj, { time=500, alpha=1 } )
			end
		end
	end
end

function HandleRows:coordsCheck()
	local xi=displayedMaps[1]["Xi"]
	local yi=displayedMaps[1]["Yi"]
	
	local deltaY=p1.y-yi
	local tileY=200
	tileY=(tileY/1.5)+(tileY/3)
	deltaY=math.floor(deltaY/tileY)+1
	
	local deltaX=p1.x-xi
	deltaX=math.floor(deltaX/270)+1
	
	if p1["CURX"]~=deltaX then
		p1["CURX"]=deltaX
	end
	if p1["CURY"]~=deltaY then
		-- print ("PLAYER Y: "..deltaY)
		p1["CURY"]=deltaY
		HandleRows:FurtherLayering()
	end
end



---------------------------------------------------------------------------------------
-- ENEMIES
---------------------------------------------------------------------------------------
local spawnedEnemies={}

HandleEnemies={}


function HandleEnemies:start()
	if( HandleEnemies:findSpot() ) then
		HandleEnemies:spawn()
	end
	
	-- timer.performWithDelay(2500,HandleEnemies.start)
end

function HandleEnemies:findSpot()
	local spot=1
	local found=false
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
	return spot
end

function HandleEnemies:spawn()
	local result=HandleEnemies:findSpot()
	if (result) then
		local angle=math.random(0,359)
		-- local radius=800
		local radius=200
		angle=math.rad(angle)
		local x=radius*( math.cos(angle) )
		local y=radius*( math.sin(angle) )
		x=x+p1.x
		y=y+p1.y
		local enemy=require('Lenemy')
		spawnedEnemies[result]=enemy.Spawn(x,y)
		view:add(spawnedEnemies[result],36,false)
	end
end

function HandleEnemies:frameChecks()
	for i=1,table.maxn(spawnedEnemies) do
		if (spawnedEnemies[i]) then
	
			local pastx,pasty=spawnedEnemies[i]["CURX"]*2,spawnedEnemies[i]["CURY"]*2
			local mapsize=table.maxn(displayedMaps[1]["PLAIN"])
			local em=spawnedEnemies[i]["DMAP"]
			if displayedMaps[4]["MAPX"]<displayedMaps[1]["MAPX"] then
				if em==1 or em==3 then
					pastx=pastx+mapsize
				end
				-- pastx=pastx+table.maxn(displayedMaps[1]["PLAIN"])
			end
			if displayedMaps[4]["MAPY"]<displayedMaps[1]["MAPY"] then
				if em==1 or em==2 then
					pasty=pasty+mapsize
				end
				-- pasty=pasty+table.maxn(displayedMaps[1]["PLAIN"])
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
			-- HandleEnemies:getPath(i)
			HandleEnemies:removeCheck(i)
			
			
			if (spawnedEnemies[i]) then
				-- local newx,newy=deltaX*2,deltaY*2
				local newx,newy=spawnedEnemies[i]["CURX"]*2,spawnedEnemies[i]["CURY"]*2
				local em=spawnedEnemies[i]["DMAP"]
				if displayedMaps[4]["MAPX"]<displayedMaps[1]["MAPX"] then
					if em==1 or em==3 then
						newx=newx+mapsize
					end
					-- newx=newx+table.maxn(displayedMaps[1]["PLAIN"])
				end
				if displayedMaps[4]["MAPY"]<displayedMaps[1]["MAPY"] then
					if em==1 or em==2 then
						newy=newy+mapsize
					end
					-- newy=newy+table.maxn(displayedMaps[1]["PLAIN"])
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
end

function HandleEnemies:removeCheck(a)
	if spawnedEnemies[a].isAlive==false then
		HandleEnemies:removeEnemy(a)
	end
end

function HandleEnemies:removeEnemy(target)
	-- timer.cancel(spawnedEnemies[target].refreshtimer)
	Runtime:removeEventListener("enterFrame",spawnedEnemies[target].refresh)
	-- timer.cancel(spawnedEnemies[target].radartimer)
	
	-- display.remove(spawnedEnemies[target].shadow)
	-- spawnedEnemies[target].shadow=nil
	
	-- display.remove(spawnedEnemies[target].radar)
	-- spawnedEnemies[target].radar=nil
	
	display.remove(spawnedEnemies[target])
	spawnedEnemies[target]=nil
end

function HandleEnemies:enemyHits(i)
	local obj1=p1["HitBox"]
	if (obj1) then
		local thisEnemy=spawnedEnemies[i]
		local obj2=thisEnemy["WEAPON"]
		if (obj2) then
			local framecheck=thisEnemy["CURFRAME"]>10 and thisEnemy["CURFRAME"]<20
			if thisEnemy["SEQUENCE"]=="SWING" and (framecheck) then
				if (obj2.canDamage==true) then
					local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
					local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
					local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
					local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
					
					local thisCycle=(left or right) and (up or down)
					if thisCycle==true then
						obj2.canDamage=false
						-- print "WHAM!"
						local damageDealt=obj2.basedamage
						if damageDealt>0 then
							damageDealt=damageDealt*-1
						end
						p1:ModifyHealth(damageDealt)
					end
				end
			elseif (obj2) then
				obj2.canDamage=true
			end
		end
	end
end

function HandleEnemies:doPostRowPosition( value )
	value:toLayer(34)
	value:toBack()
end

function HandleEnemies:doPreRowPosition( value )
	value:toLayer(36)
	value:toFront()
end

function HandleEnemies:coordsCheck(i)
	local xi=displayedMaps[1]["Xi"]
	local yi=displayedMaps[1]["Yi"]
	local map=1
	for i=1,4 do
		if (displayedMaps[i]) then
			if (displayedMaps[i]["Xi"]<=xi) and (displayedMaps[i]["Yi"]<=yi) then
				xi=displayedMaps[i]["Xi"]
				yi=displayedMaps[i]["Yi"]
				map=i
			end
		end
	end
	
	
	local deltaY=spawnedEnemies[i].y-yi
	local tileY=200
	tileY=(tileY/1.5)+(tileY/3)
	deltaY=math.floor(deltaY/tileY)+1
	
	local deltaX=spawnedEnemies[i].x-xi
	deltaX=math.floor(deltaX/270)+1
	
	if (deltaY<0) or (deltaX<0) then
		spawnedEnemies[i].isAlive=false
		print ("enemy out of bounds: north or west")
	end
	
	if spawnedEnemies[i].isAlive==true then
		local xf=displayedMaps[1]["Xf"]
		local yf=displayedMaps[1]["Yf"]
		for i=1,4 do
			if (displayedMaps[i]) then
				if (displayedMaps[i]["Xf"]>=xf) and (displayedMaps[i]["Yf"]>=yf) then
					xf=displayedMaps[i]["Xf"]
					yf=displayedMaps[i]["Yf"]
				end
			end
		end
		if (spawnedEnemies[i].y>yf) or (spawnedEnemies[i].y>xf) then
			spawnedEnemies[i].isAlive=false
			print ("enemy out of bounds: south or east")
		end
	end
	
	--[[
	local comp1=p1["CURY"]
	
	if (displayedMaps[4]) then
		if displayedMaps[4]["MAPY"]<displayedMaps[1]["MAPY"] then
			-- deltaY=deltaY+8
			comp1=comp1+8
		end
	end
	
	-- if (displayedMaps[4]) then
		-- if displayedMaps[4]["MAPX"]<displayedMaps[1]["MAPX"] then
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
		if spawnedEnemies[i]["CURX"]~=deltaX then
			spawnedEnemies[i]["CURX"]=deltaX
			spawnedEnemies[i]["DMAP"]=map
			spawnedEnemies[i]["MAPX"]=displayedMaps[map]["MAPX"]
			spawnedEnemies[i]["MAPY"]=displayedMaps[map]["MAPY"]
		end
		if spawnedEnemies[i]["CURY"]~=deltaY then
			spawnedEnemies[i]["CURY"]=deltaY
			spawnedEnemies[i]["DMAP"]=map
			spawnedEnemies[i]["MAPX"]=displayedMaps[map]["MAPX"]
			spawnedEnemies[i]["MAPY"]=displayedMaps[map]["MAPY"]
			
			-- if deltaY>comp1 then
				-- local layertomodify=view:layer(34)
				
				-- HandleEnemies:doPostRowPosition( spawnedEnemies[i] )
				
				-- local front=math.abs(deltaY-comp1)*2
				-- local i=layertomodify.numChildren
				-- local done=false
				-- local cyclecap=1
				-- while (i>=cyclecap and done==false) do
					-- layertomodify[i]:toBack()
					-- if (layertomodify[i].row) then
						-- front=front-1
					-- end
					
					-- i=i-1
					-- if front==0 then
						-- done=true
					-- end
				-- end
			-- else
				-- local layertomodify=view:layer(36)
				
				-- HandleEnemies:doPreRowPosition( spawnedEnemies[i] )
				
				-- local front=math.abs(deltaY-comp1)*2
				-- local done=false
				-- local cyclecap=layertomodify.numChildren
				-- local i=cyclecap-(front+2)
				-- while (i<=cyclecap and done==false) do
					-- layertomodify[i]:toFront()
					-- if (layertomodify[i].row) then
						-- front=front-1
					-- end
					
					-- i=i+1
					-- if front==0 then
						-- done=true
					-- end
				-- end
			-- end
		end
	end
	
end

function HandleEnemies:getPath(i)
	local thisEnemy=spawnedEnemies[i]
	if thisEnemy["MODE"]=="PURSUIT" then
		-- print "FOUND IN PURSUIT"

		local ex,ey=thisEnemy["CURX"]*2,thisEnemy["CURY"]*2
		local em=thisEnemy["DMAP"]
		local px,py=thisEnemy["AIVALS"]["UNIT"]["TILE"]["X"]*2,thisEnemy["AIVALS"]["UNIT"]["TILE"]["Y"]*2
		local pm=HandleMaps:getMap(thisEnemy["AIVALS"]["UNIT"]["MAP"]["X"],thisEnemy["AIVALS"]["UNIT"]["MAP"]["Y"])
		
		-- print ("RAW: "..ex,ey,"to",px,py)
		
		local mapsize=table.maxn(displayedMaps[1]["PLAIN"])
		if displayedMaps[4]["MAPX"]<displayedMaps[1]["MAPX"] then
			px=px+mapsize
			-- if em==1 or em==3 then
				-- print ("adding "..mapsize.." to enemy X coord because of offset. (currentx: "..ex..")")
				-- ex=ex+mapsize
			-- end
		end
		if displayedMaps[4]["MAPY"]<displayedMaps[1]["MAPY"] then
			py=py+mapsize
			-- if em==1 or em==2 then
				-- print ("adding "..mapsize.." to enemy Y coord because of offset. (currentx: "..ey..")")
				-- ey=ey+mapsize
			-- end
		end
		
		-- print (ex,ey,"to",px,py)
		
		
		-- Runtime:removeEventListener("enterFrame",HandleEnemies.frameChecks)
		
		local walkable = 0

		-- Library setup
		local Grid = require ("jumper.grid") -- The grid class
		local Pathfinder = require ("jumper.pathfinder") -- The pathfinder class
		
		-- Creates a grid object
		local grid = Grid(displayedMaps["BOUNDS"])
		-- Creates a pathfinder object using Jump Point Search
		local pather = Pathfinder(grid, 'DIJKSTRA', walkable) -- I like DIJKSTRA, but others work too. Check the pathfinding module for more info on the types of pathfinding algorithm.
		pather:setMode('ORTHOGONAL')
		
		local path = pather:getPath(ex,ey,px,py)

		if path then
			for node, count in path:nodes() do
				print (count, node:getX(), node:getY())
			end
			-- print "REMOVING LISTENER"
			-- Runtime:removeEventListener("enterFrame",HandleEnemies.frameChecks)
		else 
			-- print "no path found"
		end
	end
end


---------------------------------------------------------------------------------------
-- MOVEMENT
---------------------------------------------------------------------------------------

Controls={}


function Controls:Check(px,py)
	local value=0
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
end

function Controls:Move(px,py)
	-- if mapsDone==true then
		local cruisecontrol=40
		-- p1["shadow"].x=p1["shadow"].x+(px*p1["STATS"]["Speed"]/cruisecontrol)
		-- p1["shadow"].y=p1["shadow"].y+(py*p1["STATS"]["Speed"]/cruisecontrol)
		p1.x=p1.x+(px*p1["STATS"]["Speed"]/cruisecontrol)
		p1.y=p1.y+(py*p1["STATS"]["Speed"]/cruisecontrol)
		
		HandleMaps:movementEvents()
		
		-- p1.x=p1.shadow.x
		-- p1.y=p1.shadow.y
	-- end
end

function Controls:buttonPress()
	-- Tests:
	-- g.CallAddCoins(100)
	-- p1["STATS"]["Experience"]=p1["STATS"]["Experience"]+10
	-- p1:ModifyHealth(-20,"Sux2BU")
	-- p1:ModifyMana(-10)
	-- p1:ModifyEnergy(-10)
	print (spawnedEnemies[1]["CURX"],spawnedEnemies[1]["CURY"])
	
	
	-- p1:setSequence("SWING")
	-- Runtime:addEventListener("enterFrame",Controls.playerHits)
end

function Controls:playerHits()
	if p1["SEQUENCE"]~="SWING" then
		Runtime:removeEventListener("enterFrame",Controls.playerHits)
	elseif p1["SEQUENCE"]=="SWING" then
		local framecheck=p1["CURFRAME"]>10 and p1["CURFRAME"]<20
		if framecheck then
			local hitSomeone=false
			local obj1=p1["WEAPON"]
			if (obj1) then
				for i=1,table.maxn(spawnedEnemies) do
					if (spawnedEnemies[i]) then
						local obj2=spawnedEnemies[i]["HitBox"]
						if (obj2) then
							
							local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
							local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
							local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
							local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
							
							local thisCycle=(left or right) and (up or down)
							if thisCycle==true then
								local damageDealt=obj1.basedamage
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
			if hitSomeone==true then
				Runtime:removeEventListener("enterFrame",Controls.playerHits)
			end
		end
	end
end



---------------------------------------------------------------------------------------
-- LOAD DATA
---------------------------------------------------------------------------------------

LoadData={}


function LoadData:setPlayerValues(data)
	
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
	
	p1:generateStats()
end


