-----------------------------------------------------------------------------------------
--
-- Startup.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local loadsheet = graphics.newImageSheet( "spriteload.png", { width=50, height=50, numFrames=8 } )
local handler=require("Ltiles")
local builder=require("Lbuilder")
local players=require("Lplayers")
local WD=require("Lprogress")
local audio=require("Laudio")
local com=require("Lcombat")
local inv=require("Lwindow")
local s=require("Lsplashes")
local sav=require("Lsaving")
local col=require("Levents")
local itm=require("Litems")
local menu=require("Lmenu")
local gp=require("Lgold")
local m=require("Lmoves")
local q=require("Lquest")
local ui=require("Lui")
local DoLoad=false
local Loading
local DoStuff
local Round

function Startup(val)
	--	print "Game loading..."
	if val~=false then
		DoStuff=true
	elseif val==false then
		DoStuff=false
	end
	Loading=display.newGroup()
	menu.FindMe(8)
	
	loadbkg = display.newImage("bkgs/bkg_leveldark.png", true)
	loadbkg.x = display.contentWidth/2
	loadbkg.y = display.contentHeight/2
	Loading:insert( loadbkg )
	
	load1 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load1.x = display.contentWidth-50
	load1.y = display.contentHeight-50
	load1:play()
	Loading:insert( load1 )
	
	load2 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load2.x = load1.x-55
	load2.y = load1.y
	load2:play()
	Loading:insert( load2 )
	
	load3 = display.newSprite( loadsheet, { name="load", start=1, count=8, time=600,}  )
	load3.x = load2.x+30
	load3.y = load2.y-50
	load3:play()
	Loading:insert( load3 )
	
	loadtxt = display.newText("Loading...", 0,0,"Game Over",100)
	loadtxt.x = load2.x-150
	loadtxt.y = load1.y
	Loading:insert( loadtxt )
	
	Tip=s.GetTip()
	Loading:insert( Tip )
	
	if DoStuff==true then
		if val==true then
			DoLoad=true
			function WrapIt()
				Operations()
			end
			timer.performWithDelay(1000, (WrapIt) )
		else
			DoLoad=false
			function WrapIt()
				Operations(val)
			end
			timer.performWithDelay(1000, (WrapIt) )
		end
	end
end

function ShowContinue()
	Runtime:addEventListener( "touch", Continue )
	
	display.remove( loadtxt )
	loadtxt=nil
	display.remove( load1 )
	load1=nil
	display.remove( load2 )
	load2=nil
	display.remove( load3 )
	load3=nil
	
	contxt = display.newText("Tap to continue", 0,0,"MoolBoran",60)
	contxt:setTextColor(70,255,70)
	contxt.x = display.contentCenterX
	contxt.y = display.contentHeight*.75
	Loading:insert( contxt )
end
	
function Continue( event )
	if event.phase=="ended" then
		Runtime:removeEventListener( "touch", Continue )
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
		if DoStuff==true then
			ui.UI(true)
			if DoLoad==true then
				DoLoad=false
				m.Visibility()
			else
				ui.Pause(true)
				inv.ToggleInfo()
				inv.SwapInfo(false)
			end
			players.CalmDownCowboy(true)
			audio.changeMusic(2)
			menu.FindMe(6)
		elseif DoStuff==false then
			m.Visibility()
		end
	end
end
	
function Operations(name)
	players.CalmDownCowboy(false)
	q.Essentials()
	WD.Essentials()
	players.CreatePlayers(name)
	gp.Essentials()
	com.Essentials()
	itm.Essentials()
	inv.Essentials()
--	players.WhosYourDaddy()
	ui.CleanSlate()
	ui.UI(false)
	if DoLoad==true then
		timer.performWithDelay(100, (sav.Load) )
	else
		builder.BuildMap()
	end
	
	Runtime:addEventListener("enterFrame", col.removeOffscreenItems)
--	print "Game loaded successfully."
	Round=WD.Circle()
--	print ("Floor: "..Round)
end

function Operations2()
	gp.Essentials()
	inv.Essentials()
end

function FrontNCenter()
	Loading:toFront()
end
