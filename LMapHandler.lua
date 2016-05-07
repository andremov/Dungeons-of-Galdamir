-----------------------------------------------------------------------------------------
--
-- MapHandler.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local maps=require("Lmaps")
local WD=require("Lprogress")
local widget=require "widget"
local option=require("Loptions")
local audio=require("Laudio")
local b=require("Lmapbuilder")
local currentmap
local Round
local HowRed=0
local mapsS={}
local mapsM={}
local mapsL={}
local mapsH={}
local tutorial={}
local testin={}
local opt=display.newGroup()
local TileID=0
local SizeID=2
local CurSize
local CurTile
local Testing=true

function GetCMap()
	Round=WD.Circle()
	if Testing==false then
		if SizeID==1 then
			currentmap=mapsS[1]
			return currentmap
		elseif SizeID==2 then
			currentmap=mapsM[1]
			return currentmap
		elseif SizeID==3 then
			currentmap=mapsL[1]
			return currentmap
		elseif SizeID==4 then
			currentmap=mapsH[1]
			return currentmap
		end
	elseif Testing==true then
		currentmap=testin[1]
		return currentmap
	end
end

function CallingZones()
	maps.CallMapGroups()
	mapsS,mapsM,mapsL,mapsH,tutorial,testin=maps.GetMapGroups()
end

function Size(am)
	SizeID=am
	if am==0 then
		b.Rebuild()
	end
end

function SetTile(am)
	TileID=am
end

function GetSize()
	return SizeID
end

function GetTiles()
	return TileID
end

function MapSizeMenu()

	local background = display.newImageRect( "bkgs/bkgsize.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	opt:insert(background)
	
	function onBackRelease()
		for i=opt.numChildren,1,-1 do
			local child = opt[i]
			child.parent:remove( child )
		end
		option.DisplayOptions()
	end
	
	function SmallMap()
		Size(1)
		CurSize.text=("Current Map Size: Small")
	end
	
	function MedMap()
		Size(2)
		CurSize.text=("Current Map Size: Medium")
	end
	
	function LargeMap()
		Size(3)
		CurSize.text=("Current Map Size: Large")
	end
	
	function HCMap()
		Size(4)
		CurSize.text=("Current Map Size: Hardcore")
	end
	
	function DefaultTSet()
		SetTile(0)
		CurTile.text=("Current Tileset: Default")
	end
	
	function NotebookTSet()
		SetTile(1)
		CurTile.text=("Current Tileset: Notebook")
	end
	
	function BWTSet()
		SetTile(3)
		CurTile.text=("Current Tileset: B&W")
	end
	
	function RealTSet()
		SetTile(2)
		CurTile.text=("Current Tileset: Realistic")
	end
	
	local SmallBtn = widget.newButton{
		label="Small Map",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = SmallMap
	}
	SmallBtn:setReferencePoint( display.CenterReferencePoint )
	SmallBtn.x = display.contentWidth*0.5-160
	SmallBtn.y = display.contentHeight*0.31
	opt:insert(SmallBtn)
	
	local MedBtn = widget.newButton{
		label="Medium Map",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = MedMap
	}
	MedBtn:setReferencePoint( display.CenterReferencePoint )
	MedBtn.x = SmallBtn.x
	MedBtn.y = SmallBtn.y+90
	opt:insert(MedBtn)
	
	local LargeBtn = widget.newButton{
		label="Large Map",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = LargeMap
	}
	LargeBtn:setReferencePoint( display.CenterReferencePoint )
	LargeBtn.x = SmallBtn.x
	LargeBtn.y = MedBtn.y+90
	opt:insert(LargeBtn)
	
	local HCBtn = widget.newButton{
		label="Hardcore Map",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = HCMap
	}
	HCBtn:setReferencePoint( display.CenterReferencePoint )
	HCBtn.x = SmallBtn.x
	HCBtn.y = LargeBtn.y+90
	opt:insert(HCBtn)
	
	local DefaultTS = widget.newButton{
		label="Default Tileset",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = DefaultTSet
	}
	DefaultTS:setReferencePoint( display.CenterReferencePoint )
	DefaultTS.x = display.contentWidth*0.5+160
	DefaultTS.y = display.contentHeight*0.31
	opt:insert(DefaultTS)
	
	local NotebookTS = widget.newButton{
		label="Notebook Tileset",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = NotebookTSet
	}
	NotebookTS:setReferencePoint( display.CenterReferencePoint )
	NotebookTS.x = DefaultTS.x
	NotebookTS.y = DefaultTS.y+90
	opt:insert(NotebookTS)
	
	local RealTS = widget.newButton{
		label="Realistic Tileset",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = RealTSet
	}
	RealTS:setReferencePoint( display.CenterReferencePoint )
	RealTS.x = NotebookTS.x
	RealTS.y = NotebookTS.y+90
	opt:insert(RealTS)
	
	local BWTS = widget.newButton{
		label="Black & White Tileset",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = BWTSet
	}
	BWTS:setReferencePoint( display.CenterReferencePoint )
	BWTS.x = RealTS.x
	BWTS.y = RealTS.y+90
	opt:insert(BWTS)
	
	local Back = widget.newButton{
		label="Back",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
		width=308, height=80,
		onRelease = onBackRelease
	}
	Back:setReferencePoint( display.CenterReferencePoint )
	Back.x = display.contentWidth*0.5
	Back.y = display.contentHeight-120
	opt:insert(Back)
	
	if SizeID==1 then
		CurSize = display.newText( ("Current Map Size: Small"), 0, 0, "MoolBoran", 75 )
		CurSize.x=display.contentCenterX
		CurSize.y= display.contentHeight-300
		opt:insert(CurSize)
	elseif SizeID==2 then
		CurSize = display.newText( ("Current Map Size: Medium"), 0, 0, "MoolBoran", 75 )
		CurSize.x=display.contentCenterX
		CurSize.y= display.contentHeight-300
		opt:insert(CurSize)
	elseif SizeID==3 then
		CurSize = display.newText( ("Current Map Size: Large"), 0, 0, "MoolBoran", 75 )
		CurSize.x=display.contentCenterX
		CurSize.y= display.contentHeight-300
		opt:insert(CurSize)
	elseif SizeID==4 then
		CurSize = display.newText( ("Current Map Size: Hardcore"), 0, 0, "MoolBoran", 75 )
		CurSize.x=display.contentCenterX
		CurSize.y= display.contentHeight-300
		opt:insert(CurSize)
	end
	
	if TileID==0 then
		CurTile = display.newText( ("Current Tileset: Default"), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=CurSize.y+80
		opt:insert(CurTile)
	elseif TileID==1 then
		CurTile = display.newText( ("Current Tileset: Notebook"), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=CurSize.y+80
		opt:insert(CurTile)
	elseif TileID==2 then
		CurTile = display.newText( ("Current Tileset: Realistic"), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=CurSize.y+80
		opt:insert(CurTile)
	elseif TileID==3 then
		CurTile = display.newText( ("Current Tileset: B&W"), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=CurSize.y+80
		opt:insert(CurTile)
	end
end