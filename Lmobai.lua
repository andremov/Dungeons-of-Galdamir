-----------------------------------------------------------------------------------------
--
-- Mobai.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local builder=require("LMapBuilder")
local handler=require("LMapHandler")
local p=require("Lplayers")
local ui=require("LUI")
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

function DoTurns()
	DidSomething=false
	map=builder.GetData()
	boundary=builder.GetData(2)
	size=builder.GetData(0)
	p1=p.GetPlayer()
	col={}
	row={}
	pos=p1.loc
	
	for i=1, table.maxn( mobs ) do
		if (mobs[i]) then
			CanMove[i]=true
		end
	end
	
	for i=1, table.maxn( mobs ) do
		if (mobs[i]) then
			col[i]=(math.floor(mobs[i].loc%(math.sqrt(size))))
			row[i]=(math.floor(mobs[i].loc/(math.sqrt(size))))+1
			p1=p.GetPlayer()
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
			if boundary[(mobs[i].loc)-(math.sqrt(size))]==0 then
				CanGoUp=false
			end
			
			if boundary[(mobs[i].loc)+(math.sqrt(size))]==0 then
				CanGoDown=false
			end
			
			if boundary[(mobs[i].loc)-1]==0 then
				CanGoLeft=false
			end
			
			if boundary[(mobs[i].loc)+1]==0 then
				CanGoRight=false
			end
			
			--Other Mob Collision Checks
			for  g=1, table.maxn( mobs ) do
				if (mobs[g]) then
					if mobs[i].loc==(mobs[g].loc+(math.sqrt(size))) then
						CanGoUp=false
					end
					
					if mobs[i].loc==(mobs[g].loc-(math.sqrt(size))) then
						CanGoDown=false
					end
					
					if mobs[i].loc==(mobs[g].loc+1) then
						CanGoLeft=false
					end
					
					if mobs[i].loc==(mobs[g].loc-1) then
						CanGoRight=false
					end
				end
			end
		
			--Attacking Checks
			if 	mobs[i].loc==p1.loc+1 or 
				mobs[i].loc==p1.loc-1 or 
				mobs[i].loc==p1.loc-(math.sqrt(size)) or 
				mobs[i].loc==p1.loc+(math.sqrt(size)) and 
				CanMove[i]==true then
			--	Before movement, mob is in contact with player.
				function closure()
					c.Attacked(mobs[i])
				end
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if mobs[i].loc==p1.loc-(1*2) and CanGoRight==true and CanMove[i]==true then
			--	Before movement, player is in attack range
				MoveRight(i)
				function closure()
					c.Attacked(mobs[i])
				end
				
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if mobs[i].loc==p1.loc+(1*2) and CanGoLeft==true and CanMove[i]==true then
			--	Before movement, player is in attack range
				MoveLeft(i)
				function closure()
					c.Attacked(mobs[i])
				end
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if mobs[i].loc==p1.loc+((math.sqrt(size))*2) and CanGoUp==true and CanMove[i]==true then
			--	Before movement, player is in attack range
				MoveUp(i)
				function closure()
					c.Attacked(mobs[i])
				end
				timer.performWithDelay(100,closure)
				CanMove[i]=false
				DidSomething=true
			end
			
			if mobs[i].loc==p1.loc-((math.sqrt(size))*2) and CanGoDown==true and CanMove[i]==true then
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
				
			if mobs[i].loc==p1.loc+1 or 
				mobs[i].loc==p1.loc-1 or 
				mobs[i].loc==p1.loc-(math.sqrt(size)) or 
				mobs[i].loc==p1.loc+(math.sqrt(size)) then
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
	DidSomething=false
	if DidSomething==false then
		timer.performWithDelay(20,mov.ShowArrows)
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
		
		for i=1, table.maxn( mobs ) do
			if (mobs[i]) and mobs[i].live==1 then
				if mobs[i].loc==MS.loc then
					CanSpawn=false
				end
			end
		end
		p1=p.GetPlayer()
		if p1.loc==MS.loc then
			CanSpawn=false
		end
		
		if CanSpawn==true and SpawnCD==0 then
			LifeOverDeath(MS.loc)
			SpawnCD=5
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
	for i=1, table.maxn(mobs) do
		if data==mobs[i] then
			display.remove(mobs[i])
			mobs[i]=nil
		end
	end
end

function LifeOverDeath(id)
	local TSet=handler.GetTiles()
	local level=builder.GetData(3)
	mobs[#mobs+1]=display.newImageRect( "tiles/"..TSet.."/mob.png",80,80)
	mobs[#mobs].x=304+((((id-1)%math.sqrt(size)))*80)
	mobs[#mobs].y=432+(math.floor((id-1)/math.sqrt(size))*80)
	mobs[#mobs].loc=(id)
	if map[mobs[#mobs].loc].isVisible==false then
		mobs[#mobs].isVisible=false
	end
	level:insert(mobs[#mobs])
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
		mobs[i].x=mobs[i].x-80
		mobs[i].loc=(mobs[i].loc-1)
		if (map[mobs[i].loc].isVisible) then
			if map[mobs[i].loc].isVisible==false then
				mobs[i].isVisible=false
			elseif map[mobs[i].loc].isVisible==true then
				mobs[i].isVisible=true
			end
		else
			mobs[i].isVisible=false
		end
	end
end	
	
function MoveUp(i)
	if CanMove[i]==true then
		CanMove[i]=false
		mobs[i].y=mobs[i].y-80
		mobs[i].loc=(mobs[i].loc-(math.sqrt(size)))
		if (map[mobs[i].loc].isVisible) then
			if map[mobs[i].loc].isVisible==false then
				mobs[i].isVisible=false
			elseif map[mobs[i].loc].isVisible==true then
				mobs[i].isVisible=true
			end
		else
			mobs[i].isVisible=false
		end
	end
end
	
function MoveDown(i)
	if CanMove[i]==true then
		CanMove[i]=false
		mobs[i].y=mobs[i].y+80
		mobs[i].loc=(mobs[i].loc+(math.sqrt(size)))
		if (map[mobs[i].loc].isVisible) then
			if map[mobs[i].loc].isVisible==false then
				mobs[i].isVisible=false
			elseif map[mobs[i].loc].isVisible==true then
				mobs[i].isVisible=true
			end
		else
			mobs[i].isVisible=false
		end
	end
end

function MoveRight(i)
	if CanMove[i]==true then
		CanMove[i]=false
		mobs[i].x=mobs[i].x+80
		mobs[i].loc=(mobs[i].loc+1)
		if (map[mobs[i].loc].isVisible) then
			if map[mobs[i].loc].isVisible==false then
				mobs[i].isVisible=false
			elseif map[mobs[i].loc].isVisible==true then
				mobs[i].isVisible=true
			end
		else
			mobs[i].isVisible=false
		end
	end
end

function WipeMobs()
	if (mobs) then
		for i=table.maxn(mobs),1,-1 do
			local child = mobs[i]
			if (child) then
				display.remove(child)
				child=nil
			end
		end
		mobs=nil
	else
		builder.GetMobGroup(true)
	end
end
	