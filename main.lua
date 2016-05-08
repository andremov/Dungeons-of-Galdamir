---------------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )
system.setIdleTimer( false )
local menu = require("Lmenu")
local physics = require "physics"
--[[
	local AdBuddiz = require "plugin.adbuddiz"
	AdBuddiz.setAndroidPublisherKey( "6c7e651b-851d-4a9-923d-a557d77d4a6a" )
	AdBuddiz.cacheAds()
	if ( "simulator" == system.getInfo("environment") ) then
		print "!! Engaging AdBuddiz test mode !!"
		AdBuddiz.setTestModeActive()
	end
	
	
	
	DUNGEONS OF GAL'DARAH

	DUNGEONS OF GALDAMIR

	Font1: Monotype Corsiva
	Font2: Game Over
	Font3: Viner Hand ITC
	Font4: Adobe Devanagari
	Font5: MoolBoran
	Font5: Runes of Galdamir

	AdBuddiz:
	6c7e651b-851d-4ab9-923d-a557d77d4a6a
--]]

function fps()
	if (text2) then
		display.remove(text2)
	end
	
	if not (window) then
		window=display.newRect(0,0,80,60)
		window.x=50
		window.y=40
	end
	local frames=system.getTimer()-current
	frames=math.floor(1000/frames)
	
	text2=display.newText(frames,0,0,native.systemFont,70)
	text2.x=window.x
	text2.y=window.y
	text2:setFillColor(0,0,0)
	
	window:toFront()
	text2:toFront()
	
	current=system.getTimer()
end

current=0
Runtime:addEventListener("enterFrame",fps)

--	print "C U B 3 D :  DUNGEONS OF GAL'DARAH"
	print "C U B 3 D :  DUNGEONS OF GALDAMIR"
	physics.start()
	physics.setGravity(0,0)
	
	-- physics.setDrawMode("hybrid")
	
	-- menu.FirstMenu()
	menu.MainMenu:show()
	
	
	