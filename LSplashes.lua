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
	"Sooner than ever!",
	"Gamma!",
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
	"Techniques!",
	"Energy!",
	"Limited Shops!",
	"RSS Feeds!",
	"Version Checks!",
	"Fatigue!",
	"Quests!",
	"Now with back story!",
	"You go, gurl!",
	"Plot twists!",
	"\"Originality!\"",
	"Does not steal content!",
	"Fog of war!",
	"Optimization!",
	"Overhauls!",
	"Now more greek!",
}

function GetSplash()
	local chooser=math.random(1,table.maxn(S))
	Splash=S[chooser]
	Splashtxt = display.newEmbossedText((Splash),0,0,"MoolBoran", 80 )
	Splashtxt.x=display.contentCenterX
	Splashtxt.y=310
	Splashtxt:setTextColor( 255, 255, 0)
	Splashtxt:toFront()
	return Splashtxt
end
	
