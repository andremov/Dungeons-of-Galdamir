-----------------------------------------------------------------------------------------
--
-- Collision.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local healthsheet = graphics.newImageSheet( "healthtwinkle.png", { width=7, height=18, numFrames=14 } )
local manasheet = graphics.newImageSheet( "manatwinkle.png", { width=7, height=18, numFrames=14 } )
local tpsheet = graphics.newImageSheet( "portsprite.png", { width=80, height=80, numFrames=16 } )
local debrimages={"debrissmall1.png", "debrissmall2.png", "debrissmall3.png", "debrismed1.png", "debrismed2.png", "debrislarge1.png","golddebrissmall1.png", "golddebrissmall2.png", "golddebrissmall3.png"}
local rockbreaksheet
local physics = require "physics"
local players=require("Lplayers")
local handler=require("LMapHandler")
local WD=require("LProgress")
local builder=require("LMapBuilder")
local c=require("Lcombat")
local mov=require("Lmovement")
local ui=require("LUI")
local player=require("Lplayers")
local gold=require("LGold")
local audio=require("LAudio")
local item=require("LItems")
local inv=require("Lwindow")
local widget = require "widget"
local debris ={}
local twinkles={}
local killtxt
local portCooldown=0
local cdown=0
local espaciox=80
local espacioy=80
local yinicial=432
local xinicial=304
local GateOpened
local portcd
local portxt
local Dropped

function removeOffscreenItems()
	for i = 1, table.maxn(debris) do
		if (debris[i]) then
			if debris[i].x<-50 or debris[i].x>display.contentWidth+50 or debris[i].y<-50 or debris[i].y>display.contentHeight+50 then
				display.remove(debris[i])
                table.remove( debris, i ) 
 			end
		end
	end
	local gold=gold.GetCoinGroup()
	for i = 1, gold.numChildren do
		if (gold[i]) then
			if gold[i].x<-50 or gold[i].x>display.contentWidth+50 or gold[i].y<-50 or gold[i].y>display.contentHeight+50 then
				gold[i].parent:remove( gold[i] )
				gold[i]=nil
 			end	
		end
	end
end

function onChestCollision()
	local P1=player.GetPlayer()
	local bounds=builder.GetData(2)
	local Chests=builder.GetData(5)
	local Round=WD.Circle()
	for i=1, table.maxn(Chests) do
		if (Chests[i]) then
			if ((i)==(P1.loc)) then
				bounds[i]=1
				display.remove(Chests[i])
				Chests[i]=nil
				gold.CallCoins(Round)
				audio.Play(1)
				Dropped=item.ItemDrop()
				return Dropped
			end
		end
	end
end

function onRockCollision()
	local TSet=handler.GetTiles()
	rockbreaksheet = graphics.newImageSheet( "tiles/"..TSet.."/break.png", { width=80, height=80, numFrames=14 } )
	local P1=player.GetPlayer()
	local Rocks=builder.GetData(6)
	local bounds=builder.GetData(2)
	for i=1, table.maxn(Rocks) do
		if (Rocks[i]) then
			if ((i)==(P1.loc)) and bounds[i]~=1 then
				bounds[i]=1
				local level=builder.GetData(3)
				Rocks[i]:play()
				audio.Play(13)
				--Small
				local somuchdebris=math.random(10,15)
				for i=1, somuchdebris do
					debris[#debris+1]=display.newImage((debrimages[(math.random(1,3))]), 13, 13)
					debris[#debris].xScale=1.3
					debris[#debris].yScale=1.3
					debris[#debris].x=(P1.x+(math.random(-5,5)))
					debris[#debris].y=(P1.y+(math.random(-50,-10)))
					physics.addBody(debris[#debris], "dynamic", { friction=0.5, radius=7.0} )
					debris[#debris]:setLinearVelocity((math.random(-300,300)),-300)
					debris[#debris]:toFront()
				end
				--Medium
				local somuchdebris=math.random(1,5)
				for i=1, somuchdebris do
					debris[#debris+1]=display.newImage((debrimages[(math.random(4,5))]), 28, 40)
					debris[#debris].x=(P1.x+(math.random(-5,5)))
					debris[#debris].y=(P1.y+(math.random(-50,-10)))
					physics.addBody(debris[#debris], "dynamic", { friction=0.5, radius=20.0} )
					debris[#debris]:setLinearVelocity((math.random(-200,200)),-200)
					debris[#debris]:toFront()
				end
				--Large
				local somuchdebris=math.random(1,10)
				if somuchdebris>=9 then
					debris[#debris+1]=display.newImage((debrimages[6]), 52, 72)
					debris[#debris].x=(P1.x+(math.random(-5,5)))
					debris[#debris].y=(P1.y+(math.random(-50,-10)))
					physics.addBody(debris[#debris], "dynamic", { friction=0.5, radius=36.0} )
					debris[#debris]:setLinearVelocity((math.random(-100,100)),-100)
					debris[#debris]:toFront()
				end
				--Gold
				local somuchdebris=math.random(1,100)
				if somuchdebris>=80 then
					local goldgaincount=0
					for i=1,(math.ceil((somuchdebris-79)/2)) do
						debris[#debris+1]=display.newImage((debrimages[(math.random(7,9))]), 13, 13)
						debris[#debris].x=(P1.x+(math.random(-5,5)))
						debris[#debris].y=(P1.y+(math.random(-50,-10)))
						physics.addBody(debris[#debris], "dynamic", { friction=0.5, radius=7.0} )
						debris[#debris]:setLinearVelocity((math.random(-100,100)),-100)
						debris[#debris]:toFront()
						goldgaincount=goldgaincount+(math.random(1,3))
					end
					gold.CallAddCoins(goldgaincount)
				end
			end
		end
	end
end

function onKeyCollision()
	local P1=player.GetPlayer()
	local Key=builder.TheGates("key")
	if (Key) then
		if ((Key.loc)==(P1.loc)) then
			print "Got Key!"
			audio.Play(2)
			
			builder.TheGates("open")
			ui.MapIndicators("KEY")
			
			gum=display.newGroup()
			gum:toFront()
			
			local window=display.newImageRect("usemenu.png", 768, 308)
			window.x,window.y = display.contentWidth/2, 450
			gum:insert( window )
			
			function Backbtn()
				for i=gum.numChildren,1,-1 do
					local child = gum[i]
					child.parent:remove( child )
				end
				gum=nil
				mov.ShowArrows()
			end
			
			local lolname=display.newText( ("Key Get!") ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gum:insert( lolname )
			
			local lolname2=display.newText( "The gate to the next floor is now open." ,0,0,"Game Over",85)
			lolname2:setTextColor( 180, 180, 180)
			lolname2.x=display.contentWidth/2
			lolname2.y=(display.contentHeight/2)-80
			gum:insert( lolname2 )
			
			local backbtn= widget.newButton{
				label="Accept",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = Backbtn}
			backbtn:setReferencePoint( display.CenterReferencePoint )
			backbtn.x = (display.contentWidth/2)
			backbtn.y = (display.contentHeight/2)+30
			gum:insert( backbtn )
			return true
		end
	end
end

function onLavaCollision()
	local P1=player.GetPlayer()
	local LavaBlocks=builder.GetData(4)
	local inCombat=c.InTrouble()
	local isPaused=ui.Paused()
	if inCombat==true or isPaused==true then
	else
		for i=1, table.maxn(LavaBlocks) do
			if (LavaBlocks[i]) then
				if ((i)==(P1.loc)) and (P1.HP~=0)then
					local damage=(math.floor(P1.MaxHP*0.02))
					player.ReduceHP(damage,"Lava")
					timer.performWithDelay(100,onLavaCollision)
				end
			end
		end
	end
end

function LayOnHands()
	local Heal=builder.GetPad(1)
	local P1=player.GetPlayer()	
	local inCombat=c.InTrouble()
	local isPaused=ui.Paused()
	if inCombat==true or isPaused==true then
	else
		if (Heal==P1.loc) then
			if P1.HP<P1.MaxHP then
				twinkles[#twinkles+1]=display.newSprite( healthsheet, { name="twinkle", start=1, count=14, time=1000, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x+(math.random(-30,30))
				twinkles[#twinkles].y=P1.y+(math.random(-30,30))
				twinkles[#twinkles].xScale=2.5
				twinkles[#twinkles].yScale=2.5
				twinkles[#twinkles]:play()
			end
			local heal=(math.floor(P1.MaxHP*0.01))
			players.AddHP(heal)
			for i=1, table.maxn(twinkles) do
				if (twinkles[i]) and (twinkles[i].frame)and (twinkles[i].frame>13) then
					display.remove(twinkles[i])
				end
			end
			timer.performWithDelay(100,LayOnHands)
		end
	end
end

function LayOnFeet()
	local Mana=builder.GetPad(2)
	local P1=player.GetPlayer()
	local inCombat=c.InTrouble()
	local isPaused=ui.Paused()
	if inCombat==true or isPaused==true then
	else
		if (Mana==P1.loc) then
			if P1.MP<P1.MaxMP then
				twinkles[#twinkles+1]=display.newSprite( manasheet, { name="twinkle", start=1, count=14, time=1000, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x+(math.random(-30,30))
				twinkles[#twinkles].y=P1.y+(math.random(-30,30))
				twinkles[#twinkles].xScale=2.5
				twinkles[#twinkles].yScale=2.5
				twinkles[#twinkles]:play()
			end
			local heal=(math.floor(P1.MaxHP*0.01))
			players.AddMP(heal)
			for i=1, table.maxn(twinkles) do
				if (twinkles[i]) and (twinkles[i].frame)and (twinkles[i].frame>13) then
					display.remove(twinkles[i])
				end
			end
			timer.performWithDelay(100,LayOnFeet)
		end
	end
end

function PortCheck()
	local OP=builder.GetPortal(false)
	local BP=builder.GetPortal(true)
	local RP=builder.GetRedP()
	local P1=players.GetPlayer()
	if (OP) and (BP) then
		if (P1) and (OP.loc==P1.loc) and P1.portcd==0 then
			return "OP"
		elseif (P1) and (BP.loc==P1.loc) and P1.portcd==0 then
			return "BP"
		elseif (P1) and (BP.loc~=P1.loc) and (OP.loc~=P1.loc) then
			P1.portcd=P1.portcd-1
			if P1.portcd<=0 then
				P1.portcd=0
			end
			return false
		end
	elseif (P1) and (RP) and (RP.loc==P1.loc) then
		return "RP"
	else
		P1.portcd=P1.portcd-1
		if P1.portcd<=0 then
			P1.portcd=0
		end
		return false
	end
end

function Port()
	local OP=builder.GetPortal(false)
	local BP=builder.GetPortal(true)
	local RP=builder.GetRedP()
	local P1=players.GetPlayer()
	if (RP) then
		if (RP.loc==P1.loc) then
			audio.Play(11)
			function Closure()
				mov.ShowArrows("clean")
			end
			timer.performWithDelay(10,Closure)
			timer.performWithDelay(300,WD.Lrn2WinNub)
		end
	elseif (OP) and (BP) then
		if (P1) and (OP.loc==P1.loc) and P1.portcd==0 then
			function OrangePort()
				twinkles[#twinkles+1]=display.newSprite( tpsheet, { name="twinkle", start=1, count=16, time=300, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x
				twinkles[#twinkles].y=P1.y
				twinkles[#twinkles]:play()
				local map=builder.GetData(3)
				local xchange=OP.x-BP.x
				local ychange=OP.y-BP.y
				map.x=map.x+xchange
				map.y=map.y+ychange
				P1.loc=BP.loc
				P1.portcd=12
				timer.performWithDelay(10,mov.ShowArrows)
			end
			audio.Play(11)
			function Closure()
				mov.ShowArrows("clean")
			end
			timer.performWithDelay(10,Closure)
			timer.performWithDelay(300,OrangePort)
		elseif (P1) and (BP.loc==P1.loc) and P1.portcd==0 then
			function BluePort()
				twinkles[#twinkles+1]=display.newSprite( tpsheet, { name="twinkle", start=1, count=16, time=300, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x
				twinkles[#twinkles].y=P1.y
				twinkles[#twinkles]:play()
				local map=builder.GetData(3)
				local xchange=BP.x-OP.x
				local ychange=BP.y-OP.y
				map.x=map.x+xchange
				map.y=map.y+ychange
				P1.loc=OP.loc
				P1.portcd=12
				timer.performWithDelay(10,mov.ShowArrows)
			end
			audio.Play(11)
			function Closure()
				mov.ShowArrows("clean")
			end
			timer.performWithDelay(10,Closure)
			timer.performWithDelay(300,BluePort)
		end
	end
end

function ShopCheck()
	local ShopGroup=builder.GetData(7)
	local P1=players.GetPlayer()
	for i=1, table.maxn(ShopGroup) do
		if (ShopGroup[i]) and ((i)==(P1.loc)) then
			return true
		end
	end
end
