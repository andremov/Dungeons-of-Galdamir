---------------------------------------------------------------------------------------
--
-- player.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)
local player

local function readAnims(animname)
	local JSON = require("JSON")
	-- call JSON read func to receive lua table with JSON info
	-- adapt JSON info for ease of access
	
	filename = system.pathForFile( animname )
	file = assert(io.open(filename, "r"))
	-- file = assert(love.filesystem.load(animname, "r"))
	
	-- use JSON library to decode it to a LUA table
	-- then return table
	
	-- local output = J:decode(file:read("*all"))
	local output = JSON:decode(file:read("*all"))
	
	output=output["Animations"]["Animation"]
	
	-- arrange JSON info to a better array
	-- i used for id of animation
	-- first name is animation name
	-- animation subdivision -> parts
	-- part name is asset name
	-- for every frame of animation, save asset info
	-- x, y, scaleX, scaleY, rotation, depth
	-- depth is layering, who is in front of who
	-- then arrange color matrix to regular RGBA channels
	parsed={}
	for i=1,table.maxn(output) do
		local nameofsequence=output[i]["-name"]
		parsed[nameofsequence] = {}
		parsed[nameofsequence]["maxframes"]=tonumber(output[i]["-frameCount"])
		for j=1,table.maxn(output[i]["Part"]) do
			local nameofasset=output[i]["Part"][j]["-name"]
			parsed[nameofsequence][nameofasset]={}
			for k=1,table.maxn(output[i]["Part"][j]["Frame"]) do
				parsed[nameofsequence][nameofasset][k]={}
				parsed[nameofsequence][nameofasset][k]["x"]=tonumber(output[i]["Part"][j]["Frame"][k]["-x"])
				parsed[nameofsequence][nameofasset][k]["y"]=tonumber(output[i]["Part"][j]["Frame"][k]["-y"])
				parsed[nameofsequence][nameofasset][k]["scaleX"]=tonumber(output[i]["Part"][j]["Frame"][k]["-scaleX"])
				parsed[nameofsequence][nameofasset][k]["scaleY"]=tonumber(output[i]["Part"][j]["Frame"][k]["-scaleY"])
				parsed[nameofsequence][nameofasset][k]["rotation"]=tonumber(output[i]["Part"][j]["Frame"][k]["-rotation"])
				parsed[nameofsequence][nameofasset][k]["depth"]=tonumber(output[i]["Part"][j]["Frame"][k]["-depth"])
				
				
				local b=output[i]["Part"][j]["Frame"][k]["-colorMatrix"]
				local a={}
				local cont=0
				for word in string.gmatch(b,"%d+") do
					a[cont]=word
					cont=cont+1
				end
				
				local colorArray={}
				colorArray[1] = a[00] + a[01] + a[02] + a[03] + a[04]
				colorArray[2] = a[05] + a[06] + a[07] + a[08] + a[09]
				colorArray[3] = a[10] + a[11] + a[12] + a[13] + a[14]
				colorArray[4] = a[15] + a[16] + a[17] + a[18] + a[19]
				
				parsed[nameofsequence][nameofasset][k]["colors"]=colorArray
			end
		end
		-- for cycling purposes:
		parsed[i]=parsed[nameofsequence]
	end
		parsed["IDLE"]["loop"]=true
		parsed["WALK"]["loop"]=true
		parsed["SWING"]["loop"]=false
	for i=1,table.maxn(parsed) do
		parsed[i]["DEFAULTTIME"]=0.8
		parsed[i]["TIME"]=0.8
	end
	
	return parsed
end

function CreatePlayer(name)
	if not(player) then
		local physics = require "physics"
		local names={
			-- "Nameless",
			-- "Orphan",
			-- "Smith",
			-- "Slave",
			-- "Hctib",
			"Barry"
		}
		
		-- Essentials
		player=display.newGroup()
		player.x, player.y = display.contentWidth/2, display.contentHeight/2
		player.name="TEST NAME FOR TESTING"
		
		-- Map Essentials
		player["MAPX"]=0
		player["MAPY"]=0
		player["QUAD"]=1
		player["CURY"]=2
		player["CURX"]=0
		
		-- Animation Essentials
		player["SEQUENCE"]="IDLE"
		player["CURFRAME"]=1
		player["TIME"]=1
		player["LASTTIME"]=0
		player["SCALE"]=1
		player["COMBAT"]=false
		player["ANIMATIONS"]=readAnims('Barry/BarryAnim.json')
		
		
		-- Animation Functions
		player.saturation=function()
			for i=1,player["ASSETS"]["COLOR"].numChildren do
				if player["TIME"]>=2.5 then
					player["ASSETS"]["COLOR"][i].fill.effect.intensity = -3.75
				elseif (player["TIME"]>1) and player["TIME"]<2.5 then
					player["ASSETS"]["COLOR"][i].fill.effect.intensity = player["TIME"]*(1-player["TIME"])
				elseif (player["TIME"]<1) then
					if (1-player["TIME"])*2>1 then
						player["ASSETS"]["COLOR"][i].fill.effect.intensity = 1
					else
						player["ASSETS"]["COLOR"][i].fill.effect.intensity = (1-player["TIME"])*2
					end
				else
					player["ASSETS"]["COLOR"][i].fill.effect.intensity = 0
				end
			end
			player["LASTTIME"]=player["TIME"]
		end
		player.refresh=function()
			local asd=player["ANIMATIONS"][player["SEQUENCE"]]["TIME"]
			asd=asd*player["TIME"]
			player["CURFRAME"]=player["CURFRAME"]+(asd)
			if player["CURFRAME"]>=player["ANIMATIONS"][player["SEQUENCE"]].maxframes then
				if player["ANIMATIONS"][player["SEQUENCE"]].loop==true then
					player["CURFRAME"]=1
				elseif player["ANIMATIONS"][player["SEQUENCE"]].loop==false then
					player["CURFRAME"]=1
					player["SEQUENCE"]="IDLE"
				end
			end
			
			for t=1,table.maxn(player["COPIES"]) do
				for i=1,player["ASSETS"][player["COPIES"][t]].numChildren do
					local curlimb=player["ASSETS"][player["COPIES"][t]][i]
					local currentframe=player["CURFRAME"]
					local flooredframe=math.floor(currentframe)
					
					local x=player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe].x + ( (player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe+1].x - player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe].x) * (currentframe-flooredframe) )
					
					local y=player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe].y + ( (player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe+1].y - player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe].y) * (currentframe-flooredframe) )
					
					local r=player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe].rotation + ( (player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe+1].rotation - player["ANIMATIONS"][player["SEQUENCE"]][curlimb.name][flooredframe].rotation) * (currentframe-flooredframe) )
					
					x=x*(player["SCALE"]/0.5)
					y=y*(player["SCALE"]/0.5)
					
					curlimb.x = (x)
					curlimb.y = (y)
					curlimb.rotation = (r)
					
					if player["COPIES"][t]=="COLOR" and curlimb.name=="Body" then
						player["ASSETS"]["COLOR"].maskX=curlimb.x
						player["ASSETS"]["COLOR"].maskY=curlimb.y
					end
				end
			end
			if player["TIME"] ~= player["LASTTIME"] then
				player:saturation()
			end
			-- player.shadow:toBack()
			player:regeneration()
			
			player.x=player["shadow"].x
			player.y=player["shadow"].y
			
			player["WEAPON"]["basedamage"]=player["STATS"]["Damage"]
		
			-- timer.performWithDelay(20,player.refresh)
		end
		player.turn=function()
			if player.xScale==1 then
				player.xScale=-1
			else
				player.xScale=1
			end
		end
		player.setSequence=function(self,value,side)
			side=side or self.xScale
			if self["SEQUENCE"]~=value then
				self["CURFRAME"]=1
				self["SEQUENCE"]=value
			end
			if self.xScale~=side then
				self.turn()
			end
		end
		
		-- Modify Health/Mana/Energy Functions
		player.ModifyHealth=function(self,amount,cause)
			self["STATS"]["Health"] = self["STATS"]["Health"] + amount
			-- a.Play(5)
			
			if self["STATS"]["Health"] <= 0 then
				self["STATS"]["Health"] = 0
				-- ui.DeathMenu(cause)
			elseif self["STATS"]["Health"]>self["STATS"]["MaxHealth"] then
				self["STATS"]["Health"]=self["STATS"]["MaxHealth"]
			end
			
			local healthpercent=self["STATS"]["Health"]/self["STATS"]["MaxHealth"]
			healthpercent=(healthpercent*1.5)+0.01
			self["ASSETS"]["COLOR"].maskScaleX=healthpercent
			self["ASSETS"]["COLOR"].maskScaleY=healthpercent
			
		end
		player.ModifyMana=function(self,amount)
			self["STATS"]["Mana"] = self["STATS"]["Mana"] + amount
			-- a.Play(5)
			
			if self["STATS"]["Mana"] <= 0 then
				self["STATS"]["Mana"] = 0
			elseif self["STATS"]["Mana"]>self["STATS"]["MaxMana"] then
				self["STATS"]["Mana"]=self["STATS"]["MaxMana"]
			end
			
			local manapercent=self["STATS"]["Mana"]/self["STATS"]["MaxMana"]
			-- self["ASSETS"]["PURPLE"]:setFillColor(0.6,0,1.0,manapercent+0.2)
			manapercent=(manapercent*0.5)
			self["ASSETS"]["PURPLE"].yScale=1.0+manapercent
			self["ASSETS"]["PURPLE"].xScale=1.0+manapercent
		end
		player.ModifyEnergy=function(self,amount)
			self["STATS"]["Energy"] = self["STATS"]["Energy"] + amount
			-- a.Play(5)
			
			if self["STATS"]["Energy"] <= 0 then
				self["STATS"]["Energy"] = 0
			elseif self["STATS"]["Energy"]>self["STATS"]["MaxEnergy"] then
				self["STATS"]["Energy"]=self["STATS"]["MaxEnergy"]
			end
			
			local energypercent=self["STATS"]["Energy"]/self["STATS"]["MaxEnergy"]
			for i=2, table.maxn(self["ANIMATIONS"]) do
				self["ANIMATIONS"][i]["TIME"]=self["ANIMATIONS"][i]["DEFAULTTIME"]*0.4
				local asd=self["ANIMATIONS"][i]["DEFAULTTIME"]*0.6
				asd=asd*energypercent
				self["ANIMATIONS"][i]["TIME"]=self["ANIMATIONS"][i]["TIME"]+(asd)
			end
			
			-- FOR IDLE
			self["ANIMATIONS"]["IDLE"]["TIME"]=self["ANIMATIONS"]["IDLE"]["DEFAULTTIME"]
			local asd=self["ANIMATIONS"]["IDLE"]["DEFAULTTIME"]*0.6
			asd=asd*energypercent
			self["ANIMATIONS"]["IDLE"]["TIME"]=self["ANIMATIONS"]["IDLE"]["TIME"]-(asd)
		end

		-- Other Functions (?)
		player.regeneration=function()			
			if player["COMBAT"]==false then
				local sliver=0.001*player["TIME"]
				local he=sliver*player["STATS"]["MaxHealth"]
				local ma=(sliver*1.5)*player["STATS"]["MaxHealth"]
				local en=(sliver*4)*player["STATS"]["MaxHealth"]
				
				player:ModifyHealth(he)
				player:ModifyMana(ma)
				player:ModifyEnergy(en)
			end
		end
		player.StatBoost=function(stat)
			assert(false,"Calling 'StatBoost' function, not done yet.")
			-- player.bst[stat]=player.bst[stat]+1
			-- StatCheck()
		end
		player.Natural=function(statnum,amnt)
			assert(false,"Calling 'Natural' function, not done yet.")
			-- player.nat[statnum]=player.nat[statnum]+amnt
			-- player.pnts=player.pnts-(amnt)
			-- StatCheck()
		end
		player.ModStats=function(con,dex,str,mgc,sta,int,arm)
			assert(false,"Calling 'ModStats' function, not done yet.")
			-- player.eqs[1]=player.eqs[1]+con
			-- player.eqs[2]=player.eqs[2]+dex
			-- player.eqs[3]=player.eqs[3]+str
			-- player.eqs[4]=player.eqs[4]+mgc
			-- player.eqs[5]=player.eqs[5]+sta
			-- player.eqs[6]=player.eqs[6]+int
			-- player.armor=player.armor+arm
			-- StatCheck()
		end
		player.LearnSorcery=function(id)
			assert(false,"Calling 'LearnSorcery' function, not done yet.")
			-- player.["SPELLS"][id][3]=true
		end
		player.generateStats=function()
		
			local statnames={"Constitution","Dexterity","Strength","Talent","Stamina","Intellect"	}
			local statdescrip={"Physical state of the body as to health.","Skill using hands or body, mental skill and cleverness.","Muscular or bodily power.","Magical or mental power.","Power to endure fatigue.","Capacity for thought or knowledge."}
			for s=1,table.maxn(statnames) do
				player["STATS"][s]["NAME"]=thisstat
				player["STATS"][s]["ID"]=s
				player["STATS"][s]["DESCRIPTION"]=statdescrip[s]
				player["STATS"][s]["TOTAL"]=player["STATS"][s]["EQUIP"] + player["STATS"][s]["NATURAL"] + player["STATS"][s]["BOOST"]
				local thisstat=statnames[s]
				player["STATS"][thisstat]=player["STATS"][s]
			end
			player["INVENTORY"]["SLOTS"]=12
			
			player["STATS"]["MaxHealth"]=(10*player["STATS"]["Level"])+(player["STATS"]["Constitution"]["TOTAL"]*20)
			
			player["STATS"]["MaxMana"]=(5*player["STATS"]["Level"])+(player["STATS"]["Intellect"]["TOTAL"]*10)
			
			player["STATS"]["MaxEnergy"]=(5*player["STATS"]["Level"])+(player["STATS"]["Stamina"]["TOTAL"]*10)
			
			player["STATS"]["MaxExperience"]=50
			
			-- player["STATS"]["Weight"]
		end
		
		-- Assets Essentials
		player["ASSETS"]={}
		local limbnames={
			"RightArm","Sword","Groin", "RightLeg","LeftLeg", "Body",  "LeftArm", "Face", "Hair", "Shield",
		}
		player["COPIES"]={
			"PURPLE",
			"B&W",
			"COLOR"
		}
		for t=1,table.maxn(player["COPIES"]) do
			-- print ("STARTING WITH "..player["COPIES"][t])
			player["ASSETS"][player["COPIES"][t]]=display.newGroup()
			player["ASSETS"][player["COPIES"][t]].setFillColor=function (self,r,g,b,a)
				local acceptableparams=( (r) and (r>=0) and (r<=1) )
				acceptableparams=acceptableparams and ( (g) and (g>=0) and (g<=1) )
				acceptableparams=acceptableparams and ( (b) and (b>=0) and (b<=1) )
				if (acceptableparams) then
					a=a or 1
					for i=self.numChildren,1,-1 do
						local child = self[i]
						child:setFillColor(r,g,b,a)
					end
				else
					assert(false, "Invalid color parameters.")
				end
			end
			for i=1,table.maxn(limbnames) do
				local thislimb=display.newImage("Barry/blue/"..limbnames[i]..".png")
				thislimb.name=limbnames[i]
				if player["COPIES"][t]=="B&W" and limbnames[i]=="Sword" then
					player["WEAPON"]=thislimb
				end
				player["ASSETS"][player["COPIES"][t]]:insert(thislimb)
			end
			player:insert(player["ASSETS"][player["COPIES"][t]])
			if player["COPIES"][t]=="PURPLE" then
				player["ASSETS"][player["COPIES"][t]]:setFillColor(0.6,0,1.0,0.6)
				player["ASSETS"][player["COPIES"][t]].xScale=1.5
				player["ASSETS"][player["COPIES"][t]].yScale=1.5
				for i=1,player["ASSETS"][player["COPIES"][t]].numChildren do
					local thislimb=player["ASSETS"][player["COPIES"][t]][i]
					thislimb.fill.effect = "filter.scatter"
					thislimb.fill.effect.intensity = 0.25
				end
			elseif player["COPIES"][t]=="B&W" then
				for i=1,player["ASSETS"][player["COPIES"][t]].numChildren do
					local thislimb=player["ASSETS"][player["COPIES"][t]][i]
					thislimb.fill.effect = "filter.grayscale"
				end
			elseif player["COPIES"][t]=="COLOR" then
				local mask = graphics.newMask( "ui/circlemask.png" )
				player["ASSETS"][player["COPIES"][t]]:setMask(mask)
				player["ASSETS"][player["COPIES"][t]].maskScaleX=1.5
				player["ASSETS"][player["COPIES"][t]].maskScaleY=1.5
				for i=1,player["ASSETS"][player["COPIES"][t]].numChildren do
					local thislimb=player["ASSETS"][player["COPIES"][t]][i]
					thislimb.fill.effect = "filter.desaturate"
					thislimb.fill.effect.intensity = 0
				end
			end
			-- print ("FINISHED WITH "..player["COPIES"][t])
			player["ASSETS"][player["COPIES"][t]]:toFront()
		end
		
		-- Shadow Essentials
		player["shadow"]=display.newImageRect("Barry/Shadow.png",103,17)
		player["shadow"].x,player["shadow"].y=player.x,player.y
		player["shadow"].anchorY=0.2
		player["shadow"].category="player"
		local shade={ -51,-8, 51,-8, 51,8, -51,8}
		physics.addBody(player["shadow"],"dynamic",{shape=shade,filter={categoryBits=2,maskBits=7}})
		player["shadow"].isFixedRotation=true
		player["shadow"].parent=player
		player["shadow"].name="shadow"
		player:insert(player["shadow"])
		
		player["HitBox"]=display.newRect(0,-75,90,150)
		player["HitBox"]:setFillColor(0,0,1,0)
		player:insert(player["HitBox"])
		
		-- Trackables
		player["GOLD"]=0
		player["EQUIPMENT"]={  }
		player["INVENTORY"]={ { ID=1,AMOUNT=10},{ ID=33,AMOUNT=1},{ ID=41,AMOUNT=1},}
		player["INVENTORY"]["SLOTS"]=12
		-- player.weapon="unarmed"
		-- player.keys=0
		
		-- Questing
		player["QUESTS"]={
		
		}
		
		-- Spells & Abilities
		player["SPELLS"]={
			-- {"Gouge","Place a deep wound on the enemy target.",true,9,13},
			-- {"Fireball","Cast a firey ball of death and burn the enemy.",true,16,7},
			-- {"Cleave","Hits for twice maximum damage. Can't be evaded.",false,5,13},
			-- {"Slow","Reduces enemy's dexterity.",false,28,5},
			-- {"Poison Blade","Inflicts poison.",false,16,19},
			-- {"Fire Sword","Hits for twice damage and inflicts a burn.",false,26,37},
			-- {"Healing","Heals for 20% of your maximum health.",false,58,4},
			-- {"Ice Spear","Hits for twice damage and reduces enemy's dexterity.",false,51,46},
		}
		
		-- Stats
		player["STATS"]={}
		player["STATS"]["Free"]=7
		local statnames={"Constitution","Dexterity","Strength","Talent","Stamina","Intellect"	}
		local statdescrip={"Physical state of the body as to health.","Skill using hands or body, mental skill and cleverness.","Muscular or bodily power.","Magical or mental power.","Power to endure fatigue.","Capacity for thought or knowledge."}
		for s=1,table.maxn(statnames) do
			local thisstat=statnames[s]
			player["STATS"][thisstat]={}
			player["STATS"][thisstat]["NAME"]=thisstat
			player["STATS"][thisstat]["ID"]=s
			player["STATS"][thisstat]["DESCRIPTION"]=statdescrip[s]
			player["STATS"][thisstat]["EQUIP"]=0
			player["STATS"][thisstat]["NATURAL"]=2
			player["STATS"][thisstat]["BOOST"]=0
			player["STATS"][thisstat]["TOTAL"]=player["STATS"][thisstat]["EQUIP"] + player["STATS"][thisstat]["NATURAL"] + player["STATS"][thisstat]["BOOST"]
			-- just in case, cycles:
			player["STATS"][s]=player["STATS"][thisstat]
		end
		
		-- Leveling
		player["STATS"]["Level"]=1
		player["STATS"]["MaxExperience"]=50
		player["STATS"]["Experience"]=0
		
		--Secondary Stats
		-- player.portcd=0
		if name=="" or name==" " then
			name=nil
		end
		player["NAME"]=name or names[math.random(1,table.maxn(names))]
		player["STATS"]["Armor"]=0
		player["STATS"]["Weight"]=5
		player["STATS"]["Speed"]=1.00
		player["STATS"]["Damage"]=10
		
		player["STATS"]["MaxHealth"]=(10*player["STATS"]["Level"])+(player["STATS"]["Constitution"]["TOTAL"]*20)
		player["STATS"]["Health"]=player["STATS"]["MaxHealth"]
		
		player["STATS"]["MaxMana"]=(5*player["STATS"]["Level"])+(player["STATS"]["Intellect"]["TOTAL"]*10)
		player["STATS"]["Mana"]=player["STATS"]["MaxMana"]
		
		player["STATS"]["MaxEnergy"]=(5*player["STATS"]["Level"])+(player["STATS"]["Stamina"]["TOTAL"]*10)
		player["STATS"]["Energy"]=player["STATS"]["MaxEnergy"]
	-- player.SPD=(1.00-(player.stats[2]/100))
		-- player:refresh()
		Runtime:addEventListener("enterFrame",player.refresh)
	end
	return player
end



