-----------------------------------------------------------------------------------------
--
-- settings.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local o=require("Loptions")
local gsm
local curname=1
local window
local snap=1
local names={
		"Gold Counter","Health Display","Mana Display",
		"Energy Display","Stat Points Notice","Experience Bar",
		"Quest Log","Pause Button"
	}
local info={
		-- Gold
		{"demogold.png",140,50},
		-- HP
		{"demohealth.png",140,50},
		-- MP
		{"demomana.png",140,50},
		-- EP
		{"demoenergy.png",140,50},
		-- Unspent point
		{"unspent.png",240,80},
		-- XP Bar
		{"demoxp.png",392,40},
		-- Quest
		{"demoquest.png",447,80},
		-- Pause Button
		{"pauseon.png",84.5,84.5},
	}
local positions={
		-- Gold
		{75,10,0},
		-- HP
		{100,display.contentHeight-180,0},
		-- MP
		{100,display.contentHeight-120,0},
		-- EP
		{100,display.contentHeight-60,0},
		-- Unspent point
		{display.contentWidth-210,display.contentHeight-45},
		-- XP Bar
		{(display.contentWidth/2)+180,27,0},
		-- Quest
		{display.contentWidth-225,40},
		-- Pause Button
		{display.contentWidth-(70/2*1.3),display.contentHeight-(70/2*1.3)},
	}
local defaults={
		-- Gold
		{75,10,0},
		-- HP
		{100,display.contentHeight-180,0},
		-- MP
		{100,display.contentHeight-120,0},
		-- EP
		{100,display.contentHeight-60,0},
		-- Unspent point
		{display.contentWidth-210,display.contentHeight-45},
		-- XP Bar
		{(display.contentWidth/2)+180,27,0},
		-- Quest
		{display.contentWidth-225,40},
		-- Pause Button
		{display.contentWidth-(70/2*1.3),display.contentHeight-(70/2*1.3)},
	}

function Get(element)
	return positions[element+1]
end

function Start()
	Runtime:addEventListener("touch",Moved)
	gsm=display.newGroup()
	window={}
	
	block=display.newImageRect("cblocked.png",653,653)
	block.x=display.contentCenterX
	block.y=display.contentCenterY
	gsm:insert(block)
	
	prevtxt=display.newText("Previous",0,0,"MoolBoran",55)
	prevtxt.x=display.contentCenterX-180
	prevtxt.y=display.contentCenterY+50
	prevtxt:addEventListener("tap",doPrev)
	prevtxt:setTextColor(125,125,250)
	gsm:insert(prevtxt)
	
	resttxt=display.newText("Reset",0,0,"MoolBoran",55)
	resttxt.x=display.contentCenterX
	resttxt.y=display.contentCenterY+50
	resttxt:addEventListener("tap",doReset)
	resttxt:setTextColor(125,125,250)
	gsm:insert(resttxt)
	
	backtxt=display.newText("Back",0,0,"MoolBoran",65)
	backtxt.x=display.contentCenterX
	backtxt.y=display.contentCenterY+200
	backtxt:addEventListener("tap",doBack)
	backtxt:setTextColor(180,180,180)
	gsm:insert(backtxt)
	
	nexttxt=display.newText("Next",0,0,"MoolBoran",55)
	nexttxt.x=display.contentCenterX+180
	nexttxt.y=display.contentCenterY+50
	nexttxt:addEventListener("tap",doNext)
	nexttxt:setTextColor(125,125,250)
	gsm:insert(nexttxt)
	
	for s=1,table.maxn(names) do
		window[s]=display.newImageRect(info[s][1],info[s][2],info[s][3])
		window[s].x=positions[s][1]
		if s>=1 and s<=4 then
			window[s].y=positions[s][2]+30
		else
			window[s].y=positions[s][2]
		end
		if curname~=s then
			window[s]:setFillColor(100,100,100,100)
		end
		gsm:insert(window[s])
	end
	
	Windows()
	
	Interface()
end

function doNext()
	curname=curname+1
	if curname>table.maxn(names) then
		curname=1
	end
	Interface()
end

function doPrev()
	curname=curname-1
	if curname<1 then
		curname=table.maxn(names)
	end
	Interface()
end

function doReset()
	local thex=defaults[curname][1]
	local they=defaults[curname][2]
	local thez=defaults[curname][3]
	positions[curname][1]=thex
	positions[curname][2]=they
	positions[curname][3]=thez
	Windows()
	Interface()
end

function Windows()
	for s=table.maxn(names),1,-1 do	
		display.remove(window[s])
		window[s]=nil
	end
	for s=1,table.maxn(names) do
		window[s]=display.newImageRect(info[s][1],info[s][2],info[s][3])
		window[s].x=positions[s][1]
		if s>=1 and s<=4 then
			window[s].y=positions[s][2]+30
		else
			window[s].y=positions[s][2]
		end
		if curname~=s then
			window[s]:setFillColor(100,100,100,100)
		end
		gsm:insert(window[s])
	end
end

function doBack()
	Runtime:removeEventListener("touch",Moved)
	for i=gsm.numChildren,1,-1 do
		local child = gsm[i]
		child.parent:remove( child )
	end
	Save()
	o.DisplayOptions()
end

function Interface()
	display.remove(selected)
	selected=nil
	display.remove(alwaysV)
	alwaysV=nil
	display.remove(alwaysV2)
	alwaysV2=nil
	display.remove(alwaysV3)
	alwaysV3=nil
	display.remove(snap1)
	snap1=nil
	display.remove(snap2)
	snap2=nil
	display.remove(snap3)
	snap3=nil
	
	selected=display.newText((names[curname]),0,0,"MoolBoran",70)
	selected.x=display.contentCenterX
	selected.y=display.contentCenterY-100
	selected:setTextColor(230,230,230)
	gsm:insert(selected)
	
	if curname==1 or curname==2 or curname==3 or curname==4 or curname==6 then
		alwaysV3=display.newRect(0,0,400,50)
		alwaysV3.x=display.contentCenterX
		alwaysV3.y=display.contentCenterY-60
		alwaysV3:setFillColor(255,255,255,0)
		alwaysV3:addEventListener("tap",doVisible)
		gsm:insert(alwaysV3)
		
	
		alwaysV=display.newText("Always visible?",0,0,"MoolBoran",60)
		alwaysV.x=display.contentCenterX-45
		alwaysV.y=display.contentCenterY-50
		alwaysV:setTextColor(180,180,180)
		gsm:insert(alwaysV)
		
		if positions[curname][3]==0 then
			alwaysV2=display.newText("No",0,0,"MoolBoran",60)
			alwaysV2.x=display.contentCenterX+120
			alwaysV2.y=alwaysV.y
			alwaysV2:setTextColor(255,125,125)
			gsm:insert(alwaysV2)
		else
			alwaysV2=display.newText("Yes",0,0,"MoolBoran",60)
			alwaysV2.x=display.contentCenterX+120
			alwaysV2.y=alwaysV.y
			alwaysV2:setTextColor(125,255,125)
			gsm:insert(alwaysV2)
		end
	end
	
	snap3=display.newRect(0,0,400,50)
	snap3.x=display.contentCenterX
	snap3.y=display.contentCenterY+100
	snap3:setFillColor(255,255,255,0)
	snap3:addEventListener("tap",doSnap)
	gsm:insert(snap3)
	
	snap1=display.newText("Snapping?",0,0,"MoolBoran",60)
	snap1.x=display.contentCenterX-45
	snap1.y=display.contentCenterY+110
	snap1:setTextColor(180,180,180)
	gsm:insert(snap1)
	
	if snap==0 then
		snap2=display.newText("No",0,0,"MoolBoran",60)
		snap2.x=display.contentCenterX+120
		snap2.y=snap1.y
		snap2:setTextColor(255,125,125)
		gsm:insert(snap2)
	else
		snap2=display.newText("Yes",0,0,"MoolBoran",60)
		snap2.x=display.contentCenterX+120
		snap2.y=snap1.y
		snap2:setTextColor(125,255,125)
		gsm:insert(snap2)
	end
	
	for s=1,table.maxn(names) do
		if curname~=s then
			window[s]:setFillColor(100,100,100,100)
		else
			window[s]:setFillColor(255,255,255,255)
		end
	end
	
end

function doVisible()
	if positions[curname][3]==1 then
		positions[curname][3]=0
	else
		positions[curname][3]=1
	end
	Interface()
end

function doSnap()
	if snap==1 then
		snap=0
	else
		snap=1
	end
	Interface()
end

function Moved( event )
	if (window[curname]) then
		if event.y>750 or event.y<350 then
			window[curname].x=event.x
			if snap==1 then
				for s=1,table.maxn(names) do
					if curname~=s then
						if window[curname].x+10>window[s].x and window[curname].x-10<window[s].x then
							window[curname].x=window[s].x
						end
					end
				end
				if window[curname].x+10>display.contentCenterX and window[curname].x-10<display.contentCenterX then
					window[curname].x=display.contentCenterX
				end
			end
			positions[curname][1]=window[curname].x
			local uno=(info[curname][3]/2)
			if event.y+uno<(display.contentCenterY-(610/2)) or event.y-uno>(display.contentCenterY+(610/2)) then
				window[curname].y=event.y
				if curname>=1 and curname<=4 then
					window[curname].y=event.y+30
				else
					window[curname].y=event.y
				end
				if snap==1 then
					for s=1,table.maxn(names) do
						if curname~=s then
							if window[curname].y+10>window[s].y and window[curname].y-10<window[s].y then
								window[curname].y=window[s].y
							end
						end
					end
				end
				if curname>=1 and curname<=4 then
					positions[curname][2]=window[curname].y-30
				else
					positions[curname][2]=window[curname].y
				end
			end
		end
	end	
end

function Load()
	local exists=false
	local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "r" )
	if (fh) then
		exists=true
	end
	if exists==true then
		local Sve={}
		local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
		for line in io.lines( path ) do
			Sve[#Sve+1]=line
		end
		local count=0
		for p=1,table.maxn(positions) do
			for i=1,table.maxn(positions[p]) do
				count=count+1
				positions[p][i]=Sve[count]
			end
		end
	end
end

function Save()
	local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "w+" )
	
	for p=1,table.maxn(positions) do
		for i=1,table.maxn(positions[p]) do
			fh:write(positions[p][i],"\n")
		end
	end
	
	io.close( fh )
end

function WipeSave()
	local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "w+" )
	fh:write("")
	io.close( fh )
end 