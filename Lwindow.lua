-----------------------------------------------------------------------------------------
--
-- Windows.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local HPot2sheet = graphics.newImageSheet( "items/HealthPotion2.png", { width=64, height=64, numFrames=16 })
local HPot3sheet = graphics.newImageSheet( "items/HealthPotion3.png", { width=64, height=64, numFrames=16 })
local MPot2sheet = graphics.newImageSheet( "items/ManaPotion2.png", { width=64, height=64, numFrames=16 })
local MPot3sheet = graphics.newImageSheet( "items/ManaPotion3.png", { width=64, height=64, numFrames=16 })
local EPot2sheet = graphics.newImageSheet( "items/EnergyPotion2.png", { width=64, height=64, numFrames=16 })
local EPot3sheet = graphics.newImageSheet( "items/EnergyPotion3.png", { width=64, height=64, numFrames=16 })
local widget = require "widget"
<<<<<<< HEAD
local audio=require("LAudio")
local g=require("LGold")
=======
local a=require("Laudio")
local g=require("Lgold")
>>>>>>> B1.9.0
local c=require("Lcombat")
local mov=require("Lmovement")
local p=require("Lplayers")
local WD=require("Lprogress")
local ui=require("Lui")
local item=require("Litems")
local sc=require("Lscore")
local b=require("Lmapbuilder")
local s=require("Lsaving")
local ginv
local geqp
local ginf
local gdm
local gum
local swg
local gexui
local isOpn
local isUse
local items

function Essentials()
	p1=p.GetPlayer()
	xinvicial=75
	yinvicial=156
	espaciox=64
	espacioy=64
	xeqpicial=75
	yeqpicial=698
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
			UseMenu()
		end
		if (swg) then
			ToggleSound()
		end
		if (ginf) then
			ToggleInfo()
		end
		if (ginv) then
			ToggleBag()
		end
		if (gexui) then
			ToggleExit()
		end
		return true
	else
		return false
	end
end

function ToggleBag()
	if isOpn==false then
		ginv=display.newGroup()
		items={}
		curreqp={}
		
		invinterface=display.newImageRect("container.png", 570, 549)
		invinterface.x,invinterface.y = display.contentWidth/2, 400
		invinterface.xScale,invinterface.yScale=1.2280701755,1.2280701755
		ginv:insert( invinterface )
		isOpn=true
		
		InvCheck()
		
		for i=1,table.maxn(p1.inv) do
			if (p1.inv[i])~=nil then
				local itmnme=item.ReturnInfo(p1.inv[i][1],0)
	--			print ("Player has "..p1.inv[i][2].." of "..itmnme..".")
				if p1.inv[i][1]==2 then
					items[#items+1]=display.newSprite( HPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					items[#items]:play()
				elseif p1.inv[i][1]==3 then
					items[#items+1]=display.newSprite( HPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					items[#items]:play()
				elseif p1.inv[i][1]==7 then
					items[#items+1]=display.newSprite( MPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					items[#items]:play()
				elseif p1.inv[i][1]==8 then
					items[#items+1]=display.newSprite( MPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					items[#items]:play()
				elseif p1.inv[i][1]==10 then
					item[i]=display.newSprite( EPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					item[i]:play()
				elseif p1.inv[i][1]==11 then
					item[i]=display.newSprite( EPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					item[i]:play()
				else
					items[#items+1]=display.newImageRect( "items/"..itmnme..".png" ,64,64)
				end
				items[#items].xScale=1.140625
				items[#items].yScale=1.140625
				items[#items].x = xinvicial+ (((#items-1)%9)*((espaciox*items[#items].xScale)+4))
				items[#items].y = yinvicial+ ((math.floor((#items-1)/9))*((espacioy*items[#items].yScale)+4))
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
				curreqp[#curreqp].xScale=1.140625
				curreqp[#curreqp].yScale=1.140625
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
				curreqp[#curreqp].x = xeqpicial+ (((plcmnt-1)%9)*((espaciox*curreqp[#curreqp].xScale)+4))
				curreqp[#curreqp].y = yeqpicial
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

function ToggleInfo()
	if isOpn==false then
		isOpn=true
		ginf=display.newGroup()
		info={}
		
		bkg=display.newImageRect("bkgs/pausebkg.png", 768, 800)
		bkg.x,bkg.y = display.contentWidth/2, 400
		ginf:insert( bkg )
		
		if p1.name=="Error" then
			info[1]=display.newText(
				(
					"I AM ERROR."
				),
				10,10,"MoolBoran",80
			)
			ginf:insert(info[1])
		else
			info[1]=display.newText(
				(
					p1.name
				),
				10,10,"MoolBoran",80
			)
			ginf:insert(info[1])
		end
		local baseX=30
		local baseY=90
		local SpacingX=300
		local SpacingY=50
		
		info[#info+1]=display.newText(
			(
				"HP: "..p1.HP.."/"..p1.MaxHP
			),
			baseX,baseY,"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		info[#info+1]=display.newText(
			(
				"MP: "..p1.MP.."/"..p1.MaxMP
			),
			baseX+SpacingX,baseY,"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		info[#info+1]=display.newText(
			(
				"EP: "..p1.EP.."/"..p1.MaxEP
			),
			baseX,baseY+SpacingY,"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		info[#info+1]=display.newText(
			(
				"Gold: "..p1.gp
			),
			baseX+SpacingX,baseY+SpacingY,"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		info[#info+1]=display.newText(
			(
				"Level: "..p1.lvl
			),
			baseX,baseY+(SpacingY*2),"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		info[#info+1]=display.newText(
			(
				"XP: "..p1.XP.."/"..p1.MaxXP
			),
			baseX+SpacingX,baseY+(SpacingY*2),"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		local flr=WD.Circle()
		info[#info+1]=display.newText(
			(
				"Floor: "..flr
			),
			baseX,baseY+(SpacingY*3),"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		info[#info+1]=display.newText(
			(
				"Class: "..p1.clsnames[p1.class+1]
			),
			baseX+SpacingX,baseY+(SpacingY*3),"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		
		info[#info+1]=display.newText(
			(
				"Statistics:"
			),
			10,350,"MoolBoran",70
		)
		ginf:insert(info[#info])
		
		for s=1,6 do
			info[#info+1]=display.newText(
				(
					p1.statnames[s]
				),
				30,420+(45*(s-1)),"MoolBoran",60
			)
			ginf:insert(info[#info])
		end
		
		info[#info+1]=display.newText(
			(
				"Stat Points: "..p1.pnts
			),
			30,690,"MoolBoran",60
		)
		ginf:insert(info[#info])
		
		for s=1,6 do
			info[#info+1]=display.newText(
				(
					p1.nat[s]
				),
				info[#info-s].x+220,420+(45*(s-1)),"MoolBoran",60
			)
			ginf:insert(info[#info])
		end
		
		for s=1,6 do
			info[#info+1]=display.newText(
				(
				"+"..p1.eqs[s]
				),
				info[#info-s].x+100,420+(45*(s-1)),"MoolBoran",60
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
		
		if p1.name=="Magus" then
			info[#info+1]=display.newImageRect("player/magus.png",120,120)
			info[#info].x=display.contentWidth-120
			info[#info].y=150
			info[#info].xScale=1.5
			info[#info].yScale=info[#info].xScale
			ginf:insert(info[#info])
		end
		
		if p1.pnts~=0 then
			pli={}
			mini={}
			for n=1,6 do
				--
				if (p1.nat[n]+1)<(p1.lvl*12) then
					pli[n]=widget.newButton{
						defaultFile="+.png",
						overFile="+2.png",
						width=20, height=20,
						onRelease = More,
					}
					pli[n].xScale,pli[n].yScale=2.0,2.0
					pli[n].x = info[17+n].x+45
					pli[n].y = 445+((n-1)*45)
					ginf:insert(pli[n])
				end
				--
				if p1.nat[n]-1~=0 then
					mini[n]=widget.newButton{
						defaultFile="-.png",
						overFile="-2.png",
						width=20, height=20,
						onRelease = Less,
					}
					mini[n].xScale,mini[n].yScale=2.0,2.0
					mini[n].x = info[17+n].x-75
					mini[n].y = 445+((n-1)*45)
					ginf:insert(mini[n])
				end
			end
		end
		ginf:toFront()
		
	elseif isOpn==true and (ginf) then
		isOpn=false
		for i=table.maxn(info),1,-1 do
			display.remove(info[i])
			info[i]=nil
		end
		info=nil
		for i=ginf.numChildren,1,-1 do
			display.remove(ginf[i])
			ginf[i]=nil
		end
		ginf=nil
	end
end

function ToggleSound()
	if isOpn==false then
		isOpn=true
		swg=display.newGroup()
		
		window=display.newImageRect("usemenu.png",768,308)
		window.x=display.contentCenterX
		window.y=display.contentCenterY
		swg:insert(window)
		
		scroll=display.newImageRect("scroll.png",600,50)
		scroll.x=display.contentCenterX
		scroll.y=display.contentCenterY-40
		scroll:addEventListener("touch",MusicScroll)
		swg:insert(scroll)
		
		local m=a.muse()
		m=m*10
		scrollind=display.newImageRect("scrollind.png",15,50)
		scrollind.x=display.contentCenterX-290+( m*58 )
		scrollind.y=scroll.y
		swg:insert(scrollind)
		
		musicind=display.newText( ("Music Volume: "..(m*10).."%"),0,0,"MoolBoran",50 )
		musicind.x=scroll.x
		musicind.y=scroll.y+10
		swg:insert(musicind)
		
		scroll2=display.newImageRect("scroll.png",600,50)
		scroll2.x=display.contentCenterX
		scroll2.y=scroll.y+80
		scroll2:addEventListener("touch",SoundScroll)
		swg:insert(scroll2)
		
		local s=a.sfx()
		s=s*10
		scrollind2=display.newImageRect("scrollind.png",15,50)
		scrollind2.x=display.contentCenterX-290+( s*58 )
		scrollind2.y=scroll2.y
		swg:insert(scrollind2)
		
		soundind=display.newText( ("Sound Volume: "..(s*10).."%"),0,0,"MoolBoran",50 )
		soundind.x=scroll2.x
		soundind.y=scroll2.y+10
		swg:insert(soundind)

	elseif isOpn==true and (swg) then
		isOpn=false
		for i=swg.numChildren,1,-1 do
			display.remove(swg[i])
			swg[i]=nil
		end
		swg=nil
	end
end

function ToggleExit()
	if isOpn==false then
		isOpn=true
		gexui=display.newGroup()
		
		window=display.newImageRect("usemenu.png", 768, 308)
		window.x,window.y = display.contentWidth/2, 450
		gexui:insert( window )
		
		lolname=display.newText( ("You pressed the exit button.") ,0,0,"MoolBoran",70)
		lolname.x=display.contentCenterX
		lolname.y=(display.contentHeight/2)-140
		gexui:insert( lolname )
		
		lolname2=display.newText( ("Are you sure you want to exit?") ,0,0,"MoolBoran",55)
		lolname2.x=display.contentCenterX
		lolname2.y=lolname.y+50
		gexui:insert(lolname2)
		

		lolname3=display.newText( ("\(Unsaved progress will be lost.\)") ,0,0,"MoolBoran",40)
		lolname3:setTextColor(180,180,180)
		lolname3.x=display.contentCenterX
		lolname3.y=lolname2.y+50
		gexui:insert(lolname3)
		
		AcceptBtn= widget.newButton{
			label="Yes",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton2.png",
			width=200, height=55,
			onRelease = DoExit}
		AcceptBtn:setReferencePoint( display.CenterReferencePoint )
		AcceptBtn.x = (display.contentWidth/2)-130
		AcceptBtn.y = (display.contentHeight/2)+30
		gexui:insert( AcceptBtn )
		
		BackBtn= widget.newButton{
			label="No",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton2.png",
			width=200, height=55,
			onRelease = ToggleExit}
		BackBtn:setReferencePoint( display.CenterReferencePoint )
		BackBtn.x = (display.contentWidth/2)+130
		BackBtn.y = (display.contentHeight/2)+30
		gexui:insert( BackBtn )
		
		gexui:toFront()
		
	elseif isOpn==true and (gexui) then
		isOpn=false
		for i=gexui.numChildren,1,-1 do
			display.remove(gexui[i])
			gexui[i]=nil
		end
		gexui=nil
	end
end

function DoExit()
	for i=gexui.numChildren,1,-1 do
		display.remove(gexui[i])
		gexui[i]=nil
	end
	gexui=nil
	isOpn=false
	WD.SrsBsns()
end

function MusicScroll( event )
	if event.x>display.contentCenterX+290 then
		scrollind.x=display.contentCenterX+290
		a.MusicVol(1.0)
		musicind.text=("Music Volume: "..(1.0*100).."%")
	elseif event.x<display.contentCenterX-290 then
		scrollind.x=display.contentCenterX-290
		a.MusicVol(0.0)
		musicind.text=("Music Volume: "..(0.0*100).."%")
	else
		for s=1,10 do
			local x=display.contentCenterX-290+( (s-1)*58 )
			if event.x>x-29 and event.x<x+29 then
				scrollind.x=display.contentCenterX-290+( (s-1)*58 )
				a.MusicVol((s-1)/10)
				musicind.text=("Music Volume: "..((s-1)*10).."%")
			end
		end
	end
end

function SoundScroll( event )
	if event.x>display.contentCenterX+290 then
		scrollind2.x=display.contentCenterX+290
		a.SoundVol(1.0)
		soundind.text=("Sound Volume: "..(1.0*100).."%")
	elseif event.x<display.contentCenterX-290 then
		scrollind2.x=display.contentCenterX-290
		a.SoundVol(0.0)
		soundind.text=("Sound Volume: "..(0.0*100).."%")
	else
		for s=1,10 do
			local x=display.contentCenterX-290+( (s-1)*58 )
			if event.x>x-29 and event.x<x+29 then
				scrollind2.x=display.contentCenterX-290+( (s-1)*58 )
				a.SoundVol((s-1)/10)
				soundind.text=("Sound Volume: "..((s-1)*10).."%")
			end
		end
	end
end

function More( event )
	local statnum
	for i=1,6 do
		if (pli[i]) then
			if event.y+21>pli[i].y and event.y-21<pli[i].y then
				statnum=i
			end
		end
	end
	p.Natural(statnum,1)
	ToggleInfo()
	ToggleInfo()
end

function Less( event )
	local statnum
	for i=1,6 do
		if (mini[i]) then
			if event.y+21>mini[i].y and event.y-21<mini[i].y then
				statnum=i
			end
		end
	end
	p.Natural(statnum,-1)
	ToggleInfo()
	ToggleInfo()
end

function DeathMenu(cause)
	if isOpn==false then
		gdm=display.newGroup()
		isOpn=true
		
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
			Deathmsg2.text=("Swimming in lava.")
		end
		if cause=="Mob" then
			Deathmsg2.text=("Fighting a mob.")
		end
		if cause=="Poison" then
			Deathmsg2.text=("Poisoning self. Dumbass.")
		end
		
		ToMenuBtn = widget.newButton{
			label="Back To Menu",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton2.png",
			width=290, height=80,
			onRelease = onToMenuBtnRelease
		}
		ToMenuBtn.x = display.contentCenterX
		ToMenuBtn.y = display.contentHeight*0.61
		gdm:insert( ToMenuBtn )
		
		Round=WD.Circle()
		p1=p.GetPlayer()
		size=b.GetData(0)
		scre=sc.Scoring( Round , p1 , (math.sqrt(size)) )
		Round=tostring(Round)
		GCount=tostring(p1.gp)
		GInfoTxt=display.newGroup()
		
		InfoTxt1=display.newText("You got to floor ",0,0,"MoolBoran", 60 )
		InfoTxt1.x=225
		InfoTxt1.y=Deathmsg2.y+100
		GInfoTxt:insert( InfoTxt1 )
		
		InfoTxt2=display.newText(Round,InfoTxt1.x+140+(25*(#Round-1)),0,"MoolBoran", 60 )
		InfoTxt2:setTextColor(50, 255, 50)
		InfoTxt2.y=InfoTxt1.y
		GInfoTxt:insert( InfoTxt2 )
		
		InfoTxt3= display.newText(" with ",InfoTxt2.x+25+(25*(#Round-1)),0,"MoolBoran", 60 )
		InfoTxt3.y=InfoTxt1.y
		GInfoTxt:insert( InfoTxt3 )
		
		InfoTxt4=display.newText(GCount,InfoTxt3.x+50,0,"MoolBoran", 60 )
		InfoTxt4.y=InfoTxt1.y
		InfoTxt4:setTextColor(255, 255, 50)
		GInfoTxt:insert( InfoTxt4 )
		
		InfoTxt5=display.newText(" gold.",InfoTxt4.x+25+(15*(#GCount-1)),0,"MoolBoran", 60 )
		InfoTxt5.y=InfoTxt1.y
		GInfoTxt:insert( InfoTxt5 )
		
		InfoTxt6=display.newText(("Score: "..scre),0,0,"MoolBoran", 60 )
		InfoTxt6.x=display.contentCenterX
		InfoTxt6.y=display.contentCenterY+20
		GInfoTxt:insert( InfoTxt6 )
		
		gdm:insert( Dthtxt )
		gdm:insert( GInfoTxt )
		gdm:toFront()
		
		Runtime:removeEventListener("enterFrame", g.GoldDisplay)
		b.WipeMap()
		mov.ShowArrows("clean")
		a.Stopbkg()
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
			elseif itemstats[3]==1 then
				p.AddMP(itemstats[4])
				ToggleBag()
			else
				if itemstats[4]==0 then
					WD.FloorPort(false)
				elseif itemstats[4]==1 then
					WD.FloorPort(true)
				elseif itemstats[4]==2 then
					s.Save()
				end
			end
			ToggleBag()
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
		
		local backbtn= widget.newButton{
			label="Back",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton2.png",
			width=200, height=55,
			onRelease = UseMenu}
		backbtn:setReferencePoint( display.CenterReferencePoint )
		backbtn.x = (display.contentWidth/2)
		backbtn.y = (display.contentHeight/2)+30
		gum:insert( backbtn )
		
		local dropbtn= widget.newButton{
			label="Drop",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton2.png",
			width=200, height=55,
			onRelease = DroppedIt}
		dropbtn:setReferencePoint( display.CenterReferencePoint )
		dropbtn.x = ((display.contentWidth/4)*3)+50
		dropbtn.y = (display.contentHeight/2)+30
		gum:insert( dropbtn )
		
		itemstats={
			item.ReturnInfo(id,4)
		}
		
		if itemstats[1]==0 then
			local usebtn= widget.newButton{
				label="Use",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = UsedIt
			}
			usebtn:setReferencePoint( display.CenterReferencePoint )
			usebtn.x = (display.contentWidth/4)-50
			usebtn.y = (display.contentHeight/2)+30
			gum:insert( usebtn )
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"MoolBoran",90)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-120
			gum:insert( lolname )
			
			local descrip=display.newText( (itemstats[5]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
		end	
		if itemstats[1]==1 then
			local equipbtn= widget.newButton{
				label="Equip",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = EquippedIt
			}
			equipbtn:setReferencePoint( display.CenterReferencePoint )
			equipbtn.x = (display.contentWidth/4)-50
			equipbtn.y = (display.contentHeight/2)+30
			gum:insert( equipbtn )
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"MoolBoran",90)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-120
			gum:insert( lolname )
			
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
				stattxts[1]=display.newText( ("No change.") ,0,0,"MoolBoran",55)
				stattxts[1]:setTextColor( 180, 180, 180)
				stattxts[1].y=(display.contentHeight/2)-50
				stattxts[1].x=display.contentWidth/2
				gum:insert( stattxts[1] )
			end
		end
		if itemstats[1]==2 then
			if itemstats[4]==0 or itemstats[4]==1 then
				local usebtn= widget.newButton{
					label="Teleport",
					labelColor = { default={255,255,255}, over={0,0,0} },
					fontSize=30,
					defaultFile="cbutton.png",
					overFile="cbutton2.png",
					width=200, height=55,
					onRelease = UsedIt
				}
				usebtn:setReferencePoint( display.CenterReferencePoint )
				usebtn.x = (display.contentWidth/4)-50
				usebtn.y = (display.contentHeight/2)+30
				gum:insert( usebtn )
			elseif itemstats[4]==2 then
				local usebtn= widget.newButton{
					label="Save",
					labelColor = { default={255,255,255}, over={0,0,0} },
					fontSize=30,
					defaultFile="cbutton.png",
					overFile="cbutton2.png",
					width=200, height=55,
					onRelease = UsedIt
				}
				usebtn:setReferencePoint( display.CenterReferencePoint )
				usebtn.x = (display.contentWidth/4)-50
				usebtn.y = (display.contentHeight/2)+30
				gum:insert( usebtn )
			end
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"MoolBoran",90)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-120
			gum:insert( lolname )
			
			local descrip=display.newText( (itemstats[3]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
		end
		if itemstats[1]==3 then	
		
			local learnbtn= widget.newButton{
				label="Learn",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = LearnedIt
			}
			learnbtn:setReferencePoint( display.CenterReferencePoint )
			learnbtn.x = (display.contentWidth/4)-50
			learnbtn.y = (display.contentHeight/2)+30
			gum:insert( learnbtn )
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"MoolBoran",90)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-120
			gum:insert( lolname )
			
			local descrip=display.newText( (itemstats[4]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
			
		end
		if itemstats[1]==4 then	
		
			local boostbtn= widget.newButton{
				label="Use",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = StatBoost
			}
			boostbtn:setReferencePoint( display.CenterReferencePoint )
			boostbtn.x = (display.contentWidth/4)-50
			boostbtn.y = (display.contentHeight/2)+30
			gum:insert( boostbtn )
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"MoolBoran",90)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-120
			gum:insert( lolname )
			
			local descrip=display.newText( (itemstats[4]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
			
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
