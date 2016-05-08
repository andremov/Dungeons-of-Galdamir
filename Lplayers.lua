-----------------------------------------------------------------------------------------
--
-- players.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local psheet = graphics.newImageSheet( "player.png", { width=38, height=60, numFrames=60 } )
local physics = require "physics"
local WD=require("Lprogress")
local su=require("Lstartup")
local b=require("Lbuilder")
local gold=require("Lgold")
local c=require("Lchars")
local a=require("Laudio")
local i=require("Litems")
local ui=require("Lui")
local per=require("perspective")
local yCoord=856
local xCoord=70
local scale=2.6
local player
local pseqs={
		{name="stand.right",	start=11, count=4, time=750},
		{name="stand.left",		start=15, count=4, time=750},
		{name="run.right",		start=21, count=4, time=500},
		{name="run.left",		start=25, count=4, time=500},
		{name="stand.vertical",	start=31, count=4, time=500},
		{name="run.vertical",	start=35, count=4, time=500},
		{name="heal.right",		start=41, count=4, time=750},
		{name="heal.left",		start=45, count=4, time=750},
		{name="heal.vertical",	start=51, count=4, time=750},
	}
local names={
		"Nameless",
		"Orphan",
		"Smith",
		"Slave",
		"Hctib",
	}
	
function CreatePlayers(name,char,class)
	--Visual
	player=display.newSprite( psheet, pseqs )
	player:setSequence("stand.right")
	player:play()
	player.x, player.y = display.contentWidth/2, display.contentHeight/2
	player.xScale=scale-1.1
	player.yScale=player.xScale
	player.weapon="unarmed"
	
	player.shadow=display.newImageRect("shadow.png",38,60)
	player.shadow.x,player.shadow.y=player.x,player.y
	player.shadow.xScale=player.xScale
	player.shadow.yScale=player.yScale
	local shade={ -21,46, 21,46, 21,30, -21,30}
	physics.addBody(player.shadow, "dynamic", { friction=0.5,shape=shade} )
	player.shadow.isFixedRotation=true
	--Leveling
	if name=="" or name==" " then
		name=nil
	end
	player.name=name or names[math.random(1,table.maxn(names))]
	player.lvl=1
	player.MaxXP=50
	player.XP=0
	player.clsnames={"Viking","Warrior","Knight","Sorcerer","Thief","Scholar","Freelancer"}
	player.char=char or 0
	player.class=class or 6
	--Extras
	player.gp=0
	player.eqp={  }
	player.inv={ {1,10},{33,1},{41,1} }
	player.weight=5
	--Stats
	player.statnames={"Constitution",	"Dexterity",	"Strength",	"Magic",		"Stamina",	"Intellect"}
	player.eqs=			{0,			0,			0,			0,			0,			0}
	player.nat=			{2,			2,			2,			2,			2,			2}
	player.bon=			{0,			0,			0,			0,			0,			0}
	player.bst=			{0,			0,			0,			0,			0,			0}
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
		{"Healing","Heals for 20% of your maximum health.",false,58,4},
		{"Ice Spear","Hits for twice damage and reduces enemy's dexterity.",false,51,46},
	}
	--Secondary Stats
	player.portcd=0
	player.armor=0
	player.MaxHP=(10*player.lvl)+(player.stats[1]*20)
	player.MaxMP=(5*player.lvl)+(player.stats[6]*10)
	player.MaxEP=(5*player.lvl)+(player.stats[5]*10)
	player.HP=player.MaxHP
	player.MP=player.MaxMP
	player.EP=player.MaxEP
	player.SPD=(1.00-(player.stats[2]/100))
	--
	if (player) then
		player.isVisible=false
		player.shadow.isVisible=false
		Runtime:addEventListener("enterFrame",ui.ShowStats)
		ui.Controls()
		view=per.createView()
		
		-- view:add(Objects,7,false)
		-- view:add(PFX,6,false)
		view:add(player.shadow,6,false)
		view:add(player,5,true)
		-- view:add(p1.mpBar,5,false)
		-- view:add(p1.hpBar,5,false)
		view:setBounds(false)
		view:track()
	end
end

function getMap(value)
	view:add(value,8,false)
end

function SpriteSeq(value)
	if value==false then
		if player.sequence=="run.right" then
			player:setSequence("stand.right")
			player:play()
		elseif player.sequence=="run.left" then
			player:setSequence("stand.left")
			player:play()
		elseif player.sequence=="run.vertical" then
			player:setSequence("stand.vertical")
			player:play()
		end
	elseif value==true then
		if player.sequence=="run.right" then
			player:setSequence("heal.right")
			player:play()
		elseif player.sequence=="run.left" then
			player:setSequence("heal.left")
			player:play()
		elseif player.sequence=="run.vertical" then
			player:setSequence("heal.vertical")
			player:play()
		end
	elseif player.sequence~=value then
		player:setSequence(value)
		player:play()
	end
end

function GetPlayer()
	return player
end

--Modify values
function ReduceHP(amount,cause)
	if player.HP~=0 then
		player.HP = player.HP - amount
		if player.HP <= 0 then
			player.HP = 0
			ui.DeathMenu(cause)
		end
	end
end

function AddHP(amount)
	if player.HP~=player.MaxHP then
		player.HP = player.HP + amount
		if player.HP > player.MaxHP then
			player.HP = player.MaxHP
		end
		a.Play(5)
	end
end

function AddMP(amount)
	if player.MP~=player.MaxMP then
		player.MP = player.MP + amount
		if player.MP > player.MaxMP then
			player.MP = player.MaxMP
		end
		a.Play(5)
	end
end

function AddEP(amount)
	if player.EP~=player.MaxEP then
		player.EP = player.EP + amount
		if player.EP > player.MaxEP then
			player.EP = player.MaxEP
		end
		a.Play(5)
	end
end

--Stats
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
	player.MaxEP=(5*player.lvl)+(player.stats[5]*10)
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
	for a=1,table.maxn(player.inv) do
		local iteminfo=i.ReturnInfo(player.inv[a][1],5)
		local weight=iteminfo.weight
		player.weight=player.weight+(weight*player.inv[a][2])
	end
	for b=1,table.maxn(player.eqp) do
		local iteminfo=i.ReturnInfo(player.eqp[b][1],5)
		player.weight=player.weight+iteminfo.weight
	end
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

function ModStats(con,dex,str,mgc,sta,int,arm)
	player.eqs[1]=player.eqs[1]+con
	player.eqs[2]=player.eqs[2]+dex
	player.eqs[3]=player.eqs[3]+str
	player.eqs[4]=player.eqs[4]+mgc
	player.eqs[5]=player.eqs[5]+sta
	player.eqs[6]=player.eqs[6]+int
	player.armor=player.armor+arm
	StatCheck()
end

function LearnSorcery(id)
	player.spells[id][3]=true
	--print ("Player learned: "..player.spells[id][1])
end

--Loading
function Load1(cls,chr)
--	print "Player loading..."
	Runtime:removeEventListener("enterFrame",ShowStats)
	display.remove(player)
	Statless()
	local char =chr
	local class=cls
	
	--Visual
	player=display.newSprite( psheet, pseqs )
	player:setSequence("stand1")
	player.x, player.y = display.contentWidth/2, display.contentHeight/2
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
	player.statnames={"Stamina",	"Attack",	"Defense",	"Magic",	"Dexterity",	"Intellect"}
	player.clsnames={"Viking","Warrior","Knight","Sorcerer","Thief","Scholar","Freelancer"}
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
		{"Healing","Heals for 20% of your maximum health.",false,58,4},
		{"Ice Spear","Hits for twice damage and reduces enemy's dexterity.",false,51,46},
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