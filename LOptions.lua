-----------------------------------------------------------------------------------------
--
-- Options.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local char=require("Lchars")
local sav=require("Lsaving")
local menu=require("Lmenu")
local scr=require("Lscore")
local a=require("Laudio")
local optionz=display.newGroup()
local Sound
local Music
local Back
local tileID=0
local tiles={"Default","Notebook","Simple"}

function DisplayOptions()
	scr.CheckScore()
	title=display.newText("Options",0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	title:setFillColor(0.5,1,0.5)
	optionz:insert(title)
	
	BackBtn =  widget.newButton{
		label="Back",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/cbutton.png",
		overFile="ui/cbutton-over.png",
		width=290, height=90,
		onRelease = onBackRelease
	}
	BackBtn.x = display.contentWidth*0.5
	BackBtn.y = display.contentHeight-100
	optionz:insert(BackBtn)
	--[[
	Char =  widget.newButton{
		label="Character",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onCharRelease
	}
	Char.x = display.contentWidth*0.25
	Char.y = display.contentHeight*0.5+210
	optionz:insert(Char)
	]]
	--[[
	Map =  widget.newButton{
		label="Tilesets",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/cbutton.png",
		overFile="ui/cbutton-over.png",
		width=290, height=90,
		onRelease = FunSize
	}
	Map.x = display.contentWidth*0.75
	Map.y = display.contentHeight*0.5+210
	optionz:insert(Map)
	]]
	
	ScreBtn =  widget.newButton{
		label="High Scores",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/cbutton.png",
		overFile="ui/cbutton-over.png",
		width=290, height=90,
		onRelease = onScreBtnRelease
	}
	ScreBtn.x = display.contentWidth*0.5
	ScreBtn.y = display.contentHeight*0.5+210
	optionz:insert(ScreBtn)
	--[[
	Setting =  widget.newButton{
		label="UI Positions",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/cbutton.png",
		overFile="ui/cbutton-over.png",
		width=290, height=90,
		onRelease = onSettingRelease
	}
	Setting.x = display.contentCenterX--ScreBtn.x
	Setting.y = ScreBtn.y-100
	optionz:insert(Setting)
	]]
		
	tileprevbtn =  widget.newButton{
		label="<",
		font="MoolBoran",
		fontSize=70,
		labelYOffset=15,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/sbutton.png",
		overFile="ui/sbutton-over.png",
		width=90, height=90,
		onRelease = prevTile,
	}
	tileprevbtn.x = display.contentWidth*0.25
	tileprevbtn.y = display.contentHeight*0.5+100
	optionz:insert(tileprevbtn)
	
	tilenextbtn =  widget.newButton{
		label=">",
		font="MoolBoran",
		fontSize=70,
		labelYOffset=15,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/sbutton.png",
		overFile="ui/sbutton-over.png",
		width=90, height=90,
		onRelease = nextTile
	}
	tilenextbtn.x = display.contentWidth*0.75
	tilenextbtn.y = display.contentHeight*0.5+100
	optionz:insert(tilenextbtn)
	
	curtiletext=display.newText( tiles[tileID+1],0,0,"MoolBoran",60)
	curtiletext.x = display.contentWidth*0.5
	curtiletext.y = display.contentHeight*0.5+110
	optionz:insert(curtiletext)
	
	tiletext=display.newText( "Tileset:",0,0,"MoolBoran",80)
	tiletext.x = display.contentWidth*0.5
	tiletext.y = display.contentHeight*0.5+20
	optionz:insert(tiletext)
	
	scroll=display.newImageRect("ui/scroll.png",600,50)
	scroll.x=display.contentCenterX
	scroll.y=display.contentCenterY-170
	scroll.xScale=1.25
	scroll.yScale=scroll.xScale
	scroll:addEventListener("touch",MusicScroll)
	optionz:insert(scroll)
	
	local m=a.muse()
	m=m*10
	scrollind=display.newImageRect("ui/scrollind.png",15,50)
	scrollind.x=display.contentCenterX-(290*scroll.xScale)+( m*(290*scroll.xScale)/5 )
	scrollind.y=scroll.y
	scrollind.xScale=1.5
	scrollind.yScale=scrollind.xScale
	optionz:insert(scrollind)
	
	musicind=display.newText( ("Music Volume".." "..(m*10).."%"),0,0,"MoolBoran",60 )
	musicind.x=scroll.x
	musicind.y=scroll.y+10
	optionz:insert(musicind)
	
	scroll2=display.newImageRect("ui/scroll.png",600,50)
	scroll2.x=display.contentCenterX
	scroll2.y=display.contentCenterY-70
	scroll2.xScale=scroll.xScale
	scroll2.yScale=scroll.xScale
	scroll2:addEventListener("touch",SoundScroll)
	optionz:insert(scroll2)
	
	local s=a.sfx()
	s=s*10
	scrollind2=display.newImageRect("ui/scrollind.png",15,50)
	scrollind2.x=display.contentCenterX-(290*scroll.xScale)+( s*(290*scroll.xScale)/5 )
	scrollind2.y=scroll2.y
	scrollind2.xScale=scrollind.xScale
	scrollind2.yScale=scrollind.xScale
	optionz:insert(scrollind2)
	
	soundind=display.newText( ("Sound Volume".." "..(s*10).."%"),0,0,"MoolBoran",60 )
	soundind.x=scroll2.x
	soundind.y=scroll2.y+10
	optionz:insert(soundind)
	
end

function nextTile()
	tileID=tileID+1
	if tileID>table.maxn(tiles)-1 then
		tileID=0
	end
	curtiletext.text=tiles[tileID+1]
end

function prevTile()
	tileID=tileID-1
	if tileID<0 then
		tileID=table.maxn(tiles)-1
	end
	curtiletext.text=tiles[tileID+1]
end

function onScreBtnRelease()
	a.Play(12)
	for i=optionz.numChildren,1,-1 do
		local child = optionz[i]
		child.parent:remove( child )
	end
	scr.HighScores()
end

function onSettingRelease()
	a.Play(12)
	for i=optionz.numChildren,1,-1 do
		local child = optionz[i]
		child.parent:remove( child )
	end
	set.Start()
end

function onBackRelease()
	a.Play(12)
	for i=optionz.numChildren,1,-1 do
		local child = optionz[i]
		child.parent:remove( child )
	end
	menu.ShowMenu()
	timer.performWithDelay(100,menu.ReadySetGo)
end
	
function GetTiles()
	return tileID
end

function onCharRelease()
	a.Play(12)
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
		musicind.text=("Music Volume".." "..(1.0*100).."%")
	elseif event.x<display.contentCenterX-(290*scroll.xScale) then
		scrollind.x=display.contentCenterX-(290*scroll.xScale)
		a.MusicVol(0.0)
		musicind.text=("Music Volume".." "..(0.0*100).."%")
	else
		for s=1,11 do
			local x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*58 )
			if event.x>x-(290*scroll.xScale)/10 and event.x<x+(290*scroll.xScale)/10 then
				scrollind.x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*(290*scroll.xScale)/5 )
				a.MusicVol((s-1)/10)
				musicind.text=("Music Volume".." "..((s-1)*10).."%")
			end
		end
	end
end

function SoundScroll( event )
	if event.x>display.contentCenterX+(290*scroll.xScale) then
		scrollind2.x=display.contentCenterX+(290*scroll.xScale)
		a.SoundVol(1.0)
		soundind.text=("Sound Volume".." "..(1.0*100).."%")
	elseif event.x<display.contentCenterX-(290*scroll.xScale) then
		scrollind2.x=display.contentCenterX-(290*scroll.xScale)
		a.SoundVol(0.0)
		soundind.text=("Sound Volume".." "..(0.0*100).."%")
	else
		for s=1,11 do
			local x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*58 )
			if event.x>x-(290*scroll.xScale)/10 and event.x<x+(290*scroll.xScale)/10 then
				scrollind2.x=display.contentCenterX-(290*scroll.xScale)+( (s-1)*(290*scroll.xScale)/5 )
				a.SoundVol((s-1)/10)
				soundind.text=("Sound Volume".." "..((s-1)*10).."%")
			end
		end
	end
end
