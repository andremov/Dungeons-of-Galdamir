-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
system.setIdleTimer( false )
local loadsheet = graphics.newImageSheet( "spriteload.png", { width=50, height=50, numFrames=8 } )
local startup=require("Lstartup")
local menu = require("Lmenu")
local physics = require "physics"
local bin = require("Lgarbage")
local v=require("Lversion")
local lc=require("Llocale")
local GVersion=v.HowDoIVersion(false)
local loadbkg
local load1
local loadtxt
--[[
local AdBuddiz = require "plugin.adbuddiz"
AdBuddiz.setAndroidPublisherKey( "6c7e651b-851d-4ab9-923d-a557d77d4a6a" )
AdBuddiz.cacheAds()
--]]
--	print "C U B 3 D :  DUNGEONS OF GAL'DARAH"
	print "C U B 3 D :  DUNGEONS OF GALDAMIR"
	print ("Version: "..GVersion)
	physics.start()
	physics.setGravity(0,30)
	lc.Load()
	menu.ShowMenu()
	timer.performWithDelay(100,menu.ReadySetGo)
--	startup.Startup()
--	bin.Font()
	
	function AddMe()
		print "Uh-oh."
	end