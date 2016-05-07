-----------------------------------------------------------------------------------------
--
-- UI.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local players=require("Lplayers")
local inv=require("Lwindow")
local audio=require("LAudio")
local gold=require("LGold")
local col=require("LTileEvents")
local WD=require("LProgress")
local builder=require("LMapBuilder")
local c=require("Lcombat")
local mob=require("Lmobai")
local widget = require "widget"
local shp=require("LShop")
local m=require("Lmovement")
local isPaused
local Map
local P1
local gexui
local bkglevel
local Coins
local topthing
local portsprsnt
local portsnprsnt
local rportprsnt
local hpdprsnt
local hpdnprsnt
local mpdprsnt
local mpdnprsnt
local pwg

function Background()
	bkglevel = display.newImage("bkgs/bkg_level.png", true)
	bkglevel.x = display.contentCenterX
	bkglevel.y = display.contentCenterY	
	bkglevel:toBack()
	return bkglevel
end

function Paused()
	return isPaused
end

function UI()
	P1=players.GetPlayer()
	pwg=display.newGroup()
	isPaused=false
	
	window=display.newRect(0,0,335,140)
	window:setFillColor(100,100,100,150)
	window.x,window.y=(display.contentWidth+170), display.contentHeight-90
	window.loc=0
	pwg:insert(window)
	
	pausetxt=display.newText("Game Paused.",0,0,native.systemFont,36)
	pausetxt.x=window.x
	pausetxt.y=window.y-100
	pwg:insert(pausetxt)
	
	pausewin=display.newRect(0,0,(#pausetxt.text)*24,48)
	pausewin:setFillColor(0,0,0,150)
	pausewin.x=pausetxt.x
	pausewin.y=pausetxt.y
	pwg:insert(pausewin)
	
	pausetxt:toFront()
	
	PauseBtn = widget.newButton{
		defaultFile="pauseon.png",
		overFile="pauseoff.png",
		width=65, height=65,
		onRelease = Pause
	}
	PauseBtn:setReferencePoint( display.CenterReferencePoint )
	PauseBtn.x = window.x-220
	PauseBtn.y = window.y
	pwg:insert(PauseBtn)
	
	bag = display.newImageRect("bag.png", 50, 50)
	bag.x, bag.y = window.x-128, window.y-32
	bag.xScale = 1.28
	bag.yScale = bag.xScale
	bag:addEventListener("touch",OpenBag)
	pwg:insert(bag)
	
	info = display.newImageRect("infobtn.png", 50, 50)
	info.x, info.y = bag.x+(50*bag.xScale), bag.y
	info.yScale = bag.yScale
	info.xScale = bag.xScale
	info:addEventListener("touch",OpenInfo)
	pwg:insert(info)
	
	uiexit = display.newImageRect("exit.png", 50, 50)
	uiexit.x, uiexit.y = info.x+(150*info.xScale), bag.y
	uiexit.yScale = bag.yScale
	uiexit.xScale = bag.xScale
	uiexit:addEventListener("tap",Exit)
	pwg:insert(uiexit)
	
	Sound=audio.sfx()
	Music=audio.muse()
	
	SMute = display.newImageRect("soundoff.png",50,50)
	SMute.x,SMute.y = info.x+(50*info.xScale), bag.y
	SMute.xScale=bag.xScale
	SMute.yScale=bag.yScale
	SMute.isVisible=false
	pwg:insert(SMute)
	
	SUnmute = display.newImageRect("soundon.png",50,50)
	SUnmute.x,SUnmute.y = SMute.x,SMute.y
	SUnmute.xScale=SMute.xScale
	SUnmute.yScale=SMute.yScale
	SUnmute.isVisible=true
	SUnmute:addEventListener("tap",SoundsOff)
	pwg:insert(SUnmute)
	
	MMute = display.newImageRect("musicoff.png",50,50)
	MMute.x,MMute.y = SMute.x+(50*SMute.xScale), bag.y
	MMute.xScale=SMute.xScale
	MMute.yScale=SMute.yScale
	MMute.isVisible=false
	pwg:insert(MMute)
	
	MUnmute = display.newImageRect("musicon.png",50,50)
	MUnmute.x,MUnmute.y = MMute.x,MMute.y
	MUnmute.xScale=SMute.xScale
	MUnmute.yScale=SMute.yScale
	MUnmute.isVisible=true
	MUnmute:addEventListener("tap",MusicOff)
	pwg:insert(MUnmute)
	
	if Sound==false then
		SMute.isVisible=true
		SUnmute.isVisible=false
		SMute:addEventListener("tap",SoundsOn)
	end
	if Music==false then
		MMute.isVisible=true
		MUnmute.isVisible=false
		MMute:addEventListener("tap",MusicOn)
	end
	MapIndicators("create")
end

function Pause(mute)
	local busy=inv.OpenWindow()
	local shap=shp.AtTheMall()
	local fight=c.InTrouble()
	if busy==false and shap==false and fight==false then
		portsprsnt.txt.text=(P1.portcd)
		MovePause(true)
		if isPaused==true then
			isPaused=false
			print "Game resumed."
			if mute~=true then
				audio.Play(5)
			end
		elseif isPaused==false then
			isPaused=true
			m.ShowArrows("clean")
			print "Game paused."
			if mute~=true then
				audio.Play(6)
			end
		end
	end
end

function MovePause(val)
	if pwg.x==0 and val~=true then
		window.loc=0
		m.ShowArrows()
	elseif pwg.x==-350 and val~=true then
		window.loc=1
	else
		if window.loc==0 then
			pwg.x=pwg.x-35
			timer.performWithDelay(50,MovePause)
		elseif window.loc==1 then
			pwg.x=pwg.x+35
			timer.performWithDelay(50,MovePause)
		end
	end
end

function Exit()
	local busy=inv.OpenWindow()
	local shap=shp.AtTheMall()
	local fight=c.InTrouble()
	if busy==false and shap==false and fight==false then
		if not(gexui) then
			gexui=display.newGroup()
			
			window=display.newImageRect("usemenu.png", 768, 308)
			window.x,window.y = display.contentWidth/2, 450
			gexui:insert( window )
			
			lolname=display.newText( ("You pressed the exit button.") ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gexui:insert( lolname )
			
			lolname2=display.newText( ("Are you sure you want to exit?") ,0,0,"Game Over",80)
			lolname2.x=display.contentWidth/2
			lolname2.y=lolname.y+50
			gexui:insert(lolname2)
			

			lolname3=display.newText( ("\(Unsaved progress will be lost.\)") ,0,0,"Game Over",65)
			lolname3:setTextColor(180,180,180)
			lolname3.x=display.contentWidth/2
			lolname3.y=lolname2.y+50
			gexui:insert(lolname3)
			
			local backbtn= widget.newButton{
				label="Yes",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = DoExit}
			backbtn:setReferencePoint( display.CenterReferencePoint )
			backbtn.x = (display.contentWidth/2)-130
			backbtn.y = (display.contentHeight/2)+30
			gexui:insert( backbtn )
			
			local dropbtn= widget.newButton{
				label="No",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = Exit}
			dropbtn:setReferencePoint( display.CenterReferencePoint )
			dropbtn.x = (display.contentWidth/2)+130
			dropbtn.y = (display.contentHeight/2)+30
			gexui:insert( dropbtn )
			
			gexui:toFront()
			
		elseif (gexui) then
			for i=gexui.numChildren,1,-1 do
				display.remove(gexui[i])
				gexui[i]=nil
			end
			gexui=nil
		end
	end
end

function DoExit()
	for i=gexui.numChildren,1,-1 do
		display.remove(gexui[i])
		gexui[i]=nil
	end
	gexui=nil
	WD.SrsBsns()
end

function OpenBag( event )
	if event.phase=="ended" then
		inv.ToggleBag()
	end
end

function OpenInfo( event )
	if event.phase=="ended" then
		inv.ToggleInfo()
	end
end

function MapIndicators(val)
	if val=="create" then
		portsprsnt = display.newImageRect("portalspresent.png",80,80)
		portsprsnt.x, portsprsnt.y = bag.x, bag.y+(50*1.28)
		portsprsnt.xScale,portsprsnt.yScale=0.8,0.8
		portsprsnt.isVisible=false
		pwg:insert(portsprsnt)
		
		portsnprsnt = display.newImageRect("portalsnpresent.png",80,80)
		portsnprsnt.x, portsnprsnt.y = portsprsnt.x, portsprsnt.y
		portsnprsnt.xScale,portsnprsnt.yScale=0.8,0.8
		pwg:insert(portsnprsnt)
		
		portsprsnt.txt=display.newText((P1.portcd),0,0,"Game Over",120)
		portsprsnt.txt.x,portsprsnt.txt.y=portsprsnt.x,portsprsnt.y-5
		portsprsnt.txt.isVisible=false
		pwg:insert(portsprsnt.txt)
		
		rportprsnt = display.newImageRect("rppresent.png",80,80)
		rportprsnt.x, rportprsnt.y = portsprsnt.x, portsprsnt.y
		rportprsnt.xScale,rportprsnt.yScale=0.8,0.8
		rportprsnt.isVisible=false
		pwg:insert(rportprsnt)
		
		hpdprsnt = display.newImageRect("hppresent.png",80,80)
		hpdprsnt.x, hpdprsnt.y = portsprsnt.x+(80*0.8), portsprsnt.y
		hpdprsnt.xScale,hpdprsnt.yScale=0.8,0.8
		hpdprsnt.isVisible=false
		pwg:insert(hpdprsnt)
		
		hpdnprsnt = display.newImageRect("hpnpresent.png",80,80)
		hpdnprsnt.x, hpdnprsnt.y = hpdprsnt.x, portsprsnt.y
		hpdnprsnt.xScale,hpdnprsnt.yScale=0.8,0.8
		pwg:insert(hpdnprsnt)
		
		mpdprsnt = display.newImageRect("mppresent.png",80,80)
		mpdprsnt.x, mpdprsnt.y = hpdprsnt.x+(80*0.8), portsprsnt.y
		mpdprsnt.xScale,mpdprsnt.yScale=0.8,0.8
		mpdprsnt.isVisible=false
		pwg:insert(mpdprsnt)
		
		mpdnprsnt = display.newImageRect("mpnpresent.png",80,80)
		mpdnprsnt.x, mpdnprsnt.y = mpdprsnt.x, portsprsnt.y
		mpdnprsnt.xScale,mpdnprsnt.yScale=0.8,0.8
		pwg:insert(mpdnprsnt)
		
		msprsnt = display.newImageRect("mspresent.png",80,80)
		msprsnt.x, msprsnt.y = mpdprsnt.x+(80*0.8), portsprsnt.y
		msprsnt.xScale,msprsnt.yScale=0.8,0.8
		msprsnt.isVisible=false
		pwg:insert(msprsnt)
		
		msnprsnt = display.newImageRect("msnpresent.png",80,80)
		msnprsnt.x, msnprsnt.y = msprsnt.x, portsprsnt.y
		msnprsnt.xScale,msnprsnt.yScale=0.8,0.8
		pwg:insert(msnprsnt)
	
		keynprsnt = display.newImageRect("keyno.png",80,80)
		keynprsnt.x,keynprsnt.y = msprsnt.x+(80*0.8), portsprsnt.y
		keynprsnt.xScale = 0.8
		keynprsnt.yScale = keynprsnt.xScale
		pwg:insert(keynprsnt)
		
		keyprsnt = display.newImageRect("keyget.png",80,80)
		keyprsnt.x,keyprsnt.y = keynprsnt.x, portsprsnt.y
		keyprsnt.xScale = keynprsnt.xScale
		keyprsnt.yScale =	keynprsnt.xScale
		keyprsnt.isVisible=false
		pwg:insert(keyprsnt)
	end
	if val=="KEY" then
		keyprsnt.isVisible=true
		keynprsnt.isVisible=false
	end
	if val=="RP" then
		portsprsnt.isVisible=false
		portsprsnt.txt.isVisible=false
		portsnprsnt.isVisible=false
		rportprsnt.isVisible=true
	end
	if val=="MP" then
		mpdprsnt.isVisible=true
		mpdnprsnt.isVisible=false
	end
	if val=="HP" then
		hpdprsnt.isVisible=true
		hpdnprsnt.isVisible=false
	end
	if val=="BP" then
		portsprsnt.isVisible=true
		portsprsnt.txt.isVisible=true
		portsnprsnt.isVisible=false
		rportprsnt.isVisible=false
	end
	if val=="MS" then
		msprsnt.isVisible=true
		msnprsnt.isVisible=false
	end
end

function GetProfBkg()
	return profbkg
end

function CleanSlate()
	if (pwg) then
		for i=pwg.numChildren,1,-1 do
			display.remove(pwg[i])
			pwg[i]=nil		
		end	
		pwg=nil
	end
	if (bkglevel) then
		display.remove(bkglevel)
		bkglevel=nil
	end
end

function SoundsOff()
	audio.SimpleSMute()
	SMute.isVisible=true
	SUnmute.isVisible=false
	SUnmute:removeEventListener("tap",SoundsOff)
	SMute:addEventListener("tap",SoundsOn)
end

function SoundsOn()
	audio.SimpleSUnmute()
	SMute.isVisible=false
	SUnmute.isVisible=true
	SUnmute:addEventListener("tap",SoundsOff)
	SMute:removeEventListener("tap",SoundsOn)
end

function MusicOff()
	audio.SimpleMMute()
	MMute.isVisible=true
	MUnmute.isVisible=false
	MUnmute:removeEventListener("tap",MusicOff)
	MMute:addEventListener("tap",MusicOn)
end

function MusicOn()
	audio.SimpleMUnmute()
	MMute.isVisible=false
	MUnmute.isVisible=true
	MUnmute:addEventListener("tap",MusicOff)
	MMute:removeEventListener("tap",MusicOn)
end
