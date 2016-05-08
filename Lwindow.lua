-----------------------------------------------------------------------------------------
--
-- Windows.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local WD=require("Lprogress")
local item=require("Litems")
local mov=require("Lmoves")
local b=require("Lbuilder")
local p=require("Lplayers")
local lc=require("Llocale")
local sc=require("Lscore")
local s=require("Lsaving")
local c=require("Lcombat")
local a=require("Laudio")
local g=require("Lgold")
local m=require("Lmenu")
local ui=require("Lui")
local gexui
local isOpn
local isUse
local items
local ginv
local ginf
local geqp
local gbk
local gdm
local gum
local swg
local DeathMessages={}
DeathMessages["EN"]={
	-- Lava
	{
		"Roasted by lava.",
		"Swimming in lava.",
		"Hyperthermia.",
		"Skin melting.",
		"Do I smell barbeque?",
	},
	-- Mob
	{
		"Fighting a mob.",
		"Face smashed in.",
		"Your insides are on the floor.",
		"Pro-tip: Keep your extremities together.",
		"Exsanguination.",
		"Don't mess with the mobs.",
		"Do not feed the mobs.",
	},
	-- Poison
	{
		"Well, now you know.",
		"Smooth move.",
		"Nice one, smartass.",
		"That was poison.",
		"You had so much potential...",
	},
	-- Portal
	{
		"Portal dismemberment.",
		"I think your leg is over there.",
		"Your blood didn't teleport...",
		"Stay inside the portal at all times.",
		"Not your best teleport.",
		"Did you find the secret cow level?",
	},
	-- Energy
	{
		"Falling unconscious in a dungeon.",
		"Should've kept some energy drinks handy.",
		"So is having energy a priority to you now?",
		"Should've gotten a good night's sleep.",
	},
}
DeathMessages["ES"]={
	-- Lava
	{
		"Asado por lava.",
		"Nadando en lava.",
		"Hipertermia.",
		"Piel derretida.",
		"¿Huelo barbacoa?",
	},
	-- Mob
	{
		"Luchando contra un enemigo.",
		"Cara aplastada", 
		"Interiores esparcidos por el piso.",
		"Pro-tip: Manten tus extremidades juntas.",
		"Desangramiento.",
		"No te metas con los monstruos.",
		"No alimentes a tus enemigos.",
	},
	-- Poison
	{
		"Bueno, ahora lo sabes.",
		"Buen movimiento.",
		"Muy buena, listillo.",
		"Eso fue veneno.",
		"Tenias tanto potencial...",
	},
	-- Portal
	{
		"Desmembramiento portal.",
		"Creo que tu pierna esta alla.",
		"Tu sangre no se teletransporto...",
		"Permanece en el interior del portal en todo momento.",
		"No es tu mejor intento.",
		"¿Encontraste el nivel de vaca secreto?",
	},
	-- Energy
	{
		"Inconsciente en un calabozo.",
		"Debiste haber mantenido algunas bebidas energeticas a mano.",
		"Entonces, ¿Tener energia es una prioridad para ti ahora?", 
		"Debiste de haber conseguido una buena noche de sueño.",
	},
}

function Essentials()
	p1=p.GetPlayer()
	xinvicial=62
	yinvicial=157
	scale=1.2
	espacio=64*scale
	xeqpicial=62
	yeqpicial=721.47998046875
	statchangexs=200
	statchangey=(display.contentCenterY)-70
	statchangex=(display.contentCenterX)-statchangexs
	isUse=false
	isOpn=false
	statchange={}
end

function CloseErrthang()
	if not (gdm) then
		if (gum) then
			UseMenu(false)
		end
		if (swg) then
			ToggleSound(false)
		end
		if (ginf) then
			ToggleInfo(false)
		end
		if (ginv) then
			ToggleBag(false)
		end
		if (gexui) then
			ToggleExit(false)
		end
		if (gbk) then
			ToggleSpells(false)
		end
		ui.ShowPwg()
		return true
	else
		return false
	end
end

function ToggleBag(sound)
	if isOpn==false then
		if sound~=false then
			a.Play(3)
		end
		ginv=display.newGroup()
		items={}
		curreqp={}
		
		invinterface=display.newImageRect("container.png", 570, 507)
		invinterface.x,invinterface.y = display.contentCenterX, 440
		invinterface.xScale,invinterface.yScale=1.28,1.28
		ginv:insert( invinterface )
		isOpn=true
		
		CloseBtn=widget.newButton{
			label="X",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=50,
			defaultFile="sbutton.png",
			overFile="sbutton-over.png",
			width=80, height=80,
			onRelease = CloseErrthang}
		CloseBtn:setReferencePoint( display.CenterReferencePoint )
		CloseBtn.xScale,CloseBtn.yScale=0.75,0.75
		CloseBtn.x = display.contentCenterX-30+(570/2*1.28)
		CloseBtn.y = 410-(507/2*1.28)
		ginv:insert( CloseBtn )
		
		InvCheck()
		
		for i=1,table.maxn(p1.inv) do
			if (p1.inv[i])~=nil then
				local itmnme=item.ReturnInfo(p1.inv[i][1],0)
	--			print ("Player has "..p1.inv[i][2].." of "..itmnme..".")
	
				items[#items+1]=display.newImageRect( "items/"..itmnme..".png" ,64,64)
				items[#items].xScale=scale
				items[#items].yScale=scale
				items[#items].x = xinvicial+ (((#items-1)%9)*(espacio+(3*1.28)))
				items[#items].y = yinvicial+ ((math.floor((#items-1)/9))*(espacio+(3*1.28)))
				function Gah()
					UseMenu(p1.inv[i][1],i)
				end
				items[#items]:addEventListener("tap",Gah)
				ginv:insert( items[#items] )
				if p1.inv[i][2]~=1 then
					if p1.inv[i][2]>9 then
						items[#items].num=display.newText( (p1.inv[i][2]) ,items[#items].x+5,items[#items].y-5,"Game Over",80)
						ginv:insert( items[#items].num )
					elseif p1.inv[i][2]<=9 then
						items[#items].num=display.newText( (p1.inv[i][2]) ,items[#items].x+15,items[#items].y-5,"Game Over",80)
						ginv:insert( items[#items].num )
					end
				end
			end
		end
		
		for i=1,table.maxn(p1.eqp) do
			if (p1.eqp[i])~=nil then
				local itmnme=item.ReturnInfo(p1.eqp[i][1],0)
	--			print ("Player has "..itmnme.." equipped in slot number "..p1.eqp[i][2]..".")
				curreqp[#curreqp+1]=display.newImageRect( "items/"..itmnme..".png" ,64,64)
				curreqp[#curreqp].xScale=scale
				curreqp[#curreqp].yScale=scale
				if p1.eqp[i][2]==6 then
					plcmnt=1
				elseif p1.eqp[i][2]==2 then
					plcmnt=2
				elseif p1.eqp[i][2]==3 then
					plcmnt=3
				elseif p1.eqp[i][2]==0 then
					plcmnt=4
				elseif p1.eqp[i][2]==4 then
					plcmnt=5
				elseif p1.eqp[i][2]==1 then
					plcmnt=6
				elseif p1.eqp[i][2]==7 then
					plcmnt=7
				elseif p1.eqp[i][2]==5 then
					plcmnt=8
				elseif p1.eqp[i][2]==8 then
					plcmnt=9
				end
				curreqp[#curreqp].x = xeqpicial+(((plcmnt-1)%9)*(espacio+(3*1.28)))
				curreqp[#curreqp].y = yeqpicial
				function Argh()
					CheckMenu(p1.eqp[i][1])
				end
				curreqp[#curreqp]:addEventListener("tap",Argh)
				ginv:insert( curreqp[#curreqp] )
			end
		end
		ginv:toFront()
		if table.maxn(p1.inv)==0 then
	--		print "Inventory is empty."
		end
		if table.maxn(p1.eqp)==0 then
	--		print "Player has nothing equipped."
		end
	elseif isOpn==true and (ginv) then
		if sound~=false then
			a.Play(4)
		end
		
		if isUse==false then
			for i=table.maxn(items),1,-1 do
				display.remove(items[i])
				items[i]=nil
			end
			items=nil
			for i=table.maxn(curreqp),1,-1 do
				display.remove(curreqp[i])
				curreqp[i]=nil
			end
			curreqp=nil
			isOpn=false
			for i=ginv.numChildren,1,-1 do
				display.remove(ginv[i])
				ginv[i]=nil
			end
			ginv=nil
		else
			SpecialUClose()
			for i=table.maxn(items),1,-1 do
				display.remove(items[i])
				items[i]=nil
			end
			items=nil
			for i=table.maxn(curreqp),1,-1 do
				display.remove(curreqp[i])
				curreqp[i]=nil
			end
			curreqp=nil
			isOpn=false
			for i=ginv.numChildren,1,-1 do
				display.remove(ginv[i])
				ginv[i]=nil
			end
			ginv=nil
		end
		
	end
end

function ToggleInfo(sound)
	if isOpn==false then
		if sound~=false then
			a.Play(3)
		end
		isOpn=true
		ginf=display.newGroup()
		info={}
		pli={}
		mini={}
		
		bkg=display.newImageRect("bkgs/pausebkg.png", 768, 800)
		bkg.x,bkg.y = display.contentWidth/2, 400
		
		CloseBtn=widget.newButton{
			label="X",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=50,
			defaultFile="sbutton.png",
			overFile="sbutton-over.png",
			width=80, height=80,
			onRelease = CloseErrthang}
		CloseBtn:setReferencePoint( display.CenterReferencePoint )
		CloseBtn.xScale,CloseBtn.yScale=0.75,0.75
		CloseBtn.x = display.contentWidth-30
		CloseBtn.y = 30
		
		StatInfo()
	elseif isOpn==true and (ginf) then
		if sound~=false then
			a.Play(4)
		end
		display.remove(bkg)
		bkg=nil
		display.remove(CloseBtn)
		CloseBtn=nil
		isOpn=false
		for i=table.maxn(info),1,-1 do
			display.remove(info[i])
			info[i]=nil
		end
		info=nil
		for i=table.maxn(pli),1,-1 do
			display.remove(pli[i])
			pli[i]=nil
		end
		pli=nil
		for i=table.maxn(mini),1,-1 do
			display.remove(mini[i])
			mini[i]=nil
		end
		mini=nil
		for i=ginf.numChildren,1,-1 do
			display.remove(ginf[i])
			ginf[i]=nil
		end
		ginf=nil
	end
end

function ToggleSound(sound)
	if isOpn==false then
		if sound~=false then
			a.Play(3)
		end
		isOpn=true
		swg=display.newGroup()
	
		window=display.newImageRect("usemenu.png",768,308)
		window.x=display.contentCenterX
		window.y=display.contentCenterY
		swg:insert(window)
	
		scroll=display.newImageRect("scroll.png",600,50)
		scroll.x=display.contentCenterX
		scroll.y=display.contentCenterY-40
		scroll.xScale=1.15
		scroll.yScale=scroll.xScale
		scroll:addEventListener("touch",MusicScroll)
		swg:insert(scroll)
		
		CloseBtn=widget.newButton{
			label="X",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=50,
			defaultFile="sbutton.png",
			overFile="sbutton-over.png",
			width=80, height=80,
			onRelease = CloseErrthang}
		CloseBtn:setReferencePoint( display.CenterReferencePoint )
		CloseBtn.xScale,CloseBtn.yScale=0.75,0.75
		CloseBtn.x = display.contentWidth-30
		CloseBtn.y = display.contentCenterY-((308/2)-30)
		swg:insert(CloseBtn)
		
		local m=a.muse()
		m=m*10
		scrollind=display.newImageRect("scrollind.png",15,50)
		scrollind.x=display.contentCenterX-(290*scroll.xScale)+( m*(290*scroll.xScale)/5 )
		scrollind.y=scroll.y
		scrollind.xScale=1.45
		scrollind.yScale=scrollind.xScale
		swg:insert(scrollind)
		
		musicind=display.newText( (lc.giveText("LOC003").." "..(m*10).."%"),0,0,"MoolBoran",50 )
		musicind.x=scroll.x
		musicind.y=scroll.y+10
		swg:insert(musicind)
		
		scroll2=display.newImageRect("scroll.png",600,50)
		scroll2.x=scroll.x
		scroll2.y=scroll.y+100
		scroll2.xScale=scroll.xScale
		scroll2.yScale=scroll.xScale
		scroll2:addEventListener("touch",SoundScroll)
		swg:insert(scroll2)
		
		local s=a.sfx()
		s=s*10
		scrollind2=display.newImageRect("scrollind.png",15,50)
		scrollind2.x=display.contentCenterX-(290*scroll.xScale)+( s*(290*scroll.xScale)/5 )
		scrollind2.y=scroll2.y
		scrollind2.xScale=scrollind.xScale
		scrollind2.yScale=scrollind.xScale
		swg:insert(scrollind2)
		
		soundind=display.newText( (lc.giveText("LOC004").." "..(s*10).."%"),0,0,"MoolBoran",50 )
		soundind.x=scroll2.x
		soundind.y=scroll2.y+10
		swg:insert(soundind)

	elseif isOpn==true and (swg) then
		if sound~=false then
			a.Play(4)
		end
		isOpn=false
		for i=swg.numChildren,1,-1 do
			display.remove(swg[i])
			swg[i]=nil
		end
		swg=nil
	end
end

function ToggleExit(sound)
	if isOpn==false then
		if sound~=false then
			a.Play(3)
		end
		m.FindMe(9)
		isOpn=true
		gexui=display.newGroup()
		
		window=display.newImageRect("usemenu.png", 768, 308)
		window.x,window.y = display.contentWidth/2, 450
		gexui:insert( window )
		
		local lang=lc.giveLang()
		local text
		if lang=="EN" then
			text="You pressed the exit button."
		elseif lang=="ES" then
			text="Undiste el boton de salida."
		end
		lolname=display.newText( (text) ,0,0,"MoolBoran",70)
		lolname.x=display.contentCenterX
		lolname.y=(display.contentHeight/2)-140
		gexui:insert( lolname )
		
		if lang=="EN" then
			text="Are you sure you want to exit?"
		elseif lang=="ES" then
			text="¿Seguro quieres salir?"
		end
		lolname2=display.newText( (text) ,0,0,"MoolBoran",55)
		lolname2.x=display.contentCenterX
		lolname2.y=lolname.y+50
		gexui:insert(lolname2)
		
		if lang=="EN" then
			text="\(Unsaved progress will be lost.\)"
		elseif lang=="ES" then
			text="\(Progreso no guardado sera perdido.\)"
		end
		lolname3=display.newText( (text) ,0,0,"MoolBoran",40)
		lolname3:setTextColor(180,180,180)
		lolname3.x=display.contentCenterX
		lolname3.y=lolname2.y+50
		gexui:insert(lolname3)
		
		AcceptBtn=  widget.newButton{
			label=lc.giveText("LOC019"),
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=200, height=55,
			onRelease = DoExit}
		AcceptBtn:setReferencePoint( display.CenterReferencePoint )
		AcceptBtn.x = (display.contentWidth/2)-130
		AcceptBtn.y = (display.contentHeight/2)+30
		gexui:insert( AcceptBtn )
		
		BackBtn=  widget.newButton{
			label=lc.giveText("LOC018"),
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=200, height=55,
			onRelease = ToggleExit}
		BackBtn:setReferencePoint( display.CenterReferencePoint )
		BackBtn.x = (display.contentWidth/2)+130
		BackBtn.y = (display.contentHeight/2)+30
		gexui:insert( BackBtn )
		
		gexui:toFront()
		
	elseif isOpn==true and (gexui) then
		if sound~=false then
			a.Play(4)
		end
		m.FindMe(6)
		isOpn=false
		for i=gexui.numChildren,1,-1 do
			display.remove(gexui[i])
			gexui[i]=nil
		end
		gexui=nil
	end
end

function ToggleSpells(sound)
	if isOpn==false then
		if sound~=false then
			a.Play(3)
		end
		isOpn=true
		gbk=display.newGroup()
		spellicons={}
		spellnames={}
		spelltrigger={}
		
		bkg=display.newImageRect("bkgs/magicbkg.png", 768, 800)
		bkg.x,bkg.y = display.contentWidth/2, 400
		gbk:insert(bkg)
		
		CloseBtn=widget.newButton{
			label="X",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=50,
			defaultFile="sbutton.png",
			overFile="sbutton-over.png",
			width=80, height=80,
			onRelease = CloseErrthang}
		CloseBtn:setReferencePoint( display.CenterReferencePoint )
		CloseBtn.xScale,CloseBtn.yScale=0.75,0.75
		CloseBtn.x = display.contentWidth-30
		CloseBtn.y = 30
		gbk:insert(CloseBtn)
		
		for i=1,table.maxn(p1.spells) do
		
			spelltrigger[i]=display.newRect(0,0,310,80)
			spelltrigger[i].x = 170
			spelltrigger[i].y = 120+((i-1)*85)
			spelltrigger[i]:setFillColor(0,0,0,0)
			spelltrigger[i]:addEventListener("tap",SpellInfo)
			gbk:insert(spelltrigger[i])
			
			if p1.spells[i][3]==true then
				spellicons[i]=display.newImageRect(("spells/"..p1.spells[i][1]..".png"),80,80)
				spellicons[i].x=60
				spellicons[i].y=120+((i-1)*85)
				gbk:insert(spellicons[i])
				
				spellnames[i]=display.newText((p1.spells[i][1]),spellicons[i].x+45,0,"MoolBoran",55)
				spellnames[i].y=spellicons[i].y+20
				spellnames[i]:setTextColor(0,0,0)
				gbk:insert(spellnames[i])
			else
				spellicons[i]=display.newImageRect(("spells/"..p1.spells[i][1].." X.png"),80,80)
				spellicons[i].x=60
				spellicons[i].y=120+((i-1)*85)
				gbk:insert(spellicons[i])
				
				spellnames[i]=display.newText(("???"),spellicons[i].x+45,0,"MoolBoran",55)
				spellnames[i].y=spellicons[i].y+20
				spellnames[i]:setTextColor(0,0,0)
				gbk:insert(spellnames[i])
			end
		end
		
	elseif isOpn==true and (gbk) then
		if sound~=false then
			a.Play(4)
		end
		isOpn=false
		for i=table.maxn(spellicons),1,-1 do
			display.remove(spellicons[i])
			spellicons[i]=nil
		end
		spellicons=nil
		for i=table.maxn(spellnames),1,-1 do
			display.remove(spellnames[i])
			spellnames[i]=nil
		end
		spellnames=nil
		for i=table.maxn(spelltrigger),1,-1 do
			display.remove(spelltrigger[i])
			spelltrigger[i]=nil
		end
		spelltrigger=nil
		for i=gbk.numChildren,1,-1 do
			display.remove(gbk[i])
			gbk[i]=nil
		end
		gbk=nil
	end
end

function SpellInfo( event )
	local selectedSpell
	for i=1,table.maxn(spelltrigger) do
		if event.y>spelltrigger[i].y-40 and event.y<spelltrigger[i].y+40 then
			selectedSpell=i
		end
	end
	if (spellshown) then
		for i=table.maxn(spellshown),1,-1 do
			display.remove(spellshown[i])
			spellshown[i]=nil
		end
		spellshown=nil
	end
	spellshown={}
	
	if p1.spells[selectedSpell][3]==true then
		spellshown[1]=display.newText( (p1.spells[selectedSpell][1]),0,0,"MoolBoran",80)
		spellshown[1].x=((display.contentWidth/4)*3)-50
		spellshown[1].y=100
		spellshown[1]:setTextColor(0,0,0)
		gbk:insert(spellshown[1])
		
		spellshown[2]=display.newText( 
			(p1.spells[selectedSpell][2]),
			spellshown[1].x-190,
			spellshown[1].y+50,
			420,0,"MoolBoran",45
		)
		spellshown[2]:setTextColor(50,50,50)
		gbk:insert(spellshown[2])
		
		spellshown[3]=display.newText( (p1.spells[selectedSpell][4].." MP"),0,0,"MoolBoran",65)
		spellshown[3].x=spellshown[2].x-110
		spellshown[3].y=spellshown[2].y+150
		spellshown[3]:setTextColor(180,70,180)
		gbk:insert(spellshown[3])
		
		spellshown[4]=display.newText( (p1.spells[selectedSpell][5].." EP"),0,0,"MoolBoran",65)
		spellshown[4].x=spellshown[2].x+110
		spellshown[4].y=spellshown[2].y+150
		spellshown[4]:setTextColor(70,180,70)
		gbk:insert(spellshown[4])
	else
		local lang=lc.giveLang()
		local text
		if lang=="EN" then
			text="You haven't learned this spell."
		elseif lang=="ES" then
			text="No has aprendido este hechizo."
		end
		spellshown[1]=display.newText(
			(text),
			((display.contentWidth/4)*3)-240,
			150,
			420,0,"MoolBoran",45
		)
		spellshown[1]:setTextColor(50,50,50)
		gbk:insert(spellshown[1])
	end
end

function StatChange()
	for s=1,6 do
		info[#info+1]=display.newText(
			(
				p1.statnames[s]
			),
			0,0,"MoolBoran",60
		)
		info[#info].x=(display.contentWidth/4)+((display.contentWidth/2)*math.floor((s-1)%2))
		info[#info].y=110+(220*math.floor((s-1)/2))
		ginf:insert(info[#info])
	end
	for s=1,6 do
		info[#info+1]=display.newText(
			(
				p1.nat[s]
			),
			0,0,"MoolBoran",60
		)
		info[#info].x=info[#info-6].x
		info[#info].y=info[#info-6].y+80
		ginf:insert(info[#info])
	end
	for s=1,6 do
		if p1.pnts>0 and p1.nat[s]<p1.lvl*10 then
			pli[#pli+1]=  widget.newButton{
				defaultFile="sbutton.png",
				overFile="sbutton-over.png",
				width=80, height=80,
				onRelease = More
			}
			pli[#pli]:setReferencePoint( display.CenterReferencePoint )
			pli[#pli].x = info[6+s].x+90
			pli[#pli].y = info[6+s].y-10
			ginf:insert(pli[#pli])
			
			pli[#pli+1]=display.newImageRect("+.png",11,11)
			pli[#pli].x = pli[#pli-1].x
			pli[#pli].y = pli[#pli-1].y
			pli[#pli].xScale = 3.0
			pli[#pli].yScale = 3.0
			ginf:insert(pli[#pli])
		end
	end
	for s=1,6 do
		if p1.nat[s]>1 then
			mini[#mini+1]=  widget.newButton{
				defaultFile="sbutton.png",
				overFile="sbutton-over.png",
				width=80, height=80,
				onRelease = Less
			}
			mini[#mini]:setReferencePoint( display.CenterReferencePoint )
			mini[#mini].x = info[6+s].x-90
			mini[#mini].y = info[6+s].y-10
			ginf:insert(mini[#mini])
			
			mini[#mini+1]=display.newImageRect("-.png",11,11)
			mini[#mini].x = mini[#mini-1].x
			mini[#mini].y = mini[#mini-1].y
			mini[#mini].xScale = 3.0
			mini[#mini].yScale = 3.0
			ginf:insert(mini[#mini])
		end
	end
	
	swapInfoBtn=  widget.newButton{
		defaultFile="sbutton.png",
		overFile="sbutton-over.png",
		width=80, height=80,
		onRelease = SwapInfo}
	swapInfoBtn:setReferencePoint( display.CenterReferencePoint )
	swapInfoBtn.x = display.contentWidth-60
	swapInfoBtn.y = display.contentHeight-300
	swapInfoBtn.state=true
	ginf:insert( swapInfoBtn )
	
	swapInfoImg=display.newImageRect("plusminusinfo.png",70,70)
	swapInfoImg.x=swapInfoBtn.x
	swapInfoImg.y=swapInfoBtn.y
	swapInfoImg.xScale=0.7
	swapInfoImg.yScale=swapInfoImg.xScale
	ginf:insert(swapInfoImg)
	
	local lang=lc.giveLang()
	local text
	if lang=="EN" then
		text="Stat Management"
	elseif lang=="ES" then
		text="Gestion de estadisticas"
	end
	info[#info+1]=display.newText(
		(
			text
		),
		0,10,"MoolBoran",80
	)
	info[#info].x=display.contentCenterX
	info[#info]:setTextColor(125,250,125)
	ginf:insert(info[#info])
	
	if lang=="EN" then
		text="Stat Points:"
	elseif lang=="ES" then
		text="Puntos:"
	end
	info[#info+1]=display.newText(
		(
			text.." "..p1.pnts
		),
		0,700,"MoolBoran",60
	)
	info[#info].x=display.contentCenterX
	ginf:insert(info[#info])
	if p1.pnts==0 then
		info[#info]:setTextColor(180,180,180)
	end
end

function StatInfo()
	local baseX=50
	local baseY=90
	local SpacingX=350
	local SpacingY=50
	local symLength=18
	local primary=250
	local secundary=75
	if p1.name=="Error" then
		info[1]=display.newText(
			(
				"I AM ERROR."
			),
			display.contentCenterX/2,10,"MoolBoran",80
		)
		ginf:insert(info[1])
	else
		info[1]=display.newText(
			(
				p1.name
			),
			display.contentCenterX/2,10,"MoolBoran",80
		)
		ginf:insert(info[1])
	end
	
	info[#info+1]=display.newText(
		(
			"HP:"
		),
		baseX,baseY,"MoolBoran",60
	)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			p1.HP.."/"..p1.MaxHP
		),
		baseX+(#(info[#info].text)*symLength)+symLength,baseY,"MoolBoran",60
	)
	info[#info]:setTextColor(primary,secundary,secundary)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			"("..math.ceil(p1.HP/p1.MaxHP*100).."%"..")"
		),
		baseX+(#(info[#info-1].text)*symLength)+(#(info[#info].text)*symLength)+(symLength*2.25),baseY,"MoolBoran",60
	)
	info[#info]:setTextColor(primary,secundary,secundary)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			"MP:"
		),
		baseX+SpacingX,baseY,"MoolBoran",60
	)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			p1.MP.."/"..p1.MaxMP
		),
		baseX+SpacingX+(#(info[#info].text)*symLength)+symLength,baseY,"MoolBoran",60
	)
	info[#info]:setTextColor(primary,secundary,primary)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			"("..math.ceil(p1.MP/p1.MaxMP*100).."%"..")"
		),
		baseX+SpacingX+(#(info[#info-1].text)*symLength)+(#(info[#info].text)*symLength)+(symLength*2.25),baseY,"MoolBoran",60
	)
	info[#info]:setTextColor(primary,secundary,primary)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			"EP:"
		),
		baseX,baseY+SpacingY,"MoolBoran",60
	)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			p1.EP.."/"..p1.MaxEP
		),
		baseX+(#(info[#info].text)*symLength)+symLength,baseY+SpacingY,"MoolBoran",60
	)
	info[#info]:setTextColor(secundary,primary,secundary)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			"("..math.ceil(p1.EP/p1.MaxEP*100).."%"..")"
		),
		baseX+(#(info[#info-1].text)*symLength)+(#(info[#info].text)*symLength)+(symLength*2.25),baseY+SpacingY,"MoolBoran",60
	)
	info[#info]:setTextColor(secundary,primary,secundary)
	ginf:insert(info[#info])
	
	--[[
	info[#info+1]=display.newText(
		(
			"Class: "..p1.clsnames[p1.class+1]
		),
		baseX+SpacingX,baseY+(SpacingY*3),"MoolBoran",60
	)
	ginf:insert(info[#info])
	--]]
	
	local lang=lc.giveLang()
	local text
	if lang=="EN" then
		text="Level:"
	elseif lang=="ES" then
		text="Nivel:"
	end
	info[#info+1]=display.newText(
		(
			text.." "..p1.lvl
		),
		baseX,baseY+(SpacingY*2),"MoolBoran",60
	)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			"XP:"
		),
		baseX+SpacingX,baseY+(SpacingY*2),"MoolBoran",60
	)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			p1.XP.."/"..p1.MaxXP
		),
		baseX+SpacingX+(#(info[#info].text)*symLength)+symLength,baseY+(SpacingY*2),"MoolBoran",60
	)
	info[#info]:setTextColor(secundary,secundary,primary)
	ginf:insert(info[#info])
	
	info[#info+1]=display.newText(
		(
			"("..math.ceil(p1.XP/p1.MaxXP*100).."%"..")"
		),
		baseX+SpacingX+(#(info[#info-1].text)*symLength)+(#(info[#info].text)*symLength)+(symLength*2.25),baseY+(SpacingY*2),"MoolBoran",60
	)
	info[#info]:setTextColor(secundary,secundary,primary)
	ginf:insert(info[#info])
	
	if lang=="EN" then
		text="Floor:"
	elseif lang=="ES" then
		text="Piso:"
	end
	local flr=WD.Circle()
	info[#info+1]=display.newText(
		(
			text.." "..flr
		),
		baseX,baseY+(SpacingY*3),"MoolBoran",60
	)
	ginf:insert(info[#info])
	
	local text2
	if lang=="EN" then
		text="Gold:"
		text2="coins"
	elseif lang=="ES" then
		text="Oro:"
		text2="monedas"
	end
	info[#info+1]=display.newText(
		(
			text.." "..p1.gp.." "..text2
		),
		baseX+SpacingX,baseY+(SpacingY*3),"MoolBoran",60
	)
	ginf:insert(info[#info])
	
	if lang=="EN" then
		text="Statistics:"
	elseif lang=="ES" then
		text="Estadisticas:"
	end
	info[#info+1]=display.newText(
		(
			text
		),
		baseX-20,350,"MoolBoran",70
	)
	ginf:insert(info[#info])
	
	for s=1,6 do
		info[#info+1]=display.newText(
			(
				p1.statnames[s]
			),
			baseX,420+(45*(s-1)),"MoolBoran",60
		)
		ginf:insert(info[#info])
	end
	
	if lang=="EN" then
		text="Stat Points:"
	elseif lang=="ES" then
		text="Puntos:"
	end
	info[#info+1]=display.newText(
		(
			text.." "..p1.pnts
		),
		baseX,690,"MoolBoran",60
	)
	ginf:insert(info[#info])
	
	for s=1,6 do
		info[#info+1]=display.newText(
			(
				p1.nat[s]
			),
			info[#info-s].x+160,420+(45*(s-1)),"MoolBoran",60
		)
		ginf:insert(info[#info])
	end
	
	for s=1,6 do
		info[#info+1]=display.newText(
			(
			"+"..p1.eqs[s]
			),
			info[#info-s].x+60,420+(45*(s-1)),"MoolBoran",60
		)
		if p1.eqs[s]>0 then
			info[#info]:setTextColor(50,200,50)
		elseif p1.eqs[s]<0 then
			info[#info]:setTextColor(200,50,50)
		else
			info[#info]:setTextColor(150,150,150)
		end
		ginf:insert(info[#info])
	end
	
	for s=1,6 do
		info[#info+1]=display.newText(
			(
			"+"..p1.bon[s]+p1.bst[s]
			),
			info[#info-s].x+60,420+(45*(s-1)),"MoolBoran",60
		)
		if p1.bon[s]>0 then
			info[#info]:setTextColor(50,200,50)
		elseif p1.bon[s]<0 then
			info[#info]:setTextColor(200,50,50)
		else
			info[#info]:setTextColor(150,150,150)
		end
		ginf:insert(info[#info])
	end
	
	for s=1,6 do
		info[#info+1]=display.newText(
			(
				"= "..p1.stats[s]
			),
			info[#info-s].x+50,420+(45*(s-1)),"MoolBoran",60
		)
		if p1.stats[s]>p1.nat[s] then
			info[#info]:setTextColor(50,200,50)
		elseif p1.stats[s]<p1.nat[s] then
			info[#info]:setTextColor(200,50,50)
		else
		end
		ginf:insert(info[#info])
	end
	
	swapInfoBtn=  widget.newButton{
		defaultFile="sbutton.png",
		overFile="sbutton-over.png",
		width=80, height=80,
		onRelease = SwapInfo}
	swapInfoBtn:setReferencePoint( display.CenterReferencePoint )
	swapInfoBtn.x = display.contentWidth-60
	swapInfoBtn.y = display.contentHeight-300
	swapInfoBtn.state=false
	ginf:insert( swapInfoBtn )
	
	swapInfoImg=display.newImageRect("plusminus.png",70,70)
	swapInfoImg.x=swapInfoBtn.x
	swapInfoImg.y=swapInfoBtn.y
	swapInfoImg.xScale=0.7
	swapInfoImg.yScale=swapInfoImg.xScale
	ginf:insert(swapInfoImg)
	
	ginf:toFront()
end

function SwapInfo(sound)
	if sound~=false then
		a.Play(4)
	end
	if swapInfoBtn.state==false then
		for i=table.maxn(info),1,-1 do
			display.remove(info[i])
			info[i]=nil
		end
		for i=table.maxn(mini),1,-1 do
			display.remove(mini[i])
			mini[i]=nil
		end
		for i=table.maxn(pli),1,-1 do
			display.remove(pli[i])
			pli[i]=nil
		end
		for i=ginf.numChildren,1,-1 do
			display.remove(ginf[i])
			ginf[i]=nil
		end
		StatChange()
	else
		for i=table.maxn(info),1,-1 do
			display.remove(info[i])
			info[i]=nil
		end
		for i=table.maxn(mini),1,-1 do
			display.remove(mini[i])
			mini[i]=nil
		end
		for i=table.maxn(pli),1,-1 do
			display.remove(pli[i])
			pli[i]=nil
		end
		for i=ginf.numChildren,1,-1 do
			display.remove(ginf[i])
			ginf[i]=nil
		end
		StatInfo()
	end
end

function DoExit()
	native.requestExit()
end

function MusicScroll( event )
	if event.x>display.contentCenterX+(290*scroll.xScale) then
		scrollind.x=display.contentCenterX+(290*scroll.xScale)
		a.MusicVol(1.0)
		musicind.text=(lc.giveText("LOC003").." "..(1.0*100).."%")
	elseif event.x<display.contentCenterX-(290*scroll.xScale) then
		scrollind.x=display.contentCenterX-(290*scroll.xScale)
		a.MusicVol(0.0)
		musicind.text=(lc.giveText("LOC003").." "..(0.0*100).."%")
	else
		for s=1,11 do
			local x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*58 )
			if event.x>x-(290*scroll.xScale)/10 and event.x<x+(290*scroll.xScale)/10 then
				scrollind.x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*(290*scroll.xScale)/5 )
				a.MusicVol((s-1)/10)
				musicind.text=(lc.giveText("LOC003").." "..((s-1)*10).."%")
			end
		end
	end
end

function SoundScroll( event )
	if event.x>display.contentCenterX+(290*scroll.xScale) then
		scrollind2.x=display.contentCenterX+(290*scroll.xScale)
		a.SoundVol(1.0)
		soundind.text=(lc.giveText("LOC004").." "..(1.0*100).."%")
	elseif event.x<display.contentCenterX-(290*scroll.xScale) then
		scrollind2.x=display.contentCenterX-(290*scroll.xScale)
		a.SoundVol(0.0)
		soundind.text=(lc.giveText("LOC004").." "..(0.0*100).."%")
	else
		for s=1,11 do
			local x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*58 )
			if event.x>x-(290*scroll.xScale)/10 and event.x<x+(290*scroll.xScale)/10 then
				scrollind2.x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*(290*scroll.xScale)/5 )
				a.SoundVol((s-1)/10)
				soundind.text=(lc.giveText("LOC004").." "..((s-1)*10).."%")
			end
		end
	end
end

function More( event )
	local statnum
	for i=1,12 do
		if (pli[i]) then
			if event.y+50>pli[i].y and event.y-50<pli[i].y and event.x+50>pli[i].x and event.x-50<pli[i].x then
				statnum=math.ceil(i/2)
			end
		end
	end
	p.Natural(statnum,1)
	SwapInfo(false)
	SwapInfo()
end

function Less( event )
	local statnum
	for i=1,12 do
		if (mini[i]) then
			if event.y+50>mini[i].y and event.y-50<mini[i].y and event.x+50>mini[i].x and event.x-50<mini[i].x then
				statnum=math.ceil(i/2)
			end
		end
	end
	p.Natural(statnum,-1)
	SwapInfo(false)
	SwapInfo()
end

function DeathMenu(cause)
	if isOpn==false then
		gdm=display.newGroup()
		isOpn=true
		m.FindMe(9)
		DMenu=display.newImageRect("deathmenu.png", 700, 500)
		DMenu.x,DMenu.y = display.contentCenterX, 450
		Dthtxt=display.newGroup()
		gdm:insert( DMenu )
		
		Deathmsg=display.newText("Game Over!",0,0, "MoolBoran", 90)
		Deathmsg.x = display.contentCenterX
		Deathmsg.y = 290
		Dthtxt:insert( Deathmsg )
		
		Deathmsg2=display.newText(" ",0,0,"MoolBoran", 55)
		Deathmsg2:setTextColor(180, 180, 180)
		Deathmsg2.x = display.contentCenterX
		Deathmsg2.y = Deathmsg.y+50
		Dthtxt:insert( Deathmsg2 )
		
		if cause=="Lava" then
			Deathmsg2.text=(DeathMessages[lc.giveLang()][1][math.random(1,table.maxn(DeathMessages[1]))])
		end
		if cause=="Mob" then
			Deathmsg2.text=(DeathMessages[lc.giveLang()][2][math.random(1,table.maxn(DeathMessages[1]))])
		end
		if cause=="Poison" then
			Deathmsg2.text=(DeathMessages[lc.giveLang()][3][math.random(1,table.maxn(DeathMessages[1]))])
		end
		if cause=="Portal" then
			Deathmsg2.text=(DeathMessages[lc.giveLang()][4][math.random(1,table.maxn(DeathMessages[1]))])
		end
		if cause=="Energy" then
			Deathmsg2.text=(DeathMessages[lc.giveLang()][5][math.random(1,table.maxn(DeathMessages[1]))])
		end
		
		local lang=lc.giveLang()
		local text
		if lang=="EN" then
			text="Back to Menu"
		elseif lang=="ES" then
			text="Volver al Menu"
		end
		ToMenuBtn =  widget.newButton{
			label=text,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=290, height=80,
			onRelease = onToMenuBtnRelease
		}
		ToMenuBtn.x = display.contentCenterX
		ToMenuBtn.y = display.contentHeight*0.61
		gdm:insert( ToMenuBtn )
		
		Round=WD.Circle()
		p1=p.GetPlayer()
		size=b.GetData(0)
		scre,hs=sc.Scoring( Round , p1 , (math.sqrt(size)) )
		Round=tostring(Round)
		GCount=tostring(p1.gp)
		GInfoTxt=display.newGroup()
		
		if lang=="EN" then
			text="You got to floor "
		elseif lang=="ES" then
			text="Llegaste al piso "
		end
		InfoTxt1=display.newText(text,0,0,"MoolBoran", 60 )
		InfoTxt1.x=225
		InfoTxt1.y=Deathmsg2.y+100
		GInfoTxt:insert( InfoTxt1 )
		
		InfoTxt2=display.newText(Round,InfoTxt1.x+140+(25*(#Round-1)),0,"MoolBoran", 60 )
		InfoTxt2:setTextColor(50, 255, 50)
		InfoTxt2.y=InfoTxt1.y
		GInfoTxt:insert( InfoTxt2 )
		
		if lang=="EN" then
			text=" with "
		elseif lang=="ES" then
			text=" con "
		end
		InfoTxt3= display.newText(text,InfoTxt2.x+25+(25*(#Round-1)),0,"MoolBoran", 60 )
		InfoTxt3.y=InfoTxt1.y
		GInfoTxt:insert( InfoTxt3 )
		
		InfoTxt4=display.newText(GCount,InfoTxt3.x+50,0,"MoolBoran", 60 )
		InfoTxt4.y=InfoTxt1.y
		InfoTxt4:setTextColor(255, 255, 50)
		GInfoTxt:insert( InfoTxt4 )
		
		if lang=="EN" then
			text=" gold."
		elseif lang=="ES" then
			text=" de oro."
		end
		InfoTxt5=display.newText(" gold.",InfoTxt4.x+25+(15*(#GCount-1)),0,"MoolBoran", 60 )
		InfoTxt5.y=InfoTxt1.y
		GInfoTxt:insert( InfoTxt5 )
		
		if hs==true then
			if lang=="EN" then
				text="New high score:"
			elseif lang=="ES" then
				text="Nuevo puntaje maximo:"
			end
			InfoTxt6=display.newText((text),0,0,"MoolBoran", 60 )
			InfoTxt6:setTextColor(70, 255, 70)
			InfoTxt6.x=display.contentCenterX
			InfoTxt6.y=display.contentCenterY-20
			GInfoTxt:insert( InfoTxt6 )
		else
			if lang=="EN" then
				text="Score:"
			elseif lang=="ES" then
				text="Puntaje:"
			end
			InfoTxt6=display.newText((text),0,0,"MoolBoran", 60 )
			InfoTxt6:setTextColor(70, 255, 70)
			InfoTxt6.x=display.contentCenterX
			InfoTxt6.y=display.contentCenterY-20
			GInfoTxt:insert( InfoTxt6 )
		end
		
		InfoTxt7=display.newText((scre),0,0,"MoolBoran", 60 )
		InfoTxt7.x=display.contentCenterX
		InfoTxt7.y=display.contentCenterY+40
		GInfoTxt:insert( InfoTxt7 )
		
		gdm:insert( Dthtxt )
		gdm:insert( GInfoTxt )
		gdm:toFront()
		
		Runtime:removeEventListener("enterFrame", g.GoldDisplay)
		b.WipeMap()
		mov.CleanArrows()
		a.changeMusic(0)
		s.WipeSave()
		
	elseif isOpn==true then
		for i=gdm.numChildren,1,-1 do
			display.remove(gdm[i])
			gdm[i]=nil
		end
		gdm=nil
		isOpn=false
	end
end

function AddItem(id,stacks,amount)
	local itmnme=item.ReturnInfo(id,0)
	local ItemAdded=false
	if not (amount) then
		amount=1
	end
	if table.maxn(p1.inv)==63 then
	--	print "Inventory is full!"
		return false
	elseif table.maxn(p1.inv)==0 then
		p1.inv[(#p1.inv+1)]={}
		p1.inv[(#p1.inv)][1]=id
		p1.inv[(#p1.inv)][2]=amount
	--	print ("Player now has "..p1.inv[1][2].." of "..itmnme..".")
	else
		for i=1, table.maxn(p1.inv) do
			if ItemAdded==false then
				if p1.inv[i] and p1.inv[i][1]==id and stacks==true then
						p1.inv[i][2]=((p1.inv[i][2])+amount)
		--				print ("Player now has "..p1.inv[i][2].." of "..itmnme..".")
						ItemAdded=true
				elseif i==(table.maxn(p1.inv)-1) then
				end
			end
		end
		if ItemAdded==false then
			p1.inv[(#p1.inv+1)]={}
			p1.inv[(#p1.inv)][1]=id
			p1.inv[(#p1.inv)][2]=amount
		--	print ("Player now has "..p1.inv[#p1.inv][2].." of "..itmnme..".")
			ItemAdded=true
		end
	end
end

function UseMenu(id,slot)
	if isUse==false then
		if id~=false then
			a.Play(3)
		end
	
		function UsedIt()
			isUse=false
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			gum=nil
			p1.inv[slot][2]=p1.inv[slot][2]-1
			if p1.inv[slot][2]==0 then
				table.remove( p1.inv, slot )
			end
			if itemstats[3]==0 then
				if itemstats[4]<0 then
					p.ReduceHP((itemstats[4]*-1),"Poison")
				elseif itemstats[4]>0 then
					p.AddHP(itemstats[4])
				end
				ToggleBag()
				ToggleBag()
			elseif itemstats[3]==1 then
				p.AddMP(itemstats[4])
				ToggleBag()
				ToggleBag()
			elseif itemstats[3]==2 then
				p.AddEP(itemstats[4])
				ToggleBag()
				ToggleBag()
			else
				ToggleBag()
				ui.Pause(true)
				if itemstats[4]==0 then
					WD.FloorPort(false)
				elseif itemstats[4]==1 then
					WD.FloorPort(true)
				elseif itemstats[4]==2 then
					b.Expand()
				end
			end
		end
		
		function LearnedIt()
			isUse=false
			local watevah=item.ReturnInfo(id,1)
			p.LearnSorcery(watevah)
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			gum=nil
			table.remove( p1.inv, slot )
			ToggleBag()
			ToggleBag()
		end
		
		function StatBoost()
			isUse=false
			local watevah=item.ReturnInfo(id,2)
			p.StatBoost(watevah)
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			gum=nil
			p1.inv[slot][2]=p1.inv[slot][2]-1
			if p1.inv[slot][2]==0 then
				table.remove( p1.inv, slot )
			end
			ToggleBag()
			ToggleBag()
		end
		
		function EquippedIt()
			a.Play(8)
			for i=1,table.maxn(p1.eqp) do
				if (p1.eqp[i]) and (p1.eqp[i][1]) and (p1.eqp[i][2]) and (p1.eqp[i][2]==itemstats[3]) then
					p1.inv[#p1.inv+1]={}
					p1.inv[#p1.inv][1]=p1.eqp[i][1]
					p1.inv[#p1.inv][2]=1
					table.remove( p1.eqp, (i) )
				end
			end
			
			p1.eqp[#p1.eqp+1]={}
			p1.eqp[#p1.eqp][1]=id
			p1.eqp[#p1.eqp][2]=itemstats[3]
			
			isUse=false
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			gum=nil
			
			table.remove( p1.inv, slot )
			
			ToggleBag()
			ToggleBag()
			p.ModStats(statchange[1],statchange[2],statchange[3],statchange[4],statchange[5],statchange[6])
			statchange={}
		end
		
		function DroppedIt()
			statchange={}
			isUse=false
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			gum=nil
			table.remove( p1.inv, slot )
			ToggleBag()
			ToggleBag()
		end
		
		gum=display.newGroup()
		gum:toFront()
		isUse=true
		
	--	print ("Player wants to use item "..id..", in slot "..slot..".")
		window=display.newImageRect("usemenu.png", 768, 308)
		window.x,window.y = display.contentWidth/2, 450
		gum:insert( window )
		
		for i=1,table.maxn(items) do
			if items[i] then
				items[i]:removeEventListener("tap",Gah)
			end
		end
		for i=1,table.maxn(curreqp) do
			if curreqp[i] then
				curreqp[i]:removeEventListener("tap",Argh)
			end
		end
		
		local lang=lc.giveLang()
		local text
		if lang=="EN" then
			text="Back"
		elseif lang=="ES" then
			text="Volver"
		end
		local backbtn=  widget.newButton{
			label=text,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=200, height=55,
			onRelease = UseMenu}
		backbtn:setReferencePoint( display.CenterReferencePoint )
		backbtn.x = (display.contentWidth/2)
		backbtn.y = (display.contentHeight/2)+30
		gum:insert( backbtn )
		
		if lang=="EN" then
			text="Drop"
		elseif lang=="ES" then
			text="Tirar"
		end
		local dropbtn=  widget.newButton{
			label=text,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=200, height=55,
			onRelease = DroppedIt}
		dropbtn:setReferencePoint( display.CenterReferencePoint )
		dropbtn.x = ((display.contentWidth/4)*3)+50
		dropbtn.y = (display.contentHeight/2)+30
		gum:insert( dropbtn )
		
		itemstats={
			item.ReturnInfo(id,4)
		}
		
		local lolname=display.newText( (itemstats[2]) ,0,0,"MoolBoran",90)
		lolname.x=display.contentWidth/2
		lolname.y=(display.contentHeight/2)-120
		gum:insert( lolname )
		
		if itemstats[1]==0 then
			if lang=="EN" then
				text="Use"
			elseif lang=="ES" then
				text="Usar"
			end
			local usebtn=  widget.newButton{
				label=text,
				labelColor = { default={255,255,255}, over={0,0,0} },
				font="MoolBoran",
				fontSize=50,
				labelYOffset=10,
				defaultFile="cbutton.png",
				overFile="cbutton-over.png",
				width=200, height=55,
				onRelease = UsedIt
			}
			usebtn:setReferencePoint( display.CenterReferencePoint )
			usebtn.x = (display.contentWidth/4)-50
			usebtn.y = (display.contentHeight/2)+30
			gum:insert( usebtn )
			
			local descrip=display.newText( (itemstats[5]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
		end	
		if itemstats[1]==1 then
			if lang=="EN" then
				text="Equip"
			elseif lang=="ES" then
				text="Equipar"
			end
			local equipbtn=  widget.newButton{
				label=text,
				labelColor = { default={255,255,255}, over={0,0,0} },
				font="MoolBoran",
				fontSize=50,
				labelYOffset=10,
				defaultFile="cbutton.png",
				overFile="cbutton-over.png",
				width=200, height=55,
				onRelease = EquippedIt
			}
			equipbtn:setReferencePoint( display.CenterReferencePoint )
			equipbtn.x = (display.contentWidth/4)-50
			equipbtn.y = (display.contentHeight/2)+30
			gum:insert( equipbtn )
			
			local itmfound=false
			local equipstats
			for i=1,table.maxn(p1.eqp) do
				if p1.eqp[i][2]==itemstats[3] then
					equipstats={item.ReturnInfo(p1.eqp[i][1],4)}
					itmfound=true
				end
			end
			
			if itmfound==false then
				equipstats={0,0,0,0,0,0,0,0,0}
			end
			
			statchange={
				itemstats[4]-equipstats[4],
				itemstats[5]-equipstats[5],
				itemstats[6]-equipstats[6],
				itemstats[7]-equipstats[7],
				itemstats[8]-equipstats[8],
				itemstats[9]-equipstats[9]
			}
			stattxts={}
			
			local eqpstatchnge=false
			local stats={"STA","ATT","DEF","MGC","DEX","INT"}
			for c=1,6 do
				if statchange[c]>0 then
					stattxts[c]=display.newText( (stats[c].." +"..statchange[c]),0,0,"MoolBoran",60)
					stattxts[c]:setTextColor( 60, 180, 60)
					stattxts[c].x=statchangex+(statchangexs*((c-1)%3))
					stattxts[c].y=statchangey+(50*math.floor((c-1)/3))
					gum:insert( stattxts[c] )
					eqpstatchnge=true
				elseif statchange[c]<0 then
					stattxts[c]=display.newText( (stats[c].." "..statchange[c]) ,0,0,"MoolBoran",60)
					stattxts[c]:setTextColor( 180, 60, 60)
					stattxts[c].x=statchangex+(statchangexs*((c-1)%3))
					stattxts[c].y=statchangey+(50*math.floor((c-1)/3))
					gum:insert( stattxts[c] )
					eqpstatchnge=true
				end
			end
			
			if eqpstatchnge==false then
				if lang=="EN" then
					text="No change."
				elseif lang=="ES" then
					text="No hay cambio."
				end
				stattxts[1]=display.newText( (text) ,0,0,"MoolBoran",55)
				stattxts[1]:setTextColor( 180, 180, 180)
				stattxts[1].y=(display.contentHeight/2)-50
				stattxts[1].x=display.contentWidth/2
				gum:insert( stattxts[1] )
			end
		end
		if itemstats[1]==2 then
			if itemstats[4]==0 or itemstats[4]==1 then
				if lang=="EN" then
					text="Teleport"
				elseif lang=="ES" then
					text="Teletransportar"
				end
				local usebtn=  widget.newButton{
					label=text,
					labelColor = { default={255,255,255}, over={0,0,0} },
					font="MoolBoran",
					fontSize=50,
					labelYOffset=10,
					defaultFile="cbutton.png",
					overFile="cbutton-over.png",
					width=200, height=55,
					onRelease = UsedIt
				}
				usebtn:setReferencePoint( display.CenterReferencePoint )
				usebtn.x = (display.contentWidth/4)-50
				usebtn.y = (display.contentHeight/2)+30
				gum:insert( usebtn )
			elseif itemstats[4]==2 then
				if lang=="EN" then
					text="Expand"
				elseif lang=="ES" then
					text="Expandir"
				end
				local usebtn=  widget.newButton{
					label=text,
					labelColor = { default={255,255,255}, over={0,0,0} },
					font="MoolBoran",
					fontSize=50,
					labelYOffset=10,
					defaultFile="cbutton.png",
					overFile="cbutton-over.png",
					width=200, height=55,
					onRelease = UsedIt
				}
				usebtn:setReferencePoint( display.CenterReferencePoint )
				usebtn.x = (display.contentWidth/4)-50
				usebtn.y = (display.contentHeight/2)+30
				gum:insert( usebtn )
			end
			
			local descrip=display.newText( (itemstats[3]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
		end
		if itemstats[1]==3 then
			if lang=="EN" then
				text="Learn"
			elseif lang=="ES" then
				text="Aprender"
			end
			local learnbtn=  widget.newButton{
				label=text,
				labelColor = { default={255,255,255}, over={0,0,0} },
				font="MoolBoran",
				fontSize=50,
				labelYOffset=10,
				defaultFile="cbutton.png",
				overFile="cbutton-over.png",
				width=200, height=55,
				onRelease = LearnedIt
			}
			learnbtn:setReferencePoint( display.CenterReferencePoint )
			learnbtn.x = (display.contentWidth/4)-50
			learnbtn.y = (display.contentHeight/2)+30
			gum:insert( learnbtn )
			
			local descrip=display.newText( (itemstats[4]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
			
		end
		if itemstats[1]==4 then
			if lang=="EN" then
				text="Use"
			elseif lang=="ES" then
				text="Usar"
			end
			local boostbtn=  widget.newButton{
				label=text,
				labelColor = { default={255,255,255}, over={0,0,0} },
				font="MoolBoran",
				fontSize=50,
				labelYOffset=10,
				defaultFile="cbutton.png",
				overFile="cbutton-over.png",
				width=200, height=55,
				onRelease = StatBoost
			}
			boostbtn:setReferencePoint( display.CenterReferencePoint )
			boostbtn.x = (display.contentWidth/4)-50
			boostbtn.y = (display.contentHeight/2)+30
			gum:insert( boostbtn )
			
			local descrip=display.newText( (itemstats[4]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
			
		end
		
	elseif isUse==true then
		if id~=false then
			a.Play(4)
		end
		SpecialUClose()
		ToggleBag(false)
		ToggleBag(false)
	end
end

function CheckMenu(id)

	if isUse==false then
		gum=display.newGroup()
		gum:toFront()
		isUse=true
		
	--	print ("Player wants to use item "..id..", in slot "..slot..".")
		window=display.newImageRect("usemenu.png", 768, 308)
		window.x,window.y = display.contentWidth/2, 450
		gum:insert( window )
		
		for i=1,table.maxn(items) do
			if items[i] then
				items[i]:removeEventListener("tap",Gah)
			end
		end
		for i=1,table.maxn(curreqp) do
			if curreqp[i] then
				curreqp[i]:removeEventListener("tap",Argh)
			end
		end
		
		if lang=="EN" then
			text="Back"
		elseif lang=="ES" then
			text="Volver"
		end
		local backbtn=  widget.newButton{
			label=text,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=200, height=55,
			onRelease = CheckMenu}
		backbtn:setReferencePoint( display.CenterReferencePoint )
		backbtn.x = (display.contentWidth/2)
		backbtn.y = (display.contentHeight/2)+30
		gum:insert( backbtn )
		
		itemstats={
			item.ReturnInfo(id,4)
		}
		
		local lolname=display.newText( (itemstats[2]) ,0,0,"MoolBoran",90)
		lolname.x=display.contentWidth/2
		lolname.y=(display.contentHeight/2)-120
		gum:insert( lolname )
		
		if itemstats[1]==1 then
			
			statchange={
				itemstats[4],
				itemstats[5],
				itemstats[6],
				itemstats[7],
				itemstats[8],
				itemstats[9]
			}
			stattxts={}
			
			local stats={"STA","ATT","DEF","MGC","DEX","INT"}
			for c=1,6 do
				if statchange[c]>0 then
					stattxts[c]=display.newText( (stats[c].." +"..statchange[c]),0,0,"MoolBoran",60)
					stattxts[c]:setTextColor( 60, 180, 60)
					stattxts[c].x=statchangex+(statchangexs*((c-1)%3))
					stattxts[c].y=statchangey+(50*math.floor((c-1)/3))
					gum:insert( stattxts[c] )
				elseif statchange[c]<0 then
					stattxts[c]=display.newText( (stats[c].." "..statchange[c]) ,0,0,"MoolBoran",60)
					stattxts[c]:setTextColor( 180, 60, 60)
					stattxts[c].x=statchangex+(statchangexs*((c-1)%3))
					stattxts[c].y=statchangey+(50*math.floor((c-1)/3))
					gum:insert( stattxts[c] )
				end
			end
		end
	elseif isUse==true then
		SpecialUClose()
		ToggleBag()
		ToggleBag()
	end
end

function SpecialUClose()
	isUse=false
	statchange={}
	for i=gum.numChildren,1,-1 do
		local child = gum[i]
		child.parent:remove( child )
	end
	gum=nil
end

function OpenWindow()
	return isOpn
end

function SilentQuip(id)
	itemstats={
		item.ReturnInfo(id,4)
	}
	p.ModStats(itemstats[4],itemstats[5],itemstats[6],itemstats[7],itemstats[8],itemstats[9])
	p1.eqp[#p1.eqp+1]={}
	p1.eqp[#p1.eqp][1]=id
	p1.eqp[#p1.eqp][2]=itemstats[3]
end

function onToMenuBtnRelease()
	if (gdm) then
		DeathMenu()
	end
	if (ginf) then
		ToggleInfo()
	end
	WD.SrsBsns()
end

function InvFull()
	if table.maxn(p1.inv)==63 then
	--	print "Inventory is full!"
		return true
	else
		return false
	end
end

function InvCheck()
	for a=table.maxn(p1.inv),1,-1 do
		for b=table.maxn(p1.inv),1,-1 do
			if (p1.inv[a])and(p1.inv[b]) and a~=b then
				if p1.inv[a][1]==p1.inv[b][1] then
					local stack=item.ReturnInfo(p1.inv[a][1],3)
					if stack==true then
						p1.inv[a][2]=p1.inv[a][2]+p1.inv[b][2]
						table.remove(p1.inv,b)
					end
				end
			end
		end
	end
end
