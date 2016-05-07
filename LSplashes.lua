-----------------------------------------------------------------------------------------
--
-- Splashes.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)

local Splash
local Splashtxt
local S={
	"Now with splashes!",
	"Random maps!",
	"Soon!",
	"Beta!",
	"Equipment!",
	"Working Inventory!",
	"Mob Racial Diversity!",
	"Item Drop Restrictions!",
	"Hardcore!",
	"Character Customization!",
	"Elixirs Of Doubtful Origins!",
	"Omnipotence-free!",
	"Diamond Armor!",
	"Major Bugfixing!",
	"Magical!",
	"Dodge!",
	"Charger required!",
	"Not Impossible!",
	"Improbable!",
	"Gold Ore!",
	"Mysterious Gems!",
	"Don't Panic!",
	"Item Shops!",
	"Floor taxes!",
	"Stable Releases!",
	"Balanced!",
	"Stat Boosts!",
	"Secret Items!",
	"28 Pages of Code!",
	"27MB of Pure Gold!",
	"Over 100 items!",
	"Rings!",
	"Unused Equipment!",
	"Sorcery!",
	"Mana!",
	"Smooth!",
	"Content Heavy!",
}

function GetSplash()
	local chooser=math.random(1,table.maxn(S))
	Splash=S[chooser]
	Splashtxt = display.newEmbossedText((Splash),20,190,native.systemFont, 50 )
	Splashtxt:setTextColor( 255, 255, 0)
	return Splashtxt
end
