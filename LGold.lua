-----------------------------------------------------------------------------------------
--
-- Gold.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local coinsheet = graphics.newImageSheet( "coinsprite.png", { width=32, height=32, numFrames=8 } )
local gpsheet = graphics.newImageSheet( "gp.png", { width=40, height=40, numFrames=12 } )
local players = require("Lplayers")
local physics = require "physics"
local ui=require("Lui")
local builder=require("Lmapbuilder")
local DisplayS=2.0
local Displayx=45
local Displayy=30
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
	P1.gp=P1.gp+amount
end

function GetCoinGroup()
	return  CoinGroup
end

function GoldDisplay()
	if not (GCDisplay) then
		transp=0
		GCDisplay = display.newText( (GoldCount), 0, 0, "Game Over", 100 )
		GCDisplay:setTextColor( 255, 255, 50, transp)
		GCDisplay.y = Displayy+10
		GCDisplay.x = Displayx+20
		
		GWindow = display.newRect (0,0,#GCDisplay.text*22,40)
		GWindow:setFillColor( 150, 150, 150,transp/2)
		GWindow.x=GCDisplay.x
		GWindow.y=GCDisplay.y+5
		
		GCDisplay:toFront()
	end
	CDisplayUpdate()
	if (GoldCount<1000) then
		GCDisplay.x = Displayx+60
	else
		GCDisplay.x = Displayx+20
	end
	GCDisplay.text=(GoldCount)
	if GoldCount==P1.gp and Handbrake~=true then
		if transp<20 then
			transp=0
		else
			transp=transp-(255/100)
		end
		display.remove(GWindow)
		GWindow = display.newRect (0,0,#GCDisplay.text*22,40)
		GWindow:setFillColor( 150, 150, 150,transp/2)
		GWindow.x=GCDisplay.x
		GWindow.y=GCDisplay.y+5
		
		GCDisplay:toFront()
		GCDisplay:setTextColor( 255, 255, 50, transp)
		CDisplay:setFillColor( transp, transp, transp, transp)
	else
		if GoldCount<P1.gp then
			GoldCount=GoldCount+1
		elseif GoldCount>P1.gp then
			GoldCount=GoldCount-1
		end
		transp=255
		display.remove(GWindow)
		GWindow = display.newRect (0,0,#GCDisplay.text*22,40)
		GWindow:setFillColor( 150, 150, 150,transp/2)
		GWindow.x=GCDisplay.x
		GWindow.y=GCDisplay.y+5
		
		GCDisplay:toFront()
		GCDisplay:setTextColor( 255, 255, 50, transp)
		CDisplay:setFillColor( transp, transp, transp, transp)
	end
end

function CDisplayUpdate()
	if not (CDisplay) then
		CDisplay=display.newSprite( gpsheet, { name="gp", start=1, count=11, time=500}  )
		CDisplay:setFillColor( 0, 0, 0, 0)
		CDisplay.x, CDisplay.y = Displayx, Displayy
		CDisplay.xScale=DisplayS
		CDisplay.yScale=DisplayS
	end
	if (GoldCount<=1) then
		CDisplay:setFrame(1)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>1) and (GoldCount<=5)then
		CDisplay:setFrame(2)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>5) and (GoldCount<=10)then
		CDisplay:setFrame(3)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>10) and (GoldCount<=20)then
		CDisplay:setFrame(4)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>20) and (GoldCount<=40)then
		CDisplay:setFrame(5)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>40) and (GoldCount<=70)then
		CDisplay:setFrame(6)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>70) and (GoldCount<=100)then
		CDisplay:setFrame(7)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>100) and (GoldCount<=300)then
		CDisplay:setFrame(8)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>300) and (GoldCount<=500)then
		CDisplay:setFrame(9)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>500) and (GoldCount<=1000) then
		CDisplay:setFrame(10)
		CDisplay.x, CDisplay.y = Displayx, Displayy
	elseif (GoldCount>1000) then
		CDisplay:setFrame(11)
		CDisplay.x, CDisplay.y = GCDisplay.x+70, GCDisplay.y
	end
	--CDisplay:toFront()
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
	if DaCoins>10 then
		timer.performWithDelay(1, Coins, 5)
	else
		timer.performWithDelay(1, Coins, (DaCoins))
	end
end

function CleanCounter()
	display.remove(CDisplay)
	CDisplay=nil
	display.remove(GCDisplay)
	GCDisplay=nil
	display.remove(GWindow)
	GWindow=nil
end

