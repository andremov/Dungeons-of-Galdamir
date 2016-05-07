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
local HighCard
local Level
local Life
local GPieces
local Round
local Dthtxt
local floorcount
local profbkg
local proftransp

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
		proftransp=proftransp-(255/50)
		if proftransp<20 then
			proftransp=0
		end
		profbkg:setTextColor(proftransp,proftransp,proftransp,proftransp)
		profbkg2:setTextColor(proftransp,proftransp,proftransp,proftransp)
		timer.performWithDelay(20,FloorSign)
	else
		proftransp=255
		floorcount=display.newGroup()
		profbkg=display.newImageRect("floorcount.png", 600, 250)
		profbkg.xScale=0.5
		profbkg.yScale=profbkg.xScale
		profbkg:setTextColor(proftransp,proftransp,proftransp,proftransp)
		profbkg.x, profbkg.y = display.contentCenterX, display.contentCenterY
		
		local profbkg2=display.newText( (Round), 0, 0, "Game Over", 100 )
		profbkg2:setTextColor(proftransp,proftransp,proftransp,proftransp)
		profbkg2.x, profbkg2.y = profbkg.x, profbkg.y+40
		
		floorcount:insert(profbkg)
		floorcount:insert(profbkg2)
		floorcount:toFront()
		timer.performWithDelay(20,FloorSign)
	end
end

function FloorPort(up)
	if up==true then
		local P1=players.GetPlayer()
		local size=builder.GetLevel(0)
		Round=Round+1
		
		FloorSign()
		
		print ("Floor: " ..Round)
		q.WipeQuest()
		if Round>HighCard then
			HighCard=Round
			local gpgain=Round*((math.sqrt(size)/5)*2)
			if gpgain>(10*math.sqrt(size)) then
				gpgain=(10*math.sqrt(size))
			end
			gp.CallAddCoins(gpgain)
		end
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

	FloorSign()

	--print "Player won."
	print ("Floor: " ..Round)
	q.WipeQuest()
	if Round>HighCard then
		HighCard=Round
		local gpgain=Round*((math.sqrt(size)/5)*2)
		if gpgain>(10*math.sqrt(size)) then
			gpgain=(10*math.sqrt(size))
		end
		gp.CallAddCoins(gpgain)
	end
	su.Startup(false)
	builder.YouShallNowPass(false)
	sav.Save()
end

function Lrn2WinNub()
	local P1=players.GetPlayer()
	Round=Round+1

	FloorSign()
	
	--print "Player went through a Red Portal."
	print ("Floor: " ..Round)
	q.WipeQuest()
	if Round>HighCard then
		HighCard=Round
		local gpgain=Round*((math.sqrt(size)/5)*2)
		if gpgain>(10*math.sqrt(size)) then
			gpgain=(10*math.sqrt(size))
		end
		gp.CallAddCoins(gpgain)
	end
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

