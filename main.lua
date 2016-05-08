---------------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )
system.setIdleTimer( false )
local menu = require("Lmenu")
local physics = require "physics"

local performance = require('performance')
performance:newPerformanceMeter()

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

current=0

--	print "C U B 3 D :  DUNGEONS OF GAL'DARAH"
	print "C U B 3 D :  DUNGEONS OF GALDAMIR"
	physics.start()
	physics.setGravity(0,0)
	
	-- physics.setDrawMode("hybrid")
	
	-- menu.FirstMenu()
	menu.MainMenu:show()
	
	
	