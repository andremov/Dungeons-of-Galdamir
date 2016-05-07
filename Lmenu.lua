-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local su=require("LStartup")
local a=require("LAudio")
local option=require("LOptions")
local s=require("LSplashes")
local v=require("LVersion")
local t=require("Ltutorial")
local sav=require("LSaving")
local scr=require("LScore")
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

function ReadySetGo()
	canGo=true
end

function onPlayBtnRelease()
	a.Play(12)
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
				defaultFile="button.png",
				overFile="button-over.png",
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
				defaultFile="button.png",
				overFile="button-over.png",
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
	a.Play(12)
	for i=group.numChildren,1,-1 do
		local child = group[i]
		child.parent:remove( child )
	end
	timer.performWithDelay(100,Keyboard)
	VDisplay=nil
	local path = system.pathForFile(  "DoGSave.sav", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "w+" )
	fh:write("")
	io.close( fh )
end

function Stahp()
	a.Play(12)
	display.remove(CanBtn)
	display.remove(CantBtn)
	display.remove(asd2)
	
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
	group:insert(ContBtn)
	
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
	a.Play(12)
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
	a.Play(12)
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
	a.Play(12)
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
	a.Play(12)
	if canGo==true then
		for i=group.numChildren,1,-1 do
			local child = group[i]
			child.parent:remove( child )
		end
		VDisplay=nil
		scr.HighScores()
	end
end

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
	
	local titleLogo = display.newImageRect( "title.png", 720, 98 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
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
		label="Tutorial (WIP)",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button.png",
		overFile="button-over.png",
		width=308, height=80,
		onRelease = onTutBtnRelease
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
	
	logo=display.newImageRect("Symbol.png",200,240)
	logo.xScale=0.75
	logo.yScale=0.75
	logo.x=80
	logo.y=display.contentHeight-100
	
	ad1=display.newImageRect("ad1.png",57,57)
	ad1.x=logo.x+160
	ad1.y=logo.y+30
	ad1.xScale=1.5
	ad1.yScale=ad1.xScale
	ad1:addEventListener("tap",openAd1)
	
	ad2=display.newImageRect("ad2.png",57,57)
	ad2.x=ad1.x+120
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

function isVersion(val)
	if (VDisplay2) then
		display.remove(VDisplay2)
	end
	if val==true then
		if (VDisplay) then
			if canGo==true then
				VDisplay2 = display.newText(("Up to date."),0,0,labelFont, 40 )
				VDisplay2:setTextColor( 0, 150, 0)
				VDisplay2.x=VDisplay.x
				VDisplay2.y=VDisplay.y+75
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
			VDisplay2 = display.newText(("Update available!"),0,0,labelFont, 28 )
			VDisplay2:setTextColor( 150, 0, 0)
			VDisplay2.x=VDisplay.x
			VDisplay2.y=VDisplay.y+70
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
				VDisplay2 = display.newText(("Update check failed."),0,0,labelFont, 25 )
				VDisplay2:setTextColor( 150, 0, 0)
				VDisplay2.x=VDisplay.x
				VDisplay2.y=VDisplay.y+70
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
	kbrd=display.newGroup()
	UpdateName()
	
	local title=display.newText(("Character Name"),0,0,native.systemFont,75)
	title.x=display.contentWidth/2
	title.y=100
	kbrd:insert(title)
	
	for i=1,table.maxn(letters)/2 do
		keys[i]=display.newText( (letters[i]) ,0,0,native.systemFont,75)
		keys[i].x=80+(75*((i-1)%9))
		keys[i].y=((display.contentHeight/2)-50)+(80*math.floor((i-1)/9))
		kbrd:insert( keys[i] )
		
		function Input()
			LetterChange(keys[i].text)
		end
		
		keys[i]:addEventListener("tap",Input)
	end
	
	
	for i=table.maxn(letters)/2+1,table.maxn(letters) do
		keys2[i]=display.newText( (letters[i]) ,0,0,native.systemFont,75)
		keys2[i].x=80+(75*((i-1-table.maxn(letters)/2)%9))
		keys2[i].y=((display.contentHeight/2)+220)+(80*math.floor((i-1-table.maxn(letters)/2)/9))
		kbrd:insert( keys2[i] )
		
		function Input()
			LetterChange(keys2[i].text)
		end
		
		keys2[i]:addEventListener("tap",Input)
	end
	
	function Backspace()
		LetterChange(true)
	end
	
	keys[#keys+1] = widget.newButton{
		defaultFile="del1.png",
		overFile="del2.png",
		width=85, height=85,
		onRelease = Backspace
	}
	keys[#keys]:setReferencePoint( display.CenterReferencePoint )
	keys[#keys].x = 80+(75*((table.maxn(letters)/2)%9))
	keys[#keys].y = ((display.contentHeight/2)-50)+(80*math.floor((table.maxn(letters)/2)/9))
	kbrd:insert( keys[#keys] )
	
	keys2[#keys2+1] = widget.newButton{
		defaultFile="end1.png",
		overFile="end2.png",
		width=85, height=85,
		onRelease = End
	}
	keys2[#keys2]:setReferencePoint( display.CenterReferencePoint )
	keys2[#keys2].x = 80+(75*((table.maxn(letters)+1)%9))
	keys2[#keys2].y = ((display.contentHeight/2)+130)+(85*math.floor((table.maxn(letters)-18)/9))
	kbrd:insert( keys2[#keys2] )
end

function UpdateName()
	if not(namedis) then
		namedis=display.newText((""),0,0,native.systemFont,80)
		namedis.x=display.contentWidth/2
		namedis.y=300
		kbrd:insert( namedis )
	end
	if (curname) then
		namedis.text=curname
	end
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
