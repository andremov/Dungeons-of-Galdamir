-----------------------------------------------------------------------------------------
--
-- players.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local heartfsheet = graphics.newImageSheet( "heartsprite.png", { width=17, height=17, numFrames=16 } )
local manasheet = graphics.newImageSheet( "manasprite.png", { width=60, height=60, numFrames=3 } )
local heartnsheet = graphics.newImageSheet( "heartemptysprite.png", { width=17, height=17, numFrames=16 } )
local heartssheet = graphics.newImageSheet( "heartsilversprite.png", { width=17, height=17, numFrames=16 } )
local xpsheet = graphics.newImageSheet( "xpbar.png", { width=392, height=40, numFrames=50 } )
local b=require("LMapBuilder")
local gold=require("LGold")
local WD=require("LProgress")
local c=require("Lchars")
local a=require("LAudio")
local i=require("LItems")
local w=require("Lwindow")
local su=require("LStartup")
local yCoord=856
local xCoord=70
local Map
local check=119
local player
local Cheat=false
local transp
local transp2
local transp3
local names={
		"Nameless",
		"Orphan",
		"Smith",
		"Slave",
	}
	
function CreatePlayers(name)
	local char =c.GetCharInfo(0)
	local class=c.GetCharInfo(1)

	if not (char) then
		char=0
	end
	if not (class) then
		class=0
	end
	
	--Visual
	player=display.newImageRect( "chars/"..char.."/"..class.."/char.png", 76 ,76)
	player.x, player.y = display.contentWidth/2, display.contentHeight/2
	player:setStrokeColor(50, 50, 255)
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
	player.clsnames={"Knight","Warrior","Thief","Viking","Mage","Scholar"}
	player.char=char
	player.class=class
	player.life=0
	--Extras
	player.gp=0
	player.eqp={  }
	player.inv={ {1,10}}
	--Stats
	player.statnames=	{"Stamina",	"Attack",	"Defense",	"Magic",	"Dexterity",	"Intellect"}
	player.eqs=			{0,			0,			0,			0,			0,				0}
	player.nat=			{2,			2,			2,			2,			2,				2}
	player.stats={
		(player.nat[1]+player.eqs[1]),
		(player.nat[2]+player.eqs[2]),
		(player.nat[3]+player.eqs[3]),
		(player.nat[4]+player.eqs[4]),
		(player.nat[5]+player.eqs[5]),
		(player.nat[6]+player.eqs[6]),
	}
	player.pnts=5
	--Spells
	player.spells={
		{"Fireball","Cast a firey ball of death and burn the enemy.",true,30},
		{"Cleave","Hits for twice maximum damage. Can't be evaded.",false,20},
		{"Slow","Reduces enemy's dexterity.",false,50},
		{"Poison Blade","Inflicts poison.",false,50},
		{"Fire Sword","Hits for twice damage and inflicts a burn.",false,50},
		{"Healing","Heals for 20% of maximum Hit Points.",false,60},
		{"Ice Sword","Hits for twice damage and reduces enemy's dexterity.",false,120},
	}
	--Secondary Stats
	player.portcd=0
	player.MaxHP=(100*player.lvl)+(player.stats[1]*10)
	player.HP=player.MaxHP
	player.MaxMP=( (player.lvl*15)+(player.stats[6]*10) )
	player.MP=player.MaxMP
	player.SPD=(1.00-(player.stats[5]/100))
	--
	if (player) then
		Runtime:addEventListener("enterFrame",ShowStats)
		su.FrontNCenter()
	end
end

function PlayerLoc(right)
	if right==true then
		local size=b.GetData(0)
		local curround=WD.Circle()
		if curround%2==0 then
			player.loc=size-(math.sqrt(size)+1)
		else
			player.loc=(math.sqrt(size)+2)
		end
	elseif right==false then
		local size=b.GetData(0)
		local curround=WD.Circle()
		if curround%2==0 then
			player.loc=(math.sqrt(size)+2)
		else
			player.loc=size-(math.sqrt(size)+1)
		end
	end
end

function GetPlayer()
	return player
end

function MovePlayer(dist)
	player.loc=player.loc+dist
end

function ShowStats()
	check=check+1
	if check==120 then
		StatCheck()
		check=-1
	end
	
-- Life
	if not(LifeDisplay) then
		transp=0
		LifeDisplay = display.newText( (player.HP.."/"..player.MaxHP), 0, 0, "Game Over", 100 )
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeDisplay.x = 160
		LifeDisplay.y = display.contentHeight-115
	end
	if not(LifeSymbol) then
		player.life=0
		LifeSymbol=display.newSprite( heartfsheet, {name="heart",start=1,count=16,time=(1800)} )
		LifeSymbol.yScale=3.75
		LifeSymbol.xScale=3.75
		LifeSymbol.x = 50
		LifeSymbol.y = display.contentHeight-110
		LifeSymbol:play()
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
	
	if ((player.HP.."/"..player.MaxHP))~=LifeDisplay.text then
		LifeDisplay.text=((player.HP.."/"..player.MaxHP))
		transp=255
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	elseif ((player.HP.."/"..player.MaxHP))==LifeDisplay.text and transp~=0 and player.HP==player.MaxHP then
		transp=transp-(255/50)
		if transp<20 then
			transp=0
		end
		LifeDisplay:setTextColor( 255, 255, 255,transp)
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
	
	if player.HP==0 and player.life~=1 then
		display.remove(LifeSymbol)
		player.life=1
		LifeSymbol=display.newSprite( heartnsheet, { name="heart", start=1, count=16, time=(1800) }  )
		LifeSymbol.yScale=3.75
		LifeSymbol.xScale=3.75
		LifeSymbol.x = 50
		LifeSymbol.y = display.contentHeight-110
		LifeSymbol:play()
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	elseif player.HP/player.MaxHP<=.2 and player.life~=2 then
		display.remove(LifeSymbol)
		player.life=2
		LifeSymbol=display.newSprite( heartfsheet, {name="heart",start=1,count=16,time=(360)} )
		LifeSymbol.yScale=3.75
		LifeSymbol.xScale=3.75
		LifeSymbol.x = 50
		LifeSymbol.y = display.contentHeight-110
		LifeSymbol:play()
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	elseif player.life~=0 then
		display.remove(LifeSymbol)
		player.life=0
		LifeSymbol=display.newSprite( heartfsheet, {name="heart",start=1,
		count=16,time=(1800)} )
		LifeSymbol.yScale=3.75
		LifeSymbol.xScale=3.75
		LifeSymbol.x = 50
		LifeSymbol.y = display.contentHeight-110
		LifeSymbol:play()
		LifeSymbol:setFillColor(transp,transp,transp,transp)
	end
-- Mana
	if not(ManaDisplay) then
		transp3=0
		ManaDisplay = display.newText( (player.MP.."/"..player.MaxMP), 0, 0, "Game Over", 100 )
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaDisplay.x = LifeDisplay.x
		ManaDisplay.y = display.contentHeight-55
	end
	if not (ManaSymbol) then
		ManaSymbol=display.newSprite( manasheet, {name="mana",start=1,count=3,time=500} )
		ManaSymbol.yScale=1.0625
		ManaSymbol.xScale=1.0625
		ManaSymbol.x = LifeSymbol.x
		ManaSymbol.y = display.contentHeight-50
		ManaSymbol:play()
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
	end
	
	if ((player.MP.."/"..player.MaxMP))~=ManaDisplay.text then
		ManaDisplay.text=((player.MP.."/"..player.MaxMP))
		transp3=255
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
	elseif ((player.MP.."/"..player.MaxMP))==ManaDisplay.text and transp3~=0 and player.MP==player.MaxMP then
		transp3=transp3-(255/50)
		if transp3<20 then
			transp3=0
		end
		ManaDisplay:setTextColor( 255, 255, 255,transp3)
		ManaSymbol:setFillColor(transp3,transp3,transp3,transp3)
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
		StatSymbol.y = display.contentHeight-250
		StatSymbol:toFront()
		StatSymbol:setFillColor(transp4,transp4,transp4,transp4)
		su.FrontNCenter()
	end
	
	if player.pnts~=0 then
		transp4=255
		StatSymbol:setFillColor(transp4,transp4,transp4,transp4)
	elseif player.pnts==0 and transp4~=0 then
		transp4=transp4-(255/50)
		if transp4<20 then
			transp4=0
		end
		StatSymbol:setFillColor(transp4,transp4,transp4,transp4)
	end
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

function StatCheck()
	player.stats={
		(player.nat[1]+player.eqs[1]),
		(player.nat[2]+player.eqs[2]),
		(player.nat[3]+player.eqs[3]),
		(player.nat[4]+player.eqs[4]),
		(player.nat[5]+player.eqs[5]),
		(player.nat[6]+player.eqs[6]),
	}
	if player.class==0 then
		player.stats[6]=player.stats[6]+math.floor(player.stats[3]/6)
		player.stats[1]=player.stats[1]+math.floor(player.stats[3]/6)
	elseif player.class==1 then
		player.stats[5]=player.stats[5]+math.floor(player.stats[2]/3)
	elseif player.class==2 then
		player.stats[2]=player.stats[2]+math.floor(player.stats[5]/6)
		player.stats[4]=player.stats[4]+math.floor(player.stats[5]/6)
	elseif player.class==3 then
		player.stats[3]=player.stats[3]+math.floor(player.stats[1]/3)
	elseif player.class==4 then
		player.stats[5]=player.stats[5]+math.floor(player.stats[4]/3)
	elseif player.class==5 then
		player.stats[3]=player.stats[3]+math.floor(player.stats[6]/3)
	end
	player.SPD=(1.00-(player.stats[5]/100))
	player.MaxHP=(100*player.lvl)+(player.stats[1]*10)
	player.MaxMP=(player.lvl*15)+(player.stats[6]*10)
	if player.HP>player.MaxHP then
		player.HP=player.MaxHP
	end
	if player.MP>player.MaxMP then
		player.MP=player.MaxMP
	end
end

function WhosYourDaddy()
	Cheat=true
end

function Statless()
	player=nil
	display.remove(LifeDisplay)
	display.remove(LifeSymbol)
	display.remove(ManaDisplay)
	display.remove(ManaSymbol)
	display.remove(XPSymbol)
	display.remove(XPDisplay)
	display.remove(StatSymbol)
	LifeDisplay=nil
	LifeSymbol=nil
	ManaDisplay=nil
	ManaSymbol=nil
	XPDisplay=nil
	StatSymbol=nil
	XPSymbol=nil
end

function StatBoost(stat)
	player.nat[stat]=player.nat[stat]+1
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
end

function OhCrap()
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
	player.eqs[6]=player.eqs[6]+dex
	StatCheck()
end

function LearnSorcery(name)
	for m=1,table.maxn(player.spells) do
		if player.spells[m][1]==name then
			player.spells[m][3]=true
			print ("Player learned: "..player.spells[m][1])
		end
	end
end

function LoadPlayer(cls,chr,stam,atk,dfnc,mgk,dxtrty,intlct,pnts,lv,xpnts,hitp,manp,neim,golp)
	Runtime:removeEventListener("enterFrame",ShowStats)

	display.remove(player)
	Statless()
	local char =chr
	local class=cls
	
	player=display.newImageRect( "chars/"..char.."/"..class.."/char.png", 76 ,76)
	player.x, player.y = display.contentWidth/2, display.contentHeight/2
	player:setStrokeColor(50, 50, 255)
	player.strokeWidth = 4
	
	player.name=neim
	
	player.gp=golp
	
	player.portcd=0
	
	player.MP=manp
	player.HP=hitp
	
	player.lvl=lv
	player.MaxXP=player.lvl*50
	player.XP=xpnts
	
	player.statnames=	{"Stamina",	"Attack",	"Defense",	"Magic",	"Dexterity",	"Intellect"}
	player.eqs={0,0,0,0,0,0}
	
	player.nat={}
	player.nat[1]=stam
	player.nat[2]=atk
	player.nat[3]=dfnc
	player.nat[4]=mgk
	player.nat[5]=dxtrty
	player.nat[6]=intlct
	
	player.pnts=pnts
	
	player.stats={}
	
	player.clsnames={"Knight","Warrior","Thief","Viking","Mage","Scholar"}
	player.char=char
	player.class=class
	player.inv={}
	player.eqp={}
	
	player.spells={
		{"Fireball","Cast a firey ball of death and burn the enemy.",true,30},
		{"Cleave","Hits for twice maximum damage. Can't be evaded.",false,20},
		{"Slow","Reduces enemy's dexterity.",false,50},
		{"Poison Blade","Inflicts poison.",false,50},
		{"Fire Sword","Hits for twice damage and inflicts a burn.",false,50},
		{"Healing","Heals for 20% of maximum Hit Points.",false,60},
		{"Ice Sword","Hits for twice damage and reduces enemy's dexterity.",false,120},
	}
	
	StatCheck()
	
	if (player) then
		print "!1"
		check=119
		Runtime:addEventListener("enterFrame",ShowStats)
		su.FrontNCenter()
		player.HP=player.HP-1
		player.MP=player.MP-1
	end
	local size=b.GetData(0)
	local curround=WD.Circle()
	if curround%2==0 then
		player.loc=size-(math.sqrt(size)+1)
	else
		player.loc=(math.sqrt(size)+2)
	end
	timer.performWithDelay(100,Wow)
end

function Wow()
	player.HP=player.HP+1
	player.MP=player.MP+1
end

function LoadSpells(name)
	for m=1,table.maxn(player.spells) do
		if player.spells[m][1]==name then
			player.spells[m][3]=true
		end
	end
end