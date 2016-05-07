-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local s=require("Lsplashes")
local a=require("Laudio")
local v=require("Lversion")
local p=require("Lplay")
local o=require("Loptions")
local sc=require("Lscore")
local c=require("Lchars")
local m=require("Lmaphandler")
local group=display.newGroup()
local GVersion
local PlayBtn
local OptnBtn
local VDisplay
local VDisplay2
local RSplash
local sign
local Sounds
local Splash
local OffScreen
local canGo

function ShowMenu()
	function FrontNCenter2()
		OffScreen:toFront()
	end
	if not (OffScreen) then
		OffScreen = display.newImage("bkgs/bkg_leveldark2.png", 1536,2048)
		OffScreen.x = display.contentWidth/2
		OffScreen.y = display.contentHeight/2
		Runtime:addEventListener("enterFrame",FrontNCenter2)
	end
	
	CurMenu=0
	GVersion=v.HowDoIVersion(true)
	canGo=false
	--[[
	local background = display.newImageRect( "bkgs/background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	group:insert(background)
	]]
	local titleLogo = display.newImageRect( "titleW.png", 477, 254 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 150
	titleLogo:addEventListener("tap",SplashChange)
	group:insert(titleLogo)
	
	PlayBtn = widget.newButton{
		label="Play",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onPlayBtnRelease
	}
	PlayBtn:setReferencePoint( display.CenterReferencePoint )
	PlayBtn.x = display.contentWidth*0.5
	PlayBtn.y = display.contentCenterY-20
	group:insert(PlayBtn)
	
	OptnBtn = widget.newButton{
		label="Options",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onOptnBtnRelease
	}
	OptnBtn:setReferencePoint( display.CenterReferencePoint )
	OptnBtn.x = display.contentWidth*0.5
	OptnBtn.y = PlayBtn.y+100
	group:insert(OptnBtn)
	
	sign=display.newImageRect("sign.png", 95, 70)
	sign.xScale=2.3
	sign.yScale=2.3
	sign.x=(display.contentWidth-130)
	sign.y=(display.contentHeight-90)
	group:insert(sign)
	
	VerDisplay = display.newText(("Version:"),0,0,"MoolBoran", 70 )
	VerDisplay:setTextColor( 0, 0, 0)
	VerDisplay.x=sign.x
	VerDisplay.y=sign.y-30
	group:insert(VerDisplay)
	
	VDisplay = display.newText((GVersion),0,0,"MoolBoran", 45 )
	VDisplay:setTextColor( 0, 0, 0)
	VDisplay.x=VerDisplay.x
	VDisplay.y=VerDisplay.y+40
	group:insert(VDisplay)
	
	logo=display.newImageRect("Symbol3W.png",206,206)
	logo.xScale=0.75
	logo.yScale=logo.xScale
	logo.x=100
	logo.y=display.contentHeight-130
	group:insert(logo)
	
	ad1=display.newImageRect("ad1.png",57,57)
	ad1.x=logo.x+160
	ad1.y=logo.y+30
	ad1.xScale=2.0
	ad1.yScale=ad1.xScale
	ad1:addEventListener("touch",openAd1)
	group:insert(ad1)
	
	ad2=display.newImageRect("ad2.png",57,57)
	ad2.x=ad1.x+(70*ad1.xScale)
	ad2.y=ad1.y
	ad2.xScale=ad1.xScale
	ad2.yScale=ad1.xScale
	ad2:addEventListener("touch",openAd2)
	group:insert(ad2)
	
	Splash=s.GetSplash()
	group:insert(Splash)
	
	Sounds=a.sfx()
	
	if Sounds==true or Sounds==false then
	else
		a.LoadSounds()
	end
<<<<<<< HEAD
	
	a.Menu(true)
=======
	a.changeMusic(1)
>>>>>>> G1.2.0
	Runtime:addEventListener( "key", onKeyEvent )
end

function SplashChange()
	a.Play(12)
	if (Splash) then
		display.remove(Splash)
		Splash=nil
	end
	Splash=s.GetSplash()
	group:insert(Splash)
end

function onPlayBtnRelease()
	if canGo==true then
		a.Play(12)
		for i=group.numChildren,1,-1 do
			local child = group[i]
			child.parent:remove( child )
		end
		VDisplay=nil
		p.Display()
	end
end

function ReadySetGo()
	canGo=true
end

function onUpdateBtnRelease( event )
	if canGo==true and event.phase=="ended" then
		a.Play(12)
		system.openURL( "tinyurl.com/dogcub3d" )
	end
end

function openAd1( event )
	if canGo==true and event.phase=="ended" then
		a.Play(12)
		system.openURL( "tinyurl.com/togcub3d" )
	end
end

function openAd2( event )
	if canGo==true and event.phase=="ended" then
		a.Play(12)
		system.openURL( "tinyurl.com/mogcub3d" )
	end
end

function onOptnBtnRelease()
	if canGo==true then
		a.Play(12)
		for i=group.numChildren,1,-1 do
			local child = group[i]
			child.parent:remove( child )
		end
		VDisplay=nil
		o.DisplayOptions()
	end
end

function isVersion(val)
	if (VDisplay2) then
		display.remove(VDisplay2)
	end
	if val==true then
		if (VDisplay) then
			if canGo==true then
				VDisplay2 = display.newText(("Up to date."),0,0,"MoolBoran", 60 )
				VDisplay2:setTextColor( 0, 150, 0)
				VDisplay2.x=VDisplay.x
				VDisplay2.y=VDisplay.y+55
				group:insert(VDisplay2)
			else
				function Closure1()
					isVersion(true)
				end
				timer.performWithDelay(10,Closure1)
			end
		end
	elseif val==false then
		if (VDisplay) then
			if canGo==true then
			VDisplay2 = display.newText(("Update available!"),0,0,"MoolBoran", 45 )
			VDisplay2:setTextColor( 150, 0, 0)
			VDisplay2.x=VDisplay.x
			VDisplay2.y=VDisplay.y+45
			group:insert(VDisplay2)
			sign:addEventListener("touch",onUpdateBtnRelease)
			else
				function Closure2()
					isVersion(false)
				end
				timer.performWithDelay(10,Closure2)
			end
		end
	elseif val==nil then
		if (VDisplay) then
			if canGo==true then
				VDisplay2 = display.newText(("Update check failed."),0,0,"MoolBoran", 45 )
				VDisplay2:setTextColor( 150, 0, 0)
				VDisplay2.x=VDisplay.x
				VDisplay2.y=VDisplay.y+50
				group:insert(VDisplay2)
			else
				function Closure2()
					isVersion(nil)
				end
				timer.performWithDelay(10,Closure2)
			end
		end
	end
end

function FindMe(value)
	CurMenu=value
end

function onKeyEvent( event )
	local phase = event.phase
	local keyName = event.keyName

	if ( "back" == keyName and phase == "up" ) then
		if CurMenu==0 then
		elseif CurMenu==1 then
			p.onBackRelease()
		elseif CurMenu==2 then
			o.onBackRelease()
		elseif CurMenu==3 then
			m.onBackRelease()
		elseif CurMenu==4 then
			c.onBackRelease()
		elseif CurMenu==5 then
			sc.onBackBtn()
		elseif CurMenu==6 then
			ui.ForcePause()
			inv.ToggleExit()
		elseif CurMenu==7 then
			inv.ToggleExit()
		elseif CurMenu==8 then
<<<<<<< HEAD
		
=======
			
>>>>>>> G1.2.0
		elseif CurMenu==9 then
			native.requestExit()
		end
		return true
	end

	return false
end