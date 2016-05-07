-----------------------------------------------------------------------------------------
--
-- Score.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local audio = require("Laudio")
local menu = require("Lmenu")
local v = require("Lversion")
local ghs=display.newGroup()
local Score
local GVersion
local OKVers={
		"BETA 1.9.0",
	}
local Default={
		"Brownie S.",10000,
		"Go Q.",9001,
		"T. Pastry",7500,
		"Blue X.",5000,
		"H. Dew",2500,
		"D. \"Fox\" Leigh",1000,
		"M. Person",500,
		"Moorabi",250,
		"Reese C.",100,
		"E. Z. Mood",10
	}
	
function onBackBtn()
	
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
		math.floor((Score*p1.lvl)*((p1.stats[1]+p1.stats[2]+p1.stats[3]+p1.stats[4]+p1.stats[5]+p1.stats[6])/6))
	)
	isHigh(Score,p1.name)
	return Score
end

function isHigh(val,name)
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
		local overIt=false
		for l=table.maxn(Sve),2,-2 do
			if val>Sve[l] then
				overIt=l
			end
		end
		if overIt~=false then
			local fh, errStr = io.open( path, "r+" )
			
			fh:write( Sve[1], "\n" )
			for z=2,(overIt-2),2 do
				fh:write( Sve[z], "\n" )
				fh:write( Sve[z+1], "\n" )
			end
			
			fh:write( name, "\n" )
			fh:write( val, "\n" )
			
			for z=overIt-1,19,2 do
				fh:write (Sve[z], "\n")
				fh:write( Sve[z+1], "\n" )
			end
			
			io.close( fh )
		end
	end
	CleanScores()
end

function HighScores()
	--Displays high scores
	
	local background = display.newImageRect( "bkgs/score.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	ghs:insert(background)
	
	BackBtn = widget.newButton{
		label="Back",
		labelColor = { default={0,0,0}, over={255,255,255} },
		fontSize=30,
		defaultFile="button1.png",
		overFile="button1-over.png",
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
	
	for l=2,21,2 do
		Text[#Text+1] = display.newText( ( (Sve[l].." - "..Sve[l+1]) ) ,140,150+(71*#Text),"MoolBoran", 75 )
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
	
	for z=1,21 do
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
	--Fills in empty score file with zeros.
	GVersion=v.HowDoIVersion(true)
	local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "r" )
	if (fh) then
		local contents = fh:read( "*a" )
		if (contents) and contents~="" and contents~=" " then
			io.close( fh )
			Sve={}
			for line in io.lines( path ) do
				n = tonumber(line)
				
				if n == nil then
					Sve[#Sve+1]=line
				else
					Sve[#Sve+1]=n
				end
			end
			local saveok=false
			for i=1,table.maxn(OKVers) do
				if Sve[1]==OKVers[i] then
					saveok=true
				end
			end
			if saveok==false then
				local fh, errStr = io.open( path, "w+" )
				
				fh:write( GVersion, "\n" )
				for z=1,20 do
					fh:write( Default[z], "\n" )
				end
				io.close( fh )
			
				if (Sve) then
					for i=table.maxn(Sve),1,-1 do
						Sve[i]=nil
					end
					Sve=nil
				end
			end
		else
			local fh, errStr = io.open( path, "w+" )
			fh:write( GVersion, "\n" )
			for z=1,20 do
				fh:write( Default[z], "\n" )
			end
			io.close( fh )
		end
	else
		local fh, errStr = io.open( path, "w+" )
		fh:write( GVersion, "\n" )
		for z=1,20 do
			fh:write( Default[z], "\n" )
		end
		io.close( fh )
	end
end

