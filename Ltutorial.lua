-----------------------------------------------------------------------------------------
--
-- Tutorial.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local p=require("Lplayers")
local interfaceb
local Narrator

function FromTheTop()
	interfaceb = display.newImageRect("BlackUI.png", 768, 239)
	interfaceb.x, interfaceb.y = 384, 912
	timer.performWithDelay(500,First)
end

function First()
	Narrator=display.newText("Hello there! Welcome to the Dungeons of Gal'Darah.",0, 800,"Game Over",100)
	local textMessage = display.newText( "Hello Corona User!nHope you're having a great day.", 25, 25, "Helvetica", 18 )
	local multiText = display.newText( "This text should be wrapped according to the specified width.", 25, 25, 175, 400, "Helvetica", 18 )
	timer.performWithDelay(1500,Second)
end

function Second()
	display.remove(Narrator)
	p.CreatePlayers("tutorial")
	Narrator=display.newText(
	"This is your guy. Your character. If you don't like how he looks, you can customize it in the Options menu, but not right now",
	0, 800,"Game Over",100)
	
	timer.performWithDelay(1500,Third)
end

function Third()
	display.remove(Narrator)
end