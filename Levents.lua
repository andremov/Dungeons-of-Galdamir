-----------------------------------------------------------------------------------------
--
-- Collision.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local healthsheet = graphics.newImageSheet( "twinkle1.png", { width=7, height=18, numFrames=14 } )
local manasheet = graphics.newImageSheet( "twinkle2.png", { width=7, height=18, numFrames=14 } )
local energysheet = graphics.newImageSheet( "twinkle3.png", { width=7, height=18, numFrames=14 } )
local tpsheet = graphics.newImageSheet( "portsprite.png", { width=80, height=80, numFrames=16 } )
local debrimages={"debrissmall1.png", "debrissmall2.png", "debrissmall3.png", "debrismed1.png", "debrismed2.png", "debrislarge1.png","golddebrissmall1.png", "golddebrissmall2.png", "golddebrissmall3.png"}
local physics = require "physics"
local players=require("Lplayers")
local handler=require("Ltiles")
local WD=require("Lprogress")
local builder=require("Lbuilder")
local c=require("Lcombat")
local mov=require("Lmoves")
local ui=require("Lui")
local player=require("Lplayers")
local gold=require("Lgold")
local audio=require("Laudio")
local item=require("Litems")
local inv=require("Lwindow")
local mob=require("Lmobai")
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
	for r in pairs(Chests) do
		for l in pairs(Chests[r]) do
			if (l==P1.loc) and (r==P1.room) then
				bounds[l]=1
				display.remove(Chests[r][l])
				Chests[r][l]=nil
				gold.CallCoins(math.ceil(Round/2))
				builder.ModMap(l)
				Dropped=item.ItemDrop()
				return Dropped
			end
		end
	end
end

function onRockCollision()
	local P1=player.GetPlayer()
	local Rocks=builder.GetData(6)
	local bounds=builder.GetData(2)
	for l in pairs(Rocks[P1.room]) do
		if ((l)==(P1.loc)) and bounds[l]~=1 then
			bounds[l]=1
			builder.ModMap(l)
			local stat
			if P1.stats[2]>=Rocks[P1.room][l].req and P1.stats[4]>=Rocks[P1.room][l].req then
				if P1.stats[2]>P1.stats[4] then
					stat=P1.stats[2]
				elseif P1.stats[2]<P1.stats[4] then
					stat=P1.stats[4]
				else
					stat=P1.stats[2]
				end
			elseif P1.stats[2]<Rocks[P1.room][l].req and P1.stats[4]>=Rocks[P1.room][l].req then
				stat=P1.stats[4]
			elseif P1.stats[2]>=Rocks[P1.room][l].req and P1.stats[4]<Rocks[P1.room][l].req then
				stat=P1.stats[2]
			end
			local div=(stat-Rocks[P1.room][l].req)+1
			local enreq=(P1.MaxEP*.05)
			local loss=math.floor(enreq/div)
			display.remove(Rocks[P1.room][l])
			Rocks[P1.room][l]=nil
			if P1.EP>=loss then
				P1.EP=P1.EP-loss
			else
				local nope=math.ceil( (loss-P1.EP)/2 )
				P1.EP=0
				player.ReduceHP(nope,"Energy")
			end
			audio.Play(7)
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

function RockCheck(loc)
	local P1=player.GetPlayer()
	local Rocks=builder.GetData(6)
	local bounds=builder.GetData(2)
	for l in pairs(Rocks[P1.room]) do
		if ((l)==(loc)) and bounds[l]~=1 then
			if P1.stats[2]>=Rocks[P1.room][l].req or P1.stats[4]>=Rocks[P1.room][l].req then
				return 2
			else
				return 1
			end
		end
	end
	return 0
end

function onKeyCollision()
	local P1=player.GetPlayer()
	local bounds=builder.GetData(2)
	local Key=builder.TheGates("key")
	if (Key) then
		if (Key.loc==P1.loc) and ((Key.room)==(P1.room)) then
	--		print "Got Key!"
			audio.Play(2)
			builder.ModMap(Key.loc)
			bounds[Key.loc]=1
			
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
				mov.Visibility()
			end
			
			local lolname=display.newText( ("Key Get!") ,0,0,"MoolBoran",90)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-120
			gum:insert( lolname )
			
			local lolname2=display.newText( "You hear a loud clang in the distance." ,0,0,"MoolBoran",55)
			lolname2:setTextColor( 180, 180, 180)
			lolname2.x=display.contentWidth/2
			lolname2.y=(display.contentHeight/2)-50
			gum:insert( lolname2 )
			
			local backbtn=  widget.newButton{
				label="Accept",
				labelColor = { default={255,255,255}, over={0,0,0} },
				font="MoolBoran",
				fontSize=50,
				labelYOffset=10,
				defaultFile="cbutton.png",
				overFile="cbutton-over.png",
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
	local isLava=false
	if inCombat==true or isPaused==true then
	else
		for l in pairs(LavaBlocks[P1.room]) do
			if ((l)==(P1.loc)) and (P1.HP~=0)then
				isLava=true
			end
		end
	end
	if isLava==true then
		local damage=(math.floor(P1.MaxHP*0.02))
		player.ReduceHP(damage,"Lava")
		lavatimer=timer.performWithDelay(200,onLavaCollision)
	else
		if (lavatimer) then
			local stahp=timer.pause(lavatimer)
			lavatimer=nil
		end
	end
end

function onWaterCollision()
	local P1=player.GetPlayer()
	local WaterBlocks=builder.GetData(9)
	local isWet=false
	for l in pairs(WaterBlocks[P1.room]) do
		if ((l)==(P1.loc)) and (P1.HP~=0)then
			isWet=true
		end
	end
	return isWet
end

function LayOnHands()
	local Heal=builder.GetPad(1)
	local P1=player.GetPlayer()	
	local inCombat=c.InTrouble()
	local isPaused=ui.Paused()
	if inCombat==true or isPaused==true then
	elseif (Heal) then
		if (Heal.loc==P1.loc) and (Heal.room==P1.room) then
			player.SpriteSeq(true)
			if P1.HP<P1.MaxHP then
				twinkles[#twinkles+1]=display.newSprite( healthsheet, { name="twinkle", start=1, count=14, time=1000, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x+(math.random(-30,30))
				twinkles[#twinkles].y=P1.y+(math.random(-30,30))
				twinkles[#twinkles].xScale=2.5
				twinkles[#twinkles].yScale=2.5
				twinkles[#twinkles]:play()
			end
			local heal=(math.ceil(P1.MaxHP*0.01))
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
	local Energy=builder.GetPad(3)
	local P1=player.GetPlayer()
	local inCombat=c.InTrouble()
	local isPaused=ui.Paused()
	if inCombat==true or isPaused==true then
	elseif (Energy) then
		if (Energy.loc==P1.loc) and (Energy.room==P1.room) then
			player.SpriteSeq(true)
			if P1.EP<P1.MaxEP then
				twinkles[#twinkles+1]=display.newSprite( energysheet, { name="twinkle", start=1, count=14, time=1000, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x+(math.random(-30,30))
				twinkles[#twinkles].y=P1.y+(math.random(-30,30))
				twinkles[#twinkles].xScale=2.5
				twinkles[#twinkles].yScale=2.5
				twinkles[#twinkles]:play()
			end
			local heal=(math.ceil(P1.MaxEP*0.01))
			players.AddEP(heal)
			for i=1, table.maxn(twinkles) do
				if (twinkles[i]) and (twinkles[i].frame)and (twinkles[i].frame>13) then
					display.remove(twinkles[i])
				end
			end
			timer.performWithDelay(100,LayOnFeet)
		end
	end
end

function LayOnHead()
	local Mana=builder.GetPad(2)
	local P1=player.GetPlayer()
	local inCombat=c.InTrouble()
	local isPaused=ui.Paused()
	if inCombat==true or isPaused==true then
	elseif (Mana) then
		if (Mana.loc==P1.loc) and (Mana.room==P1.room) then
			player.SpriteSeq(true)
			if P1.MP<P1.MaxMP then
				twinkles[#twinkles+1]=display.newSprite( manasheet, { name="twinkle", start=1, count=14, time=1000, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x+(math.random(-30,30))
				twinkles[#twinkles].y=P1.y+(math.random(-30,30))
				twinkles[#twinkles].xScale=2.5
				twinkles[#twinkles].yScale=2.5
				twinkles[#twinkles]:play()
			end
			local heal=(math.ceil(P1.MaxMP*0.01))
			players.AddMP(heal)
			for i=1, table.maxn(twinkles) do
				if (twinkles[i]) and (twinkles[i].frame)and (twinkles[i].frame>13) then
					display.remove(twinkles[i])
				end
			end
			timer.performWithDelay(100,LayOnHead)
		end
	end
end

function PortCheck()
	local OP=builder.GetPortal(1)
	local RP=builder.GetPortal(2)
	local BP=builder.GetPortal(3)
	local DP=builder.GetPortal(4)
	local P1=players.GetPlayer()
	local info=false
	if (OP) and (RP) then
		if (P1) and (OP.loc==P1.loc) and (OP.room==P1.room) then
			if P1.portcd==0 then
				local check=mob.LocationCheck(RP.loc,RP.room)
				if check==false then
					info="OP"
				else
					info="OPB"
				end
			else
				info="OPB"
			end
		elseif (P1) and (RP.loc==P1.loc) and (RP.room==P1.room) then
			if P1.portcd==0 then
				local check=mob.LocationCheck(OP.loc,OP.room)
				if check==false then
					info="RP"
				else
					info="RPB"
				end
			else
				info="RPB"
			end
		elseif (P1) then
			P1.portcd=P1.portcd-1
			if P1.portcd<=0 then
				P1.portcd=0
			end
		end
	else
		P1.portcd=P1.portcd-1
		if P1.portcd<=0 then
			P1.portcd=0
		end
	end
	if (BP) and (DP) then
		if (P1) and (BP.loc==P1.loc) and (BP.room==P1.room) then
			if P1.portcd==0 then
				local check=mob.LocationCheck(DP.loc,DP.room)
				if check==false then
					info="BP"
				else
					info="BPB"
				end
			else
				info="BPB"
			end
		elseif (P1) and (DP.loc==P1.loc) and (DP.room==P1.room) then
			if P1.portcd==0 then
				local check=mob.LocationCheck(BP.loc,BP.room)
				if check==false then
					info="DP"
				else
					info="DPB"
				end
			else
				info="DPB"
			end
		elseif (P1) then
			P1.portcd=P1.portcd-1
			if P1.portcd<=0 then
				P1.portcd=0
			end
		end
	else
		P1.portcd=P1.portcd-1
		if P1.portcd<=0 then
			P1.portcd=0
		end
	end
	return info
end

function Port()
	local OP=builder.GetPortal(1)
	local RP=builder.GetPortal(2)
	local BP=builder.GetPortal(3)
	local DP=builder.GetPortal(4)
	local P1=players.GetPlayer()
	local map=builder.GetData(3)
	local msize=builder.GetData(0)
	local boundary=builder.GetData(1)
	local walls=builder.GetData()
	local manacost=math.floor(P1.weight/15)
	if (OP) and (RP) then
		if (P1) and (OP.loc==P1.loc) and P1.portcd==0 then
			function OrangePort()
				twinkles[#twinkles+1]=display.newSprite( tpsheet, { name="twinkle", start=1, count=16, time=300, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x
				twinkles[#twinkles].y=P1.y
				twinkles[#twinkles]:play()
				if P1.MP>=manacost then
					P1.MP=P1.MP-manacost
					local xchange=OP.x-RP.x
					local ychange=OP.y-RP.y
					map.x=map.x+xchange
					map.y=map.y+ychange
					P1.loc=RP.loc
					P1.room=RP.room
					P1.portcd=12
					timer.performWithDelay(100,mov.Visibility)
				else
					local deficit=manacost-P1.MP
					players.ReduceHP(deficit*2,"Portal")
					P1.MP=0
					if P1.HP>0 then
					--	local chosentile=math.random(1,msize)
						local chosentile=1
						if boundary[chosentile]==1 then
							local xchange=walls[chosentile].x-RP.x
							local ychange=RP.y-(walls[chosentile].y)
							map.x=map.x+xchange
							map.y=map.y+ychange
							P1.loc=chosentile
							P1.portcd=12
							timer.performWithDelay(100,mov.Visibility)
						else
							local xchange=OP.x-RP.x
							local ychange=OP.y-RP.y
							map.x=map.x+xchange
							map.y=map.y+ychange
							P1.loc=RP.loc
							P1.room=RP.room
							P1.portcd=12
							timer.performWithDelay(100,mov.Visibility)
						end
					end
				end
			end
			audio.Play(6)
			function Closure()
				mov.CleanArrows()
			end
			timer.performWithDelay(10,Closure)
			timer.performWithDelay(300,OrangePort)
		elseif (P1) and (RP.loc==P1.loc) and P1.portcd==0 then
			function RedPort()
				twinkles[#twinkles+1]=display.newSprite( tpsheet, { name="twinkle", start=1, count=16, time=300, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x
				twinkles[#twinkles].y=P1.y
				twinkles[#twinkles]:play()
				if P1.MP>=manacost then
					P1.MP=P1.MP-manacost
					local xchange=RP.x-OP.x
					local ychange=RP.y-OP.y
					map.x=map.x+xchange
					map.y=map.y+ychange
					P1.loc=OP.loc
					P1.room=OP.room
					P1.portcd=12
					timer.performWithDelay(100,mov.Visibility)
				else
					local deficit=manacost-P1.MP
					players.ReduceHP(deficit*2,"Portal")
					P1.MP=0
					if P1.HP>0 then
					--	local chosentile=math.random(1,msize)
						local chosentile=1
						if boundary[chosentile]==1 then
							local xchange=walls[chosentile].x-OP.x
							local ychange=OP.y-walls[chosentile].y
							map.x=map.x+xchange
							map.y=map.y+ychange
							P1.loc=chosentile
							P1.portcd=12
							timer.performWithDelay(100,mov.Visibility)
						else
							local map=builder.GetData(3)
							local xchange=RP.x-OP.x
							local ychange=RP.y-OP.y
							map.x=map.x+xchange
							map.y=map.y+ychange
							P1.loc=OP.loc
							P1.room=OP.room
							P1.portcd=12
							timer.performWithDelay(100,mov.Visibility)
						end
					end
				end
			end
			audio.Play(6)
			function Closure()
				mov.CleanArrows()
			end
			timer.performWithDelay(10,Closure)
			timer.performWithDelay(300,RedPort)
		end
	end
	if (BP) and (DP) then
		if (P1) and (BP.loc==P1.loc) and P1.portcd==0 then
			function BluePort()
				twinkles[#twinkles+1]=display.newSprite( tpsheet, { name="twinkle", start=1, count=16, time=300, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x
				twinkles[#twinkles].y=P1.y
				twinkles[#twinkles]:play()
				if P1.MP>=manacost then
					P1.MP=P1.MP-manacost
					local xchange=BP.x-DP.x
					local ychange=BP.y-DP.y
					map.x=map.x+xchange
					map.y=map.y+ychange
					P1.loc=DP.loc
					P1.room=DP.room
					P1.portcd=12
					timer.performWithDelay(100,mov.Visibility)
				else
					local deficit=manacost-P1.MP
					players.ReduceHP(deficit*2,"Portal")
					P1.MP=0
					if P1.HP>0 then
					--	local chosentile=math.random(1,msize)
						local chosentile=1
						if boundary[chosentile]==1 then
							local xchange=walls[chosentile].x-DP.x
							local ychange=DP.y-walls[chosentile].y
							map.x=map.x+xchange
							map.y=map.y+ychange
							P1.loc=chosentile
							P1.portcd=12
							timer.performWithDelay(100,mov.Visibility)
						else
							local xchange=BP.x-DP.x
							local ychange=BP.y-DP.y
							map.x=map.x+xchange
							map.y=map.y+ychange
							P1.loc=DP.loc
							P1.room=DP.room
							P1.portcd=12
							timer.performWithDelay(100,mov.Visibility)
						end
					end
				end
			end
			audio.Play(6)
			function Closure()
				mov.CleanArrows()
			end
			timer.performWithDelay(10,Closure)
			timer.performWithDelay(300,BluePort)
		elseif (P1) and (DP.loc==P1.loc) and P1.portcd==0 then
			function DarkPort()
				twinkles[#twinkles+1]=display.newSprite( tpsheet, { name="twinkle", start=1, count=16, time=300, loopCount=1 }  )
				twinkles[#twinkles].x=P1.x
				twinkles[#twinkles].y=P1.y
				twinkles[#twinkles]:play()
				if P1.MP>=manacost then
					P1.MP=P1.MP-manacost
					local xchange=DP.x-BP.x
					local ychange=DP.y-BP.y
					map.x=map.x+xchange
					map.y=map.y+ychange
					P1.loc=BP.loc
					P1.room=BP.room
					P1.portcd=12
					timer.performWithDelay(100,mov.Visibility)
				else
					local deficit=manacost-P1.MP
					players.ReduceHP(deficit*2,"Portal")
					P1.MP=0
					if P1.HP>0 then
					--	local chosentile=math.random(1,msize)
						local chosentile=1
						if boundary[chosentile]==1 then
							local xchange=walls[chosentile].x-BP.x
							local ychange=BP.y-walls[chosentile].y
							map.x=map.x+xchange
							map.y=map.y+ychange
							P1.loc=chosentile
							P1.portcd=12
							timer.performWithDelay(100,mov.Visibility)
						else
							local map=builder.GetData(3)
							local xchange=DP.x-BP.x
							local ychange=DP.y-BP.y
							map.x=map.x+xchange
							map.y=map.y+ychange
							P1.loc=BP.loc
							P1.room=BP.room
							P1.portcd=12
							timer.performWithDelay(100,mov.Visibility)
						end
					end
				end
			end
			audio.Play(6)
			function Closure()
				mov.CleanArrows()
			end
			timer.performWithDelay(10,Closure)
			timer.performWithDelay(300,DarkPort)
		end
	end
end

function ShopCheck()
	local ShopGroup=builder.GetData(7)
	local P1=players.GetPlayer()
	for r in pairs(ShopGroup) do
		for l in pairs(ShopGroup[r]) do
			if ((l)==(P1.loc)) and ((r)==(P1.room)) then
				return true
			end
		end
	end
end

function SpawnerCheck()
	local MS=builder.GetMSpawner()
	local P1=players.GetPlayer()
	local info=false
	if (MS) then
		if (P1) and (MS.loc==P1.loc) and (MS.room==P1.room) and (MS.cd==0) and (P1.stats[4]>=MS.req) then
			info=true
		end
	end
	return info
end