-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
local loadsheet = graphics.newImageSheet( "spriteload.png", { width=50, height=50, numFrames=8 } )
local startup=require("LStartup")
local menu = require("Lmenu")
local widget = require "widget"
local bin = require("Lgarbage")
local v=require("LVersion")
local GVersion=v.HowDoIVersion(false)
local loadbkg
local load1
local loadtxt

	print "C U B 3 D :  DUNGEONS OF GAL'DARAH"
	print ("Version: "..GVersion)
	
	function Go()
		menu.ShowMenu()
	--	startup.Startup()
	--	bin.Font()
	end
	
	function FrontNCenter()
		Loading2:toFront()
	end
	
	function ShowContinue()
		Runtime:removeEventListener("enterFrame",FrontNCenter)
		display.remove( Loading2 )
		menu.ReadySetGo()
	end
	
	Loading2=display.newGroup()
	
	loadbkg = display.newImage("bkgs/bkg_leveldark.png", true)
	loadbkg.x = display.contentWidth/2
	loadbkg.y = display.contentHeight/2
	Loading2:insert( loadbkg )
	
	load1 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load1.x = display.contentWidth-50
	load1.y = display.contentHeight-50
	load1:play()
	Loading2:insert( load1 )
	
	loadtxt = display.newText("Loading...", 0,0,"Game Over",100)
	loadtxt.x = load1.x-150
	loadtxt.y = load1.y
	Loading2:insert( loadtxt )
	
	logo=display.newImageRect("SymbolW.png",240,390)
	logo.x=display.contentWidth/2
	logo.y=display.contentHeight/2
	logo.xScale=1
	logo.yScale=1
	Loading2:insert( logo )
	
	Runtime:addEventListener("enterFrame",FrontNCenter)
	
	timer.performWithDelay(1000, (ShowContinue) )
	
	timer.performWithDelay(500,(Go))
	