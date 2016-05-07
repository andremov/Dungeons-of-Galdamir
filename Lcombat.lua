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
local heartsheet = graphics.newImageSheet( "heartsprite.png", { width=17, height=17, numFrames=16 } )
local manasheet = graphics.newImageSheet( "manasprite.png", { width=60, height=60, numFrames=3 } )
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
local yCoord=510
local xCoord=display.contentWidth-250
local inCombat
local gcm
local gom
local CMenu
local OMenu
local enemy
local HitGroup
local hits
local enemy
local Spellbook
local ptimer
local etimer
local Sorcery
local SorcIniX
local SorcIniY
local SBookDisplayed
local BurnLimit
local statusdisplay
local SorceryUI
local outcomed

function Essentials()
	SBookDisplayed=false
	Sorcery={}
	inCombat=false
	SorcIniX=display.contentCenterX-(190+20)
	SorcIniY=display.contentHeight-120
	outcomed=false
end

function Attacking(victim)
	if inCombat==false then
		inCombat=true
		enemy=victim
		DisplayCombat()
	end
end

function Attacked(victim)
	if inCombat==false then
		inCombat=true
		enemy=victim
		DisplayCombat()
	--	MobsTurn()
	end
end

function DisplayCombat()
	gcm=display.newGroup()
	hits={}
	mov.ShowArrows("clean")
	HitGroup=display.newGroup()
	Runtime:removeEventListener("enterFrame", gp.GoldDisplay)
	Runtime:removeEventListener("enterFrame", players.ShowStats)
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
	
	window1=display.newImage("window.png",171,43)
	window1.x=190
	window1.y=yCoord-120
	window1.xScale=2.25
	window1.yScale=window1.xScale
	gcm:insert(window1)
	
	window2=display.newImage("window2.png",171,43)
	window2.x=display.contentWidth-window1.x
	window2.y=window1.y
	window2.xScale=window1.xScale
	window2.yScale=window2.xScale
	gcm:insert(window2)

	
	gcm:toFront()	
	CreateMobStats()
	p1=players.GetPlayer()
	
	--Mob Display
	P1Sprite(1)
	MoveSprites()
	
	--Timers
	timersprite=display.newSprite( timersheet, { name="timerid", start=1, count=25, loopCount=1, time=1000+(1500*p1.SPD)}  )
	timersprite.x=display.contentCenterX
	timersprite.y=display.contentCenterY+100
	timersprite:play()
	gcm:insert(timersprite)
	
	AttackBtn=display.newImageRect("combataction3.png",342,86)
	AttackBtn.x=timersprite.x-172
	AttackBtn.y=timersprite.y-44
	gcm:insert( AttackBtn )
	
	MagicBtn=display.newImageRect("combataction3.png",342,86)
	MagicBtn.x = timersprite.x+172
	MagicBtn.y = AttackBtn.y
	gcm:insert( MagicBtn )
	
	RunBtn=display.newImageRect("combataction3.png",342,86)
	RunBtn.x = MagicBtn.x
	RunBtn.y = timersprite.y+44
	gcm:insert( RunBtn )
	
	timersprite:toFront()
	
	ptimer=timer.performWithDelay(1000+(1500*p1.SPD),ShowActions)
	etimer=timer.performWithDelay(1001+(1500*enemy.SPD),MobsTurn)
end

function ShowActions()
	ptimer=nil
	local ep=timer.pause(etimer)
	
	if (AttackBtn) then
		display.remove(AttackBtn)
	end
	
	if (MagicBtn) then
		display.remove(MagicBtn)
	end
	
	if (RunBtn) then
		display.remove(RunBtn)
	end
	
	function toAttack()
		display.remove(AttackBtn)
		display.remove(MagicBtn)
		display.remove(RunBtn)
		
		AttackBtn=display.newImageRect("combataction3.png",342,86)
		AttackBtn.x=timersprite.x-172
		AttackBtn.y=timersprite.y-44
		gcm:insert( AttackBtn )
		
		MagicBtn=display.newImageRect("combataction3.png",342,86)
		MagicBtn.x = timersprite.x+172
		MagicBtn.y = AttackBtn.y
		gcm:insert( MagicBtn )
		
		RunBtn=display.newImageRect("combataction3.png",342,86)
		RunBtn.x = MagicBtn.x
		RunBtn.y = timersprite.y+44
		gcm:insert( RunBtn )
		
		timersprite:toFront()
		
		PlayerAttacks()
	end
	
	AttackBtn= widget.newButton{
		label="Attack",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="combataction.png",
		overFile="combataction2.png",
		width=342, height=86,
		onRelease = toAttack}
	AttackBtn:setReferencePoint( display.CenterReferencePoint )
	AttackBtn.x = timersprite.x-172
	AttackBtn.y = timersprite.y-44
	gcm:insert( AttackBtn )
	
	function toSorcery()		
		ShowSorcery()
	end
	
	MagicBtn= widget.newButton{
		label="Sorcery",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="combataction.png",
		overFile="combataction2.png",
		width=342, height=86,
		onRelease = toSorcery}
	MagicBtn:setReferencePoint( display.CenterReferencePoint )
	MagicBtn.x = timersprite.x+172
	MagicBtn.y = AttackBtn.y
	gcm:insert( MagicBtn )
	
	function toRun()
		display.remove(AttackBtn)
		display.remove(MagicBtn)
		display.remove(RunBtn)
		
		AttackBtn=display.newImageRect("combataction3.png",342,86)
		AttackBtn.x=timersprite.x-172
		AttackBtn.y=timersprite.y-44
		gcm:insert( AttackBtn )
		
		MagicBtn=display.newImageRect("combataction3.png",342,86)
		MagicBtn.x = timersprite.x+172
		MagicBtn.y = AttackBtn.y
		gcm:insert( MagicBtn )
		
		RunBtn=display.newImageRect("combataction3.png",342,86)
		RunBtn.x = MagicBtn.x
		RunBtn.y = timersprite.y+44
		gcm:insert( RunBtn )
		
		timersprite:toFront()
		
		RunAttempt()
	end
	
	RunBtn= widget.newButton{
		label="Retreat",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="combataction.png",
		overFile="combataction2.png",
		width=342, height=86,
		onRelease = toRun}
	RunBtn:setReferencePoint( display.CenterReferencePoint )
	RunBtn.x = MagicBtn.x
	RunBtn.y = timersprite.y+44
	gcm:insert( RunBtn )
	
	timersprite:toFront()
end

function MobsTurn()
	etimer=nil
	timersprite:pause()
	local pp=timer.pause(ptimer)
	MobSprite(2)
	local isHit=EvadeCalc("p1",16)
	if isHit>=(p1.stats[5]/6)*2 then
		if isHit>=(p1.stats[5]/3)*5 then
			local Damage=DamageCalc("p1",(math.random(15,20)/10),16)
			if (Damage)<=0 then
				Hits("BLK!",false,false,false)
			else
				players.ReduceHP(Damage,"Mob")
				P1Sprite(3)
				Hits((Damage),true,false,false)
				UpdateStats()
			end
		else
			local Damage=DamageCalc("p1",1,16)
			if (Damage)<=0 then
				Hits("BLK!",false,false,false)
			else
				players.ReduceHP(Damage,"Mob")
				P1Sprite(3)
				Hits((Damage),false,false,false)
				UpdateStats()
			end
		end
	else
		Hits("MSS!",false,false,false)
	end
	if enemy.status=="BRN" then
		if BurnLimit>0 then
			local Burn=(math.floor(enemy.MaxHP*.05))
			enemy.HP=enemy.HP-Burn
			UpdateStats()
			BurnLimit=BurnLimit-1
			Hits((Burn),false,true,"BRN")
				UpdateStats()
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
			UpdateStats()
			Hits((Poison),false,true,"PSN")
				UpdateStats()
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
		EndTurn()
	end
end

function MoveSprites()
	if inCombat==true then
		if movcd==nil then
			movcd=0
		end
		--Enemy
		if (esprite.y==70) then
			esprite.y=esprite.y+1
		elseif (esprite.y==180) then
			esprite.y=esprite.y-1
		elseif movcd==0 then
			if psprite.y+10>esprite.y and psprite.y-10<esprite.y then
				movcd=math.random(100,350)
				movetar=math.random(71,179)
				movptar=math.random(71,179)
			elseif psprite.y>esprite.y then
				esprite.y=esprite.y+1
			elseif psprite.y<esprite.y then
				esprite.y=esprite.y-1
			end
		else
			if esprite.y>movetar then
				esprite.y=esprite.y-1
			elseif esprite.y<movetar then
				esprite.y=esprite.y+1
			end
		end
		
		--Player
		if (psprite.y==70) then
			psprite.y=psprite.y+1
		elseif (psprite.y==180) then
			psprite.y=psprite.y-1
		elseif movcd==0 then
			if psprite.y+10>esprite.y and psprite.y-10<esprite.y then
				movcd=math.random(20,50)
				movetar=math.random(71,179)
				movptar=math.random(71,179)
			elseif psprite.y<esprite.y then
				psprite.y=psprite.y+1
			elseif psprite.y>esprite.y then
				psprite.y=psprite.y-1
			end
		else
			movcd=movcd-1
			if psprite.y>movptar then
				psprite.y=psprite.y-1
			elseif psprite.y<movptar then
				psprite.y=psprite.y+1
			end
		end
		if (block) then
			block.y=psprite.y+(256/5)
		end
		movtimer=timer.performWithDelay(20,MoveSprites)
	end
end

function MobSprite(value)
	if inCombat==true then
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
				esprite.y=170
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
				esprite.y=170
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
				esprite.y=170
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
		if (value~=1)and(value~=2)and(value~=3)and(value~=4)then--Go Default
			if (esprite)and(esprite.sequence~="walk")then
				if (esprite.frame==esprite.numFrames)then
					esprite:setSequence( "walk" )
					esprite:play()
				else
					timer.performWithDelay(20,MobSprite)
				end
			end
		end
	end
end

function P1Sprite(value)
	if inCombat==true then
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
				psprite.x=(display.contentWidth/2)-50
				psprite.y=170
				psprite.xScale=3.0
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
				psprite.x=(display.contentWidth/2)-50
				psprite.y=170
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
				psprite.x=(display.contentWidth/2)-50
				psprite.y=170
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
				psprite.x=(display.contentWidth/2)-50
				psprite.y=170
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
				psprite.x=(display.contentWidth/2)-50
				psprite.y=170
				psprite.xScale=4.0
				psprite.yScale=psprite.xScale
				psprite:play()
				gcm:insert(psprite)
			end
		end
		if (value)==(2) then--Change to Hit
			local hat=math.random(1,3)
			if hat==1 then
				psprite:setSequence( "hit1" )
			elseif hat==2 then
				psprite:setSequence( "hit2" )
			else
				psprite:setSequence( "hit3" )
			end
			psprite:play()
		end
		if (value)==(3) then--Change to Hurt
			psprite:setSequence( "hurt" )
			psprite:play()
		end
		if (value)==(4) then--Set to Casting
			psprite:setSequence( "cast" )
			psprite:play()
		end
		if (value~=1)and(value~=2)and(value~=3)and(value~=4) then--Go Default
			if (psprite)and(psprite.sequence~="walk")then
				if (psprite.frame==psprite.numFrames)or(psprite.sequence=="cast")then
					psprite:setSequence( "walk" )
					psprite:play()
				else
					timer.performWithDelay(20,P1Sprite)
				end
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
	enemy.classnames={"Gladiator","Berserker","Gladiator","Wizard","Berserker"}
	enemy.classname=enemy.classnames[enemy.class]
	MobSprite(1)
	enemy.MaxHP=(100*enemy.lvl)+(enemy.stats[1]*10)
	enemy.MaxMP=(enemy.lvl*15)+(enemy.stats[4]*10)
	enemy.HP=enemy.MaxHP
	enemy.MP=enemy.MaxMP
	enemy.SPD=(1.00-(enemy.stats[5]/100))
	
	UpdateStats()
end

function UpdateStats()
	if not(Created)then
		Created=true
		--Mob
	-- Life
		hpBar=display.newSprite( hpsheet, { name="hpsheet", start=1, count=67, time=(1800) })
		hpBar.yScale=1.25
		hpBar.xScale=hpBar.yScale
		hpBar.x = xCoord+110
		hpBar.y = yCoord-135
		hpBar:toFront()
		gcm:insert(hpBar)
		hpBar:setFrame(math.floor(( (enemy.HP/enemy.MaxHP)*66 )+1))
		
		LifeSymbol=display.newSprite( heartsheet, { name="heart", start=1, count=16, time=(1800) })
		LifeSymbol.yScale=3.25
		LifeSymbol.xScale=LifeSymbol.yScale
		LifeSymbol.x = xCoord-10
		LifeSymbol.y = hpBar.y
		LifeSymbol:play()
		LifeSymbol:toFront()
		gcm:insert(LifeSymbol)
		
		LifeDisplay = display.newText( (enemy.HP.."/"..enemy.MaxHP), 0, 0, "Game Over", 75 )
		LifeDisplay:setTextColor( 0, 0, 0)
		LifeDisplay.x = LifeSymbol.x+140
		LifeDisplay.y = LifeSymbol.y-5
		LifeDisplay:toFront()
		gcm:insert(LifeDisplay)
		

	-- Level
		
		statusdisplay=display.newSprite( statussheet, { name="status", start=1, count=6, time=800 }  )
		statusdisplay.yScale=0.75
		statusdisplay.xScale=statusdisplay.yScale
		statusdisplay.x = LifeDisplay.x-150
		statusdisplay.y = LifeDisplay.y+40
		gcm:insert(statusdisplay)
		
		LvlDisplay = display.newText( ("Lv: "..enemy.lvl), 0, 0, "Game Over", 75 )
		LvlDisplay:setTextColor( 50, 255, 50)
		LvlDisplay.x = LifeSymbol.x-80
		LvlDisplay.y = LifeDisplay.y
		LvlDisplay:toFront()
		gcm:insert(LvlDisplay)
		
		classdisplay= display.newText( (""..enemy.classname), 0, 0, "Game Over", 75 )
		classdisplay:setTextColor( 0, 0, 0)
		classdisplay.x = statusdisplay.x+150
		classdisplay.y = statusdisplay.y
		gcm:insert(classdisplay)
		--Player
	-- Life
		hpBar2=display.newSprite( hpsheet, { name="hpsheet", start=1, count=67, time=(1800) })
		hpBar2.yScale=1.25
		hpBar2.xScale=hpBar2.yScale
		hpBar2.x = 140
		hpBar2.y = yCoord-135
		hpBar2:toFront()
		gcm:insert(hpBar2)
		hpBar2:setFrame(math.floor(( (p1.HP/p1.MaxHP)*66 )+1))
		
		LifeSymbol2=display.newSprite( heartsheet, { name="heart", start=1, count=16, time=(1800) })
		LifeSymbol2.yScale=3.25
		LifeSymbol2.xScale=LifeSymbol2.yScale
		LifeSymbol2.x = 260
		LifeSymbol2.y = hpBar2.y
		LifeSymbol2:play()
		LifeSymbol2:toFront()
		gcm:insert(LifeSymbol2)
		
		LifeDisplay2 = display.newText( (p1.HP.."/"..p1.MaxHP), 0, 0, "Game Over", 75 )
		LifeDisplay2:setTextColor( 0, 0, 0)
		LifeDisplay2.x = LifeSymbol2.x-140
		LifeDisplay2.y = LifeSymbol2.y-5
		LifeDisplay2:toFront()
		gcm:insert(LifeDisplay2)
	--Mana

		mpBar2=display.newSprite( mpsheet, { name="mpsheet", start=1, count=67, time=(1800) })
		mpBar2.yScale=1.25
		mpBar2.xScale=mpBar2.yScale
		mpBar2.x = 140
		mpBar2.y = yCoord-95
		mpBar2:toFront()
		gcm:insert(mpBar2)
		mpBar2:setFrame(math.floor(( (p1.HP/p1.MaxHP)*66 )+1))
		
		ManaSymbol2=display.newSprite( manasheet, { name="mana", start=1, count=3, time=(500) })
		ManaSymbol2.yScale=0.9
		ManaSymbol2.xScale=ManaSymbol2.yScale
		ManaSymbol2.x = 260
		ManaSymbol2.y = mpBar2.y
		ManaSymbol2:play()
		ManaSymbol2:toFront()
		gcm:insert(ManaSymbol2)
		
		ManaDisplay2 = display.newText( (p1.MP.."/"..p1.MaxMP), 0, 0, "Game Over", 75 )
		ManaDisplay2:setTextColor( 0, 0, 0)
		ManaDisplay2.x = ManaSymbol2.x-140
		ManaDisplay2.y = ManaSymbol2.y-5
		ManaDisplay2:toFront()
		gcm:insert(ManaDisplay2)
	-- Level
		--[[
		statusdisplay2=display.newSprite( statussheet, { name="status", start=1, count=6, time=800 }  )
		statusdisplay2.yScale=0.75
		statusdisplay2.xScale=statusdisplay2.yScale
		statusdisplay2.x = LifeDisplay2.x-30
		statusdisplay2.y = LifeDisplay2.y+45
		gcm:insert(statusdisplay2)
		statusdisplay2:play()
		]]
	else
		if p1.MP<0 then
			p1.MP=0
		end
		if p1.HP<0 then
			p1.HP=0
		end
		if enemy.HP<0 then
			enemy.HP=0
		end
		ManaDisplay2.text=(p1.MP.."/"..p1.MaxMP)
		LifeDisplay2.text=(p1.HP.."/"..p1.MaxHP)
		LifeDisplay.text=(enemy.HP.."/"..enemy.MaxHP)
		mpBar2:setFrame(math.floor(( (p1.MP/p1.MaxMP)*66 )+1))
		hpBar2:setFrame(math.floor(( (p1.HP/p1.MaxHP)*66 )+1))
		hpBar:setFrame(math.floor(( (enemy.HP/enemy.MaxHP)*66 )+1))
		MobSprite()
		P1Sprite()
	end
end

function InTrouble()
	return inCombat
end

function RunAttempt()
	ShowSorcery(true)
	local RunChance,MaxChance=EvadeCalc("mob",48)
	if RunChance>=(enemy.stats[5]/3) or MaxChance<(enemy.stats[5]/3)*2 then
		EndCombat("Ran")
	else
		EndTurn()
	end
end

function PlayerAttacks()
	P1Sprite(2)
	ShowSorcery(true)
	local isHit=EvadeCalc("mob",16)
	if isHit>=(enemy.stats[5]/6)*2 then
		if isHit>=(enemy.stats[5]/3)*5 then
			local Damage=DamageCalc("mob",(math.random(15,20)/10),16)
			if (Damage)<=0 then
				Hits("BLK!",false,true,false)
			else
				enemy.HP=enemy.HP-Damage
				MobSprite(3)
				UpdateStats()
				Hits((Damage),true,true,false)
			end
		else
			local Damage=DamageCalc("mob",1,16)
			if (Damage)<=0 then
				Hits("BLK!",false,true,false)
			else
				enemy.HP=enemy.HP-Damage
				MobSprite(3)
				UpdateStats()
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
	end
	EndTurn()
end

function EndTurn()
	if p1.HP>0 and enemy.HP>0 then
		if ptimer==nil then
			ptimer=timer.performWithDelay(1000+(1500*p1.SPD),ShowActions)
			if (ptimer)then
				timer.resume(etimer)
				timersprite:play()
			else
				timer.performWithDelay(20,EndTurn)
			end
		elseif etimer==nil then
			etimer=timer.performWithDelay(1000+(1500*enemy.SPD),MobsTurn)
			if (etimer)then
				timer.resume(ptimer)
				if timersprite.frame~=timersprite.numFrames then
					timersprite:play()
				end
			else
				timer.performWithDelay(20,EndTurn)
			end
		end
		MobSprite()
		P1Sprite()
	end
end

function EndCombat(outcome)
	inCombat=false
	gcm:insert(HitGroup)
	for i=gcm.numChildren,1,-1 do
		display.remove(gcm[i])
		gcm[i]=nil
	end
	gcm=nil
	Created=nil
	
	if outcomed==false then
		
		outcomed=true
		Runtime:addEventListener("enterFrame", gp.GoldDisplay)
		Runtime:addEventListener("enterFrame", players.ShowStats)
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
			
			OMenu=display.newImageRect("usemenu.png", 768, 308)
			OMenu.x,OMenu.y = display.contentWidth*0.5, 450
			gom:insert(OMenu)	
			
			local msg=display.newText("Got away safely!",0,0, "Game Over", 150)
			msg.x = display.contentWidth/2
			msg.y = OMenu.y-80
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
			OKBtn.y = OMenu.y+80
			gom:insert(OKBtn)
		end
	end
end

function AcceptOutcome()
	Runtime:removeEventListener("enterFrame", NoMansLand)
	
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
	mov.ShowArrows()
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
		hits[#hits].x=(display.contentWidth/2)-75
		hits[#hits].y=(display.contentHeight/4)*1
		hits[#hits]:setLinearVelocity(100,-300)
	elseif target==true then
		hits[#hits].x=(display.contentWidth/2)+75
		hits[#hits].y=(display.contentHeight/4)*1
		hits[#hits]:setLinearVelocity(-100,-300)
	end
	HitGroup:insert( hits[#hits] )
	HitGroup:toFront()
end

function GetHits()
	return hits
end

function ShowSorcery(comm)
	if comm==true then
		if SBookDisplayed==true then
			function deletion()
				display.remove(SorceryUI)
			end
			transition.to(SorceryUI, {time=(100*(#Sorcery)), y=(SorceryUI.y+(50+((#Sorcery)*44))),transition = easing.inExpo,onComplete=deletion})
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
			for s=1, table.maxn(p1.spells) do
				if p1.spells[s][3]==true then
					function toCast()
						CastSorcery(p1.spells[s][1])
					end
					Sorcery[#Sorcery+1]=display.newText( (p1.spells[s][1].."  "..p1.spells[s][4].." MP"), SorcIniX, (SorcIniY-((#Sorcery-1)*50)), "Viner Hand ITC", 40)
					Sorcery[#Sorcery]:setTextColor(50,50,50)
					if (p1.spells[s][4])>p1.MP then
						Sorcery[#Sorcery]:setTextColor(180,60,60)
					else
						Sorcery[#Sorcery]:addEventListener("tap",toCast)
					end						
					Sorcery[#Sorcery].isVisible=false
				end
			end
			if table.maxn(Sorcery)==0 then
				Sorcery[#Sorcery+1]=display.newText( ("No known Sorcery."), SorcIniX, (SorcIniY-((#Sorcery-1)*40)), "Viner Hand ITC", 40)
				Sorcery[#Sorcery]:setTextColor(120,120,120)
				Sorcery[#Sorcery].isVisible=false
			end
			
			SorceryUI=display.newImageRect("scrollui4.png", 460, 600)
			SorceryUI.x, SorceryUI.y = display.contentCenterX, display.contentHeight+300
			transition.to(SorceryUI, {time=(100*(#Sorcery)), y=(SorceryUI.y-(50+((#Sorcery)*44))),transition = easing.inExpo,onComplete=finishSpells})
			SBookDisplayed=true
		elseif SBookDisplayed==true then
			function deletion()
				display.remove(SorceryUI)
			end
			transition.to(SorceryUI, {time=(100*(#Sorcery)), y=(SorceryUI.y+(50+((#Sorcery)*44))),transition = easing.inExpo,onComplete=deletion})
			for i=table.maxn(Sorcery),1,-1 do
				display.remove(Sorcery[i])
				Sorcery[i]=nil
			end
			SBookDisplayed=false
		end
	end
end

function CastSorcery(name)
	P1Sprite(4)
	ShowSorcery(true)
	display.remove(AttackBtn)
	display.remove(MagicBtn)
	display.remove(RunBtn)
	
	AttackBtn=display.newImageRect("combataction3.png",342,86)
	AttackBtn.x=timersprite.x-172
	AttackBtn.y=timersprite.y-44
	gcm:insert( AttackBtn )
	
	MagicBtn=display.newImageRect("combataction3.png",342,86)
	MagicBtn.x = timersprite.x+172
	MagicBtn.y = AttackBtn.y
	gcm:insert( MagicBtn )
	
	RunBtn=display.newImageRect("combataction3.png",342,86)
	RunBtn.x = MagicBtn.x
	RunBtn.y = timersprite.y+44
	gcm:insert( RunBtn )
	
	timersprite:toFront()
	
	for s=1, table.maxn(p1.spells) do
		if p1.spells[s][1]==name then
			p1.MP=p1.MP-p1.spells[s][4]
		end
	end
	if name=="Cleave" then
		local Damage=MagicCalc((math.random(15,20)/10),22)
		Hits((Damage),true,true,"SPL")
		enemy.HP=enemy.HP-Damage
		MobSprite(3)
		if enemy.HP<=0 then
			if enemy.HP<0 then
				enemy.HP=0
			end
			function closure()
				EndCombat("Win")
			end
			timer.performWithDelay(200,closure)
		end
		UpdateStats()
		
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
		end
		UpdateStats()
		
	elseif name=="Fire Sword" then
	
		local isHit=EvadeCalc("mob",32)
		if isHit>=(enemy.stats[5]/6)*2 then
			local Damage=MagicCalc((math.random(15,20)/10),22)
			if (Damage)<=0 then
				Hits("BLK!",false,true,"SPL")
			else
				enemy.status="BRN"
				Hits(("Burn!"),false,true,"SPL")
				enemy.HP=enemy.HP-Damage
				MobSprite(3)
				statusdisplay:setFrame(3)
				UpdateStats()
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
		end
		UpdateStats()
		
	elseif name=="Fireball" then
	
		local isHit=EvadeCalc("mob",32)
		if isHit>=(enemy.stats[5]/6)*2 then
			if isHit>=(enemy.stats[5]/3)*5 then
				local Damage=MagicCalc((math.random(15,20)/10),22)
				if (Damage)<=0 then
					Hits("BLK!",false,true,"SPL")
				else
					enemy.status="BRN"
					Hits(("Burn!"),false,true,"SPL")
					enemy.HP=enemy.HP-Damage
					MobSprite(3)
					statusdisplay:setFrame(3)
					UpdateStats()
					BurnLimit=p1.stats[4]+2
					if BurnLimit>15 then
						BurnLimit=15
					end
					Hits((Damage),true,true,"SPL")
				end
			else
				local Damage=MagicCalc(1,22)
				if (Damage)<=0 then
					Hits("BLK!",false,true,"SPL")
				else
					enemy.status="BRN"
					Hits(("Burn!"),false,true,"SPL")
					enemy.HP=enemy.HP-Damage
					MobSprite(3)
					statusdisplay:setFrame(3)
					UpdateStats()
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
		end
		UpdateStats()
		
	elseif name=="Ice Sword" then
	
		local isHit=EvadeCalc("mob",32)
		if isHit>=(enemy.stats[5]/6)*2 then
			local Damage=MagicCalc((math.random(15,20)/10),22)
			if (Damage)<=0 then
				Hits("BLK!",false,true,"SPL")
			else
				enemy.stats[5]=enemy.stats[5]-(math.floor(enemy.stats[5]*.2))
				Hits(("Slowed!"),false,true,"SPL")
				enemy.HP=enemy.HP-Damage
				MobSprite(3)
				UpdateStats()
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
		end
		UpdateStats()
		
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
		end
		UpdateStats()
		
	elseif name=="Poison Blade" then
	
		local isHit=EvadeCalc("mob",32)
		if isHit>=(enemy.stats[5]/6)*2 then
			if isHit>=(enemy.stats[5]/3)*5 then
				local Damage=MagicCalc((math.random(15,20)/10),22)
				if (Damage)<=0 then
					Hits("BLK!",false,true,"SPL")
				else
					enemy.status="PSN"
					Hits(("Poison!"),false,true,"SPL")
					enemy.HP=enemy.HP-Damage
					MobSprite(3)
					statusdisplay:setFrame(5)
					UpdateStats()
					Hits((Damage),true,true,"SPL")
				end
			else
				local Damage=MagicCalc(1,22)
				if (Damage)<=0 then
					Hits("BLK!",false,true,"SPL")
				else
					enemy.status="PSN"
					Hits(("Poison!"),false,true,"SPL")
					enemy.HP=enemy.HP-Damage
					MobSprite(3)
					statusdisplay:setFrame(5)
					UpdateStats()
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
		end
		UpdateStats()
	end
	EndTurn()
end

function NoMansLand()
	for h=1,table.maxn(hits) do
		if (hits[h]) and (hits[h].y) then
			if hits[h].y>=280 then
				display.remove(hits[h])
			end
		end
	end
end

function MagicCalc(crit,cmd)
	local Damage
	Damage=(
		((p1.stats[4]*1.5)-enemy.stats[3])*5
	)
	Damage=(
		((Damage*cmd/16)*crit)
	)
	Damage=(
		Damage*((math.random((10+(p1.stats[4]*0.5)),(10+(p1.stats[4]*1.5))))/10)
	)
	Damage=(Damage*0.65)
	Damage=math.floor(Damage)
	return Damage
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
		Damage=(
			Damage*((math.random((10+(enemy.stats[2]*0.5)),(10+(enemy.stats[2]*1.5))))/10)
		)
		Damage=(Damage*0.65)
		Damage=math.floor(Damage)
	elseif tar=="mob" then
		Damage=(
			((p1.stats[2]*1.5)-enemy.stats[3])*5
		)
		Damage=(
			((Damage*cmd/16)*crit)
		)
		Damage=(
			Damage*((math.random((10+(p1.stats[2]*0.5)),(10+(p1.stats[2]*1.5))))/10)
		)
		Damage=(Damage*0.65)
		Damage=math.floor(Damage)
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
		Chance=Chance*1.5
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
		Chance=Chance*1.5
		MaxChance=(
			((p1.stats[5]*1.5)-enemy.stats[5])
		)
		MaxChance=(
			(MaxChance*cmd/16)
		)
		MaxChance=(
			MaxChance*((10+(p1.stats[5]*1.5))/10)
		)
		MaxChance=MaxChance*1.5
	--	print (Chance.."/"..MaxChance)
	end
	if tar=="mob" then
		return Chance,MaxChance
	else
		return Chance
	end
end
