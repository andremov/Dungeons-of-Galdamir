-----------------------------------------------------------------------------------------
--
-- Options.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local gearsheet = graphics.newImageSheet( "gearsprite.png", { width=50, height=50, numFrames=30 })
local widget = require "widget"
local menu=require("Lmenu")
local audio=require("Laudio")
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
	SUnmute:removeSelf()
	SMute:removeSelf()
	MUnmute:removeSelf()
	MMute:removeSelf()
	menu.ReadySetGo()
end
	
function FunSize()
	
	map.MapSizeMenu()
	SUnmute:removeSelf()
	SMute:removeSelf()
	MUnmute:removeSelf()
	MMute:removeSelf()
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
	SUnmute:removeSelf()
	SMute:removeSelf()
	MUnmute:removeSelf()
	MMute:removeSelf()
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
	defaultFile="button.png",
	overFile="button-over.png",
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
	defaultFile="button.png",
	overFile="button-over.png",
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
				defaultFile="button.png",
				overFile="button-over.png",
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
	
	--AudioOnOff()
	
	scroll=display.newImageRect("scroll.png",600,50)
	scroll.x=display.contentCenterX
	scroll.y=display.contentCenterY-160
	optionz:insert(scroll)
	
	scrollind=display.newImageRect("scrollind.png",15,50)
	scrollind.x=display.contentCenterX+290
	scrollind.y=display.contentHeight/2-160
	optionz:insert(scrollind)
	
end
--[[
function AudioOnOff()
	Sound=audio.sfx()
	Music=audio.muse()
	
	SMute = display.newImageRect("soundoff.png",50,50)
	SMute.x,SMute.y = (display.contentWidth/3), display.contentHeight/2-160
	SMute.xScale=3
	SMute.yScale=3
	
	SUnmute = display.newImageRect("soundon.png",50,50)
	SUnmute.x,SUnmute.y = (display.contentWidth/3), display.contentHeight/2-160
	SUnmute.xScale=3
	SUnmute.yScale=3
	
	MMute = display.newImageRect("musicoff.png",50,50)
	MMute.x,MMute.y = (display.contentWidth/3)*2, display.contentHeight/2-160
	MMute.xScale=3
	MMute.yScale=3
	
	MUnmute = display.newImageRect("musicon.png",50,50)
	MUnmute.x,MUnmute.y = (display.contentWidth/3)*2, display.contentHeight/2-160
	MUnmute.xScale=3
	MUnmute.yScale=3
	
	if Sound==true then
		SUnmute.isVisible=true
		SMute.isVisible=false
		SUnmute:addEventListener("tap",SoundsOff)
	elseif Sound==false then
		SMute.isVisible=true
		SUnmute.isVisible=false
		SMute:addEventListener("tap",SoundsOn)
	end
	if Music==true then
		MUnmute.isVisible=true
		MMute.isVisible=false
		MUnmute:addEventListener("tap",MusicOff)
	elseif Music==false then
		MMute.isVisible=true
		MUnmute.isVisible=false
		MMute:addEventListener("tap",MusicOn)
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
]]