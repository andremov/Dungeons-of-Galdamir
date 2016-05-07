-----------------------------------------------------------------------------------------
--
-- Version.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local m=require("Lmenu")
--[[
DUNGEONS OF GAL'DARAH
CURRENT VERSION: BETA 1.9.0

Font1: Monotype Corsiva
Font2: Game Over
Font3: Viner Hand ITC
Font4: Adobe Devanagari
Font5: MoolBoran

TO DO:
	- Check on spawn mob bug, mob loc=nil
	- Add Energy
	- Make "back" button in combat always visible
	- Add skills
	- Move player window in combat to be = enemy window
	- make map building like mazes
	- on exit btn save isnt deleted
	- make blank scroll an extra drop
	- check items are fixed
	- on shop buy items are singles
	- item quantities on shop
--]]

local RSS
local GVersion="BETA 1.9.0"

function HowDoIVersion(val)
	if val==true then
		VCheck()
	end
	return GVersion
end


function VCheck()
	network.request( "http://echelan.tumblr.com/rss", "GET", VListen)
end

function VListen( event )
	if ( event.isError ) then
		m.isVersion(nil)
	else
		local message = event.response
		local count=0
		local gmessage={}
		for word in string.gmatch(message, "Ver.: ..........") do
			count=count+1
			if count==1 then
				RSS=string.sub(word,7,16)
				VConclusions()
			end
		end
	end
end

function VConclusions()
	if RSS==GVersion then
		m.isVersion(true)
	else
		m.isVersion(false)
	end
end