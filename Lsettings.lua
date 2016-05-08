-----------------------------------------------------------------------------------------
--
-- settings.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local o=require("Loptions")
local gsm
local curname=1
local names={
		"Gold Counter","Health Display","Mana Display",
		"Energy Display","Stat Points Notice","Experience Bar",
		"Quest Log","Pause Button"
	}
local info={
		-- Gold
		{"demowindow.png",140,50},
		-- HP
		{"demowindow.png",140,50},
		-- MP
		{"demowindow.png",140,50},
		-- EP
		{"demowindow.png",140,50},
		-- Unspent point
		{"unspent.png",240,80},
		-- XP Bar
		{"demoxp.png",392,40},
		-- Quest
		{"demoquest.png",447,80},
		-- Pause Button
		{"pauseon.png",50,50},
	}
local positions={
		-- Gold
		{75,10,0},
		-- HP
		{160,display.contentHeight-175,0},
		-- MP
		{160,display.contentHeight-115,0},
		-- EP
		{160,display.contentHeight-55,0},
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
		{160,display.contentHeight-175,0},
		-- MP
		{160,display.contentHeight-115,0},
		-- EP
		{160,display.contentHeight-55,0},
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
	
	local exists=false
	local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "r" )
	if (fh) then
		exists=true
	end
	if exists==true then
		Load()
	end
	
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
	positions[curname]=defaults[curname]
	Interface()
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
	display.remove(window)
	window=nil
	
	selected=display.newText((names[curname]),0,0,"MoolBoran",70)
	selected.x=display.contentCenterX
	selected.y=display.contentCenterY-100
	selected:setTextColor(230,230,230)
	gsm:insert(selected)
	
	window=display.newImageRect(info[curname][1],info[curname][2],info[curname][3])
	window.x=positions[curname][1]
	if curname>=1 and curname<=4 then
		window.y=positions[curname][2]+20
	else
		window.y=positions[curname][2]
	end
	gsm:insert(window)
	
end

function Moved( event )
	if (window) then
	--	print (event.x..","..event.y)
		if event.y>750 or event.y<350 then
			window.x=event.x
			positions[curname][1]=event.x
			if event.y+(info[curname][3]/2)<(display.contentCenterY-(653/2)) or event.y-(info[curname][3]/2)>(display.contentCenterY+(653/2)) then
				window.y=event.y
				if curname>=1 and curname<=4 then
					window.y=event.y+20
				else
					window.y=event.y
				end
				positions[curname][2]=event.y
			end
		end
	end	
end

function Load()
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