-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local egg=math.random(1,1000000)
local widget = require "widget"
local group=display.newGroup()
local s=require("Lsplashes")
local v=require("Lversion")
local o=require("Loptions")
local sc=require("Lscore")
local c=require("Lchars")
local a=require("Laudio")
local p=require("Lplay")
local ui=require("Lui")
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
local asd={}
local runes={}
local runegroup=display.newGroup()
local words={"love","hate","dragon","mystery","quest","penis","skill","adventure","death","betrayal","vengeance","fuck"}
local numofwords=30

function getWord()
	if (runes[numofwords]) then
	else
		runes[numofwords]=display.newText(words[math.random(1,table.maxn(words))],math.random(50,700),math.random(50,1000),"Runes of Galdamir",math.random(5,10)*10)
		runes[numofwords].red=1
		runes[numofwords].blue=1
		runes[numofwords].green=1
		runes[numofwords].alpha=0.5
		runes[numofwords].process=0
		runes[numofwords]:toBack()
		runegroup:insert(runes[numofwords])
		if runes[numofwords].x>display.contentCenterX then
			runes[numofwords].xplus=-1
		else
			runes[numofwords].xplus=1
		end
	end
	numofwords=numofwords-1
	if numofwords==0 then
		numofwords=30
	end
	timer.performWithDelay(500,getWord)
end

function Glow()
	for i in pairs (runes) do
		if runes[i].green<=0 then
			runes[i].process=1
		elseif runes[i].green>=1 then
			runes[i].process=0
		end
		if runes[i].process==0 then
			runes[i].green=runes[i].green-.25
			runes[i].red=runes[i].red+.5
			runes[i].blue=runes[i].blue+.55
		else
			runes[i].green=runes[i].green+.25
			runes[i].red=runes[i].red+.5
			runes[i].blue=runes[i].blue+.5
		end
		runes[i].x=runes[i].x+(runes[i].xplus*2)
		runes[i].alpha=runes[i].alpha-.002
		runes[i]:setFillColor(runes[i].red,runes[i].green,runes[i].blue,runes[i].alpha)
		if runes[i].alpha<=0 then
			display.remove(runes[i])
			runes[i]=nil
		end
	end
	runegroup:toBack()
	timer.performWithDelay(100,Glow)
end

function FirstMenu()
	getWord()
	Glow()

	Sounds=a.sfx()
	
	if (Sounds) then
	else
		a.LoadSounds()
	end
end

function ShowMenu()
	
	if egg==1 then
		titleLogo = display.newImageRect( "ui/title2.png", 477, 254 )
	else
		titleLogo = display.newImageRect( "ui/titleW.png", 477, 254 )
	end
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
		defaultFile="ui/cbutton.png",
		overFile="ui/cbutton-over.png",
		width=290, height=90,
		onRelease = onPlayBtnRelease
	}
	PlayBtn.x = display.contentWidth*0.5
	PlayBtn.y = display.contentCenterY-20
	group:insert(PlayBtn)
	
	OptnBtn =  widget.newButton{
		label="Options",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/cbutton.png",
		overFile="ui/cbutton-over.png",
		width=290, height=90,
		onRelease = onOptnBtnRelease
	}
	OptnBtn.x = display.contentWidth*0.5
	OptnBtn.y = PlayBtn.y+100
	group:insert(OptnBtn)
	
	--[[
	langBtn=display.newImageRect("lang.png",430,350)
	langBtn.xScale=0.2
	langBtn.yScale=langBtn.xScale
	langBtn.x=70
	langBtn.y=display.contentHeight-70
	langBtn:addEventListener("tap",doThing)
	group:insert(langBtn)
	
	if hieroglyphics=="EN" then
		langTxt=display.newText("English",0,0,"MoolBoran",40)
		langTxt:setFillColor(80,1,80)
		langTxt.x=langBtn.x
		langTxt.y=langBtn.y+50
		group:insert(langTxt)
	elseif hieroglyphics=="ES" then
		langTxt=display.newText("Espanol",0,0,"MoolBoran",40)
		langTxt:setFillColor(80,1,80)
		langTxt.x=langBtn.x
		langTxt.y=langBtn.y+50
		group:insert(langTxt)
	end
	--]]
	
	logo=display.newImageRect("ui/Symbol3W.png",206,206)
	logo.xScale=0.75
	logo.yScale=logo.xScale
	logo.x=display.contentCenterX
	logo.y=display.contentHeight-130
	logo:addEventListener("touch",Credits)
	group:insert(logo)
	
	if ( "simulator" == system.getInfo("environment") ) then
		print "Hello, developer!"
	
		GVersion=v.HowDoIVersion(true)
		print ("Version: "..GVersion)
		
		sign=display.newImageRect("ui/sign.png", 95, 70)
		sign.xScale=2.3
		sign.yScale=2.3
		sign.x=display.contentWidth/4*3+50
		sign.y=(display.contentHeight-90)
		group:insert(sign)
		
		VerDisplay = display.newText(("Version:"),0,0,"MoolBoran", 70 )
		VerDisplay:setFillColor( 0, 0, 0)
		VerDisplay.x=sign.x
		VerDisplay.y=sign.y-30
		group:insert(VerDisplay)
		
		VDisplay = display.newText((GVersion),0,0,"MoolBoran", 45 )
		VDisplay:setFillColor( 0, 0, 0)
		VDisplay.x=VerDisplay.x
		VDisplay.y=VerDisplay.y+40
		group:insert(VDisplay)
	end
	
	Splash=s.GetSplash()
	group:insert(Splash)
	
	a.changeMusic(1)
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
			VDisplay2:setFillColor( 0, 0.6, 0)
			VDisplay2.x=VDisplay.x
			VDisplay2.y=VDisplay.y+55
			group:insert(VDisplay2)
		end
	elseif val==false then
		if (VDisplay) then
			VDisplay2 = display.newText(("Update available!"),0,0,"MoolBoran", 45 )
			VDisplay2:setFillColor( 0.6, 0, 0)
			VDisplay2.x=VDisplay.x
			VDisplay2.y=VDisplay.y+45
			group:insert(VDisplay2)
		end
	elseif val==nil then
		if (VDisplay) then
			VDisplay2 = display.newText(("Update check failed."),0,0,"MoolBoran", 45 )
			VDisplay2:setFillColor( 0.6, 0, 0)
			VDisplay2.x=VDisplay.x
			VDisplay2.y=VDisplay.y+50
			group:insert(VDisplay2)
		end
	end
end

-- Credits
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
		title:setFillColor(0.5,1,0.5)
		group:insert(title)
		
		function One()
			CreditsTab(1)
		end
		
		coding=display.newText("Coding",0,0,"MoolBoran",65)
		coding.x=display.contentWidth/5
		coding.y=display.contentHeight-100
		coding:addEventListener("tap",One)
		coding:setFillColor(0.5,0.5,1)
		group:insert(coding)
		
		function Two()
			CreditsTab(2)
		end
		
		sound=display.newText("Sound",0,0,"MoolBoran",65)
		sound.x=display.contentWidth/5*2
		sound.y=display.contentHeight-100
		sound:addEventListener("tap",Two)
		sound:setFillColor(0.5,0.5,1)
		group:insert(sound)
		
		function Three()
			CreditsTab(3)
		end
		
		graphic=display.newText("Graphic",0,0,"MoolBoran",65)
		graphic.x=display.contentWidth/5*3
		graphic.y=display.contentHeight-100
		graphic:addEventListener("tap",Three)
		graphic:setFillColor(0.5,0.5,1)
		group:insert(graphic)
		
		function Four()
			Credone()
		end
		
		back=display.newText("Back",0,0,"MoolBoran",65)
		back.x=display.contentWidth/5*4
		back.y=display.contentHeight-100
		back:addEventListener("tap",Four)
		back:setFillColor(0.5,0.5,1)
		group:insert(back)
	end
end

function CreditsTab(tab)
	for t=table.maxn(text),1,-1 do
		display.remove(text[t])
		text[t]=nil
	end
		coding:setFillColor(0.5,0.5,1)
		sound:setFillColor(0.5,0.5,1)
		graphic:setFillColor(0.5,0.5,1)
		if tab==1 then
			coding:setFillColor(1,0.5,0.5)
		elseif tab==2 then
			sound:setFillColor(1,0.5,0.5)
		elseif tab==3 then
			graphic:setFillColor(1,0.5,0.5)
		end
		--[[
			TO DO:
				SOUNDS
				- GOLD FREESOUND
				- ROCK FREESOUND
				- GATE FREESOUND
				CHARACTER
				ENEMIES
		--]]
	local executives={
		"Andres Movilla","- Developer",
		"Mauricio Movilla","- Publisher",
	}
	local sfx={
		"HorrorPen from OpenGameArt.org","- Composer of \"No More Magic\"",
		"Kevin Macleod from Incompetech.com","- Composer of \"Gagool\"",
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
		text[s]=display.newText(tables[tab][s],0,0,"MoolBoran",45)
		text[s].anchorX=0
		text[s].anchorY=0
		text[s].x=130+(-100*(s%2))
		text[s].y=125+(-30*((s%2)+1))+(100*math.ceil(s/2))
		group:insert(text[s])
	--	print (s.."x-"..text[s].x)
	--	print (s.."y-"..text[s].y)
	end
end

function Credone()
	Runtime:addEventListener("tap",NextStep)
end
