-----------------------------------------------------------------------------------------
--
-- Version.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local m=require("Lmenu")
--[[
DUNGEONS OF GAL'DARAH

DUNGEONS OF GALDAMIR

Font1: Monotype Corsiva
Font2: Game Over
Font3: Viner Hand ITC
Font4: Adobe Devanagari
Font5: MoolBoran

AdBuddiz:
6c7e651b-851d-4ab9-923d-a557d77d4a6a

TO DO
	COD-LIKE DAMAGE GFX
	LOW HEALTH SFX
--]]

local RSS
local shSuffix="RLSE"
local loSuffix="RELEASE"
local verNum="1.2.0"
local cVersion=(shSuffix.." "..verNum)
local gVersion=(loSuffix.." "..verNum)

function HowDoIVersion(val)
	if val==true then
		VCheck()
	end
	return gVersion
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