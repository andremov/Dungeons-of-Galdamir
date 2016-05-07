-----------------------------------------------------------------------------------------
--
-- players.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local heartnsheet = graphics.newImageSheet( "heartemptysprite.png", { width=25, height=25, numFrames=16 } )
local energysheet = graphics.newImageSheet( "energysprite.png", { width=60, height=60, numFrames=4 } )
local heartsheet = graphics.newImageSheet( "heartsprite.png", { width=25, height=25, numFrames=16 } )
local manasheet = graphics.newImageSheet( "manasprite.png", { width=60, height=60, numFrames=3 } )
local xpsheet = graphics.newImageSheet( "xpbar.png", { width=392, height=40, numFrames=50 } )
local b=require("Lmapbuilder")
local WD=require("Lprogress")
local su=require("Lstartup")
local gold=require("Lgold")
local w=require("Lwindow")
local c=require("Lchars")
local a=require("Laudio")
local i=require("Litems")
local ui=require("Lui")
local DisplayCan=false
local Cheat=false
local StrongForce
local yCoord=856
local check=119
local xCoord=70
local scale=1.2
local transp2
local transp3
local player
local transp
local Map
local names={
		"Nameless",
		"Orphan",
		"Smith",
		"Slave",
		"Hctib",
	}
	
function CreatePlayers(name)
	local char =c.GetCharInfo(0)
	local class=c.GetCharInfo(1)

	if not (char) then
		char=math.random(0,3)
	end
	if not (class) then
		class=math.random(0,5)
	end
	
	--Visual
	player=display.newImageRect( "chars/"..char.."/"..class.."/char.png", 76 ,76)
	player.x, player.y = display.contentWidth/2, display.contentHeight/2
	player:setStrokeColor(50, 50, 255)
	player.xScale=scale
	player.yScale=player.xScale
	player.strokeWidth = 4
	--Leveling
	if name==nil or name=="" or name==" " then
		player.name=names[math.random(1,table.maxn(names))]
	elseif name=="Magus" or name=="MAGUS" or name=="magus" then
		player.name="Magus"
	elseif name=="Error" or name=="error" or name=="ERROR" then
		player.name="Error"
	else
		player.name=name
	end
	player.lvl=1
	player.MaxXP=50
	player.XP=0
	player.clsnames={"Viking","Warrior","Knight","Sorceror","Thief","Scholar"}
	player.char=char
	player.class=class
	--Extras
	player.gp=0
	player.eqp={  }
	player.inv={ {1,10} }
	player.weight=5
	--Stats
	player.statnames=	{"Stamina",	"Attack",	"Defense",	"Magic",	"Dexterity",	"Intellect"}
	player.eqs=			{0,			0,			0,			0,			0,				0}
	player.nat=			{2,			2,			2,			2,			2,				2}
	player.bon=			{0,			0,			0,			0,			0,				0}
	player.bst=			{0,			0,			0,			0,			0,				0}
	player.stats={
		(player.nat[1]+player.eqs[1]+player.bon[1]+player.bst[1]),
		(player.nat[2]+player.eqs[2]+player.bon[2]+player.bst[2]),
		(player.nat[3]+player.eqs[3]+player.bon[3]+player.bst[3]),
		(player.nat[4]+player.eqs[4]+player.bon[4]+player.bst[4]),
		(player.nat[5]+player.eqs[5]+player.bon[5]+player.bst[5]),
		(player.nat[6]+player.eqs[6]+player.bon[6]+player.bst[6]),
	}
	player.pnts=7
	--Spells
	player.spells={
		{"Gouge","Place a deep wound on the enemy target.",true,9,13},
		{"Fireball","Cast a firey ball of death and burn the enemy.",true,16,7},
		{"Cleave","Hits for twice maximum damage. Can't be evaded.",false,5,13},
		{"Slow","Reduces enemy's dexterity.",false,28,5},
		{"Poison Blade","Inflicts poison.",false,16,19},
		{"Fire Sword","Hits for twice damage and inflicts a burn.",false,26,37},
		{"Healing","Heals for 20% of maximum Hit Points.",false,58,4},
		{"Ice Sword","Hits for twice damage and reduces enemy's dexterity.",false,46,51},
	}
	--Secondary Stats
	player.portcd=0
	player.MaxHP=(10*player.lvl)+(player.stats[1]*20)
	player.MaxMP=(5*player.lvl)+(player.stats[6]*10)
	player.MaxEP=(5*player.lvl)+(player.stats[6]*10)
	player.HP=player.MaxHP
	player.MP=player.MaxMP
	player.EP=player.MaxEP
	player.SPD=(1.00-(player.stats[5]/100))
	--
	if (player) then
		Runtime:addEventListener("enterFrame",ShowStats)
		su.FrontNCenter()
	end
end

function PlayerLoc(location,room)
	player.loc=location
	player.room=room
end

function GetPlayer()
	return player
end

function ShowStats()
	check=check+1
	if check==120 then
		StatCheck()
		check=-1
	end
	
-- Life
	if not(LifeDisplay) then
		transp=255
		
		LifeDisplay = display.newText( (player.HP.."/"..player.MaxHP), 0, 0, "Game Over", 100 )
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeDisplay.x = 160
		LifeDisplay.y = display.contentHeight-175
		
		LifeWindow = display.newRect (0,0,#LifeDisplay.text*22,40)
		LifeWindow:setFillColor( 150, 150, 150,transp/2)
		LifeWindow.x=LifeDisplay.x
		LifeWindow.y=LifeDisplay.y+5
		
		LifeDisplay:toFront()
	end
	if not(LifeSymbol) then
		player.life=0
		LifeSymbol=display.newSprite( heartsheet, {name="heart",start=1,count=16,time=(1800)} )
		LifeSymbol.yScale=3.75
		LifeSymbol.xScale=3.75
		LifeSymbol.x = 50
		LifeSymbol.y = display.contentHeight-170
		LifeSymbol:play()
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
	
	if ((player.HP.."/"..player.MaxHP))~=LifeDisplay.text or StrongForce==true then
		transp=255
		LifeDisplay.text=((player.HP.."/"..player.MaxHP))
		
		display.remove(LifeWindow)
		LifeWindow = display.newRect (0,0,#LifeDisplay.text*22,40)
		LifeWindow:setFillColor( 150, 150, 150,transp/2)
		LifeWindow.x=LifeDisplay.x
		LifeWindow.y=LifeDisplay.y+5
		
		LifeSymbol:toFront()
		LifeDisplay:toFront()
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	elseif ((player.HP.."/"..player.MaxHP))==LifeDisplay.text and transp~=0 and player.HP==player.MaxHP and StrongForce~=true then
		transp=transp-(255/50)
		if transp<20 then
			transp=0
		end
		LifeWindow:setFillColor( 150, 150, 150,transp/2)
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
	
	if player.HP==0 then
		display.remove(LifeSymbol)
		LifeSymbol=display.newSprite( heartnsheet, { name="heart", start=1, count=16, time=(1800) }  )
		LifeSymbol.yScale=3.75
		LifeSymbol.xScale=3.75
		LifeSymbol.x = 50
		LifeSymbol.y = display.contentHeight-170
		LifeSymbol:play()
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
	
-- Mana
	if not(ManaDisplay) then
		transp3=255
		
		ManaDisplay = display.newText( (player.MP.."/"..player.MaxMP), 0, 0, "Game Over", 100 )
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaDisplay.x = LifeDisplay.x
		ManaDisplay.y = LifeDisplay.y+60
		
		ManaWindow = display.newRect (0,0,#ManaDisplay.text*22,40)
		ManaWindow:setFillColor( 150, 150, 150,transp3/2)
		ManaWindow.x=ManaDisplay.x
		ManaWindow.y=ManaDisplay.y+5
		
		ManaDisplay:toFront()
	end
	if not (ManaSymbol) then
		ManaSymbol=display.newSprite( manasheet, {name="mana",start=1,count=3,time=500} )
		ManaSymbol.yScale=1.0625
		ManaSymbol.xScale=1.0625
		ManaSymbol.x = LifeSymbol.x
		ManaSymbol.y = LifeSymbol.y+60
		ManaSymbol:play()
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
	end
	
	if ((player.MP.."/"..player.MaxMP))~=ManaDisplay.text or StrongForce==true then
		transp3=255
		ManaDisplay.text=((player.MP.."/"..player.MaxMP))
		
		display.remove(ManaWindow)
		ManaWindow = display.newRect (0,0,#ManaDisplay.text*22,40)
		ManaWindow:setFillColor( 150, 150, 150,transp3/2)
		ManaWindow.x=ManaDisplay.x
		ManaWindow.y=ManaDisplay.y+5
		
		ManaSymbol:toFront()
		ManaDisplay:toFront()
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
	elseif ((player.MP.."/"..player.MaxMP))==ManaDisplay.text and transp3~=0 and player.MP==player.MaxMP and StrongForce~=true then
		transp3=transp3-(255/50)
		if transp3<20 then
			transp3=0
		end
		ManaWindow:setFillColor( 150, 150, 150,transp3/2)
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
	end
	
-- Energy
	if not(EnergyDisplay) then
		transp5=255
		EnergyDisplay = display.newText( (player.EP.."/"..player.MaxEP), 0, 0, "Game Over", 100 )
		EnergyDisplay:setTextColor( 255, 255, 255,transp5)
		EnergyDisplay.x = ManaDisplay.x
		EnergyDisplay.y = ManaDisplay.y+60
		
		EnergyWindow = display.newRect (0,0,#EnergyDisplay.text*22,40)
		EnergyWindow:setFillColor( 150, 150, 150,transp5/2)
		EnergyWindow.x=EnergyDisplay.x
		EnergyWindow.y=EnergyDisplay.y+5
		
		EnergyDisplay:toFront()
	end
	
	if not (EnergySymbol) then
		EnergySymbol=display.newSprite( energysheet, {name="energy",start=1,count=4,time=500} )
		EnergySymbol.yScale=1.0625
		EnergySymbol.xScale=1.0625
		EnergySymbol.x = ManaSymbol.x
		EnergySymbol.y = ManaSymbol.y+60
		EnergySymbol:play()
		EnergySymbol:setFillColor(transp5,transp5,transp5,transp5)
	end
	
	if ((player.EP.."/"..player.MaxEP))~=EnergyDisplay.text or StrongForce==true then
		transp5=255
		EnergyDisplay.text=((player.EP.."/"..player.MaxEP))
		
		display.remove(EnergyWindow)
		EnergyWindow = display.newRect (0,0,#EnergyDisplay.text*22,40)
		EnergyWindow:setFillColor( 150, 150, 150,transp5/2)
		EnergyWindow.x=EnergyDisplay.x
		EnergyWindow.y=EnergyDisplay.y+5
		
		EnergySymbol:toFront()
		EnergyDisplay:toFront()
		EnergyDisplay:setTextColor( 255, 255, 255,transp5)
		EnergySymbol:setFillColor(transp5,transp5,transp5,transp5)
	elseif ((player.EP.."/"..player.MaxEP))==EnergyDisplay.text and transp5~=0 and player.EP==player.MaxEP and StrongForce~=true then
		transp5=transp5-(255/50)
		if transp5<20 then
			transp5=0
		end
		EnergyWindow:setFillColor( 150, 150, 150,transp5/2)
		EnergyDisplay:setTextColor( 255, 255, 255,transp5)
		EnergySymbol:setFillColor(transp5,transp5,transp5,transp5)
	end
	
-- Experience
	if not (XPSymbol) then
		transp2=0
		XPSymbol=display.newSprite( xpsheet, { name="xpbar", start=1, count=50, time=(2000) }  )
		XPSymbol.x = (display.contentWidth/2)+180
		XPSymbol.y = 27
		XPSymbol:toFront()
		XPSymbol:setFillColor(transp2,transp2,transp2,transp2)
		
		XPDisplay=display.newText( ((XPSymbol.frame*2).."%"), 0, 0, "Game Over", 85 )
		XPDisplay.x = XPSymbol.x
		XPDisplay.y = XPSymbol.y
		XPDisplay:toFront()
		XPDisplay:setTextColor( 0, 0, 0,transp2)
	end
	
-- Stat Points
	if not (StatSymbol) then
		transp4=0
		StatSymbol=display.newImageRect("unspent.png",240,80)
		StatSymbol.x = display.contentWidth-130
		StatSymbol.y = display.contentHeight-150
		StatSymbol:toFront()
		StatSymbol:setFillColor(transp4,transp4,transp4,transp4)
		su.FrontNCenter()
	end
	
	if StrongForce==true then
		StatSymbol:removeEventListener("touch",openStats)
		transp4=transp4-(255/50)
		if transp4<20 then
			transp4=0
		end
		StatSymbol:setFillColor(transp4,transp4,transp4,transp4)
	elseif player.pnts~=0 then
		StatSymbol:removeEventListener("touch",openStats)
		transp4=255
		StatSymbol:setFillColor(transp4,transp4,transp4,transp4)
		StatSymbol:addEventListener("touch",openStats)
	elseif player.pnts==0 and transp4~=0 then
		StatSymbol:removeEventListener("touch",openStats)
		transp4=transp4-(255/50)
		if transp4<20 then
			transp4=0
		end
		StatSymbol:setFillColor(transp4,transp4,transp4,transp4)
	end
end

function openStats( event )
	if event.phase=="ended" and DisplayCan==true then
		ui.Pause(true)
		w.ToggleInfo()
	end
end

function LetsYodaIt()
	if StrongForce~=true then
		StrongForce=true
	else
		StrongForce=false
	end
end

function CalmDownCowboy(what)
	DisplayCan=what
end

function ReduceHP(amount,cause)
	if player.HP~=0 and Cheat==false then
		player.HP = player.HP - amount
		if player.HP <= 0 then
			player.HP = 0
			w.DeathMenu(cause)
		end
	end
end

function AddHP(amount)
	if player.HP~=player.MaxHP then
		player.HP = player.HP + amount
		if player.HP > player.MaxHP then
			player.HP = player.MaxHP
		end
		a.Play(7)
	end
end

function AddMP(amount)
	if player.MP~=player.MaxMP then
		player.MP = player.MP + amount
		if player.MP > player.MaxMP then
			player.MP = player.MaxMP
		end
		a.Play(7)
	end
end

function AddEP(amount)
	if player.EP~=player.MaxEP then
		player.EP = player.EP + amount
		if player.EP > player.MaxEP then
			player.EP = player.MaxEP
		end
		a.Play(7)
	end
end

function StatCheck()
	if player.class==0 then
		player.bon[3]=math.floor(player.nat[1]/3)
	elseif player.class==1 then
		player.bon[5]=math.floor(player.nat[2]/3)
	elseif player.class==2 then
		player.bon[6]=math.floor(player.nat[3]/6)
		player.bon[1]=math.floor(player.nat[3]/6)
	elseif player.class==3 then
		player.bon[5]=math.floor(player.nat[4]/3)
	elseif player.class==4 then
		player.bon[2]=math.floor(player.nat[5]/6)
		player.bon[4]=math.floor(player.nat[5]/6)
	elseif player.class==5 then
		player.bon[3]=math.floor(player.nat[6]/3)
	end
	player.stats={
		(player.nat[1]+player.eqs[1]+player.bon[1]+player.bst[1]),
		(player.nat[2]+player.eqs[2]+player.bon[2]+player.bst[2]),
		(player.nat[3]+player.eqs[3]+player.bon[3]+player.bst[3]),
		(player.nat[4]+player.eqs[4]+player.bon[4]+player.bst[4]),
		(player.nat[5]+player.eqs[5]+player.bon[5]+player.bst[5]),
		(player.nat[6]+player.eqs[6]+player.bon[6]+player.bst[6]),
	}
	player.SPD=(1.00-(player.stats[5]/100))
	player.MaxHP=(10*player.lvl)+(player.stats[1]*20)
	player.MaxMP=(5*player.lvl)+(player.stats[6]*10)
	player.MaxEP=(5*player.lvl)+(player.stats[6]*10)
	if player.HP>player.MaxHP then
		player.HP=player.MaxHP
	end
	if player.MP>player.MaxMP then
		player.MP=player.MaxMP
	end
	if player.EP>player.MaxEP then
		player.EP=player.MaxEP
	end
	player.weight=5
	for i=1,table.maxn(player.inv) do
		player.weight=player.weight+player.inv[i][2]
	end
	for i=1,table.maxn(player.eqp) do
		player.weight=player.weight+2
	end
end

function WhosYourDaddy()
	Cheat=true
end

function Statless()
	player=nil
	display.remove(LifeDisplay)
	display.remove(LifeWindow)
	display.remove(LifeSymbol)
	display.remove(ManaDisplay)
	display.remove(ManaWindow)
	display.remove(ManaSymbol)
	display.remove(EnergyDisplay)
	display.remove(EnergyWindow)
	display.remove(EnergySymbol)
	display.remove(XPSymbol)
	display.remove(XPDisplay)
	display.remove(StatSymbol)
	LifeDisplay=nil
	LifeWindow=nil
	LifeSymbol=nil
	ManaDisplay=nil
	ManaWindow=nil
	ManaSymbol=nil
	EnergyDisplay=nil
	EnergyWindow=nil
	EnergySymbol=nil
	XPSymbol=nil
	XPDisplay=nil
	StatSymbol=nil
end

function StatBoost(stat)
	player.bst[stat]=player.bst[stat]+1
	StatCheck()
end

function Natural(statnum,amnt)
	player.nat[statnum]=player.nat[statnum]+amnt
	player.pnts=player.pnts-(amnt)
	StatCheck()
end

function GrantXP(orbs)
	player.XP=player.XP+(orbs)
	if math.floor(player.XP)==0 then
		XPSymbol:setFrame( 1 )
	else
		timer.performWithDelay(50,OhCrap)
	end
end

function LvlUp()
	player.lvl=player.lvl+1
	local profit=player.XP-player.MaxXP
	player.XP=0+profit
	player.MaxXP=player.lvl*50
	
	if math.floor(player.XP)==0 then
		xpSymbol:setFrame( 1 )
	else
		timer.performWithDelay(50,OhCrap)
	end
	
	player.pnts=player.pnts+4
	
	player.MaxHP=(100*player.lvl)+(player.stats[1]*10)
	player.MaxMP=(player.lvl*15)+(player.stats[6]*10)
	player.HP=player.MaxHP
	player.MP=player.MaxMP
	LvlFanfare()
end

function LvlFanfare()
	if not (LvlWindow) then
		transp10=255
		LvlWindow=display.newImageRect("fanfarelevelup.png",330,142)
		LvlWindow.xScale=2
		LvlWindow.yScale=LvlWindow.xScale
		LvlWindow.x=display.contentCenterX
		LvlWindow.y=display.contentCenterY-250
		LvlWindow:toFront()
		LvlWindow:setFillColor( transp10, transp10, transp10, transp10)
		timer.performWithDelay(10,LvlFanfare)
	else
		if transp10<20 then
			transp10=0
			display.remove(LvlWindow)
			LvlWindow=nil
		else
			transp10=transp10-(255/50)
			LvlWindow:setFillColor( transp10, transp10, transp10, transp10)
			LvlWindow:toFront()
			timer.performWithDelay(2,LvlFanfare)
		end
	end
end

function OhCrap()
	XPSymbol:toFront()
	XPDisplay:toFront()
	if XPSymbol.frame==50 and player.XP>player.MaxXP then
		LvlUp()
	elseif XPSymbol.frame>math.floor((player.XP/player.MaxXP)*50) then
		XPSymbol:setFrame(1)
		transp2=255
		XPSymbol:setFillColor(transp2,transp2,transp2,transp2)
		XPDisplay:setTextColor( 0, 0, 0,transp2)
		XPDisplay.text=((XPSymbol.frame*2).."%")
		timer.performWithDelay(50,OhCrap)
	elseif XPSymbol.frame<math.floor((player.XP/player.MaxXP)*50) then
		XPSymbol:setFrame(XPSymbol.frame+1)
		transp2=255
		XPSymbol:setFillColor(transp2,transp2,transp2,transp2)
		XPDisplay:setTextColor( 0, 0, 0,transp2)
		XPDisplay.text=((XPSymbol.frame*2).."%")
		timer.performWithDelay(50,OhCrap)
	elseif XPSymbol.frame==math.floor((player.XP/player.MaxXP)*50) and transp2~=0 then
		transp2=transp2-(255/50)
		if transp2<20 then
			transp2=0
		end
		XPSymbol:setFillColor(transp2,transp2,transp2,transp2)
		XPDisplay:setTextColor( 0, 0, 0,transp2)
		timer.performWithDelay(50,OhCrap)
	end
end

function ModStats(sta,att,def,mgc,dex,int)
	player.eqs[1]=player.eqs[1]+sta
	player.eqs[2]=player.eqs[2]+att
	player.eqs[3]=player.eqs[3]+def
	player.eqs[4]=player.eqs[4]+mgc
	player.eqs[5]=player.eqs[5]+dex
	player.eqs[6]=player.eqs[6]+int
	StatCheck()
end

function LearnSorcery(name)
	for m=1,table.maxn(player.spells) do
		if player.spells[m][1]==name then
			player.spells[m][3]=true
	--		print ("Player learned: "..player.spells[m][1])
		end
	end
end

function Load1(cls,chr)
--	print "Player loading..."
	Runtime:removeEventListener("enterFrame",ShowStats)
	display.remove(player)
	Statless()
	
	local char =chr
	local class=cls
	
	player=display.newImageRect( "chars/"..char.."/"..class.."/char.png", 76 ,76)
	player.x, player.y = display.contentWidth/2, display.contentHeight/2
	player:setStrokeColor(50, 50, 255)
	player.strokeWidth = 4
	player.xScale=scale
	player.yScale=player.xScale
	
	player.char=char
	player.class=class
end

function Load2(stam,atk,dfnc,mgk,dxtrty,intlct)
	player.nat={}
	player.nat[1]=stam
	player.nat[2]=atk
	player.nat[3]=dfnc
	player.nat[4]=mgk
	player.nat[5]=dxtrty
	player.nat[6]=intlct
end

function Load3(stam,atk,dfnc,mgk,dxtrty,intlct)
	player.bst={}
	player.bst[1]=stam
	player.bst[2]=atk
	player.bst[3]=dfnc
	player.bst[4]=mgk
	player.bst[5]=dxtrty
	player.bst[6]=intlct
end

function Load4(pnts,lv,xpnts)
	player.lvl=lv
	player.MaxXP=player.lvl*50
	player.XP=xpnts
	player.pnts=pnts
end

function Load5(hitp,manp,enep,neim,golp)
	player.name=neim
	player.gp=golp
	player.MP=manp
	player.HP=hitp
	player.EP=enep
	FinishLoading()
end

function FinishLoading()
	player.statnames={"Stamina","Attack","Defense","Magic","Dexterity","Intellect"}
	player.clsnames={"Knight","Warrior","Thief","Viking","Sorceror","Scholar"}
	player.eqs={0,0,0,0,0,0}
	player.bon={0,0,0,0,0,0}
	player.weight=5
	player.portcd=0
	player.stats={}
	player.inv={}
	player.eqp={}
	player.spells={
		{"Gouge","Place a deep wound on the enemy target.",true,9,13},
		{"Fireball","Cast a firey ball of death and burn the enemy.",true,16,7},
		{"Cleave","Hits for twice maximum damage. Can't be evaded.",false,5,13},
		{"Slow","Reduces enemy's dexterity.",false,28,5},
		{"Poison Blade","Inflicts poison.",false,16,19},
		{"Fire Sword","Hits for twice damage and inflicts a burn.",false,26,37},
		{"Healing","Heals for 20% of maximum Hit Points.",false,58,4},
		{"Ice Sword","Hits for twice damage and reduces enemy's dexterity.",false,46,51},
	}
	if (player) then
		check=119
		Runtime:addEventListener("enterFrame",ShowStats)
		su.FrontNCenter()
	end
end

function LoadSpells(name)
	for m=1,table.maxn(player.spells) do
		if player.spells[m][1]==name then
			player.spells[m][3]=true
		end
	end
end