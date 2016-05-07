-----------------------------------------------------------------------------------------
--
-- WinOrDeath.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local builder=require("Lmapbuilder")
local players=require("Lplayers")
local m=require("Lmenu")
local mob=require("Lmobai")
local handler=require("Lmaphandler")
local mov=require("Lmovement")
local col=require("Ltileevents")
local audio=require("Laudio")
local gp=require("Lgold")
local inv=require("Lwindow")
local ui=require("Lui")
local com=require("Lcombat")
local sav=require("Lsaving")
local shp=require("Lshop")
local q=require("Lquest")
local su=require("Lstartup")
local RoundTax=5
local HighCard
local Level
local Life
local GPieces
local Round
local Dthtxt
local floorcount

function Essentials()
	Round=1
	HighCard=1
end

function RoundChange(val)
	Round=val
	HighCard=val
end

function FloorSign()
	if (floorcount) and proftransp==0 then
		for i=floorcount.numChildren,1,-1 do
			local child = floorcount[i]
			child.parent:remove( child )
		end
		floorcount=nil
	elseif (floorcount) and proftransp~=0 then
		proftransp=proftransp-(255/100)
		if proftransp<20 then
			proftransp=0
		end
		profbkg:setFillColor(proftransp,proftransp,proftransp,proftransp)
		profbkg2:setTextColor(0,0,0,proftransp)
		floorcount:toFront()
		timer.performWithDelay(20,FloorSign)
	else
		proftransp=255
		floorcount=display.newGroup()
		profbkg=display.newImageRect("floorcount.png", 600, 250)
		profbkg.xScale=0.5
		profbkg.yScale=profbkg.xScale
		profbkg:setFillColor(proftransp,proftransp,proftransp,proftransp)
		profbkg.x, profbkg.y = display.contentCenterX, display.contentCenterY-200
		
		profbkg2=display.newText( (Round), 0, 0, "Game Over", 100 )
		profbkg2:setTextColor(0,0,0,proftransp)
		profbkg2.x, profbkg2.y = profbkg.x, profbkg.y+20
		
		floorcount:insert(profbkg)
		floorcount:insert(profbkg2)
		floorcount:toFront()
		timer.performWithDelay(4000,FloorSign)
	end
end

function FloorPort(up)
	if up==true then
		local P1=players.GetPlayer()
		local size=builder.GetData(0)
		Round=Round+1
		
		FloorSign()
		
	--	print ("Floor: " ..Round)
		q.WipeQuest()
		if Round>HighCard then
			HighCard=Round
			local gpgain=Round*((math.sqrt(size)/5)*2)
			if gpgain>(5*math.sqrt(size)) then
				gpgain=(5*math.sqrt(size))
			end
			gp.CallAddCoins(gpgain)
		end
		su.Startup(false)
		builder.Rebuild(false)
		sav.Save()
		
	elseif up==false and Round>1 then
		local P1=players.GetPlayer()
		Round=Round-1
		
		FloorSign()
		
	--	print ("Floor: " ..Round)
		q.WipeQuest()
		su.Startup(false)
		builder.Rebuild(true)
		sav.Save()
	end
end

function Win()
	local P1=players.GetPlayer()
	local size=builder.GetData(0)
	Round=Round+1

	FloorSign()

--	print "Player won."
--	print ("Floor: " ..Round)
	q.WipeQuest()
	if Round>HighCard then
		HighCard=Round
		local gpgain=Round*((math.sqrt(size)/5)*2)
		if gpgain>(5*math.sqrt(size)) then
			gpgain=(5*math.sqrt(size))
		end
		gp.CallAddCoins(gpgain)
	end
	su.Startup(false)
	builder.Rebuild(false)
	sav.Save()
end

function Lrn2WinNub()
	local P1=players.GetPlayer()
	local size=builder.GetData(0)
	Round=Round+1

	FloorSign()
	
--	print "Player went through a Red Portal."
--	print ("Floor: " ..Round)
	q.WipeQuest()
	if Round>HighCard then
		HighCard=Round
		local gpgain=Round*((math.sqrt(size)/5)*2)
		if gpgain>(5*math.sqrt(size)) then
			gpgain=(5*math.sqrt(size))
		end
		gp.CallAddCoins(gpgain)
	end
	su.Startup(false)
	builder.Rebuild(false)
	sav.Save()
end

function Circle()
	return Round
end

function SrsBsns()
	Runtime:removeEventListener("enterFrame", gp.GoldDisplay)
	Runtime:removeEventListener("enterFrame", players.ShowStats)
--	print "Player went back to menu."
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

