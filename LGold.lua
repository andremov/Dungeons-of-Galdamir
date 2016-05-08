-----------------------------------------------------------------------------------------
--
-- Gold.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local coinsheet = graphics.newImageSheet( "coinsprite.png", { width=32, height=32, numFrames=8 } )
local players = require("Lplayers")
local physics = require "physics"
local builder=require("Lbuilder")
local set=require("Lsettings")
local a=require("Laudio")
local ui=require("Lui")
local DisplayS=1.25
local Displayx
local Displayy
local alwaysV
local GoldCount
local CoinGroup=display.newGroup()
local coins={}
local P1
local GCDisplay
local CDisplay
local DaCoins
local Handbrake

function Essentials()
	P1=players.GetPlayer()
	GoldCount=0
	local info=set.Get(0)
	Displayx=info[1]
	Displayy=info[2]
	alwaysV=info[3]
end

function Coins()
	coins[#coins+1]=display.newSprite( coinsheet, { name="coin", start=1, count=8, time=500,}  )
	coins[#coins].x=(P1.x+(math.random(-5,5)))
	coins[#coins].y=(P1.y+(math.random(-50,-10)))
	physics.addBody(coins[#coins], "dynamic", { friction=0.5, radius=15.0} )
	coins[#coins]:setLinearVelocity((math.random(-200,200)),-300)
	coins[#coins]:play()
	CoinGroup:insert( coins[#coins] )
	CoinGroup:toFront()
end

function CallAddCoins(amount)
	a.Play(1)
	P1.gp=P1.gp+amount
end

function GetCoinGroup()
	return  CoinGroup
end

function GoldDisplay()
	if not (GCDisplay) then
		if alwaysV==0 then
			transp=0
		else
			transp=255
		end
		
		GCDisplay = display.newText( (GoldCount),0,0, "Game Over", 100 )
		GCDisplay.anchorX=0
		GCDisplay.anchorY=0
		GCDisplay.x=Displayx
		GCDisplay.y=Displayy
		GCDisplay:setFillColor( 255/255, 255/255, 50/255, transp/255)
		
		GWindow = display.newRect (0,0,#GCDisplay.text*23,40)
		GWindow:setFillColor( 150/255, 150/255, 150/255,transp/2/255)
		GWindow.anchorX=0
		GWindow.anchorY=0
		GWindow.y=GCDisplay.y+12.5
		GWindow.x=GCDisplay.x
		
		GCDisplay:toFront()
	end
	if not (CDisplay) then
		CDisplay=display.newSprite( coinsheet, { name="coin", start=1, count=8, time=750}  )
		CDisplay:setFillColor( 0, 0, 0, 0)
		CDisplay.anchorX=0
		CDisplay.anchorY=0
		CDisplay.x, CDisplay.y = GCDisplay.x-50, GCDisplay.y+10
		CDisplay.xScale=DisplayS
		CDisplay.yScale=DisplayS
		CDisplay:toFront()
		CDisplay:play()
	end
	GCDisplay.text=(GoldCount)
	if GoldCount==P1.gp and Handbrake~=true then
		if alwaysV==0 then
			if transp<20 then
				transp=0
			else
				transp=transp-(255/100)
			end
		else
			transp=255
		end
		display.remove(GWindow)
		GWindow = display.newRect (0,0,#GCDisplay.text*23,40)
		GWindow:setFillColor( 150/255, 150/255, 150/255,transp/2/255)
		GWindow.anchorX=0
		GWindow.anchorY=0
		GWindow.x=GCDisplay.x
		GWindow.y=GCDisplay.y+12.5
		
		GCDisplay:toFront()
		CDisplay:toFront()
		GCDisplay:setFillColor( 255/255, 255/255, 50/255, transp/255)
		CDisplay:setFillColor( transp/255, transp/255, transp/255, transp/255)
	else
		if GoldCount<P1.gp then
			GoldCount=GoldCount+1
		elseif GoldCount>P1.gp then
			GoldCount=GoldCount-1
		end
		transp=255
		display.remove(GWindow)
		GWindow = display.newRect (0,0,#GCDisplay.text*23,40)
		GWindow:setFillColor( 150/255, 150/255, 150/255,transp/255/2)
		GWindow.anchorX=0
		GWindow.anchorY=0
		GWindow.x=GCDisplay.x
		GWindow.y=GCDisplay.y+12.5
		
		GCDisplay:toFront()
		CDisplay:toFront()
		GCDisplay:setFillColor( 255/255, 255/255, 50/255, transp/255)
		CDisplay:setFillColor( transp/255, transp/255, transp/255, transp/255)
	end
end

function ShowGCounter()
	if Handbrake==true then
		Handbrake=false
	else
		Handbrake=true
	end
end

function CallCoins(value)
	DaCoins=(math.random(2,5)*(math.ceil(value/2)))
	CallAddCoins(DaCoins)
	timer.performWithDelay(1, Coins, math.random(2,3))
end

function CleanCounter()
	display.remove(CDisplay)
	CDisplay=nil
	display.remove(GCDisplay)
	GCDisplay=nil
	display.remove(GWindow)
	GWindow=nil
end

