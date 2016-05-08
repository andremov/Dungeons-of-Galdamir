-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local egg=math.random(1,1000000)
local widget = require "widget"
local group=display.newGroup()
local set=require("Lsettings")
local inv=require("Lwindow")
local s=require("Lsplashes")
local m=require("Lhandler")
local v=require("Lversion")
local o=require("Loptions")
local sc=require("Lscore")
local c=require("Lchars")
local a=require("Laudio")
local p=require("Lplay")
local ui=require("Lui")
local OffScreen
local VDisplay2
local VDisplay
local GVersion
local PlayBtn
local OptnBtn
local RSplash
local text={}
local Sounds
local Splash
local sign

function ShowMenu()
	function FrontNCenter2()
		OffScreen:toFront()
	end
	
	set.Load()
	
	CurMenu=0
	GVersion=v.HowDoIVersion(true)
	
	if egg==1 then
		titleLogo = display.newImageRect( "title2.png", 477, 254 )
	else
		titleLogo = display.newImageRect( "titleW.png", 477, 254 )
	end
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 150
	titleLogo:addEventListener("tap",SplashChange)
	group:insert(titleLogo)
	
	PlayBtn =  widget.newButton{
		label="Play",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onPlayBtnRelease
	}
	PlayBtn:setReferencePoint( display.CenterReferencePoint )
	PlayBtn.x = display.contentWidth*0.5
	PlayBtn.y = display.contentCenterY-20
	group:insert(PlayBtn)
	
	OptnBtn =  widget.newButton{
		label="Options",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onOptnBtnRelease
	}
	OptnBtn:setReferencePoint( display.CenterReferencePoint )
	OptnBtn.x = display.contentWidth*0.5
	OptnBtn.y = PlayBtn.y+100
	group:insert(OptnBtn)
	
	logo=display.newImageRect("Symbol3W.png",206,206)
	logo.xScale=0.75
	logo.yScale=logo.xScale
	logo.x=display.contentCenterX
	logo.y=display.contentHeight-130
	logo:addEventListener("touch",Credits)
	group:insert(logo)
	
	if ( "simulator" == system.getInfo("environment") ) then
		print "Hello, developer!"
		
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
	end
	--[[
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
	--]]
	
	Sounds=a.sfx()
	
	if (Sounds) then
	else
		a.LoadSounds()
	end
	
	Splash=s.GetSplash()
	group:insert(Splash)
	
	a.changeMusic(1)
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
	a.Play(12)
	for i=group.numChildren,1,-1 do
		local child = group[i]
		child.parent:remove( child )
	end
	VDisplay=nil
	p.Display()
end

function onUpdateBtnRelease( event )
	if event.phase=="ended" then
		a.Play(12)
		system.openURL( "tinyurl.com/dogcub3d" )
	end
end

function openAd1( event )
	if event.phase=="ended" then
		a.Play(12)
		system.openURL( "tinyurl.com/togcub3d" )
	end
end

function openAd2( event )
	if event.phase=="ended" then
		a.Play(12)
		system.openURL( "tinyurl.com/mogcub3d" )
	end
end

function onOptnBtnRelease()
	a.Play(12)
	for i=group.numChildren,1,-1 do
		local child = group[i]
		child.parent:remove( child )
	end
	VDisplay=nil
	o.DisplayOptions()
end

function isVersion(val)
	if (VDisplay2) then
		display.remove(VDisplay2)
	end
	if val==true then
		if (VDisplay) then
			VDisplay2 = display.newText(("Up to date."),0,0,"MoolBoran", 60 )
			VDisplay2:setTextColor( 0, 150, 0)
			VDisplay2.x=VDisplay.x
			VDisplay2.y=VDisplay.y+55
			group:insert(VDisplay2)
		end
	elseif val==false then
		if (VDisplay) then
			VDisplay2 = display.newText(("Update available!"),0,0,"MoolBoran", 45 )
			VDisplay2:setTextColor( 150, 0, 0)
			VDisplay2.x=VDisplay.x
			VDisplay2.y=VDisplay.y+45
			group:insert(VDisplay2)
			sign:addEventListener("touch",onUpdateBtnRelease)
		end
	elseif val==nil then
		if (VDisplay) then
			VDisplay2 = display.newText(("Update check failed."),0,0,"MoolBoran", 45 )
			VDisplay2:setTextColor( 150, 0, 0)
			VDisplay2.x=VDisplay.x
			VDisplay2.y=VDisplay.y+50
			group:insert(VDisplay2)
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
			
		elseif CurMenu==9 then
			native.requestExit()
		end
		return true
	end

	if ( "menu" == keyName and phase == "up" ) then
		if CurMenu==6 then
			ui.Pause()
		elseif CurMenu==7 then
			ui.Pause()
		end
		return true
	end

	return false
end

function Credits( event )
	if event.phase=="ended" then
		a.Play(12)
		for i=group.numChildren,1,-1 do
			local child = group[i]
			child.parent:remove( child )
		end
		VDisplay=nil
		
		title=display.newText("Credits",0,0,"MoolBoran",100)
		title.x = display.contentWidth*0.5
		title.y = 100
		title:setTextColor(125,250,125)
		group:insert(title)
		
		function One()
			CreditsTab(1)
		end
		
		coding=display.newText("Coding",0,0,"MoolBoran",65)
		coding.x=display.contentWidth/5
		coding.y=display.contentHeight-100
		coding:addEventListener("tap",One)
		coding:setTextColor(125,125,250)
		group:insert(coding)
		
		function Two()
			CreditsTab(2)
		end
		
		sound=display.newText("Sound",0,0,"MoolBoran",65)
		sound.x=display.contentWidth/5*2
		sound.y=display.contentHeight-100
		sound:addEventListener("tap",Two)
		sound:setTextColor(125,125,250)
		group:insert(sound)
		
		function Three()
			CreditsTab(3)
		end
		
		graphic=display.newText("Graphic",0,0,"MoolBoran",65)
		graphic.x=display.contentWidth/5*3
		graphic.y=display.contentHeight-100
		graphic:addEventListener("tap",Three)
		graphic:setTextColor(125,125,250)
		group:insert(graphic)
		
		function Four()
			Credone()
		end
		
		back=display.newText("Back",0,0,"MoolBoran",65)
		back.x=display.contentWidth/5*4
		back.y=display.contentHeight-100
		back:addEventListener("tap",Four)
		back:setTextColor(125,125,250)
		group:insert(back)
	end
end

function CreditsTab(tab)
	for t=table.maxn(text),1,-1 do
		display.remove(text[t])
		text[t]=nil
	end
		coding:setTextColor(125,125,250)
		sound:setTextColor(125,125,250)
		graphic:setTextColor(125,125,250)
		if tab==1 then
			coding:setTextColor(250,125,125)
		elseif tab==2 then
			sound:setTextColor(250,125,125)
		elseif tab==3 then
			graphic:setTextColor(250,125,125)
		end
		--[[
			TO DO:
				SOUNDS
				- GOLD FREESOUND
				- ROCK FREESOUND
				- GATE FREESOUND
				MAP TEXTURES
				CHARACTER
				ENEMIES
		--]]
	local executives={
		"Andres Movilla","- Developer",
		"Mauricio Movilla","- Publisher",
	}
	local sfx={
		"HorrorPen from OpenGameArt.org","- Composer of \"No More Magic\"",
		"Kevin Macleod from Incompetech.com","- Composer of \"Oppresive Gloom\"",
		"Mekathros from OpenGameArt.org","- Composer of \"Gran Batalla\"",
		"bart from OpenGameArt.org","- Composer of the level up fanfare",
		"qubodup from OpenGameArt.org","- Composer of the buttons and clicks",
		"artisticdude from OpenGameArt.org","- Composer of the combat hits",
		"Fantozzi from OpenGameArt.org","- Composer of the different steps",
	}
	local gfx={
		"Ashiroxzer from OpenGameArt.org","- Artist of the user interface",
		"VWolfDog from OpenGameArt.org","- Artist of some items",
		"Clint Bellanger from OpenGameArt.org","- Artist of several items",
		"Mumu from OpenGameArt.org","- Artist of some items",
		"Blarumyrran from OpenGameArt.org","- Artist of some items",
		"Lorc from OpenGameArt.org","- Artist of most UI icons",
		"Chilvence from DHTP","- Artist of most Default Tileset textures",
	
	
	
	
	}
	local tables={executives,sfx,gfx}
	
	for s=1,table.maxn(tables[tab]) do
		text[s]=display.newText(
			tables[tab][s],
			130+(-100*(s%2)),
			125+(-30*((s%2)+1))+(100*math.ceil(s/2)),
			"MoolBoran",45
		)
		group:insert(text[s])
	--	print (s.."x-"..text[s].x)
	--	print (s.."y-"..text[s].y)
	end
end

function Credone()
	Runtime:addEventListener("tap",NextStep)
end

function NextStep()
	Runtime:removeEventListener("tap",NextStep)
	for i=group.numChildren,1,-1 do
		local child = group[i]
		child.parent:remove( child )
	end
	ShowMenu()
end