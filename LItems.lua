-----------------------------------------------------------------------------------------
--
-- Items.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local inv=require("Lwindow")
local p=require("Lplayers")
local mov=require("Lmovement")
local WD=require("LProgress")
local b=require("LMapBuilder")
local q=require("LQuest")
local ui=require("LUI")
local itemlist
local equips
local items
local wahewah
local itemuse
local itemuse2
local stat1
local stat2
local stat3
local stat4
local stat5
local name
local gum
local scrolls
local PosItems
local p1

	--[[ General Data:
		Data 1: Name (text)
		Data 2: isStackable (true/false)
		Data 3: Floor Drop
		Data 4: Buy Price
	--]]
	--[[ Weapon/Armor Data:
		Data 1: Name (text)
		Data 2: Slot (number)
		Data 3: Stamina Bonus (number)
		Data 4: Attack Bonus (number)
		Data 5: Defense Bonus (number)
		Data 6: Magic Bonus (number)
		Data 7: Dexterity Bonus (number)
		Data 8: Intellect Bonus (number)
	--]]
	--[[ Consumables Use IDs:
		0 - Restore Health
		1 - Restore Mana
	--]]
	--[[ Weapon/Armor Slot IDs:
		0 - Main Hand
		1 - Off Hand
		2 - Helmet
		3 - Necklace
		4 - Chestpiece
		5 - Pantaloons
		6 - Ring
		7 - Gloves
		8 - Boots
	--]]

function Essentials()
	gum=display.newGroup()
	itemlist={
		{"HealthPotion",true,1,5},
		{"HealthPotion2",true,3,15},
		{"HealthPotion3",true,5,30},
		{"PurpleElixir",true,1,nil},
		{"GreenPotion",true,5,nil},
		{"ManaPotion",true,1,10},
		{"ManaPotion2",true,6,25},
		{"ManaPotion3",true,13,40},
		--
		{"ScrollOfCleave",false,3,100},
		{"ScrollOfFireSword",false,10,100},
		{"ScrollOfIceSword",false,16,100},
		{"ScrollOfHealing",false,12,100},
		{"ScrollOfSlow",false,5,100},
		{"ScrollOfPoison",false,7,100},
		--
		{"GemBlue",true,3,50},
		{"GemGreen",true,3,50},
		{"GemPink",true,3,50},
		{"GemRed",true,3,50},
		{"GemYellow",true,3,50},
		--
		{"UpperScroll",true,1,10},
		{"LowerScroll",true,2,10},
		{"ScrollOfSalvation",true,1,20},
		--
		{"WoodSword",false,1,10},
		{"StoneSword",false,3,20},
		{"GoldSword",false,5,20},
		{"IronSword",false,8,30},
		{"DiamondSword",false,13,nil},
		{"StoneAxe",false,3,20},
		{"GoldAxe",false,5,20},
		{"IronAxe",false,8,30},
		{"EversteelSword",false,20,nil},
		--
		{"LeatherCap",false,2,20},
		{"LeatherTunic",false,2,20},
		{"LeatherPants",false,2,20},
		{"LeatherShoes",false,2,20},
		--
		{"ChainHelm",false,5,30},
		{"ChainPlate",false,5,30},
		{"ChainLeggings",false,5,30},
		{"ChainBoots",false,5,30},
		--
		{"IronHelm",false,9,40},
		{"IronPlate",false,9,40},
		{"IronLeggings",false,9,40},
		{"IronBoots",false,9,40},
		--
		{"DiamondHelm",false,15,nil},
		{"DiamondPlate",false,15,nil},
		{"DiamondLeggings",false,15,nil},
		{"DiamondBoots",false,15,nil},
		--
		{"BronzeRing",false,1,15},
		{"BronzeRing",false,1,15},
		{"BronzeRing",false,1,15},
		{"BronzeRing",false,1,15},
		{"BronzeRing",false,1,15},
		--
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		--
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		--
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		--
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		--
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		{"IronRing",false,4,35},
		--
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		--
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		--
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		--
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		--
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		--
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		-- 
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		{"SilverRing",false,7,50},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		-- 
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
		{"GoldRing",false,13,80},
	}
	items={
		{"HealthPotion",	0,50,		"Heals for 50 Hit Points."},
		{"HealthPotion2",	0,100,		"Heals for 100 Hit Points."},
		{"HealthPotion3",	0,200,		"Heals for 200 Hit Points."},
		{"PurpleElixir",	0,-20,		"The label is teared off."},	
		{"GreenPotion",		0,-100,		"Smells funny."},
		{"ManaPotion",		1,30,		"Grants 1 Mana to every sorcery."},
		{"ManaPotion2",		1,60,		"Grants 2 Mana to every sorcery."},
		{"ManaPotion3",		1,120,		"Grants 3 Mana to every sorcery."},
	}
	scrolls={
		{"ScrollOfCleave",		"Cleave",		"Teaches the \"Cleave\" sorcery."},
		{"ScrollOfFireSword",	"Fire Sword",	"Teaches the \"Fire Sword\" sorcery."},
		{"ScrollOfIceSword",	"Ice Sword",	"Teaches the \"Ice Sword\" sorcery."},
		{"ScrollOfHealing",		"Healing",		"Teaches the \"Healing\" sorcery."},
		{"ScrollOfSlow",		"Slow",			"Teaches the \"Slow\" sorcery."},
		{"ScrollOfPoison",		"Poison Blade",	"Teaches the \"Poison Blade\" sorcery."},
	}
	gems={
		{"GemBlue",		"DEF","Glows with a blue light.\nIt seems tough to break."},
		{"GemPurple",	"MGC","Glows with a purple light.\nIt has some strange aura emanating from it."},
		{"GemPink",		"STA","Glows with a pink light.\nIt pounds faintly every once in a while."},
		{"GemRed",		"ATT","Glows with a red light.\nIt vibrates angrily every once in a while."},
		{"GemYellow",	"DEX","Glows with a yellow light.\nIt seems lightweight and sharp."},
		{"GemGreen",	"INT","Glows with a green light.\nLetters and symbols seems to spin around the orb inside."},
	}
	special={
		{"UpperScroll",			"Teleports you to an upper floor.",1},
		{"LowerScroll",			"Teleports you to a lower floor.",0},
		{"ScrollOfSalvation",	"Saves your progress.",2},
	}
	equips={					--		STA 	ATT		DEF		MGC		DEX		INT
		{"WoodSword",0,					0,		1,		0,		0,		0,		0},
		{"StoneSword",0,				0,		2,		1,		0,		0,		0},
		{"GoldSword",0,					0,		1,		2,		0,		0,		0},
		{"IronSword",0,					0,		3,		1,		0,		0,		0},
		{"DiamondSword",0,				0,		4,		1,		0,		1,		0},
		{"StoneAxe",0,					0,		2,		0,		0,		1,		0},
		{"GoldAxe",0,					0,		1,		0,		0,		2,		0},
		{"IronAxe",0,					0,		3,		0,		0,		1,		0},
		{"EversteelSword",0,				1,		5,		2,		1,		2,		1},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"LeatherCap",2,				0,		0,		0,		1,		1,		0},
		{"LeatherTunic",4,				0,		0,		0,		1,		1,		0},
		{"LeatherPants",5,				0,		0,		0,		1,		1,		0},
		{"LeatherShoes",8,				0,		0,		0,		1,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"ChainHelm",2,					0,		0,		1,		1,		1,		0},
		{"ChainPlate",4,				0,		0,		0,		2,		1,		0},
		{"ChainLeggings",5,				0,		0,		0,		2,		1,		0},
		{"ChainBoots",8,				0,		0,		0,		2,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"IronHelm",2,					0,		0,		1,		3,		0,		0},
		{"IronPlate",4,					0,		0,		0,		4,		0,		0},
		{"IronLeggings",5,				0,		0,		0,		4,		0,		0},
		{"IronBoots",8,					0,		0,		0,		3,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"DiamondHelm",2,				0,		0,		1,		4,		0,		0},
		{"DiamondPlate",4,				1,		0,		0,		4,		0,		0},
		{"DiamondLeggings",5,			1,		0,		0,		4,		0,		0},
		{"DiamondBoots",8,				0,		0,		0,		4,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"BronzeRing",6,				1,		0,		0,		0,		0,		0},
		{"BronzeRing",6,				0,		1,		0,		0,		0,		0},
		{"BronzeRing",6,				0,		0,		1,		0,		0,		0},
		{"BronzeRing",6,				0,		0,		0,		1,		0,		0},
		{"BronzeRing",6,				0,		0,		0,		0,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"IronRing",6,					2,		0,		0,		0,		0,		0},
		{"IronRing",6,					1,		1,		0,		0,		0,		0},
		{"IronRing",6,					1,		0,		1,		0,		0,		0},
		{"IronRing",6,					1,		0,		0,		1,		0,		0},
		{"IronRing",6,					1,		0,		0,		0,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"IronRing",6,					1,		1,		0,		0,		0,		0},
		{"IronRing",6,					0,		2,		0,		0,		0,		0},
		{"IronRing",6,					0,		1,		1,		0,		0,		0},
		{"IronRing",6,					0,		1,		0,		1,		0,		0},
		{"IronRing",6,					0,		1,		0,		0,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"IronRing",6,					1,		0,		1,		0,		0,		0},
		{"IronRing",6,					0,		1,		1,		0,		0,		0},
		{"IronRing",6,					0,		0,		2,		0,		0,		0},
		{"IronRing",6,					0,		0,		1,		1,		0,		0},
		{"IronRing",6,					0,		0,		1,		0,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"IronRing",6,					1,		0,		0,		1,		0,		0},
		{"IronRing",6,					0,		1,		0,		1,		0,		0},
		{"IronRing",6,					0,		0,		1,		1,		0,		0},
		{"IronRing",6,					0,		0,		0,		2,		0,		0},
		{"IronRing",6,					0,		0,		0,		1,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"IronRing",6,					1,		0,		0,		0,		1,		0},
		{"IronRing",6,					0,		1,		0,		0,		1,		0},
		{"IronRing",6,					0,		0,		1,		0,		1,		0},
		{"IronRing",6,					0,		0,		0,		1,		1,		0},
		{"IronRing",6,					0,		0,		0,		0,		2,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"SilverRing",6,				1,		0,		0,		1,		1,		0},
		{"SilverRing",6,				1,		1,		0,		0,		1,		0},
		{"SilverRing",6,				1,		0,		1,		0,		1,		0},
		{"SilverRing",6,				0,		0,		1,		1,		1,		0},
		{"SilverRing",6,				0,		1,		0,		1,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"SilverRing",6,				1,		0,		1,		1,		0,		0},
		{"SilverRing",6,				1,		1,		0,		1,		0,		0},
		{"SilverRing",6,				1,		1,		1,		0,		0,		0},
		{"SilverRing",6,				0,		1,		1,		1,		0,		0},
		{"SilverRing",6,				0,		1,		1,		0,		1},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"SilverRing",6,				3,		0,		0,		0,		0,		0},
		{"SilverRing",6,				1,		2,		0,		0,		0,		0},
		{"SilverRing",6,				1,		0,		2,		0,		0,		0},
		{"SilverRing",6,				1,		0,		0,		2,		0,		0},
		{"SilverRing",6,				1,		0,		0,		0,		2,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"SilverRing",6,				2,		1,		0,		0,		0,		0},
		{"SilverRing",6,				0,		3,		0,		0,		0,		0},
		{"SilverRing",6,				0,		1,		2,		0,		0,		0},
		{"SilverRing",6,				0,		1,		0,		2,		0,		0},
		{"SilverRing",6,				0,		1,		0,		0,		2,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"SilverRing",6,				2,		0,		0,		1,		0,		0},
		{"SilverRing",6,				0,		2,		0,		1,		0,		0},
		{"SilverRing",6,				0,		0,		2,		1,		0,		0},
		{"SilverRing",6,				0,		0,		0,		3,		0,		0},
		{"SilverRing",6,				0,		0,		0,		1,		2,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"SilverRing",6,				2,		0,		1,		0,		0,		0},
		{"SilverRing",6,				0,		2,		1,		0,		0,		0},
		{"SilverRing",6,				0,		0,		3,		0,		0,		0},
		{"SilverRing",6,				0,		0,		1,		2,		0,		0},
		{"SilverRing",6,				0,		0,		1,		0,		2,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"SilverRing",6,				2,		0,		0,		0,		1,		0},
		{"SilverRing",6,				0,		2,		0,		0,		1,		0},
		{"SilverRing",6,				0,		0,		2,		0,		1,		0},
		{"SilverRing",6,				0,		0,		0,		2,		1,		0},
		{"SilverRing",6,				0,		0,		0,		0,		3,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					2,		0,		0,		1,		1,		0},
		{"GoldRing",6,					2,		0,		1,		0,		1,		0},
		{"GoldRing",6,					2,		1,		0,		0,		1,		0},
		{"GoldRing",6,					2,		0,		1,		1,		0,		0},
		{"GoldRing",6,					2,		1,		1,		0,		0,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					2,		1,		0,		1,		0,		0},
		{"GoldRing",6,					1,		2,		0,		1,		0,		0},
		{"GoldRing",6,					1,		2,		0,		0,		1,		0},
		{"GoldRing",6,					1,		2,		1,		0,		0,		0},
		{"GoldRing",6,					0,		2,		1,		0,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					0,		2,		0,		1,		1,		0},
		{"GoldRing",6,					0,		2,		1,		1,		0,		0},
		{"GoldRing",6,					1,		1,		2,		0,		0,		0},
		{"GoldRing",6,					1,		0,		2,		1,		0,		0},
		{"GoldRing",6,					1,		0,		2,		0,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					0,		0,		2,		1,		1,		0},
		{"GoldRing",6,					0,		1,		2,		1,		0,		0},
		{"GoldRing",6,					0,		1,		2,		0,		1,		0},
		{"GoldRing",6,					1,		0,		2,		1,		0,		0},
		{"GoldRing",6,					0,		0,		1,		2,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					0,		1,		0,		2,		1,		0},
		{"GoldRing",6,					0,		1,		1,		2,		0,		0},
		{"GoldRing",6,					1,		1,		0,		2,		0,		0},
		{"GoldRing",6,					1,		0,		1,		2,		0,		0},
		{"GoldRing",6,					1,		0,		0,		2,		1,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					0,		0,		1,		1,		2,		0},
		{"GoldRing",6,					0,		1,		0,		1,		2,		0},
		{"GoldRing",6,					0,		1,		1,		0,		2,		0},
		{"GoldRing",6,					1,		1,		0,		0,		2,		0},
		{"GoldRing",6,					1,		0,		1,		0,		2,		0},
		{"GoldRing",6,					1,		0,		0,		1,		2,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					0,		1,		1,		1,		1,		0},
		{"GoldRing",6,					1,		0,		1,		1,		1,		0},
		{"GoldRing",6,					1,		1,		0,		1,		1,		0},
		{"GoldRing",6,					1,		1,		1,		0,		1,		0},
		{"GoldRing",6,					1,		1,		1,		1,		0,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					4,		0,		0,		0,		0,		0},
		{"GoldRing",6,					1,		3,		0,		0,		0,		0},
		{"GoldRing",6,					1,		0,		3,		0,		0,		0},
		{"GoldRing",6,					1,		0,		0,		3,		0,		0},
		{"GoldRing",6,					1,		0,		0,		0,		3,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					3,		1,		0,		0,		0,		0},
		{"GoldRing",6,					0,		4,		0,		0,		0,		0},
		{"GoldRing",6,					0,		1,		3,		0,		0,		0},
		{"GoldRing",6,					0,		1,		0,		3,		0,		0},
		{"GoldRing",6,					0,		1,		0,		0,		3,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					3,		0,		1,		0,		0,		0},
		{"GoldRing",6,					0,		3,		1,		0,		0,		0},
		{"GoldRing",6,					0,		0,		4,		0,		0,		0},
		{"GoldRing",6,					0,		0,		1,		3,		0,		0},
		{"GoldRing",6,					0,		0,		1,		0,		3,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					3,		0,		0,		1,		0,		0},
		{"GoldRing",6,					0,		3,		0,		1,		0,		0},
		{"GoldRing",6,					0,		0,		3,		1,		0,		0},
		{"GoldRing",6,					0,		0,		0,		4,		0,		0},
		{"GoldRing",6,					0,		0,		0,		1,		3,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					3,		0,		0,		0,		1,		0},
		{"GoldRing",6,					0,		3,		0,		0,		1,		0},
		{"GoldRing",6,					0,		0,		3,		0,		1,		0},
		{"GoldRing",6,					0,		0,		0,		3,		1,		0},
		{"GoldRing",6,					0,		0,		0,		0,		4,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					2,		2,		0,		0,		0,		0},
		{"GoldRing",6,					2,		0,		2,		0,		0,		0},
		{"GoldRing",6,					2,		0,		0,		2,		0,		0},
		{"GoldRing",6,					2,		0,		0,		0,		2,		0},
		{"GoldRing",6,					0,		0,		0,		2,		2,		0},
		--								STA 	ATT		DEF		MGC		DEX		INT
		{"GoldRing",6,					0,		0,		2,		0,		2,		0},
		{"GoldRing",6,					0,		2,		0,		0,		2,		0},
		{"GoldRing",6,					0,		2,		2,		0,		0,		0},
		{"GoldRing",6,					0,		2,		0,		2,		0,		0},
		{"GoldRing",6,					0,		0,		2,		2,		0,		0},
		{"GoldRing",6,					0,		0,		2,		2,		0,		0},
	}
end

function ItemDrop(boost)
	local roll=math.random(1, 100)
	local CurRound=WD.Circle()
	p1=p.GetPlayer()
	PosItems={}
	for i=1,table.maxn(itemlist) do
		if (itemlist[i][3]) and itemlist[i][3]<=CurRound then
			PosItems[#PosItems+1]=i
		end
	end
	if roll>=55 or boost==true then
		local CurQuest,ItemName=q.ReturnQuest()
		if (CurQuest) and CurQuest==2 then
		
			q.UpdateQuest("itm")
			gum:toFront()
			local window=display.newImageRect("usemenu.png", 768, 308)
			window.x,window.y = display.contentWidth/2, 450
			gum:insert( window )
			
			function Backbtn()
				for i=gum.numChildren,1,-1 do
					local child = gum[i]
					child.parent:remove( child )
				end
				mov.ShowArrows()
			end
			
			local lolname=display.newText( ("Item Get!") ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gum:insert( lolname )
			
			local lolname2=display.newText( (ItemName) ,0,0,"Game Over",85)
			lolname2:setTextColor( 180, 180, 180)
			lolname2.x=display.contentWidth/2
			lolname2.y=(display.contentHeight/2)-80
			gum:insert( lolname2 )
			
			local backbtn= widget.newButton{
				label="Accept",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = Backbtn}
			backbtn:setReferencePoint( display.CenterReferencePoint )
			backbtn.x = (display.contentWidth/2)
			backbtn.y = (display.contentHeight/2)+30
			gum:insert( backbtn )
			
			
			return true
		else
			local choose=math.random(1,(table.maxn(PosItems)))
			inv.AddItem((PosItems[choose]),itemlist[(PosItems[choose])][2])
			asdname=itemlist[(PosItems[choose])][1]
			
			gum:toFront()
			local window=display.newImageRect("usemenu.png", 768, 308)
			window.x,window.y = display.contentWidth/2, 450
			gum:insert( window )
			
			function Backbtn()
				for i=gum.numChildren,1,-1 do
					local child = gum[i]
					child.parent:remove( child )
				end
				mov.ShowArrows()
			end
			
			function Bagbtn()
				for i=gum.numChildren,1,-1 do
					local child = gum[i]
					child.parent:remove( child )
				end
				ui.Pause()
				inv.ToggleBag()
			end
			
			local lolname=display.newText( ("Item Get!") ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gum:insert( lolname )
			
			local lolname2=display.newText( (asdname) ,0,0,"Game Over",85)
			lolname2:setTextColor( 180, 180, 180)
			lolname2.x=display.contentWidth/2
			lolname2.y=(display.contentHeight/2)-80
			gum:insert( lolname2 )
			
			local backbtn= widget.newButton{
				label="Accept",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = Backbtn}
			backbtn:setReferencePoint( display.CenterReferencePoint )
			backbtn.x = (display.contentWidth/2)-105
			backbtn.y = (display.contentHeight/2)+30
			gum:insert( backbtn )
			
			local bagbtn= widget.newButton{
				label="Open Bag",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = Bagbtn}
			bagbtn:setReferencePoint( display.CenterReferencePoint )
			bagbtn.x = (display.contentWidth/2)+105
			bagbtn.y = (display.contentHeight/2)+30
			gum:insert( bagbtn )
			
			return true
		end
	end
end

function OneHundredPercent()
	return itemlist, equips, items
end

function ShopStock(val,id)
	if val==0 then
		local CurRound=WD.Circle()
		PosItems={}
		for i=1,table.maxn(itemlist) do
			if (itemlist[i][3]) and (itemlist[i][4]) and itemlist[i][3]<=(CurRound) then
				PosItems[#PosItems+1]=i
			end
		end
		return PosItems
	end
	if val==1 then
		for i=1,table.maxn(itemlist) do
			if (itemlist[i]) and i==id then
				local size=b.GetData(0)
				local prc=((math.sqrt(size))/5)*itemlist[i][4]
				return itemlist[i][1],prc
			end
		end
	
	end
end

function ReturnInfo(id,wachuwah)
	if wachuwah==0 then
		wahewah=(itemlist[id][1])
		return wahewah
	elseif wachuwah==1 then
		wahewah=(scrolls[id][2])
		return wahewah
	elseif wachuwah==2 then
		wahewah=(gems[id][2])
		return wahewah
	elseif wachuwah==3 then
		wahewah=(itemlist[id][2])
		return wahewah
	elseif wachuwah==4 then
		if id<=8 then
				wahewah=0
				name=(items[id][1])
				itemuse=(items[id][2])
				stat1=(items[id][3])
				stat2=(items[id][4])
				return wahewah,name,itemuse,stat1,stat2
		elseif id<=14 then
			wahewah=3
			name=(scrolls[id-8][1])
			itemuse=(scrolls[id-8][2])
			stat1=(scrolls[id-8][3])
			return wahewah,name,itemuse,stat1
		elseif id<=19 then
			wahewah=4
			name=(gems[id-14][1])
			stat1=(gems[id-14][2])
			stat2=(gems[id-14][3])
			return wahewah,name,stat1,stat2
		elseif id<=22 then
			wahewah=2
			name=(special[id-19][1])
			stat1=(special[id-19][2])
			stat2=(special[id-19][3])
			return wahewah,name,stat1,stat2
		else
			wahewah=1
			name=(equips[id-22][1])
			itemuse=(equips[id-22][2])
			stat1=(equips[id-22][3])
			stat2=(equips[id-22][4])
			stat3=(equips[id-22][5])
			stat4=(equips[id-22][6])
			stat5=(equips[id-22][7])
			stat6=(equips[id-22][8])
			return wahewah,name,itemuse,stat1,stat2,stat3,stat4,stat5,stat6
		end
	end
end