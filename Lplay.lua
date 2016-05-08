-----------------------------------------------------------------------------------------
--
-- Play.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget=require"widget"
local t=require("Ltutorial")
local su=require("Lstartup")
local sav=require("Lsaving")
local lc=require("Llocale")
local a=require("Laudio")
local m=require("Lmenu")
local pmg

function Display()
	pmg=display.newGroup()
	m.FindMe(1)
	title=display.newText(lc.giveText("LOC029"),0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	title:setTextColor(125,250,125)
	pmg:insert(title)

	TutBtn =  widget.newButton{
		label="Tutorial",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=308, height=90,
		onRelease = onTutBtnRelease
	}
	TutBtn:setReferencePoint( display.CenterReferencePoint )
	TutBtn.x = display.contentWidth*0.5
	TutBtn.y = display.contentHeight*0.3
	pmg:insert(TutBtn)
	
	local saved=sav.CheckSave(1)
	if saved~=false then
		Slot1 =  widget.newButton{
			label=saved,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=308, height=90,
			onRelease = goSlot1
			
		}
		Slot1:setReferencePoint( display.CenterReferencePoint )
		Slot1.x = display.contentWidth*0.5
		Slot1.y = TutBtn.y+110
		pmg:insert(Slot1)
		
		Clean1=  widget.newButton{
			label="X",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="sbutton.png",
			overFile="sbutton-over.png",
			width=90, height=90,
			onRelease = cleanSlot1
			
		}
		Clean1:setReferencePoint( display.CenterReferencePoint )
		Clean1.x = Slot1.x+220
		Clean1.y = Slot1.y
		pmg:insert(Clean1)
	else
		Slot1 =  widget.newButton{
			label="No data",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=308, height=90,
			onRelease = goSlot1
			
		}
		Slot1:setReferencePoint( display.CenterReferencePoint )
		Slot1.x = display.contentWidth*0.5
		Slot1.y = TutBtn.y+110
		pmg:insert(Slot1)
	end
	
	local saved=sav.CheckSave(2)
	if saved~=false then
		Slot2 =  widget.newButton{
			label=saved,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=308, height=90,
			onRelease = goSlot2
			
		}
		Slot2:setReferencePoint( display.CenterReferencePoint )
		Slot2.x = display.contentWidth*0.5
		Slot2.y = Slot1.y+110
		pmg:insert(Slot2)
		
		Clean2=  widget.newButton{
			label="X",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="sbutton.png",
			overFile="sbutton-over.png",
			width=90, height=90,
			onRelease = cleanSlot2
			
		}
		Clean2:setReferencePoint( display.CenterReferencePoint )
		Clean2.x = Slot2.x+220
		Clean2.y = Slot2.y
		pmg:insert(Clean2)
	else
		Slot2 =  widget.newButton{
			label="No data",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=308, height=90,
			onRelease = goSlot2
			
		}
		Slot2:setReferencePoint( display.CenterReferencePoint )
		Slot2.x = display.contentWidth*0.5
		Slot2.y = Slot1.y+110
		pmg:insert(Slot2)
	end
	
	local saved=sav.CheckSave(3)
	if saved~=false then
		Slot3 =  widget.newButton{
			label=saved,
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=308, height=90,
			onRelease = goSlot3
			
		}
		Slot3:setReferencePoint( display.CenterReferencePoint )
		Slot3.x = display.contentWidth*0.5
		Slot3.y = Slot2.y+110
		pmg:insert(Slot3)
		
		Clean3=  widget.newButton{
			label="X",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="sbutton.png",
			overFile="sbutton-over.png",
			width=90, height=90,
			onRelease = cleanSlot3
			
		}
		Clean3:setReferencePoint( display.CenterReferencePoint )
		Clean3.x = Slot3.x+220
		Clean3.y = Slot3.y
		pmg:insert(Clean3)
	else
		Slot3 =  widget.newButton{
			label="No data",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=308, height=90,
			onRelease = goSlot3
			
		}
		Slot3:setReferencePoint( display.CenterReferencePoint )
		Slot3.x = display.contentWidth*0.5
		Slot3.y = Slot2.y+110
		pmg:insert(Slot3)
	end
	
	BackBtn =  widget.newButton{
		label=lc.giveText("LOC008"),
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onBackRelease
	}
	BackBtn:setReferencePoint( display.CenterReferencePoint )
	BackBtn.x = display.contentWidth*0.5
	BackBtn.y = display.contentHeight-100
	pmg:insert(BackBtn)
end

function Refresh()
	for i=pmg.numChildren,1,-1 do
		local child = pmg[i]
		child.parent:remove( child )
	end
	pmg=nil
	Display()
end

function onBackRelease()
	a.Play(12)
	for i=pmg.numChildren,1,-1 do
		local child = pmg[i]
		child.parent:remove( child )
	end
	pmg=nil
	m.ShowMenu()
	timer.performWithDelay(100,m.ReadySetGo)
end

function goSlot1()
	a.Play(12)
	m.FindMe(6)
	local saved=sav.CheckSave(1)
	if saved~=false then
		for i=pmg.numChildren,1,-1 do
			local child = pmg[i]
			child.parent:remove( child )
		end
		pmg=nil
		sav.setSlot(1)
		su.Startup(true)
	else
		for i=pmg.numChildren,1,-1 do
			local child = pmg[i]
			child.parent:remove( child )
		end
		pmg=nil
		sav.setSlot(1)
		timer.performWithDelay(100,Keyboard)
	end
end

function goSlot2()
	a.Play(12)
	m.FindMe(6)
	local saved=sav.CheckSave(2)
	if saved~=false then
		for i=pmg.numChildren,1,-1 do
			local child = pmg[i]
			child.parent:remove( child )
		end
		pmg=nil
		sav.setSlot(2)
		su.Startup(true)
	else
		for i=pmg.numChildren,1,-1 do
			local child = pmg[i]
			child.parent:remove( child )
		end
		pmg=nil
		sav.setSlot(2)
		timer.performWithDelay(100,Keyboard)
	end
end

function goSlot3()
	a.Play(12)
	m.FindMe(6)
	local saved=sav.CheckSave(3)
	if saved~=false then
		for i=pmg.numChildren,1,-1 do
			local child = pmg[i]
			child.parent:remove( child )
		end
		pmg=nil
		sav.setSlot(3)
		su.Startup(true)
	else
		for i=pmg.numChildren,1,-1 do
			local child = pmg[i]
			child.parent:remove( child )
		end
		pmg=nil
		sav.setSlot(3)
		timer.performWithDelay(100,Keyboard)
	end
end

function cleanSlot1()
	a.Play(12)
	sav.WipeSave(1)
	Refresh()
end

function cleanSlot2()
	a.Play(12)
	sav.WipeSave(2)
	Refresh()
end

function cleanSlot3()
	a.Play(12)
	sav.WipeSave(3)
	Refresh()
end

function onTutBtnRelease()
	a.Play(12)
	for i=pmg.numChildren,1,-1 do
		local child = pmg[i]
		child.parent:remove( child )
	end
	pmg=nil
	t.FromTheTop()
end

function Keyboard()
--[[	local letters={
		"A","B","C","D","E","F","G",
		"H","I","J","K","L","M","N",
		"O","P","Q","R","S","T","U",
		"V","W","X","Y","Z",
		"a","b","c","d","e","f","g",
		"h","i","j","k","l","m","n",
		"o","p","q","r","s","t","u",
		"v","w","x","y","z",
	}]]
	local letters1={
		"Q","W","E","R","T","Y","U","I","O","P",
		"A","S","D","F","G","H","J","K","L",
		"Z","X","C","V","B","N","M",
	}
	local letters2={
		"q","w","e","r","t","y","u","i","o","p",
		"a","s","d","f","g","h","j","k","l",
		"z","x","c","v","b","n","m",
	}
	keys={}
	keys2={}
	kbacks={}
	kbacks2={}
	kbrd=display.newGroup()
	UpdateName()
	
	
	title=display.newText(lc.giveText("LOC030"),0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	title:setTextColor(125,250,125)
	kbrd:insert(title)
	
	for i=1,10 do
		keys[i]=display.newText( (letters1[i]) ,0,0,"MoolBoran",110)
		keys[i].x=40+(75*(i-1))
		keys[i].y=((display.contentHeight/2)-120)
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
	
	for i=11,19 do
		local s=i-10
		keys[i]=display.newText( (letters1[i]) ,0,0,"MoolBoran",110)
		keys[i].x=80+(75*(s-1))
		keys[i].y=((display.contentHeight/2)-120)+80
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
	
	for i=20,26 do
		local s=i-19
		keys[i]=display.newText( (letters1[i]) ,0,0,"MoolBoran",110)
		keys[i].x=160+(75*(s-1))
		keys[i].y=((display.contentHeight/2)-120)+160
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
	
	
	for i=1,10 do
		keys2[i]=display.newText( (letters2[i]) ,0,0,"MoolBoran",110)
		keys2[i].x=40+(75*(i-1))
		keys2[i].y=((display.contentHeight/2)+160)
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
	
	for i=11,19 do
		local s=i-10
		keys2[i]=display.newText( (letters2[i]) ,0,0,"MoolBoran",110)
		keys2[i].x=80+(75*(s-1))
		keys2[i].y=((display.contentHeight/2)+160)+80
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
	
	for i=20,26 do
		local s=i-19
		keys2[i]=display.newText( (letters2[i]) ,0,0,"MoolBoran",110)
		keys2[i].x=160+(75*(s-1))
		keys2[i].y=((display.contentHeight/2)+160)+160
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
	
	DelBtn =  widget.newButton{
		label=lc.giveText("LOC031"),
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=216, height=90,
		onRelease = Backspace
	}
	DelBtn:setReferencePoint( display.CenterReferencePoint )
	DelBtn.x = display.contentCenterX
	DelBtn.y = display.contentHeight-55
	kbrd:insert( DelBtn )
	
	EndBtn =  widget.newButton{
		label=lc.giveText("LOC032"),
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=216, height=90,
		onRelease = End
	}
	EndBtn:setReferencePoint( display.CenterReferencePoint )
	EndBtn.x = display.contentWidth-130
	EndBtn.y = display.contentHeight-55
	kbrd:insert( EndBtn )
	
	BackBtn =  widget.newButton{
		label=lc.giveText("LOC008"),
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=216, height=90,
		onRelease = Back2Menu
	}
	BackBtn:setReferencePoint( display.CenterReferencePoint )
	BackBtn.x = 130
	BackBtn.y = display.contentHeight-55
	kbrd:insert( BackBtn )
end

function Back2Menu()
	a.Play(12)
	DelKeyboard()
	Display()
	namedis=nil
	curname=nil
end

function UpdateName()
	if not(namedis) then
		namedis=display.newText((""),0,0,"MoolBoran",120)
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
	a.Play(12)
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
	a.Play(12)
	DelKeyboard()
	su.Startup(curname)
	namedis=nil
	curname=nil
end