-----------------------------------------------------------------------------------------
--
-- Character Customization.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local o=require("LOptions")
local a=require("LAudio")
local widget = require "widget"
local charname
local charclass
local charmenu
local classmenu
local currentchar
local curmenu

function onLunRelease()
	charname=0
	Classes()
	CurrentChar()
end

function onArcRelease()
	charname=1
	Classes()
	CurrentChar()
end

function onRefRelease()
	charname=2
	Classes()
	CurrentChar()
end

function onIngRelease()
	charname=3
	Classes()	
	CurrentChar()
end

function onKnightRelease()
	charclass=0
	CurrentChar()
end

function onWarriorRelease()
	charclass=1
	CurrentChar()
end

function onThiefRelease()
	charclass=2
	CurrentChar()
end

function onVikingRelease()
	charclass=3
	CurrentChar()
end

function onSorcerorRelease()
	charclass=4
	CurrentChar()
end

function onScholarRelease()
	charclass=5
	CurrentChar()
end

function CharMenu()
	if (charclass) then
		Classes()
	CurrentChar()
	end
	if not (charmenu) then
		charmenu=display.newGroup()
	end
	for i=charmenu.numChildren,1,-1 do
		local child = charmenu[i]
		child.parent:remove( child )
	end
	
	local background = display.newImageRect( "bkgs/bkgchar.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	charmenu:insert(background)
	
	local Luneth1=display.newImageRect("chars/0/char.png",65,65)
	Luneth1.x = display.contentWidth*0.2
	Luneth1.y = display.contentHeight*0.3
	charmenu:insert(Luneth1)
	
	local Luneth = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onLunRelease
	}
	Luneth:setReferencePoint( display.CenterReferencePoint )
	Luneth.x = display.contentWidth*0.2
	Luneth.y = display.contentHeight*0.3
	charmenu:insert(Luneth)
	
	local Refia1=display.newImageRect("chars/2/char.png",65,65)
	Refia1.x = display.contentWidth*0.4
	Refia1.y = display.contentHeight*0.3
	charmenu:insert(Refia1)
	
	local Refia = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onRefRelease
	}
	Refia:setReferencePoint( display.CenterReferencePoint )
	Refia.x = display.contentWidth*0.4
	Refia.y = display.contentHeight*0.3
	charmenu:insert(Refia)
	
	local Arc1=display.newImageRect("chars/1/char.png",65,65)
	Arc1.x = display.contentWidth*0.6
	Arc1.y = display.contentHeight*0.3
	charmenu:insert(Arc1)
	
	local Arc = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onArcRelease
	}
	Arc:setReferencePoint( display.CenterReferencePoint )
	Arc.x = display.contentWidth*0.6
	Arc.y = display.contentHeight*0.3
	charmenu:insert(Arc)
	
	local Ingus1=display.newImageRect("chars/3/char.png",65,65)
	Ingus1.x = display.contentWidth*0.8
	Ingus1.y = display.contentHeight*0.3
	charmenu:insert(Ingus1)
	
	local Ingus = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onIngRelease
	}
	Ingus:setReferencePoint( display.CenterReferencePoint )
	Ingus.x = display.contentWidth*0.8
	Ingus.y = display.contentHeight*0.3
	charmenu:insert(Ingus)
	
	local Back = widget.newButton{
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
	Back.y = display.contentHeight-120
	charmenu:insert(Back)

end

function Classes()
	if not (classmenu) then
		classmenu=display.newGroup()
	end
	for i=classmenu.numChildren,1,-1 do
		local child = classmenu[i]
		child.parent:remove( child )
	end
	
	--Viking
	local Viktxt=display.newText("Viking\n+STA", 0, 0, "Game Over", 80)
	Viktxt.x = (display.contentWidth/7)*1
	Viktxt.y = display.contentHeight*0.4+80
	classmenu:insert(Viktxt)
	
	local Viking1=display.newImageRect("chars/"..charname.."/3/char.png",65,65)
	Viking1.x = Viktxt.x
	Viking1.y = Viktxt.y-80
	classmenu:insert(Viking1)
	
	local Viking = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onVikingRelease
	}
	Viking:setReferencePoint( display.CenterReferencePoint )
	Viking.x = Viking1.x
	Viking.y = Viking1.y
	classmenu:insert(Viking)
	
	--Warrior
	local Wartxt=display.newText("Warrior\n+ATT", 0, 0, "Game Over", 80)
	Wartxt.x = (display.contentWidth/7)*2
	Wartxt.y = display.contentHeight*0.4+80
	classmenu:insert(Wartxt)
	
	local Warrior1=display.newImageRect("chars/"..charname.."/1/char.png",65,65)
	Warrior1.x = Wartxt.x
	Warrior1.y = Wartxt.y-80
	classmenu:insert(Warrior1)
	
	local Warrior = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onWarriorRelease
	}
	Warrior:setReferencePoint( display.CenterReferencePoint )
	Warrior.x = Warrior1.x
	Warrior.y = Warrior1.y
	classmenu:insert(Warrior)
	
	--Knight
	local Knitxt=display.newText("Knight\n+DEF", 0, 0, "Game Over", 80)
	Knitxt.x = (display.contentWidth/7)*3
	Knitxt.y = display.contentHeight*0.4+80
	classmenu:insert(Knitxt)
	
	local Knight1=display.newImageRect("chars/"..charname.."/0/char.png",65,65)
	Knight1.x = Knitxt.x
	Knight1.y = Knitxt.y-80
	classmenu:insert(Knight1)
	
	local Knight = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onKnightRelease
	}
	Knight:setReferencePoint( display.CenterReferencePoint )
	Knight.x = Knight1.x
	Knight.y = Knight1.y
	classmenu:insert(Knight)
	
	--Thief
	local Thitxt=display.newText("Thief\n+DEX", 0, 0, "Game Over", 80)
	Thitxt.x = (display.contentWidth/7)*5
	Thitxt.y = display.contentHeight*0.4+80
	classmenu:insert(Thitxt)
	
	local Thief1=display.newImageRect("chars/"..charname.."/2/char.png",65,65)
	Thief1.x = Thitxt.x
	Thief1.y = Thitxt.y-80
	classmenu:insert(Thief1)
	
	local Thief = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onThiefRelease
	}
	Thief:setReferencePoint( display.CenterReferencePoint )
	Thief.x = Thief1.x
	Thief.y = Thief1.y
	classmenu:insert(Thief)
	
	--Sorceror
	local Sortxt=display.newText("Sorceror\n+MGC", 0, 0, "Game Over", 80)
	Sortxt.x = (display.contentWidth/7)*4
	Sortxt.y = display.contentHeight*0.4+80
	classmenu:insert(Sortxt)
	
	local Sorceror1=display.newImageRect("chars/"..charname.."/4/char.png",65,65)
	Sorceror1.x = Sortxt.x
	Sorceror1.y = Sortxt.y-80
	classmenu:insert(Sorceror1)
	
	local Sorceror = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onSorcerorRelease
	}
	Sorceror:setReferencePoint( display.CenterReferencePoint )
	Sorceror.x = Sorceror1.x
	Sorceror.y = Sorceror1.y
	classmenu:insert(Sorceror)
	
	--Scholar
	local Schtxt=display.newText("Scholar\n+INT", 0, 0, "Game Over", 80)
	Schtxt.x = (display.contentWidth/7)*6
	Schtxt.y = display.contentHeight*0.4+80
	classmenu:insert(Schtxt)
	
	local Scholar1=display.newImageRect("chars/"..charname.."/5/char.png",65,65)
	Scholar1.x = Schtxt.x
	Scholar1.y = Schtxt.y-80
	classmenu:insert(Scholar1)
	
	local Scholar = widget.newButton{
		label="",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="charbutton.png",
		overFile="charbutton-over.png",
		width=80, height=80,
		onRelease = onScholarRelease
	}
	Scholar:setReferencePoint( display.CenterReferencePoint )
	Scholar.x = Scholar1.x
	Scholar.y = Scholar1.y
	classmenu:insert(Scholar)
	
end

function CurrentChar()
	if not (curmenu) then
		curmenu=display.newGroup()
	end
	for i=curmenu.numChildren,1,-1 do
		local child = curmenu[i]
		child.parent:remove( child )
	end
	if not (charname) then
		charname=0
	end
	if not (charclass) then
		charclass=0
	end
	
	local char=display.newText("Current Character:", 0, 0, "Game Over", 100)
	char.x = display.contentWidth*0.5
	char.y = display.contentHeight*0.5+60
	curmenu:insert(char)
	
	currentchar=display.newImageRect( "chars/"..charname.."/"..charclass.."/char.png", 76 ,76)
	currentchar.strokeWidth = 4
	currentchar:setStrokeColor(50, 50, 255)
	currentchar.x, currentchar.y = char.x,char.y+80
	curmenu:insert(currentchar)
end

function GetCharInfo(field)	
	if field==0 then
		return charname
	end
	if field==1 then
		return charclass
	end
end

function onBackRelease()
	
	if (charmenu) then
		for i=charmenu.numChildren,1,-1 do
			local child = charmenu[i]
			child.parent:remove( child )
		end
	end
	if (classmenu) then
		for i=classmenu.numChildren,1,-1 do
			local child = classmenu[i]
			child.parent:remove( child )
		end
	end
	if (curmenu) then
		for i=curmenu.numChildren,1,-1 do
			local child = curmenu[i]
			child.parent:remove( child )
		end
	end
	o.DisplayOptions()
	return true	
end
