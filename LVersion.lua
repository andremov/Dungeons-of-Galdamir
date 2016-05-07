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
CURRENT VERSION: GAMMA 1.1.4
=======
CURRENT VERSION: GAMMA 1.2.0
>>>>>>> G1.2.0

Font1: Monotype Corsiva
Font2: Game Over
Font3: Viner Hand ITC
Font4: Adobe Devanagari
Font5: MoolBoran

TO DO
	OPEN & CLOSE SHOP AUDIO
	STEP AUDIO
	COMBAT AUDIO
	MUSIC REPEAT?
	DEAL DAMAGE SFX
	COD-LIKE DAMAGE GFX
	LOW HEALTH SFX
	SHOP STAT COMPARE
--]]

local RSS
<<<<<<< HEAD
local GVersion="GAMMA 1.1.4"
local cVersion="GAMA 1.1.4"
=======
local GVersion="GAMMA 1.2.0"
local cVersion="GAMA 1.2.0"
>>>>>>> G1.2.0

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
	if RSS==cVersion then
		m.isVersion(true)
	else
		m.isVersion(false)
	end
end