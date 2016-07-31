---------------------------------------------------------------------------------------
--
-- Splashes.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)
local Splash
local Splashtxt
local Tip
local Tiptxt
local Tiptxt2

local S={
	"Now with splashes!",
	"Random maps!",
	"Now released!",
	"Finally!",
	"Working Equipment!",
	"Working Inventory!",
	"Mob Racial Diversity!",
	"Item Drop Restrictions!",
	"Hardcore!",
	"Elixirs Of Doubtful Origins!",
	"Omnipotence-free!",
	"Mithril Armor!",
	"Major Bugfixing!",
	"Magical!",
	"Dodge!",
	"Charger required!",
	"Not Impossible!",
	"Improbable!",
	"Gold Ore!",
	"Mysterious Runes!",
	"Don't Panic!",
	"Item Shops!",
	"Floor taxes!",
	"Stable Releases!",
	"Balanced!",
	"Stat Boosts!",
	"Secret Items!",
	"29 Pages of Code!",
	"20MB of Pure Gold!",
	"Over 100 Items!",
	"Rings!",
	"Sorcery!",
	"Mana!",
	"Smooth!",
	"Content Heavy!",
	"Techniques!",
	"Energy!",
	"Limited Shops!",
	"Fatigue!",
	"Quests!",
	"Now with back story!",
	"You go, gurl!",
	"Plot twists!",
	"Fog of war!",
	"Optimization!",
	"Overhauls!",
	"Weight!",
	"Now with more death!",
	"Lazy-compatible combat!",
	"Rooms!",
	"Blocked portals!",
	"Now with more contrast!",
	"Expandable maps!",
	"Now with less files!",
	"Runes!",
}

local T={
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
	{"In the pause menu you can see","your floor's features."},
	{"Something lurks in the fog."},
	{"Avoid moving near a mob spawner."},
	{"Never forget to take the key."},
	{"The game is currently loading."},
	{"These tips are sometimes helpful."},
	{"The map's looks can be changed","in the options menu."},
	{"You can check your highest scores","in the options menu."},
	{"You can change the volume in the","options menu."},
	{"The game auto-saves every so often."},
}

function GetSplash()
	local chooser=math.random(1,table.maxn(S))
	Splash=S[chooser]
	Splashtxt = display.newEmbossedText((Splash),0,0,"MoolBoran", 65 )
	Splashtxt.x=display.contentCenterX
	Splashtxt.y=310
	Splashtxt:setFillColor( 1, 1, 0)
	Splashtxt:toFront()
	return Splashtxt
end

function GetTip()
	local chooser=math.random(1,table.maxn(T))
	Tip=T[chooser]
	local TGroup=display.newGroup()
	TGroup.x=display.contentCenterX
	TGroup.y=100
	
	
	Tiptxt = display.newEmbossedText(("Tip: "..Tip[1]),0,0,"MoolBoran", 50 )
	Tiptxt:toFront()
	TGroup:insert( Tiptxt )
	if (Tip[2]) then
		Tiptxt2 = display.newEmbossedText((Tip[2]),0,0,"MoolBoran", 50 )
		Tiptxt2.y=Tiptxt.y+60
		Tiptxt2:toFront()
		TGroup:insert( Tiptxt2 )
	end
	
	return TGroup
end
