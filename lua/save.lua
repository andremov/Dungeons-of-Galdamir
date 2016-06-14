---------------------------------------------------------------------------------------
--
-- Saving.lua
--
---------------------------------------------------------------------------------------
module(..., package.seeall)

---------------------------------------------------------------------------------------
-- GLOBAL
---------------------------------------------------------------------------------------
local JSON=require("JSON")
local key={
		"0","1","2","3","4","5","6","7","8","9",
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
		
	} --MAX:62

local function readJSON(saveslot)
	-- call JSON read func to receive lua table with JSON info
	-- adapt JSON info for ease of access
	
	filename = system.pathForFile( saveslot )
	file = assert(io.open(filename, "r"))
	
	-- use JSON library to decode it to a LUA table
	-- then return table
	
	local output = JSON:decode(file:read("*all"))
	
	return parsed
end

local function sumLarge(factor1, factor2)
	factor1=tostring(factor1)
	factor2=tostring(factor2)
	if #factor2>#factor1 then --factor1 siempre es mayor
		local temp=factor2
		factor2=factor1
		factor1=temp
	end
	local result=""
	local curdig=1
	while (#factor2>0 or #factor1>0) do
		local digfactor1=string.sub(factor1,#factor1,#factor1)
		local digfactor2=string.sub(factor2,#factor2,#factor2)
		factor1=string.sub(factor1,1,#factor1-1)
		factor2=string.sub(factor2,1,#factor2-1)
		digfactor1=tonumber(digfactor1)
		digfactor2=tonumber(digfactor2)
		if not (digfactor1) then
			digfactor1=0
		end
		if not (digfactor2) then
			digfactor2=0
		end
		
		local resultdig=digfactor1+digfactor2
		
		if (#result==curdig) then
			local asd=string.sub(result,1,1)
			result=string.sub(result,2,#result)
			asd=tonumber(asd)
			resultdig=resultdig+asd
		end
		resultdig=tostring(resultdig)
		
		result=resultdig..result
		curdig=curdig+1
	end
	return result
end

local function printtable(param,space)
	space=space or ">"
	for k, v in pairs( param ) do
		if type(v)~="table" then
			print(space..k, v)
		else
			print (space..k.."={")
			printtable(v, "-"..space)
			print (space.."}")
		end
	end
end

local function fileContents(filename)
	local path = system.pathForFile(  filename, system.DocumentsDirectory )
	local fh, errStr = io.open( path, "r")
	
	if (fh) then
		local contents = fh:read( "*a" )
		io.close( fh )
		if (contents) then
			return path,contents
		end
	end
	
	return nil,nil
end

function DecimalToBase(base, numero)
	local str=""
	if base>table.maxn(key) then
		assert(false, "LA CAGASTE. BASE MAX="..table.maxn(key))
	else
		while numero>base-1 do
			str=key[(numero%base)+1]..str
			numero=math.floor(numero/base)
		end
		str=key[(numero%base)+1]..str

		return str
	end
end

function BaseToDecimal(base, numero)
	local num=0
	numero=tostring(numero)
	if base>table.maxn(key) then
		assert(false, "LA CAGASTE. BASE MAX="..table.maxn(key))
	else
		-- while numero>base-1 do
		local i=0
		while #numero>0 do
			local dig=string.sub(numero, #numero)
			numero=string.sub(numero, 1, #numero-1)
			
			
			local j=1
			local found=false
			while ( found==false and j<=table.maxn(key) ) do
				if (key[j]==dig) then
					found=true
				else
					j=j+1
				end
			end
			
			if found==false then
				local message="Couldn't find '"..dig.."' in key."
				assert(false, message)
			end
			
			num=num+((j-1)*(base^i))
			i=i+1
		end

		return num
	end
end

function setSlot(value)
	Save["SLOT"]=value
end


---------------------------------------------------------------------------------------
-- SAVE
---------------------------------------------------------------------------------------


Save={}

function Save:keepMapData(map)
	if not (Save["DATA"]) then
		Save["DATA"]={}
	end
	if not (Save["DATA"].maps) then
		Save["DATA"].maps={}
	end
	
	local mapx=map["MAPX"]
	local mapy=map["MAPY"]
	-- map=map["MAP"]
	-- local parsed={}
	-- for i=1,table.maxn(map) do
		-- local fixedcol=map[i]["col"]+1
		-- local fixedrow=map[i]["row"]+1
		-- if type(parsed[fixedcol])~="table" then
			-- parsed[fixedcol]={}
		-- end
		-- if map[i]["open"]==true then
			-- parsed[fixedcol][fixedrow]=1
		-- else
			-- parsed[fixedcol][fixedrow]=0
		-- end
	-- end
	-- map=parsed
	map=map["PLAIN"]
	
	local str=""
	if mapx<0 then
		str=str.."-"
	else
		str=str.."+"
	end
	mapx=math.abs(mapx)
	mapx=DecimalToBase(62,mapx)
	for i=#mapx,1 do
		mapx="0"..mapx
	end
	str=str..mapx
	
	if mapy<0 then
		str=str.."-"
	else
		str=str.."+"
	end
	mapy=math.abs(mapy)
	mapy=DecimalToBase(62,mapy)
	for i=#mapy,1 do
		mapy="0"..mapy
	end
	str=str..mapy
	
	for i=1,table.maxn(map) do
		-- print "-----------------"
		-- print ("FILA "..i)
		local fila=""
		for j=1,table.maxn(map[i]) do
			fila=fila..map[j][i]
		end
		-- print ("RAW: '"..fila.."' : "..#tostring(fila).." digitos.")
		-- fila=tonumber(fila)
		-- print ("RAW: '"..fila.."' : "..#tostring(fila).." digitos.")
		fila=BaseToDecimal(5,fila)
		-- print ("TRAS BASE 5: '"..fila.."' : "..#tostring(fila).." digitos.")
		fila=DecimalToBase(62,fila)
		-- print ("A BASE 62: '"..fila.."' : "..#tostring(fila).." digitos.")
		
		for i=#fila,5 do
			fila="0"..fila
		end
		-- print ("ESTANDAR: '"..fila.."' : "..#tostring(fila).." digitos.")
		-- print (" ")
		
		str=str..fila
	end
	
	local found=false
	local it=1
	-- print "Starting comparison..."
	while (it<=table.maxn(Save["DATA"].maps) and (found==false)  ) do
		-- print ("New: "..str)
		-- print ("Old: "..Save["DATA"].maps[it])
		if Save["DATA"].maps[it]==str then
			found=true
		end
		it=it+1
	end
	-- print ("Finished comparison with verdict: "..tostring(found) )
	if found==false then
		-- print "Did save."
		Save["DATA"].maps[table.maxn(Save["DATA"].maps)+1]=str
	else
		-- print "Didnt save."
	end
	-- print (Save["DATA"].maps)
end

function Save:keepPlayerData(player)
	if not (Save["DATA"]) then
		Save["DATA"]={}
	end
	
	local oldFile=system.pathForFile( "TEMPSave"..Save["SLOT"]..".png", system.DocumentsDirectory)
	if (oldFile) then
		os.remove( oldFile )
	end
	display.save(player,"TEMPSave"..Save["SLOT"]..".png")
	
	local player2={}
	player2["!N"]=player["NAME"] -- STRING
	player2["!G"]=player["GOLD"] -- INT -> INCREASE BASE
	
	player2["!MX"]=player["MAPX"] -- INT -> INCREASE BASE
	player2["!MY"]=player["MAPY"] -- INT -> INCREASE BASE
	player2["!CY"]=player["CURY"] -- INT -> INCREASE BASE
	player2["!CX"]=player["CURY"] -- INT -> INCREASE BASE
	
	player2["!S"]={}
	for i=1,table.maxn(player["STATS"]) do
		player2["!S"][i]=player["STATS"][i]
		player2["!S"][i]["ID"]=nil
		player2["!S"][i]["DESCRIPTION"]=nil
		player2["!S"][i]["NAME"]=nil
		player2["!S"][i]["TOTAL"]=nil
		player2["!S"][i]["!B"]=player2["!S"][i]["BOOST"] -- INT -> INCREASE BASE
		player2["!S"][i]["!N"]=player2["!S"][i]["NATURAL"] -- INT -> INCREASE BASE
		player2["!S"][i]["BOOST"]=nil
		player2["!S"][i]["NATURAL"]=nil
		player2["!S"][i]["EQUIP"]=nil
	end
	
	player2["!E"]=player["STATS"]["Energy"] -- INT -> INCREASE BASE
	player2["!F"]=player["STATS"]["Free"] -- INT -> INCREASE BASE
	player2["!H"]=player["STATS"]["Health"] -- INT -> INCREASE BASE
	player2["!M"]=player["STATS"]["Mana"] -- INT -> INCREASE BASE
	player2["!L"]=player["STATS"]["Level"] -- INT -> INCREASE BASE
	player2["!X"]=player["STATS"]["Experience"] -- INT -> INCREASE BASE
	
	player2["!S"]=player["SPELLS"] -- TABLE -> PARSE
	player2["!I"]=player["INVENTORY"] -- TABLE -> PARSE
	for i=1,table.maxn(player2["!I"]) do
		player2["!I"][i]["!A"]=player2["!I"][i]["AMOUNT"] -- INT -> INCREASE BASE
		player2["!I"][i]["!ID"]=player2["!I"][i]["ID"] -- INT -> INCREASE BASE
		player2["!I"][i]["AMOUNT"]=nil
		player2["!I"][i]["ID"]=nil
	end
	player2["!I"]["SLOTS"]=nil
	player2["!C"]=player["EQUIPMENT"] -- TABLE -> PARSE
	player2["!Q"]=player["QUESTS"] -- TABLE -> PARSE
	
	player=nil
	
	local function crunchTime(victim)
		for k, v in pairs( victim ) do
			if type(v)=="number" then
				-- print (k, v)
				v=DecimalToBase(62,v)
				victim[k]=tostring(v)
				
				for i=#victim,2 do
					victim[k]="0"..victim[k]
				end
			elseif type(v)=="table" then
				crunchTime(v)
			end
		end
	end
	crunchTime(player2)
	
	-- printtable(player2)
	player2=JSON:encode(player2)
	-- print (player2)
	
	player2=string.gsub(player2, "\"", "")
	player2=string.gsub(player2, "\,", "")
	player2=string.gsub(player2, "\:", "")
	Save["DATA"].p1=player2
end

function Save:recordData()
	local path = system.pathForFile(  "Save"..Save["SLOT"]..".sav", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "w+" )
	
	local oldFile=system.pathForFile( "Save"..Save["SLOT"]..".png", system.DocumentsDirectory)
	if (oldFile) then
		os.remove( oldFile )
	end
	os.rename( system.pathForFile( "TEMPSave"..Save["SLOT"]..".png", system.DocumentsDirectory ), system.pathForFile( "Save"..Save["SLOT"]..".png", system.DocumentsDirectory )	)
	
	fh:write( Save["DATA"].p1, "\n" )
	fh:write( JSON:encode_pretty(Save["DATA"].maps), "\n" )
	io.close( fh )
end



---------------------------------------------------------------------------------------
-- LOAD
---------------------------------------------------------------------------------------

Load={}

function Load:retrieveData()
	local path,contents=fileContents("Save"..Save["SLOT"]..".sav")
	if (contents) then
		local player
		local maps
		local player2
		for line,a in io.lines( path ) do
			if not(player) then
				player=line
			else
				maps=line
			end
		end
		maps=JSON:decode(maps)
		
		if not (Save["DATA"]) then
			Save["DATA"]={}
		end
		
		Save["DATA"].maps=maps
		Save["DATA"].p1=player
		
		-- print ("INTERPRETING...")
		-- print ("RAW: "..player)
		player2=string.gsub(player,"\!%u+","\"\,\"%1\":\"")
		player2="{"..string.sub(player2,4)
		player2=string.sub(player2,1,#player2-1).."\"}"
		-- print ("UNCRUNCHED: "..player2)
		
		-- NAME FIX
		local one,two=string.find(player2,"\!N.+\,\"\!Q")
		local asd=string.sub(player2,one,two-5)
		asd=string.gsub(asd,"\":\"","")
		asd=string.gsub(asd,"\!N","\!N\":\"")
		asd=asd.."\",\"!Q"
		player2=string.gsub(player2,"\!N.+\,\"\!Q",asd)
		-- print ("NAME FIX: "..player2)
		
		-- EQUIPS FIX
		local one,two=string.find(player2,"\!C\".+\,\"\!CX")
		local asd=string.sub(player2,one+4,two-4)
		asd=string.gsub(asd,"\"","")
		asd="!C\":"..asd.."\"!CQ"
		player2=string.gsub(player2,"\!C\".+\,\"\!CX",asd)
		-- print ("EQUIPS FIX: "..player2)
		
		-- SPELLS FIX
		local one,two=string.find(player2,"\!S.+\,\"\!X")
		local asd=string.sub(player2,one+4,two-4)
		asd=string.gsub(asd,"\"","")
		asd="!S\":"..asd..",\"!X"
		player2=string.gsub(player2,"\!S.+\,\"\!X",asd)
		-- print ("SPELLS FIX: "..player2)
		
		-- QUESTS FIX
		local one,two=string.find(player2,"\!Q.+\,\"\!S")
		local asd=string.sub(player2,one+4,two-4)
		asd=string.gsub(asd,"\"","")
		asd="!Q\":"..asd..",\"!S"
		player2=string.gsub(player2,"\!Q.+\,\"\!S",asd)
		-- print ("QUESTS FIX: "..player2)
		
		-- INVENTORY FIX
		local one,two=string.find(player2,"\!I\".+\,\"\!L")
		local asd=string.sub(player2,one+4,two-4)
		asd=string.gsub(asd,"\"","")
		asd=string.gsub(asd,"}{","},{")
		asd=string.gsub(asd,",","",1)
		asd=string.gsub(asd,"!A:","\"!A\":\"")
		asd=string.gsub(asd,"!ID:","\"!ID\":\"")
		asd=string.gsub(asd,"}","\"}")
		asd=string.gsub(asd,",","\",")
		asd=string.gsub(asd,"}\",","},")
		asd=string.gsub(asd,"\",\"!A","\"!A")
		asd="!I\":"..asd..",\"!L"
		player2=string.gsub(player2,"\!I\".+\,\"\!L",asd)
		-- print ("INVENTORY FIX: "..player2)
		
		-- print ("FIXES DONE:"..player2)
		player2=JSON:decode(player2)
		-- print ("JSONDECODED: ")
		-- printtable(player2)
		
		
		for k, v in pairs( player2 ) do
			if type(v)=="table" then
				for i=1,table.maxn(player2[k]) do
					for l, w in pairs( player2[k][i] ) do
						player2[k][i][l]=BaseToDecimal(62,w)
					end
				end
			elseif type(v)=="string" and k~="!N" then
				player2[k]=BaseToDecimal(62,v)
			end
		end
		
		return (player2)
	end
	return nil
end

function Load:getName(slot)
	local path,contents=fileContents("Save"..slot..".sav")
	if (contents) then
		local name
		for line,a in io.lines( path ) do
			if not(name) then
				name=line
			end
		end
		
		name=string.gsub(name,"\!%u+","\"\,\"%1\":\"")
		
		local one,two=string.find(name,"\!N.+\,\"\!Q")
		name=string.sub(name,one,two-5)
		name=string.gsub(name,"\":\"","")
		name=string.gsub(name,"\!N","")
		
		return (name)
	end
	return nil
end

function Load:getExtraInfo(slot)
	local path,contents=fileContents("Save"..slot..".sav")
	if (contents) then
		local info
		for line,a in io.lines( path ) do
			if not(info) then
				info=line
			end
		end
		
		info=string.gsub(info,"\!%u+","\"\,\"%1\":\"")
		
		local one,two=string.find(info,"\!G.+\,\"\!H")
		local gold=string.sub(info,one+5,two-5)
		
		one,two=string.find(info,"\!L.+\,\"\!M\"")
		local level=string.sub(info,one+5,two-6)
		
		gold=BaseToDecimal(62,gold)
		level=BaseToDecimal(62,level)
		
		return gold,level
	end
	return nil
end

function Load:getMap(mapx,mapy)
	local found=false
	local counter=1
	if (Save["DATA"]) and (Save["DATA"].maps) then
		while found==false and counter<=table.maxn(Save["DATA"].maps) do
			
			local thismapx=string.sub(Save["DATA"].maps[counter],1,3)
			
			local xneg=string.sub(thismapx,1,1)
			thismapx=string.sub(thismapx,2)
			thismapx=BaseToDecimal(62,thismapx)
			if xneg=="-" then
				thismapx=thismapx*-1
			end
			
			local thismapy=string.sub(Save["DATA"].maps[counter],4,6)
			
			local yneg=string.sub(thismapy,1,1)
			thismapy=string.sub(thismapy,2)
			thismapy=BaseToDecimal(62,thismapy)
			if yneg=="-" then
				thismapy=thismapy*-1
			end
			
			if thismapx==mapx and thismapy==mapy then
				found=true
			else
				counter=counter+1
			end
		end
		
		if found==true then
			local parsed={}
			local mapinfo=string.sub(Save["DATA"].maps[counter],7)
			for i=1,#mapinfo/6 do
				local stringpos=(i*6)
				parsed[i]=string.sub(mapinfo,stringpos-5, stringpos)
			end
			mapinfo=nil
			for i=1,table.maxn(parsed) do
				parsed[i]=BaseToDecimal(62,parsed[i])
				parsed[i]=DecimalToBase(5,parsed[i])
				for j=#parsed[i],13 do
					parsed[i]="0"..parsed[i]
				end
				local estacol={}
				for j=1,#parsed[i] do
					estacol[j]=tonumber(string.sub(parsed[i],j, j))
				end
				parsed[i]=estacol
			end
			
			for i=1,table.maxn(parsed) do
				for j=i,table.maxn(parsed[i]) do
					local temp=parsed[i][j]
					parsed[i][j]=parsed[j][i]
					parsed[j][i]=temp
				end
			end
		
			return parsed
		end
	end
	return nil
end

---------------------------------------------------------------------------------------
-- ERASE
---------------------------------------------------------------------------------------

Erase={}

function Erase:clearSave(slot)
	local path = system.pathForFile(  "Save"..slot..".sav", system.DocumentsDirectory )
	local success,errstr=os.remove(path)
end


