-----------------------------------------------------------------------------------------
--
-- Score.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local audio = require("LAudio")
local menu = require("Lmenu")
local ghs=display.newGroup()
local Score
--[[

Things to take into account for scoring:
Player's Level
Floor
Map Size
Gold Count

--]]

--[[

(Level*(GoldCount/(1+((Floor-1)*Zones))))

--]]


function onBackBtn()
	audio.Play(12)
	if (Text) then
		for i=table.maxn(Text),1,-1 do
			local child = Text[i]
			child.parent:remove( child )
			Text[i]=nil
		end
		Text=nil
	end
	if (Sve) then
		for i=table.maxn(Sve),1,-1 do
			Sve[i]=nil
		end
		Sve=nil
	end
	for i=ghs.numChildren,1,-1 do
		local child = ghs[i]
		child.parent:remove( child )
	end
	menu.ShowMenu()
	menu.ReadySetGo()
end

function Scoring(round,p1,size)
	Score=(
		(size/5)
	)
	Score=(
		Score*(round-1)
	)
	Score=(
		Score+1
	)
	Score=(
		p1.gp/Score
	)
	Score=(
		Score^(round)
	)
	Score=(
		math.floor((Score*p1.lvl)*((p1.stats[1]+p1.stats[2]+p1.stats[3]+p1.stats[4]+p1.stats[5])/5))
	)
	print (Score)
	isHigh(Score)
	return Score
end

function isHigh(val)
	if val~=nil then
		Sve={}
		local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
		for line in io.lines( path ) do
			n = tonumber(line)
			if n == nil then
				Sve[#Sve+1]=line
			else
				Sve[#Sve+1]=n
			end
		end
	
		for l=table.maxn(Sve),1,-1 do
			if val>Sve[l] then
				local fh, errStr = io.open( path, "r+" )
				
				for z=1,(l-1) do
					fh:write( Sve[z], "\n" )
				end
				
				fh:write( val, "\n" )
				
				for z=l,9 do
					fh:write (Sve[z], "\n")
				end
				
				io.close( fh )
			end
		end
		CleanScores()
	end
	
end

function SaveScore()
	
end

function HighScores()
	
	
	local background = display.newImageRect( "bkgs/score.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	ghs:insert(background)
	
	BackBtn = widget.newButton{
		label="Back",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button.png",
		overFile="button-over.png",
		width=308, height=80,
		onRelease = onBackBtn
	}
	BackBtn:setReferencePoint( display.CenterReferencePoint )
	BackBtn.x = display.contentWidth*0.5
	BackBtn.y = display.contentHeight-70
	ghs:insert(BackBtn)
	
	Sve={}
	
	local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
	for line in io.lines( path ) do
		n = tonumber(line)
		if n == nil then
			Sve[#Sve+1]=line
		else
			Sve[#Sve+1]=n
		end
	end
	Text={}
	
	for l=1,10 do
		Text[#Text+1] = display.newText( ( (Sve[l]) ) ,0,0,labelFont, 60 )
		Text[#Text].x=display.contentWidth/2
		Text[#Text].y=110+(71*#Text)
		ghs:insert(Text[#Text])
	end
end

function CleanScores()

	Sve={}
	local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
	for line in io.lines( path ) do
		n = tonumber(line)
		if n == nil then
			Sve[#Sve+1]=line
		else
			Sve[#Sve+1]=n
		end
	end
	
	local fh, errStr = io.open( path, "w+" )
	
	for z=1,10 do
		fh:write( Sve[z], "\n" )
	end
	
	io.close( fh )
	if (Sve) then
		for i=table.maxn(Sve),1,-1 do
			Sve[i]=nil
		end
		Sve=nil
	end
end

function CheckScore()
	local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "r" )
	if (fh) then
		local contents = fh:read( "*a" )
		if (contents) and contents~="" and contents~=" " then
		else
			local fh, errStr = io.open( path, "w+" )
			for z=1,10 do
				fh:write( 0, "\n" )
			end
			io.close( fh )
		end
	else
		local fh, errStr = io.open( path, "w+" )
		for z=1,10 do
			fh:write( 0, "\n" )
		end
		io.close( fh )
	end
end