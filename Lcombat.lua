-----------------------------------------------------------------------------------------
--
-- combat.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local player1 = graphics.newImageSheet( "player/0.png", { width=39, height=46, numFrames=25 } )
local player2 = graphics.newImageSheet( "player/1.png", { width=24, height=33, numFrames=25 } )
local player3 = graphics.newImageSheet( "player/2.png", { width=30, height=49, numFrames=25 } )
local player4 = graphics.newImageSheet( "player/3.png", { width=33, height=53, numFrames=35 } )
local player5 = graphics.newImageSheet( "player/4.png", { width=32, height=32, numFrames=80 } )
local heartfsheet = graphics.newImageSheet( "heartsprite.png", { width=17, height=17, numFrames=16 } )
local statussheet = graphics.newImageSheet( "status.png", { width=88, height=40, numFrames=6 } )
local dexatt2 = graphics.newImageSheet( "enemy/dexatt2.png",{ width=32, height=33, numFrames=24 })
local dexatt3 = graphics.newImageSheet( "enemy/dexatt3.png",{ width=32, height=33, numFrames=24 })
local stadef2 = graphics.newImageSheet( "enemy/stadef2.png",{ width=55, height=32, numFrames=8 })
local stadef3 = graphics.newImageSheet( "enemy/stadef3.png",{ width=55, height=32, numFrames=8 })
local mgc2 = graphics.newImageSheet( "enemy/mage2.png",{ width=30, height=40, numFrames=10 })
local mgc3 = graphics.newImageSheet( "enemy/mage3.png",{ width=30, height=40, numFrames=10 })
local dexatt={dexatt3,dexatt2}
local stadef={stadef3,stadef2}
local mgc={mgc3,mgc2}
local p1sprite={player1,player2,player3,player4,player5}
local hpsheet = graphics.newImageSheet("hp.png",{ width=200, height=30, numFrames=67 })
local mpsheet = graphics.newImageSheet("mp.png",{ width=200, height=30, numFrames=67 })
local timersheet = graphics.newImageSheet( "timer.png",{ width=100, height=100, numFrames=25 })
local mov=require("Lmovement")
local players=require("Lplayers")
local gp=require("LGold")
local mob=require("Lmobai")
local ui=require("LUI")
local builder=require("LMapBuilder")
local WD=require("LProgress")
local audio=require("LAudio")
local widget = require "widget"
local physics = require "physics"
local q=require("LQuest")
local yCoord=856
local xCoord=display.contentWidth-250
local inCombat
local PTurn
local gcm
local gom
local CMenu
local OMenu
local enemy
local HitGroup
local hits
local enemy
local Spellbook
local Sorcery
local SorcIniX
local SorcIniY
local SBookDisplayed
local BurnLimit
local statusdisplay
local SorceryUI

function Essentials()
	SBookDisplayed=false
	Sorcery={}
	inCombat=false
	SorcIniX=display.contentWidth/2-20
	SorcIniY=50
end

function Attacking(victim)
	if inCombat==false then
		inCombat=true
		enemy=victim
		DisplayCombat()
		PTurn=true
	end
end

function Attacked(victim)
	if inCombat==false then
		inCombat=true
		enemy=victim
		DisplayCombat()
		PTurn=false
		MobsTurn()
	end
end

function DisplayCombat()
	gcm=display.newGroup()
	hits={}
	mov.ShowArrows("clean")
	HitGroup=display.newGroup()
	Runtime:removeEventListener("enterFrame", gp.GoldDisplay)
	Runtime:addEventListener("enterFrame", NoMansLand)
	
	local bkgdark=display.newImageRect("bkgs/bkg_level.png",768,1024)
	bkgdark.x=display.contentCenterX
	bkgdark.y=display.contentCenterY
	gcm:insert(bkgdark)
	
	local bkg=display.newImage("bkgs/bkg"..math.random(1,3)..".png",480,272)
	bkg.xScale = 1.5
	bkg.yScale = 1.5
	bkg.x = display.contentCenterX
	bkg.y = 146
	gcm:insert(bkg)
	
	local window1=display.newImage("window.png",171,160)
	window1.x=171
	window1.y=500
	window1.xScale=2.0
	window1.yScale=window1.xScale
	gcm:insert(window1)
	
	local window2=display.newImage("window2.png",171,43)
	window2.x=342
	window2.y=400
	window2.xScale=2.0
	window2.yScale=window2.xScale
	gcm:insert(window2)
	
	function toAttack()
		audio.Play(12)
		PlayerAttacks()
	end
	
	local AttackBtn= widget.newButton{
		label="Attack",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton2.png",
		width=252, height=55,
		onRelease = toAttack}
	AttackBtn:setReferencePoint( display.CenterReferencePoint )
	AttackBtn.x = 150
	AttackBtn.y = 650
	gcm:insert( AttackBtn )
	
	function toSorcery()
		audio.Play(12)
		ShowSorcery()
	end
	
	local MagicBtn= widget.newButton{
		label="Sorcery",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton2.png",
		width=252, height=55,
		onRelease = toSorcery}
	MagicBtn:setReferencePoint( display.CenterReferencePoint )
	MagicBtn.x = AttackBtn.x
	MagicBtn.y = AttackBtn.y+65
	gcm:insert( MagicBtn )
	
	function toRun()
		audio.Play(12)
		RunAttempt()
	end
	
	local RunBtn= widget.newButton{
		label="Retreat",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton2.png",
		width=252, height=55,
		onRelease = toRun}
	RunBtn:setReferencePoint( display.CenterReferencePoint )
	RunBtn.x = AttackBtn.x
	RunBtn.y = MagicBtn.y+65
	gcm:insert( RunBtn )
	
	gcm:toFront()	
	CreateMobStats()
	p1=players.GetPlayer()
	P1Sprite(1)
end

function MobSprite(value)
	if (value)==(1) then--Create
		enemy.num=math.random(1,2)
		if (enemy.class==1) or (enemy.class==3) then
			--Sta/Def
			eseqs={
				{name="walk", start=1, count=4, time=1000},
				{name="hit", start=5, count=3, loopCount=1, time=1000},
				{name="hurt", start=8, count=1, time=1000}
			}
			esprite=display.newSprite( stadef[enemy.num], eseqs  )
			esprite:setSequence( "walk" )
			esprite.x=(display.contentWidth/2)+50
			esprite.y=250
			esprite.xScale=4.0
			esprite.yScale=esprite.xScale
			esprite:play()
			gcm:insert(esprite)
		elseif (enemy.class==2) or (enemy.class==5)then
			--Att/Dex
			eseqs={
				{name="walk", start=1, count=4, time=1000},
				{name="hit", start=9, count=4, loopCount=1, time=1000},
				{name="hurt", start=8, count=1, time=1000},
				{name="hitalt", start=17, count=3, loopCount=1, time=1000}
			}
			esprite=display.newSprite( dexatt[enemy.num], eseqs  )
			esprite:setSequence( "walk" )
			esprite.x=(display.contentWidth/2)+50
			esprite.y=250
			esprite.xScale=3.5
			esprite.yScale=esprite.xScale
			esprite:play()
			gcm:insert(esprite)
		elseif (enemy.class)==(4) then
			--MGC
			eseqs={
				{name="walk", start=1, count=4, time=1000},
				{name="hit", start=6, count=3, loopCount=1, time=1000},
				{name="hurt", start=5, count=1, time=1000}
			}
			esprite=display.newSprite( mgc[enemy.num], eseqs  )
			esprite:setSequence( "walk" )
			esprite.x=(display.contentWidth/2)+50
			esprite.y=250
			esprite.xScale=4.0
			esprite.yScale=esprite.xScale
			esprite:play()
			gcm:insert(esprite)
		end
	end
	if (value)==(2) then--Change to Hit
		if (enemy.class==1) or (enemy.class==3) then
			--Sta/Def
			esprite:setSequence( "hit" )
			esprite:play()
		elseif (enemy.class==2) or (enemy.class==5)then
			--Att/Dex
			local roll=math.random(1,2)
			if roll==1 then
				esprite:setSequence( "hit" )
				esprite:play()
			elseif roll==2 then
				esprite:setSequence( "hitalt" )
				esprite:play()
			end
		elseif (enemy.class)==(4) then
			--MGC
			esprite:setSequence( "hit" )
			esprite:play()
		end
	end
	if (value)==(3) then--Change to Hurt
		if (enemy.class==1) or (enemy.class==3) then
			--Sta/Def
			esprite:setSequence( "hurt" )
			esprite:play()
		elseif (enemy.class==2) or (enemy.class==5)then
			--Att/Dex
			esprite:setSequence( "hurt" )
			esprite:play()
		elseif (enemy.class)==(4) then
			--MGC
			esprite:setSequence( "hurt" )
			esprite:play()
		end
	end
	if (value~=1)and(value~=2)and(value~=3)and(value~=4) then--Go Default
		if esprite.sequence~="walk" then
			if (esprite.frame==esprite.numFrames)then
				esprite:setSequence( "walk" )
				esprite:play()
			else
				timer.performWithDelay(20,MobSprite)
			end
		end
	end
end

function P1Sprite(value)
	if (value)==(1) then--Create
		if p1.name=="Magus" then
			pseqs={
				{name="walk", start=1, count=3, time=1000},
				{name="hit1", start=17, count=8, loopCount=1, time=1000},
				{name="hit2", start=33, count=8, loopCount=1, time=1000},
				{name="hit3", start=49, count=16, loopCount=1, time=1000},
				{name="cast", start=65, count=7, time=1000},
				{name="hurt", start=4, count=1, time=1000}
			}
			psprite=display.newSprite( p1sprite[5], pseqs  )
			psprite:setSequence( "walk" )
			psprite.x=(display.contentWidth/2)+50
			psprite.y=250
			psprite.xScale=4.0
			psprite.yScale=psprite.xScale
			psprite:play()
			gcm:insert(psprite)
		elseif (p1.char==0) then
			pseqs={
				{name="walk", start=1, count=4, time=1000},
				{name="hit1", start=6, count=3, loopCount=1, time=1000},
				{name="hit2", start=11, count=4, loopCount=1, time=1000},
				{name="hit3", start=16, count=5, loopCount=1, time=1000},
				{name="cast", start=21, count=2, time=1000},
				{name="hurt", start=5, count=1, time=1000}
			}
			psprite=display.newSprite( p1sprite[1], pseqs  )
			psprite:setSequence( "walk" )
			psprite.x=(display.contentWidth/2)+50
			psprite.y=250
			psprite.xScale=4.0
			psprite.yScale=psprite.xScale
			psprite:play()
			gcm:insert(psprite)
		elseif (p1.char==1) then
			pseqs={
				{name="walk", start=1, count=2, time=1000},
				{name="hit1", start=6, count=3, loopCount=1, time=1000},
				{name="hit2", start=11, count=3, loopCount=1, time=1000},
				{name="hit3", start=16, count=5, loopCount=1, time=1000},
				{name="cast", start=21, count=2, time=1000},
				{name="hurt", start=3, count=1, time=1000}
			}
			psprite=display.newSprite( p1sprite[2], pseqs  )
			psprite:setSequence( "walk" )
			psprite.x=(display.contentWidth/2)+50
			psprite.y=250
			psprite.xScale=4.0
			psprite.yScale=psprite.xScale
			psprite:play()
			gcm:insert(psprite)
		elseif (p1.char)==(2) then
			pseqs={
				{name="walk", start=1, count=4, time=1000},
				{name="hit1", start=6, count=2, loopCount=1, time=1000},
				{name="hit2", start=11, count=3, loopCount=1, time=1000},
				{name="hit3", start=16, count=2, loopCount=1, time=1000},
				{name="cast", start=21, count=2, time=1000},
				{name="hurt", start=5, count=1, time=1000}
			}
			psprite=display.newSprite( p1sprite[3], pseqs  )
			psprite:setSequence( "walk" )
			psprite.x=(display.contentWidth/2)+50
			psprite.y=250
			psprite.xScale=4.0
			psprite.yScale=psprite.xScale
			psprite:play()
			gcm:insert(psprite)
		elseif (p1.char)==(3) then
			pseqs={
				{name="walk", start=1, count=2, time=600},
				{name="cast", start=8, count=2, time=600},
				{name="hit1", start=15, count=3, loopCount=1, time=400},
				{name="hit2", start=22, count=4, loopCount=1, time=600},
				{name="hit3", start=29, count=7, loopCount=1, time=1000},
				{name="hurt", start=3, count=1, time=800}
			}
			psprite=display.newSprite( p1sprite[4], pseqs  )
			psprite:setSequence( "walk" )
			psprite.x=(display.contentWidth/2)+50
			psprite.y=250
			psprite.xScale=4.0
			psprite.yScale=psprite.xScale
			psprite:play()
			gcm:insert(psprite)
		end
	end
	if (value)==(2) then--Change to Hit
		esprite:setSequence( "hit" )
		esprite:play()
	end
	if (value)==(3) then--Change to Hurt
		esprite:setSequence( "hurt" )
		esprite:play()
	end
	if (value)==(4) then--Set to Casting
		psprite:setSequence( "cast" )
		psprite:play()
	end
	if (value~=1)and(value~=2)and(value~=3)and(value~=4) then--Go Default
		if esprite.sequence~="walk" then
			if (esprite.frame==esprite.numFrames)then
				esprite:setSequence( "walk" )
				esprite:play()
			else
				timer.performWithDelay(20,MobSprite)
			end
		end
	end
end

function CreateMobStats()
	p1=players.GetPlayer()
	local size=builder.GetData(0)
	local col=(math.floor(enemy.loc%(math.sqrt(size))))
	local row=(math.floor(enemy.loc/(math.sqrt(size))))+1
	local zonas=((math.sqrt(size))/10)
	local round=WD.Circle()
	
	if not (enemy.bonus) then
		enemy.bonus={}
		for i=1,5 do
			if enemy.class==i then
				enemy.bonus[i]=2
			else
				enemy.bonus[i]=1
			end
		end
	end
	if not (enemy.lvl) then
		if round%2==0 then
			for z=1, zonas do
				if col>((math.sqrt(size)/zonas)*(zonas-z)) and col<=((math.sqrt(size)/zonas)*((zonas+1)-z)) and row>=((math.sqrt(size)/zonas)*(zonas-z)) then
					enemy.lvl=(z+(zonas*(round-1)))
				elseif row>((math.sqrt(size)/zonas)*(zonas-z)) and row<=((math.sqrt(size)/zonas)*((zonas+1)-z)) and col>=((math.sqrt(size)/zonas)*((zonas+1)-z)) then
					enemy.lvl=(z+(zonas*(round-1)))
				end
			end
		else
			for z=1, zonas do
				if col>((math.sqrt(size)/zonas)*(z-1)) and col<=((math.sqrt(size)/zonas)*z) and row<=((math.sqrt(size)/zonas)*z) then
					enemy.lvl=(z+(zonas*(round-1)))
				elseif row>((math.sqrt(size)/zonas)*(z-1)) and row<=((math.sqrt(size)/zonas)*z) and col<=((math.sqrt(size)/zonas)*z) then
					enemy.lvl=(z+(zonas*(round-1)))
				end
			end
		end
	end
	if not (enemy.stats) then
		enemy.stats={}
		for s=1,5 do
			enemy.stats[s]=1+enemy.bonus[s]
		end
		enemy.status=false
		enemy.pnts=(5*enemy.lvl)
		enemy.pnts=enemy.pnts
		for i=1,enemy.pnts do
			enemy.min=math.min(enemy.stats[1],enemy.stats[2],enemy.stats[3],enemy.stats[4],enemy.stats[5])
			local astats={}
			for i=1,5 do
				if enemy.stats[i]>enemy.min+5 then
					astats[i]=0
				else
					astats[i]=1
				end
			end
			function DoneIt()
				local statroll=math.random(1,5)
				if astats[statroll]==1 then
					enemy.stats[statroll]=enemy.stats[statroll]+1
				else
					DoneIt()
				end
			end
			DoneIt()
		end
	end
	enemy.max=math.max(enemy.stats[1],enemy.stats[2],enemy.stats[3],enemy.stats[4],enemy.stats[5])
	for i=1,5 do
		if enemy.stats[i]==enemy.max then
			enemy.class=i
		end
	end
	MobSprite(1)
	enemy.MaxHP=(100*enemy.lvl)+(enemy.stats[1]*10)
	enemy.MaxMP=(enemy.lvl*15)+(enemy.stats[4]*10)
	enemy.HP=enemy.MaxHP
	enemy.MP=enemy.MaxMP
	ShowMobStats()
end

function ShowMobStats()
	
-- Life
	LifeSymbol=display.newSprite( heartfsheet, { name="heart", start=1, count=16, time=(1800) })
	LifeSymbol.yScale=3.75
	LifeSymbol.xScale=3.75
	LifeSymbol.x = xCoord+10
	LifeSymbol.y = yCoord
	LifeSymbol:play()
	LifeSymbol:toFront()
	gcm:insert(LifeSymbol)
	
	display.remove(LifeDisplay)
	LifeDisplay = display.newText( (enemy.HP.."/"..enemy.MaxHP), 0, 0, "Game Over", 100 )
	LifeDisplay:setTextColor( 255, 255, 255)
	LifeDisplay.x = LifeSymbol.x+110
	LifeDisplay.y = yCoord-5
	LifeDisplay:toFront()
	gcm:insert(LifeDisplay)
	

-- Level
	
	LvlDisplay = display.newText( ("Lv: "..enemy.lvl), 0, 0, "Game Over", 100 )
	LvlDisplay:setTextColor( 0, 255, 0)
	LvlDisplay.x = xCoord-70
	LvlDisplay.y = LifeDisplay.y
	LvlDisplay:toFront()
	gcm:insert(LvlDisplay)
	
	statusdisplay=display.newSprite( statussheet, { name="status", start=1, count=6, time=800 }  )
	statusdisplay.x = LvlDisplay.x
	statusdisplay.y = LvlDisplay.y+50
	gcm:insert(statusdisplay)
	
end

function UpdateMobStats()
	display.remove(LifeDisplay)
	if enemy.HP<0 then
		enemy.HP=0
	end
	LifeDisplay = display.newText( (enemy.HP.."/"..enemy.MaxHP), 0, 0, "Game Over", 100 )
	LifeDisplay:setTextColor( 255, 255, 255)
	LifeDisplay.x = LifeSymbol.x+110
	LifeDisplay.y = yCoord-5
	LifeDisplay:toFront()
	gcm:insert(LifeDisplay)
end

function InTrouble()
	return inCombat
end

function RunAttempt()
	ShowSorcery(true)
	if PTurn==true then
		PTurn=false
		local RunChance,MaxChance=EvadeCalc("mob",48)
		if RunChance>=(enemy.stats[5]/3) or MaxChance<(enemy.stats[5]/3)*2 then
			EndCombat("Ran")
			inCombat=false
		else
			PTurn=false
			MobsTurn()
		end
	end
end

function PlayerAttacks()
	ShowSorcery(true)
	if PTurn==true then
		PTurn=false
		local isHit=EvadeCalc("mob",16)
		if isHit>=(enemy.stats[5]/3)*2 then
			if isHit>=(enemy.stats[5]/3)*5 then
				local Damage=DamageCalc("mob",(math.random(15,20)/10),16)
				if (Damage)<=0 then
					Hits("BLK!",false,true,false)
				else
					enemy.HP=enemy.HP-Damage
					UpdateMobStats()
					Hits((Damage),true,true,false)
				end
			else
				local Damage=DamageCalc("mob",1,16)
				if (Damage)<=0 then
					Hits("BLK!",false,true,false)
				else
					enemy.HP=enemy.HP-Damage
					UpdateMobStats()
					Hits((Damage),false,true,false)
				end
			end
		else
			Hits("MSS!",false,true,false)
		end
		if enemy.HP<=0 then
			if enemy.HP<0 then
				enemy.HP=0
			end
			function closure()
				EndCombat("Win")
			end
			timer.performWithDelay(200,closure)
		else
			timer.performWithDelay(500,MobsTurn)
		end
	end
end

function MobsTurn()
	if PTurn==false then
		local isHit=EvadeCalc("p1",16)
		if isHit>=(p1.stats[5]/3)*2 then
			if isHit>=(p1.stats[5]/3)*5 then
				local Damage=DamageCalc("p1",(math.random(15,20)/10),16)
				if (Damage)<=0 then
					Hits("BLK!",false,false,false)
				else
					players.ReduceHP(Damage,"Mob")
					Hits((Damage),true,false,false)
				end
			else
				local Damage=DamageCalc("p1",1,16)
				if (Damage)<=0 then
					Hits("BLK!",false,false,false)
				else
					players.ReduceHP(Damage,"Mob")
					Hits((Damage),false,false,false)
				end
			end
		else
			Hits("MSS!",false,false,false)
		end
		if enemy.status=="BRN" then
			if BurnLimit>0 then
				local Burn=(math.floor(enemy.MaxHP*.05))
				enemy.HP=enemy.HP-Burn
				UpdateMobStats()
				BurnLimit=BurnLimit-1
				Hits((Burn),false,true,"BRN")
			elseif BurnLimit<=0 then
				if BurnLimit<0 then
					BurnLimit=0
				end
				statusdisplay:setFrame(1)
				enemy.status=false
			end
		elseif enemy.status=="PSN" then
			if enemy.HP<enemy.MaxHP*.2 then
				statusdisplay:setFrame(1)
				enemy.status=false
			else
				local Poison=(math.floor(enemy.MaxHP*.02))
				enemy.HP=enemy.HP-Poison
				UpdateMobStats()
				Hits((Poison),false,true,"PSN")
			end
		end
		if p1.HP<=0 then
			if p1.HP<0 then
				p1.HP=0
			end
			function closure1()
				EndCombat("Loss")
			end
			timer.performWithDelay(200,closure1)
		elseif enemy.HP<=0 then
			if enemy.HP<0 then
				enemy.HP=0
			end
			function closure2()
				EndCombat("Win")
			end
			timer.performWithDelay(200,closure2)
		else
			PTurn=true
			if Automatic==true then
				timer.performWithDelay(500,PlayerAttacks)
			end
		end
	end
end

function EndCombat(outcome)
	gcm:insert(HitGroup)
	for i=gcm.numChildren,1,-1 do
		display.remove(gcm[i])
		gcm[i]=nil
	end
	gcm=nil
	
	if outcomed==false then
		outcomed=true
		Runtime:addEventListener("enterFrame", gp.GoldDisplay)
		--------------------------------------------
		if outcome=="Loss" then
		--------------------------------------------
		elseif (outcome)=="Win" then
			q.UpdateQuest("mob",enemy.lvl)
			gom=display.newGroup()
			mob.MobDied(enemy)
			
			OMenu=display.newImageRect("deathmenu.png", 700, 500)
			OMenu.x,OMenu.y = display.contentWidth*0.5, 450
			gom:insert(OMenu)
			
			local OKBtn= widget.newButton{
				label="Okay",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=290, height=80,
				onRelease = AcceptOutcome
			}
			OKBtn:setReferencePoint( display.CenterReferencePoint )
			OKBtn.x = display.contentWidth/2
			OKBtn.y = display.contentHeight*0.61
			gom:insert(OKBtn)
			
			local msg=display.newText("Mob defeated!",0,0, "Game Over", 190)
			msg.x = display.contentWidth/2
			msg.y = 280
			gom:insert(msg)
			
			local msg2=display.newText("You gained:",0,0, "Game Over", 100)
			msg2.x = display.contentWidth/4
			msg2.y = msg.y+100
			gom:insert(msg2)
			
			local enemystats=((enemy.stats[2]+enemy.stats[1]+enemy.stats[5]+enemy.stats[5]+enemy.stats[3])/5)
			local playerstats=((p1.stats[2]+p1.stats[1]+p1.stats[5]+p1.stats[5]+p1.stats[3])/5)
			local xp=math.floor(25*((enemystats/playerstats)*(enemy.lvl/p1.lvl)))
			local gold=(math.floor(xp/10))*5
			if p1.lvl-3>=enemy.lvl then
				xp=0
			end
			if gold==0 then
				players.GrantXP(xp)
				local msg4=display.newText( ( xp ).." XP.",0,0, "Game Over", 100)
				msg4:setTextColor(255, 0, 255)
				msg4.x = msg2.x+200
				msg4.y = msg2.y
				gom:insert(msg4)
			elseif xp==0 then
				local msg3=display.newText(gold.." gold.",0,0, "Game Over", 100)
				msg3:setTextColor(255, 255, 0)
				msg3.x = msg2.x+200
				msg3.y = msg2.y
				gom:insert(msg3)
				gp.CallAddCoins(gold)
			else
				local msg3=display.newText(gold.." gold.",0,0, "Game Over", 100)
				msg3:setTextColor(255, 255, 0)
				msg3.x = msg2.x+200
				msg3.y = msg2.y
				gom:insert(msg3)
				gp.CallAddCoins(gold)
				
				players.GrantXP( xp )
				
				local msg4=display.newText( ( xp ).." XP.",0,0, "Game Over", 100)
				msg4:setTextColor(255, 0, 255)
				msg4.x = msg3.x
				msg4.y = msg2.y+50
				gom:insert(msg4)
			end
		--------------------------------------------
		elseif (outcome)=="Ran" then
			gom=display.newGroup()
			
			OMenu=display.newImageRect("deathmenu.png", 700, 500)
			OMenu.x,OMenu.y = display.contentWidth*0.5, 450
			gom:insert(OMenu)	
			
			local msg=display.newText("Got away safely!",0,0, "Game Over", 190)
			msg.x = display.contentWidth/2
			msg.y = 280
			gom:insert(msg)
			
			local OKBtn= widget.newButton{
				label="Okay",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=290, height=80,
				onRelease = AcceptOutcome
			}
			OKBtn:setReferencePoint( display.CenterReferencePoint )
			OKBtn.x = display.contentWidth/2
			OKBtn.y = display.contentHeight*0.61
			gom:insert(OKBtn)
		end
	end
end

function AcceptOutcome()
	Runtime:removeEventListener("enterFrame", NoMansLand)
	audio.Play(12)
	outcomed=false
	Automatic=false
	for i=gom.numChildren,1,-1 do
		local child = gom[i]
		child.parent:remove( child )
	end
	for i = 1, table.maxn(hits) do
		if (hits[i]) then
			display.remove(hits[i])
			hits[i]=nil
		end
	end
	inCombat=false
	mov.ShowArrows()
	ui.DontKeepCalm("toggle")
end

function Hits(damage,crit,target,special)
	P1=players.GetPlayer()
	if special==true then
		hits[#hits+1]=display.newText( ("+"..damage), 0, 0, "Game Over", 120 )
		hits[#hits]:setTextColor( 0, 150, 0)
	elseif special=="BRN" then
		hits[#hits+1]=display.newText( (damage), 0, 0, "Game Over", 120 )
		hits[#hits]:setTextColor( 200, 0, 0)
	elseif special=="PSN" then
		hits[#hits+1]=display.newText( (damage), 0, 0, "Game Over", 120 )
		hits[#hits]:setTextColor( 150, 0, 150)
	elseif special=="SPL" then
		hits[#hits+1]=display.newText( (damage), 0, 0, "Game Over", 120 )
		hits[#hits]:setTextColor(20,20,200)
	elseif crit==true then
		hits[#hits+1]=display.newText( (damage.."!"), 0, 0, "Game Over", 120 )
		hits[#hits]:setTextColor( 150, 0, 0)
	elseif crit==false then
		hits[#hits+1]=display.newText( (damage), 0, 0, "Game Over", 100 )
		hits[#hits]:setTextColor( 0, 0, 0)
	end
	physics.addBody(hits[#hits], "dynamic", { friction=0.5,} )
	hits[#hits].isFixedRotation = true
	if target==false then
		hits[#hits].x=(display.contentWidth/4)
		hits[#hits].y=(display.contentHeight/4)*2.5
		hits[#hits]:setLinearVelocity(100,-300)
	elseif target==true then
		hits[#hits].x=(display.contentWidth/4)*3
		hits[#hits].y=(display.contentHeight/4)*2.5
		hits[#hits]:setLinearVelocity(-100,-300)
	end
	HitGroup:insert( hits[#hits] )
	HitGroup:toFront()
end

function GetHits()
	return hits
end

function ShowSorcery(dumb)
	if dumb==true then
		if SBookDisplayed==true then
			function deletion()
				display.remove(SorceryUI)
			end
			transition.to(SorceryUI, {time=(100*(#Sorcery)), y=(SorceryUI.y-(50+((#Sorcery)*44))),transition = easing.inExpo,onComplete=deletion})
			for i=table.maxn(Sorcery),1,-1 do
				display.remove(Sorcery[i])
				Sorcery[i]=nil
			end
			SBookDisplayed=false
		end
	else
		if SBookDisplayed==false then
			function finishSpells()
				for i=1,table.maxn(Sorcery) do
					Sorcery[i].isVisible=true
					Sorcery[i]:toFront()
				end
			end
			Spellbook=players.LearnSorcery(true)
			for s=1, table.maxn(Spellbook),5 do
				if Spellbook[s+2]==true then
					function toCast()
						CastSorcery(Spellbook[s])
					end
					Sorcery[#Sorcery+1]=display.newText( (Spellbook[s].."  "..Spellbook[s+3].."/"..Spellbook[s+4]), SorcIniX, (SorcIniY+((#Sorcery-1)*50)), "Viner Hand ITC", 40)
					Sorcery[#Sorcery]:setTextColor(50,50,50)
					if (Spellbook[s+3])==0 then
						Sorcery[#Sorcery]:setTextColor(180,60,60)
					else
						Sorcery[#Sorcery]:addEventListener("tap",toCast)
					end						
					Sorcery[#Sorcery].isVisible=false
					SorcDisplayed=true
				end
			end
			if table.maxn(Sorcery)==0 then
				Sorcery[#Sorcery+1]=display.newText( ("No known Sorcery."), SorcIniX, (SorcIniY+((#Sorcery-1)*40)), "Viner Hand ITC", 40)
				Sorcery[#Sorcery]:setTextColor(120,120,120)
				Sorcery[#Sorcery].isVisible=false
			end
			
			SorceryUI=display.newImageRect("scrollui4.png", 460, 600)
			SorceryUI.x, SorceryUI.y = display.contentWidth-230, -300
			transition.to(SorceryUI, {time=(100*(#Sorcery)), y=(SorceryUI.y+(50+((#Sorcery)*44))),transition = easing.inExpo,onComplete=finishSpells})
			SBookDisplayed=true
		elseif SBookDisplayed==true then
			function deletion()
				display.remove(SorceryUI)
			end
			transition.to(SorceryUI, {time=(100*(#Sorcery)), y=(SorceryUI.y-(50+((#Sorcery)*44))),transition = easing.inExpo,onComplete=deletion})
			for i=table.maxn(Sorcery),1,-1 do
				display.remove(Sorcery[i])
				Sorcery[i]=nil
			end
			SBookDisplayed=false
		end
	end
end

function CastSorcery(name)
	if PTurn==true then
		PTurn=false
		ShowSorcery(true)
		Spellbook=players.LearnSorcery(true)
		for s=1, table.maxn(Spellbook),5 do
			if Spellbook[s]==name then
				Spellbook[s+3]=Spellbook[s+3]-1	
			end
		end
		if name=="Cleave" then
			local Damage=DamageCalc("mob",(math.random(15,20)/10),22)
			Hits((Damage),true,true,"SPL")
			enemy.HP=enemy.HP-Damage
			if enemy.HP<=0 then
				if enemy.HP<0 then
					enemy.HP=0
				end
				function closure()
					EndCombat("Win")
				end
				timer.performWithDelay(200,closure)
			else
				timer.performWithDelay(500,MobsTurn)
			end
			UpdateMobStats()
			
		elseif name=="Healing" then
		
			local p1=players.GetPlayer()
			players.AddHP(math.floor(p1.MaxHP*.2))
			Hits((math.floor(p1.MaxHP*.2)),false,false,true)
			if enemy.HP<=0 then
				if enemy.HP<0 then
					enemy.HP=0
				end
				function closure()
					EndCombat("Win")
				end
				timer.performWithDelay(200,closure)
			else
				timer.performWithDelay(500,MobsTurn)
			end
			UpdateMobStats()
			
		elseif name=="Fire Sword" then
		
			local isHit=EvadeCalc("mob",32)
			if isHit>=(enemy.stats[5]/3)*2 then
				local Damage=DamageCalc("mob",(math.random(15,20)/10),22)
				if (Damage)<=0 then
					Hits("BLK!",false,true,"SPL")
				else
					enemy.status="BRN"
					Hits(("Burn!"),false,true,"SPL")
					enemy.HP=enemy.HP-Damage
					statusdisplay:setFrame(3)
					UpdateMobStats()
					BurnLimit=p1.stats[4]*2
					if BurnLimit>15 then
						BurnLimit=20
					end
					Hits((Damage),true,true,"SPL")
				end
			else
				Hits("MSS!",false,true,"SPL")
			end
			if enemy.HP<=0 then
				if enemy.HP<0 then
					enemy.HP=0
				end
				function closure()
					EndCombat("Win")
				end
				timer.performWithDelay(200,closure)
			else
				timer.performWithDelay(500,MobsTurn)
			end
			UpdateMobStats()
			
		elseif name=="Fireball" then
		
			local isHit=EvadeCalc("mob",32)
			if isHit>=(enemy.stats[5]/3)*2 then
				if isHit>=(enemy.stats[5]/3)*5 then
					local Damage=DamageCalc("mob",(math.random(15,20)/10),22)
					if (Damage)<=0 then
						Hits("BLK!",false,true,"SPL")
					else
						enemy.status="BRN"
						Hits(("Burn!"),false,true,"SPL")
						enemy.HP=enemy.HP-Damage
						statusdisplay:setFrame(3)
						UpdateMobStats()
						BurnLimit=p1.stats[4]+2
						if BurnLimit>15 then
							BurnLimit=15
						end
						Hits((Damage),true,true,"SPL")
					end
				else
					local Damage=DamageCalc("mob",1,22)
					if (Damage)<=0 then
						Hits("BLK!",false,true,"SPL")
					else
						enemy.status="BRN"
						Hits(("Burn!"),false,true,"SPL")
						enemy.HP=enemy.HP-Damage
						statusdisplay:setFrame(3)
						UpdateMobStats()
						BurnLimit=p1.stats[4]+2
						if BurnLimit>15 then
							BurnLimit=15
						end
						Hits((Damage),false,true,"SPL")
					end
				end
			else
				Hits("MSS!",false,true,"SPL")
			end
			if enemy.HP<=0 then
				if enemy.HP<0 then
					enemy.HP=0
				end
				function closure()
					EndCombat("Win")
				end
				timer.performWithDelay(200,closure)
			else
				timer.performWithDelay(500,MobsTurn)
			end
			UpdateMobStats()
			
		elseif name=="Ice Sword" then
		
			local isHit=EvadeCalc("mob",32)
			if isHit>=(enemy.stats[5]/3)*2 then
				local Damage=DamageCalc("mob",(math.random(15,20)/10),22)
				if (Damage)<=0 then
					Hits("BLK!",false,true,"SPL")
				else
					enemy.stats[5]=enemy.stats[5]-(math.floor(enemy.stats[5]*.2))
					Hits(("Slowed!"),false,true,"SPL")
					enemy.HP=enemy.HP-Damage
					UpdateMobStats()
					Hits((Damage),true,true,"SPL")
				end
			else
				Hits("MSS!",false,true,"SPL")
			end
			if enemy.HP<=0 then
				if enemy.HP<0 then
					enemy.HP=0
				end
				function closure()
					EndCombat("Win")
				end
				timer.performWithDelay(200,closure)
			else
				timer.performWithDelay(500,MobsTurn)
			end
			UpdateMobStats()
			
		elseif name=="Slow" then
			enemy.stats[5]=enemy.stats[5]-(math.floor(enemy.stats[5]*.2))
			Hits(("Slowed!"),false,true,"SPL")
			if enemy.HP<=0 then
				if enemy.HP<0 then
					enemy.HP=0
				end
				function closure()
					EndCombat("Win")
				end
				timer.performWithDelay(200,closure)
			else
				timer.performWithDelay(500,MobsTurn)
			end
			UpdateMobStats()
			
		elseif name=="Poison Blade" then
		
			local isHit=EvadeCalc("mob",32)
			if isHit>=(enemy.stats[5]/3)*2 then
				if isHit>=(enemy.stats[5]/3)*5 then
					local Damage=DamageCalc("mob",(math.random(15,20)/10),22)
					if (Damage)<=0 then
						Hits("BLK!",false,true,"SPL")
					else
						enemy.status="PSN"
						Hits(("Poison!"),false,true,"SPL")
						enemy.HP=enemy.HP-Damage
						statusdisplay:setFrame(5)
						UpdateMobStats()
						Hits((Damage),true,true,"SPL")
					end
				else
					local Damage=DamageCalc("mob",1,22)
					if (Damage)<=0 then
						Hits("BLK!",false,true,"SPL")
					else
						enemy.status="PSN"
						Hits(("Poison!"),false,true,"SPL")
						enemy.HP=enemy.HP-Damage
						statusdisplay:setFrame(5)
						UpdateMobStats()
						Hits((Damage),false,true,"SPL")
					end
				end
			else
				Hits("MSS!",false,true,"SPL")
			end
			if enemy.HP<=0 then
				if enemy.HP<0 then
					enemy.HP=0
				end
				function closure()
					EndCombat("Win")
				end
				timer.performWithDelay(200,closure)
			else
				timer.performWithDelay(500,MobsTurn)
			end
			UpdateMobStats()
		end
	end
end

function NoMansLand()
	for h=1,table.maxn(hits) do
		if (hits[h]) and (hits[h].y) then
			if hits[h].y>=display.contentHeight-260 then
				display.remove(hits[h])
			end
		end
	end
end

function DamageCalc(tar,crit,cmd)
	local Damage
	if tar=="p1" then
		Damage=(
			((enemy.stats[2]*1.5)-p1.stats[3])*5
		)
		Damage=(
			((Damage*cmd/16)*crit)
		)
		Damage=math.floor(
			Damage*((math.random((10+(enemy.stats[2]*0.5)),(10+(enemy.stats[2]*1.5))))/10)
		)
	elseif tar=="mob" then
		Damage=(
			((p1.stats[2]*1.5)-enemy.stats[3])*5
		)
		Damage=(
			((Damage*cmd/16)*crit)
		)
		Damage=math.floor(
			Damage*((math.random((10+(p1.stats[2]*0.5)),(10+(p1.stats[2]*1.5))))/10)
		)
	end
	return Damage
end

function EvadeCalc(tar,cmd)
	local Chance
	local MaxChance
	if tar=="p1" then
		Chance=(
			((enemy.stats[5]*1.5)-p1.stats[5])
		)
		Chance=(
			(Chance*cmd/16)
		)
		Chance=(
			Chance*((math.random((10+(enemy.stats[5]*0.5)),(10+(enemy.stats[5]*1.5))))/10)
		)
	elseif tar=="mob" then
		Chance=(
			((p1.stats[5]*1.5)-enemy.stats[5])
		)
		Chance=(
			(Chance*cmd/16)
		)
		Chance=(
			Chance*((math.random((10+(p1.stats[5]*0.5)),(10+(p1.stats[5]*1.5))))/10)
		)
		MaxChance=(
			((p1.stats[5]*1.5)-enemy.stats[5])
		)
		MaxChance=(
			(MaxChance*cmd/16)
		)
		MaxChance=(
			MaxChance*((10+(p1.stats[5]*1.5))/10)
		)
	--	print (Chance.."/"..MaxChance)
	end
	if tar=="mob" then
		return Chance,MaxChance
	else
		return Chance
	end
end