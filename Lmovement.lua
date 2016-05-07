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
local g=require("Lgold")
local mobs
local mright
local mup
local mdown
local mleft
local inter
local cwin
local mtext
local mwindow
local scale=1.2
local espacio=80*scale
local yinicial=display.contentHeight/2
local xinicial=display.contentWidth/2
local Toggle=math.random(5,10)

function ShowArrows()
	CleanArrows()
	
	combatBug=c.InTrouble()
	Key=coll.onKeyCollision()
	Dropped=coll.onChestCollision()
	Slowed=coll.onWaterCollision()
	coll.onLavaCollision()
	coll.onRockCollision()
	coll.LayOnHands()
	coll.LayOnHead()
	coll.LayOnFeet()
	if (mtext) then
		display.remove(mtext)
		mtext=nil
		display.remove(mwindow)
		mwindow=nil
	end
	
	if Dropped==true or Key==true or combatBug==true then
	elseif Toggle<=0 then
		mtext=display.newText("Doing mob turns...",0,0,"MoolBoran",70)
		mtext.x=display.contentCenterX
		mtext.y=display.contentHeight*.2
		
		mwindow=display.newRect (0,0,#mtext.text*22,60)
		mwindow:setFillColor( 0, 0, 0, 122)
		mwindow.x=mtext.x
		mwindow.y=mtext.y-15
		mtext:toFront()
		
		Toggle=math.random(5,10)
		timer.performWithDelay(200,mob.DoTurns)
	else
	--	print ("ROOM: "..p1.room.." LOC: "..p1.loc)
		RoomChange=false
		boundary=b.GetData(1,0)
		msize=b.GetData(0)
		size=math.sqrt(msize)
		p1=p.GetPlayer()
		col=p1.loc%size
		row=math.floor(p1.loc/size)
		mobs=mob.GetMobGroup()
		Ports=coll.PortCheck()
		Shop=coll.ShopCheck()
		Spawner=coll.SpawnerCheck()
		
		if not(cwin) then
			local halfX=display.contentCenterX
			local halfY=display.contentCenterY
			cwin=display.newImageRect( "cwindow.png", 653,653 )
			cwin.x=halfX
			cwin.y=halfY
			cwin:addEventListener("touch",Interaction)
		end
		
		--Boundary Checks
		if (row+1)==1 then
			RoomChange="U"
		end
		
		if (row+1)==size then
			RoomChange="D"
		end
		
		if col==1 then
			RoomChange="L"
		end
		
		if col==0 then
			RoomChange="R"
		end
		
		--Wall Collision Checks
		if RoomChange=="U" then
			if boundary[p1.room-5][col+(size*(size-1))]~=0 then
				CanMoveUp=true
			end
		else
			if boundary[p1.room][p1.loc-size]~=0 then
				CanMoveUp=true
			end
		end
		
		if RoomChange=="D" then
			if boundary[p1.room+5][col]~=0 then
				CanMoveDown=true
			end
		else
			if boundary[p1.room][p1.loc+size]~=0 then
				CanMoveDown=true
			end
		end
		
		if RoomChange=="L" then
			if boundary[p1.room-1][p1.loc+(size-1)]~=0 then
				CanMoveLeft=true
			end
		else
			if boundary[p1.room][p1.loc-1]~=0 then
				CanMoveLeft=true
			end
		end
		
		if RoomChange=="R" then
			if boundary[p1.room+1][p1.loc-(size-1)]~=0 then
				CanMoveRight=true
			end
		else
			if boundary[p1.room][p1.loc+1]~=0 then
				CanMoveRight=true
			end
		end
		
		--Mob Collision Checks
		local tryup=mob.LocationCheck(p1.loc-size,p1.room)
		if tryup==true then
			CanAttackUp=true
			CanMoveUp=false
			mup=display.newImageRect("interact1.png",80,80)
			mup.x=xinicial
			mup.y=yinicial-espacio
			mup.xScale=scale
			mup.yScale=mup.xScale
			mup:toFront()
		end
		
		local trydown=mob.LocationCheck(p1.loc+size,p1.room)
		if trydown==true then
			CanAttackDown=true
			CanMoveDown=false
			mdown=display.newImageRect("interact1.png",80,80)
			mdown.x=xinicial
			mdown.y=yinicial+espacio
			mdown.xScale=scale
			mdown.yScale=mdown.xScale
			mdown:toFront()
		end
		
		local tryright=mob.LocationCheck(p1.loc+1,p1.room)
		if tryright==true then
			CanAttackRight=true
			CanMoveRight=false
			mright=display.newImageRect("interact1.png",80,80)
			mright.x=xinicial+espacio
			mright.y=yinicial
			mright.xScale=scale
			mright.yScale=mright.xScale
			mright:toFront()
		end
		
		local tryleft=mob.LocationCheck(p1.loc-1,p1.room)
		if tryleft==true then
			CanAttackLeft=true
			CanMoveLeft=false
			mleft=display.newImageRect("interact1.png",80,80)
			mleft.x=xinicial-espacio
			mleft.y=yinicial
			mleft.xScale=scale
			mleft.yScale=mleft.xScale
			mleft:toFront()
		end
		
		--Movement Arrow Creation
		
		if Shop==true then
			inter=display.newImageRect("interact2.png",80,80)
			inter.x=xinicial
			inter.y=yinicial
			inter.xScale=scale
			inter.yScale=inter.xScale
			inter:toFront()
			inter:addEventListener( "touch",ShopInteract)
		end
		
		if Spawner==true then
			inter=display.newImageRect("interact8.png",80,80)
			inter.x=xinicial
			inter.y=yinicial
			inter.xScale=scale
			inter.yScale=inter.xScale
			inter:toFront()
			inter:addEventListener( "touch",YouNoSpawn)
		end
		
		if Ports~=false then
			if Ports=="OP" then
				inter=display.newImageRect("interact4.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",PortInteract)
			elseif Ports=="OPB" then
				inter=display.newImageRect("interact4B.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
			elseif Ports=="BP"  then
				inter=display.newImageRect("interact6.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",PortInteract)
			elseif Ports=="BPB" then
				inter=display.newImageRect("interact6B.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
			elseif Ports=="RP" then
				inter=display.newImageRect("interact5.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",PortInteract)
			elseif Ports=="RPB" then
				inter=display.newImageRect("interact5B.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
			elseif Ports=="DP"  then
				inter=display.newImageRect("interact7.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",PortInteract)
			elseif Ports=="DPB" then
				inter=display.newImageRect("interact7B.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
			end
		end
		
		local finish,finishroom=b.GetData(11)
		local entrance,entranceroom=b.GetData(12)
		local CurRound=WD.Circle()
		if p1.loc==entrance and p1.room==entranceroom and CurRound>1 then
			inter=display.newImageRect("interact3B.png",80,80)
			inter.x=xinicial
			inter.y=yinicial
			inter.xScale=scale
			inter.yScale=inter.xScale
			inter:toFront()
			inter:addEventListener( "touch",GoinDown)
		end
		
		if p1.loc==finish and p1.room==finishroom then
			inter=display.newImageRect("interact3.png",80,80)
			inter.x=xinicial
			inter.y=yinicial
			inter.xScale=scale
			inter.yScale=inter.xScale
			inter:toFront()
			inter:addEventListener( "touch",GoinUp)
		end
		
		if CanMoveUp==true then
			mup=display.newImageRect("moveu.png",80,80)
			mup.x=xinicial
			mup.y=yinicial-espacio
			mup.xScale=scale
			mup.yScale=mup.xScale
			mup:toFront()
		end

		if CanMoveDown==true then
			mdown=display.newImageRect("moved.png",80,80)
			mdown.x=xinicial
			mdown.y=yinicial+espacio
			mdown.xScale=scale
			mdown.yScale=mdown.xScale
			mdown:toFront()
		end
		
		if CanMoveLeft==true then
			mleft=display.newImageRect("movel.png",80,80)
			mleft.x=xinicial-espacio
			mleft.y=yinicial
			mleft.xScale=scale
			mleft.yScale=mleft.xScale
			mleft:toFront()
		end
		
		if CanMoveRight==true then
			mright=display.newImageRect("mover.png",80,80)
			mright.x=xinicial+espacio
			mright.y=yinicial
			mright.xScale=scale
			mright.yScale=mright.xScale
			mright:toFront()
		end
	end
end

function CleanArrows()
	CanMoveDown=false
	CanMoveLeft=false
	CanMoveUp=false
	CanMoveRight=false
	--
	CanAttackDown=false
	CanAttackLeft=false
	CanAttackUp=false
	CanAttackRight=false
	--
	display.remove(mup)
	display.remove(mdown)
	display.remove(mleft)
	display.remove(mright)
	display.remove(inter)
	--
	if (mtext) then
		display.remove(mtext)
		mtext=nil
		display.remove(mwindow)
		mwindow=nil
	end
end

function CleanWindow()
	display.remove(cwin)
	cwin=nil
end

function Visibility()
	local Tiles={}
	local Seen={}
	Tiles[#Tiles+1]=true
	
	p1=p.GetPlayer()
	boundary=b.GetData(1,0)
	mbounds=b.GetData(2,0)
	msize=b.GetData(0)
	size=math.sqrt(msize)
	
	--Player's Place
	Seen[p1.room]={}
	Seen[p1.room][p1.loc]=1
	
	--Surrounding tiles
	for x=1,3,2 do
		for y=1,3,2 do
			local space=p1.loc+(x-2)+((y-2)*size)
			local spaceY=p1.loc+((y-2)*size)
			local spaceX=p1.loc+(x-2)
			local room=p1.room
			local col=(p1.loc%size)
			local row=(math.floor(p1.loc/size))
			local xBounds=false
			if x==1 and col==1 then
				xBounds=true
			elseif x==3 and col==0 then
				xBounds=true
			end
			if boundary[room][space]==0 and xBounds==false then
				--Player can't walk here
						Seen[room][space]=1
			elseif boundary[room][spaceY]==1 and boundary[room][spaceX]==1 and xBounds==false then
				--Player can walk, check near walls
						Seen[room][space]=1
			else
				
				if (row+1)==1 then
					if y==1 then
						local space
						local room
						space=(col+(x-2)+(size*(size-1)))
						room=p1.room-5
						if (boundary[room]) then
							if not (Seen[room]) then
								Seen[room]={}
							end
							Seen[room][space]=1
						end
					end
				end
		
				if (row+1)==size then
					if y==3 then
						local space
						local room
						space=(col+(x-2))
						room=p1.room+5
						if (boundary[room]) then
							if not (Seen[room]) then
								Seen[room]={}
							end
							Seen[room][space]=1
						end
					end
				end
		
				if col==1 then
					if x==1 then
						local space
						local room
						space=p1.loc+(size-1)+((y-2)*size)
						room=p1.room-1
						if (boundary[room]) then
							if not (Seen[room]) then
								Seen[room]={}
							end
							Seen[room][space]=1
						end
					end
				end
				
				if col==0 then
					if x==3 then
						local space
						local room
						space=p1.loc-(size-1)+((y-2)*size)
						room=p1.room+1
						if (boundary[room]) then
							if not (Seen[room]) then
								Seen[room]={}
							end
							Seen[room][space]=1
						end
					end
				end
			end
		end
	end
	
	--Tiles to the left
	for c=1,4 do
		if math.floor((p1.loc-1)/size)==math.floor((p1.loc-(c+1))/size) then
			local space
			local room
			space=((p1.loc-c))
			room=p1.room
			if boundary[room][space]==1 and Tiles[#Tiles]~=false then
				if mbounds[room][space]==0 then
					Seen[room][space]=1
					Tiles[#Tiles+1]=false
				else
					Seen[room][space]=1
					Tiles[#Tiles+1]=true
				end
			elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
				Seen[room][space]=1
				Tiles[#Tiles+1]=false
			else
				Tiles[#Tiles+1]=false
			end
		else
			local space
			local room
			room=p1.room-1
			space=p1.loc+(size-c)
			if (boundary[room]) then
				if not (Seen[room]) then
					Seen[room]={}
				end
				if boundary[room][space]==1 and Tiles[#Tiles]~=false then
					if mbounds[room][space]==0 then
						Seen[room][space]=1
						Tiles[#Tiles+1]=false
					else
						Seen[room][space]=1
						Tiles[#Tiles+1]=true
					end
				elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
					Seen[room][space]=1
					Tiles[#Tiles+1]=false
				else
					Tiles[#Tiles+1]=false
				end
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
		if math.floor((p1.loc-1)/size)==math.floor((p1.loc+(c-1))/size) then
			local space
			local room
			space=((p1.loc+c))
			room=p1.room
			if boundary[room][space]==1 and Tiles[#Tiles]~=false then
				if mbounds[room][space]==0 then
					Seen[room][space]=1
					Tiles[#Tiles+1]=false
				else
					Seen[room][space]=1
					Tiles[#Tiles+1]=true
				end
			elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
				Seen[room][space]=1
				Tiles[#Tiles+1]=false
			else
				Tiles[#Tiles+1]=false
			end
		else
			local space
			local room
			space=p1.loc-(size-c)
			room=p1.room+1
			if (boundary[room]) then
				if not (Seen[room]) then
					Seen[room]={}
				end
				if boundary[room][space]==1 and Tiles[#Tiles]~=false then
					if mbounds[room][space]==0 then
						Seen[room][space]=1
						Tiles[#Tiles+1]=false
					else
						Seen[room][space]=1
						Tiles[#Tiles+1]=true
					end
				elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
					Seen[room][space]=1
					Tiles[#Tiles+1]=false
				else
					Tiles[#Tiles+1]=false
				end
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
	local overflow=0
	for r=1,6 do
		if ((p1.loc)%size)==((p1.loc-(r*size))%size) then
			local space
			local room
			if (p1.loc-(r*size))<0 then
				overflow=overflow+1
				local col=((p1.loc)%size)
				local row=(math.floor((p1.loc)/size))
				space=(col+(size*(size-overflow)))
				room=p1.room-5
			else
				space=(p1.loc-(r*size))
				room=p1.room
			end
			if (boundary[room]) then
				if not (Seen[room]) then
					Seen[room]={}
				end
				if boundary[room][space]==1 and Tiles[#Tiles]~=false then
					if mbounds[room][space]==0 then
						Seen[room][space]=1
						Tiles[#Tiles+1]=false
					else
						Seen[room][space]=1
						Tiles[#Tiles+1]=true
					end
				elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
					Seen[room][space]=1
					Tiles[#Tiles+1]=false
				else
					Tiles[#Tiles+1]=false
				end
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
	overflow=0
	for r=1,6 do
		if ((p1.loc)%size)==((p1.loc+(r*size))%size) then
			local space
			local room
			if (p1.loc+(r*size))>msize then
				overflow=overflow+1
				local col=(p1.loc%size)
				local row=(math.floor(p1.loc/size))
				space=(col+((overflow-1)*size))
				room=p1.room+5
			else
				space=(p1.loc+(r*size))
				room=p1.room
			end
			if (boundary[room]) then
				if not (Seen[room]) then
					Seen[room]={}
				end
				if boundary[room][space]==1 and Tiles[#Tiles]~=false then
					if mbounds[room][space]==0 then
						Seen[room][space]=1
						Tiles[#Tiles+1]=false
					else
						Seen[room][space]=1
						Tiles[#Tiles+1]=true
					end
				elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
					Seen[room][space]=1
					Tiles[#Tiles+1]=false
				else
					Tiles[#Tiles+1]=false
				end
			end
		end
	end
	
	b.Show(Seen)
end

function Interaction( event )
	if event.phase=="began" then
		local halfX=display.contentCenterX
		local halfY=display.contentCenterY
		local dimX=halfX*2
		local dimY=(halfY*2)-290
		local dimH=math.sqrt((dimX^2)+(dimY^2))
		local intX=event.x-halfX
		local intY=event.y-halfY
		local vx=math.abs(intX/dimH)
		local vy=math.abs(intY/dimH)
		
		if intX<(76*0.6) and intX>(-76*0.6) then
			--X=CENTER
			if intY<(76*0.6) and intY>(-76*0.6) then
				--Y=CENTER
			else
				--Y=CENTER
				if intY>(76*0.6) then
					Down()
				elseif intY<(-76*0.6) then
					Up()
				end
			end
		else
			--X~CENTER
			if intY<(76*0.6) and intY>(-76*0.6) then
				--Y=CENTER
				if intX>(76*0.6) then
					Right()
				elseif intX<(-76*0.6) then
					Left()
				end
			else
				--Y~CENTER
				if intX>(76*0.6) then
					if intY>(76*0.6) then
						if vx<vy then
							Down()
						else
							Right()
						end
					elseif intY<(-76*0.6) then
						if vx<vy then
							Up()
						else
							Right()
						end
					end
				elseif intX<(-76*0.6) then
					if intY>(76*0.6) then
						if vx<vy then
							Down()
						else
							Left()
						end
					elseif intY<(-76*0.6) then
						if vx<vy then
							Up()
						else
							Left()
						end
					end
				end
			end
		end
	end
end

function PortInteract( event )
	if event.phase=="ended" then
		CleanArrows()
		coll.Port()
	end
end

function ShopInteract( event )
	if event.phase=="ended" then
		CleanArrows()
		function closure1()
			sho.DisplayShop(p1.loc,p1.room)
		end
		timer.performWithDelay(100,closure1)
	end
end

function GoinDown( event )
	if event.phase=="ended" then
		CleanArrows()
		WD.FloorPort(false)
	end
end

function YouNoSpawn( event )
	if event.phase=="ended" then
		local Round=WD.Circle()
		mob.DelayMobs()
		g.CallCoins(Round)
		Visibility()
	end
end

function GoinUp( event )
	if event.phase=="ended" then
		CleanArrows()
		WD.Win()
	end
end

function Up()
	if CanAttackUp==true then
		CleanArrows()
		--
		for i in pairs(mobs[p1.room]) do
			if mobs[p1.room][i].loc==(p1.loc-size) then
				function closure()
					c.Attacking(mobs[p1.room][i])
				end
				timer.performWithDelay(50,closure)
			end
		end
	elseif CanMoveUp==true then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.y=map.y+espacio
		local energycost=math.floor(P1.weight/30)
		if RoomChange=="U" then
			P1.room=P1.room-5
			P1.loc=col+(size*(size-1))
		else
			P1.loc=P1.loc-size
		end
		if Slowed==true then
			Toggle=Toggle-3
			energycost=energycost*1.5
		else
			Toggle=Toggle-1
		end
		if P1.EP>=energycost then
			P1.EP=P1.EP-energycost
		else
			local deficit=energycost-P1.EP
			p.ReduceHP(math.floor(deficit/2),"Energy")
			P1.EP=0
		end
		Visibility()
	end
end

function Down()
	if CanAttackDown==true then
		CleanArrows()
		--
		for i in pairs(mobs[p1.room]) do
			if mobs[p1.room][i].loc==(p1.loc+size) then
				function closure()
					c.Attacking(mobs[p1.room][i])
				end
				timer.performWithDelay(50,closure)
			end
		end
	elseif CanMoveDown==true then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.y=map.y-espacio
		local energycost=math.floor(P1.weight/30)
		if RoomChange=="D" then
			P1.room=P1.room+5
			P1.loc=(col)
		else
			P1.loc=P1.loc+size
		end
		if Slowed==true then
			Toggle=Toggle-3
			energycost=energycost*1.5
		else
			Toggle=Toggle-1
		end
		if P1.EP>=energycost then
			P1.EP=P1.EP-energycost
		else
			local deficit=energycost-P1.EP
			p.ReduceHP(math.floor(deficit/2),"Energy")
			P1.EP=0
		end
		Visibility()
	end
end

function Left()
	if CanAttackLeft==true then
		CleanArrows()
		--
		for i in pairs(mobs[p1.room]) do
			if mobs[p1.room][i].loc==(p1.loc-1) then
				function closure()
					c.Attacking(mobs[p1.room][i])
				end
				timer.performWithDelay(50,closure)
			end
		end
	elseif CanMoveLeft==true then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.x=map.x+espacio
		local energycost=math.floor(P1.weight/30)
		if RoomChange=="L" then
			P1.room=P1.room-1
			P1.loc=p1.loc+(size-1)
		else
			P1.loc=P1.loc-1
		end
		if Slowed==true then
			Toggle=Toggle-3
			energycost=energycost*1.5
		else
			Toggle=Toggle-1
		end
		if P1.EP>=energycost then
			P1.EP=P1.EP-energycost
		else
			local deficit=energycost-P1.EP
			p.ReduceHP(math.floor(deficit/2),"Energy")
			P1.EP=0
		end
		Visibility()
	end
end

function Right()
	if CanAttackRight==true then
		CleanArrows()
		--
		for i in pairs(mobs[p1.room]) do
			if mobs[p1.room][i].loc==(p1.loc+1) then
				function closure()
					c.Attacking(mobs[p1.room][i])
				end
				timer.performWithDelay(50,closure)
			end
		end
	elseif CanMoveRight==true then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.x=map.x-espacio
		local energycost=math.floor(P1.weight/30)
		if RoomChange=="R" then
			P1.room=P1.room+1
			P1.loc=p1.loc-(size-1)
		else
			P1.loc=P1.loc+1
		end
		if Slowed==true then
			Toggle=Toggle-3
			energycost=math.ceil(energycost*1.5)
		else
			Toggle=Toggle-1
		end
		if P1.EP>=energycost then
			P1.EP=P1.EP-energycost
		else
			local deficit=energycost-P1.EP
			p.ReduceHP(math.floor(deficit/2),"Energy")
			P1.EP=0
		end
		Visibility()
	end
end
