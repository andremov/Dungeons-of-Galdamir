-----------------------------------------------------------------------------------------
--
-- Windows.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local HPot2sheet = graphics.newImageSheet( "items/HealthPotion2.png", { width=64, height=64, numFrames=16 })
local HPot3sheet = graphics.newImageSheet( "items/HealthPotion3.png", { width=64, height=64, numFrames=16 })
local MPot2sheet = graphics.newImageSheet( "items/ManaPotion2.png", { width=64, height=64, numFrames=16 })
local MPot3sheet = graphics.newImageSheet( "items/ManaPotion3.png", { width=64, height=64, numFrames=16 })
local widget = require "widget"
local audio=require("LAudio")
local g=require("LGold")
local mov=require("Lmovement")
local p=require("Lplayers")
local WD=require("LProgress")
local ui=require("LUI")
local item=require("LItems")
local sc=require("LScore")
local b=require("LMapBuilder")
local s=require("LSaving")
local ginv
local geqp
local ginf
local gdm
local gum
local isOpn
local isUse

function Essentials()
	p1=p.GetPlayer()
	gum=display.newGroup()
	xinvicial=75
	yinvicial=156
	xeqpicial=75
	yeqpicial=698
	statchangey=(display.contentHeight/2)-60
	statchangex=(display.contentWidth/2)-295
	statchangexs=120
	espaciox=64
	espacioy=64
	isUse=false
	isOpn=false
	statchange={}
end

function ToggleBag()
	if isOpn==false then
		ginv=display.newGroup()
		items={}
		curreqp={}
		
		invinterface=display.newImageRect("container.png", 570, 549)
		invinterface.x,invinterface.y = display.contentWidth/2, 400
		invinterface.xScale,invinterface.yScale=1.2280701755,1.2280701755
		ginv:insert( invinterface )
		isOpn=true
		
		for i=1,table.maxn(p1.inv) do
			if (p1.inv[i])~=nil then
				local itmnme=item.ReturnInfo(p1.inv[i][1],0)
				print ("Player has "..p1.inv[i][2].." of "..itmnme..".")
				if p1.inv[i][1]==2 then
					items[#items+1]=display.newSprite( HPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					items[#items]:play()
				elseif p1.inv[i][1]==3 then
					items[#items+1]=display.newSprite( HPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					items[#items]:play()
				elseif p1.inv[i][1]==7 then
					items[#items+1]=display.newSprite( MPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					items[#items]:play()
				elseif p1.inv[i][1]==8 then
					items[#items+1]=display.newSprite( MPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					items[#items]:play()
				else
					items[#items+1]=display.newImageRect( "items/"..itmnme..".png" ,64,64)
				end
				items[#items].xScale=1.140625
				items[#items].yScale=1.140625
				items[#items].x = xinvicial+ (((#items-1)%9)*((espaciox*items[#items].xScale)+4))
				items[#items].y = yinvicial+ ((math.floor((#items-1)/9))*((espacioy*items[#items].yScale)+4))
				function Gah()
					UseMenu(p1.inv[i][1],i)
				end
				items[#items]:addEventListener("tap",Gah)
				ginv:insert( items[#items] )
				if p1.inv[i][2]~=1 then
					if p1.inv[i][2]>9 then
						items[#items].num=display.newText( (p1.inv[i][2]) ,items[#items].x+5,items[#items].y-5,"Game Over",80)
						ginv:insert( items[#items].num )
					elseif p1.inv[i][2]<=9 then
						items[#items].num=display.newText( (p1.inv[i][2]) ,items[#items].x+15,items[#items].y-5,"Game Over",80)
						ginv:insert( items[#items].num )
					end
				end
			end
		end
		
		for i=1,table.maxn(p1.eqp) do
			if (p1.eqp[i])~=nil then
				local itmnme=item.ReturnInfo(p1.eqp[i][1],0)
				print ("Player has "..itmnme.." equipped in slot number "..p1.eqp[i][2]..".")
				curreqp[#curreqp+1]=display.newImageRect( "items/"..itmnme..".png" ,64,64)
				curreqp[#curreqp].xScale=1.140625
				curreqp[#curreqp].yScale=1.140625
				if p1.eqp[i][2]==6 then
					plcmnt=1
				elseif p1.eqp[i][2]==2 then
					plcmnt=2
				elseif p1.eqp[i][2]==3 then
					plcmnt=3
				elseif p1.eqp[i][2]==0 then
					plcmnt=4
				elseif p1.eqp[i][2]==4 then
					plcmnt=5
				elseif p1.eqp[i][2]==1 then
					plcmnt=6
				elseif p1.eqp[i][2]==7 then
					plcmnt=7
				elseif p1.eqp[i][2]==5 then
					plcmnt=8
				elseif p1.eqp[i][2]==8 then
					plcmnt=9
				end
				curreqp[#curreqp].x = xeqpicial+ (((plcmnt-1)%9)*((espaciox*curreqp[#curreqp].xScale)+4))
				curreqp[#curreqp].y = yeqpicial
				ginv:insert( curreqp[#curreqp] )
			end
		end
		ginv:toFront()
		if table.maxn(p1.inv)==0 then
			print "Inventory is empty."
		end
		if table.maxn(p1.eqp)==0 then
			print "Player has nothing equipped."
		end
	elseif isOpn==true and (ginv) then
		
		if isUse==false then
			for i=table.maxn(items),1,-1 do
				display.remove(items[i])
				items[i]=nil
			end
			items=nil
			for i=table.maxn(curreqp),1,-1 do
				display.remove(curreqp[i])
				curreqp[i]=nil
			end
			curreqp=nil
			isOpn=false
			for i=ginv.numChildren,1,-1 do
				display.remove(ginv[i])
				ginv[i]=nil
			end
			ginv=nil
		end
		
	end
end

function ToggleInfo()
	if isOpn==false then
		isOpn=true
		ginf=display.newGroup()
		info={}
		
		bkg=display.newImageRect("bkgs/pausebkg.png", 768, 800)
		bkg.x,bkg.y = display.contentWidth/2, 400
		ginf:insert( bkg )
		
		if p1.name=="Error" then
			info[1]=display.newText(
				(
					"I AM ERROR."
				),
				10,10,native.systemFontBold,50
			)
			ginf:insert(info[1])
		else
			info[1]=display.newText(
				(
					p1.name
				),
				10,10,native.systemFontBold,50
			)
			ginf:insert(info[1])
		end
		
		info[2]=display.newText(
			(
				"HP: "..p1.HP.."/"..p1.MaxHP.."\n"..
				"Level: "..p1.lvl.."\n"..
				"Gold: "..p1.gp.."\n"
			),
			30,80,native.systemFont,40
		)
		ginf:insert(info[2])
		
		local flr=WD.Circle()
		
		info[3]=display.newText(
			(
				"MP: "..p1.MP.."/"..p1.MaxMP.."\n"..
				"XP: "..p1.XP.."/"..p1.MaxXP.."\n"..
				"Floor: "..flr.."\n"
			),
			info[2].x+200,80,native.systemFont,40
		)
		ginf:insert(info[3])
		
		info[4]=display.newText(
			(
				"Statistics:".."\n"	
			),
			10,350,native.systemFontBold,50
		)
		ginf:insert(info[4])
		
		for s=1,6 do
			info[#info+1]=display.newText(
				(
					p1.statnames[s]
				),
				30,420+(45*(s-1)),native.systemFont,40
			)
			ginf:insert(info[#info])
		end
		
		info[#info+1]=display.newText(
			(
				"Stat Points: "..p1.pnts
			),
			30,690,native.systemFont,40
		)
		ginf:insert(info[#info])
		
		for s=1,6 do
			info[#info+1]=display.newText(
				(
					p1.nat[s]
				),
				info[7].x+220,420+(45*(s-1)),native.systemFont,40
			)
			ginf:insert(info[#info])
		end
		
		for s=1,6 do
			info[#info+1]=display.newText(
				(
				"+"..p1.eqs[s]
				),
				info[13].x+120,420+(45*(s-1)),native.systemFont,40
			)
			info[#info]:setTextColor(50,200,50)
			ginf:insert(info[#info])
		end
		
		for s=1,6 do
			info[#info+1]=display.newText(
				(
					"= "..p1.stats[s]
				),
				info[19].x+50,420+(45*(s-1)),native.systemFont,40
			)
			ginf:insert(info[#info])
		end
		
		if p1.name=="Magus" then
			info[#info+1]=display.newImageRect("player/Magus.png",120,120)
			info[#info].x=display.contentWidth-120
			info[#info].y=150
			info[#info].xScale=1.5
			info[#info].yScale=info[#info].xScale
			ginf:insert(info[#info])
		end
		
		if p1.pnts~=0 then
			pli={}
			mini={}
			for n=1,6 do
				--
				if (p1.nat[n]+1)<(p1.lvl*12) then
					pli[n]=widget.newButton{
						defaultFile="+.png",
						overFile="+2.png",
						width=20, height=20,
						onRelease = More,
					}
					pli[n].xScale,pli[n].yScale=2.0,2.0
					pli[n].x = info[11+n].x+45
					pli[n].y = 445+((n-1)*45)
					ginf:insert(pli[n])
				end
				--
				if p1.nat[n]-1~=0 then
					mini[n]=widget.newButton{
						defaultFile="-.png",
						overFile="-2.png",
						width=20, height=20,
						onRelease = Less,
					}
					mini[n].xScale,mini[n].yScale=2.0,2.0
					mini[n].x = info[11+n].x-75
					mini[n].y = 445+((n-1)*45)
					ginf:insert(mini[n])
				end
			end
		end
		ginf:toFront()
		
	elseif isOpn==true and (ginf) then
		isOpn=false
		for i=table.maxn(info),1,-1 do
			display.remove(info[i])
			info[i]=nil
		end
		info=nil
		for i=ginf.numChildren,1,-1 do
			display.remove(ginf[i])
			ginf[i]=nil
		end
		ginf=nil
	end
end

function More( event )
	local statnum
	for i=1,6 do
		if (pli[i]) then
			if event.y+21>pli[i].y and event.y-21<pli[i].y then
				statnum=i
			end
		end
	end
	p.Natural(statnum,1)
	ToggleInfo()
	ToggleInfo()
end

function Less( event )
	local statnum
	for i=1,6 do
		if (mini[i]) then
			if event.y+21>mini[i].y and event.y-21<mini[i].y then
				statnum=i
			end
		end
	end
	p.Natural(statnum,-1)
	ToggleInfo()
	ToggleInfo()
end

function DeathMenu(cause)
	if isOpn==false then
		gdm=display.newGroup()
		isOpn=true
		
		DMenu=display.newImageRect("deathmenu.png", 700, 500)
		DMenu.x,DMenu.y = display.contentWidth*0.5, 450
		Dthtxt=display.newGroup()
		
		if cause=="Lava" then
			local Deathmsg_Lava=display.newText("Swimming in lava.",0,0,"Game Over", 100)
			Deathmsg_Lava.x = display.contentWidth/2
			Deathmsg_Lava.y = 350
			Dthtxt:insert( Deathmsg_Lava )
		end
		if cause=="Mob" then
			local Deathmsg_Mob=display.newText("Fighting a mob.", 0,0,"Game Over", 100)
			Deathmsg_Mob.x = display.contentWidth/2
			Deathmsg_Mob.y = 350
			Dthtxt:insert( Deathmsg_Mob )
		end
		if cause=="Poison" then
			local Deathmsg_Poison=display.newText("Poisoning self. Dumbass.", 0,0,"Game Over", 100)
			Deathmsg_Poison.x = display.contentWidth/2
			Deathmsg_Poison.y = 350
			Dthtxt:insert( Deathmsg_Poison )
		end
		
		Deathmsg=display.newText("Game Over!",0,0, "Game Over", 190)
		Deathmsg.x = display.contentWidth/2
		Deathmsg.y = 280
		Dthtxt:insert( Deathmsg )
		
		ToMenuBtn = widget.newButton{
			label="Back To Menu",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton2.png",
			width=290, height=80,
			onRelease = onToMenuBtnRelease
		}
		ToMenuBtn:setReferencePoint( display.CenterReferencePoint )
		ToMenuBtn.x = display.contentWidth/2
		ToMenuBtn.y = display.contentHeight*0.61
		
		Round=WD.Circle()
		p1=p.GetPlayer()
		size=b.GetData(0)
		
		scre=sc.Scoring( Round , p1 , (math.sqrt(size)) )
		
		GInfoTxt=display.newGroup()
		InfoTxt1=display.newText("You got to floor",0,0,"Game Over", 90 )
		InfoTxt1.x=225
		InfoTxt1.y=(display.contentHeight/2)-100
		GInfoTxt:insert( InfoTxt1 )
		
		Round=tostring(Round)
		
		InfoTxt2=display.newText(Round,InfoTxt1.x+130+(20*(#Round-1)),InfoTxt1.y-25,"Game Over", 90 )
		InfoTxt2:setTextColor(0, 255, 0)
		GInfoTxt:insert( InfoTxt2 )
		
		InfoTxt3= display.newText("with",InfoTxt2.x+25+(20*(#Round-1)),InfoTxt1.y-25,"Game Over", 90 )
		GInfoTxt:insert( InfoTxt3 )
		
		GCount=tostring(p1.gp)
		
		InfoTxt4=display.newText(GCount,InfoTxt3.x+50,InfoTxt1.y-25,"Game Over", 90 )
		InfoTxt4:setTextColor(255, 255, 0)
		GInfoTxt:insert( InfoTxt4 )
		
		InfoTxt5=display.newText("gold.",InfoTxt4.x+25+(10*(#GCount-1)),InfoTxt1.y-25,"Game Over", 90 )
		GInfoTxt:insert( InfoTxt5 )
		
		InfoTxt6=display.newText(("Score: "..scre),0,0,"Game Over", 90 )
		InfoTxt6.x=display.contentWidth/2
		InfoTxt6.y=display.contentHeight/2
		GInfoTxt:insert( InfoTxt6 )
		
		gdm:insert( DMenu )
		gdm:insert( Dthtxt )
		gdm:insert( ToMenuBtn )
		gdm:insert( GInfoTxt )
		gdm:toFront()
		
		Runtime:removeEventListener("enterFrame", g.GoldDisplay)
		b.WipeMap()
		mov.ShowArrows("clean")
		audio.Stopbkg()
		
		local path = system.pathForFile(  "DoGSave.sav", system.DocumentsDirectory )
		local fh, errStr = io.open( path, "w+" )
		fh:write("")
		io.close( fh )
		
	elseif isOpn==true then
		for i=gdm.numChildren,1,-1 do
			display.remove(gdm[i])
			gdm[i]=nil
		end
		gdm=nil
		isOpn=false
	end
end

function AddItem(id,stacks,amount)
	local itmnme=item.ReturnInfo(id,0)
	local ItemAdded=false
	if not (amount) then
		amount=1
	end
	if table.maxn(p1.inv)==63 then
		print "Inventory is full!"
		return false
	elseif table.maxn(p1.inv)==0 then
		p1.inv[(#p1.inv+1)]={}
		p1.inv[(#p1.inv)][1]=id
		p1.inv[(#p1.inv)][2]=amount
		print ("Player now has "..p1.inv[1][2].." of "..itmnme..".")
	else
		for i=1, table.maxn(p1.inv) do
			if ItemAdded==false then
				if p1.inv[i] and p1.inv[i][1]==id and stacks==true then
						p1.inv[i][2]=((p1.inv[i][2])+amount)
						print ("Player now has "..p1.inv[i][2].." of "..itmnme..".")
						ItemAdded=true
				elseif i==(table.maxn(p1.inv)-1) then
				end
			end
		end
		if ItemAdded==false then
			p1.inv[(#p1.inv+1)]={}
			p1.inv[(#p1.inv)][1]=id
			p1.inv[(#p1.inv)][2]=amount
			print ("Player now has "..p1.inv[#p1.inv][2].." of "..itmnme..".")
			ItemAdded=true
		end
	end
end

function UseMenu(id,slot)

	if isUse==false then
	
		function UsedIt()
			
			isUse=false
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			if amount==1 then
				table.remove( p1.inv, slot )
			elseif amount~=1 then
				p1.inv[slot][2]=p1.inv[slot][2]-1
			end
			ToggleBag()
			if itemstats[3]==0 then
				ToggleBag()
				if itemstats[4]<0 then
					WD.Hurt("Poison",(itemstats[4]*-1))
				elseif itemstats[4]>0 then
					p.AddHP(itemstats[4])
				end
			elseif itemstats[3]==1 then
				p.GrantMana(itemstats[4])
				ToggleBag()
			else
				if itemstats[4]==0 then
					WD.FloorPort(false)
				elseif itemstats[4]==1 then
					WD.FloorPort(true)
				elseif itemstats[4]==2 then
					s.Save()
				end
			end
		end
		
		function LearnedIt()
			
			isUse=false
			local watevah=item.ReturnInfo(id,1)
			p.LearnSorcery(watevah)
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			table.remove( inv, slot )
			ToggleBag()
			ToggleBag()
		end
		
		function StatBoost()
			isUse=false
			local watevah=item.ReturnInfo(id,2)
			p.StatBoost(watevah)
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			if amount==1 then
				table.remove( inv, slot )
			elseif amount~=1 then
				p1.inv[slot][2]=p1.inv[slot][2]-1
			end
			ToggleBag()
			ToggleBag()
		end
		
		function EquippedIt()
			
			for i=1,table.maxn(p1.eqp) do
				if (p1.eqp[i]) and (p1.eqp[i][1]) and (p1.eqp[i][2]) and (p1.eqp[i][2]==itemstats[3]) then
					p1.inv[#p1.inv+1]={}
					p1.inv[#p1.inv][1]=p1.eqp[i][1]
					p1.inv[#p1.inv][2]=1
					table.remove( p1.eqp, (i) )
				end
			end
			
			p1.eqp[#p1.eqp+1]={}
			p1.eqp[#p1.eqp][1]=id
			p1.eqp[#p1.eqp][2]=itemstats[3]
			
			isUse=false
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			
			table.remove( p1.inv, slot )
			
			ToggleBag()
			ToggleBag()
			p.ModStats(statchange[1],statchange[2],statchange[3],statchange[4],statchange[5],statchange[6])
			statchange={}
		end
		
		function DroppedIt()
			
			statchange={}
			isUse=false
			for i=gum.numChildren,1,-1 do
				local child = gum[i]
				child.parent:remove( child )
			end
			table.remove( p1.inv, slot )
			ToggleBag()
			ToggleBag()
		end
		
		gum:toFront()
		isUse=true
		print ("Player wants to use item "..id..", in slot "..slot..".")
		window=display.newImageRect("usemenu.png", 768, 308)
		window.x,window.y = display.contentWidth/2, 450
		gum:insert( window )
		
		for i=1,table.maxn(items) do
			if items[i] then
				items[i]:removeEventListener("tap",Gah)
			end
		end
	
		itemstats={
			item.ReturnInfo(id,4)
		}
		
		if itemstats[1]==0 then
		
			local usebtn= widget.newButton{
				label="Use",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = UsedIt
			}
			usebtn:setReferencePoint( display.CenterReferencePoint )
			usebtn.x = (display.contentWidth/4)-50
			usebtn.y = (display.contentHeight/2)+30
			gum:insert( usebtn )
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gum:insert( lolname )
			
			local descrip=display.newText( (itemstats[5]) ,0,0,"Game Over",85)
			descrip:setTextColor( 180, 180, 180)
			descrip.x=display.contentWidth/2
			descrip.y=(display.contentHeight/2)-80
			gum:insert( descrip )
		end	
		if itemstats[1]==1 then
		
			local eqpstatchnge=false
			local itmfound=false
			
			local equipbtn= widget.newButton{
				label="Equip",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = EquippedIt
			}
			equipbtn:setReferencePoint( display.CenterReferencePoint )
			equipbtn.x = (display.contentWidth/4)-50
			equipbtn.y = (display.contentHeight/2)+30
			gum:insert( equipbtn )
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gum:insert( lolname )
			
			local equipstats
			for i=1,table.maxn(p1.eqp) do
				if p1.eqp[i][2]==itemstats[3] then
					equipstats={item.ReturnInfo(p1.eqp[i][1],4)}
					
					itmfound=true
					
				end
			end
			
			if itmfound==false then
				equipstats={0,0,0,0,0,0,0,0,0}
			end
			
			statchange={
				itemstats[4]-equipstats[4],
				itemstats[5]-equipstats[5],
				itemstats[6]-equipstats[6],
				itemstats[7]-equipstats[7],
				itemstats[8]-equipstats[8],
				itemstats[9]-equipstats[9]
			}		
			
			if statchange[1]>0 then
				stabonus=display.newText( ("STA +"..statchange[1]) ,0,0,"Game Over",85)
				stabonus:setTextColor( 60, 180, 60)
				stabonus.x=statchangex+(statchangexs*0)
				stabonus.y=statchangey
				gum:insert( stabonus )
				eqpstatchnge=true
			elseif statchange[1]<0 then
				stabonus=display.newText( ("STA "..statchange[1]) ,0,0,"Game Over",85)
				stabonus:setTextColor( 180, 60, 60)
				stabonus.x=statchangex+(statchangexs*0)
				stabonus.y=statchangey
				gum:insert( stabonus )
				eqpstatchnge=true
			end
			
			if statchange[2]>0 then
				attbonus=display.newText( ("ATT +"..statchange[2]) ,0,0,"Game Over",85)
				attbonus:setTextColor( 60, 180, 60)
				attbonus.x=statchangex+(statchangexs*1)
				attbonus.y=statchangey
				gum:insert( attbonus )
				eqpstatchnge=true
			elseif statchange[2]<0 then
				attbonus=display.newText( ("ATT "..statchange[2]) ,0,0,"Game Over",85)
				attbonus:setTextColor( 180, 60, 60)
				attbonus.x=statchangex+(statchangexs*1)
				attbonus.y=statchangey
				gum:insert( attbonus )
				eqpstatchnge=true
			end
			
			if statchange[3]>0 then
				accbonus=display.newText( ("DEF +"..statchange[3]) ,0,0,"Game Over",85)
				accbonus:setTextColor( 60, 180, 60)
				accbonus.x=statchangex+(statchangexs*2)
				accbonus.y=statchangey
				gum:insert( accbonus )
				eqpstatchnge=true
			elseif statchange[3]<0 then
				accbonus=display.newText( ("DEF "..statchange[3]) ,0,0,"Game Over",85)
				accbonus:setTextColor( 180, 60, 60)
				accbonus.x=statchangex+(statchangexs*2)
				accbonus.y=statchangey
				gum:insert( accbonus )
				eqpstatchnge=true
			end
			
			if statchange[4]>0 then
				defbonus=display.newText( ("MGC +"..statchange[4]) ,0,0,"Game Over",85)
				defbonus:setTextColor( 60, 180, 60)
				defbonus.x=statchangex+(statchangexs*3)
				defbonus.y=statchangey
				gum:insert( defbonus )
				eqpstatchnge=true
			elseif statchange[4]<0 then
				defbonus=display.newText( ("MGC "..statchange[4]) ,0,0,"Game Over",85)
				defbonus:setTextColor( 180, 60, 60)
				defbonus.x=statchangex+(statchangexs*3)
				defbonus.y=statchangey
				gum:insert( defbonus )
				eqpstatchnge=true
			end
			
			if statchange[5]>0 then
				dexbonus=display.newText( ("DEX +"..statchange[5]) ,0,0,"Game Over",85)
				dexbonus:setTextColor( 60, 180, 60)
				dexbonus.x=statchangex+(statchangexs*4)
				dexbonus.y=statchangey
				gum:insert( dexbonus )
				eqpstatchnge=true
			elseif statchange[5]<0 then
				dexbonus=display.newText( ("DEX "..statchange[5]) ,0,0,"Game Over",85)
				dexbonus:setTextColor( 180, 60, 60)
				dexbonus.x=statchangex+(statchangexs*4)
				dexbonus.y=statchangey
				gum:insert( dexbonus )
				eqpstatchnge=true
			end
			
			if statchange[6]>0 then
				intbonus=display.newText( ("INT +"..statchange[5]) ,0,0,"Game Over",85)
				intbonus:setTextColor( 60, 180, 60)
				intbonus.x=statchangex+(statchangexs*5)
				intbonus.y=statchangey
				gum:insert(intbonus)
				eqpstatchnge=true
			elseif statchange[6]<0 then
				intbonus=display.newText( ("INT "..statchange[5]) ,0,0,"Game Over",85)
				intbonus:setTextColor( 180, 60, 60)
				intbonus.x=statchangex+(statchangexs*5)
				intbonus.y=statchangey
				gum:insert(intbonus)
				eqpstatchnge=true
			end
			
			if eqpstatchnge==false then
				stabonus=display.newText( ("No change.") ,0,0,"Game Over",85)
				stabonus:setTextColor( 180, 180, 180)
				stabonus.x=display.contentWidth/2
				stabonus.y=statchangey
				gum:insert( stabonus )
			end
			
		end
		if itemstats[1]==2 then
		
			if itemstats[4]==0 or itemstats[4]==1 then
				local usebtn= widget.newButton{
					label="Teleport",
					labelColor = { default={255,255,255}, over={0,0,0} },
					fontSize=30,
					defaultFile="cbutton.png",
					overFile="cbutton2.png",
					width=200, height=55,
					onRelease = UsedIt
				}
				usebtn:setReferencePoint( display.CenterReferencePoint )
				usebtn.x = (display.contentWidth/4)-50
				usebtn.y = (display.contentHeight/2)+30
				gum:insert( usebtn )
			elseif itemstats[4]==2 then
				local usebtn= widget.newButton{
					label="Save",
					labelColor = { default={255,255,255}, over={0,0,0} },
					fontSize=30,
					defaultFile="cbutton.png",
					overFile="cbutton2.png",
					width=200, height=55,
					onRelease = UsedIt
				}
				usebtn:setReferencePoint( display.CenterReferencePoint )
				usebtn.x = (display.contentWidth/4)-50
				usebtn.y = (display.contentHeight/2)+30
				gum:insert( usebtn )
			end
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gum:insert( lolname )
			
			local descrip=display.newText( (itemstats[3]) ,0,0,"Game Over",85)
			descrip:setTextColor( 180, 180, 180)
			descrip.x=display.contentWidth/2
			descrip.y=(display.contentHeight/2)-80
			gum:insert( descrip )
			
		end
		if itemstats[1]==3 then	
		
			local learnbtn= widget.newButton{
				label="Learn",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = LearnedIt
			}
			learnbtn:setReferencePoint( display.CenterReferencePoint )
			learnbtn.x = (display.contentWidth/4)-50
			learnbtn.y = (display.contentHeight/2)+30
			gum:insert( learnbtn )
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gum:insert( lolname )
			
			local descrip=display.newText( (itemstats[4]) ,0,0,"Game Over",85)
			descrip:setTextColor( 180, 180, 180)
			descrip.x=display.contentWidth/2
			descrip.y=(display.contentHeight/2)-80
			gum:insert( descrip )
			
		end
		if itemstats[1]==4 then	
		
			local boostbtn= widget.newButton{
				label="Use",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton2.png",
				width=200, height=55,
				onRelease = StatBoost
			}
			boostbtn:setReferencePoint( display.CenterReferencePoint )
			boostbtn.x = (display.contentWidth/4)-50
			boostbtn.y = (display.contentHeight/2)+30
			gum:insert( boostbtn )
			
			local lolname=display.newText( (itemstats[2]) ,0,0,"Game Over",110)
			lolname.x=display.contentWidth/2
			lolname.y=(display.contentHeight/2)-150
			gum:insert( lolname )
			
			local descrip=display.newText( (itemstats[4]) ,0,0,"Game Over",85)
			descrip:setTextColor( 180, 180, 180)
			descrip.x=display.contentWidth/2
			descrip.y=(display.contentHeight/2)-80
			gum:insert( descrip )
			
		end
		
		local backbtn= widget.newButton{
			label="Back",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton2.png",
			width=200, height=55,
			onRelease = UseMenu}
		backbtn:setReferencePoint( display.CenterReferencePoint )
		backbtn.x = (display.contentWidth/2)
		backbtn.y = (display.contentHeight/2)+30
		gum:insert( backbtn )
		
		local dropbtn= widget.newButton{
			label="Drop",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton2.png",
			width=200, height=55,
			onRelease = DroppedIt}
		dropbtn:setReferencePoint( display.CenterReferencePoint )
		dropbtn.x = ((display.contentWidth/4)*3)+50
		dropbtn.y = (display.contentHeight/2)+30
		gum:insert( dropbtn )
		
	elseif isUse==true then
		isUse=false
		statchange={}
		for i=gum.numChildren,1,-1 do
			local child = gum[i]
			child.parent:remove( child )
		end
		ToggleBag()
		ToggleBag()
	end
end

function OpenWindow()
	return isOpn
end

function SilentQuip(id)
	itemstats={
		item.ReturnInfo(id,4)
	}
	p.ModStats(itemstats[4],itemstats[5],itemstats[6],itemstats[7],itemstats[8])
	p1.eqp[#p1.eqp+1]={}
	p1.eqp[#p1.eqp][1]=id
	p1.eqp[#p1.eqp][2]=itemstats[3]
end

function onToMenuBtnRelease()
	if (gdm) then
		DeathMenu()
	end
	if (ginf) then
		ToggleInfo()
	end
	WD.SrsBsns()
end

function InvFull()
	if table.maxn(p1.inv)==63 then
		print "Inventory is full!"
		return true
	else
		return false
	end
end