-----------------------------------------------------------------------------------------
--
-- UI.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local builder=require("Lbuilder")
local players=require("Lplayers")
local widget = require "widget"
local set=require("Lsettings")
local WD=require("Lprogress")
local audio=require("Laudio")
local inv=require("Lwindow")
local mob=require("Lmobai")
local gold=require("Lgold")
local col=require("Levents")
local c=require("Lcombat")
local shp=require("Lshop")
local m=require("Lmoves")
local portsnprsnt
local portsprsnt
local rportprsnt
local mpdnprsnt
local hpdnprsnt
local isPaused
local bkglevel
local topthing
local hpdprsnt
local mpdprsnt
local Coins
local pwg
local Map
local P1

function Background()
	if (bkglevel) then
		display.remove(bkglevel)
		bkglevel=nil
	end
	bkglevel = display.newImage("bkgs/bkg_level.png", true)
	bkglevel.x = display.contentCenterX
	bkglevel.y = display.contentCenterY
	bkglevel:toBack()
	return bkglevel
end

function Paused()
	return isPaused
end

function ForcePause()
	if isPaused==true then
		inv.CloseErrthang()
	else
		Pause()
	end
end

function UI(ready)
	if ready==true then
		local info=set.Get(7)
		PauseBtn =  widget.newButton{
			defaultFile="pauseon.png",
			overFile="pauseoff.png",
			width=65, height=65,
			onRelease = Pause
		}
		PauseBtn:setReferencePoint( display.CenterReferencePoint )
		PauseBtn.xScale = 1.3
		PauseBtn.yScale = PauseBtn.xScale
		PauseBtn.x = info[1]
		PauseBtn.y = info[2]
	else
		if (pwg) then
			for i=pwg.numChildren,1,-1 do
				display.remove(pwg[i])
				pwg[i]=nil		
			end	
			pwg=nil
			display.remove(PauseBtn)
			PauseBtn=nil
		end
		P1=players.GetPlayer()
		pwg=display.newGroup()
		isPaused=false
		
		window=display.newRect(0,0,390,166)
		window:setFillColor(100,100,100,150)
		window.x,window.y=(display.contentCenterX), display.contentCenterY
		pwg:insert(window)
		
		pausetxt=display.newText("Game Paused.",0,0,"MoolBoran",60)
		pausetxt.x=window.x
		pausetxt.y=window.y-90
		pwg:insert(pausetxt)
		
		pausewin=display.newRect(0,0,(#pausetxt.text)*24,38)
		pausewin:setFillColor(0,0,0,150)
		pausewin.x=pausetxt.x
		pausewin.y=pausetxt.y-15
		pwg:insert(pausewin)
		
		pausetxt:toFront()
		
		bag = display.newImageRect("bagbtn.png", 80, 80)
		bag.x, bag.y = window.x+(25*1.28*1.5)-((390-6)/2), window.y+(25*1.28*1.5)-((166-6)/2)
		bag.xScale = 1.2
		bag.yScale = bag.xScale
		bag:addEventListener("touch",OpenBag)
		pwg:insert(bag)
		
		info = display.newImageRect("infobtn.png", 80, 80)
		info.x, info.y = bag.x+(80*bag.xScale), bag.y
		info.yScale = bag.yScale
		info.xScale = bag.xScale
		info:addEventListener("touch",OpenInfo)
		pwg:insert(info)
		
		snd = display.newImageRect("soundbtn.png",80,80)
		snd.x,snd.y = info.x+(80*info.xScale), bag.y
		snd.xScale=bag.xScale
		snd.yScale=bag.yScale
		snd:addEventListener("touch",OpenSnd)
		pwg:insert(snd)
		
		magic = display.newImageRect("magicbtn.png", 80, 80)
		magic.x, magic.y = snd.x+(80*snd.xScale), bag.y
		magic.yScale = bag.yScale
		magic.xScale = bag.xScale
		magic:addEventListener("touch",OpenBook)
		pwg:insert(magic)
		
		pwg.isVisible=false
		
		MapIndicators("create")
	end
end

function Pause(mute)
	local busy=inv.OpenWindow()
	local shap=shp.AtTheMall()
	local fight=c.InTrouble()
	if busy==false and shap==false and fight==false then
		portsprsnt.txt.text=(P1.portcd)
		if isPaused==true then
			isPaused=false
			m.Visibility()
			gold.ShowGCounter()
			players.LetsYodaIt()
			pwg.isVisible=false
			if mute~=true then
				audio.Play(3)
			end
		elseif isPaused==false then
			isPaused=true
			m.CleanArrows()
			gold.ShowGCounter()
			players.LetsYodaIt()
			pwg.isVisible=true
			if mute~=true then
				audio.Play(4)
			end
		end
	elseif busy==true then
		local success=inv.CloseErrthang()
		if success==true then
			Pause()
		end
	end
end

function OpenBag( event )
	if event.phase=="ended" and isPaused==true then
		inv.ToggleBag()
		pwg.isVisible=false
	end
end

function OpenExit( event )
	if event.phase=="ended" and isPaused==true then
		inv.ToggleExit()
		pwg.isVisible=false
	end
end

function OpenSnd( event )
	if event.phase=="ended" and isPaused==true then
		inv.ToggleSound()
		pwg.isVisible=false
	end
end

function OpenInfo( event )
	if event.phase=="ended" and isPaused==true then
		inv.ToggleInfo()
		pwg.isVisible=false
	end
end

function OpenBook( event )
	if event.phase=="ended" and isPaused==true then
		inv.ToggleSpells()
		pwg.isVisible=false
	end
end

function ShowPwg()
	pwg.isVisible=true
end

function MapIndicators(val)
	if val=="create" then
		portsprsnt = display.newImageRect("portalspresent.png",80,80)
		portsprsnt.x, portsprsnt.y = bag.x-16, bag.y+(50*1.28)+17
		portsprsnt.xScale,portsprsnt.yScale=0.8,0.8
		portsprsnt.isVisible=false
		pwg:insert(portsprsnt)
		
		portsnprsnt = display.newImageRect("portalsnpresent.png",80,80)
		portsnprsnt.x, portsnprsnt.y = portsprsnt.x, portsprsnt.y
		portsnprsnt.xScale,portsnprsnt.yScale=0.8,0.8
		pwg:insert(portsnprsnt)
		
		portsprsnt.txt=display.newText((P1.portcd),0,0,"Game Over",120)
		portsprsnt.txt.x,portsprsnt.txt.y=portsprsnt.x,portsprsnt.y-5
		portsprsnt.txt.isVisible=false
		pwg:insert(portsprsnt.txt)
		
		hpdprsnt = display.newImageRect("hppresent.png",80,80)
		hpdprsnt.x, hpdprsnt.y = portsprsnt.x+(80*0.8), portsprsnt.y
		hpdprsnt.xScale,hpdprsnt.yScale=0.8,0.8
		hpdprsnt.isVisible=false
		pwg:insert(hpdprsnt)
		
		hpdnprsnt = display.newImageRect("hpnpresent.png",80,80)
		hpdnprsnt.x, hpdnprsnt.y = hpdprsnt.x, portsprsnt.y
		hpdnprsnt.xScale,hpdnprsnt.yScale=0.8,0.8
		pwg:insert(hpdnprsnt)
		
		mpdprsnt = display.newImageRect("mppresent.png",80,80)
		mpdprsnt.x, mpdprsnt.y = hpdprsnt.x+(80*0.8), portsprsnt.y
		mpdprsnt.xScale,mpdprsnt.yScale=0.8,0.8
		mpdprsnt.isVisible=false
		pwg:insert(mpdprsnt)
		
		mpdnprsnt = display.newImageRect("mpnpresent.png",80,80)
		mpdnprsnt.x, mpdnprsnt.y = mpdprsnt.x, portsprsnt.y
		mpdnprsnt.xScale,mpdnprsnt.yScale=0.8,0.8
		pwg:insert(mpdnprsnt)
		
		epdprsnt = display.newImageRect("eppresent.png",80,80)
		epdprsnt.x, epdprsnt.y = mpdprsnt.x+(80*0.8), portsprsnt.y
		epdprsnt.xScale,epdprsnt.yScale=0.8,0.8
		epdprsnt.isVisible=false
		pwg:insert(epdprsnt)
		
		epdnprsnt = display.newImageRect("epnpresent.png",80,80)
		epdnprsnt.x, epdnprsnt.y = epdprsnt.x, portsprsnt.y
		epdnprsnt.xScale,epdnprsnt.yScale=0.8,0.8
		pwg:insert(epdnprsnt)
		
		msprsnt = display.newImageRect("mspresent.png",80,80)
		msprsnt.x, msprsnt.y = epdprsnt.x+(80*0.8), portsprsnt.y
		msprsnt.xScale,msprsnt.yScale=0.8,0.8
		msprsnt.isVisible=false
		pwg:insert(msprsnt)
		
		msnprsnt = display.newImageRect("msnpresent.png",80,80)
		msnprsnt.x, msnprsnt.y = msprsnt.x, portsprsnt.y
		msnprsnt.xScale,msnprsnt.yScale=0.8,0.8
		pwg:insert(msnprsnt)
	
		keynprsnt = display.newImageRect("keyno.png",80,80)
		keynprsnt.x,keynprsnt.y = msprsnt.x+(80*0.8), portsprsnt.y
		keynprsnt.xScale = 0.8
		keynprsnt.yScale = keynprsnt.xScale
		pwg:insert(keynprsnt)
		
		keyprsnt = display.newImageRect("keyget.png",80,80)
		keyprsnt.x,keyprsnt.y = keynprsnt.x, keynprsnt.y
		keyprsnt.xScale = keynprsnt.xScale
		keyprsnt.yScale =keynprsnt.xScale
		keyprsnt.isVisible=false
		pwg:insert(keyprsnt)
	end
	if val=="KEY" then
		keyprsnt.isVisible=true
		keynprsnt.isVisible=false
	end
	if val=="MP" then
		mpdprsnt.isVisible=true
		mpdnprsnt.isVisible=false
	end
	if val=="EP" then
		epdprsnt.isVisible=true
		epdnprsnt.isVisible=false
	end
	if val=="HP" then
		hpdprsnt.isVisible=true
		hpdnprsnt.isVisible=false
	end
	if val=="BP" then
		portsprsnt.isVisible=true
		portsprsnt.txt.isVisible=true
		portsnprsnt.isVisible=false
	end
	if val=="MS" then
		msprsnt.isVisible=true
		msnprsnt.isVisible=false
	end
end

function GetProfBkg()
	return profbkg
end

function CleanSlate()
	if (pwg) then
		for i=pwg.numChildren,1,-1 do
			display.remove(pwg[i])
			pwg[i]=nil		
		end	
		pwg=nil
		display.remove(PauseBtn)
		PauseBtn=nil
	end
	if (bkglevel) then
		display.remove(bkglevel)
		bkglevel=nil
	end
end
