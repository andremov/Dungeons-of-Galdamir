---------------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
-- GLOBAL
---------------------------------------------------------------------------------------

module(..., package.seeall)
local widget = require "widget"
local score=require("Lscore")
local save=require("Lsave")
local shSuffix="RLSE"
local loSuffix="RELEASE"
local verNum="1.3.0"

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

--[[
function FirstMenu()
	getWord()
	Glow()

	Sounds=a.sfx()
	
	if (Sounds) then
	else
		a.LoadSounds()
	end
end
--]]



---------------------------------------------------------------------------------------
-- MAIN MENU
---------------------------------------------------------------------------------------

local splash=require("Lsplashes")
local ui=require("Lui")

local mmg
MainMenu={}
-- local PlayBtn
-- local OptnBtn
-- local RSplash
-- local text={}
-- local Sounds
-- local Splash
-- local runes={}
-- local runegroup=display.newGroup()
-- local words={"love", "hate", "dragon", "mystery", "quest", "penis", "skill", "adventure", "death", "betrayal", "vengeance", "fuck"}
-- local numofwords=30

function MainMenu:show()
	
	mmg=display.newGroup()
	
	local bkg=ui.CreateWindow(660,280,3)
	bkg.y = 150
	bkg:setFillColor(0.2,0.2,1)
	mmg:insert(bkg)
	
	local title1 = display.newImageRect( "ui/DUNGEONS.png", 605, 109 )
	title1.x = display.contentWidth * 0.5
	title1.y = 80
	title1:setFillColor(0.8,0.2,0.2)
	mmg:insert(title1)
	
	local title2 = display.newImageRect( "ui/GALDAMIR.png", 618, 109 )
	title2.x = display.contentWidth * 0.5
	title2.y = 220
	title2:setFillColor(0.8,0.2,0.2)
	mmg:insert(title2)
	
	local title3 = display.newImageRect( "ui/of.png", 450, 106 )
	title3.x = display.contentWidth * 0.5
	title3.y = 150
	-- title3:setFillColor(0.8,0.2,0.2)
	mmg:insert(title3)
	
	
	local PlayBtn =  widget.newButton{
		label="Play",
		font="MoolBoran",
		fontSize=80,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=350, height=150,
		onRelease = function()
			MainMenu:clear()
			SaveGame:show()
		end
	}
	PlayBtn:setFillColor(0.6,1.0,0.6)
	PlayBtn.x = display.contentWidth*0.25
	PlayBtn.y = display.contentCenterY+40
	mmg:insert(PlayBtn)
	
	
	local OptnBtn =  widget.newButton{
		label="Options",
		font="MoolBoran",
		fontSize=80,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=350, height=150,
		onRelease = function()
			MainMenu:clear()
			Options:show()
		end
	}
	OptnBtn.x = display.contentWidth*0.75
	OptnBtn.y = PlayBtn.y
	mmg:insert(OptnBtn)
	
	local logo=display.newImageRect("ui/Logo Gris.png",641,538)
	logo.xScale=0.3
	logo.yScale=logo.xScale
	logo.x=display.contentCenterX
	logo.y=display.contentHeight-130
	-- logo:addEventListener("touch",Credits)
	mmg:insert(logo)
	
	-- Splash=s.GetSplash()
	-- group:insert(Splash)
end

--[[
function SplashChange()
	if (Splash) then
		display.remove(Splash)
		Splash=nil
	end
	Splash=s.GetSplash()
	group:insert(Splash)
end
--]]

function MainMenu:clear()
	for i=mmg.numChildren,1,-1 do
		local child = mmg[i]
		mmg.parent:remove( child )
		display.remove( child )
	end
	mmg=nil
end



---------------------------------------------------------------------------------------
-- SAVE GAME
---------------------------------------------------------------------------------------

local game=require("Lgame")
local save=require("Lsave")
local sgg
local slotg
SaveGame={}

function SaveGame:show()

	sgg=display.newGroup()
	
	local title=display.newText("Save Game",0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.3
	title.y = 80
	-- title:setFillColor(0.5,1,0.5)
	sgg:insert(title)
	
	--[[
		TutBtn =  widget.newButton{
			label="Tutorial",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="ui/cbutton.png",
			overFile="ui/cbutton-over.png",
			width=308, height=90,
			onRelease = onTutBtnRelease
		}
		TutBtn.x = display.contentWidth*0.5
		TutBtn.y = display.contentHeight*0.3
		sgg:insert(TutBtn)
	--]]
	local SlotBtn={}
	for btn=1,3 do
		local name=save.Load:getName(btn) or "No Data"
		SlotBtn[btn] =  widget.newButton{
			label=name,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=70,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=350, height=130,
			onRelease = function()
				for a=1,3 do
					SlotBtn[a]:setFillColor(0.1,0.5,0.1)
				end
				SlotBtn[btn]:setFillColor(0.5,1.0,0.5)
				SaveGame:slotClear()
				SaveGame["SLOT"]=btn
				SaveGame["NAME"]=name
				SaveGame:slotInfo()
			end
		}
		SlotBtn[btn].x = 200
		SlotBtn[btn].y = (title.y+110)+(140*(btn-1))
		SlotBtn[btn]:setFillColor(0.5,1.0,0.5)
		sgg:insert(SlotBtn[btn])
	end
	
	BackBtn =  widget.newButton{
		label="Back",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=300, height=100,
		onRelease = function()
			SaveGame:clear()
			MainMenu:show()
		end
	}
	BackBtn.x = 200
	BackBtn.y = display.contentHeight-100
	BackBtn:setFillColor(1.0,0.4,0.4)
	sgg:insert(BackBtn)
end

function SaveGame:slotInfo()
	slotg=display.newGroup()
	
	local gold, level=save.Load:getExtraInfo(SaveGame["SLOT"])
	gold=gold or 0
	level=level or 0
	
	local bkg=ui.CreateWindow(590,620,2)
	bkg.x=display.contentCenterX+180
	bkg.y=display.contentCenterY+30
	bkg:setFillColor( 0.91, 0.67, 0.33 )
	slotg:insert(bkg)
	
	local name=display.newText(SaveGame["NAME"],0,0,"MoolBoran",100)
	name.x = bkg.x
	name.y = bkg.y-225
	slotg:insert(name)
	
	local playlabel
	if (SaveGame["NAME"]=="No Data") then
		playlabel="New Game"
	else
		playlabel="Load Game"
		
		local playervisual=display.newImage( "Save"..SaveGame["SLOT"]..".png", system.DocumentsDirectory)
		playervisual.x=display.contentWidth-120
		playervisual.y=bkg.y+70
		playervisual.xScale=0.75
		playervisual.yScale=0.75
		slotg:insert(playervisual)
		
		local DeleteBtn =  widget.newButton{
			label="Delete",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=60,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=200, height=100,
			onRelease = function()
				SaveGame:deleteSlot(slot)
				SaveGame:refresh()
			end
		}
		DeleteBtn.x = name.x-150
		DeleteBtn.y = bkg.y+225
		DeleteBtn:setFillColor(1,0,0)
		slotg:insert(DeleteBtn)
	end
	
	local leveldisplay1=display.newText("Level:",0,0,"MoolBoran",70)
	leveldisplay1.x = bkg.x-175
	leveldisplay1.y = bkg.y-120
	slotg:insert(leveldisplay1)
	
	local leveldisplay2=display.newText(level,0,0,"MoolBoran",80)
	leveldisplay2.x = leveldisplay1.x+110
	leveldisplay2.y = leveldisplay1.y+45
	leveldisplay2.anchorX=1.0
	leveldisplay2:setFillColor(0.6,1,0.6)
	slotg:insert(leveldisplay2)
	
	local golddisplay1=display.newText("Gold:",0,0,"MoolBoran",70)
	golddisplay1.x = leveldisplay1.x
	golddisplay1.y = bkg.y+50
	slotg:insert(golddisplay1)
	
	local golddisplay2=display.newText(gold,0,0,"MoolBoran",80)
	golddisplay2.x = leveldisplay2.x
	golddisplay2.y = golddisplay1.y+45
	golddisplay2:setFillColor(1,1,0.6)
	golddisplay2.anchorX=1.0
	slotg:insert(golddisplay2)
	
	local PlayBtn =  widget.newButton{
		label=playlabel,
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=200, height=100,
		onRelease = SaveGame.loadSlot
	}
	PlayBtn.x = name.x+150
	PlayBtn.y = bkg.y+225
	PlayBtn:setFillColor(0,1,0)
	slotg:insert(PlayBtn)
	
end

function SaveGame:loadSlot()
	SaveGame:clear()
	if ( SaveGame["NAME"]=="No Data" ) then
		Keyboard:show()
	else
		game.Initial:create(SaveGame["SLOT"])
	end
end

function SaveGame:deleteSlot()
	save.Erase:clearSave(SaveGame["SLOT"])
end

function SaveGame:refresh()
	SaveGame:clear()
	SaveGame:show()
end

function SaveGame:slotClear()
	if (slotg) then
		for i=slotg.numChildren,1,-1 do
			local child = slotg[i]
			slotg.parent:remove( child )
			display.remove( child )
		end
		slotg=nil
	end
end

function SaveGame:clear()
	SaveGame:slotClear()
	for i=sgg.numChildren,1,-1 do
		local child = sgg[i]
		sgg.parent:remove( child )
		display.remove( child )
	end
	sgg=nil
end



---------------------------------------------------------------------------------------
-- KEYBOARD
---------------------------------------------------------------------------------------

local kg
Keyboard={}
Keyboard.letters={}
Keyboard.trackerchars={}

function Keyboard:show()
	kg=display.newGroup()
	
	local alphabet={"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"}
	letters={}
	letters["Y1"]=490
	letters["Y2"]=letters["Y1"]+90
	letters["Y3"]=letters["Y2"]+90
	
	-- local trackercount=1
	local tracker=ui.CreateWindow(890,170,1)
	tracker.y=150
	tracker:setFillColor(0.85, 0.64, 0.12)
	kg:insert(tracker)
	local CCx=display.contentCenterX
	
	local trackerchars={}
	for i=1,9 do
		trackerchars[i]=display.newText("__",0,0,"MoolBoran",120)
		trackerchars[i].x=CCx+((i-5)*80)
		trackerchars[i].y=tracker.y+50
		kg:insert(trackerchars[i])
	end
	Keyboard.trackerchars=trackerchars
	
	local backdrop=ui.CreateWindow(1000,310,1)
	backdrop.y=570
	kg:insert(backdrop)
	
	for i=1,10 do
		local warever=table.maxn(letters)+1
		
		letters[warever] =  widget.newButton{
			label=alphabet[warever],
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=60,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=80, height=80,
			onRelease = function()
				Keyboard:addToName(letters[warever]:getLabel())
			end
		}
		letters[warever].x = CCx+(((i-0.5)-5)*90)
		letters[warever].y = letters["Y1"]
		letters[warever]:setFillColor(0.4,0.4,1)
		kg:insert(letters[warever])
	end
	
	for i=1,9 do
		local warever=table.maxn(letters)+1
		
		letters[warever] =  widget.newButton{
			label=alphabet[warever],
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=60,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=80, height=80,
			onRelease = function()
				Keyboard:addToName(letters[warever]:getLabel())
			end
		}
		letters[warever].x = CCx+((i-5)*90)
		letters[warever].y = letters["Y2"]
		letters[warever]:setFillColor(0.4,0.4,1)
		kg:insert(letters[warever])
	end
	
	for i=1,7 do
		local warever=table.maxn(letters)+1
		
		letters[warever] =  widget.newButton{
			label=alphabet[warever],
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=60,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=80, height=80,
			onRelease = function()
				Keyboard:addToName(letters[warever]:getLabel())
			end
		}
		letters[warever].x = CCx+((i-4)*90)
		letters[warever].y = letters["Y3"]
		letters[warever]:setFillColor(0.4,0.4,1)
		kg:insert(letters[warever])
	end
	
	Keyboard.letters=letters
	
	local shiftbtn =  widget.newButton{
		label="Shift",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = Keyboard.Shift
	}
	shiftbtn.x = 110
	shiftbtn.y = letters["Y3"]
	shiftbtn:setFillColor(0.4,0.4,1)
	kg:insert(shiftbtn)
	
	local shiftbtn2 =  widget.newButton{
		label="Shift",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = Keyboard.Shift
	}
	shiftbtn2.x = display.contentWidth-110
	shiftbtn2.y = letters["Y3"]
	shiftbtn2:setFillColor(0.4,0.4,1)
	kg:insert(shiftbtn2)
	
	local deletebtn =  widget.newButton{
		label="Delete",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = Keyboard.delete
	}
	deletebtn.x = 580
	deletebtn.y = 330
	deletebtn:setFillColor(0.5,0.5,0.5)
	kg:insert(deletebtn)
	
	local endbtn =  widget.newButton{
		label="End",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = function()
			Keyboard:clear()
			game.Initial:create( SaveGame["SLOT"],Keyboard:consolidate() )
		end
	}
	endbtn.x = 900
	endbtn.y = 330
	endbtn:setFillColor(0.4,1,0.4)
	kg:insert(endbtn)
	
	local backbtn =  widget.newButton{
		label="Back",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = function()
			Keyboard:clear()
			SaveGame:show()
		end
	}
	backbtn.x = 160
	backbtn.y = 330
	backbtn:setFillColor(1,0.2,0.2)
	kg:insert(backbtn)
	
	Keyboard:Shift()
end

function Keyboard:consolidate()
	local str=""
	for i=1,table.maxn(Keyboard.trackerchars) do
		if Keyboard.trackerchars[i].text~="__" then
			str=str..Keyboard.trackerchars[i].text
		end
	end
	return str
end

function Keyboard:Shift()
	local letters=Keyboard.letters
	if letters[1]:getLabel()=="q" then
		for i=1,table.maxn(letters) do
			letters[i]:setLabel(string.upper( letters[i]:getLabel() ))
		end
	elseif letters[1]:getLabel()=="Q" then
		for i=1,table.maxn(letters) do
			letters[i]:setLabel(string.lower( letters[i]:getLabel() ))
		end
	end
end

function Keyboard:getTrackerCount()
	local trackerchars=Keyboard.trackerchars
	local trackercount=false
	local counter=1
	while (counter<=table.maxn(trackerchars)) and trackercount==false do
		if trackerchars[counter].text=="__" then
			trackercount=counter
		end
		counter=counter+1
	end
	if trackercount==false then
		trackercount=table.maxn(trackerchars)
	end
	return trackercount
end

function Keyboard:delete()
	local trackercount=Keyboard:getTrackerCount()
	local trackerchars=Keyboard.trackerchars
	trackercount=trackercount-1
	if trackercount>=1 then
		trackerchars[trackercount].text="__"
	end
	if trackercount==1 then
		Keyboard:Shift()
	end
	Keyboard.trackerchars=trackerchars
end

function Keyboard:addToName(var)
	local trackercount=Keyboard:getTrackerCount()
	local trackerchars=Keyboard.trackerchars
	local letters=Keyboard.letters
	if trackercount<=table.maxn(trackerchars) then
		trackerchars[trackercount].text=var
		trackercount=trackercount+1
		if letters[1]:getLabel()=="Q" then
			Keyboard:Shift()
		end
	end
	Keyboard.trackerchars=trackerchars
end

function Keyboard:clear()
	for i=kg.numChildren,1,-1 do
		local child = kg[i]
		kg.parent:remove( child )
		display.remove( child )
	end
	kg=nil
end



---------------------------------------------------------------------------------------
-- OPTIONS
---------------------------------------------------------------------------------------

local og
Options={}
-- local Sound
-- local Music
-- local Back

function Options:show()

	og=display.newGroup()
	
	local title=display.newText("Options",0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	og:insert(title)
	
	local BackBtn =  widget.newButton{
		label="Back",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=290, height=90,
		onRelease = function()
			Options:clear()
			MainMenu:show()
		end
	}
	BackBtn:setFillColor(1.0,0,0)
	BackBtn.x = display.contentWidth*0.5
	BackBtn.y = display.contentHeight-100
	og:insert(BackBtn)
	
	local scroll={}
	local colors={{0.6,0.2,1.0,"Master"},{0.2,1.0,0.6,"Music"},{0.6,1.0,0.2,"Sound"}}
	for i=1,3 do
		scroll[i]=ui.CreateWindow(650,60)
		scroll[i].x=display.contentCenterX
		scroll[i].y=display.contentCenterY-150+(150*(i-1))
		scroll[i].deltaX=scroll[i].width*0.8
		scroll[i]:setFillColor(colors[i][1],colors[i][2],colors[i][3])
		local mask = graphics.newMask( "ui/rectmask.png" )
		scroll[i]:setMask(mask)
		scroll[i].maskX=0
		scroll[i].maskScaleX=13
		scroll[i].movePercent=function( event )
			local lowX=scroll[i].x-(scroll[i].deltaX/2)
			local hiX=scroll[i].x+(scroll[i].deltaX/2)
			if (event.x>lowX) and (event.x<hiX) then
				scroll[i]["ind"].x=event.x
				
				function round2(num, idp)
					return tonumber(string.format("%." .. (idp or 0) .. "f", num))
				end
				scroll[i]["ind"].rawpercent=((event.x-lowX)/scroll[i].deltaX)
				scroll[i]["ind"].percent=round2(scroll[i]["ind"].rawpercent,1)
				
				
				local text=(colors[i][4].." Volume: "..(scroll[i]["ind"].percent*100).."%")
				scroll[i]["label"]["text"]=text
			end
		end
		scroll[i]:addEventListener("touch",scroll[i].movePercent)
		og:insert(scroll[i])
		
		
		scroll[i]["ind"]=ui.CreateWindow(60,125)
		scroll[i]["ind"].x=scroll[i].x
		scroll[i]["ind"].y=scroll[i].y
		scroll[i]["ind"].percent=0.5
		scroll[i]["ind"]:setFillColor(colors[i][1]+0.3,colors[i][2]+0.3,colors[i][3]+0.3)
		og:insert(scroll[i]["ind"])
		
		local text=(colors[i][4].." Volume: "..(scroll[i]["ind"].percent*100).."%")
		scroll[i]["label"]=display.newText(text,0,0,"MoolBoran",70)
		scroll[i]["label"].x=scroll[i].x
		scroll[i]["label"].y=scroll[i].y+15
		scroll[i]["label"].percent=0.5
		og:insert(scroll[i]["label"])
		
		scroll[i]["ind"]:toFront()
	end
end

function Options:clear()
	for i=og.numChildren,1,-1 do
		local child = og[i]
		og.parent:remove( child )
		display.remove( child )
	end
	og=nil
end

--[[
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
--]]



---------------------------------------------------------------------------------------
-- CREDITS
---------------------------------------------------------------------------------------

function Credits( event )
	if event.phase=="ended" then
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
	end
end

function Credone()
	Runtime:addEventListener("tap",show)
end
