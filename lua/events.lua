---------------------------------------------------------------------------------------
--
-- events.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)
local healthsheet = graphics.newImageSheet( "twinkle1.png", { width=7, height=18, numFrames=14 } )
local manasheet = graphics.newImageSheet( "twinkle2.png", { width=7, height=18, numFrames=14 } )
local energysheet = graphics.newImageSheet( "twinkle3.png", { width=7, height=18, numFrames=14 } )
local tpsheet = graphics.newImageSheet( "portsprite.png", { width=80, height=80, numFrames=16 } )
local coinsheet = graphics.newImageSheet("coinsprite.png", { width=32, height=32, numFrames=8 } )
coseqs={{ name="stand", start=1, count=8, time=1000 }}
local debrimages={"debrissmall1.png", "debrissmall2.png", "debrissmall3.png", 
					"debrismed1.png", "debrismed2.png"
				}
local physics = require "physics"
local widget = require "widget"
local CBE = require("CBEffects.Library")
local builder=require("Lbuilder")
local players=require("Lplayer")
local item=require("Litems")
local ui=require("Lui")
local PFX=display.newGroup()
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
local interactcd=0
local iwg	
local watertiles=0
local lavatiles=0
local drops={}
local vents={}
local tilevents={}

function getparticles()
	return PFX
end

function removeOffscreenItems()
	for i = 1, table.maxn(debris) do
		if (debris[i]) then
			if debris[i].x<-50 or debris[i].x>display.contentWidth+50 or debris[i].y<-50 or debris[i].y>display.contentHeight+50 then
				display.remove(debris[i])
                table.remove( debris, i ) 
 			end
		end
	end
	-- local gold=gold.GetCoinGroup()
	-- for i = 1, gold.numChildren do
		-- if (gold[i]) then
			-- if gold[i].x<-50 or gold[i].x>display.contentWidth+50 or gold[i].y<-50 or gold[i].y>display.contentHeight+50 then
				-- gold[i].parent:remove( gold[i] )
				-- gold[i]=nil
 			-- end	
		-- end
	-- end
end

function Interact( event )
	local specials=builder.getData(1)
	local p1=players.GetPlayer()
	if specials[event.id] then
	
		ExtraFX(specials[event.id].type,event.phase,event.other)
		
		if	event.other==p1.shadow then
			
			if (specials[event.id].interacts==true) then
				if event.phase=="began" then
					interactUI(1, specials[event.id])
				elseif event.phase=="ended" then
					interactUI(-1, specials[event.id])
				end
			end
		
			if specials[event.id].type=="chest" and specials[event.id].sequence=="closed" then
			
				specials[event.id]:setSequence("open")
				doDrops(specials[event.id].x,specials[event.id].y)
				
			elseif specials[event.id].type=="breaks" then
			
				onRockCollision(specials[event.id].x,specials[event.id].y)
				display.remove(specials[event.id])
				specials[event.id]=nil
				
			elseif specials[event.id].type=="door" then
			
				display.remove(specials[event.id])
				specials[event.id]=nil
				
			end
		end
	end
end

function interactUI( change, tile )
	local p1=players.GetPlayer()
	interactcd=interactcd+change
	if interactcd==0 then
		if (iwg) then
			for i=iwg.numChildren,1,-1 do
				display.remove(iwg[i])
				iwg[i]=nil
			end
			iwg=nil
		end
	else
		if (iwg) then
			for i=iwg.numChildren,1,-1 do
				display.remove(iwg[i])
				iwg[i]=nil
			end
			iwg=nil
		end
		
		if not (iwg) then
			iwg=display.newGroup()
			
			frame=display.newImageRect("ui/qteframe.png",576,96)
			frame.x=display.contentCenterX
			frame.y=display.contentHeight-340
			iwg:insert(frame)
			
			if tile.type=="portal" then
				if p1.portcd==0 then
					button=display.newImageRect( ("ui/interact".. 3+tile.color ..".png") ,80,80)
					function closure()
						Port( tile )
					end
					button:addEventListener("tap",closure)
				else
					button=display.newImageRect( ("ui/interact".. 3+tile.color .."B.png") ,80,80)
				end
			end
				button.x=frame.x
				button.y=frame.y
				button.xScale=1.5
				button.yScale=button.xScale
				iwg:insert(button)
		end
	end
end

function ExtraFX(tiletype,phase,obj)
	local P1=player.GetPlayer()
	if obj.name=="coinshadow" and phase=="began" then
		if (vents[obj.id]) then
			vents[obj.id]:stop()
			vents[obj.id]:destroy()
			vents[obj.id] = nil
		end
		if tiletype=="water" then
			vents[obj.id] = CBE.newVent({
				x=obj.x,
				y=obj.y,
				color={ 0.25,0.25,0.75},
				isActive=0,
				scaleX=0.5,
				scaleY=0.5,
				perEmit=4,
				parentGroup=PFX,
				build = function()
					local size = math.random(10, 15)
					return display.newRect(0,0, size, size)
				end,
				onUpdate = function(particle, vent)
					
					vent.isActive=vent.isActive-1
					if vent.isActive<=0 then
						vent.isActive=20
					end
					if vent.isActive==20 then
						vent:stop()
					elseif vent.isActive==10 then
						vent:start()
					end
					particle:setVelocity(0, ((particle.y-20) - particle.y) * 0.03)
					
				end,
			})
			vents[obj.id]:start()
		end
		if tiletype=="lava" then
			vents[obj.id] = CBE.newVent({
				x=obj.x,
				y=obj.y,
				color={ 1,0,0},
				isActive=0,
				scaleX=0.5,
				scaleY=0.5,
				perEmit=1,
				parentGroup=PFX,
				build = function()
					local size = math.random(10, 15)
					return display.newRect(0,0, size, size)
				end,
				onUpdate = function(particle, vent)
					if vent.isActive==50 then
						vent:stop()
					elseif vent.isActive==3 then
						vent:start()
					end
					particle:setVelocity(0, ((particle.y-10) - particle.y) * 0.01)
				end,
			})
			vents[obj.id]:start()
		end
		if tiletype=="portal" then
			vents[obj.id] = CBE.newVent({
				x=obj.x,
				y=obj.x,
				color={ 0.75,0.25,0.75,0.5},
				isActive=0,
				scaleX=0.5,
				scaleY=0.5,
				perEmit=1,
				parentGroup=PFX,
				radius = display.contentCenterX * 0.5,
				innerRadius = display.contentCenterX * 0.48,
				build = function()
					local size = math.random(10, 15)
					return display.newRect(0,0, size, size)
				end,
				onCreation = function(p, vent)
					p:setVelocity((vent.x - p.x) * 0.05, (vent.y - p.y) * 0.05)
				end,
			})
			vents[obj.id]:start()
		end
	elseif obj==P1.shadow then
		if phase=="ended" then
			-- amountoftiles=amountoftiles-1
			if tiletype=="water" then
				watertiles=watertiles-1
			elseif tiletype=="lava" then
				lavatiles=lavatiles-1
			end
			if watertiles==0 and lavatiles==0 and (playervent) then
				playervent:stop()
				playervent:destroy()
				playervent = nil
			end
		elseif phase=="began" then
			if (playervent) then
				playervent:stop()
				playervent:destroy()
				playervent = nil
			end
			if tiletype=="water" then
				watertiles=watertiles+1
				playervent = CBE.newVent({
					x=P1.x,
					y=P1.y+40,
					color={ 0.25,0.25,0.75},
					isActive=0,
					scaleX=0.5,
					scaleY=0.5,
					perEmit=4,
					parentGroup=PFX,
					build = function()
						local size = math.random(10, 15)
						return display.newRect(0,0, size, size)
					end,
					onUpdate = function(particle, vent)
						vent.x=P1.x
						vent.y=P1.y+40
						
						vent.isActive=vent.isActive-1
						if vent.isActive<=0 then
							vent.isActive=20
						end
						if vent.isActive==20 then
							playervent:stop()
						elseif vent.isActive==10 then
							playervent:start()
						end
						particle:setVelocity(0, ((particle.y-20) - particle.y) * 0.03)
						
					end,
				})
				playervent.ttype=tiletype
				playervent:start()
			end
			if tiletype=="lava" then
				lavatiles=lavatiles+1
				playervent = CBE.newVent({
					x=P1.x,
					y=P1.y+40,
					color={ 1,0,0},
					isActive=0,
					scaleX=0.5,
					scaleY=0.5,
					perEmit=1,
					parentGroup=PFX,
					build = function()
						local size = math.random(10, 15)
						return display.newRect(0,0, size, size)
					end,
					onUpdate = function(particle, vent)
						vent.x=P1.x
						vent.y=P1.y+40
						
						vent.isActive=vent.isActive-1
						if vent.isActive<=0 then
							vent.isActive=100
							vent.healthCD=vent.healthCD-1
							if vent.healthCD==0 then
								vent.healthCD=5
								player.ReduceHP(1,"Lava")
							end
						end
						if vent.isActive==50 then
							playervent:stop()
						elseif vent.isActive==3 then
							playervent:start()
						end
						particle:setVelocity(0, ((particle.y-10) - particle.y) * 0.01)
					end,
				})
				playervent.ttype=tiletype
				playervent.healthCD=5
				playervent:start()
			end
			if tiletype=="portal" then
				playervent = CBE.newVent({
					x=P1.x,
					y=P1.y+40,
					color={ 0.75,0.25,0.75,0.5},
					isActive=0,
					scaleX=0.5,
					scaleY=0.5,
					perEmit=1,
					parentGroup=PFX,
					radius = display.contentCenterX * 0.5,
					innerRadius = display.contentCenterX * 0.48,
					build = function()
						local size = math.random(10, 15)
						return display.newRect(0,0, size, size)
					end,
					onCreation = function(p, vent)
						p:setVelocity((vent.x - p.x) * 0.05, (vent.y - p.y) * 0.05)
					end,
					onUpdate = function(particle, vent)
						vent.x=P1.x
						vent.y=P1.y+40
					end,
				})
				playervent.ttype=tiletype
				playervent:start()
			end
		end
		P1.speed=1.00+(0.75*watertiles)+(1.25*lavatiles)
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

function onRockCollision(ex,ey)
	local v=table.maxn(tilevents)+1
	tilevents[v] = CBE.newVent({
		x=ex,
		y=ey,
		isActive=math.random(50,100),
		scaleX=1.5,
		scaleY=1.5,
		perEmit=1,
		parentGroup=PFX,
		build = function()
			local rock=math.random(1,10)
			if rock>9 then
				rock=math.random(4,5)
				sizex=28
				sizey=40
			else
				rock=math.random(1,3)
				sizex=13
				sizey=13
			end
			return display.newImageRect( debrimages[rock], sizex, 	sizey )
		end,
		onCreation = function(p, vent)
			p.xScale,p.yScale=2.0,2.0
			physics.addBody(p,"dynamic",{isSensor=true, radius=8, bounce=0.0})
			p:setVelocity( (p.x*((math.random(0,6)-3)/10) )*0.005, (p.x*((math.random(0,6)-3)/10))*0.005)
		end,
		onUpdate = function(particle, vent)
			vent.isActive=vent.isActive-1
			if vent.isActive<=0 then
				vent:stop()
			end
		end,
	})
	tilevents[v]:start()
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
			
			local window=display.newImageRect("ui/usemenu.png", 768, 308)
			window.x,window.y = display.contentWidth/2, 450
			gum:insert( window )
			
			function Backbtn()
				for i=gum.numChildren,1,-1 do
					local child = gum[i]
					child.parent:remove( child )
				end
				gum=nil
				-- mov.Visibility()
			end
			
			local lolname=display.newText( ("Key Get!") ,0,0,"MoolBoran",90)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-120
			gum:insert( lolname )
			
			local lolname2=display.newText( "You hear a loud clang in the distance." ,0,0,"MoolBoran",55)
			lolname2:setFillColor( 0.7, 0.7, 0.7)
			lolname2.x=display.contentWidth/2
			lolname2.y=(display.contentHeight/2)-50
			gum:insert( lolname2 )
			
			local backbtn=  widget.newButton{
				label="Accept",
				labelColor = { default={255,255,255}, over={0,0,0} },
				font="MoolBoran",
				fontSize=50,
				labelYOffset=10,
				defaultFile="ui/cbutton.png",
				overFile="ui/cbutton-over.png",
				width=200, height=55,
				onRelease = Backbtn}
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
	local isPaused=ui.isBusy()
	local isLava=false
	if isPaused==true then
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
	local isPaused=ui.isBusy()
	if isPaused==true then
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
	local isPaused=ui.isBusy()
	if isPaused==true then
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
	local isPaused=ui.isBusy()
	if isPaused==true then
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

function Port( tile )
	local p1=players.GetPlayer()
	local map=builder.getData(0)
	local msize=table.maxn(map)
	local manacost=math.floor(p1.weight/15)
	local originport=tile.id
	local destinyport=tile.link
	audio.Play(6)
	-- print ("PRE: "..p1.x..","..p1.y)
	-- twinkles[#twinkles+1]=display.newRect( tpsheet, { name="twinkle", start=1, count=16, time=300, loopCount=1 }  )
	-- twinkles[#twinkles].x=p1.shadow.x
	-- twinkles[#twinkles].y=p1.shadow.y
	-- twinkles[#twinkles]:play()
	Flashbang()
	p1.MP=p1.MP-manacost
	if p1.MP>=0 then
		local xchange=map[tile.link].x-map[tile.id].x
		local ychange=map[tile.link].y-map[tile.id].y
		-- print ("CHANGE: "..xchange..","..ychange)
		p1.shadow.x,p1.shadow.y=map[tile.link].x,map[tile.link].y
		-- p1.portcd=12
	else
		local deficit=math.abs(p1.MP)
		players.ReduceHP(deficit*2,"Portal")
		p1.MP=0
		if p1.HP>0 then
			local chosentile=math.random(1,msize)
			if map[chosentile].type=="path" then
				local xchange=map[chosentile].x-map[tile.id].x
				local ychange=map[chosentile].y-map[tile.id].y
				p1.shadow.x,p1.shadow.y=map[tile.link].x,map[tile.link].y
			else
				local xchange=map[tile.link].x-map[tile.id].x
				local ychange=map[tile.link].y-map[tile.id].y
				p1.shadow.x,p1.shadow.y=map[tile.link].x,map[tile.link].y
			end
		end
	end
	-- print ("POST: "..p1.x..","..p1.y)
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

function Flashbang()
	if not (theFlash) then
		theFlash=display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth+200,display.contentHeight+200)
		theFlash.transp=1
		theFlash:setFillColor(1,1,1,theFlash.transp)
		theFlash:toFront()
	else
		theFlash.transp=theFlash.transp-0.03
		theFlash:setFillColor(1,1,1,theFlash.transp)
		if theFlash.transp<=0.05 then
			display.remove(theFlash)
			theFlash=nil
		end
	end
	if (theFlash) then
		timer.performWithDelay(1,Flashbang)
	end
end

function doDrops(ex,ey)
	local v=table.maxn(tilevents)+1
	tilevents[v] = CBE.newVent({
		x=ex,
		y=ey,
		isActive=math.random(10,50),
		scaleX=0.7,
		scaleY=0.7,
		perEmit=1,
		parentGroup=PFX,
		build = function()
			return display.newSprite( coinsheet, coseqs )
		end,
		onCreation = function(p, vent)
			p:setSequence("stand")
			p:play()
			p.xScale,p.yScale=1.0,1.0
			physics.addBody(p,"dynamic",{radius=8, bounce=0.0})
			p:setVelocity( (p.x*((math.random(0,6)-3)/10) )*0.005, (p.x*((math.random(0,6)-3)/10))*0.005)
		end,
		onUpdate = function(particle, vent)
			vent.isActive=vent.isActive-1
			if vent.isActive<=0 then
				vent:stop()
			end
		end,
		onDeath = function(particle, vent)
			local i=table.maxn(drops)+1
			drops[i]=display.newSprite( coinsheet, coseqs )
			drops[i].x=particle.x
			drops[i].y=particle.y
			drops[i]:setSequence("stand")
			drops[i].maxtop=drops[i].y+5
			drops[i].maxbot=drops[i].y-5
			drops[i].direction=math.random(0,1)
			drops[i]:play()
			PFX:insert(drops[i])
			function Snoop( event )
				local p1=players.GetPlayer()
				if event.other==p1 then
					display.remove(drops[i].shadow)
					drops[i].shadow=nil
					display.remove(drops[i])
					drops[i]=nil
					-- print (vents[i])
					if (vents[i]) then
						vents[i]:destroy()
						vents[i]=nil
					end
					ui.CallAddCoins()
				end
			end
			drops[i]:addEventListener("collision",Snoop)
			physics.addBody(drops[i],"dynamic",{isSensor=true,radius=12, bounce=0.0})
			-- drops[i].xScale,drops[i].yScale=0.5,0.5
			if table.maxn(drops)==1 then
				Runtime:addEventListener("enterFrame",Boing)
			end
			drops[i].shadow=display.newImageRect("shadow.png",38,7)
			drops[i].shadow.xScale=0.8
			drops[i].shadow.yScale=2.0
			drops[i].shadow.name="coinshadow"
			drops[i].shadow.id=i
			drops[i].shadow.x=drops[i].x-1
			drops[i].shadow.y=drops[i].y+20
			physics.addBody(drops[i].shadow,"dynamic",{friction=0.3,bounce=0.0,filter={ categoryBits=2, maskBits=1 }})
			drops[i].shadow.isFixedRotation=true
			PFX:insert(drops[i].shadow)
			
			drops[i].shadow:toFront()
			drops[i]:toFront()
		end,
	})
	tilevents[v]:start()
end

function Boing()
	if table.maxn(drops)==0 then
		Runtime:removeEventListener("enterFrame",Boing)
	end
	for c=1,table.maxn(drops) do
		if (drops[c]) then
			if drops[c].x~=drops[c].shadow.x then
				drops[c].x=drops[c].shadow.x
			end
			if not(drops[c].isBodyActive) then
				physics.addBody(drops[c],"dynamic",{isSensor=true,radius=12, bounce=0.0})
			end
			if drops[c].direction==0 then
				drops[c].y=drops[c].y+((5)*0.02)
			elseif drops[c].direction==1 then
				drops[c].y=drops[c].y+((-5)*0.02)
			end
			if drops[c].y>=drops[c].maxtop then
				drops[c].direction=1
			elseif drops[c].y<=drops[c].maxbot then
				drops[c].direction=0
			end
		end
	end
end



