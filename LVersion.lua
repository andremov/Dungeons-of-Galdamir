-----------------------------------------------------------------------------------------
--
-- Version.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local m=require("Lmenu")
--[[
DUNGEONS OF GAL'DARAH
<<<<<<< HEAD
CURRENT VERSION: BETA 1.8.1
=======
CURRENT VERSION: BETA 1.8.5
>>>>>>> B1.8.2

Font1: Monotype Corsiva
Font2: Game Over
Font3: Viner Hand ITC
Font4: Adobe Devanagari
Font5: FixSys

For Logo:
	1. Write Letter in red. Font 72 in file size 96x96.
	2. Pencil Sketch - 2,-20
	3. Recolor to pure yellow.
	4. Hue/Saturation - 10,100,0
	5. Glow - 6,10,75
----------------------

	
--]]

local RSS
<<<<<<< HEAD
local GVersion="BETA 1.8.1"
=======
local GVersion="BETA 1.8.5"
>>>>>>> B1.8.2

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