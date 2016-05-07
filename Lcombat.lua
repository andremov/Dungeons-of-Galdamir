-----------------------------------------------------------------------------------------
--
-- combat.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local energysheet = graphics.newImageSheet( "energysprite.png", { width=60, height=60, numFrames=4 })
local heartsheet = graphics.newImageSheet( "heartsprite.png", { width=25, height=25, numFrames=16 })
local stadef = graphics.newImageSheet( "enemy/stadef.png",{ width=140, height=110, numFrames=15 })
local manasheet = graphics.newImageSheet( "manasprite.png", { width=60, height=60, numFrames=3 })
local dexatt = graphics.newImageSheet( "enemy/dexatt.png",{ width=64, height=64, numFrames=12 })
local mgcint = graphics.newImageSheet( "enemy/mgcint.png",{ width=90, height=80, numFrames=12 })
local statussheet = graphics.newImageSheet( "status.png", { width=80, height=80, numFrames=8 })
local timersheet = graphics.newImageSheet( "timer.png",{ width=100, height=100, numFrames=25})
local psheet = graphics.newImageSheet( "player.png", { width=24, height=32, numFrames=24 } )
local hpsheet = graphics.newImageSheet("hp.png",{ width=200, height=30, numFrames=67 })
local mpsheet = graphics.newImageSheet("mp.png",{ width=200, height=30, numFrames=67 })
local epsheet = graphics.newImageSheet("ep.png",{ width=200, height=30, numFrames=67 })
local p1sprite={player1,player2,player3,player4}
local xCoord=display.contentWidth-250
local yCoord=510
local builder=require("Lmapbuilder")
local players=require("Lplayers")
local physics = require "physics"
local widget = require "widget"
local mov=require("Lmovement")
local WD=require("Lprogress")
local audio=require("Laudio")
local win=require("Lwindow")
local item=require("Litems")
local mob=require("Lmobai")
local q=require("Lquest")
local gp=require("Lgold")
local m=require("Lmenu")
local ui=require("Lui")
local timersprite
local Automatic
<<<<<<< HEAD
local Spellbook
local SorceryUI
=======
>>>>>>> G1.2.0
local inCombat
local ptimer
local etimer
local CMenu
local OMenu
local enemy
local modif
local hits
local gcm
local gom
<<<<<<< HEAD
=======
local pseqs={
		{name="stand1", start=1,  count=1, time=1000},
		{name="stand2", start=2,  count=1, time=1000},
		{name="stand3", start=3,  count=1, time=1000},
		{name="stand4", start=4,  count=1, time=1000},
		{name="walk1",  start=5,  count=4, time=1000},
		{name="walk2",  start=9,  count=4, time=1000},
		{name="walk3",  start=13, count=4, time=1000},
		{name="walk4",  start=17, count=4, time=1000},
		{name="stance",   start=21, count=2, time=1000},
		{name="hit",   start=23, count=1, time=1000},
		{name="hurt",   start=24, count=1, time=1000},
	}
>>>>>>> G1.2.0

function InTrouble()
	if inCombat==true or outcomed==true then
		return true
	else
		return false
	end
end

function Essentials()
	inCombat=false
	outcomed=false
<<<<<<< HEAD
	yinvicial=180
	xinvicial=75
	Automatic=0
	espaciox=64
	espacioy=64
	Sorcery={}
=======
	yinvicial=display.contentHeight-180
	xinvicial=display.contentCenterX-((48*3)+4+2)
	Automatic=0
	espacio=64
	book=false
>>>>>>> G1.2.0
	inv=false
end

function Attacking(victim)
	if inCombat==false then
		enemy=victim
		if (enemy) then
			inCombat=true
			modif=1
			DisplayCombat()
		else
			print "!E"
			timer.performWithDelay(20,mov.Visibility)
		end
	end
end

function Attacked(victim)
	if inCombat==false then
		enemy=victim
		if (enemy) then
			inCombat=true
			modif=0.1
			DisplayCombat()
		else
			print "!E"
			timer.performWithDelay(20,mov.Visibility)
		end
	end
end

function DisplayCombat()
	Runtime:removeEventListener("enterFrame", players.ShowStats)
	Runtime:removeEventListener("enterFrame", gp.GoldDisplay)
	Runtime:addEventListener("enterFrame", ManageHits)
	mov.CleanArrows()
	players.CalmDownCowboy(false)
	audio.changeMusic(3)
	gcm=display.newGroup()
	hits={}
	m.FindMe(7)
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
	
	window2=display.newImage("window2.png",171,43)
	window2.x=display.contentWidth-192
	window2.y=yCoord-120
	window2.xScale=2.25
	window2.yScale=window2.xScale
	gcm:insert(window2)
	
	window1=display.newImage("window.png",171,65)
	window1.x=192
	window1.y=window2.y+26
	window1.xScale=window2.xScale
	window1.yScale=window1.xScale
	gcm:insert(window1)

	
	gcm:toFront()	
	CreateMobStats()
	p1=players.GetPlayer()
	
	--Sprites
	P1Sprite(1)
	MoveSprites()
	
	--Timers
	timersprite=display.newSprite( timersheet, { name="timerid", start=1, count=25, loopCount=1, time=1000+(1500*p1.SPD)}  )
	timersprite.x=display.contentCenterX
	timersprite.y=display.contentCenterY+100
	timersprite:play()
	gcm:insert(timersprite)
	
	HideActions()
	
	ptimer=timer.performWithDelay((1000+(1500*p1.SPD)),ShowActions)
	etimer=timer.performWithDelay((1001+(1500*enemy.SPD))*modif,MobsTurn)
	modif=1
end

function CreateMobStats()
	p1=players.GetPlayer()
	local size=builder.GetData(0)
	local col=(math.floor(enemy.loc%(math.sqrt(size))))
	local row=(math.floor(enemy.loc/(math.sqrt(size))))+1
	local zonas=math.ceil((math.sqrt(size))/10)
	local round=WD.Circle()
	
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
		if enemy.room~=1 then
			local roomx=math.floor((enemy.room-1)%5)
			local roomy=math.floor((enemy.room-1)/5)
			local maxroom
			if roomx>roomy then
				maxroom=roomx
			else
				maxroom=roomy
			end
			enemy.lvl=enemy.lvl+(zonas*maxroom)
		end
	end
	if not (enemy.stats) then
		enemy.stats={}
		for s=1,6 do
			enemy.stats[s]=2
		end
		enemy.status=false
		enemy.pnts=(4.5*enemy.lvl)
		enemy.pnts=math.floor(enemy.pnts+1)
		for i=1,enemy.pnts do
			enemy.min=math.min(enemy.stats[1],enemy.stats[2],enemy.stats[3],enemy.stats[4],enemy.stats[5],enemy.stats[6])
			local astats={}
			for i=1,6 do
				if enemy.stats[i]>enemy.min+5 then
					astats[i]=0
				else
					astats[i]=1
				end
			end
			function DoneIt()
				local statroll=math.random(1,6)
				if astats[statroll]==1 then
					enemy.stats[statroll]=enemy.stats[statroll]+1
				else
					DoneIt()
				end
			end
			DoneIt()
		end
	end
	enemy.max=math.max(enemy.stats[1],enemy.stats[2],enemy.stats[3],enemy.stats[4],enemy.stats[5],enemy.stats[6])
	for i=1,6 do
		if enemy.stats[i]==enemy.max then
			enemy.class=i
		end
	end
	enemy.classnames={"Gladiator","Berserker","Gladiator","Wizard","Berserker","Wizard"}
	enemy.classname=enemy.classnames[enemy.class]
	MobSprite(1)
	enemy.MaxHP=(10*enemy.lvl)+(enemy.stats[1]*(15+math.random(1,7)))
	enemy.HP=enemy.MaxHP
	enemy.SPD=(1.00-(enemy.stats[5]/100))
	
	UpdateStats()
end

function HideActions()
	
	if Automatic==true then
		Automatic=0
	end
	
	if (AttackBtn) then
		display.remove(AttackBtn)
	end
	
	if (MagicBtn) then
		display.remove(MagicBtn)
	end
	
	if (ItemBtn) then
		display.remove(ItemBtn)
	end
	
	if (RecoverBtn) then
		display.remove(RecoverBtn)
	end
	
	if (AutoRecoverBtn) then
		display.remove(AutoRecoverBtn)
	end
	
<<<<<<< HEAD
	if (GuardBtn) then
		display.remove(GuardBtn)
=======
	if (SpellBtn) then
		display.remove(SpellBtn)
>>>>>>> G1.2.0
	end
	
	if (BackBtn) then
		display.remove(BackBtn)
	end
	
	if (AutoRunBtn) then
		display.remove(AutoRunBtn)
	end
	
<<<<<<< HEAD
=======
	if (AutoTxt) then
		display.remove(AutoTxt)
	end
	
	if (AutoTxt2) then
		display.remove(AutoTxt2)
	end
	
	if (AutoWin) then
		display.remove(AutoWin)
	end
	
>>>>>>> G1.2.0
	AttackBtn=display.newImageRect("combataction3.png",342,86)
	AttackBtn.x=timersprite.x-172
	AttackBtn.y=timersprite.y-44
	gcm:insert( AttackBtn )
	
	MagicBtn=display.newImageRect("combataction3.png",342,86)
	MagicBtn.x = timersprite.x+172
	MagicBtn.y = AttackBtn.y
	gcm:insert( MagicBtn )
	
	ItemBtn=display.newImageRect("combataction3.png",342,86)
	ItemBtn.x = MagicBtn.x
	ItemBtn.y = timersprite.y+44
	gcm:insert( ItemBtn )
	
	SpellBtn=display.newImageRect("combataction3.png",342,86)
	SpellBtn.x = AttackBtn.x
	SpellBtn.y = ItemBtn.y
	gcm:insert( SpellBtn )
	
	RecoverBtn=display.newImageRect("combataction3.png",342,86)
	RecoverBtn.x = AttackBtn.x
	RecoverBtn.y = ItemBtn.y+88
	gcm:insert( RecoverBtn )
	
	BackBtn=display.newImageRect("combataction3.png",342,86)
	BackBtn.x = MagicBtn.x
	BackBtn.y = RecoverBtn.y
	gcm:insert( BackBtn )
	
	AutoWin=display.newRect(0,0,400,60)
	AutoWin:setFillColor(0,0,0,0)
	AutoWin.x=display.contentCenterX
	AutoWin.y=RecoverBtn.y+88
	gcm:insert( AutoWin )
	AutoWin:addEventListener("tap",AutoToggle)
	
	AutoTxt=display.newText("Automatic Actions:",0,0,"MoolBoran",55)
	AutoTxt.x=display.contentCenterX-40
	AutoTxt.y=AutoWin.y+10
	gcm:insert( AutoTxt )
	
	if Automatic~=0 then
		AutoTxt2=display.newText("On",0,0,"MoolBoran",55)
		AutoTxt2:setTextColor(70,255,70)
		AutoTxt2.x=AutoTxt.x+190
		AutoTxt2.y=AutoTxt.y
		gcm:insert( AutoTxt2 )
	else
		AutoTxt2=display.newText("Off",0,0,"MoolBoran",55)
		AutoTxt2:setTextColor(255,70,70)
		AutoTxt2.x=AutoTxt.x+190
		AutoTxt2.y=AutoTxt.y
		gcm:insert( AutoTxt2 )
	end
	
	timersprite:toFront()
end

function ShowActions()
	ptimer=nil
	local ep=timer.pause(etimer)
	
<<<<<<< HEAD
	if Automatic==0 then
=======
	if Automatic==0 or Automatic==true then
>>>>>>> G1.2.0
	
		if isDefend==true then
			P1Sprite()
			p1.stats[3]=p1.stats[3]/1.5
			isDefend=false
		end
		
		if isRecover==true then
			P1Sprite()
			p1.stats[3]=p1.stats[3]/0.75
			isRecover=false
		end
	
		if (AttackBtn) then
			display.remove(AttackBtn)
			AttackBtn=nil
		end
		
		if (MagicBtn) then
			display.remove(MagicBtn)
			MagicBtn=nil
		end
		
		if (ItemBtn) then
			display.remove(ItemBtn)
			ItemBtn=nil
		end
		
		if (SpellBtn) then
			display.remove(SpellBtn)
			SpellBtn=nil
		end
		
		if (RecoverBtn) then
			display.remove(RecoverBtn)
			RecoverBtn=nil
		end
	
		if (AutoRecoverBtn) then
			display.remove(AutoRecoverBtn)
			AutoRecoverBtn=nil
		end
		
		if (BackBtn) then
			display.remove(BackBtn)
			BackBtn=nil
		end
		
<<<<<<< HEAD
		if (AutoRunBtn) then
			display.remove(AutoRunBtn)
			AutoRunBtn=nil
=======
		if (AutoTxt) then
			display.remove(AutoTxt)
			AutoTxt=nil
		end
		
		if (AutoTxt2) then
			display.remove(AutoTxt2)
			AutoTxt2=nil
		end
		
		if (AutoWin) then
			display.remove(AutoWin)
			AutoWin=nil
		end
	
		function AttackMe()
			SetAuto(1)
			HideActions()
			PlayerAttacks(0)
>>>>>>> G1.2.0
		end
		
		if not(AttackBtn)then
			AttackBtn= widget.newButton{
				label="Melee Attack",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=35,
				defaultFile="combataction.png",
				overFile="combataction2.png",
				width=342, height=86,
				onRelease = AttackMe}
			AttackBtn:setReferencePoint( display.CenterReferencePoint )
			AttackBtn.x = timersprite.x-172
			AttackBtn.y = timersprite.y-44
			gcm:insert( AttackBtn )
		end
		
		function AttackMa()
			SetAuto(2)
			HideActions()
			PlayerAttacks(1)
		end
	
		if not(MagicBtn)then
			MagicBtn= widget.newButton{
				label="Magic Attack",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=35,
				defaultFile="combataction.png",
				overFile="combataction2.png",
				width=342, height=86,
				onRelease = AttackMa}
			MagicBtn:setReferencePoint( display.CenterReferencePoint )
			MagicBtn.x = timersprite.x+172
			MagicBtn.y = AttackBtn.y
			gcm:insert( MagicBtn )
		end
		
		function toItems()
			HideActions()
			
			ShowBag()
		end
		
		if not(ItemBtn)then
			ItemBtn= widget.newButton{
				label="Inventory",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=35,
				defaultFile="combataction.png",
				overFile="combataction2.png",
				width=342, height=86,
				onRelease = toItems}
			ItemBtn:setReferencePoint( display.CenterReferencePoint )
			ItemBtn.x = MagicBtn.x
			ItemBtn.y = timersprite.y+44
			gcm:insert( ItemBtn )
		end
		
		function toSorcery()	
			HideActions()
			
			ShowSorcery()
		end
		
		if not(SpellBtn)then
			SpellBtn= widget.newButton{
				label="Spellbook",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=35,
				defaultFile="combataction.png",
				overFile="combataction2.png",
				width=342, height=86,
				onRelease = toSorcery}
			SpellBtn:setReferencePoint( display.CenterReferencePoint )
			SpellBtn.x = AttackBtn.x
			SpellBtn.y = ItemBtn.y
			gcm:insert( SpellBtn )
		end
		
		function toRecover()
			SetAuto(3)
			HideActions()
			Recover()
		end
		
		if not(RecoverBtn)then
			RecoverBtn= widget.newButton{
				label="Recover",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=35,
				defaultFile="combataction.png",
				overFile="combataction2.png",
				width=342, height=86,
				onRelease = toRecover}
			RecoverBtn:setReferencePoint( display.CenterReferencePoint )
			RecoverBtn.x = AttackBtn.x
			RecoverBtn.y = ItemBtn.y+88
			gcm:insert( RecoverBtn )
		end
		
		function toAutoRecover()
			HideActions()
			TurnOnAuto(3)
			Recover()
		end
		
		if not(AutoRecoverBtn)then
			AutoRecoverBtn= widget.newButton{
				label="Auto-Recover",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=35,
				defaultFile="extracombataction.png",
				overFile="extracombataction2.png",
				width=342, height=86,
				onRelease = toAutoRecover}
			AutoRecoverBtn:setReferencePoint( display.CenterReferencePoint )
			AutoRecoverBtn.x = RecoverBtn.x
			AutoRecoverBtn.y = RecoverBtn.y+68
			AutoRecoverBtn.xScale = 0.75
			AutoRecoverBtn.yScale = 0.75
			gcm:insert( AutoRecoverBtn )
		end
		
		function toRun()
			SetAuto(4)
			HideActions()
			RunAttempt()
		end
		
		if not(BackBtn)then
			BackBtn= widget.newButton{
				label="Retreat",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=35,
				defaultFile="combataction.png",
				overFile="combataction2.png",
				width=342, height=86,
				onRelease = toRun}
			BackBtn:setReferencePoint( display.CenterReferencePoint )
			BackBtn.x = MagicBtn.x
			BackBtn.y = RecoverBtn.y
			gcm:insert( BackBtn )
		end
		
<<<<<<< HEAD
		function toAutoRun()
			HideActions()
			TurnOnAuto(4)
			RunAttempt()
		end
		
		if not(AutoRunBtn)then
			AutoRunBtn= widget.newButton{
				label="Auto-Retreat",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=35,
				defaultFile="extracombataction.png",
				overFile="extracombataction2.png",
				width=342, height=86,
				onRelease = toAutoRun}
			AutoRunBtn:setReferencePoint( display.CenterReferencePoint )
			AutoRunBtn.x = BackBtn.x
			AutoRunBtn.y = BackBtn.y+68
			AutoRunBtn.xScale = 0.75
			AutoRunBtn.yScale = 0.75
			gcm:insert( AutoRunBtn )
=======
		if not(AutoWin)then
			AutoWin=display.newRect(0,0,400,60)
			AutoWin:setFillColor(0,0,0,0)
			AutoWin.x=display.contentCenterX
			AutoWin.y=RecoverBtn.y+88
			gcm:insert( AutoWin )
			AutoWin:addEventListener("tap",AutoToggle)
		end
		
		if not(AutoTxt)then
			AutoTxt=display.newText("Automatic Actions:",0,0,"MoolBoran",55)
			AutoTxt.x=display.contentCenterX-40
			AutoTxt.y=AutoWin.y+10
			gcm:insert( AutoTxt )
		end
		if not(AutoTxt2)then
			if Automatic~=0 then
				AutoTxt2=display.newText("On",0,0,"MoolBoran",55)
				AutoTxt2:setTextColor(70,255,70)
				AutoTxt2.x=AutoTxt.x+190
				AutoTxt2.y=AutoTxt.y
				gcm:insert( AutoTxt2 )
			else
				AutoTxt2=display.newText("Off",0,0,"MoolBoran",55)
				AutoTxt2:setTextColor(255,70,70)
				AutoTxt2.x=AutoTxt.x+190
				AutoTxt2.y=AutoTxt.y
				gcm:insert( AutoTxt2 )
			end
>>>>>>> G1.2.0
		end
	elseif Automatic==1 or Automatic==2 then
		PlayerAttacks(Automatic-1)
	elseif Automatic==3 then
		Recover()
	elseif Automatic==4 then
		RunAttempt()
	end
	timersprite:toFront()
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
			if (enemy.class==1) or (enemy.class==3) then
				--STA/DEF
				eseqs={
					{name="walk", start=1, count=3, time=1000},
					{name="hit", start=6, count=10, loopCount=1, time=1000},
					{name="hurt", start=5, count=1, time=1000}
				}
				esprite=display.newSprite( stadef, eseqs  )
				esprite:setSequence( "walk" )
				esprite.x=(display.contentWidth/2)+50
				esprite.y=170
				esprite.xScale=2.0
				esprite.yScale=esprite.xScale
				esprite:play()
				gcm:insert(esprite)
			elseif (enemy.class==2) or (enemy.class==5)then
				--ATT/DEX
				eseqs={
					{name="walk", start=1, count=4, time=1000},
					{name="hit", start=7, count=6, loopCount=1, time=1000},
					{name="hurt", start=6, count=1, time=1000},
				}
				esprite=display.newSprite( dexatt, eseqs  )
				esprite:setSequence( "walk" )
				esprite.x=(display.contentWidth/2)+50
				esprite.y=170
				esprite.xScale=2.5
				esprite.yScale=esprite.xScale
				esprite:play()
				gcm:insert(esprite)
			elseif (enemy.class)==(4) or (enemy.class)==(6) then
<<<<<<< HEAD
				--MGC
=======
				--MGC/INT
>>>>>>> G1.2.0
				eseqs={
					{name="walk", start=1, count=4, time=1000},
					{name="hit", start=7, count=6, loopCount=1, time=1000},
					{name="hurt", start=6, count=1, time=1000}
				}
				esprite=display.newSprite( mgcint, eseqs  )
				esprite:setSequence( "walk" )
				esprite.x=(display.contentWidth/2)+50
				esprite.y=170
				esprite.xScale=2.0
				esprite.yScale=esprite.xScale
				esprite:play()
				gcm:insert(esprite)
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
			psprite=display.newSprite( psheet, pseqs  )
			psprite:setSequence( "stance" )
			psprite.x=(display.contentWidth/2)-50
			psprite.y=170
			psprite.xScale=3.0
			psprite.yScale=psprite.xScale
			psprite:play()
			gcm:insert(psprite)
		end
		if (value)==(2) then--Change to Hit
			psprite:setSequence( "hit" )
			psprite:play()
		end
		if (value)==(3) then--Change to Hurt
			psprite:setSequence( "hurt" )
			psprite:play()
		end
		if (value)==(4) then--Set to Casting
			audio.Play(11)
			psprite:setSequence( "hit" )
			psprite:play()
		end
		if (value~=1)and(value~=2)and(value~=3)and(value~=4) then--Go Default
			if (psprite)and(psprite.sequence~="stance")then
				if (psprite.frame==psprite.numFrames)or(psprite.sequence=="cast")then
					psprite:setSequence( "stance" )
					psprite:play()
				else
					timer.performWithDelay(20,P1Sprite)
				end
			end
		end
	end
end

<<<<<<< HEAD
function AttackType()
	ShowSorcery(true)
	
	if (AttackBtn) then
		display.remove(AttackBtn)
		AttackBtn=nil
	end
	
	if (MagicBtn) then
		display.remove(MagicBtn)
		MagicBtn=nil
	end
	
	if (ItemBtn) then
		display.remove(ItemBtn)
		ItemBtn=nil
	end
	
	if (GuardBtn) then
		display.remove(GuardBtn)
		GuardBtn=nil
	end
	
	if (RecoverBtn) then
		display.remove(RecoverBtn)
		RecoverBtn=nil
	end
	
	if (AutoRecoverBtn) then
		display.remove(AutoRecoverBtn)
		AutoRecoverBtn=nil
	end
	
	if (BackBtn) then
		display.remove(BackBtn)
		BackBtn=nil
	end
	
	if (AutoRunBtn) then
		display.remove(AutoRunBtn)
		AutoRunBtn=nil
	end
	
	function AttackMe()
		HideActions()
		
		PlayerAttacks(0)
	end
	
	if not(AttackBtn)then
		AttackBtn= widget.newButton{
			label="Melee Attack",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=35,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = AttackMe}
		AttackBtn:setReferencePoint( display.CenterReferencePoint )
		AttackBtn.x = timersprite.x-172
		AttackBtn.y = timersprite.y-44
		gcm:insert( AttackBtn )
	end
	
	function AttackMa()
		HideActions()
		
		PlayerAttacks(1)
	end
	
	if not(MagicBtn)then
		MagicBtn= widget.newButton{
			label="Magic Attack",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=35,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = AttackMa}
		MagicBtn:setReferencePoint( display.CenterReferencePoint )
		MagicBtn.x = timersprite.x+172
		MagicBtn.y = AttackBtn.y
		gcm:insert( MagicBtn )
	end
	
	if not(MagicBtn)then
		MagicBtn= widget.newButton{
			label="Magic Attack",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=35,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = AttackMa}
		MagicBtn:setReferencePoint( display.CenterReferencePoint )
		MagicBtn.x = timersprite.x+172
		MagicBtn.y = AttackBtn.y
		gcm:insert( MagicBtn )
	end
	
	function AutomaticMe()
		HideActions()
		TurnOnAuto(1)
		PlayerAttacks(0)
	end
	
	if not(GuardBtn)then
		GuardBtn= widget.newButton{
			label="Auto-Melee Attack",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=35,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = AutomaticMe}
		GuardBtn:setReferencePoint( display.CenterReferencePoint )
		GuardBtn.x = AttackBtn.x
		GuardBtn.y = timersprite.y+44
		gcm:insert( GuardBtn )
	end
	
	function AutomaticMa()
		HideActions()
		TurnOnAuto(2)
		PlayerAttacks(1)
	end
	
	if not(ItemBtn)then
		ItemBtn= widget.newButton{
			label="Auto-Magic Attack",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=35,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = AutomaticMa}
		ItemBtn:setReferencePoint( display.CenterReferencePoint )
		ItemBtn.x = MagicBtn.x
		ItemBtn.y = timersprite.y+44
		gcm:insert( ItemBtn )
	end
	
	RecoverBtn=display.newImageRect("combataction3.png",342,86)
	RecoverBtn.x = AttackBtn.x
	RecoverBtn.y = ItemBtn.y+88
	gcm:insert( RecoverBtn )
	
	if not(BackBtn)then
		BackBtn=widget.newButton{
			label="Close",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=30,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = ShowActions}
		BackBtn:setReferencePoint( display.CenterReferencePoint )
		BackBtn.x = MagicBtn.x
		BackBtn.y = RecoverBtn.y
		gcm:insert( BackBtn )
	end
	
	timersprite:toFront()
end

function TurnOnAuto(auto)
	NoAutoBtn= widget.newButton{
		label="Manual Actions",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=35,
		defaultFile="combataction.png",
		overFile="combataction2.png",
		width=342, height=86,
		onRelease = TurnOffAuto}
	NoAutoBtn:setReferencePoint( display.CenterReferencePoint )
	NoAutoBtn.x = display.contentCenterX
	NoAutoBtn.y = display.contentHeight-50
	gcm:insert( NoAutoBtn )
	Automatic=auto
end

function TurnOffAuto()
	display.remove(NoAutoBtn)
	NoAutoBtn=nil
	Automatic=0
end

function Guard()
	ShowSorcery(true)
	P1Sprite(3)
	p1.stats[3]=p1.stats[3]*1.5
	isDefend=true
	UpdateStats()
=======
function AutoToggle()
	if Automatic~=0 then
		AutoTxt2.text=("Off")
		AutoTxt2:setTextColor(255,70,70)
		Automatic=0
	else
		AutoTxt2.text=("On")
		AutoTxt2:setTextColor(70,255,70)
		Automatic=true
	end
end

function SetAuto(auto)
	if Automatic==true then
		Automatic=auto
	end
>>>>>>> G1.2.0
end

function Recover()
	if p1.EP~=p1.MaxEP then
		local grant=(math.ceil((p1.stats[1])/1.5))
		p1.EP=p1.EP+grant
		epHits(grant)
	end
	if p1.MP~=p1.MaxMP then
		local grant=(math.ceil((p1.stats[1])/1.5))
		p1.MP=p1.MP+grant
		mpHits(grant)
	end
	if p1.EP>p1.MaxEP then
		p1.EP=p1.MaxEP
	end
	if p1.MP>p1.MaxMP then
		p1.MP=p1.MaxMP
	end
<<<<<<< HEAD
	ShowSorcery(true)
=======
	
>>>>>>> G1.2.0
	P1Sprite(3)
	p1.stats[3]=p1.stats[3]*0.75
	isRecover=true
	if Automatic==3 and p1.MP==p1.MaxMP and p1.EP==p1.MaxEP  then
<<<<<<< HEAD
		TurnOffAuto()
=======
		AutoToggle()
>>>>>>> G1.2.0
	end
	UpdateStats()
end

function MobsTurn()
	local pp=timer.pause(ptimer)
	timersprite:pause()
	MobSprite(2)
	etimer=nil
	
	local isHit=EvadeCalc("p1",16)
	if isHit>=(p1.stats[5]/6)*2 then
<<<<<<< HEAD
=======
		audio.Play(13)
>>>>>>> G1.2.0
		local Damage
		if isHit>=(p1.stats[5]/3)*5 then
			if enemy.stats[2]>enemy.stats[4]then
				Damage=DamageCalc("p1",(math.random(15,20)/10),16,2)
			else
				Damage=DamageCalc("p1",(math.random(15,20)/10),16,4)
			end
			if (Damage)<=0 then
				hpHits("BLK!",false,false)
			else
				players.ReduceHP(Damage,"Mob")
				P1Sprite(3)
				hpHits((Damage),true,false)
			end
		else
			if enemy.stats[2]>enemy.stats[4]then
				Damage=DamageCalc("p1",1,16,2)
			else
				Damage=DamageCalc("p1",1,16,4)
			end
			if (Damage)<=0 then
				hpHits("BLK!",false,false)
			else
				players.ReduceHP(Damage,"Mob")
				P1Sprite(3)
				hpHits((Damage),false,false)
			end
		end
	else
<<<<<<< HEAD
=======
		audio.Play(10)
>>>>>>> G1.2.0
		hpHits("MSS!",false,false)
	end
	MobStatuses()
end

function MobStatuses()
	if enemy.status=="BRN" then
		if BurnLimit>0 then
			local Burn=(math.floor(enemy.MaxHP*.05))
			enemy.HP=enemy.HP-Burn
			BurnLimit=BurnLimit-1
			mobHits((Burn),false,"BRN")
		elseif BurnLimit<=0 then
			if BurnLimit<0 then
				BurnLimit=0
			end
			statusdisplay:setFrame(1)
			enemy.status=false
		end
	elseif enemy.status=="BLD" then
		if BleedLimit>0 then
			local Bleed=(math.floor(enemy.MaxHP*.1))
			enemy.HP=enemy.HP-Bleed
			BleedLimit=BleedLimit-1
			mobHits((Bleed),false,"BLD")
		elseif BleedLimit<=0 then
			if BleedLimit<0 then
				BleedLimit=0
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
			mobHits((Poison),false,"PSN")
		end
	elseif enemy.status=="FRZ" then
		if FreezeLimit>0 then
			FreezeLimit=FreezeLimit-1
		elseif FreezeLimit<=0 then
			if FreezeLimit<0 then
				FreezeLimit=0
			end
			enemy.stats[5]=enemy.stats[5]/.2
			statusdisplay:setFrame(1)
			enemy.status=false
		end
	end
	UpdateStats()
end

function UpdateStats(Secret)
	if not(Created)and(gcm)then
	--[[ MOB ]]
	-- Life
		eHPcnt=enemy.HP
		hpBar=display.newSprite( hpsheet, { name="hpsheet", start=1, count=67, time=(1800) })
		hpBar.yScale=1.25
		hpBar.xScale=hpBar.yScale
		hpBar.x = xCoord+110
		hpBar.y = yCoord-135
		hpBar:toFront()
		gcm:insert(hpBar)
		hpBar:setFrame(math.floor(( (eHPcnt/enemy.MaxHP)*66 )+1))
		
		LifeSymbol=display.newSprite( heartsheet, { name="heart", start=1, count=16, time=(1800) })
		LifeSymbol.yScale=3.25
		LifeSymbol.xScale=LifeSymbol.yScale
		LifeSymbol.x = xCoord-10
		LifeSymbol.y = hpBar.y
		LifeSymbol:play()
		LifeSymbol:toFront()
		gcm:insert(LifeSymbol)
		
		LifeDisplay = display.newText( (eHPcnt.."/"..enemy.MaxHP), 0, 0, "Game Over", 75 )
		LifeDisplay:setTextColor( 0, 0, 0)
		LifeDisplay.x = LifeSymbol.x+140
		LifeDisplay.y = LifeSymbol.y-5
		LifeDisplay:toFront()
		gcm:insert(LifeDisplay)
		

	-- Level
		statusdisplay=display.newSprite( statussheet, { name="status", start=1, count=7, time=800 }  )
		statusdisplay.yScale=0.75
		statusdisplay.xScale=statusdisplay.yScale
		statusdisplay.x = LifeSymbol.x-80
		statusdisplay.y = LifeDisplay.y+90
		gcm:insert(statusdisplay)
		
		LvlDisplay = display.newText( ("Lv: "..enemy.lvl), statusdisplay.x+50, 0, "MoolBoran", 55 )
		LvlDisplay.y = statusdisplay.y+10
		LvlDisplay:toFront()
		gcm:insert(LvlDisplay)
		
		if enemy.lvl-p1.lvl>=3 then
			LvlDisplay:setTextColor( 255, 50, 50)
		elseif enemy.lvl-p1.lvl<=-3 then
			LvlDisplay:setTextColor( 50, 255, 50)
		else
			LvlDisplay:setTextColor( 255, 255, 50)
		end
		
		classdisplay= display.newText( (enemy.classname), LvlDisplay.x+15+(#LvlDisplay.text*8), 0, "MoolBoran", 55 )
		classdisplay:setTextColor( 255, 255, 255)
		classdisplay.y = LvlDisplay.y
		gcm:insert(classdisplay)
		
	--[[ PLAYER ]]
	-- Life
		pHPcnt=p1.HP
		hpBar2=display.newSprite( hpsheet, { name="hpsheet", start=1, count=67, time=(1800) })
		hpBar2.yScale=1.25
		hpBar2.xScale=hpBar2.yScale
		hpBar2.x = 140
		hpBar2.y = yCoord-135
		hpBar2:toFront()
		gcm:insert(hpBar2)
		hpBar2:setFrame(math.floor(( (pHPcnt/p1.MaxHP)*66 )+1))
		
		LifeSymbol2=display.newSprite( heartsheet, { name="heart", start=1, count=16, time=(1800) })
		LifeSymbol2.yScale=3.25
		LifeSymbol2.xScale=LifeSymbol2.yScale
		LifeSymbol2.x = 260
		LifeSymbol2.y = hpBar2.y
		LifeSymbol2:play()
		LifeSymbol2:toFront()
		gcm:insert(LifeSymbol2)
		
		LifeDisplay2 = display.newText( (pHPcnt.."/"..p1.MaxHP), 0, 0, "Game Over", 75 )
		LifeDisplay2:setTextColor( 0, 0, 0)
		LifeDisplay2.x = LifeSymbol2.x-140
		LifeDisplay2.y = LifeSymbol2.y-5
		LifeDisplay2:toFront()
		gcm:insert(LifeDisplay2)
		
	--Mana
		pMPcnt=p1.MP
		mpBar2=display.newSprite( mpsheet, { name="mpsheet", start=1, count=67, time=(1800) })
		mpBar2.yScale=1.25
		mpBar2.xScale=mpBar2.yScale
		mpBar2.x = 140
		mpBar2.y = yCoord-95
		mpBar2:toFront()
		gcm:insert(mpBar2)
		mpBar2:setFrame(math.floor(( (pMPcnt/p1.MaxMP)*66 )+1))
		
		ManaSymbol2=display.newSprite( manasheet, { name="mana", start=1, count=3, time=(500) })
		ManaSymbol2.yScale=0.9
		ManaSymbol2.xScale=ManaSymbol2.yScale
		ManaSymbol2.x = 260
		ManaSymbol2.y = mpBar2.y
		ManaSymbol2:play()
		ManaSymbol2:toFront()
		gcm:insert(ManaSymbol2)
		
		ManaDisplay2 = display.newText( (pMPcnt.."/"..p1.MaxMP), 0, 0, "Game Over", 75 )
		ManaDisplay2:setTextColor( 0, 0, 0)
		ManaDisplay2.x = ManaSymbol2.x-140
		ManaDisplay2.y = ManaSymbol2.y-5
		ManaDisplay2:toFront()
		gcm:insert(ManaDisplay2)
		
	--Energy
		pEPcnt=p1.EP
		epBar2=display.newSprite( epsheet, { name="epsheet", start=1, count=67, time=(1800) })
		epBar2.yScale=1.25
		epBar2.xScale=epBar2.yScale
		epBar2.x = 140
		epBar2.y = yCoord-55
		epBar2:toFront()
		gcm:insert(epBar2)
		epBar2:setFrame(math.floor(( (pMPcnt/p1.MaxMP)*66 )+1))
		
		EnergySymbol2=display.newSprite( energysheet, { name="energy", start=1, count=4, time=(500) })
		EnergySymbol2.yScale=0.9
		EnergySymbol2.xScale=EnergySymbol2.yScale
		EnergySymbol2.x = 260
		EnergySymbol2.y = epBar2.y
		EnergySymbol2:play()
		EnergySymbol2:toFront()
		gcm:insert(EnergySymbol2)
		
		EnergyDisplay2 = display.newText( (pEPcnt.."/"..p1.MaxEP), 0, 0, "Game Over", 75 )
		EnergyDisplay2:setTextColor( 0, 0, 0)
		EnergyDisplay2.x = EnergySymbol2.x-140
		EnergyDisplay2.y = EnergySymbol2.y-5
		EnergyDisplay2:toFront()
		gcm:insert(EnergyDisplay2)	
	end
	
	local done=true
	
	if p1.MP<0 then
		p1.MP=0
	end
	if p1.HP<0 then
		p1.HP=0
	end
	if p1.EP<0 then
		p1.EP=0
	end
	if enemy.HP<0 then
		enemy.HP=0
	end
	
	if pHPcnt-p1.HP==0 then
	elseif pHPcnt-p1.HP>0 then
		if pHPcnt-p1.HP>500 then
			pHPcnt=pHPcnt-25
			done=false
		elseif pHPcnt-p1.HP>200 then
			pHPcnt=pHPcnt-10
			done=false
		elseif pHPcnt-p1.HP>50 then
			pHPcnt=pHPcnt-5
			done=false
		elseif pHPcnt-p1.HP>20 then
			pHPcnt=pHPcnt-2
			done=false
		else
			pHPcnt=pHPcnt-1
			done=false
		end
	elseif pHPcnt-p1.HP<0 then
		if pHPcnt-p1.HP<-500 then
			pHPcnt=pHPcnt+25
			done=false
		elseif pHPcnt-p1.HP<-200 then
			pHPcnt=pHPcnt+10
			done=false
		elseif pHPcnt-p1.HP<-50 then
			pHPcnt=pHPcnt+5
			done=false
		elseif pHPcnt-p1.HP<-20 then
			pHPcnt=pHPcnt+2
			done=false
		else
			pHPcnt=pHPcnt+1
			done=false
		end
	end
	
	if pMPcnt-p1.MP==0 then
	elseif pMPcnt-p1.MP>0 then
		if pMPcnt-p1.MP>500 then
			pMPcnt=pMPcnt-25
			done=false
		elseif pMPcnt-p1.MP>200 then
			pMPcnt=pMPcnt-10
			done=false
		elseif pMPcnt-p1.MP>50 then
			pMPcnt=pMPcnt-5
			done=false
		elseif pMPcnt-p1.MP>20 then
			pMPcnt=pMPcnt-2
			done=false
		else
			pMPcnt=pMPcnt-1
			done=false
		end
	elseif pMPcnt-p1.MP<0 then
		if pMPcnt-p1.MP<-500 then
			pMPcnt=pMPcnt+25
			done=false
		elseif pMPcnt-p1.MP<-200 then
			pMPcnt=pMPcnt+10
			done=false
		elseif pMPcnt-p1.MP<-50 then
			pMPcnt=pMPcnt+5
			done=false
		elseif pMPcnt-p1.MP<-20 then
			pMPcnt=pMPcnt+2
			done=false
		else
			pMPcnt=pMPcnt+1
			done=false
		end
	end
	
	if pEPcnt-p1.EP==0 then
	elseif pEPcnt-p1.EP>0 then
		if pEPcnt-p1.EP>500 then
			pEPcnt=pEPcnt-25
			done=false
		elseif pEPcnt-p1.EP>200 then
			pEPcnt=pEPcnt-10
			done=false
		elseif pEPcnt-p1.EP>50 then
			pEPcnt=pEPcnt-5
			done=false
		elseif pEPcnt-p1.EP>20 then
			pEPcnt=pEPcnt-2
			done=false
		else
			pEPcnt=pEPcnt-1
			done=false
		end
	elseif pEPcnt-p1.EP<0 then
		if pEPcnt-p1.EP<-500 then
			pEPcnt=pEPcnt+25
			done=false
		elseif pEPcnt-p1.EP<-200 then
			pEPcnt=pEPcnt+10
			done=false
		elseif pEPcnt-p1.EP<-50 then
			pEPcnt=pEPcnt+5
			done=false
		elseif pEPcnt-p1.EP<-20 then
			pEPcnt=pEPcnt+2
			done=false
		else
			pEPcnt=pEPcnt+1
			done=false
		end
	end
	
	if eHPcnt-enemy.HP==0 then
	elseif eHPcnt-enemy.HP>500 then
		eHPcnt=eHPcnt-25
		done=false
	elseif eHPcnt-enemy.HP>200 then
		eHPcnt=eHPcnt-10
		done=false
	elseif eHPcnt-enemy.HP>50 then
		eHPcnt=eHPcnt-5
		done=false
	elseif eHPcnt-enemy.HP>20 then
		eHPcnt=eHPcnt-2
		done=false
	else
		eHPcnt=eHPcnt-1
		done=false
	end

	ManaDisplay2.text=(pMPcnt.."/"..p1.MaxMP)
	EnergyDisplay2.text=(pEPcnt.."/"..p1.MaxEP)
	LifeDisplay2.text=(pHPcnt.."/"..p1.MaxHP)
	LifeDisplay.text=(eHPcnt.."/"..enemy.MaxHP)
	mpBar2:setFrame(math.floor(( (pMPcnt/p1.MaxMP)*66 )+1))
	epBar2:setFrame(math.floor(( (pEPcnt/p1.MaxEP)*66 )+1))
	hpBar2:setFrame(math.floor(( (pHPcnt/p1.MaxHP)*66 )+1))
	hpBar:setFrame(math.floor(( (eHPcnt/enemy.MaxHP)*66 )+1))
	if (done==true) and Secret~=true and Created==true and (gcm) then
		EndTurn()
	elseif (done==true) and Created~=true and (gcm) then
		Created=true
	elseif (done~=true) and Secret~=true and (Created==true) and (gcm) then
		timer.performWithDelay(25,UpdateStats)
	elseif (done~=true) and Secret==true and (Created==true) and (gcm) then
		function Update2()
			UpdateStats(true)
		end
		timer.performWithDelay(25,Update2)
	end
end

function RunAttempt()
	
	local RunChance=EvadeCalc("mob",48)
	local MaxChance=MaxCalc()
	if RunChance>0 then
		EndCombat("Ran")
	elseif MaxChance==0 then
		local roll=math.random(1,10)
		if roll>8 then
			EndCombat("Ran")
		else
			EndTurn()
		end
	else
		EndTurn()
	end
end

function PlayerAttacks(atktype)
	if atktype==0 then
		P1Sprite(2)
	elseif atktype==1 then
		P1Sprite(4)
	end
	local atkstat
	local force
	if atktype==0 then
		atkstat=2
		local amount=math.floor(1.5*(p1.stats[atkstat]/2.5))
		if amount<1 then
			amount=1
		end
		epHits(-amount)
		p1.EP=p1.EP-amount
		if p1.EP<0 then
			p1.EP=0
			force=4
		else
			force=16
		end
	elseif atktype==1 then
		atkstat=4
		local amount=math.floor(1.5*(p1.stats[atkstat]/2.5))
		if amount<1 then
			amount=1
		end
		mpHits(-amount)
		p1.MP=p1.MP-amount
		if p1.MP<0 then
			p1.MP=0
			force=4
		else
			force=16
		end
	end
	local isHit=EvadeCalc("mob",16)
		audio.Play(13)
		if isHit>0 then
			if isHit>1 then
			local Damage=DamageCalc("mob",(math.random(15,20)/10),force,atkstat)
			if (Damage)<=0 then
				mobHits("BLK!",false,false)
			else
				enemy.HP=enemy.HP-Damage
				MobSprite(3)
				mobHits((Damage),true,false)
			end
		else
			local Damage=DamageCalc("mob",1,force,atkstat)
			if (Damage)<=0 then
				mobHits("BLK!",false,false)
			else
				enemy.HP=enemy.HP-Damage
				MobSprite(3)
				mobHits((Damage),false,false)
			end
		end
	else
<<<<<<< HEAD
=======
		audio.Play(10)
>>>>>>> G1.2.0
		mobHits("MSS!",false,false)
	end
	UpdateStats()
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
			if p1.EP~=p1.MaxEP then
				local grant=(math.ceil((p1.stats[1])/2.5))
				p1.EP=p1.EP+grant
				epHits(grant)
			end
			if p1.MP~=p1.MaxMP then
				local grant=(math.ceil((p1.stats[1])/2.5))
				p1.MP=p1.MP+grant
				mpHits(grant)
			end
			if p1.EP>p1.MaxEP then
				p1.EP=p1.MaxEP
			end
			if p1.MP>p1.MaxMP then
				p1.MP=p1.MaxMP
			end
			UpdateStats(true)
		end
		
		if Automatic==3 and p1.MP==p1.MaxMP and p1.EP==p1.MaxEP  then
<<<<<<< HEAD
			TurnOffAuto()
=======
			AutoToggle()
>>>>>>> G1.2.0
		end
		MobSprite()
		if isRecover~=true then
			P1Sprite()
		end
	elseif p1.HP<=0 then
		function closure1()
			EndCombat("Loss")
		end
		timer.performWithDelay(200,closure1)
	elseif enemy.HP<=0 then
		function closure2()
			EndCombat("Win")
		end
		timer.performWithDelay(200,closure2)
	end
end

function EndCombat(outcome)
<<<<<<< HEAD
=======
	audio.changeMusic(2)
>>>>>>> G1.2.0
	Runtime:removeEventListener("enterFrame", ManageHits)
	inCombat=false
	for i=gcm.numChildren,1,-1 do
		display.remove(gcm[i])
		gcm[i]=nil
	end
	gcm=nil
	for i=table.maxn(hits),1,-1 do
		display.remove(hits[i])
		hits[i]=nil
	end
	hits=nil
	Created=nil
	Automatic=0
	
	if outcomed==false then
		
		outcomed=true
		Runtime:addEventListener("enterFrame", gp.GoldDisplay)
		Runtime:addEventListener("enterFrame", players.ShowStats)
		--------------------------------------------
		if outcome=="Loss" then
			for i=gom.numChildren,1,-1 do
				local child = gom[i]
				child.parent:remove( child )
			end
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
				overFile="cbutton-over.png",
				width=290, height=80,
				onRelease = AcceptOutcome
			}
			OKBtn:setReferencePoint( display.CenterReferencePoint )
			OKBtn.x = display.contentWidth/2
			OKBtn.y = display.contentHeight*0.61
			gom:insert(OKBtn)
			
			local msg=display.newText("Mob defeated!",0,0, "MoolBoran", 90)
			msg.x = display.contentWidth/2
			msg.y = 290
			gom:insert(msg)
			
			local msg2=display.newText("You gained:",0,0, "MoolBoran", 60)
			msg2.x = display.contentWidth/4
			msg2.y = msg.y+110
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
				local msg4=display.newText( ( xp ).." XP.",0,0, "MoolBoran", 60)
				msg4:setTextColor(255, 0, 255)
				msg4.x = msg2.x+200
				msg4.y = msg2.y
				gom:insert(msg4)
			elseif xp==0 then
				local msg3=display.newText(gold.." gold.",0,0, "MoolBoran", 60)
				msg3:setTextColor(255, 255, 0)
				msg3.x = msg2.x+200
				msg3.y = msg2.y
				gom:insert(msg3)
				gp.CallAddCoins(gold)
			else
				local msg3=display.newText(gold.." gold.",0,0, "MoolBoran", 60)
				msg3:setTextColor(255, 255, 0)
				msg3.x = msg2.x+200
				msg3.y = msg2.y
				gom:insert(msg3)
				gp.CallAddCoins(gold)
				
				players.GrantXP( xp )
				
				local msg4=display.newText( ( xp ).." XP.",0,0, "MoolBoran", 60)
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
			
			local msg=display.newText("Got away successfully!",0,0, "MoolBoran", 85)
			msg.x = display.contentWidth/2
			msg.y = OMenu.y-60
			gom:insert(msg)
			
			local chance=math.random(1,10)
			if chance<9 then
				local RunDmg=math.floor( p1.MaxHP/(10+((math.random(0,4))-2)) )
				if RunDmg>p1.HP then
					RunDmg=(p1.HP-1)
					players.ReduceHP(RunDmg,"Mob")
				else
					players.ReduceHP(RunDmg,"Mob")
				end
				if RunDmg~=0 then
					local msg2=display.newText(("The mob hit you for "),50,0, "MoolBoran", 60)
					msg2.y = msg.y+80
					gom:insert(msg2)
					
					RunDmg=tostring(RunDmg)
					local msg3=display.newText((RunDmg),msg2.x+180+(#RunDmg*5),0, "MoolBoran", 60)
					msg3:setTextColor(255,50,50)
					msg3.y = msg2.y
					gom:insert(msg3)
					
					local msg4=display.newText((" upon running."),msg3.x+30+(#msg3.text*5),0, "MoolBoran", 60)
					msg4.y = msg2.y
					gom:insert(msg4)
				end
			end
			
			local OKBtn= widget.newButton{
				label="Okay",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton-over.png",
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
	m.FindMe(6)
	outcomed=false
	players.CalmDownCowboy(true)
	for i=gom.numChildren,1,-1 do
		local child = gom[i]
		child.parent:remove( child )
	end
	mov.Visibility()
end

function ManageHits()
	for h in pairs(hits) do
		hits[h].alpha=hits[h].alpha-0.005
		if hits[h].alpha<0.125 then
			display.remove(hits[h])
			hits[h]=nil
		end
	end
end

function mobHits(amount,crit,special)
<<<<<<< HEAD
	P1=players.GetPlayer()
	local size=55
	if crit==true then
		size=size*1.2
	end
	local hpos
	for i=1,5 do
		if not (hits[i]) then
			hpos=i
		end
	end
	if not (hpos) then
		display.remove(hits[1])
		hits[1]=nil
		hpos=1
	end
	if special==true then
		-- Heal
		hits[hpos]=display.newText( ("+"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 0, 100, 0)
	elseif special=="BRN" then
		-- BRN over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 0)
	elseif special=="BLD" then
		-- BLD over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 0)
	elseif special=="PSN" then
		-- PSN over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 100)
	elseif special=="SPL" then
		if type(amount)=="string" then
		-- spell missed
			hits[hpos]=display.newText( (amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(0,0,100)
		else
		-- spell hit
			hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(0,0,100)
		end
	else
		if type(amount)=="string" then
		-- hit missed
			hits[hpos]=display.newText( (amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(100,50,0)
		else
		-- hit hit
			hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor( 0, 0, 0)
		end
	end
	physics.addBody(hits[hpos], "kinematic", { friction=0.5,} )
	hits[hpos].isFixedRotation = true
	hits[hpos].x=LifeSymbol.x
	hits[hpos].y=LifeSymbol.y+5
	hits[hpos]:setLinearVelocity(-45,0)
end

function hpHits(amount,crit,special)
=======
>>>>>>> G1.2.0
	P1=players.GetPlayer()
	local size=55
	if crit==true then
		size=size*1.2
	end
	local hpos
<<<<<<< HEAD
=======
	for i=1,5 do
		if not (hits[i]) then
			hpos=i
		end
	end
	if not (hpos) then
		display.remove(hits[1])
		hits[1]=nil
		hpos=1
	end
	if special==true then
		-- Heal
		hits[hpos]=display.newText( ("+"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 0, 100, 0)
	elseif special=="BRN" then
		-- BRN over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 0)
	elseif special=="BLD" then
		-- BLD over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 0)
	elseif special=="PSN" then
		-- PSN over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 100)
	elseif special=="SPL" then
		if type(amount)=="string" then
		-- spell missed
			hits[hpos]=display.newText( (amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(0,0,100)
		else
		-- spell hit
			hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(0,0,100)
		end
	else
		if type(amount)=="string" then
		-- hit missed
			hits[hpos]=display.newText( (amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(100,50,0)
		else
		-- hit hit
			hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor( 0, 0, 0)
		end
	end
	physics.addBody(hits[hpos], "kinematic", { friction=0.5,} )
	hits[hpos].isFixedRotation = true
	hits[hpos].x=LifeSymbol.x
	hits[hpos].y=LifeSymbol.y+5
	hits[hpos]:setLinearVelocity(-45,0)
end

function hpHits(amount,crit,special)
	P1=players.GetPlayer()
	local size=55
	if crit==true then
		size=size*1.2
	end
	local hpos
>>>>>>> G1.2.0
	for i=6,10 do
		if not (hits[i]) then
			hpos=i
		end
	end
	if not (hpos) then
		display.remove(hits[6])
		hits[6]=nil
		hpos=6
	end

	if special==true then
		-- Heal
		hits[hpos]=display.newText( ("+"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 0, 100, 0)
	elseif special=="BRN" then
		-- BRN over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 0)
	elseif special=="BLD" then
		-- BLD over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 0)
	elseif special=="PSN" then
		-- PSN over time
		hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
		hits[hpos]:setTextColor( 100, 0, 100)
	elseif special=="SPL" then
		if type(amount)=="string" then
		-- spell missed
			hits[hpos]=display.newText( (amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(0,0,100)
		else
		-- spell hit
			hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(0,0,100)
		end
	else
		if type(amount)=="string" then
		-- hit missed
			hits[hpos]=display.newText( (amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor(100,50,0)
		else
		-- hit hit
			hits[hpos]=display.newText( ("-"..amount), 0, 0, "MoolBoran", size )
			hits[hpos]:setTextColor( 0, 0, 0)
		end
	end
	physics.addBody(hits[hpos], "kinematic", { friction=0.5,} )
	hits[hpos].isFixedRotation = true
	hits[hpos].x=LifeSymbol2.x
	hits[hpos].y=LifeSymbol2.y+5
	hits[hpos]:setLinearVelocity(45,0)
end

function epHits(amount)
	P1=players.GetPlayer()
	local size=55
	local hpos
	for i=11,15 do
		if not (hits[i]) then
			hpos=i
		end
	end
	if not (hpos) then
		display.remove(hits[11])
		hits[11]=nil
		hpos=11
	end
	
	if amount<0 then
		hits[hpos]=display.newText( (amount), 0, 0, "MoolBoran", size )
	else
		hits[hpos]=display.newText( ("+"..amount), 0, 0, "MoolBoran", size )
	end
	hits[hpos]:setTextColor( 0, 100, 0)
	physics.addBody(hits[hpos], "kinematic", { friction=0.5,} )
	hits[hpos].isFixedRotation = true
	hits[hpos].x=EnergySymbol2.x
	hits[hpos].y=EnergySymbol2.y+5
	hits[hpos]:setLinearVelocity(45,0)
end

function mpHits(amount)
	P1=players.GetPlayer()
	local size=55
	local hpos
	for i=16,20 do
		if not (hits[i]) then
			hpos=i
		end
	end
	if not (hpos) then
		display.remove(hits[16])
		hits[16]=nil
		hpos=16
	end
	
	if amount<0 then
		hits[hpos]=display.newText( (amount), 0, 0, "MoolBoran", size )
	else
		hits[hpos]=display.newText( ("+"..amount), 0, 0, "MoolBoran", size )
	end
	hits[hpos]:setTextColor( 100, 0, 100)
	physics.addBody(hits[hpos], "kinematic", { friction=0.5,} )
	hits[hpos].isFixedRotation = true
	hits[hpos].x=ManaSymbol2.x
	hits[hpos].y=ManaSymbol2.y+5
	hits[hpos]:setLinearVelocity(45,0)
end

function GetHits()
	return hits
end

function ShowBag()
	if inv==false then
		inv=true
		
		if (AutoTxt) then
			display.remove(AutoTxt)
		end
		
		if (AutoTxt2) then
			display.remove(AutoTxt2)
		end
		
		if (AutoWin) then
			display.remove(AutoWin)
		end
		
		ginv=display.newGroup()
		items={}
		items2={}
		for i=1,table.maxn(p1.inv) do
			if (p1.inv[i])~=nil and p1.inv[i][1]<=17 then
				local itmnme=item.ReturnInfo(p1.inv[i][1],0)
				
				function Gah()
					UseItem(p1.inv[i][1],i)
				end
				items2[#items2+1]=display.newImageRect("itemframe.png",64,64)
				items2[#items2].xScale=1.5
				items2[#items2].yScale=items2[#items2].xScale
				items2[#items2].x = xinvicial+(((#items2-1)%4)*((espacio*items2[#items2].xScale)+4))
				items2[#items2].y = yinvicial+(((espacio*items2[#items2].xScale)+4)*(math.floor((#items2-1)/4)))
				items2[#items2]:addEventListener("tap",Gah)
				ginv:insert( items2[#items2] )
				
				items[#items+1]=display.newImageRect( "items/"..itmnme..".png" ,64,64)
				items[#items].xScale=items2[#items2].xScale
				items[#items].yScale=items[#items].xScale
				items[#items].x = items2[#items2].x
				items[#items].y = items2[#items2].y
				ginv:insert( items[#items] )
				
				items2[#items2]:toFront()
				if p1.inv[i][2]~=1 then
					if p1.inv[i][2]>9 then
						items[#items].num=display.newText( (p1.inv[i][2]) ,items[#items].x+5,items[#items].y-5,"Game Over",80)
						ginv:insert( items[#items].num )
						items[#items].num:toFront()
					elseif p1.inv[i][2]<=9 then
						items[#items].num=display.newText( (p1.inv[i][2]) ,items[#items].x+15,items[#items].y-5,"Game Over",80)
						ginv:insert( items[#items].num )
						items[#items].num:toFront()
					end
				end
			end
		end
		ginv:toFront()
		
		display.remove(BackBtn)
		BackBtn=nil
		
		BackBtn=widget.newButton{
			label="Close",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=30,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = ShowBag}
		BackBtn:setReferencePoint( display.CenterReferencePoint )
		BackBtn.x = MagicBtn.x
		BackBtn.y = RecoverBtn.y
		gcm:insert( BackBtn )
	elseif inv==true then
		inv=false
		display.remove(BackBtn)
		BackBtn=nil
		for i=table.maxn(items),1,-1 do
			display.remove(items[i])
			items[i]=nil
			display.remove(items2[i])
			items2[i]=nil
		end
		items=nil
		items2=nil
		for i=ginv.numChildren,1,-1 do
			display.remove(ginv[i])
			ginv[i]=nil
		end
		ginv=nil
		ShowActions()
	end
end

function UseItem(id,slot)
	inv=false
	for i=table.maxn(items),1,-1 do
		display.remove(items[i])
		items[i]=nil
		display.remove(items2[i])
		items2[i]=nil
	end
	items=nil
	items2=nil
	for i=ginv.numChildren,1,-1 do
		display.remove(ginv[i])
		ginv[i]=nil
	end
	ginv=nil
	HideActions()
	
	if p1.inv[slot][2]==1 then
		table.remove( p1.inv, slot )
	elseif p1.inv[slot][2]~=1 then
		p1.inv[slot][2]=p1.inv[slot][2]-1
	end
	
	local itemstats={
		item.ReturnInfo(id,4)
	}
	
	if itemstats[3]==0 then
		if itemstats[4]<0 then
			players.ReduceHP((itemstats[4]*-1),"Poison")
			hpHits(-itemstats[4],false,false)
		elseif itemstats[4]>0 then
			p1.HP=p1.HP+(itemstats[4])
			if p1.HP>p1.MaxHP then
<<<<<<< HEAD
				p1.HP=p1.MaxHp
=======
				p1.HP=p1.MaxHP
>>>>>>> G1.2.0
			end
			hpHits(itemstats[4],false,true)
		end
	elseif itemstats[3]==1 then
		p1.MP=p1.MP+(itemstats[4])
		if p1.MP>p1.MaxMP then
			p1.MP=p1.MaxMP
		end
		mpHits(itemstats[4])
	elseif itemstats[3]==2 then
		p1.EP=p1.EP+(itemstats[4])
		if p1.EP>p1.MaxEP then
			p1.EP=p1.MaxEP
		end
		epHits(itemstats[4])
	end
	UpdateStats()
end

function ShowSorcery()
	if book==false then
		book=true
		
		if (AutoTxt) then
			display.remove(AutoTxt)
		end
		
		if (AutoTxt2) then
			display.remove(AutoTxt2)
		end
		
		if (AutoWin) then
			display.remove(AutoWin)
		end
		
		gspl=display.newGroup()
		spells={}
		spellframes={}
		spellsep={}
		spellsmp={}
		for i=1,table.maxn(p1.spells) do
			if (p1.spells[i][3])==true then
				function Hoo()
					CastSorcery(p1.spells[i][1])
				end
				spellframes[#spellframes+1]=display.newImageRect("itemframe.png",64,64)
				spellframes[#spellframes].xScale=1.5
				spellframes[#spellframes].yScale=spellframes[#spellframes].xScale
				spellframes[#spellframes].x = xinvicial+ (((#spellframes-1)%4)*((espacio*spellframes[#spellframes].xScale)+4))
				spellframes[#spellframes].y = yinvicial+(((espacio*spellframes[#spellframes].xScale)+4)*(math.floor((#spellframes-1)/4)))
				gspl:insert( spellframes[#spellframes] )
				
				spells[#spells+1]=display.newImageRect( "spells/"..p1.spells[i][1]..".png" ,80,80)
				spells[#spells].xScale=1.2
				spells[#spells].yScale=spells[#spells].xScale
				spells[#spells].x = spellframes[#spellframes].x
				spells[#spells].y = spellframes[#spellframes].y
				gspl:insert( spells[#spells] )
				
				spellframes[#spellframes]:toFront()
				
				if p1.spells[i][4]<=p1.MP and  p1.spells[i][5]<=p1.EP then
					spellframes[#spellframes]:addEventListener("tap",Hoo)
				else
					spellframes[#spellframes]:setFillColor(255,70,70)
					spellsmp[#spellsmp+1]=display.newText( (p1.spells[i][4].."MP"),0,0,"MoolBoran",35)
					spellsmp[#spellsmp]:setTextColor(70,255,70)
					spellsmp[#spellsmp].x=spellframes[#spellframes].x
					spellsmp[#spellsmp].y=spellframes[#spellframes].y-10
					gspl:insert( spellsmp[#spellsmp] )
					
					spellsep[#spellsep+1]=display.newText( (p1.spells[i][5].."EP"),0,0,"MoolBoran",35)
					spellsep[#spellsep]:setTextColor(255,70,255)
					spellsep[#spellsep].x=spellframes[#spellframes].x
					spellsep[#spellsep].y=spellframes[#spellframes].y+10
					gspl:insert( spellsep[#spellsep] )
				end
				
			end
		end
		gspl:toFront()
		
		display.remove(BackBtn)
		BackBtn=nil
		
		BackBtn=widget.newButton{
			label="Close",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=30,
			defaultFile="combataction.png",
			overFile="combataction2.png",
			width=342, height=86,
			onRelease = ShowSorcery}
		BackBtn:setReferencePoint( display.CenterReferencePoint )
		BackBtn.x = MagicBtn.x
		BackBtn.y = RecoverBtn.y
		gcm:insert( BackBtn )
	elseif book==true then
		book=false
		display.remove(BackBtn)
		BackBtn=nil
		for i=table.maxn(spells),1,-1 do
			display.remove(spells[i])
			spells[i]=nil
			display.remove(spellframes[i])
			spellframes[i]=nil
		end
		spells=nil
		spellframes=nil
		for i=gspl.numChildren,1,-1 do
			display.remove(gspl[i])
			gspl[i]=nil
		end
		gspl=nil
		ShowActions()
	end
end

function CastSorcery(name)
	
	book=false
	for i=table.maxn(spells),1,-1 do
		display.remove(spells[i])
		spells[i]=nil
		display.remove(spellframes[i])
		spellframes[i]=nil
	end
	spells=nil
	spellframes=nil
	for i=gspl.numChildren,1,-1 do
		display.remove(gspl[i])
		gspl[i]=nil
	end
	gspl=nil
	HideActions()
	
	for s=1, table.maxn(p1.spells) do
		if p1.spells[s][1]==name then
			mpHits(-p1.spells[s][4])
			epHits(-p1.spells[s][5])
			p1.MP=p1.MP-p1.spells[s][4]
			p1.EP=p1.EP-p1.spells[s][5]
		end
	end
	if name=="Cleave" then
		audio.Play(13)
		P1Sprite(2)
		local Damage=DamageCalc("mob",(math.random(15,20)/10),48,2)
		mobHits((Damage),true,"SPL")
		enemy.HP=enemy.HP-Damage
		MobSprite(3)
		
	elseif name=="Gouge" then
		P1Sprite(2)
		local isHit=EvadeCalc("mob",64)
		if isHit>0 then
			audio.Play(13)
			local Damage=DamageCalc("mob",(math.random(15,20)/10),48,2)
			if (Damage)<=0 then
				mobHits("BLK!",false,"SPL")
			else
				statusdisplay:setFrame(7)
				enemy.status="BLD"
				BleedLimit=p1.stats[4]
				if BleedLimit>15 then
					BleedLimit=20
				end
				enemy.HP=enemy.HP-Damage
				MobSprite(3)
				mobHits((Damage),true,"SPL")
			end
		else
<<<<<<< HEAD
=======
			audio.Play(10)
>>>>>>> G1.2.0
			mobHits("MSS!",false,"SPL")
		end
		
	elseif name=="Healing" then
		P1Sprite(4)
		local p1=players.GetPlayer()
		players.AddHP(math.floor(p1.MaxHP*.2))
		hpHits((math.floor(p1.MaxHP*.2)),false,true)
		
	elseif name=="Fire Sword" then
		P1Sprite(2)
		local isHit=EvadeCalc("mob",64)
		if isHit>0 then
			audio.Play(13)
			local Damage=DamageCalc("mob",(math.random(15,20)/10),48,2)
			if (Damage)<=0 then
				mobHits("BLK!",false,"SPL")
			else
				enemy.status="BRN"
				enemy.HP=enemy.HP-Damage
				MobSprite(3)
				statusdisplay:setFrame(3)
				BurnLimit=p1.stats[4]*2
				if BurnLimit>15 then
					BurnLimit=20
				end
				mobHits((Damage),true,"SPL")
			end
		else
<<<<<<< HEAD
=======
			audio.Play(10)
>>>>>>> G1.2.0
			mobHits("MSS!",false,"SPL")
		end
		
	elseif name=="Fireball" then
		P1Sprite(4)
		local isHit=EvadeCalc("mob",64)
		if isHit>0 then
			if isHit>1 then
				local Damage=DamageCalc("mob",(math.random(15,20)/10),48,4)
				if (Damage)<=0 then
					mobHits("BLK!",false,"SPL")
				else
					enemy.status="BRN"
					enemy.HP=enemy.HP-Damage
					MobSprite(3)
					statusdisplay:setFrame(3)
					BurnLimit=p1.stats[4]+2
					if BurnLimit>15 then
						BurnLimit=15
					end
					mobHits((Damage),true,"SPL")
				end
			else
				local Damage=DamageCalc("mob",1,48,4)
				if (Damage)<=0 then
					mobHits("BLK!",false,"SPL")
				else
					enemy.status="BRN"
					enemy.HP=enemy.HP-Damage
					MobSprite(3)
					statusdisplay:setFrame(3)
					BurnLimit=p1.stats[4]+2
					if BurnLimit>15 then
						BurnLimit=15
					end
					mobHits((Damage),false,"SPL")
				end
			end
		else
			mobHits("MSS!",false,"SPL")
		end
		
	elseif name=="Ice Spear" then
		P1Sprite(4)
		local isHit=EvadeCalc("mob",64)
		if isHit>0 then
			local Damage=DamageCalc("mob",(math.random(15,20)/10),48,4)
			if (Damage)<=0 then
				mobHits("BLK!",false,"SPL")
			else
				enemy.stats[5]=(enemy.stats[5]*.2)
				mobHits(("Frozen!"),false,"SPL")
				enemy.status="FRZ"
				statusdisplay:setFrame(2)
				enemy.HP=enemy.HP-Damage
				FreezeLimit=p1.stats[4]+2
				if FreezeLimit>15 then
					FreezeLimit=15
				end
				MobSprite(3)
				mobHits((Damage),true,"SPL")
			end
		else
			mobHits("MSS!",false,"SPL")
		end
		
	elseif name=="Slow" then
<<<<<<< HEAD
=======
		P1Sprite(4)
>>>>>>> G1.2.0
		enemy.stats[5]=(enemy.stats[5]*.2)
		mobHits(("Frozen!"),false,"SPL")
		enemy.status="FRZ"
		statusdisplay:setFrame(2)
		FreezeLimit=p1.stats[4]+2
		if FreezeLimit>15 then
			FreezeLimit=15
		end
		
	elseif name=="Poison Blade" then
		P1Sprite(2)
		local isHit=EvadeCalc("mob",64)
		if isHit>0 then
			audio.Play(13)
			if isHit>1 then
				local Damage=DamageCalc("mob",(math.random(15,20)/10),48,4)
				if (Damage)<=0 then
					mobHits("BLK!",false,"SPL")
				else
					enemy.status="PSN"
					mobHits(("Poison!"),false,"SPL")
					enemy.HP=enemy.HP-Damage
					MobSprite(3)
					statusdisplay:setFrame(5)
					mobHits((Damage),true,"SPL")
				end
			else
				local Damage=DamageCalc("mob",1,48,2)
				if (Damage)<=0 then
					mobHits("BLK!",false,"SPL")
				else
					enemy.status="PSN"
					mobHits(("Poison!"),false,"SPL")
					enemy.HP=enemy.HP-Damage
					MobSprite(3)
					statusdisplay:setFrame(5)
					mobHits((Damage),false,"SPL")
				end
			end
		else
<<<<<<< HEAD
=======
			audio.Play(10)
>>>>>>> G1.2.0
			mobHits("MSS!",false,"SPL")
		end
		
	end
	UpdateStats()
end

function DamageCalc(tar,crit,cmd,atkstat)
	local Damage
	if tar=="p1" then
		Damage=(
			((enemy.stats[atkstat]*(math.random(15,20)/10))-p1.stats[3])
		)
		Damage=(
			((Damage*cmd/16)*crit)
		)
		Damage=(Damage*0.5)
		Damage=math.floor(Damage)
	elseif tar=="mob" then
		Damage=(
			((p1.stats[atkstat]*(math.random(15,20)/10))-enemy.stats[3])
		)
		Damage=(
			((Damage*cmd/16)*crit)
		)
		Damage=(Damage*0.5)
		Damage=math.floor(Damage)
	end
	return Damage
end

function EvadeCalc(tar,cmd)
	local Chance
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
	end
	if Chance>=(enemy.stats[5]/6)*2 then
		if Chance>=(enemy.stats[5]/3)*5 then
			return 2
		else
			return 1
		end
	else
		return 0
	end
end

function MaxCalc()
	local Chance
	Chance=(
		((p1.stats[5]*1.5)-enemy.stats[5])
	)
	Chance=(
		(Chance*48/16)
	)
	Chance=(
		Chance*(10+(p1.stats[5]*1.5)/10)
	)
	Chance=Chance*1.5
	if Chance>=(enemy.stats[5]/6)*2 then
		return 1
	else
		return 0
	end
end
