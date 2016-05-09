---------------------------------------------------------------------------------------
--
-- enemy.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)

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

function Spawn(ax,ay)
	local physics = require "physics"
	-- Essentials
	local enemy=display.newGroup()
	enemy.x, enemy.y = ax,ay
	local shade={ -51,-4, 51,-4, 51,12, -51,12}
	physics.addBody(enemy,"dynamic",{shape=shade,filter={categoryBits=2,maskBits=7}})
	enemy.isFixedRotation=true
	enemy["CATEGORY"]="ENEMY"
	
	enemy.textd=display.newText((enemy.x..", "..enemy.y),0,50,native.systemFont,30)
	enemy:insert(enemy.textd)
	
	-- Map Essentials
	enemy["CURX"]=0
	enemy["CURY"]=0
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
	enemy["ANIMATIONS"]=readAnims('Barry/BarryAnim.json')
	
	enemy["AIVALS"]={}
	enemy["AIVALS"]["CONTACTCD"]=500
	
	enemy["AIVALS"]["UNIT"]={}
	enemy["AIVALS"]["UNIT"]["CATEGORY"]=nil
	enemy["AIVALS"]["UNIT"]["POS"]={}
	enemy["AIVALS"]["UNIT"]["POS"]["X"]=nil
	enemy["AIVALS"]["UNIT"]["POS"]["Y"]=nil
	enemy["AIVALS"]["UNIT"]["POS"][1]=nil
	enemy["AIVALS"]["UNIT"]["POS"][2]=nil
	enemy["AIVALS"]["UNIT"]["TILE"]={}
	enemy["AIVALS"]["UNIT"]["TILE"]["X"]=nil
	enemy["AIVALS"]["UNIT"]["TILE"]["Y"]=nil
	
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
		
		enemy.textd.text=(math.floor(enemy.x)..", "..math.floor(enemy.y))
		enemy["WEAPON"]["basedamage"]=enemy["STATS"]["Damage"]
		
		enemy:AI()
		enemy:updateRadar()
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
			local deltax=enemy["AIVALS"]["UNIT"]["POS"]["X"]-enemy.x
			local deltay=enemy["AIVALS"]["UNIT"]["POS"]["Y"]-enemy.y
			local deltah=math.sqrt( deltax^2 + deltay^2 )
			local speedvalue=160
			local deltaxenemy=0
			local deltayenemy=0
			
			
			local yTileCheck=(enemy["AIVALS"]["UNIT"]["TILE"]["Y"]==enemy["AIVALS"]["TARGET"]["TILE"]["Y"])
			local xTileCheck=(enemy["AIVALS"]["UNIT"]["TILE"]["X"]==enemy["AIVALS"]["TARGET"]["TILE"]["X"])
			-- print (enemy["AIVALS"]["UNIT"]["TILE"]["X"],enemy["AIVALS"]["TARGET"]["TILE"]["X"])
			-- print (enemy["AIVALS"]["UNIT"]["TILE"]["Y"],enemy["AIVALS"]["TARGET"]["TILE"]["Y"])
			if yTileCheck and xTileCheck then
				deltaxenemy=(deltax/deltah)*speedvalue
				deltayenemy=(deltay/deltah)*speedvalue
			end
			
			
			local ySuccess=(math.abs(deltay)<10)
			local xSuccess=(math.abs(deltax)<25)
			if xSuccess and ySuccess then
				-- print "GOT TO TARGET"
				enemy["MODE"]="IDLE"
				enemy["CATEGORY"]=nil
			else
				enemy:move(deltaxenemy,deltayenemy)
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
		enemy.radar:rotate(1)
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
	local limbnames={
		"RightArm","Sword","Groin", "RightLeg","LeftLeg", "Body",  "LeftArm", "Face", "Hair", "Shield",
	}
	enemy["COPIES"]={
		"B&W",
		"COLOR"
	}
	for t=1,table.maxn(enemy["COPIES"]) do
		enemy["ASSETS"][enemy["COPIES"][t]]=display.newGroup()
		enemy["ASSETS"][enemy["COPIES"][t]].setFillColor=function (self,r,g,b,a)
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
			local thislimb=display.newImage("Barry/red/"..limbnames[i]..".png")
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
				local thislimb=enemy["ASSETS"][enemy["COPIES"][t]][i]
				thislimb.fill.effect = "filter.grayscale"
			end
		elseif enemy["COPIES"][t]=="COLOR" then
			local mask = graphics.newMask( "ui/circlemask.png" )
			enemy["ASSETS"][enemy["COPIES"][t]]:setMask(mask)
			enemy["ASSETS"][enemy["COPIES"][t]].maskScaleX=1.5
			enemy["ASSETS"][enemy["COPIES"][t]].maskScaleY=1.5
			for i=1,enemy["ASSETS"][enemy["COPIES"][t]].numChildren do
				local thislimb=enemy["ASSETS"][enemy["COPIES"][t]][i]
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
	enemy.radar=display.newRect(0,0,600,1)
	enemy.radar:setFillColor(0,0,0,0)
	enemy.radar.x,enemy.radar.y=enemy.x,enemy.y
	enemy["radar"].collision = function( self, event )
		local other=event.other
		if other.CATEGORY=="PLAYER" then
			enemy["AIVALS"]["UNIT"]["TILE"]["X"]=other["parent"]["CURX"]
			enemy["AIVALS"]["UNIT"]["TILE"]["Y"]=other["parent"]["CURY"]
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
				if enemy["MODE"]~="ATTACK" then
					-- print "AI FINISHED"
					enemy["MODE"]="ATTACK"
				end
			elseif enemy["MODE"]~="PURSUIT" then
				enemy["MODE"]="PURSUIT"
			end
			enemy["AIVALS"]["CONTACTCD"]=500
		elseif other.CATEGORY=="ENEMY" and enemy["AIVALS"]["UNIT"]["CATEGORY"]~="PLAYER" and other~=self.parent then
			enemy["AIVALS"]["UNIT"]["TILE"]["X"]=other["parent"]["CURX"]
			enemy["AIVALS"]["UNIT"]["TILE"]["Y"]=other["parent"]["CURY"]
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
		if enemy["AIVALS"]["CONTACTCD"]<=0 then
			print "LOST PLAYER"
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
			enemy["AIVALS"]["CONTACTCD"]=500
		end
	end
	physics.addBody(enemy.radar,"dynamic",{isSensor=true,friction=0.5,filter={categoryBits=4,maskBits=2}})
	enemy.radar:addEventListener( "collision", enemy["radar"])
	enemy:insert(enemy["radar"])

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
	local statnames={"Constitution","Dexterity","Strength","Talent","Stamina","Intellect"	}
	for s=1,table.maxn(statnames) do
		local thisstat=statnames[s]
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
	
	enemy:refresh()
	-- enemy:AI()
	-- Runtime:addEventListener("tap",enemy.AI)
	Runtime:addEventListener("enterFrame",enemy.refresh)
	
	return enemy
end

