-----------------------------------------------------------------------------------------
--
-- Mobai.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local builder=require("Lmapbuilder")
local handler=require("Lmaphandler")
local p=require("Lplayers")
local ui=require("Lui")
local c=require("Lcombat")
local mov=require("Lmovement")
local isDead
local mobs
local CanGoUp
local CanGoLeft
local CanGoRight
local CanGoDown
local map
local boundary
local size
local p1
local pos
local LocDec
local CanMove={}
local col
local row
local SpawnCD=5
local DidSomething
local scale=1.2
local espacio=80*scale

function DoTurns()
	DidSomething=false
	map=builder.GetData()
	fog=builder.GetData(10)
	boundary=builder.GetData(2)
	size=builder.GetData(0)
	p1=p.GetPlayer()
	col={}
	row={}
	pos=p1.loc
	
	for i in pairs( mobs[p1.room] ) do
		CanMove[i]=true
	end
	
	for i in pairs( mobs[p1.room] ) do
		if not(mobs[p1.room][i].loc) then
		--	display.remove(mobs[i])
		--	mobs[i]=nil
			print (i.." is a problem.")
		else
		--	print ("TURN: "..mobs[i].loc)
			col[i]=(math.floor(mobs[p1.room][i].loc%(math.sqrt(size))))
			row[i]=(math.floor(mobs[p1.room][i].loc/(math.sqrt(size))))+1
			CanGoUp=true
			CanGoLeft=true
			CanGoRight=true
			CanGoDown=true
		
			--Boundary Checks
			if (row[i])==2 then
				CanGoUp=false
			end
			
			if (row[i])==(math.sqrt(size)-1) then
				CanGoDown=false
			end
			
			if col[i]==2 then
				CanGoLeft=false
			end
			
			if col[i]==(math.sqrt(size)-1) then
				CanGoRight=false
			end
			
			--Collision Checks
			if boundary[(mobs[p1.room][i].loc)-(math.sqrt(size))]==0 then
				CanGoUp=false
			end
			
			if boundary[(mobs[p1.room][i].loc)+(math.sqrt(size))]==0 then
				CanGoDown=false
			end
			
			if boundary[(mobs[p1.room][i].loc)-1]==0 then
				CanGoLeft=false
			end
			
			if boundary[(mobs[p1.room][i].loc)+1]==0 then
				CanGoRight=false
			end
			
			--Other Mob Collision Checks
			for  g in pairs( mobs[p1.room] ) do
				if not (mobs[p1.room][g].loc) then
				--	display.remove(mobs[g])
				--	mobs[g]=nil
					print (g.." is a problem.")
				else
					if mobs[i].loc==(mobs[p1.room][g].loc+(math.sqrt(size))) then
						CanGoUp=false
					end
					
					if mobs[i].loc==(mobs[p1.room][g].loc-(math.sqrt(size))) then
						CanGoDown=false
					end
					
					if mobs[i].loc==(mobs[p1.room][g].loc+1) then
						CanGoLeft=false
					end
					
					if mobs[i].loc==(mobs[p1.room][g].loc-1) then
						CanGoRight=false
					end
				end
			end
		
			--Attacking Checks
			if 	mobs[p1.room][i].loc==p1.loc+1 or 
				mobs[p1.room][i].loc==p1.loc-1 or 
				mobs[p1.room][i].loc==p1.loc-(math.sqrt(size)) or 
				mobs[p1.room][i].loc==p1.loc+(math.sqrt(size)) and 
				CanMove[i]==true then
			--	Before movement, mob is in contact with player.
				function closure()
					c.Attacked(mobs[i])
				end
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if mobs[p1.room][i].loc==p1.loc-(1*2) and CanGoRight==true and CanMove[i]==true then
			--	Before movement, player is in attack range
				MoveRight(i)
				function closure()
					c.Attacked(mobs[i])
				end
				
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if mobs[p1.room][i].loc==p1.loc+(1*2) and CanGoLeft==true and CanMove[i]==true then
			--	Before movement, player is in attack range
				MoveLeft(i)
				function closure()
					c.Attacked(mobs[i])
				end
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if mobs[p1.room][i].loc==p1.loc+((math.sqrt(size))*2) and CanGoUp==true and CanMove[i]==true then
			--	Before movement, player is in attack range
				MoveUp(i)
				function closure()
					c.Attacked(mobs[i])
				end
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if mobs[p1.room][i].loc==p1.loc-((math.sqrt(size))*2) and CanGoDown==true and CanMove[i]==true then
			--	Before movement, player is in attack range
				MoveDown(i)
				function closure()
					c.Attacked(mobs[i])
				end
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if CanMove[i]==true then
				Decision(i)
			end	
				
			if mobs[p1.room][i].loc==p1.loc+1 or 
				mobs[p1.room][i].loc==p1.loc-1 or 
				mobs[p1.room][i].loc==p1.loc-(math.sqrt(size)) or 
				mobs[p1.room][i].loc==p1.loc+(math.sqrt(size)) then
				--	After movement, mob is in contact with player.
				function closure()
					c.Attacked(mobs[i])
				end
				timer.performWithDelay(100,closure)
				DidSomething=true
			end
		end
	end
	MobSpawn()
	if DidSomething==false then
		timer.performWithDelay(20,mov.Visibility)
	end
end

function MobSpawn()
	local CanSpawn=false
	local MS=builder.GetMSpawner()
	if SpawnCD>0 then
		SpawnCD=SpawnCD-1
	end
	
	if (MS) then
		CanSpawn=true
		
		for i in pairs( mobs[MS.room] ) do
			if mobs[MS.room][i].loc==MS.loc then
				CanSpawn=false
			end
		end
		p1=p.GetPlayer()
		if p1.loc==MS.loc and MS.room==p1.room then
			CanSpawn=false
		end
		
		if CanSpawn==true and SpawnCD==0 then
			LifeOverDeath(MS.loc,MS.room)
			SpawnCD=math.random(10,15)
		end
		
	end
end

function GetMobGroup()
	return mobs
end

function ReceiveMobs(data)
	mobs=data
end

function MobDied(data)
	if mobs==nil then
		mobs=builder.GetMobGroup(false)
	end
	for i in pairs(mobs) do
		if data==mobs[i] then
			display.remove(mobs[i])
			mobs[i]=nil
		end
	end
end

function LifeOverDeath(id,room)
	local TSet=handler.GetTiles()
	local level=builder.GetData(3)
	local zergOff=false
	for m=1,size do
		if not(mobs[room][m]) and zergOff==false then
			mobs[room][m]=display.newImageRect( "tiles/"..TSet.."/mob.png",80,80)
			mobs[room][m].x=((((id-1)%math.sqrt(size)))*espacio)
			mobs[room][m].y=(math.floor((id-1)/math.sqrt(size))*espacio)
			mobs[room][m].loc=(id)
			mobs[room][m].room=(room)
			mobs[room][m].xScale=scale
			mobs[room][m].yScale=mobs[room][m].xScale
			mobs[room][m].isVisible=false
			level:insert(mobs[room][m])
			zergOff=true
		end
	end
end

function Decision(i)	
	if CanMove[i]==true then
		LocDec=math.random(1,4)
		if LocDec==1 and CanGoUp==true then
			MoveUp(i)
		elseif LocDec==2 and CanGoRight==true then
			MoveRight(i)
		elseif LocDec==3 and CanGoDown==true then
			MoveDown(i)
		elseif LocDec==4 and CanGoLeft==true then
			MoveLeft(i)
		elseif CanGoUp==false and CanGoRight==false and CanGoDown==false and CanGoLeft==false then
			CanMove[i]=false
		else
			Decision(i)
		end
	end
end

function MoveLeft(i)
	if CanMove[i]==true then
		CanMove[i]=false
		mobs[p1.room][i].x=mobs[p1.room][i].x-espacio
		mobs[p1.room][i].loc=(mobs[p1.room][i].loc-1)
		if (map[mobs[p1.room][i].loc])and(map[mobs[p1.room][i].loc].isVisible)and(fog[mobs[p1.room][i].loc].isVisible)then
			if map[mobs[p1.room][i].loc].isVisible==false or fog[mobs[p1.room][i].loc].isVisible==true then
				mobs[p1.room][i].isVisible=false
			elseif map[mobs[p1.room][i].loc].isVisible==true and fog[mobs[p1.room][i].loc].isVisible==false then
				mobs[p1.room][i].isVisible=true
			else
				mobs[p1.room][i].isVisible=false
			end
		else
			mobs[p1.room][i].isVisible=false
		end
	end
end	
	
function MoveUp(i)
	if CanMove[i]==true then
		CanMove[i]=false
		mobs[p1.room][i].y=mobs[p1.room][i].y-espacio
		mobs[p1.room][i].loc=(mobs[p1.room][i].loc-(math.sqrt(size)))
		if (map[mobs[p1.room][i].loc])and(map[mobs[p1.room][i].loc].isVisible)and(fog[mobs[p1.room][i].loc].isVisible)then
			if map[mobs[p1.room][i].loc].isVisible==false or fog[mobs[p1.room][i].loc].isVisible==true then
				mobs[p1.room][i].isVisible=false
			elseif map[mobs[p1.room][i].loc].isVisible==true and fog[mobs[p1.room][i].loc].isVisible==false then
				mobs[p1.room][i].isVisible=true
			else
				mobs[p1.room][i].isVisible=false
			end
		else
			mobs[p1.room][i].isVisible=false
		end
	end
end
	
function MoveDown(i)
	if CanMove[i]==true then
		CanMove[i]=false
		mobs[p1.room][i].y=mobs[p1.room][i].y+espacio
		mobs[p1.room][i].loc=(mobs[p1.room][i].loc+(math.sqrt(size)))
		if (map[mobs[p1.room][i].loc])and(map[mobs[p1.room][i].loc].isVisible)and(fog[mobs[p1.room][i].loc].isVisible)then
			if map[mobs[p1.room][i].loc].isVisible==false or fog[mobs[p1.room][i].loc].isVisible==true then
				mobs[p1.room][i].isVisible=false
			elseif map[mobs[p1.room][i].loc].isVisible==true and fog[mobs[p1.room][i].loc].isVisible==false then
				mobs[p1.room][i].isVisible=true
			else
				mobs[p1.room][i].isVisible=false
			end
		else
			mobs[p1.room][i].isVisible=false
		end
	end
end

function MoveRight(i)
	if CanMove[i]==true then
		CanMove[i]=false
		mobs[p1.room][i].x=mobs[i].x+espacio
		mobs[p1.room][i].loc=(mobs[p1.room][i].loc+1)
		if (map[mobs[p1.room][i].loc])and(map[mobs[p1.room][i].loc].isVisible)and(fog[mobs[p1.room][i].loc].isVisible)then
			if map[mobs[p1.room][i].loc].isVisible==false or fog[mobs[p1.room][i].loc].isVisible==true then
				mobs[p1.room][i].isVisible=false
			elseif map[mobs[p1.room][i].loc].isVisible==true and fog[mobs[p1.room][i].loc].isVisible==false then
				mobs[p1.room][i].isVisible=true
			else
				mobs[p1.room][i].isVisible=false
			end
		else
			mobs[p1.room][i].isVisible=false
		end
	end
end

function WipeMobs()
	if (mobs) then
		for r=table.maxn(mobs),1,-1 do
			for i=table.maxn(mobs[r]),1,-1 do
				local child = mobs[r][i]
				if (child) then
					display.remove(child)
					child=nil
				end
			end
		end
		mobs=nil
	end
end
	