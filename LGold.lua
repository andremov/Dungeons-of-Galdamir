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
local a=require("Laudio")
local ui=require("Lui")
local DisplayS=1.25
local GoldCount
local CoinGroup=display.newGroup()
local coins={}
local P1
local GCDisplay
local CDisplay
local DaCoins
local Handbrake
local gShown=true
local gwg
local showncd

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
	a.Play(1)
	P1.gp=P1.gp+amount
end

function GetCoinGroup()
	return  CoinGroup
end

function GoldDisplay()
	if not (gwg) then
		gwg=display.newGroup()
		showncd=1
		
		GWindow = ui.CreateWindow(200,70)
		GWindow.x=display.contentWidth-80
		GWindow.y=145
		gwg:insert(GWindow)
		
		CDisplay=display.newSprite( coinsheet, { name="coin", start=1, count=8, time=750}  )
		CDisplay.anchorX=0
		CDisplay.anchorY=0
		CDisplay.x, CDisplay.y = GWindow.x-80, GWindow.y-20
		CDisplay.xScale=DisplayS
		CDisplay.yScale=DisplayS
		CDisplay:toFront()
		CDisplay:play()
		gwg:insert(CDisplay)
		
		GCDisplay = display.newText( (GoldCount),0,0, "Game Over", 100 )
		GCDisplay.anchorX=0
		GCDisplay.anchorY=0
		GCDisplay.x,GCDisplay.y=CDisplay.x+60,CDisplay.y-10
		GCDisplay:setFillColor( 1, 1, 0.2)
		gwg:insert(GCDisplay)
		
		Runtime:addEventListener("enterFrame",MoveWindow)
	end
end

function MoveWindow()
	if (gwg) then
		local shownx=0
		local hiddenx=200
		if gShown==true and gwg.x~=shownx then
			-- print ("SHOWN; NOT IN POSITION")
			if gwg.x<shownx then
				gwg.x=gwg.x+2
			elseif gwg.x>shownx then
				gwg.x=gwg.x-2
			end
		elseif gShown==true and gwg.x==shownx then
			-- print ("SHOWN; IN POSITION")
			if GoldCount~=P1.gp then
				-- print ("UPDATING COUNT")
				if GoldCount<P1.gp then
					GoldCount=GoldCount+1
				elseif GoldCount>P1.gp then
					GoldCount=GoldCount-1
				end
				GCDisplay.text=(GoldCount)
				
				GCDisplay:setFillColor( 1, 1, 0.20)
				showncd=60
			else
				-- print ("COUNT UPDATED")
				showncd=showncd-1
				if showncd==0 then
					gShown=false
				end
			end
		elseif gShown==false and gwg.x~=hiddenx then
			-- print ("HIDDEN; NOT IN POSITION")
			if gwg.x<hiddenx then
				gwg.x=gwg.x+2
			elseif gwg.x>hiddenx then
				gwg.x=gwg.x-2
			end
		elseif gShown==false and gwg.x==hiddenx and P1.gp~=GoldCount then
			-- print ("HIDDEN; IN POSITION; GP ISNT COUNT")
			gShown=true
		elseif gShown==false and gwg.x==hiddenx then
			-- print ("HIDDEN; IN POSITION; GP IS COUNT")
		end
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

