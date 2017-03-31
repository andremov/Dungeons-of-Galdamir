---------------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)

-- FORWARD CALLS
local shSuffix="RLSE"
local loSuffix="RELEASE"
local verNum="1.3.0"
-- local runes={}
-- local runegroup=display.newGroup()
-- local words={"love", "hate", "dragon", "mystery", "quest", "penis", "skill", "adventure", "death", "betrayal", "vengeance", "fuck"}
-- local numofwords=30


---------------------------------------------------------------------------------------
-- GLOBAL
---------------------------------------------------------------------------------------

local function getWord()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local textword=words[math.random(1,table.maxn(words))]
	local textx=math.random(50,700)
	local texty=math.random(50,1000)
	local textsize=math.random(5,10)*10
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if (runes[numofwords]) then
	else
		runes[numofwords]=display.newText(textword,textx,texty,"Runes of Galdamir",textsize)
		runes[numofwords].color={1,1,1,0.5}
		runes[numofwords].process=0
		runes[numofwords]:toBack()
		runes[numofwords]:setFillColor(unpack(runes[numofwords].color) )
		
		local function destroyRunes( rune )
			display.remove(rune)
			rune=nil
		end
		
		transition.to( runes[numofwords], { time=1500, alpha=0, onComplete=destroyRunes } )
		
		runegroup:insert(runes[numofwords])
		if runes[numofwords].x>display.contentCenterX then
			-- runes are to the left
			transition.to( runes[numofwords], { time=3000, x=-200 } )
			-- runes[numofwords].direction=-1
		else
			-- runes are to the right
			transition.to( runes[numofwords], { time=3000, x=display.contentCenterX+200 } )
			-- runes[numofwords].direction=1
		end
	end
	numofwords=numofwords-1
	if numofwords==0 then
		numofwords=30
	end
	
	-- # CLOSING
	timer.performWithDelay(500,getWord)
end

local function Glow()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for i in pairs (runes) do
		if runes[i].colors[2]<=0 then
			runes[i].process=1
		elseif runes[i].colors[2]>=1 then
			runes[i].process=0
		end
		if runes[i].process==0 then
			runes[i].colors[2]=runes[i].colors[2]-.25
			runes[i].colors[1]=runes[i].colors[1]+.5
			runes[i].colors[3]=runes[i].colors[3]+.55
		else
			runes[i].colors[2]=runes[i].colors[2]+.25
			runes[i].colors[1]=runes[i].colors[1]+.5
			runes[i].colors[3]=runes[i].colors[3]+.5
		end
		runes[i]:setFillColor(unpack(runes[i].color) )
	end
	
	-- # CLOSING
	runegroup:toBack()
	timer.performWithDelay(100,Glow)
end



---------------------------------------------------------------------------------------
-- MAIN MENU
---------------------------------------------------------------------------------------

local mmg
MainMenu={}

function MainMenu:show()
	-- # OPENING
	-- DEPENDENCIES
	local ui=require("lua.ui")
	local widget = require "widget"
	-- FORWARD CALLS
	mmg=display.newGroup()
	local bkg
	local title1
	local title2
	local title3
	local PlayBtn
	local OptnBtn
	local logo
	-- LOCAL FUNCTIONS
	local function onPlayBtn()
		MainMenu:clear()
		SaveGame:show()
	end
	local function onOptionsBtn()
		MainMenu:clear()
		Options:show()
	end
	
	-- # BODY
	bkg=ui.CreateWindow(660,280,3)
	bkg.y = 150
	bkg:setFillColor(0.2,0.2,1)
	mmg:insert(bkg)
	
	title1 = display.newImageRect( "ui/DUNGEONS.png", 605, 109 )
	title1.x = display.contentWidth * 0.5
	title1.y = 80
	title1:setFillColor(0.8,0.2,0.2)
	mmg:insert(title1)
	
	title2 = display.newImageRect( "ui/GALDAMIR.png", 618, 109 )
	title2.x = display.contentWidth * 0.5
	title2.y = 220
	title2:setFillColor(0.8,0.2,0.2)
	mmg:insert(title2)
	
	title3 = display.newImageRect( "ui/of.png", 450, 106 )
	title3.x = display.contentWidth * 0.5
	title3.y = 150
	mmg:insert(title3)
	
	PlayBtn =  widget.newButton{
		label="Play",
		font="MoolBoran",
		fontSize=80,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=350, height=150,
		onRelease = onPlayBtn
	}
	PlayBtn:setFillColor(0.6,1.0,0.6)
	PlayBtn.x = display.contentWidth*0.25
	PlayBtn.y = display.contentCenterY+40
	mmg:insert(PlayBtn)
	
	OptnBtn =  widget.newButton{
		label="Options",
		font="MoolBoran",
		fontSize=80,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=350, height=150,
		onRelease = onOptionsBtn
	}
	OptnBtn.x = display.contentWidth*0.75
	OptnBtn.y = PlayBtn.y
	mmg:insert(OptnBtn)
	
	logo=display.newImageRect("ui/Logo Gris.png",641,538)
	logo.xScale=0.3
	logo.yScale=logo.xScale
	logo.x=display.contentCenterX
	logo.y=display.contentHeight-130
	-- logo:addEventListener("touch",Credits)
	mmg:insert(logo)
	
	-- Splash=s.GetSplash()
	-- group:insert(Splash)
	-- # CLOSING
end

function MainMenu:clear()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for i=mmg.numChildren,1,-1 do
		local child = mmg[i]
		mmg.parent:remove( child )
		display.remove( child )
	end
	mmg=nil
	
	-- # CLOSING
end



---------------------------------------------------------------------------------------
-- SAVE GAME
---------------------------------------------------------------------------------------

local sgg
local slotg
SaveGame={}

function SaveGame:show()
	-- # OPENING
	-- DEPENDENCIES
	local slot=require("lua.slot")
	local widget = require "widget"
	-- FORWARD CALLS
	sgg=display.newGroup()
	local title
	local SlotBtn
	-- LOCAL FUNCTIONS
	local function onSlotBtn( event )
		for a=1,3 do
			SlotBtn[a]:setFillColor(0.1,0.5,0.1)
		end
		SlotBtn[event.target.info.id]:setFillColor(0.5,1.0,0.5)
		SaveGame:slotClear()
		SaveGame["SLOT"]=event.target.info.id
		SaveGame["NAME"]=event.target.info.name
		SaveGame:slotInfo()
	end
	local function onBackBtn()
		SaveGame:clear()
		MainMenu:show()
	end
	
	-- # BODY
	title=display.newText("Save Game",0,0,"MoolBoran",100)
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
	
	SlotBtn={}
	
	for btn=1,3 do
		local name=slot.Load:getName(btn) or "No Data"
		SlotBtn[btn] =  widget.newButton{
			label=name,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=70,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=350, height=130,
			onRelease = onSlotBtn
		}
		SlotBtn[btn].x = 200
		SlotBtn[btn].y = (title.y+110)+(140*(btn-1))
		SlotBtn[btn]:setFillColor(0.5,1.0,0.5)
		SlotBtn[btn].info={name=name,id=btn}
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
		onRelease = onBackBtn
	}
	BackBtn.x = 200
	BackBtn.y = display.contentHeight-100
	BackBtn:setFillColor(1.0,0.4,0.4)
	sgg:insert(BackBtn)
	
	-- # CLOSING
end

function SaveGame:slotInfo()
	-- # OPENING
	-- DEPENDENCIES
	local slot=require("lua.slot")
	local ui=require("lua.ui")
	local widget = require "widget"
	-- FORWARD CALLS
	slotg=display.newGroup()
	local gold
	local level
	local bkg
	local name
	local playlabel
	local brandnewtext1
	local brandnewtext2
	local playervisual
	local leveldisplay1
	local leveldisplay2
	local golddisplay1
	local golddisplay2
	local DeleteBtn
	local PlayBtn
	-- LOCAL FUNCTIONS
	local function onDeleteBtn()
		SaveGame:deleteSlot(slot)
		SaveGame:refresh()
	end
	
	-- # BODY
	bkg=ui.CreateWindow(590,620,2)
	bkg.x=display.contentCenterX+180
	bkg.y=display.contentCenterY+30
	bkg:setFillColor( 0.91, 0.67, 0.33 )
	slotg:insert(bkg)
	
	name=display.newText(SaveGame["NAME"],0,0,"MoolBoran",100)
	name.x = bkg.x
	name.y = bkg.y-225
	slotg:insert(name)
	
	if (SaveGame["NAME"]=="No Data") then
		playlabel="New Game"
		
		brandnewtext1=display.newText("Start a brand",0,0,"MoolBoran",70)
		brandnewtext1.x = bkg.x
		brandnewtext1.y = bkg.y-30
		slotg:insert(brandnewtext1)
		
		brandnewtext2=display.newText("new adventure!",0,0,"MoolBoran",70)
		brandnewtext2.x = brandnewtext1.x
		brandnewtext2.y = brandnewtext1.y+45
		slotg:insert(brandnewtext2)
	else
		playlabel="Load Game"
		
		gold, level=slot.Load:getExtraInfo(SaveGame["SLOT"])
		gold=gold or 0
		level=level or 0
	
		playervisual=display.newImage( "Save"..SaveGame["SLOT"]..".png", system.DocumentsDirectory)
		playervisual.x=display.contentWidth-120
		playervisual.y=bkg.y+70
		playervisual.xScale=0.75
		playervisual.yScale=0.75
		slotg:insert(playervisual)
	
		leveldisplay1=display.newText("Level:",0,0,"MoolBoran",70)
		leveldisplay1.x = bkg.x-175
		leveldisplay1.y = bkg.y-120
		slotg:insert(leveldisplay1)
		
		leveldisplay2=display.newText(level,0,0,"MoolBoran",80)
		leveldisplay2.x = leveldisplay1.x+110
		leveldisplay2.y = leveldisplay1.y+45
		leveldisplay2.anchorX=1.0
		leveldisplay2:setFillColor(0.6,1,0.6)
		slotg:insert(leveldisplay2)
		
		golddisplay1=display.newText("Gold:",0,0,"MoolBoran",70)
		golddisplay1.x = leveldisplay1.x
		golddisplay1.y = bkg.y+50
		slotg:insert(golddisplay1)
		
		golddisplay2=display.newText(gold,0,0,"MoolBoran",80)
		golddisplay2.x = leveldisplay2.x
		golddisplay2.y = golddisplay1.y+45
		golddisplay2:setFillColor(1,1,0.6)
		golddisplay2.anchorX=1.0
		slotg:insert(golddisplay2)
		
		DeleteBtn =  widget.newButton{
			label="Delete",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=60,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=200, height=100,
			onRelease = onDeleteBtn
		}
		DeleteBtn.x = name.x-150
		DeleteBtn.y = bkg.y+225
		DeleteBtn:setFillColor(1,0,0)
		slotg:insert(DeleteBtn)
	end
	
	PlayBtn =  widget.newButton{
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
	
	-- # CLOSING
end

function SaveGame:loadSlot()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	SaveGame:clear()
	if ( SaveGame["NAME"]=="No Data" ) then
		-- Keyboard:show()
		print "KEYBOARD BYPASSED"
		local game=require("lua.game")
		game.Initial:create(SaveGame["SLOT"])
	else
		game.Initial:create(SaveGame["SLOT"])
	end
	
	-- # CLOSING
end

function SaveGame:deleteSlot()
	-- # OPENING
	-- DEPENDENCIES
	local slot=require("lua.slot")
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	slot.Erase:clearSave(SaveGame["SLOT"])
	
	-- # CLOSING
end

function SaveGame:refresh()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	SaveGame:clear()
	SaveGame:show()
	
	-- # CLOSING
end

function SaveGame:slotClear()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if (slotg) then
		for i=slotg.numChildren,1,-1 do
			local child = slotg[i]
			slotg.parent:remove( child )
			display.remove( child )
		end
		slotg=nil
	end
	
	-- # CLOSING
end

function SaveGame:clear()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	SaveGame:slotClear()
	for i=sgg.numChildren,1,-1 do
		local child = sgg[i]
		sgg.parent:remove( child )
		display.remove( child )
	end
	sgg=nil
	
	-- # CLOSING
end



---------------------------------------------------------------------------------------
-- KEYBOARD
---------------------------------------------------------------------------------------

local kg
Keyboard={}
Keyboard.letters={}
Keyboard.trackerchars={}

function Keyboard:show()
	-- # OPENING
	-- DEPENDENCIES
	local ui=require("lua.ui")
	local game=require("lua.game")
	local widget = require "widget"
	-- FORWARD CALLS
	kg=display.newGroup()
	local alphabet
	local tracker
	local CCx
	local trackerchars
	local backdrop
	local counter
	local shiftBtn1
	local shiftBtn2
	local backspaceBtn
	local endBtn
	local backBtn
	-- LOCAL FUNCTIONS
	local function onLetterBtn( event )
		Keyboard:addToName(event.target.info)
	end
	local function onEndBtn()
		Keyboard:clear()
		game.Initial:create( SaveGame["SLOT"],Keyboard:consolidate() )
	end
	local function onBackBtn()
		Keyboard:clear()
		SaveGame:show()
	end
	-- # BODY
	
	alphabet={"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"}
	letters={}
	letters["Y1"]=490
	letters["Y2"]=letters["Y1"]+90
	letters["Y3"]=letters["Y2"]+90
	
	-- local trackercount=1
	tracker=ui.CreateWindow(890,170,1)
	tracker.y=150
	tracker:setFillColor(0.85, 0.64, 0.12)
	kg:insert(tracker)
	CCx=display.contentCenterX
	
	trackerchars={}
	for i=1,9 do
		trackerchars[i]=display.newText("__",0,0,"MoolBoran",120)
		trackerchars[i].x=CCx+((i-5)*80)
		trackerchars[i].y=tracker.y+50
		kg:insert(trackerchars[i])
	end
	Keyboard.trackerchars=trackerchars
	
	backdrop=ui.CreateWindow(1000,310,1)
	backdrop.y=570
	kg:insert(backdrop)
	
	for i=1,10 do
		counter=table.maxn(letters)+1
		
		letters[counter] =  widget.newButton{
			label=alphabet[counter],
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=60,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=80, height=80,
			onRelease = onLetterBtn
		}
		letters[counter].x = CCx+(((i-0.5)-5)*90)
		letters[counter].y = letters["Y1"]
		letters[counter].info=alphabet[counter]
		letters[counter]:setFillColor(0.4,0.4,1)
		kg:insert(letters[counter])
	end
	
	for i=1,9 do
		counter=table.maxn(letters)+1
		
		letters[counter] =  widget.newButton{
			label=alphabet[counter],
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=60,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=80, height=80,
			onRelease = onLetterBtn
		}
		letters[counter].x = CCx+((i-5)*90)
		letters[counter].y = letters["Y2"]
		letters[counter]:setFillColor(0.4,0.4,1)
		kg:insert(letters[counter])
	end
	
	for i=1,7 do
		counter=table.maxn(letters)+1
		
		letters[counter] =  widget.newButton{
			label=alphabet[counter],
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=60,
			labelYOffset=10,
			defaultFile="ui/button.png",
			overFile="ui/button_hold.png",
			width=80, height=80,
			onRelease = onLetterBtn
		}
		letters[counter].x = CCx+((i-4)*90)
		letters[counter].y = letters["Y3"]
		letters[counter]:setFillColor(0.4,0.4,1)
		kg:insert(letters[counter])
	end
	
	Keyboard.letters=letters
	
	shiftBtn1 =  widget.newButton{
		label="Shift",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = Keyboard.shiftCase
	}
	shiftBtn1.x = 110
	shiftBtn1.y = letters["Y3"]
	shiftBtn1:setFillColor(0.4,0.4,1)
	kg:insert(shiftBtn1)
	
	shiftBtn2 =  widget.newButton{
		label="Shift",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = Keyboard.shiftCase
	}
	shiftBtn2.x = display.contentWidth-110
	shiftBtn2.y = letters["Y3"]
	shiftBtn2:setFillColor(0.4,0.4,1)
	kg:insert(shiftBtn2)
	
	backspaceBtn =  widget.newButton{
		label="Backspace",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=200, height=80,
		onRelease = Keyboard.backspace
	}
	backspaceBtn.x = 580
	backspaceBtn.y = 330
	backspaceBtn:setFillColor(0.5,0.5,0.5)
	kg:insert(backspaceBtn)
	
	endBtn =  widget.newButton{
		label="End",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = onEndBtn
	}
	endBtn.x = 900
	endBtn.y = 330
	endBtn:setFillColor(0.4,1,0.4)
	kg:insert(endBtn)
	
	backBtn =  widget.newButton{
		label="Back",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=60,
		labelYOffset=10,
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=160, height=80,
		onRelease = onBackBtn
	}
	backBtn.x = 160
	backBtn.y = 330
	backBtn:setFillColor(1,0.2,0.2)
	kg:insert(backBtn)
	
	-- # CLOSING
	Keyboard:shiftCase()
end

function Keyboard:consolidate()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local str
	-- LOCAL FUNCTIONS
	
	-- # BODY
	str=""
	for i=1,table.maxn(Keyboard.trackerchars) do
		if Keyboard.trackerchars[i].text~="__" then
			str=str..Keyboard.trackerchars[i].text
		end
	end
	
	-- # CLOSING
	return str
end

function Keyboard:shiftCase()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local letters
	-- LOCAL FUNCTIONS
	
	-- # BODY
	letters=Keyboard.letters
	if letters[1]:getLabel()=="q" then
		for i=1,table.maxn(letters) do
			letters[i]:setLabel(string.upper( letters[i]:getLabel() ))
		end
	elseif letters[1]:getLabel()=="Q" then
		for i=1,table.maxn(letters) do
			letters[i]:setLabel(string.lower( letters[i]:getLabel() ))
		end
	end
	
	-- # CLOSING
end

function Keyboard:getTrackerCount()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local trackerchars
	local trackercount
	local counter=1
	-- LOCAL FUNCTIONS
	
	-- # BODY
	trackerchars=Keyboard.trackerchars
	trackercount=false
	counter=1
	while (counter<=table.maxn(trackerchars)) and trackercount==false do
		if trackerchars[counter].text=="__" then
			trackercount=counter
		end
		counter=counter+1
	end
	if trackercount==false then
		trackercount=table.maxn(trackerchars)
	end
	
	-- # CLOSING
	return trackercount
end

function Keyboard:backspace()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local trackercount
	local trackerchars
	-- LOCAL FUNCTIONS
	
	-- # BODY
	trackercount=Keyboard:getTrackerCount()
	trackerchars=Keyboard.trackerchars
	trackercount=trackercount-1
	if trackercount>=1 then
		trackerchars[trackercount].text="__"
	end
	if trackercount==1 then
		Keyboard:Shift()
	end
	Keyboard.trackerchars=trackerchars
	
	-- # CLOSING
end

function Keyboard:addToName(var)
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	local trackercount
	local trackerchars
	local letters
	-- LOCAL FUNCTIONS
	
	-- # BODY
	trackercount=Keyboard:getTrackerCount()
	trackerchars=Keyboard.trackerchars
	letters=Keyboard.letters
	if trackercount<=table.maxn(trackerchars) then
		trackerchars[trackercount].text=var
		trackercount=trackercount+1
		if letters[1]:getLabel()=="Q" then
			Keyboard:Shift()
		end
	end
	Keyboard.trackerchars=trackerchars
	
	-- # CLOSING
end

function Keyboard:clear()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for i=kg.numChildren,1,-1 do
		local child = kg[i]
		kg.parent:remove( child )
		display.remove( child )
	end
	kg=nil
	
	-- # CLOSING
end



---------------------------------------------------------------------------------------
-- OPTIONS
---------------------------------------------------------------------------------------

local og
Options={}

function Options:show()
	-- # OPENING
	-- DEPENDENCIES
	local widget = require "widget"
	local ui=require("lua.ui")
	-- FORWARD CALLS
	og=display.newGroup()
	local title
	local BackBtn
	local scroll
	local colors
	local mask
	local text
	-- LOCAL FUNCTIONS
	local function onBackBtn()
		Options:clear()
		MainMenu:show()
	end
	
	-- # BODY
	title=display.newText("Options",0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	og:insert(title)
	
	BackBtn =  widget.newButton{
		label="Back",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="ui/button.png",
		overFile="ui/button_hold.png",
		width=290, height=90,
		onRelease = onBackBtn
	}
	BackBtn:setFillColor(1.0,0,0)
	BackBtn.x = display.contentWidth*0.5
	BackBtn.y = display.contentHeight-100
	og:insert(BackBtn)
	
	scroll={}
	colors={{0.6,0.2,1.0,"Master"},{0.2,1.0,0.6,"Music"},{0.6,1.0,0.2,"Sound"}}
	for i=1,3 do
		scroll[i]=ui.CreateWindow(650,60)
		scroll[i].x=display.contentCenterX
		scroll[i].y=display.contentCenterY-150+(150*(i-1))
		scroll[i].deltaX=scroll[i].width*0.8
		scroll[i]:setFillColor(colors[i][1],colors[i][2],colors[i][3])
		
		mask = graphics.newMask( "ui/rectmask.png" )
		scroll[i]:setMask(mask)
		scroll[i].maskX=0
		scroll[i].maskScaleX=13
		
		scroll[i].movePercent=function( event )
			local lowX=scroll[i].x-(scroll[i].deltaX/2)
			local hiX=scroll[i].x+(scroll[i].deltaX/2)
			if (event.x>lowX) and (event.x<hiX) then
				scroll[i]["ind"].x=event.x
				
				local function round2(num, idp)
					return tonumber(string.format("%." .. (idp or 0) .. "f", num))
				end
				scroll[i]["ind"].rawpercent=((event.x-lowX)/scroll[i].deltaX)
				scroll[i]["ind"].percent=round2(scroll[i]["ind"].rawpercent,1)
				
				
				text=(colors[i][4].." Volume: "..(scroll[i]["ind"].percent*100).."%")
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
		
		text=(colors[i][4].." Volume: "..(scroll[i]["ind"].percent*100).."%")
		scroll[i]["label"]=display.newText(text,0,0,"MoolBoran",70)
		scroll[i]["label"].x=scroll[i].x
		scroll[i]["label"].y=scroll[i].y+15
		scroll[i]["label"].percent=0.5
		og:insert(scroll[i]["label"])
		
		scroll[i]["ind"]:toFront()
	end
	
	-- # CLOSING
end

function Options:clear()
	-- # OPENING
	-- DEPENDENCIES
	-- FORWARD CALLS
	-- LOCAL FUNCTIONS
	
	-- # BODY
	for i=og.numChildren,1,-1 do
		local child = og[i]
		og.parent:remove( child )
		display.remove( child )
	end
	og=nil
	
	-- # CLOSING
end



---------------------------------------------------------------------------------------
-- CREDITS
---------------------------------------------------------------------------------------

--[[
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
		
			TO DO:
				SOUNDS
				- GOLD FREESOUND
				- ROCK FREESOUND
				- GATE FREESOUND
				CHARACTER
				ENEMIES
		
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


]]

