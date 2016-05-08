module(..., package.seeall)

function Font()
	--
	local g = display.newGroup()
	local fonts = native.getFontNames()
	local count, found_count = 0, 0
	
	for i,fontname in ipairs(fonts) do
		count = count+1
		j, k = string.find(fontname, "Mono")
		if (j ~= nil) then
			found_count = found_count + 1
			print("found font: \""..fontname.."\"")
			local obj = display.newText(fontname, 0, 50+((found_count-1)*40), fontname, 48)
			g:insert(obj)
			obj:setFillColor(1, 1, 1)
			obj.x=display.contentWidth/2
		end
	end
	print ("Font count: " .. count)
	local count_text = display.newText("Found " .. count .. " fonts.", 0, 50+((found_count)*40), fontname, 32)
			count_text.x=display.contentWidth/2
	g:insert(count_text)
	g:toFront()
	count_text:setFillColor(1, 1, 1)
	--	
end

function CalcMoves(level)
	-- 'level' should be player's boundaries
	local openlist={}  --Possible Moves
	local closedlist={}  --Checked Squares
	local listk=1  -- open list counter
    local closedk=0  -- Closedlist counter
	local tempG = 0
	local size  = table.maxn(level)
	local xsize = math.sqrt(size)
	local ysize = xsize
	local curSquare = {}
	local curSquareIndex = 1	 -- Index of current base
	local startX=2
	local startY=2
	local targetX=ysize-2
	local targetY=xsize-1
	local tempH = math.abs(startX-targetX) + math.abs(startY-targetY)
	openlist[1] = {x = startX, y = startY, g = 0, h = tempH, f = 0 + tempH ,par = 1}
	local board={}
	
	for i = 1, table.maxn(level) do
		board[i] = {}
		for j = 1, table.maxn(level) do
			board[i][j]={}
			if level[(i+((j-1)*xsize))]==1 then
				board[i][j].isObstacle = 0
			else
				board[i][j].isObstacle = 1
			end
		end
	end
	
	while listk > 0 do
     	local lowestF = openlist[listk].f
	  	curSquareIndex = listk
		for k = listk, 1, -1 do
  		    if openlist[k].f < lowestF then
  		       lowestF = openlist[k].f
               curSquareIndex = k
	       	end
		end

		closedk = closedk + 1
		table.insert(closedlist,closedk,openlist[curSquareIndex])

		curSquare = closedlist[closedk]				 -- define current base from which to grow list

		local rightOK = true
		local leftOK = true           				 -- Booleans defining if they're OK to add
		local downOK = true             				 -- (must be reset for each while loop)
		local upOK = true

		-- Look through closedlist. Makes sure that the path doesn't double back
		if closedk > 0 then
		    for k = 1, closedk do
				if closedlist[k].x == curSquare.x + 1 and closedlist[k].y == curSquare.y then
					rightOK = false
				end
				if closedlist[k].x == curSquare.x-1 and closedlist[k].y == curSquare.y then
					leftOK = false
				end
				if closedlist[k].x == curSquare.x and closedlist[k].y == curSquare.y + 1 then
					downOK = false
				end
				if closedlist[k].x == curSquare.x and closedlist[k].y == curSquare.y - 1 then
					upOK = false
				end
		    end
		end
		
		-- Check if next points are on the map and within moving distance
		if curSquare.x + 1 > xsize then
			rightOK = false
		end
		if curSquare.x - 1 < 1 then
			leftOK = false
		end
		if curSquare.y + 1 > ysize then
			downOK = false
		end
		if curSquare.y - 1 < 1 then
			upOK = false
		end

		-- If it IS on the map, check map for obstacles
		--(Lua returns an error if you try to access a table position that doesn't exist, so you can't combine it with above)
		
		if curSquare.x + 1 <= xsize and board[curSquare.x+1][curSquare.y].isObstacle ~= 0 then
			rightOK = false
		end
		if curSquare.x - 1 >= 1 and board[curSquare.x-1][curSquare.y].isObstacle ~= 0 then
			leftOK = false
		end
		if curSquare.y + 1 <= ysize and board[curSquare.x][curSquare.y+1].isObstacle ~= 0 then
			downOK = false
		end
		if curSquare.y - 1 >= 1 and board[curSquare.x][curSquare.y-1].isObstacle ~= 0 then
			upOK = false
		end
		
		-- check if the move from the current base is shorter then from the former parrent
		tempG =curSquare.g + 1
		for k=1,listk do
		    if rightOK and openlist[k].x==curSquare.x+1 and openlist[k].y==curSquare.y and openlist[k].g>tempG then
			tempH=math.abs((curSquare.x+1)-targetX)+math.abs(curSquare.y-targetY)
			table.insert(openlist,k,{x=curSquare.x+1, y=curSquare.y, g=tempG, h=tempH, f=tempG+tempH, par=closedk})
			rightOK=false
		    end
		
		    if leftOK and openlist[k].x==curSquare.x-1 and openlist[k].y==curSquare.y and openlist[k].g>tempG then
			tempH=math.abs((curSquare.x-1)-targetX)+math.abs(curSquare.y-targetY)
			table.insert(openlist,k,{x=curSquare.x-1, y=curSquare.y, g=tempG, h=tempH, f=tempG+tempH, par=closedk})
			leftOK=false
		    end

		    if downOK and openlist[k].x==curSquare.x and openlist[k].y==curSquare.y+1 and openlist[k].g>tempG then
			tempH=math.abs((curSquare.x)-targetX)+math.abs(curSquare.y+1-targetY)
			table.insert(openlist,k,{x=curSquare.x, y=curSquare.y+1, g=tempG, h=tempH, f=tempG+tempH, par=closedk})
			downOK=false
		    end

		    if upOK and openlist[k].x==curSquare.x and openlist[k].y==curSquare.y-1 and openlist[k].g>tempG then
			tempH=math.abs((curSquare.x)-targetX)+math.abs(curSquare.y-1-targetY)
			table.insert(openlist,k,{x=curSquare.x, y=curSquare.y-1, g=tempG, h=tempH, f=tempG+tempH, par=closedk})
			upOK=false
		    end
   		end

		-- Add points to openlist
		-- Add point to the right of current base point
		if rightOK then
			listk=listk+1
			tempH=math.abs((curSquare.x+1)-targetX)+math.abs(curSquare.y-targetY)
			table.insert(openlist,listk,{x=curSquare.x+1, y=curSquare.y, g=tempG, h=tempH, f=tempG+tempH, par=closedk})
		end

		-- Add point to the left of current base point
		if leftOK then
			listk=listk+1
			tempH=math.abs((curSquare.x-1)-targetX)+math.abs(curSquare.y-targetY)
			table.insert(openlist,listk,{x=curSquare.x-1, y=curSquare.y, g=tempG, h=tempH, f=tempG+tempH, par=closedk})
		end

		-- Add point on the top of current base point
		if downOK then
			listk=listk+1
			tempH=math.abs(curSquare.x-targetX)+math.abs((curSquare.y+1)-targetY)
			table.insert(openlist,listk,{x=curSquare.x, y=curSquare.y+1, g=tempG, h=tempH, f=tempG+tempH, par=closedk})
		end

		-- Add point on the bottom of current base point
		if upOK then
			listk=listk+1
			tempH=math.abs(curSquare.x-targetX)+math.abs((curSquare.y-1)-targetY)
			table.insert(openlist,listk,{x=curSquare.x, y=curSquare.y-1, g=tempG, h=tempH, f=tempG+tempH, par=closedk})
		end

		table.remove(openlist,curSquareIndex)
		listk=listk-1

        if closedlist[closedk].x==targetX and closedlist[closedk].y==targetY then
        	return closedlist
        end
	end

	return nil
end

function CalcPath(closedlist)
	if closedlist==nil then
        return nil
	end
	
	local path={}
	local pathIndex={}
	local last=table.getn(closedlist)
	table.insert(pathIndex,1,last)

	local i=1
	while pathIndex[i]>1 do
	i=i+1
	table.insert(pathIndex,i,closedlist[pathIndex[i-1] ].par)
	end

	for n=table.getn(pathIndex),1,-1 do
	table.insert(path,{x=closedlist[pathIndex[n] ].x, y=closedlist[pathIndex[n] ].y})
	end
	closedlist=nil
	return path
end

function animate(level)
	path = CalcPath(CalcMoves(level))
	if path==nil then
		return false
	else
		return true
	end
end
