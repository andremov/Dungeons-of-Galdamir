-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )
system.setIdleTimer( false )
local menu = require("Lmenu")
local physics = require "physics"
local bin = require("Lgarbage")
-- local AdBuddiz = require "plugin.adbuddiz"
-- AdBuddiz.setAndroidPublisherKey( "6c7e651b-851d-4a9-923d-a557d77d4a6a" )
-- AdBuddiz.cacheAds()
-- if ( "simulator" == system.getInfo("environment") ) then
	-- print "!! Engaging AdBuddiz test mode !!"
	-- AdBuddiz.setTestModeActive()
-- end
--	print "C U B 3 D :  DUNGEONS OF GAL'DARAH"
	print "C U B 3 D :  DUNGEONS OF GALDAMIR"
	physics.start()
	-- physics.setGravity(0,30)
	physics.setGravity(0,0)
	
	-- physics.setDrawMode("hybrid")
	
	menu.FirstMenu()
	menu.ShowMenu()
	
	-- bin.test()
	-- bin.Font()
	