-----------------------------------------------------------------------------------------
--
-- Movement.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local b=require("Lmapbuilder")
local p=require("Lplayers")
local WD=require("Lprogress")
local ui=require("Lui")
local coll=require("Ltileevents")
local mob=require("Lmobai")
local c=require("Lcombat")
local sho=require("Lshop")
local mobs
local mright
local mup
local mdown
local mleft
local inter
local scale=1.2
local espacio=80*scale
local yinicial=display.contentHeight/2
local xinicial=display.contentWidth/2
local Toggle=math.random(5,10)

function ShowArrows(value)
	if value=="clean" then
		display.remove(mup)
		display.remove(mdown)
		display.remove(mleft)
		display.remove(mright)
		display.remove(inter)
	else
		Key=coll.onKeyCollision()
		Dropped=coll.onChestCollision()
		Slowed=coll.onWaterCollision()
		coll.onLavaCollision()
		coll.onRockCollision()
		coll.LayOnHands()
		coll.LayOnHead()
		coll.LayOnFeet()
		
		if Dropped==true or Key==true then
			display.remove(mup)
			display.remove(mleft)
			display.remove(mdown)
			display.remove(mright)
			display.remove(inter)
		elseif Toggle<=0 then
			display.remove(mup)
			display.remove(mleft)
			display.remove(mdown)
			display.remove(mright)
			display.remove(inter)
			Toggle=math.random(5,10)
			mob.DoTurns()
		else
			Ports=coll.PortCheck()
			Shop=coll.ShopCheck()
			CanMoveDown=true
			CanMoveLeft=true
			CanMoveUp=true
			CanMoveRight=true
			boundary=b.GetData(1)
			size=b.GetData(0)
			p1=p.GetPlayer()
			col=((p1.loc)%math.sqrt(size))
			row=(math.floor((p1.loc)/math.sqrt(size)))
			
			print ("ROOM: "..p1.room.." LOC: "..p1.loc)
			
			display.remove(mup)
			display.remove(mleft)
			display.remove(mdown)
			display.remove(mright)
			display.remove(inter)
			
			mobs=mob.GetMobGroup()
			--[[
			--Boundary Checks
			if (row+1)==2 then
				CanAttackUp=false
				CanMoveUp=false
			end
			
			if (row+1)==(math.sqrt(size)-1) then
				CanAttackDown=false
				CanMoveDown=false
			end
			
			if col==2 then
				CanAttackLeft=false
				CanMoveLeft=false
			end
			
			if col==(math.sqrt(size)-1) then
				CanAttackRight=false
				CanMoveRight=false
			end
			--]]
			--Wall Collision Checks
			if boundary[p1.loc-math.sqrt(size)]==0 then
				CanAttackUp=false
				CanMoveUp=false
			end
			
			if boundary[p1.loc+math.sqrt(size)]==0 then
				CanAttackDown=false
				CanMoveDown=false
			end
			
			if boundary[p1.loc-1]==0 then
				CanAttackLeft=false
				CanMoveLeft=false
			end
			
			if boundary[p1.loc+1]==0 then
				CanAttackRight=false
				CanMoveRight=false
			end
			
			--Mob Collision Checks 
			
			for i=1, table.maxn(mobs) do
				if (mobs[i]) then
					if (mobs[i].loc==p1.loc-(math.sqrt(size))) then
						mup=display.newImageRect("interact1.png",80,80)
						mup.x=xinicial
						mup.y=yinicial-espacio
						mup.xScale=scale
						mup.yScale=mup.xScale
						mup:toFront()		
						mup:addEventListener( "touch",attackup)
						CanMoveUp=false
					end
				end		
			end

			for i=1, table.maxn(mobs) do
				if (mobs[i]) then
					if (mobs[i].loc==p1.loc+(math.sqrt(size))) then
						mdown=display.newImageRect("interact1.png",80,80)
						mdown.x=xinicial
						mdown.y=yinicial+espacio
						mdown.xScale=scale
						mdown.yScale=mdown.xScale
						mdown:toFront()		
						mdown:addEventListener( "touch",attackdown)
						CanMoveDown=false
					end
				end
			end
			
			for i=1, table.maxn(mobs) do
				if (mobs[i]) then
					if (mobs[i].loc==p1.loc-1) then
						mleft=display.newImageRect("interact1.png",80,80)
						mleft.x=xinicial-espacio
						mleft.y=yinicial
						mleft.xScale=scale
						mleft.yScale=mleft.xScale
						mleft:toFront()		
						mleft:addEventListener( "touch",attackleft)
						CanMoveLeft=false
					end
				end
			end
			
			for i=1, table.maxn(mobs) do
				if (mobs[i]) then
					if (mobs[i].loc==p1.loc+1) then
						mright=display.newImageRect("interact1.png",80,80)
						mright.x=xinicial+espacio
						mright.y=yinicial
						mright.xScale=scale
						mright.yScale=mright.xScale
						mright:toFront()		
						mright:addEventListener( "touch",attackright)
						CanMoveRight=false
					end
				end
			end
			
			--Movement Arrow Creation	
			local finish=b.GetFinish()
			
			if Shop==true then
				inter=display.newImageRect("interact5.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",ShopInteract)
			end
			
			if Ports~=false then
				if Ports=="BP" and p1.portcd==0 then
					inter=display.newImageRect("interact3.png",80,80)
					inter.x=xinicial
					inter.y=yinicial
					inter.xScale=scale
					inter.yScale=inter.xScale
					inter:toFront()
					inter:addEventListener( "touch",PortInteract)
				elseif Ports=="OP" and p1.portcd==0 then
					inter=display.newImageRect("interact4.png",80,80)
					inter.x=xinicial
					inter.y=yinicial
					inter.xScale=scale
					inter.yScale=inter.xScale
					inter:toFront()
					inter:addEventListener( "touch",PortInteract)
				elseif Ports=="RP" then
					inter=display.newImageRect("interact1.png",80,80)
					inter.x=xinicial
					inter.y=yinicial
					inter.xScale=scale
					inter.yScale=inter.xScale
					inter:toFront()
					inter:addEventListener( "touch",PortInteract)
				end
			end
			
			local CurRound=WD.Circle()
			if p1.loc==(math.sqrt(size))+2 then
				if CurRound==1 then
				else
					if CurRound%2==0 then
						inter=display.newImageRect("interact2.png",80,80)
						inter.x=xinicial
						inter.y=yinicial
						inter.xScale=scale
						inter.yScale=inter.xScale
						inter:toFront()
						inter:addEventListener( "touch",GoinUp)
					else
						inter=display.newImageRect("interact2.png",80,80)
						inter.x=xinicial
						inter.y=yinicial
						inter.xScale=scale
						inter.yScale=inter.xScale
						inter:toFront()
						inter:addEventListener( "touch",GoinDown)
					end
				end
			end
			
			if p1.loc==size-((math.sqrt(size))+1) then
				if CurRound%2==0 then
					inter=display.newImageRect("interact2.png",80,80)
					inter.x=xinicial
					inter.y=yinicial
					inter.xScale=scale
					inter.yScale=inter.xScale
					inter:toFront()
					inter:addEventListener( "touch",GoinDown)
				else
					inter=display.newImageRect("interact2.png",80,80)
					inter.x=xinicial
					inter.y=yinicial
					inter.xScale=scale
					inter.yScale=inter.xScale
					inter:toFront()
					inter:addEventListener( "touch",GoinUp)
				end
			end
			
			if CanMoveUp==true then
				mup=display.newImageRect("moveu.png",80,80)
				mup.x=xinicial
				mup.y=yinicial-espacio
				mup.xScale=scale
				mup.yScale=mup.xScale
				mup:toFront()
				mup:addEventListener( "touch",moveplayerup)
			end

			if CanMoveDown==true then
				mdown=display.newImageRect("moved.png",80,80)
				mdown.x=xinicial
				mdown.y=yinicial+espacio
				mdown.xScale=scale
				mdown.yScale=mdown.xScale
				mdown:toFront()
				mdown:addEventListener( "touch",moveplayerdown)
			end
			
			if CanMoveLeft==true then
				mleft=display.newImageRect("movel.png",80,80)
				mleft.x=xinicial-espacio
				mleft.y=yinicial
				mleft.xScale=scale
				mleft.yScale=mleft.xScale
				mleft:toFront()
				mleft:addEventListener( "touch",moveplayerleft)
			end
			
			if CanMoveRight==true then
				mright=display.newImageRect("mover.png",80,80)
				mright.x=xinicial+espacio
				mright.y=yinicial
				mright.xScale=scale
				mright.yScale=mright.xScale
				mright:toFront()
				mright:addEventListener( "touch",moveplayerright)
			end
		end
	end
end

function Visibility()
	local Tiles={}
	local Seen={}
	Tiles[#Tiles+1]=true
	
	p1=p.GetPlayer()
	boundary=b.GetData(1)
	mbounds=b.GetData(2)
	msize=b.GetData(0)
	size=math.sqrt(msize)
	
	--Player's Place
	Seen[(p1.loc)]=1
	
	--Surrounding tiles
	for x=1,3,2 do
		for y=1,3,2 do
			if boundary[p1.loc+(x-2)+((y-2)*size)]==0 then
				--Player can't walk here
				Seen[(p1.loc+(x-2)+((y-2)*size))]=1
			elseif boundary[p1.loc+((y-2)*size)]==1 and boundary[p1.loc+(x-2)]==1 then
				--Player can walk, check near walls
				Seen[(p1.loc+(x-2)+((y-2)*size))]=1
			end
		end
	end
	
	--Tiles to the left
	for c=1,4 do
		if math.floor((p1.loc)/size)==math.floor((p1.loc-c)/size) then
			if boundary[(p1.loc-c)]==1 and Tiles[#Tiles]~=false then
				if mbounds[(p1.loc-c)]==0 then
					Seen[(p1.loc-c)]=1
					Tiles[#Tiles+1]=false
				else
					Seen[(p1.loc-c)]=1
					Tiles[#Tiles+1]=true
				end
			elseif Tiles[#Tiles]==true and boundary[(p1.loc-c)]==0 then
					Seen[(p1.loc-c)]=1
				Tiles[#Tiles+1]=false
			else
				Tiles[#Tiles+1]=false
			end
		end
	end
	
	if (Tiles) then
		for l=table.maxn(Tiles),1,-1 do
			Tiles[l]=nil
		end
		Tiles[#Tiles+1]=true
	end

	--Tiles to the right
	for c=1,4 do
		if math.floor((p1.loc)/size)==math.floor((p1.loc+c-1)/size) then
			if boundary[(p1.loc+c)]==1 and Tiles[#Tiles]~=false then
				if mbounds[(p1.loc+c)]==0 then
					Seen[(p1.loc+c)]=1
					Tiles[#Tiles+1]=false
				else
					Seen[(p1.loc+c)]=1
					Tiles[#Tiles+1]=true
				end
			elseif Tiles[#Tiles]==true and boundary[(p1.loc+c)]==0 then
				Seen[(p1.loc+c)]=1
				Tiles[#Tiles+1]=false
			else
				Tiles[#Tiles+1]=false
			end
		end
	end
	
	if (Tiles) then
		for l=table.maxn(Tiles),1,-1 do
			Tiles[l]=nil
		end
		Tiles[#Tiles+1]=true
	end

	--Tiles upwards
	for r=1,6 do
		if ((p1.loc)%size)==((p1.loc-(r*size))%size) then
			if boundary[(p1.loc-(r*size))]==1 and Tiles[#Tiles]~=false then
				if mbounds[(p1.loc-(r*size))]==0 then
					Seen[(p1.loc-(r*size))]=1
					Tiles[#Tiles+1]=false
				else
					Seen[(p1.loc-(r*size))]=1
					Tiles[#Tiles+1]=true
				end
			elseif Tiles[#Tiles]==true and boundary[(p1.loc-(r*size))]==0 then
				Seen[(p1.loc-(r*size))]=1
				Tiles[#Tiles+1]=false
			else
				Tiles[#Tiles+1]=false
			end
		end
	end
	
	if (Tiles) then
		for l=table.maxn(Tiles),1,-1 do
			Tiles[l]=nil
		end
		Tiles[#Tiles+1]=true
	end
	
	--Tiles downwards
	for r=1,6 do
		if ((p1.loc)%size)==((p1.loc+(r*size))%size) then
			if boundary[(p1.loc+(r*size))]==1 and Tiles[#Tiles]~=false then
				if mbounds[(p1.loc+(r*size))]==0 then
					Seen[(p1.loc+(r*size))]=1
					Tiles[#Tiles+1]=false
				else
					Seen[(p1.loc+(r*size))]=1
					Tiles[#Tiles+1]=true
				end
			elseif Tiles[#Tiles]==true and boundary[(p1.loc+(r*size))]==0 then
				Seen[(p1.loc+(r*size))]=1
				Tiles[#Tiles+1]=false
			else
				Tiles[#Tiles+1]=false
			end
		end
	end
	
	b.Show(Seen)
end

function PortInteract( event )
	if event.phase=="ended" then
		ShowArrows("clean")
		coll.Port()
	end
end

function ShopInteract( event )
	if event.phase=="ended" then
		ShowArrows("clean")
		function closure1()
			sho.DisplayShop(p1.loc)
		end
		timer.performWithDelay(100,closure1)
	end
end

function GoinDown( event )
	if event.phase=="ended" then
		ShowArrows("clean")
		WD.FloorPort(false)
	end
end

function GoinUp( event )
	if event.phase=="ended" then
		ShowArrows("clean")
		WD.Win()
	end
end

function moveplayerup( event )
	if event.phase=="ended" then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.y=map.y+espacio
		p.MovePlayer(-math.sqrt(size))
		if Slowed==true then
			Toggle=Toggle-3
		else
			Toggle=Toggle-1
		end
		Visibility()
	end
end

function moveplayerdown( event )
	if event.phase=="ended" then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.y=map.y-espacio
		p.MovePlayer(math.sqrt(size))
		if Slowed==true then
			Toggle=Toggle-3
		else
			Toggle=Toggle-1
		end
		Visibility()
	end
end	

function moveplayerleft( event )
	if event.phase=="ended" then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.x=map.x+espacio
		p.MovePlayer(-1)
		if Slowed==true then
			Toggle=Toggle-3
		else
			Toggle=Toggle-1
		end
		Visibility()
	end
end	

function moveplayerright( event )
	if event.phase=="ended" then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.x=map.x-espacio
		p.MovePlayer(1)
		if Slowed==true then
			Toggle=Toggle-3
		else
			Toggle=Toggle-1
		end
		Visibility()
	end
end

function attackup( event )
	if event.phase=="ended" then
		ShowArrows("clean")
		--
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if mobs[i].loc==(p1.loc-(math.sqrt(size))) then
					function closure()
						c.Attacking(mobs[i])
					end
					timer.performWithDelay(50,closure)
				end
			end
		end
	end
end

function attackdown( event )
	if event.phase=="ended" then
		ShowArrows("clean")
		--
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if mobs[i].loc==(p1.loc+(math.sqrt(size))) then
					function closure()
						c.Attacking(mobs[i])
					end
					timer.performWithDelay(50,closure)
				end
			end
		end
	end
end	

function attackleft( event )
	if event.phase=="ended" then
		ShowArrows("clean")
		--
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if mobs[i].loc==(p1.loc-1) then
					function closure()
						c.Attacking(mobs[i])
					end
					timer.performWithDelay(50,closure)
				end
			end
		end
	end
end	

function attackright( event )
	if event.phase=="ended" then
		ShowArrows("clean")
		--
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if mobs[i].loc==(p1.loc+1) then
					function closure()
						c.Attacking(mobs[i])
					end
					timer.performWithDelay(50,closure)
				end
			end
		end
	end
end
