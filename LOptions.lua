-----------------------------------------------------------------------------------------
--
-- Options.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local gearsheet = graphics.newImageSheet( "gearsprite.png", { width=50, height=50, numFrames=30 })
local widget = require "widget"
local menu=require("Lmenu")
local a=require("Laudio")
local map=require("Lmaphandler")
local char=require("Lchars")
local scr=require("Lscore")
local sav=require("Lsaving")
local optionz=display.newGroup()
local SMute
local SUnmute
local MMute
local MUnmute
local Sound
local Music
local Back
local Char
local Small
local Med
local Large

function DisplayOptions()
	scr.CheckScore()
	menu.FindMe(2)
	title=display.newText("Options",0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	title:setTextColor(125,250,125)
	optionz:insert(title)
	
	gear=display.newSprite( gearsheet, { name="gear", start=1, count=30, time=3000,}  )
	gear.x=display.contentWidth
	gear.y=display.contentHeight
	gear.xScale=4.0
	gear.yScale=4.0
	gear:play()
	optionz:insert(gear)
	
	gear2=display.newSprite( gearsheet, { name="gear2", start=1, count=30, time=4000,}  )
	gear2.x=0
	gear2.y=0
	gear2.xScale=6.0
	gear2.yScale=6.0
	gear2:play()
	optionz:insert(gear2)
	
	gear3=display.newSprite( gearsheet, { name="gear3", start=1, count=30, time=3500,}  )
	gear3.x=0
	gear3.y=display.contentHeight
	gear3.xScale=5.0
	gear3.yScale=5.0
	gear3:play()
	optionz:insert(gear3)
	
	BackBtn = widget.newButton{
		label="Back",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onBackRelease
	}
	BackBtn:setReferencePoint( display.CenterReferencePoint )
	BackBtn.x = display.contentWidth*0.5
	BackBtn.y = display.contentHeight-100
	optionz:insert(BackBtn)
	
	Char = widget.newButton{
		label="Character",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onCharRelease
	}
	Char:setReferencePoint( display.CenterReferencePoint )
	Char.x = display.contentWidth*0.25
	Char.y = display.contentHeight*0.5+210
	optionz:insert(Char)
	
	Map = widget.newButton{
		label="Map",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = FunSize
	}
	Map:setReferencePoint( display.CenterReferencePoint )
	Map.x = display.contentWidth*0.75
	Map.y = Char.y
	optionz:insert(Map)
	
	ScreBtn = widget.newButton{
		label="High Scores",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onScreBtnRelease
	}
	ScreBtn:setReferencePoint( display.CenterReferencePoint )
	ScreBtn.x = display.contentCenterX
	ScreBtn.y = Char.y-100
	optionz:insert(ScreBtn)
	
	scroll=display.newImageRect("scroll.png",600,50)
	scroll.x=display.contentCenterX
	scroll.y=display.contentCenterY-170
	scroll.xScale=1.25
	scroll.yScale=scroll.xScale
	scroll:addEventListener("touch",MusicScroll)
	optionz:insert(scroll)
	
	local m=a.muse()
	m=m*10
	scrollind=display.newImageRect("scrollind.png",15,50)
	scrollind.x=display.contentCenterX-(290*scroll.xScale)+( m*(290*scroll.xScale)/5 )
	scrollind.y=scroll.y
	scrollind.xScale=1.5
	scrollind.yScale=scrollind.xScale
	optionz:insert(scrollind)
	
	musicind=display.newText( ("Music Volume: "..(m*10).."%"),0,0,"MoolBoran",50 )
	musicind.x=scroll.x
	musicind.y=scroll.y+10
	optionz:insert(musicind)
	
	scroll2=display.newImageRect("scroll.png",600,50)
	scroll2.x=display.contentCenterX
	scroll2.y=display.contentCenterY-70
	scroll2.xScale=scroll.xScale
	scroll2.yScale=scroll.xScale
	scroll2:addEventListener("touch",SoundScroll)
	optionz:insert(scroll2)
	
	local s=a.sfx()
	s=s*10
	scrollind2=display.newImageRect("scrollind.png",15,50)
	scrollind2.x=display.contentCenterX-(290*scroll.xScale)+( s*(290*scroll.xScale)/5 )
	scrollind2.y=scroll2.y
	scrollind2.xScale=scrollind.xScale
	scrollind2.yScale=scrollind.xScale
	optionz:insert(scrollind2)
	
	soundind=display.newText( ("Sound Volume: "..(s*10).."%"),0,0,"MoolBoran",50 )
	soundind.x=scroll2.x
	soundind.y=scroll2.y+10
	optionz:insert(soundind)
	
end

function onScreBtnRelease()
	for i=optionz.numChildren,1,-1 do
		local child = optionz[i]
		child.parent:remove( child )
	end
	scr.HighScores()
end

function onBackRelease()
	for i=optionz.numChildren,1,-1 do
		local child = optionz[i]
		child.parent:remove( child )
	end
	menu.ShowMenu()
	timer.performWithDelay(100,menu.ReadySetGo)
end
	
function FunSize()
	map.MapSizeMenu()
	for i=optionz.numChildren,1,-1 do
		local child = optionz[i]
		child.parent:remove( child )
	end
end

function onCharRelease()
	for i=optionz.numChildren,1,-1 do
		local child = optionz[i]
		child.parent:remove( child )
	end
	char.CharMenu()
end

function MusicScroll( event )
	if event.x>display.contentCenterX+(290*scroll.xScale) then
		scrollind.x=display.contentCenterX+(290*scroll.xScale)
		a.MusicVol(1.0)
		musicind.text=("Music Volume: "..(1.0*100).."%")
	elseif event.x<display.contentCenterX-(290*scroll.xScale) then
		scrollind.x=display.contentCenterX-(290*scroll.xScale)
		a.MusicVol(0.0)
		musicind.text=("Music Volume: "..(0.0*100).."%")
	else
		for s=1,11 do
			local x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*58 )
			if event.x>x-(290*scroll.xScale)/10 and event.x<x+(290*scroll.xScale)/10 then
				scrollind.x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*(290*scroll.xScale)/5 )
				a.MusicVol((s-1)/10)
				musicind.text=("Music Volume: "..((s-1)*10).."%")
			end
		end
	end
end

function SoundScroll( event )
	if event.x>display.contentCenterX+(290*scroll.xScale) then
		scrollind2.x=display.contentCenterX+(290*scroll.xScale)
		a.SoundVol(1.0)
		soundind.text=("Sound Volume: "..(1.0*100).."%")
	elseif event.x<display.contentCenterX-(290*scroll.xScale) then
		scrollind2.x=display.contentCenterX-(290*scroll.xScale)
		a.SoundVol(0.0)
		soundind.text=("Sound Volume: "..(0.0*100).."%")
	else
		for s=1,11 do
			local x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*58 )
			if event.x>x-(290*scroll.xScale)/10 and event.x<x+(290*scroll.xScale)/10 then
				scrollind2.x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*(290*scroll.xScale)/5 )
				a.SoundVol((s-1)/10)
				soundind.text=("Sound Volume: "..((s-1)*10).."%")
			end
		end
	end
end
