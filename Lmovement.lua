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
local cwin
local scale=1.2
local espacio=80*scale
local yinicial=display.contentHeight/2
local xinicial=display.contentWidth/2
local Toggle=math.random(5,10)

function ShowArrows()
	CleanArrows()
	
	Key=coll.onKeyCollision()
	Dropped=coll.onChestCollision()
	Slowed=coll.onWaterCollision()
	coll.onLavaCollision()
	coll.onRockCollision()
	coll.LayOnHands()
	coll.LayOnHead()
	coll.LayOnFeet()
	
	if Dropped==true or Key==true then
	elseif Toggle<=0 then
		Toggle=math.random(5,10)
		mob.DoTurns()
	else
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
		
		print ("ROOM: "..p1.room.." LOC: "..p1.loc)
		
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
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if (mobs[i].loc==p1.loc-size) then
					mup=display.newImageRect("interact12.png",80,80)
					mup.x=xinicial
					mup.y=yinicial-espacio
					mup.xScale=scale
					mup.yScale=mup.xScale
					mup:toFront()
					CanMoveUp=false
					CanAttackUp=true
				end
			end		
		end

		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if (mobs[i].loc==p1.loc+size) then
					mdown=display.newImageRect("interact12.png",80,80)
					mdown.x=xinicial
					mdown.y=yinicial+espacio
					mdown.xScale=scale
					mdown.yScale=mdown.xScale
					mdown:toFront()
					CanMoveDown=false
					CanAttackDown=true
				end
			end
		end
		
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if (mobs[i].loc==p1.loc-1) then
					mleft=display.newImageRect("interact12.png",80,80)
					mleft.x=xinicial-espacio
					mleft.y=yinicial
					mleft.xScale=scale
					mleft.yScale=mleft.xScale
					mleft:toFront()
					CanMoveLeft=false
					CanAttackLeft=true
				end
			end
		end
		
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if (mobs[i].loc==p1.loc+1) then
					mright=display.newImageRect("interact12.png",80,80)
					mright.x=xinicial+espacio
					mright.y=yinicial
					mright.xScale=scale
					mright.yScale=mright.xScale
					mright:toFront()
					CanMoveRight=false
					CanAttackRight=true
				end
			end
		end
		
		--Movement Arrow Creation
		
		if Shop==true then
			inter=display.newImageRect("interact52.png",80,80)
			inter.x=xinicial
			inter.y=yinicial
			inter.xScale=scale
			inter.yScale=inter.xScale
			inter:toFront()
			inter:addEventListener( "touch",ShopInteract)
		end
		
		if Ports~=false then
			if Ports=="BP" and p1.portcd==0 then
				inter=display.newImageRect("interact32.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",PortInteract)
			elseif Ports=="OP" and p1.portcd==0 then
				inter=display.newImageRect("interact42.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",PortInteract)
			end
		end
		
		local finish,finishroom=b.GetData(11)
		local entrance,entranceroom=b.GetData(12)
		local CurRound=WD.Circle()
		if p1.loc==entrance and p1.room==entranceroom then
			if CurRound==1 then
			else
				if CurRound%2==0 then
					inter=display.newImageRect("interact22.png",80,80)
					inter.x=xinicial
					inter.y=yinicial
					inter.xScale=scale
					inter.yScale=inter.xScale
					inter:toFront()
					inter:addEventListener( "touch",GoinUp)
				else
					inter=display.newImageRect("interact22.png",80,80)
					inter.x=xinicial
					inter.y=yinicial
					inter.xScale=scale
					inter.yScale=inter.xScale
					inter:toFront()
					inter:addEventListener( "touch",GoinDown)
				end
			end
		end
		
		if p1.loc==finish and p1.room==finishroom then
			if CurRound%2==0 then
				inter=display.newImageRect("interact22.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",GoinDown)
			else
				inter=display.newImageRect("interact22.png",80,80)
				inter.x=xinicial
				inter.y=yinicial
				inter.xScale=scale
				inter.yScale=inter.xScale
				inter:toFront()
				inter:addEventListener( "touch",GoinUp)
			end
		end
		
		if CanMoveUp==true then
			mup=display.newImageRect("moveu2.png",80,80)
			mup.x=xinicial
			mup.y=yinicial-espacio
			mup.xScale=scale
			mup.yScale=mup.xScale
			mup:toFront()
		end

		if CanMoveDown==true then
			mdown=display.newImageRect("moved2.png",80,80)
			mdown.x=xinicial
			mdown.y=yinicial+espacio
			mdown.xScale=scale
			mdown.yScale=mdown.xScale
			mdown:toFront()
		end
		
		if CanMoveLeft==true then
			mleft=display.newImageRect("movel2.png",80,80)
			mleft.x=xinicial-espacio
			mleft.y=yinicial
			mleft.xScale=scale
			mleft.yScale=mleft.xScale
			mleft:toFront()
		end
		
		if CanMoveRight==true then
			mright=display.newImageRect("mover2.png",80,80)
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
	Seen[(p1.loc)]=p1.room
	
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
				Seen[space]=room
			elseif boundary[room][spaceY]==1 and boundary[room][spaceX]==1 and xBounds==false then
				--Player can walk, check near walls
				Seen[space]=room
			else
				
				if (row+1)==1 then
					if y==1 then
						local space
						local room
						space=(col+(x-2)+(size*(size-1)))
						room=p1.room-5
						if (boundary[room]) then
							Seen[space]=room
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
							Seen[space]=room
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
							Seen[space]=room
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
							Seen[space]=room
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
					Seen[space]=room
					Tiles[#Tiles+1]=false
				else
					Seen[space]=room
					Tiles[#Tiles+1]=true
				end
			elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
				Seen[space]=room
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
				if boundary[room][space]==1 and Tiles[#Tiles]~=false then
					if mbounds[room][space]==0 then
						Seen[space]=room
						Tiles[#Tiles+1]=false
					else
						Seen[space]=room
						Tiles[#Tiles+1]=true
					end
				elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
					Seen[space]=room
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
					Seen[space]=room
					Tiles[#Tiles+1]=false
				else
					Seen[space]=room
					Tiles[#Tiles+1]=true
				end
			elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
				Seen[space]=room
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
				if boundary[room][space]==1 and Tiles[#Tiles]~=false then
					if mbounds[room][space]==0 then
						Seen[space]=room
						Tiles[#Tiles+1]=false
					else
						Seen[space]=room
						Tiles[#Tiles+1]=true
					end
				elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
					Seen[space]=room
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
				if boundary[room][space]==1 and Tiles[#Tiles]~=false then
					if mbounds[room][space]==0 then
						Seen[space]=room
						Tiles[#Tiles+1]=false
					else
						Seen[space]=room
						Tiles[#Tiles+1]=true
					end
				elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
					Seen[space]=room
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
				if boundary[room][space]==1 and Tiles[#Tiles]~=false then
					if mbounds[room][space]==0 then
						Seen[space]=room
						Tiles[#Tiles+1]=false
					else
						Seen[space]=room
						Tiles[#Tiles+1]=true
					end
				elseif Tiles[#Tiles]==true and boundary[room][space]==0 then
					Seen[space]=room
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
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if mobs[i].loc==(p1.loc-size) then
					function closure()
						c.Attacking(mobs[i])
					end
					timer.performWithDelay(50,closure)
				end
			end
		end
	elseif CanMoveUp==true then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.y=map.y+espacio
		if RoomChange=="U" then
			P1.room=P1.room-5
			P1.loc=col+(size*(size-1))
		else
			P1.loc=P1.loc-size
		end
		if Slowed==true then
			Toggle=Toggle-3
		else
			Toggle=Toggle-1
		end
		Visibility()
	end
end

function Down()
	if CanAttackDown==true then
		CleanArrows()
		--
		for i=1, table.maxn(mobs) do
			if (mobs[i]) then
				if mobs[i].loc==(p1.loc+size) then
					function closure()
						c.Attacking(mobs[i])
					end
					timer.performWithDelay(50,closure)
				end
			end
		end
	elseif CanMoveDown==true then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.y=map.y-espacio
		if RoomChange=="D" then
			P1.room=P1.room+5
			P1.loc=(col)
		else
			P1.loc=P1.loc+size
		end
		if Slowed==true then
			Toggle=Toggle-3
		else
			Toggle=Toggle-1
		end
		Visibility()
	end
end

function Left()
	if CanAttackLeft==true then
		CleanArrows()
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
	elseif CanMoveLeft==true then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.x=map.x+espacio
		if RoomChange=="L" then
			P1.room=P1.room-1
			P1.loc=p1.loc+(size-1)
		else
			P1.loc=P1.loc-1
		end
		if Slowed==true then
			Toggle=Toggle-3
		else
			Toggle=Toggle-1
		end
		Visibility()
	end
end

function Right()
	if CanAttackRight==true then
		CleanArrows()
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
	elseif CanMoveRight==true then
		map=b.GetData(3)
		P1=p.GetPlayer()
		map.x=map.x-espacio
		if RoomChange=="R" then
			P1.room=P1.room+1
			P1.loc=p1.loc-(size-1)
		else
			P1.loc=P1.loc+1
		end
		if Slowed==true then
			Toggle=Toggle-3
		else
			Toggle=Toggle-1
		end
		Visibility()
	end
end
