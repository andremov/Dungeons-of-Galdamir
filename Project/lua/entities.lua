---------------------------------------------------------------------------------------
--
-- entities.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)

local function readAnims(animname)
	-- # OPENING
	-- DEPENDENCIES
	local JSON = require("lua.json")
	-- FORWARD CALLS
	local output
	local nameofsequence
	local nameofasset
	local b
	local a
	local cont
	local colorArray
	-- LOCAL FUNCTIONS
	
	-- # BODY
	-- call JSON read func to receive lua table with JSON info
	-- adapt JSON info for ease of access
	
	filename = system.pathForFile( animname )
	file = assert(io.open(filename, "r"))
	-- file = assert(love.filesystem.load(animname, "r"))
	
	-- use JSON library to decode it to a LUA table
	-- then return table
	
	-- local output = J:decode(file:read("*all"))
	output = JSON:decode(file:read("*all"))
	
	output=output["Animations"]["Animation"]
	
	-- arrange JSON info to a better array
	-- i used for id of anima	tion
	-- first name is animation name
	-- animation subdivision -> parts
	-- part name is asset name
	-- for every frame of animation, save asset info
	-- x, y, scaleX, scaleY, rotation, depth
	-- depth is layering, who is in front of who
	-- then arrange color matrix to regular RGBA channels
	parsed={}
	for i=1,table.maxn(output) do
		nameofsequence=output[i]["-name"]
		parsed[nameofsequence] = {}
		parsed[nameofsequence]["maxframes"]=tonumber(output[i]["-frameCount"])
		for j=1,table.maxn(output[i]["Part"]) do
			nameofasset=output[i]["Part"][j]["-name"]
			parsed[nameofsequence][nameofasset]={}
			for k=1,table.maxn(output[i]["Part"][j]["Frame"]) do
				parsed[nameofsequence][nameofasset][k]={}
				parsed[nameofsequence][nameofasset][k]["x"]=tonumber(output[i]["Part"][j]["Frame"][k]["-x"])
				parsed[nameofsequence][nameofasset][k]["y"]=tonumber(output[i]["Part"][j]["Frame"][k]["-y"])
				parsed[nameofsequence][nameofasset][k]["scaleX"]=tonumber(output[i]["Part"][j]["Frame"][k]["-scaleX"])
				parsed[nameofsequence][nameofasset][k]["scaleY"]=tonumber(output[i]["Part"][j]["Frame"][k]["-scaleY"])
				parsed[nameofsequence][nameofasset][k]["rotation"]=tonumber(output[i]["Part"][j]["Frame"][k]["-rotation"])
				parsed[nameofsequence][nameofasset][k]["depth"]=tonumber(output[i]["Part"][j]["Frame"][k]["-depth"])
				
				
				b=output[i]["Part"][j]["Frame"][k]["-colorMatrix"]
				a={}
				cont=0
				for word in string.gmatch(b,"%d+") do
					a[cont]=word
					cont=cont+1
				end
				
				colorArray={}
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
	
	-- # CLOSING
	return parsed
end

function Spawn(ax,ay)
	-- # OPENING
	-- DEPENDENCIES
	local physics = require "physics"
	-- FORWARD CALLS
	local enemy
	local shade
	local asd
	local limbnames
	local thislimb
	local mask
	local acceptableparams
	local statnames
	local thisstat
	-- LOCAL FUNCTIONS
	
	-- # BODY
	-- Essentials
	enemy=display.newGroup()
	enemy.x, enemy.y = ax,ay
	shade={ -40,-4, 40,-4, 40,12, -40,12}
	physics.addBody(enemy,"dynamic",{shape=shade,filter={categoryBits=2,maskBits=7}})
	enemy.isFixedRotation=true
	enemy["CATEGORY"]="ENEMY"
	
	-- Map Essentials
	enemy["CURX"]=1
	enemy["CURY"]=1
	enemy["MAPX"]=0
	enemy["MAPY"]=0
	enemy["DMAP"]=0
	-- enemy["LAYER"]=0
	enemy["isAlive"]=true
	
	-- Animation Essentials
	enemy["SEQUENCE"]="IDLE"
	enemy["CURFRAME"]=1
	enemy["TIME"]=1.0
	enemy["LASTTIME"]=0
	enemy["SCALE"]=1
	enemy["MODE"]="IDLE"
	enemy["!MODE"]=""
	enemy["ANIMATIONS"]=readAnims('Barry/BarryAnim.json')
	
	enemy["AIVALS"]={}
	enemy["AIVALS"]["CONTACTCD"]=500
	enemy["AIVALS"]["LASTMOVE"]=nil
	enemy["AIVALS"]["CURMOVE"]=nil
	enemy["AIVALS"]["REPATH"]=200
	
	enemy["AIVALS"]["UNIT"]={}
	enemy["AIVALS"]["UNIT"]["CATEGORY"]=nil
	enemy["AIVALS"]["UNIT"]["MAP"]={}
	enemy["AIVALS"]["UNIT"]["MAP"]["X"]=nil
	enemy["AIVALS"]["UNIT"]["MAP"]["Y"]=nil
	enemy["AIVALS"]["UNIT"]["POS"]={}
	enemy["AIVALS"]["UNIT"]["POS"]["X"]=nil
	enemy["AIVALS"]["UNIT"]["POS"]["Y"]=nil
	enemy["AIVALS"]["UNIT"]["POS"][1]=nil
	enemy["AIVALS"]["UNIT"]["POS"][2]=nil
	enemy["AIVALS"]["UNIT"]["TILE"]={}
	enemy["AIVALS"]["UNIT"]["TILE"]["X"]=nil
	enemy["AIVALS"]["UNIT"]["TILE"]["Y"]=nil
	enemy["AIVALS"]["UNIT"]["!TILE"]={}
	enemy["AIVALS"]["UNIT"]["!TILE"]["X"]=nil
	enemy["AIVALS"]["UNIT"]["!TILE"]["Y"]=nil
	
	enemy["AIVALS"]["TARGET"]={}
	enemy["AIVALS"]["TARGET"]["TILE"]={}
	enemy["AIVALS"]["TARGET"]["TILE"]["X"]=nil
	enemy["AIVALS"]["TARGET"]["TILE"]["Y"]=nil
	
	-- Animation Functions
	enemy.saturation=function()
		for i=1,enemy["ASSETS"]["COLOR"].numChildren do
			if enemy["TIME"]>=2.5 then
				enemy["ASSETS"]["COLOR"][i].fill.effect.intensity = -3.75
			elseif (enemy["TIME"]>1) and enemy["TIME"]<2.5 then
				enemy["ASSETS"]["COLOR"][i].fill.effect.intensity = enemy["TIME"]*(1-enemy["TIME"])
			elseif (enemy["TIME"]<1) then
				if (1-enemy["TIME"])*2>1 then
					enemy["ASSETS"]["COLOR"][i].fill.effect.intensity = 1
				else
					enemy["ASSETS"]["COLOR"][i].fill.effect.intensity = (1-enemy["TIME"])*2
				end
			else
				enemy["ASSETS"]["COLOR"][i].fill.effect.intensity = 0
			end
		end
		enemy["LASTTIME"]=enemy["TIME"]
	end
	enemy.refresh=function(self)
		local asd=enemy["ANIMATIONS"][enemy["SEQUENCE"]]["TIME"]
		asd=asd*enemy["TIME"]
		enemy["CURFRAME"]=enemy["CURFRAME"]+(asd)
		if enemy["CURFRAME"]>=enemy["ANIMATIONS"][enemy["SEQUENCE"]].maxframes then
			if enemy["ANIMATIONS"][enemy["SEQUENCE"]].loop==true then
				enemy["CURFRAME"]=1
			elseif enemy["ANIMATIONS"][enemy["SEQUENCE"]].loop==false then
				enemy["CURFRAME"]=1
				enemy["SEQUENCE"]="IDLE"
			end
		end
		
		for t=1,table.maxn(enemy["COPIES"]) do
			for i=1,enemy["ASSETS"][enemy["COPIES"][t]].numChildren do
				local curlimb=enemy["ASSETS"][enemy["COPIES"][t]][i]
				local currentframe=enemy["CURFRAME"]
				local flooredframe=math.floor(currentframe)
				
				local x=enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe].x + ( (enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe+1].x - enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe].x) * (currentframe-flooredframe) )
				
				local y=enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe].y + ( (enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe+1].y - enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe].y) * (currentframe-flooredframe) )
				
				local r=enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe].rotation + ( (enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe+1].rotation - enemy["ANIMATIONS"][enemy["SEQUENCE"]][curlimb.name][flooredframe].rotation) * (currentframe-flooredframe) )
				
				x=x*(enemy["SCALE"]/0.5)
				y=y*(enemy["SCALE"]/0.5)
				
				curlimb.x = (x)
				curlimb.y = (y)
				curlimb.rotation = (r)
				
				if enemy["COPIES"][t]=="COLOR" and curlimb.name=="Body" then
					enemy["ASSETS"]["COLOR"].maskX=curlimb.x
					enemy["ASSETS"]["COLOR"].maskY=curlimb.y
				end
			end
		end
		if enemy["TIME"] ~= enemy["LASTTIME"] then
			enemy.saturation()
		end
		enemy.shadow:toBack()
		
		enemy["WEAPON"]["basedamage"]=enemy["STATS"]["Damage"]
		
		enemy:AI()
		enemy:updateRadar()
		-- timer.performWithDelay(200,enemy.refresh)
	end
	enemy.turn=function()
		if enemy.xScale==1 then
			enemy.xScale=-1
		else
			enemy.xScale=1
		end
	end
	enemy.setSequence=function(self,value,side)
		side=side or self.xScale
		if self["SEQUENCE"]~=value then
			self["CURFRAME"]=1
			self["SEQUENCE"]=value
		end
		if self.xScale~=side then
			self.turn()
		end
	end
	
	-- AI Functions
	enemy.AI=function()
		if (enemy["MODE"]~=enemy["!MODE"]) then
			enemy["!MODE"]=enemy["MODE"]
			-- print ("MODE SWITCH:",enemy["MODE"])
		end
		enemy["STATS"]["COOLDOWN"]=enemy["STATS"]["COOLDOWN"]-1
		if enemy["MODE"]=="IDLE" then
			enemy:setSequence("IDLE")
			-- local idlemove=math.random(1,100)
			-- if idlemove>95 then
				-- print "!"
				-- enemy["TARGETX"]=enemy.shadow.x+math.random(-50,50)
				-- enemy["TARGETY"]=enemy.shadow.y+math.random(-50,50)
				-- enemy["CATEGORY"]="idle"
				-- enemy["MODE"]="PURSUIT"
			-- end
		elseif enemy["MODE"]=="PURSUIT" then
			local ySuccess=false
			local xSuccess=false
			local speedvalue=160
			local deltaxenemy=0
			local deltayenemy=0
			
			-- print "MOVE:"
			
			local yTileCheck=(enemy["CURY"]*2==enemy["AIVALS"]["TARGET"]["TILE"]["Y"])
			local xTileCheck=(enemy["CURX"]*2==enemy["AIVALS"]["TARGET"]["TILE"]["X"])
			
			if yTileCheck and xTileCheck then
				-- print "cleaned targets"
				-- print "SWITCHING TO SEARCH"
				-- enemy["AIVALS"]["LASTMOVE"]=nil
				-- enemy["AIVALS"]["CURMOVE"]=nil
				-- enemy["MODE"]="SEARCH"
				enemy["AIVALS"]["TARGET"]["TILE"]["X"]=nil
				enemy["AIVALS"]["TARGET"]["TILE"]["Y"]=nil
			-- else
				-- print (xTileCheck,yTileCheck)
				-- print (enemy["CURX"]*2,enemy["CURY"]*2,"->",enemy["AIVALS"]["TARGET"]["TILE"]["X"],enemy["AIVALS"]["TARGET"]["TILE"]["Y"])
				-- print (enemy["CURX"],enemy["CURY"])
				-- print (enemy["AIVALS"]["TARGET"]["TILE"]["X"],enemy["AIVALS"]["TARGET"]["TILE"]["Y"])
			end
			
			yTileCheck=(enemy["AIVALS"]["UNIT"]["!TILE"]["Y"]) and (enemy["AIVALS"]["UNIT"]["!TILE"]["Y"]==enemy["AIVALS"]["TARGET"]["TILE"]["Y"])
			xTileCheck=(enemy["AIVALS"]["UNIT"]["!TILE"]["X"]) and (enemy["AIVALS"]["UNIT"]["!TILE"]["X"]==enemy["AIVALS"]["TARGET"]["TILE"]["X"])
			
			if yTileCheck and xTileCheck then
				-- print "SWITCHING TO SEARCH BECAUSE NEXT STEP IS WHERE PLAYER IS AT"
				enemy["AIVALS"]["LASTMOVE"]=nil
				enemy["AIVALS"]["CURMOVE"]=nil
				enemy["MODE"]="SEARCH"
			end
			
			yTileCheck=(enemy["AIVALS"]["UNIT"]["!TILE"]["Y"]==enemy["CURY"]*2)
			xTileCheck=(enemy["AIVALS"]["UNIT"]["!TILE"]["X"]==enemy["CURX"]*2)
			
			if yTileCheck and xTileCheck then
				-- print "SWITCHING TO SEARCH BECAUSE ENEMY IS ALREADY AT NEXT STEP"
				enemy["AIVALS"]["LASTMOVE"]=nil
				enemy["AIVALS"]["CURMOVE"]=nil
				enemy["MODE"]="SEARCH"
			end
			
			-- print (enemy["AIVALS"]["UNIT"]["TILE"]["X"],enemy["AIVALS"]["TARGET"]["TILE"]["X"])
			-- print (enemy["AIVALS"]["UNIT"]["TILE"]["Y"],enemy["AIVALS"]["TARGET"]["TILE"]["Y"])
			
			-- print (enemy["AIVALS"]["UNIT"]["!TILE"]["Y"],enemy["AIVALS"]["TARGET"]["TILE"]["Y"])
			-- print (enemy["AIVALS"]["UNIT"]["!TILE"]["X"],enemy["AIVALS"]["TARGET"]["TILE"]["X"])
			
			-- if not(enemy["AIVALS"]["TARGET"]["TILE"]["X"]) and not(enemy["AIVALS"]["TARGET"]["TILE"]["Y"]) then
			if enemy["MODE"]=="PURSUIT" then
				-- enemy["MODE"]="SEARCH"
			-- else
				-- local ex,ey=thisEnemy["CURX"]*2,thisEnemy["CURY"]*2
				if (enemy["AIVALS"]["TARGET"]["TILE"]["X"]) and enemy["AIVALS"]["TARGET"]["TILE"]["Y"] then
					xTileCheck=(enemy["AIVALS"]["TARGET"]["TILE"]["X"]-(enemy["CURX"]*2))
					yTileCheck=(enemy["AIVALS"]["TARGET"]["TILE"]["Y"]-(enemy["CURY"]*2))
					
					-- print "--"
					local value
					if xTileCheck<0 then
						-- print "WEST"
						value="WEST"
					elseif xTileCheck>0 then
						-- print "EAST"
						value="EAST"
					end
					
					if yTileCheck<0 then
						-- print "NORTH"
						value="NORTH"
					elseif yTileCheck>0 then
						-- print "SOUTH"
						value="SOUTH"
					end
					
					if (enemy["AIVALS"]["CURMOVE"]~=value) then
						enemy["AIVALS"]["LASTMOVE"]=enemy["AIVALS"]["CURMOVE"]
						enemy["AIVALS"]["CURMOVE"]=value
					end
					
					if not(enemy["AIVALS"]["LASTMOVE"]) then
						local choose=math.random(0,1)
						if (value=="WEST" or value=="EAST") then
							choose=choose+2
						end
						if (choose==0) then
							enemy["AIVALS"]["LASTMOVE"]="WEST"
						elseif (choose==1) then
							enemy["AIVALS"]["LASTMOVE"]="EAST"
						elseif (choose==2) then
							enemy["AIVALS"]["LASTMOVE"]="NORTH"
						elseif (choose==3) then
							enemy["AIVALS"]["LASTMOVE"]="SOUTH"
						end
					end
					
					local pastmovefraction=20
					local curmovefraction=60
					if xTileCheck==0 then
						if (enemy["AIVALS"]["LASTMOVE"]=="WEST") then
							deltaxenemy=(pastmovefraction/64)*speedvalue*-1
						elseif(enemy["AIVALS"]["LASTMOVE"]=="EAST") then
							deltaxenemy=(pastmovefraction/64)*speedvalue
						end
					else
						local inverter1=(math.abs(xTileCheck)/xTileCheck)
						local inverter2=(math.abs(xTileCheck)/xTileCheck)*-1
						deltaxenemy=(curmovefraction/64)*speedvalue*inverter1
					end
					if yTileCheck==0 then
						if (enemy["AIVALS"]["LASTMOVE"]=="NORTH") then
							deltayenemy=(pastmovefraction/64)*speedvalue*-1
						elseif (enemy["AIVALS"]["LASTMOVE"]=="SOUTH") then
							deltayenemy=(pastmovefraction/64)*speedvalue
						end
					else
						local inverter1=(math.abs(yTileCheck)/yTileCheck)
						local inverter2=(math.abs(yTileCheck)/yTileCheck)*-1
						deltayenemy=(curmovefraction/64)*speedvalue*inverter1
					end
					enemy:move(deltaxenemy,deltayenemy)
				end
				-- enemy["MODE"]="PURSUIT"
			end
			
		--[[
			local speedvalue=160
			
			local deltax=enemy["TARGETX"]-enemy.x
			local deltay=enemy["TARGETY"]-enemy.y
			local deltax1=deltax-140
			local deltax2=deltax+140
			
			-- print "IN PURSUIT"
			
			if math.abs(deltax)<160 and math.abs(deltay)<160 then
				if enemy["TARGETX"]>enemy.x then
					deltax=deltax1
				else
					deltax=deltax2
				end
			end
			
			local deltah=math.sqrt( deltax^2 + deltay^2 )
			local deltatheta=math.tan( math.rad(deltay/deltax) )
			
			local deltaxenemy=0
			local deltayenemy=0
			
			local yState=0
			local xState=0
			
			local ySuccess=(math.abs(deltay)<10)
			local xSuccess=(math.abs(deltax)<25)
			
			-- local yFail=(enemy.y+1>enemy["AIVALS"]["POS"][2] and enemy.y-1<enemy["AIVALS"]["POS"][2])
			-- local xFail=(enemy.x+1>enemy["AIVALS"]["POS"][1] and enemy.x-1<enemy["AIVALS"]["POS"][1])
			-- if xFail then
				-- enemy["AIVALS"]["xCD"]=enemy["AIVALS"]["xCD"]-1
			-- else
				-- if enemy["AIVALS"]["xCD"]<=0 then
					-- enemy["AIVALS"]["xCD"]=5
				-- end
			-- end
			-- if yFail then
				-- enemy["AIVALS"]["yCD"]=enemy["AIVALS"]["yCD"]-1
			-- else
				-- if enemy["AIVALS"]["yCD"]<=0 then
					-- enemy["AIVALS"]["yCD"]=5
				-- end
			-- end
			
			local yFail=false
			local xFail=false
			
			if deltax>0 and enemy["AIVALS"]["E"]>0 then
				xFail=true
			elseif deltax<0 and enemy["AIVALS"]["W"]>0 then
				xFail=true
			end
			-- print ("XD "..deltax,"S "..enemy["AIVALS"]["S"],"N "..enemy["AIVALS"]["N"])
			if deltay>0 and enemy["AIVALS"]["S"]>0 then
				yFail=true
			elseif deltay<0 and enemy["AIVALS"]["N"]>0 then
				yFail=true
			end
			-- print ("YD "..deltay,"E "..enemy["AIVALS"]["E"],"W "..enemy["AIVALS"]["W"])
			if ySuccess then
				-- print "Y SUCCEEDED"
				yState=1
				-- enemy["AIVALS"]["yCD"]=5
			-- elseif enemy["AIVALS"]["yCD"]<=0 then
			elseif yFail then
				-- print "Y FAILED"
				yState=2
			end
			
			if xSuccess then
				-- print "X SUCCEEDED"
				xState=1
				-- enemy["AIVALS"]["xCD"]=5
			-- elseif enemy["AIVALS"]["xCD"]<=0 then
			elseif xFail then
				-- print "X FAILED"
				xState=2
			end
			
			local curStateNum=table.maxn(enemy["AIVALS"]["MOVEORDER"])
			local curState=enemy["AIVALS"]["MOVEORDER"][curStateNum]
			local pastState=enemy["AIVALS"]["MOVEORDER"][curStateNum-1]
			if (curState=="N") then
				-- print "NORMAL"
				if xState==0 and yState==0 then
					-- print "ALL FINE"
					deltaxenemy=(deltax/deltah)*speedvalue
					deltayenemy=(deltay/deltah)*speedvalue
				elseif xState==0 then
					-- print "Y F-ED UP"
					deltaxenemy=speedvalue*(deltax/math.abs(deltax))
					if yState==2 then
						deltayenemy=50*(deltay/math.abs(deltay))
					end
				elseif yState==0 then
					-- print "X F-ED UP"
					deltayenemy=speedvalue*(deltay/math.abs(deltay))
					if xState==2 then
						deltaxenemy=50*(deltax/math.abs(deltax))
					end
				else
					-- print "NORMAL MOVE FAILED"
					-- print (xState,yState)
					if (xState==1 and yState==2) then
						local rand=math.random(1,2)
						if deltax>0 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="XS"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+3]="OS"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="ON"
						elseif deltax<0 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="XN"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="ON"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+3]="OS"
						end
						-- enemy["AIVALS"]["TIMER"]=10
					elseif (yState==2 and xState==2 and deltax>deltay) then
						local rand=math.random(1,2)
						if deltax>0 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="XS"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="OS"
						elseif deltax<0 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="XN"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="ON"
						end
						if rand==1 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="OW"
						else
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="OE"
						end
						-- enemy["AIVALS"]["TIMER"]=10
					elseif (xState==2 and yState==1) then
						local rand=math.random(1,2)
						if deltay>0 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="XE"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="OE"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+3]="OW"
						elseif deltay<0 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="XW"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="OW"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+3]="OE"
						end
						-- enemy["AIVALS"]["TIMER"]=10
					elseif (yState==2 and xState==2 and deltax<=deltay) then
						local rand=math.random(1,2)
						if deltay>0 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="XE"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="OE"
						elseif deltay<0 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="XW"
							enemy["AIVALS"]["MOVEORDER"][curStateNum+2]="OW"
						end
						if rand==1 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+3]="ON"
						else
							enemy["AIVALS"]["MOVEORDER"][curStateNum+3]="OS"
						end
						-- enemy["AIVALS"]["TIMER"]=10
					end
				end
			elseif string.sub(curState,1,1)=="O" then
				-- print "OVERDRIVE"
				-- enemy["AIVALS"]["TIMER"]=enemy["AIVALS"]["TIMER"]-1
				-- print (curState)
				if enemy["AIVALS"]["N"]>0 and curState=="ON" then
					-- print "NORTH FAILED"
					-- enemy["AIVALS"]["yCD"]=5
					-- enemy["AIVALS"]["xCD"]=5
					-- enemy["AIVALS"]["TIMER"]=10
					local rand=math.random(1,2)
					-- if rand==1 then
						-- enemy["AIVALS"]["MOVEORDER"][curStateNum]="OS"
					-- else
						-- rand=math.random(1,2)
						if rand==1 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="OW"
						else
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="OE"
						end
						curStateNum=table.maxn(enemy["AIVALS"]["MOVEORDER"])
						curState=enemy["AIVALS"]["MOVEORDER"][curStateNum]
						pastState=enemy["AIVALS"]["MOVEORDER"][curStateNum-1]
					-- end
				elseif enemy["AIVALS"]["S"]>0 and curState=="OS" then
					-- print "SOUTH FAILED"
					-- enemy["AIVALS"]["yCD"]=5
					-- enemy["AIVALS"]["xCD"]=5
					-- enemy["AIVALS"]["TIMER"]=10
					local rand=math.random(1,2)
					-- if rand==1 then
						-- enemy["AIVALS"]["MOVEORDER"][curStateNum]="ON"
					-- else
						-- rand=math.random(1,2)
						if rand==1 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="OW"
						else
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="OE"
						end
						curStateNum=table.maxn(enemy["AIVALS"]["MOVEORDER"])
						curState=enemy["AIVALS"]["MOVEORDER"][curStateNum]
						pastState=enemy["AIVALS"]["MOVEORDER"][curStateNum-1]
					-- end
				elseif enemy["AIVALS"]["W"]>0 and curState=="OW" then
					-- print "WEST FAILED"
					-- enemy["AIVALS"]["yCD"]=5
					-- enemy["AIVALS"]["xCD"]=5
					-- enemy["AIVALS"]["TIMER"]=10
					local rand=math.random(1,2)
					-- if rand==1 then
						-- enemy["AIVALS"]["MOVEORDER"][curStateNum]="OE"
					-- else
						-- rand=math.random(1,2)
						if rand==1 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="ON"
						else
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="OS"
						end
						curStateNum=table.maxn(enemy["AIVALS"]["MOVEORDER"])
						curState=enemy["AIVALS"]["MOVEORDER"][curStateNum]
						pastState=enemy["AIVALS"]["MOVEORDER"][curStateNum-1]
					-- end
				elseif enemy["AIVALS"]["E"]>0 and curState=="OE" then
					-- print "EAST FAILED"
					-- enemy["AIVALS"]["yCD"]=5
					-- enemy["AIVALS"]["xCD"]=5
					-- enemy["AIVALS"]["TIMER"]=10
					local rand=math.random(1,2)
					-- if rand==1 then
						-- enemy["AIVALS"]["MOVEORDER"][curStateNum]="OW"
					-- else
						-- rand=math.random(1,2)
						if rand==1 then
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="ON"
						else
							enemy["AIVALS"]["MOVEORDER"][curStateNum+1]="OS"
						end
						curStateNum=table.maxn(enemy["AIVALS"]["MOVEORDER"])
						curState=enemy["AIVALS"]["MOVEORDER"][curStateNum]
						pastState=enemy["AIVALS"]["MOVEORDER"][curStateNum-1]
					-- end
				end
				
				if (pastState) then
					if enemy["AIVALS"][string.sub(pastState,2,2)]==0 then
						-- print "OVERRIDE FINISHED"
						enemy["AIVALS"]["MOVEORDER"][curStateNum]=nil
					
						curStateNum=table.maxn(enemy["AIVALS"]["MOVEORDER"])
						curState=enemy["AIVALS"]["MOVEORDER"][curStateNum]
						pastState=enemy["AIVALS"]["MOVEORDER"][curStateNum-1]
						if (pastState) then
							if (string.sub(curState,1,1)=="X") then
								-- print "X REMOVED; BACK TO NORM (?)"
								enemy["AIVALS"]["MOVEORDER"][curStateNum]=nil
								curStateNum=table.maxn(enemy["AIVALS"]["MOVEORDER"])
								curState=enemy["AIVALS"]["MOVEORDER"][curStateNum]
								pastState=enemy["AIVALS"]["MOVEORDER"][curStateNum-1]
							end
						else
							-- print (curStateNum,curState,pastState)
							-- assert(false)
						end
					end
				else
					-- print (curStateNum,curState,pastState)
					-- assert(false)
				end
				-- if enemy["AIVALS"]["TIMER"]<=0 then
					-- enemy["AIVALS"]["yCD"]=5
					-- enemy["AIVALS"]["xCD"]=5
					-- enemy["AIVALS"]["TIMER"]=10
					-- print "OVERDRIVE WENT WELL; GOING TO TEST"
					-- enemy["AIVALS"]["MOVEORDER"][curStateNum-1]=enemy["AIVALS"]["MOVEORDER"][curStateNum-1]..enemy["AIVALS"]["MOVEORDER"][curStateNum]
					-- enemy["AIVALS"]["MOVEORDER"][curStateNum]=nil
				-- end
				
				-- if enemy["AIVALS"][string.sub(curState,2,2)]>
				
				if (string.sub(curState,2,2)=="N") then
					deltayenemy=-220
				elseif (string.sub(curState,2,2)=="S") then
					deltayenemy=220
				elseif (string.sub(curState,2,2)=="W") then
					deltaxenemy=-220
				elseif (string.sub(curState,2,2)=="E") then
					deltaxenemy=220
				end
			else
				-- print ("WTF "..curState)
			end
		-- if xSuccess and ySuccess then
			if xState==1 and yState==1 then
				-- print "GOT TO TARGET"
				enemy["MODE"]="IDLE"
				enemy["CATEGORY"]=nil
			else
				enemy:move(deltaxenemy,deltayenemy)
				enemy["AIVALS"]["POS"][1]=enemy.x
				enemy["AIVALS"]["POS"][2]=enemy.y
			end
			]]
		
		elseif enemy["MODE"]=="SEARCH" then
			local ySuccess=false
			local xSuccess=false
			local speedvalue=120
			local deltaxenemy=0
			local deltayenemy=0
			-- local deltax=enemy["AIVALS"]["UNIT"]["POS"][1]-enemy.x
			-- if (deltax>enemy["AIVALS"]["UNIT"]["POS"][2]-enemy.x) then
				-- deltax=enemy["AIVALS"]["UNIT"]["POS"][2]-enemy.x
			-- end
			local deltay=enemy["AIVALS"]["UNIT"]["POS"]["Y"]-enemy.y
			local deltax=enemy["AIVALS"]["UNIT"]["POS"]["X"]-enemy.x
			if (math.abs(deltay)<30) then
				if (enemy.x<enemy["AIVALS"]["UNIT"]["POS"]["X"]) then
					deltax=enemy["AIVALS"]["UNIT"]["POS"][1]-enemy.x
				else
					deltax=enemy["AIVALS"]["UNIT"]["POS"][2]-enemy.x
				end
			end
			-- deltax=deltax
			
			local deltah=math.sqrt( deltax^2 + deltay^2 )
			deltaxenemy=(deltax/deltah)*speedvalue
			deltayenemy=(deltay/deltah)*speedvalue
			
			ySuccess=(math.abs(deltay)<10)
			xSuccess=(math.abs(deltax)<25)
			if xSuccess and ySuccess then
				-- print "GOT TO TARGET"
				enemy["AIVALS"]["LASTMOVE"]=nil
				enemy["AIVALS"]["CURMOVE"]=nil
				enemy["MODE"]="IDLE"
				enemy["CATEGORY"]=nil
			else
				enemy:move(deltaxenemy,deltayenemy)
			end
		elseif enemy["MODE"]=="ATTACK" then
			if enemy["AIVALS"]["UNIT"]["POS"]["X"]>enemy.x then
				if enemy.xScale==-1 then
					enemy:turn()
				end
			else
				if enemy.xScale==1 then
					enemy:turn()
				end
			end
			if enemy["STATS"]["COOLDOWN"]<=0 then
				enemy["STATS"]["COOLDOWN"]=70
				enemy:setSequence("SWING")
			end
		end
		-- timer.performWithDelay(250,enemy.AI)
	end
	enemy.move=function(self,cx,cy)
		-- local cruisecontrol=120
		local cruisecontrol=40
		
		self.x=self.x+(cx*self["STATS"]["Speed"]/cruisecontrol)
		self.y=self.y+(cy*self["STATS"]["Speed"]/cruisecontrol)
		
		-- self.shadow.x=self.shadow.x+(cx*self["STATS"]["Speed"]/cruisecontrol)
		-- self.shadow.y=self.shadow.y+(cy*self["STATS"]["Speed"]/cruisecontrol)
		-- self.radar.x=self.shadow.x
		-- self.radar.y=self.shadow.y
		
		local value=0
		if math.abs(cx)>value or math.abs(cy)>value then
			if cx>value then
				self:setSequence("WALK",1)
			elseif cx<value then
				self:setSequence("WALK",-1)
			else
				self:setSequence("WALK")
			end
		end
	end
	enemy.updateRadar=function()
		enemy["AIVALS"]["CONTACTCD"]=enemy["AIVALS"]["CONTACTCD"]-1
		if enemy["AIVALS"]["CONTACTCD"]<=0 then
			print "LOST PLAYER"
			enemy["AIVALS"]["CONTACTCD"]=500
			enemy:cleanTarget()
		end
		enemy.radar:rotate(5)
	end
	enemy.cleanTarget=function()
		enemy["MODE"]="IDLE"
		enemy["AIVALS"]["UNIT"]["POS"]["X"]=nil
		enemy["AIVALS"]["UNIT"]["POS"]["Y"]=nil
		enemy["AIVALS"]["UNIT"]["TILE"]["X"]=nil
		enemy["AIVALS"]["UNIT"]["TILE"]["Y"]=nil
		enemy["AIVALS"]["UNIT"]["CATEGORY"]=nil
		enemy["AIVALS"]["TARGET"]["TILE"]["Y"]=nil
		enemy["AIVALS"]["TARGET"]["TILE"]["X"]=nil
		enemy["AIVALS"]["UNIT"]["POS"][1]=nil
		enemy["AIVALS"]["UNIT"]["POS"][2]=nil
		enemy["AIVALS"]["LASTMOVE"]=nil
		enemy["AIVALS"]["CURMOVE"]=nil
	end
	
	-- Modify Health Function
	enemy.ModifyHealth=function(self,amount,cause)
		self["STATS"]["Health"] = self["STATS"]["Health"] + amount
		-- a.Play(5)
		
		if self["STATS"]["Health"] <= 0 then
			self["STATS"]["Health"] = 0
			self["isAlive"]=false
		elseif self["STATS"]["Health"]>self["STATS"]["MaxHealth"] then
			self["STATS"]["Health"]=self["STATS"]["MaxHealth"]
		end
		
		local healthpercent=self["STATS"]["Health"]/self["STATS"]["MaxHealth"]
		healthpercent=(healthpercent*1.5)+0.01
		self["ASSETS"]["COLOR"].maskScaleX=healthpercent
		self["ASSETS"]["COLOR"].maskScaleY=healthpercent
		
	end
	

	-- Assets Essentials
	enemy["ASSETS"]={}
	limbnames={
		"RightArm","Sword","Groin", "RightLeg","LeftLeg", "Body",  "LeftArm", "Face", "Hair", "Shield",
	}
	enemy["COPIES"]={
		"B&W",
		"COLOR"
	}
	for t=1,table.maxn(enemy["COPIES"]) do
		enemy["ASSETS"][enemy["COPIES"][t]]=display.newGroup()
		enemy["ASSETS"][enemy["COPIES"][t]].setFillColor=function (self,r,g,b,a)
			acceptableparams=( (r) and (r>=0) and (r<=1) )
			acceptableparams=acceptableparams and ( (g) and (g>=0) and (g<=1) )
			acceptableparams=acceptableparams and ( (b) and (b>=0) and (b<=1) )
			if (acceptableparams) then
				a=a or 1
				for i=self.numChildren,1,-1 do
					self[i]:setFillColor(r,g,b,a)
				end
			else
				assert(false, "Invalid color parameters.")
			end
		end
		for i=1,table.maxn(limbnames) do
			thislimb=display.newImage("Barry/red/"..limbnames[i]..".png")
			thislimb.name=limbnames[i]
			if enemy["COPIES"][t]=="B&W" and limbnames[i]=="Sword" then
				enemy["WEAPON"]=thislimb
				enemy["WEAPON"].canDamage=true
			end
			enemy["ASSETS"][enemy["COPIES"][t]]:insert(thislimb)
		end
		enemy:insert(enemy["ASSETS"][enemy["COPIES"][t]])
		if enemy["COPIES"][t]=="B&W" then
			for i=1,enemy["ASSETS"][enemy["COPIES"][t]].numChildren do
				thislimb=enemy["ASSETS"][enemy["COPIES"][t]][i]
				thislimb.fill.effect = "filter.grayscale"
			end
		elseif enemy["COPIES"][t]=="COLOR" then
			mask = graphics.newMask( "ui/circlemask.png" )
			enemy["ASSETS"][enemy["COPIES"][t]]:setMask(mask)
			enemy["ASSETS"][enemy["COPIES"][t]].maskScaleX=1.5
			enemy["ASSETS"][enemy["COPIES"][t]].maskScaleY=1.5
			for i=1,enemy["ASSETS"][enemy["COPIES"][t]].numChildren do
				thislimb=enemy["ASSETS"][enemy["COPIES"][t]][i]
				thislimb.fill.effect = "filter.desaturate"
				thislimb.fill.effect.intensity = 0
			end
		end
		enemy["ASSETS"][enemy["COPIES"][t]]:toFront()
	end


	-- Shadow Essentials
	enemy.shadow=display.newImageRect("Barry/Shadow.png",103,17)
	enemy.shadow.anchorY=0.2
	enemy:insert(enemy["shadow"])

	-- Radar Essentials
	enemy.radar=display.newRect(0,0,2000,1)
	enemy.radar:setFillColor(1,0,0,0)
	enemy.radar.x,enemy.radar.y=enemy.x,enemy.y
	enemy:insert(enemy["radar"])
	enemy["radar"].collision = function( self, event )
		local other=event.other
		if other.CATEGORY=="PLAYER" then
			-- if (enemy["AIVALS"]["UNIT"]["CATEGORY"]~=other.CATEGORY) then
				-- print "found player"
			-- end
			enemy["AIVALS"]["UNIT"]["TILE"]["X"]=other["CURX"]
			enemy["AIVALS"]["UNIT"]["TILE"]["Y"]=other["CURY"]
			enemy["AIVALS"]["UNIT"]["MAP"]["X"]=other["MAPX"]
			enemy["AIVALS"]["UNIT"]["MAP"]["Y"]=other["MAPY"]
			enemy["AIVALS"]["UNIT"]["POS"]["X"]=other.x
			enemy["AIVALS"]["UNIT"]["POS"]["Y"]=other.y
			enemy["AIVALS"]["UNIT"]["POS"][1]=other.x-140
			enemy["AIVALS"]["UNIT"]["POS"][2]=other.x+140
			enemy["AIVALS"]["UNIT"]["CATEGORY"]=other.CATEGORY
			
			print ("CONTACT!")
			print (enemy["AIVALS"]["UNIT"]["TILE"]["X"]..", "..enemy["AIVALS"]["UNIT"]["TILE"]["Y"])
			-- print (", ")
			-- print ("CONTACT!")
			
			
			local shortx=other.x
			local shorty=other.y
			
			local yCheck=(enemy.y+10>shorty and enemy.y-10<shorty)
			local xCheck=(enemy.x+165>shortx and enemy.x-165<shortx)
			
			if xCheck and yCheck then
				if enemy["MODE"]~="ATTACK" then
					-- print "AI FINISHED"
					enemy["MODE"]="ATTACK"
				end
			elseif enemy["MODE"]~="PURSUIT" then
				enemy["MODE"]="PURSUIT"
			end
			enemy["AIVALS"]["CONTACTCD"]=500
		elseif other.CATEGORY=="ENEMY" and enemy["AIVALS"]["UNIT"]["CATEGORY"]~="PLAYER" and other~=self.parent then
			enemy["AIVALS"]["UNIT"]["TILE"]["X"]=other["CURX"]
			enemy["AIVALS"]["UNIT"]["TILE"]["Y"]=other["CURY"]
			enemy["AIVALS"]["UNIT"]["MAP"]["X"]=other["MAPX"]
			enemy["AIVALS"]["UNIT"]["MAP"]["Y"]=other["MAPY"]
			enemy["AIVALS"]["UNIT"]["POS"]["X"]=other.x
			enemy["AIVALS"]["UNIT"]["POS"]["Y"]=other.y
			enemy["AIVALS"]["UNIT"]["POS"][1]=other.x-140
			enemy["AIVALS"]["UNIT"]["POS"][2]=other.x+140
			enemy["AIVALS"]["UNIT"]["CATEGORY"]=other.CATEGORY
			
			local shortx=other.x
			local shorty=other.y
			
			local yCheck=(enemy.y+10>shorty and enemy.y-10<shorty)
			local xCheck=(enemy.x+165>shortx and enemy.x-165<shortx)
			
			if xCheck and yCheck then
				if enemy["MODE"]~="IDLE" then
					enemy["MODE"]="IDLE"
				end
			elseif enemy["MODE"]~="PURSUIT" then
				enemy["MODE"]="PURSUIT"
			end
			enemy["AIVALS"]["CONTACTCD"]=500
		end
		-- if enemy["AIVALS"]["CONTACTCD"]<=0 then
			-- print "LOST PLAYER"
			-- enemy["AIVALS"]["CONTACTCD"]=500
			-- enemy:cleanTarget()
		-- end
	end
	physics.addBody(enemy.radar,"dynamic",{isSensor=true,friction=0.5,filter={categoryBits=4,maskBits=2}})
	enemy.radar:addEventListener( "collision", enemy["radar"])

	enemy["HitBox"]=display.newRect(0,-75,90,150)
	enemy["HitBox"]:setFillColor(1,1,1,0)
	enemy:insert(enemy["HitBox"])

	-- Trackables
	enemy["GOLD"]=0
	
	-- Spells & Abilities
	enemy["SPELLS"]={
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
	enemy["STATS"]={}
	statnames={"Constitution","Dexterity","Strength","Talent","Stamina","Intellect"	}
	for s=1,table.maxn(statnames) do
		thisstat=statnames[s]
		enemy["STATS"][thisstat]={}
		enemy["STATS"][thisstat]["NAME"]=thisstat
		enemy["STATS"][thisstat]["ID"]=s
		enemy["STATS"][thisstat]["NATURAL"]=2
		-- just in case, cycles:
		enemy["STATS"][s]=enemy["STATS"][thisstat]
	end
	
	-- Leveling
	enemy["STATS"]["Level"]=1
	enemy["STATS"]["COOLDOWN"]=0
	
	--Secondary Stats
	enemy["STATS"]["Armor"]=0
	enemy["STATS"]["Speed"]=1.00
	enemy["STATS"]["Damage"]=5
	-- enemy["STATS"]["Damage"]=math.random(5,20)
	
	enemy["STATS"]["MaxHealth"]=(10*enemy["STATS"]["Level"])+(enemy["STATS"]["Constitution"]["NATURAL"]*20)
	enemy["STATS"]["Health"]=enemy["STATS"]["MaxHealth"]
	
	-- enemy:refresh()
	-- enemy:AI()
	-- Runtime:addEventListener("tap",enemy.AI)
	Runtime:addEventListener("enterFrame",enemy.refresh)
	
	-- # CLOSING
	return enemy
end

function CreatePlayer(name, scale)
	-- # OPENING
	-- DEPENDENCIES
	local physics = require "physics"
	-- FORWARD CALLS
	local names
	local shade
	local asd
	local limbnames
	local acceptableparams
	local thislimb
	local mask
	local statnames
	local statdescrip
	local thisstat
	local scale = scale or 1
	-- LOCAL FUNCTIONS
	
	-- # BODY
	if not(player) then
		names={
			"Barry"
		}
		
		-- Essentials
		player=display.newGroup()
		shade={ -40,-4, 40,-4, 40,12, -40,12}
		physics.addBody(player,"dynamic",{shape=shade,filter={categoryBits=2,maskBits=7}})
		player.isFixedRotation=true
		player.x, player.y = display.contentWidth/2, display.contentHeight/2
		player["CATEGORY"]="PLAYER"
		
		-- Map Essentials
		player["REVISION"] = { regionX = -1, rowY = -1 }
		-- player["POSITION"]={}
		-- player["POSITION"]["REGION"]={x=0,y=0,q=1}
		-- player["POSITION"]["GLOBAL"]={x=5,y=5}
		-- player["POSITION"]["REGIONAL"]={x=5,y=5}
		-- player["CHUNK"]={x=0, y=0}
		-- player["TILE"]={x=1, y=1}
		-- player["MAPY"]=0
		-- player["QUAD"]=1
		-- player["CURY"]=1
		-- player["CURX"]=1
		
		-- Animation Essentials
		player["SEQUENCE"]="IDLE"
		player["CURFRAME"]=1
		player["TIME"]=1
		player["LASTTIME"]=0
		player["SCALE"]=scale
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
			player.shadow:toBack()
			
			
			player:regeneration()
			
			player["WEAPON"]["basedamage"]=player["STATS"]["Damage"]
		
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
		limbnames={
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
				acceptableparams=( (r) and (r>=0) and (r<=1) )
				acceptableparams=acceptableparams and ( (g) and (g>=0) and (g<=1) )
				acceptableparams=acceptableparams and ( (b) and (b>=0) and (b<=1) )
				if (acceptableparams) then
					a=a or 1
					for i=self.numChildren,1,-1 do
						self[i]:setFillColor(r,g,b,a)
					end
				else
					assert(false, "Invalid color parameters.")
				end
			end
			for i=1,table.maxn(limbnames) do
				thislimb=display.newImage("Barry/reg/"..limbnames[i]..".png")
				thislimb.xScale = scale
				thislimb.yScale = scale
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
					thislimb=player["ASSETS"][player["COPIES"][t]][i]
					thislimb.fill.effect = "filter.scatter"
					thislimb.fill.effect.intensity = 0.25
				end
			elseif player["COPIES"][t]=="B&W" then
				for i=1,player["ASSETS"][player["COPIES"][t]].numChildren do
					thislimb=player["ASSETS"][player["COPIES"][t]][i]
					thislimb.fill.effect = "filter.grayscale"
				end
			elseif player["COPIES"][t]=="COLOR" then
				mask = graphics.newMask( "ui/circlemask.png" )
				player["ASSETS"][player["COPIES"][t]]:setMask(mask)
				player["ASSETS"][player["COPIES"][t]].maskScaleX=1.5
				player["ASSETS"][player["COPIES"][t]].maskScaleY=1.5
				for i=1,player["ASSETS"][player["COPIES"][t]].numChildren do
					thislimb=player["ASSETS"][player["COPIES"][t]][i]
					thislimb.fill.effect = "filter.desaturate"
					thislimb.fill.effect.intensity = 0
				end
			end
			-- print ("FINISHED WITH "..player["COPIES"][t])
			player["ASSETS"][player["COPIES"][t]]:toFront()
		end
		
		-- Shadow Essentials
		player["shadow"]=display.newImageRect("Barry/Shadow.png",103,17)
		player["shadow"].xScale = scale
		player["shadow"].yScale = scale
		player["shadow"].anchorY=0.2
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
		statnames={"Constitution","Dexterity","Strength","Talent","Stamina","Intellect"	}
		statdescrip={"Physical state of the body as to health.","Skill using hands or body, mental skill and cleverness.","Muscular or bodily power.","Magical or mental power.","Power to endure fatigue.","Capacity for thought or knowledge."}
		for s=1,table.maxn(statnames) do
			thisstat=statnames[s]
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
		
		player.x = 150
		player.y = 100
	end
	
	-- # CLOSING
	return player
end


