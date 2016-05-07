-----------------------------------------------------------------------------------------
--
-- WinOrDeath.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local builder=require("LMapBuilder")
local players=require("Lplayers")
local m=require("Lmenu")
local mob=require("Lmobai")
local handler=require("LMapHandler")
local mov=require("Lmovement")
local col=require("LTileEvents")
local audio=require("LAudio")
local gp=require("LGold")
local inv=require("Lwindow")
local ui=require("LUI")
local com=require("Lcombat")
local sav=require("LSaving")
local shp=require("LShop")
local q=require("LQuest")
local su=require("LStartup")
local RoundTax=5
local Level
local Life
local GPieces
local Round
local Dthtxt
local floorcount
local profbkg

function Essentials()
	Round=1
end

function RoundChange(val)
	Round=val
end

function FloorSign(normal)
	if normal==true then
		if Round%2==0 then
			if (floorcount) then
				for i=floorcount.numChildren,1,-1 do
					local child = floorcount[i]
					child.parent:remove( child )
				end
				floorcount=nil
			end
			floorcount=display.newGroup()
			profbkg=display.newImageRect("scrollui2.png", 314, 116)
			profbkg.x, profbkg.y = display.contentWidth+157, display.contentHeight/2
			
			local profbkg2=display.newImageRect("floorcount.png", 254, 34)
			profbkg2.x, profbkg2.y = profbkg.x, profbkg.y-20
			
			local profbkg3=display.newText( (Round), 0, 0, "Game Over", 100 )
			profbkg3.x, profbkg3.y = profbkg2.x, profbkg2.y+30
			
			floorcount:insert(profbkg)
			floorcount:insert(profbkg2)
			floorcount:insert(profbkg3)
			floorcount:toFront()
			function Closure3()
				for i=floorcount.numChildren,1,-1 do
					local child = floorcount[i]
					child.parent:remove( child )
				end
				floorcount=nil
			end
			function Closure2()
				if (floorcount) then
					transition.to(floorcount, {time=600, x=floorcount.x+310,transition = easing.inExpo,onComplete=Closure3})
				end
			end
			function Closure1()
				timer.performWithDelay(1500,Closure2)
			end
			if (floorcount) then
				transition.to(floorcount, {time=600, x=floorcount.x-310,transition = easing.inExpo,onComplete=Closure1})
			end
		else
			if (floorcount) then
				for i=floorcount.numChildren,1,-1 do
					local child = floorcount[i]
					child.parent:remove( child )
				end
				floorcount=nil
			end
			floorcount=display.newGroup()
			profbkg=display.newImageRect("scrollui2.png", 314, 116)
			profbkg.x, profbkg.y = -157, display.contentHeight/2
			profbkg.rotation=180
			
			local profbkg2=display.newImageRect("floorcount.png", 254, 34)
			profbkg2.x, profbkg2.y = profbkg.x, profbkg.y-20
			
			local profbkg3=display.newText( (Round), 0, 0, "Game Over", 100 )
			profbkg3.x, profbkg3.y = profbkg2.x, profbkg2.y+30
			
			floorcount:insert(profbkg)
			floorcount:insert(profbkg2)
			floorcount:insert(profbkg3)
			floorcount:toFront()
			function Closure3()
				for i=floorcount.numChildren,1,-1 do
					local child = floorcount[i]
					child.parent:remove( child )
				end
				floorcount=nil
			end
			function Closure2()
				if (floorcount) then
					transition.to(floorcount, {time=600, x=floorcount.x-310,transition = easing.inExpo,onComplete=Closure3})
				end
			end
			function Closure1()
				timer.performWithDelay(1500,Closure2)
			end
			if (floorcount) then
				transition.to(floorcount, {time=600, x=floorcount.x+310,transition = easing.inExpo,onComplete=Closure1})
			end
		end
	else
		if Round%2==0 then
			if (floorcount) then
				for i=floorcount.numChildren,1,-1 do
					local child = floorcount[i]
					child.parent:remove( child )
				end
				floorcount=nil
			end
			floorcount=display.newGroup()
			profbkg=display.newImageRect("scrollui2.png", 314, 116)
			profbkg.x, profbkg.y = display.contentWidth+157, display.contentHeight/2
			
			local profbkg2=display.newImageRect("floorcount.png", 254, 34)
			profbkg2.x, profbkg2.y = profbkg.x, profbkg.y-20
			
			local profbkg3=display.newText( (Round), 0, 0, "Game Over", 100 )
			profbkg3.x, profbkg3.y = profbkg2.x, profbkg2.y+30
			
			floorcount:insert(profbkg)
			floorcount:insert(profbkg2)
			floorcount:insert(profbkg3)
			floorcount:toFront()
			function Closure3()
				for i=floorcount.numChildren,1,-1 do
					local child = floorcount[i]
					child.parent:remove( child )
				end
				floorcount=nil
			end
			function Closure2()
				if (floorcount) then
					transition.to(floorcount, {time=600, x=floorcount.x+310,transition = easing.inExpo,onComplete=Closure3})
				end
			end
			function Closure1()
				timer.performWithDelay(1500,Closure2)
			end
			if (floorcount) then
				transition.to(floorcount, {time=600, x=floorcount.x-310,transition = easing.inExpo,onComplete=Closure1})
			end
		else
			if (floorcount) then
				for i=floorcount.numChildren,1,-1 do
					local child = floorcount[i]
					child.parent:remove( child )
				end
				floorcount=nil
			end
			floorcount=display.newGroup()
			profbkg=display.newImageRect("scrollui2.png", 314, 116)
			profbkg.x, profbkg.y = -157, display.contentHeight/2
			profbkg.rotation=180
			
			local profbkg2=display.newImageRect("floorcount.png", 254, 34)
			profbkg2.x, profbkg2.y = profbkg.x, profbkg.y-20
			
			local profbkg3=display.newText( (Round), 0, 0, "Game Over", 100 )
			profbkg3.x, profbkg3.y = profbkg2.x, profbkg2.y+30
			
			floorcount:insert(profbkg)
			floorcount:insert(profbkg2)
			floorcount:insert(profbkg3)
			floorcount:toFront()
			function Closure3()
				for i=floorcount.numChildren,1,-1 do
					local child = floorcount[i]
					child.parent:remove( child )
				end
				floorcount=nil
			end
			function Closure2()
				if (floorcount) then
					transition.to(floorcount, {time=600, x=floorcount.x-310,transition = easing.inExpo,onComplete=Closure3})
				end
			end
			function Closure1()
				timer.performWithDelay(1500,Closure2)
			end
			if (floorcount) then
				transition.to(floorcount, {time=600, x=floorcount.x+310,transition = easing.inExpo,onComplete=Closure1})
			end
		end
	end
end

function FloorPort(up)
	if up==true then
		local P1=players.GetPlayer()
		local size=builder.GetLevel(0)
		Round=Round+1

		FloorSign(true)
		
		print ("Floor: " ..Round)
		q.WipeQuest()
		local gpgain=Round*((math.sqrt(size)/5)*2)
		if gpgain>(10*math.sqrt(size)) then
			gpgain=(10*math.sqrt(size))
		end
		gp.CallAddCoins(gpgain)
		if Round%(math.ceil(5/(math.sqrt(size)/5)))==0 then
			shp.DisplayShop()
		end
		su.Startup(false)
		builder.YouShallNowPass(false)
		sav.Save()
		
	elseif up==false and Round>1 then
		local P1=players.GetPlayer()
		Round=Round-1
		
		FloorSign()
		
		print ("Floor: " ..Round)
		q.WipeQuest()
		su.Startup(false)
		builder.YouShallNowPass(true)
		sav.Save()
	end
end

function Win()
	local P1=players.GetPlayer()
	local size=builder.GetData(0)
	Round=Round+1

	FloorSign(true)

	--print "Player won."
	print ("Floor: " ..Round)
	q.WipeQuest()
	local gpgain=Round*((math.sqrt(size)/5)*2)
	if gpgain>(10*math.sqrt(size)) then
		gpgain=(10*math.sqrt(size))
	end
	gp.CallAddCoins(gpgain)
	su.Startup(false)
	builder.YouShallNowPass(false)
	sav.Save()
end

function Lrn2WinNub()
	local P1=players.GetPlayer()
	Round=Round+1

	FloorSign(true)
	
	--print "Player went through a Red Portal."
	print ("Floor: " ..Round)
	q.WipeQuest()
	local gpgain=Round*((math.sqrt(size)/5)*2)
	if gpgain>(10*math.sqrt(size)) then
		gpgain=(10*math.sqrt(size))
	end
	gp.CallAddCoins(gpgain)
	su.Startup(false)
	builder.YouShallNowPass(true)
	sav.Save()
end

function Circle()
	return Round
end

function SrsBsns()
	Runtime:removeEventListener("enterFrame", gp.GoldDisplay)
	Runtime:removeEventListener("enterFrame", players.ShowStats)
	print "Player went back to menu."
	ui.CleanSlate()
	local P1=players.GetPlayer()
	q.WipeQuest()
	display.remove(P1)
	players.Statless()
	gp.CleanCounter()
	builder.WipeMap()
	m.ShowMenu()
	m.ReadySetGo()
end

