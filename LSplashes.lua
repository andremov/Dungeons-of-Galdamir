-----------------------------------------------------------------------------------------
--
-- Splashes.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)

local Splash
local Splashtxt
local Tip
local Tiptxt
local Tiptxt2
local S={
	"Now with splashes!",
	"Random maps!",
	"Sooner than ever!",
	"Gamma!",
	"Working Equipment!",
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
	"29 Pages of Code!",
	"35MB of Pure Gold!",
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
	"\"Originality\"!",
	"Does not steal content!",
	"Fog of war!",
	"Optimization!",
	"Overhauls!",
	"Now more greek!",
	"Splashes perfectly measured to fit!",
	"Weight!",
	"Now with more death!",
	"Lazy-compatible combat!",
	"Rooms!",
	"Blocked portals!",
	"Ceci n'est pas un splash!",
}
local T={
	{"Change your class for a different","stat bonus."},
	{"Spend your stat points wisely!"},
	{"Dexterity increases your chance of","hitting an enemy."},
	{"Stamina increases your health."},
	{"Magic increases the damage your","magical attacks cause."},
	{"Attack increases the damage your","melee attacks  cause."},
	{"Defense reduces the damage you","receive."},
	{"Intellect increases your mana and","energy."},
	{"A mob's looks and class depend on","its highest stat."},
	{"Attacking with low energy or low mana","can reduce the damage you cause."},
	{"These tips are random."},
	{"Water slows you down, allowing mobs","to follow you faster."},
	{"Keep health potions at hand."},
	{"Sorcery hits harder than regular","attacks, but require both resources."},
	{"In the pause menu you can see what","features the floor has."},
	{"Something lurks in the fog."},
	{"Avoid moving near a mob spawner."},
	{"Never forget to take the key."},
	{"The game is currently loading."},
	{"These tips are sometimes helpful."},
	{"You can change your character's class","in the options menu."},
	{"The map's looks can be changed","in the options menu."},
	{"The map's size can be changed","in the options menu."},
	{"You can check your highest scores","in the options menu."},
	{"There's a reason why the menu has no","sounds. Change the volume."},
}

function GetSplash()
	local chooser=math.random(1,table.maxn(S))
	Splash=S[chooser]
	Splashtxt = display.newEmbossedText((Splash),0,0,"MoolBoran", 75 )
	Splashtxt.x=display.contentCenterX
	Splashtxt.y=310
	Splashtxt:setTextColor( 255, 255, 0)
	Splashtxt:toFront()
	return Splashtxt
end

function GetTip()
	local chooser=math.random(1,table.maxn(T))
	Tip=T[chooser]
	local TGroup=display.newGroup()
	
	Tiptxt = display.newEmbossedText(("Tip: "..Tip[1]),0,0,"MoolBoran", 50 )
	Tiptxt.x=display.contentCenterX
	Tiptxt.y=100
	Tiptxt:setTextColor( 200, 200, 200)
	Tiptxt:toFront()
	TGroup:insert( Tiptxt )
	if (Tip[2]) then
		Tiptxt2 = display.newEmbossedText((Tip[2]),0,0,"MoolBoran", 50 )
		Tiptxt2.x=display.contentCenterX
		Tiptxt2.y=Tiptxt.y+60
		Tiptxt2:setTextColor( 200, 200, 200)
		Tiptxt2:toFront()
		TGroup:insert( Tiptxt2 )
	end
	return TGroup
end
