-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local su=require("Lstartup")
local a=require("Laudio")
local option=require("Loptions")
local s=require("Lsplashes")
local v=require("Lversion")
local t=require("Ltutorial")
local sav=require("Lsaving")
local scr=require("Lscore")
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
local saved

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
	
	GVersion=v.HowDoIVersion(true)
	canGo=false
	
	local background = display.newImageRect( "bkgs/background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	local titleLogo = display.newImageRect( "titleB.png", 477, 254 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	titleLogo.xScale=0.75
	titleLogo.yScale=titleLogo.xScale
	
	saved=sav.CheckSave()
	scr.CheckScore()
	
	if saved==true then
		ContBtn = widget.newButton{
			label="Continue",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=30,
			defaultFile="button1.png",
			overFile="button1-over.png",
			width=308, height=80,
			onRelease = onContBtnRelease
		}
		ContBtn:setReferencePoint( display.CenterReferencePoint )
		ContBtn.x = display.contentWidth*0.5
		ContBtn.y = 312
	elseif saved==false then
		ContBtn = widget.newButton{
			label="Continue",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=30,
			defaultFile="inactive.png",
			overFile="inactive-over.png",
			width=308, height=80,
		}
		ContBtn:setReferencePoint( display.CenterReferencePoint )
		ContBtn.x = display.contentWidth*0.5
		ContBtn.y = 312
	end
	
	PlayBtn = widget.newButton{
		label="New Game",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = onPlayBtnRelease
	}
	PlayBtn:setReferencePoint( display.CenterReferencePoint )
	PlayBtn.x = display.contentWidth*0.5
	PlayBtn.y = ContBtn.y+100
	
	TutBtn = widget.newButton{
		label="TBA",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="inactive.png",
		overFile="inactive-over.png",
		width=308, height=80,
		--onRelease = onTutBtnRelease
	}
	TutBtn:setReferencePoint( display.CenterReferencePoint )
	TutBtn.x = display.contentWidth*0.5
	TutBtn.y = PlayBtn.y+100
	
	OptnBtn = widget.newButton{
		label="Options",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = onOptnBtnRelease
	}
	OptnBtn:setReferencePoint( display.CenterReferencePoint )
	OptnBtn.x = display.contentWidth*0.5
	OptnBtn.y = TutBtn.y+100
	
	ScreBtn = widget.newButton{
		label="High Scores",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = onScreBtnRelease
	}
	ScreBtn:setReferencePoint( display.CenterReferencePoint )
	ScreBtn.x = display.contentWidth*0.5
	ScreBtn.y = OptnBtn.y+100
	
	sign=display.newImageRect("sign.png", 95, 70)
	sign.xScale=2.3
	sign.yScale=2.3
	sign.x=(display.contentWidth-130)
	sign.y=(display.contentHeight-90)
	
	VerDisplay = display.newText(("Version:"),0,0,"MoolBoran", 70 )
	VerDisplay:setTextColor( 0, 0, 0)
	VerDisplay.x=sign.x
	VerDisplay.y=sign.y-30
	
	VDisplay = display.newText((GVersion),0,0,"MoolBoran", 50 )
	VDisplay:setTextColor( 0, 0, 0)
	VDisplay.x=VerDisplay.x
	VDisplay.y=VerDisplay.y+40
	
	logo=display.newImageRect("Symbol3.png",206,206)
	logo.xScale=0.75
	logo.yScale=logo.xScale
	logo.x=100
	logo.y=display.contentHeight-130
	
	ad1=display.newImageRect("ad1.png",57,57)
	ad1.x=logo.x+160
	ad1.y=logo.y+30
	ad1.xScale=2.0
	ad1.yScale=ad1.xScale
	ad1:addEventListener("tap",openAd1)
	
	ad2=display.newImageRect("ad2.png",57,57)
	ad2.x=ad1.x+(70*ad1.xScale)
	ad2.y=ad1.y
	ad2.xScale=ad1.xScale
	ad2.yScale=ad1.xScale
	ad2:addEventListener("tap",openAd2)
	
	Splash=s.GetSplash()
	
	Sounds=a.sfx()
	
	if Sounds==true or Sounds==false then
	else
		a.LoadSounds()
	end
	
	a.Menu(true)
	
	group:insert(background)
	group:insert(ad2)
	group:insert(ad1)
	group:insert(ContBtn)
	group:insert(Splash)
	group:insert(PlayBtn)
	group:insert(TutBtn)
	group:insert(OptnBtn)
	group:insert(ScreBtn)
	group:insert(titleLogo)
	group:insert(sign)
	group:insert(VerDisplay)
	group:insert(VDisplay)
	group:insert(logo)
end

function ReadySetGo()
	canGo=true
end

function onPlayBtnRelease()
	
	a.Menu(false)
	if canGo==true then
		if saved==true then
			display.remove(PlayBtn)
			
			local asd2=display.newText("Are you sure?",0,0,"Game Over",110)
			asd2.x=ContBtn.x
			asd2.y=ContBtn.y
			group:insert(asd2)
			
			CanBtn = widget.newButton{
				label="New Game",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=30,
				defaultFile="button1.png",
				overFile="button1-over.png",
				width=308, height=80,
				onRelease = GoPlay
			}
			CanBtn:setReferencePoint( display.CenterReferencePoint )
			CanBtn.x = display.contentWidth*0.5-160
			CanBtn.y = ContBtn.y+100
			group:insert(CanBtn)
	
			CantBtn = widget.newButton{
				label="Cancel",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=30,
				defaultFile="button1.png",
				overFile="button1-over.png",
				width=308, height=80,
				onRelease = Stahp
			}
			CantBtn:setReferencePoint( display.CenterReferencePoint )
			CantBtn.x = display.contentWidth*0.5+160
			CantBtn.y = ContBtn.y+100
			group:insert(CantBtn)
			
			display.remove(ContBtn)
			
		elseif saved==false then
			GoPlay()
		end
	end
end

function GoPlay()
	for i=group.numChildren,1,-1 do
		local child = group[i]
		child.parent:remove( child )
	end
	timer.performWithDelay(100,Keyboard)
	VDisplay=nil
	sav.WipeSave()
end

function Stahp()
	
	display.remove(CanBtn)
	display.remove(CantBtn)
	display.remove(asd2)
	
	ContBtn = widget.newButton{
		label="Continue",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = onContBtnRelease
		
	}
	ContBtn:setReferencePoint( display.CenterReferencePoint )
	ContBtn.x = display.contentWidth*0.5
	ContBtn.y = 312
	group:insert(ContBtn)
	
	PlayBtn = widget.newButton{
		label="New Game",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = onPlayBtnRelease
	}
	PlayBtn:setReferencePoint( display.CenterReferencePoint )
	PlayBtn.x = display.contentWidth*0.5
	PlayBtn.y = ContBtn.y+100
	group:insert(PlayBtn)
end

function onUpdateBtnRelease()
	if canGo==true then
		system.openURL( "tinyurl.com/dogcub3d" )
	end
end

function openAd1()
	if canGo==true then
		system.openURL( "tinyurl.com/togcub3d" )
	end
end

function openAd2()
	if canGo==true then
		system.openURL( "tinyurl.com/mogcub3d" )
	end
end

function onContBtnRelease()
	a.Menu(false)
	if canGo==true then
		for i=group.numChildren,1,-1 do
			local child = group[i]
			child.parent:remove( child )
		end
		su.Startup(true)
		VDisplay=nil
	end
end

function onTutBtnRelease()
	
	if canGo==true then
		--[[
		for i=group.numChildren,1,-1 do
			local child = group[i]
			child.parent:remove( child )
		end
		t.FromTheTop()
		sav.Save()
		--]]
	--	local asd=display.newText("Tu eres en serio?",0,0,"Game Over",110)
		local asd=display.newText("Aprende a jugar tu solo.",0,0,"Game Over",110)
		asd.x=TutBtn.x
		asd.y=TutBtn.y
		group:insert(asd)
		display.remove(TutBtn)
	end
end

function onOptnBtnRelease()
	if canGo==true then
		for i=group.numChildren,1,-1 do
			local child = group[i]
			child.parent:remove( child )
		end
		VDisplay=nil
		option.DisplayOptions()
	end
end

function onScreBtnRelease()
	if canGo==true then
		for i=group.numChildren,1,-1 do
			local child = group[i]
			child.parent:remove( child )
		end
		VDisplay=nil
		scr.HighScores()
	end
end

<<<<<<< HEAD
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
	GVersion=v.HowDoIVersion(true)
	canGo=false
	
	local background = display.newImageRect( "bkgs/background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	local titleLogo = display.newImageRect( "titleB.png", 477, 254 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	titleLogo.xScale=0.75
	titleLogo.yScale=titleLogo.xScale
	saved=sav.CheckSave()
	scr.CheckScore()
	if saved==true then
		ContBtn = widget.newButton{
			label="Continue",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=30,
			defaultFile="button.png",
			overFile="button-over.png",
			width=308, height=80,
			onRelease = onContBtnRelease
			
		}
		ContBtn:setReferencePoint( display.CenterReferencePoint )
		ContBtn.x = display.contentWidth*0.5
		ContBtn.y = 312
	elseif saved==false then
		ContBtn = widget.newButton{
			label="Continue",
			labelColor = { default={0,0,0}, over={255,255,255} },
			fontSize=30,
			defaultFile="inactive.png",
			overFile="inactive-over.png",
			width=308, height=80,
		}
		ContBtn:setReferencePoint( display.CenterReferencePoint )
		ContBtn.x = display.contentWidth*0.5
		ContBtn.y = 312
	end
	
	PlayBtn = widget.newButton{
		label="New Game",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button.png",
		overFile="button-over.png",
		width=308, height=80,
		onRelease = onPlayBtnRelease
	}
	PlayBtn:setReferencePoint( display.CenterReferencePoint )
	PlayBtn.x = display.contentWidth*0.5
	PlayBtn.y = ContBtn.y+100
	
	TutBtn = widget.newButton{
		label="TBA",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="inactive.png",
		overFile="inactive-over.png",
		width=308, height=80,
		--onRelease = onTutBtnRelease
	}
	TutBtn:setReferencePoint( display.CenterReferencePoint )
	TutBtn.x = display.contentWidth*0.5
	TutBtn.y = PlayBtn.y+100
	
	OptnBtn = widget.newButton{
		label="Options",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button.png",
		overFile="button-over.png",
		width=308, height=80,
		onRelease = onOptnBtnRelease
	}
	OptnBtn:setReferencePoint( display.CenterReferencePoint )
	OptnBtn.x = display.contentWidth*0.5
	OptnBtn.y = TutBtn.y+100
	
	ScreBtn = widget.newButton{
		label="High Scores",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button.png",
		overFile="button-over.png",
		width=308, height=80,
		onRelease = onScreBtnRelease
	}
	ScreBtn:setReferencePoint( display.CenterReferencePoint )
	ScreBtn.x = display.contentWidth*0.5
	ScreBtn.y = OptnBtn.y+100
	
	sign=display.newImageRect("sign.png", 95, 70)
	sign.xScale=2.3
	sign.yScale=2.3
	sign.x=(display.contentWidth-130)
	sign.y=(display.contentHeight-90)
	
	VDisplay = display.newText(("Version:\n"..GVersion),0,0,labelFont, 30 )
	VDisplay:setTextColor( 0, 0, 0)
	VDisplay.x=sign.x
	VDisplay.y=sign.y-25
	
	logo=display.newImageRect("Symbol.png",160,260)
	logo.x=80
	logo.y=display.contentHeight-130
	
	ad1=display.newImageRect("ad1.png",57,57)
	ad1.x=logo.x+160
	ad1.y=logo.y+30
	ad1.xScale=2.0
	ad1.yScale=ad1.xScale
	ad1:addEventListener("tap",openAd1)
	
	ad2=display.newImageRect("ad2.png",57,57)
	ad2.x=ad1.x+(70*ad1.xScale)
	ad2.y=ad1.y
	ad2.xScale=ad1.xScale
	ad2.yScale=ad1.xScale
	ad2:addEventListener("tap",openAd2)
	
	Splash=s.GetSplash()
	
	Sounds=a.sfx()
	if Sounds==true or Sounds==false then
	else
		a.LoadSounds()
	end
	a.Menu(true)
	group:insert(background)
	group:insert(ad2)
	group:insert(ad1)
	group:insert(ContBtn)
	group:insert(Splash)
	group:insert(PlayBtn)
	group:insert(TutBtn)
	group:insert(OptnBtn)
	group:insert(ScreBtn)
	group:insert(titleLogo)
	group:insert(sign)
	group:insert(VDisplay)
	group:insert(logo)
end

=======
>>>>>>> B1.9.0
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
			sign:addEventListener("tap",onUpdateBtnRelease)
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

function Keyboard()
	local letters={
		"A","B","C","D","E","F","G",
		"H","I","J","K","L","M","N",
		"O","P","Q","R","S","T","U",
		"V","W","X","Y","Z",
		"a","b","c","d","e","f","g",
		"h","i","j","k","l","m","n",
		"o","p","q","r","s","t","u",
		"v","w","x","y","z",
	}
	keys={}
	keys2={}
	kbacks={}
	kbacks2={}
	kbrd=display.newGroup()
	UpdateName()
	
	
	bkg=display.newImageRect("bkgs/bkgname.png", 768, 1024)
	bkg.x,bkg.y = display.contentCenterX, display.contentCenterY
	kbrd:insert( bkg )
	
	for i=1,table.maxn(letters)/2 do
		keys[i]=display.newText( (letters[i]) ,0,0,"MoolBoran",110)
		keys[i]:setTextColor( 0, 0, 0)
		keys[i].x=80+(75*((i-1)%9))
		keys[i].y=((display.contentHeight/2)-120)+(90*math.floor((i-1)/9))
		kbrd:insert( keys[i] )
		
		kbacks[i]=display.newRect(0,0,70,70)
		kbacks[i].x=keys[i].x
		kbacks[i].y=keys[i].y-20
		kbacks[i]:setFillColor(0,0,0,0)
		kbrd:insert( kbacks[i] )
		
		function Input()
			LetterChange(keys[i].text)
		end
		
		kbacks[i]:addEventListener("tap",Input)
	end
	
	
	for i=table.maxn(letters)/2+1,table.maxn(letters) do
		keys2[i]=display.newText( (letters[i]) ,0,0,"MoolBoran",110)
		keys2[i]:setTextColor( 0, 0, 0)
		keys2[i].x=80+(75*((i-1-table.maxn(letters)/2)%9))
		keys2[i].y=((display.contentHeight/2)+160)+(90*math.floor((i-1-table.maxn(letters)/2)/9))
		kbrd:insert( keys2[i] )
		
		kbacks2[i]=display.newRect(0,0,70,70)
		kbacks2[i].x=keys2[i].x
		kbacks2[i].y=keys2[i].y-20
		kbacks2[i]:setFillColor(0,0,0,0)
		kbrd:insert( kbacks2[i] )
		
		function Input()
			LetterChange(keys2[i].text)
		end
		
		kbacks2[i]:addEventListener("tap",Input)
	end
	
	function Backspace()
		LetterChange(true)
	end
	
	DelBtn = widget.newButton{
		label="Backspace",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton2.png",
		width=252, height=55,
		onRelease = Backspace
	}
	DelBtn:setReferencePoint( display.CenterReferencePoint )
	DelBtn.x = display.contentCenterX
	DelBtn.y = display.contentHeight-40
	kbrd:insert( DelBtn )
	
	EndBtn = widget.newButton{
		label="Continue",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton2.png",
		width=252, height=55,
		onRelease = End
	}
	EndBtn:setReferencePoint( display.CenterReferencePoint )
	EndBtn.x = display.contentWidth-130
	EndBtn.y = display.contentHeight-40
	kbrd:insert( EndBtn )
	
	BackBtn = widget.newButton{
		label="Back",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton2.png",
		width=252, height=55,
		onRelease = Back2Menu
	}
	BackBtn:setReferencePoint( display.CenterReferencePoint )
	BackBtn.x = 130
	BackBtn.y = display.contentHeight-40
	kbrd:insert( BackBtn )
end

function Back2Menu()
	DelKeyboard()
	ShowMenu()
	canGo=true
	namedis=nil
	curname=nil
end

function UpdateName()
	if not(namedis) then
		namedis=display.newText((""),0,0,"MoolBoran",120)
		namedis:setTextColor( 0, 0, 0)
		namedis.x=display.contentWidth/2
		namedis.y=280
		kbrd:insert( namedis )
	end
	if (curname) then
		namedis.text=curname
	end
	namedis:toFront()
end

function LetterChange(let)
	if let==true then
		curname=string.sub(curname,1,#curname-1)
	else
		if (curname) and #curname~=12 then
			curname=(namedis.text..let)
		elseif not (curname) then
			curname=(namedis.text..let)
		end
	end
	UpdateName()
end

function DelKeyboard()
	for i=kbrd.numChildren,1,-1 do
		if kbrd[i] then
			local child = kbrd[i]
			child.parent:remove( child )
			child=nil
		end	
	end
end

function End()
	DelKeyboard()
	su.Startup(curname)
	namedis=nil
	curname=nil
end
