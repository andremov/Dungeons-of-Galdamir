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

function onBackRelease()
	for i=optionz.numChildren,1,-1 do
		local child = optionz[i]
		child.parent:remove( child )
	end
	menu.ShowMenu()
	menu.ReadySetGo()
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

function DisplayOptions()
	local background = display.newImageRect( "bkgs/bkgoptions.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	optionz:insert(background)
	
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
	
	Back = widget.newButton{
		label="Back",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = onBackRelease
	}
	Back:setReferencePoint( display.CenterReferencePoint )
	Back.x = display.contentWidth*0.5
	Back.y = display.contentHeight-100
	optionz:insert(Back)
	
	Char = widget.newButton{
		label="Character Customization",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button2.png",
		overFile="button2-over.png",
		width=380, height=80,
		onRelease = onCharRelease
	}
	Char:setReferencePoint( display.CenterReferencePoint )
	Char.x = display.contentWidth*0.5
	Char.y = display.contentHeight*0.5+210
	optionz:insert(Char)
	
	Size = widget.newButton{
		label="Map Size",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = FunSize
	}
	Size:setReferencePoint( display.CenterReferencePoint )
	Size.x = Char.x
	Size.y = Char.y-90
	optionz:insert(Size)
	
	function SaveDel()
		sav.WipeSave()
		display.remove(Save)
		local Savetxt=display.newText("Save deleted!",0,0,"Game Over",100)
		Savetxt.x = Size.x
		Savetxt.y = Size.y-90
		Savetxt:toFront()
		optionz:insert(Savetxt)
	end
	
	local path = system.pathForFile(  "DoGSave.sav", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "r" )
	if (fh) then
		local contents = fh:read( "*a" )
		if (contents) and contents~="" and contents~=" " then
			Save = widget.newButton{
				label="Delete Save",
				labelColor = { default={0,0,0}, over={255,255,255} },
				fontSize=30,
				defaultFile="button1.png",
				overFile="button1-over.png",
				width=308, height=80,
				onRelease = SaveDel
			}
			Save:setReferencePoint( display.CenterReferencePoint )
			Save.x = Size.x
			Save.y = Size.y-90
			optionz:insert(Save)
		end
	io.close( fh )
	end
	
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
