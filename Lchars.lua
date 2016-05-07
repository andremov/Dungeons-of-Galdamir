-----------------------------------------------------------------------------------------
--
-- Character Customization.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local o=require("Loptions")
local a=require("Laudio")
local charname
local charclass
local charmenu
local btns
local imgs
local btns2
local imgs2
local info
local info2
local classmenu
local currentchar
local curmenu
local Classes={"Viking","Warrior","Knight","Sorceror","Thief","Scholar"}
local Stats={"STA","ATT","DEF","MGC","DEX","INT"}
local Chars={"Luneth","Arc","Refia","Ingus"}

function CharChoose( event )
	for i=1,table.maxn(Chars) do
		local x=display.contentWidth*(0.2*i)
		if event.x>x-40 and event.x<x+40 then
			charname=i-1
			ClassMenu()
			CurrentChar()
		end
	end
end

function ClassChoose( event )
	for i=1,table.maxn(Classes) do
		local x=(display.contentWidth/7)*i
		if event.x>x-40 and event.x<x+40 then
			charclass=i-1
			CurrentChar()
		end
	end
end

function CharMenu()
	if (charname) then
		ClassMenu()
	end
	if not (charmenu) then
		charmenu=display.newGroup()
	end
	if not (imgs) then
		imgs={}
	end
	if not (btns) then
		btns={}
	end
	for i=charmenu.numChildren,1,-1 do
		local child = charmenu[i]
		child.parent:remove( child )
	end
	
	for i=1,table.maxn(Chars) do
		imgs[i]=display.newImageRect("chars/"..(i-1).."/char.png",65,65)
		imgs[i].x = display.contentWidth*(0.2*i)
		imgs[i].y = display.contentHeight*0.3
		charmenu:insert(imgs[i])
	
		btns[i] = widget.newButton{
			defaultFile="charbutton.png",
			overFile="charbutton-over.png",
			width=80, height=90,
			onRelease = CharChoose
		}
		btns[i]:setReferencePoint( display.CenterReferencePoint )
		btns[i].x = display.contentWidth*(0.2*i)
		btns[i].y = display.contentHeight*0.3
		charmenu:insert(btns[i])
	end
	
	title=display.newText("Character Customization",0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	title:setTextColor(125,250,125)
	charmenu:insert(title)
	
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
	charmenu:insert(BackBtn)
end

function ClassMenu()
	if (charclass) then
		CurrentChar()
	end
	if not (classmenu) then
		classmenu=display.newGroup()
	end
	if not (imgs2) then
		imgs2={}
	end
	if not (btns2) then
		btns2={}
	end
	if not (info) then
		info={}
	end
	if not (info2) then
		info2={}
	end
	for i=classmenu.numChildren,1,-1 do
		local child = classmenu[i]
		child.parent:remove( child )
	end
	
	for i=1,table.maxn(Classes) do
		info[i]=display.newText((Classes[i]), 0, 0, "MoolBoran", 40)
		info[i].x = (display.contentWidth/7)*i
		info[i].y = display.contentHeight*0.4+80
		classmenu:insert(info[i])
		
		info2[i]=display.newText(("+"..Stats[i]), 0, 0, "MoolBoran", 40)
		info2[i].x = info[i].x
		info2[i].y = info[i].y+42
		classmenu:insert(info2[i])
		
		imgs2[i]=display.newImageRect("chars/"..charname.."/"..(i-1).."/char.png",65,65)
		imgs2[i].x = info[i].x
		imgs2[i].y = info[i].y-80
		classmenu:insert(imgs2[i])
	
		btns2[i] = widget.newButton{
			defaultFile="charbutton.png",
			overFile="charbutton-over.png",
			width=80, height=90,
			onRelease = ClassChoose
		}
		btns2[i]:setReferencePoint( display.CenterReferencePoint )
		btns2[i].x = info[i].x
		btns2[i].y = imgs2[i].y
		classmenu:insert(btns2[i])
	end
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
	
	char=display.newText("Current Character:", 0, 0, "MoolBoran", 70)
	char.x = display.contentCenterX
	char.y = display.contentCenterY+100
	curmenu:insert(char)
	
	currentchar=display.newImageRect( "chars/"..charname.."/"..charclass.."/char.png", 76 ,76)
	currentchar.strokeWidth = 4
	currentchar:setStrokeColor(50, 50, 255)
	currentchar.x, currentchar.y = char.x,char.y+80
	curmenu:insert(currentchar)
	
	curinfo=display.newText((Classes[charclass+1]), 0, 0, "MoolBoran", 40)
	curinfo.x = currentchar.x
	curinfo.y = currentchar.y+80
	curmenu:insert(curinfo)
	
	curinfo2=display.newText(("+"..Stats[charclass+1]), 0, 0, "MoolBoran", 40)
	curinfo2.x = curinfo.x
	curinfo2.y = curinfo.y+45
	curmenu:insert(curinfo2)
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
