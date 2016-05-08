-----------------------------------------------------------------------------------------
--
-- MapHandler.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local option=require("Loptions")
local WD=require("Lprogress")
local audio=require("Laudio")
local widget=require"widget"
local b=require("Lbuilder")
local lc=require("Llocale")
local m=require("Lmenu")
local opt=display.newGroup()
local Testing=false
local TileID=0
local CurTile
local Round

function SetTile(am)
	TileID=am
end

function GetTiles()
	return TileID
end

function MapSizeMenu()
	m.FindMe(3)
	function onBackRelease()
		audio.Play(12)
		for i=opt.numChildren,1,-1 do
			local child = opt[i]
			child.parent:remove( child )
		end
		option.DisplayOptions()
	end
	
	function DefaultTSet()
		audio.Play(12)
		SetTile(0)
		CurTile.text=(lc.giveText("LOC028").." "..lc.giveText("LOC024"))
	end
	
	function NotebookTSet()
		audio.Play(12)
		SetTile(1)
		CurTile.text=(lc.giveText("LOC028").." "..lc.giveText("LOC025"))
	end
	
	function SimpleTSet()
		audio.Play(12)
		SetTile(2)
		CurTile.text=(lc.giveText("LOC028").." "..lc.giveText("LOC026"))
	end
	
	function BWTSet()
		audio.Play(12)
		SetTile(3)
		CurTile.text=(lc.giveText("LOC028").." B&W")
	end
	
	function SecretTSet()
		audio.Play(12)
		SetTile(4)
		CurTile.text=(lc.giveText("LOC028").." "..lc.giveText("LOC027"))
	end
	
	local DefaultTS =  widget.newButton{
		label=lc.giveText("LOC024"),
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = DefaultTSet
	}
	DefaultTS:setReferencePoint( display.CenterReferencePoint )
	DefaultTS.x = display.contentWidth*0.5
	DefaultTS.y = display.contentHeight*0.3
	opt:insert(DefaultTS)
	
	local NotebookTS =  widget.newButton{
		label=lc.giveText("LOC025"),
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = NotebookTSet
	}
	NotebookTS:setReferencePoint( display.CenterReferencePoint )
	NotebookTS.x = DefaultTS.x
	NotebookTS.y = DefaultTS.y+100
	opt:insert(NotebookTS)
	
	local SimpleTS =  widget.newButton{
		label=lc.giveText("LOC026"),
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = SimpleTSet
	}
	SimpleTS:setReferencePoint( display.CenterReferencePoint )
	SimpleTS.x = NotebookTS.x
	SimpleTS.y = NotebookTS.y+100
	opt:insert(SimpleTS)
	
	--[[
	local BWTS =  widget.newButton{
		label="Black & White Tileset",
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = BWTSet
	}
	BWTS:setReferencePoint( display.CenterReferencePoint )
	BWTS.x = RealTS.x
	BWTS.y = RealTS.y+100
	opt:insert(BWTS)
	--]]
	
	title=display.newText(lc.giveText("LOC007"),0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	title:setTextColor(125,250,125)
	title:addEventListener("tap",Secret)
	opt:insert(title)
	
	local BackBtn =  widget.newButton{
		label=lc.giveText("LOC008"),
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
		labelColor = { default={255,255,255}, over={0,0,0} },
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onBackRelease
	}
	BackBtn:setReferencePoint( display.CenterReferencePoint )
	BackBtn.x = display.contentWidth*0.5
	BackBtn.y = display.contentHeight-100
	opt:insert(BackBtn)
	
	if TileID==0 then
		CurTile = display.newText( (lc.giveText("LOC028").." "..lc.giveText("LOC024") ), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=700
		opt:insert(CurTile)
	elseif TileID==1 then
		CurTile = display.newText( (lc.giveText("LOC028").." "..lc.giveText("LOC025") ), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=700
		opt:insert(CurTile)
	elseif TileID==2 then
		CurTile = display.newText( (lc.giveText("LOC028").." "..lc.giveText("LOC026") ), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=700
		opt:insert(CurTile)
	elseif TileID==3 then
		CurTile = display.newText( ("Current Tileset: B&W"), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=700
		opt:insert(CurTile)
	elseif TileID==4 then
		CurTile = display.newText( ( lc.giveText("LOC028").." "..lc.giveText("LOC027") ), 0, 0, "MoolBoran", 75 )
		CurTile.x=display.contentCenterX
		CurTile.y=700
		opt:insert(CurTile)
	end
end

function Secret( event )
	SecretTSet()
end