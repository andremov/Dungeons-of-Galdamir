-----------------------------------------------------------------------------------------
--
-- Startup.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local loadsheet = graphics.newImageSheet( "spriteload.png", { width=50, height=50, numFrames=8 } )
local handler=require("Lmaphandler")
local gp=require("Lgold")
local builder=require("Lmapbuilder")
local players=require("Lplayers")
local audio=require("Laudio")
local col=require("Ltileevents")
local com=require("Lcombat")
local ui=require("Lui")
local q=require("Lquest")
local inv=require("Lwindow")
local itm=require("Litems")
local physics = require "physics"
local WD=require("Lprogress")
local m=require("Lmovement")
local sav=require("Lsaving")
local Round
local Loading
local DoStuff
local DoLoad=false

function Startup(val)
	if val~=false then
		print "GAME LOADING..."
		physics.start()
		physics.setGravity(0,30)
		DoStuff=true
	elseif val==false then
		DoStuff=false
	end
	Loading=display.newGroup()
	
	local loadbkg = display.newImage("bkgs/bkg_leveldark.png", true)
	loadbkg.x = display.contentWidth/2
	loadbkg.y = display.contentHeight/2
	Loading:insert( loadbkg )
	
	local load1 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load1.x = display.contentWidth-50
	load1.y = display.contentHeight-50
	load1:play()
	Loading:insert( load1 )
	
	local load2 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load2.x = load1.x-55
	load2.y = load1.y
	load2:play()
	Loading:insert( load2 )
	
	local load3 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load3.x = load2.x+30
	load3.y = load2.y-50
	load3:play()
	Loading:insert( load3 )
	
	local loadtxt = display.newText("Loading...", 0,0,"Game Over",100)
	loadtxt.x = load2.x-150
	loadtxt.y = load1.y
	Loading:insert( loadtxt )
	
	function ShowContinue()
		loadbkg:addEventListener( "touch", Continue )
		Loading:remove( loadtxt )
	
		contxt = display.newText("Tap to continue...", 0,0,"Game Over",100)
		contxt.x = load2.x-200
		contxt.y = load1.y
		Loading:insert( contxt )
	
	end
	if DoStuff==true then
		if val==true then
			function WrapIt()
				Operations()
			end
			timer.performWithDelay(1000, (WrapIt) )
			DoLoad=true
		else
			function WrapIt()
				Operations(val)
			end
			timer.performWithDelay(1000, (WrapIt) )
		end
	end
end

	
function Continue()
	if DoLoad==true then
		DoLoad=false
		timer.performWithDelay(100, (sav.Load) )
		return true
	else
		if DoStuff==true then
			Runtime:addEventListener("enterFrame", gp.GoldDisplay)
		end
		for i=Loading.numChildren,1,-1 do
			if (Loading[i]) then
				display.remove(Loading[i])
				Loading[i]=nil
			end
		end
		Loading=nil
		ui.UI()
		if DoStuff==true then
			ui.Pause(true)
			inv.ToggleInfo()
			audio.Play(3)
			audio.Play(10)
		end
		if DoStuff==false then
			m.ShowArrows()
		end
		return false
	end
end
	
function Operations(name)
	q.Essentials()
	WD.Essentials()
	handler.CallingZones()
	players.CreatePlayers(name)
	gp.Essentials()
--	players.WhosYourDaddy()
	builder.Gen()
	com.Essentials()
	itm.Essentials()
	inv.Essentials()
	
	Runtime:addEventListener("enterFrame", col.removeOffscreenItems)
	print "Game loaded successfully."
	Round=WD.Circle()
	print ("Floor: "..Round)
end

function Operations2()
	gp.Essentials()
	inv.Essentials()
end

function FrontNCenter()
	Loading:toFront()
end
