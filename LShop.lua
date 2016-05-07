-----------------------------------------------------------------------------------------
--
-- Shop.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local HPot2sheet = graphics.newImageSheet( "items/HealthPotion2.png", { width=64, height=64, numFrames=16 })
local HPot3sheet = graphics.newImageSheet( "items/HealthPotion3.png", { width=64, height=64, numFrames=16 })
local MPot2sheet = graphics.newImageSheet( "items/ManaPotion2.png", { width=64, height=64, numFrames=16 })
local MPot3sheet = graphics.newImageSheet( "items/ManaPotion3.png", { width=64, height=64, numFrames=16 })
local EPot2sheet = graphics.newImageSheet( "items/EnergyPotion2.png", { width=64, height=64, numFrames=16 })
local EPot3sheet = graphics.newImageSheet( "items/EnergyPotion3.png", { width=64, height=64, numFrames=16 })
local widget = require "widget"
local ui=require("Lui")
local b=require("Lmapbuilder")
local mov=require("Lmovement")
local WD=require("Lprogress")
local it=require("Litems")
local gp=require("Lgold")
local p=require("Lplayers")
local inv=require("Lwindow")
local a=require("Laudio")
local sav=require("Lsaving")
local swg
local gbm
local gsm
local BoughtTxt
local atShop=false
local page

function DisplayShop(id)
	atShop=true
	gsm=display.newGroup()
	gbm=display.newGroup()
	swg=display.newGroup()
	gp.ShowGCounter()
	Shops=b.GetData(7)
	curShop=Shops[id]
	ShopID=id
	page=1
	
	window=display.newImageRect("shop.png", 768, 600)
	window.x,window.y = display.contentWidth*0.5, 425
	swg:insert(window)
	
	shopsign=display.newImageRect("shopsign.png", 128, 64)
	shopsign.x,shopsign.y = display.contentWidth*0.5, 150
	shopsign.yScale=1.5
	shopsign.xScale=shopsign.yScale
	swg:insert(shopsign)
	
	local ResumBtn= widget.newButton{
		label="Close",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=303, height=52,
		onRelease = CloseShop
	}
	ResumBtn:setReferencePoint( display.CenterReferencePoint )
	ResumBtn.x = (display.contentWidth/4)*3
	ResumBtn.y = (display.contentHeight/2)+150
	swg:insert(ResumBtn)
	
	if not(curShop.item)then
		local PosItems=it.ShopStock(0)
		if table.maxn(PosItems)>=1 then
			curShop.item={}
			choice={}
			for i=1,4 do
				choice[i]={}
				choice[i][1]=math.random(1,(table.maxn(PosItems)))
				curShop.item[i]={}
				curShop.item[i][1]=PosItems[choice[i][1]]
				curShop.item[i][2],curShop.item[i][3]=it.ShopStock(1,curShop.item[i][1])
			end
		end
	end
	swg:toFront()
	SellMenu()
	BuyMenu()
end

function BuyMenu()
	for s=1,4 do
		item={}
		if (curShop.item[s][1]) then
			if curShop.item[s][1]==2 then
				item[s]=display.newSprite( HPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				item[s]:play()
			elseif curShop.item[s][1]==3 then
				item[s]=display.newSprite( HPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				item[s]:play()
			elseif curShop.item[s][1]==7 then
				item[s]=display.newSprite( MPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				item[s]:play()
			elseif curShop.item[s][1]==8 then
				item[s]=display.newSprite( MPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				item[s]:play()
			elseif curShop.item[s][1]==10 then
				item[s]=display.newSprite( EPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				item[s]:play()
			elseif curShop.item[s][1]==11 then
				item[s]=display.newSprite( EPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				item[s]:play()
			else
				item[s]=display.newImageRect( "items/"..curShop.item[s][2]..".png" ,64,64)
			end
			item[s].x = display.contentCenterX+60
			item[s].y = 280+((s-1)*100)
			item[s].txt=display.newText( (curShop.item[s][2]) ,item[s].x+50,item[s].y-40,"MoolBoran",50)
			item[s].prc=display.newText( ("Buy for "..curShop.item[s][3].." gold.") ,item[s].x+50,item[s].y,"MoolBoran",40)
			item[s].prc:setTextColor( 255, 255, 0)
			item[s].sq=display.newRect(0,0,350,80)
			item[s].sq.x = item[s].x+135
			item[s].sq.y = item[s].y
			item[s].sq:setFillColor(0,0,0,0)
			function itemGet()
				ItemInfo(s)
			end
			item[s].sq:addEventListener("tap",itemGet)
			gbm:insert(item[s])
			gbm:insert(item[s].txt)
			gbm:insert(item[s].prc)
			gbm:insert(item[s].sq)
		end
	end
	gbm:toFront()
end

function SellMenu()
	local p1=p.GetPlayer()
	pitems={}
	for m=1,5 do
		if (p1.inv[m+((page-1)*5)]) then
			pitems[m]={}
			pitems[m][1]=p1.inv[m+((page-1)*5)][1]
			pitems[m][2]=p1.inv[m+((page-1)*5)][2]
			pitems[m][3],pitems[m][4]=it.ShopStock(1,pitems[m][1])
			if pitems[m][4]~=nil then
				pitems[m][4]=math.ceil(pitems[m][4]/2)
			end
		end
	end
	for s=1,5 do
		if (pitems[s]) then
			if pitems[s][1]==2 then
				pitems[s].img=display.newSprite( HPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				pitems[s].img:play()
			elseif pitems[s][1]==3 then
				pitems[s].img=display.newSprite( HPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				pitems[s].img:play()
			elseif pitems[s][1]==7 then
				pitems[s].img=display.newSprite( MPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				pitems[s].img:play()
			elseif pitems[s][1]==8 then
				pitems[s].img=display.newSprite( MPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
				pitems[s].img:play()
			else
				pitems[s].img=display.newImageRect( "items/"..pitems[s][3]..".png" ,64,64)
			end
			pitems[s].img.x = 60
			pitems[s].img.y = 280+((s-1)*80)
			pitems[s].txt=display.newText( (pitems[s][3]) ,pitems[s].img.x+50,pitems[s].img.y-40,"MoolBoran",50)
			if pitems[s][2]~=1 then
				if pitems[s][2]>9 then
					pitems[s].num=display.newText( (pitems[s][2]) ,pitems[s].img.x+5,pitems[s].img.y-5,"Game Over",80)
				elseif p1.inv[s][2]<=9 then
					pitems[s].num=display.newText( (pitems[s][2]) ,pitems[s].img.x+15,pitems[s].img.y-5,"Game Over",80)
				end
			end
			if pitems[s][4]~=nil then
				pitems[s].prc=display.newText( ("Sell for "..pitems[s][4].." gold.") ,pitems[s].img.x+50,pitems[s].img.y,"MoolBoran",40)
				pitems[s].prc:setTextColor( 255, 255, 0)
				pitems[s].sq=display.newRect(0,0,350,80)
				pitems[s].sq.x = pitems[s].img.x+135
				pitems[s].sq.y = pitems[s].img.y
				pitems[s].sq:setFillColor(0,0,0,0)
			end
			function itemGive()
				SellItem(pitems[s][1],pitems[s][3],pitems[s][4],(s+(5*(page-1))))
			end
			if pitems[s][4]~=nil then
				pitems[s].sq:addEventListener("tap",itemGive)
			end
			gsm:insert(pitems[s].img)
			gsm:insert(pitems[s].txt)
			if (pitems[s].prc) then
				gsm:insert(pitems[s].prc)
				gsm:insert(pitems[s].sq)
			end
			if (pitems[s].num) then
				gsm:insert( pitems[s].num )
			end
		end
	end
	
	PageTxt=display.newText( ("Page "..page.."/"..math.ceil(table.maxn(p1.inv)/5)),0,0,"MoolBoran",50 )
	PageTxt.x = (display.contentCenterX/2)
	PageTxt.y = (display.contentCenterY)+160
	gsm:insert(PageTxt)
	
	if page~=1 then
		PrevBtn= widget.newButton{
			defaultFile="arrow.png",
			overFile="arrow2.png",
			width=50, height=50,
			onRelease = PrevPage
		}
		PrevBtn:setReferencePoint( display.CenterReferencePoint )
		PrevBtn.x = (display.contentCenterX/2)-120
		PrevBtn.y = (display.contentCenterY)+150
		PrevBtn.rotation=180
		gsm:insert(PrevBtn)
	end
	
	if page~=math.ceil(table.maxn(p1.inv)/5) then
		NextBtn= widget.newButton{
			defaultFile="arrow.png",
			overFile="arrow2.png",
			width=50, height=50,
			onRelease = NextPage
		}
		NextBtn:setReferencePoint( display.CenterReferencePoint )
		NextBtn.x = (display.contentCenterX/2)+120
		NextBtn.y = (display.contentCenterY)+150
		gsm:insert(NextBtn)
	end
	gsm:toFront()
end

function SellItem(id,name,prc,slot)
	local p1=p.GetPlayer()
	a.Play(1)
	
	if p1.inv[slot][2]==1 then
		table.remove( p1.inv, slot )
		for i=gsm.numChildren,1,-1 do
			display.remove(gsm[i])
			gsm[i]=nil
		end
		if page>math.ceil(table.maxn(p1.inv)/5) then
			page=page-1
		end
		SellMenu()
	else
		p1.inv[slot][2]=p1.inv[slot][2]-1
		for i=gsm.numChildren,1,-1 do
			display.remove(gsm[i])
			gsm[i]=nil
		end
		if page>math.ceil(table.maxn(p1.inv)/5) then
			page=page-1
		end
		SellMenu()
	end
	
	if (BoughtTxt) then
		display.remove(BoughtTxt)
		BoughtTxt=nil
	end
	
	--[[
	BoughtTxt=display.newText(("You sold a "..name.."."),0,0,"Game Over",70)
	BoughtTxt:setTextColor( 255, 255, 0)
	BoughtTxt.x=display.contentCenterX
	BoughtTxt.y=750]]
	
	gp.CallAddCoins(prc)
end

function NextPage()
	for i=gsm.numChildren,1,-1 do
		display.remove(gsm[i])
		gsm[i]=nil
	end
	page=page+1
	SellMenu()
end

function PrevPage()
	for i=gsm.numChildren,1,-1 do
		display.remove(gsm[i])
		gsm[i]=nil
	end
	page=page-1
	SellMenu()
end

function CloseShop()
	atShop=false
	for i=gsm.numChildren,1,-1 do
		display.remove(gsm[i])
		gsm[i]=nil
	end
	gsm=nil
	for i=swg.numChildren,1,-1 do
		display.remove(swg[i])
		swg[i]=nil
	end
	swg=nil
	for i=gbm.numChildren,1,-1 do
		display.remove(gbm[i])
		gbm[i]=nil
	end
	gbm=nil
	gp.ShowGCounter()
	
	mov.Visibility()
end

function BuyItem(id,name,prc)
	local stacks=it.ReturnInfo(id,3)
	local Full=inv.InvFull()
	local p1=p.GetPlayer()
	if Full==true or prc>p1.gp then
	else
		print (id)
		print (stacks)
		print (prc)
		a.Play(1)
		inv.AddItem(id,stacks,1)
		gp.CallAddCoins(-prc)
		
		for i=gsm.numChildren,1,-1 do
			display.remove(gsm[i])
			gsm[i]=nil
		end
		SellMenu()
	end
end

function ItemInfo(slot)
	if (slot) and type(slot)=="number" then
		local p1=p.GetPlayer()
		local statchangexs=200
		local statchangey=(display.contentCenterY)-70
		local statchangex=(display.contentCenterX)-statchangexs
		
		gum=display.newGroup()
		gum:toFront()
		isUse=true
	
		function Buy()
			ItemInfo()
			BuyItem(curShop.item[slot][1],curShop.item[slot][2],curShop.item[slot][3])
			for i=gbm.numChildren,1,-1 do
				display.remove(gbm[i])
				gbm[i]=nil
			end
			BuyMenu()
		end
		
		window=display.newImageRect("usemenu.png", 768, 308)
		window.x,window.y = display.contentWidth/2, 450
		gum:insert( window )
		
		for i=1,table.maxn(item) do
			if item[i] then
				item[i].sq:removeEventListener("tap",itemGet)
			end
		end
		for i=1,table.maxn(pitems) do
			if pitems[i] then
				pitems[i].sq:addEventListener("tap",itemGive)
			end
		end
		
		if curShop.item[slot][3]>p1.gp then
			local usebtn= widget.newButton{
				label="Buy",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="nbutton.png",
				overFile="nbutton-over.png",
				width=200, height=55,
			}
			usebtn:setReferencePoint( display.CenterReferencePoint )
			usebtn.x = (display.contentWidth/2)-120
			usebtn.y = (display.contentHeight/2)+30
			gum:insert( usebtn )
		else
			local usebtn= widget.newButton{
				label="Buy",
				labelColor = { default={255,255,255}, over={0,0,0} },
				fontSize=30,
				defaultFile="cbutton.png",
				overFile="cbutton-over.png",
				width=200, height=55,
				onRelease = Buy
			}
			usebtn:setReferencePoint( display.CenterReferencePoint )
			usebtn.x = (display.contentWidth/2)-120
			usebtn.y = (display.contentHeight/2)+30
			gum:insert( usebtn )
		end
		
		local backbtn= widget.newButton{
			label="Back",
			labelColor = { default={255,255,255}, over={0,0,0} },
			fontSize=30,
			defaultFile="cbutton.png",
			overFile="cbutton-over.png",
			width=200, height=55,
			onRelease = ItemInfo}
		backbtn:setReferencePoint( display.CenterReferencePoint )
		backbtn.x = (display.contentWidth/2)+120
		backbtn.y = (display.contentHeight/2)+30
		gum:insert( backbtn )
		
		itemstats={
			it.ReturnInfo(curShop.item[slot][1],4)
		}
		
		local lolname=display.newText( (itemstats[2]) ,0,0,"MoolBoran",90)
		lolname.x=display.contentWidth/2
		lolname.y=(display.contentHeight/2)-120
		gum:insert( lolname )
		
		if itemstats[1]==0 then			
			local descrip=display.newText( (itemstats[5]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
		end	
		if itemstats[1]==1 then
			local itmfound=false
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
			stattxts={}
			
			local eqpstatchnge=false
			local stats={"STA","ATT","DEF","MGC","DEX","INT"}
			for c=1,6 do
				if statchange[c]>0 then
					stattxts[c]=display.newText( (stats[c].." +"..statchange[c]),0,0,"MoolBoran",60)
					stattxts[c]:setTextColor( 60, 180, 60)
					stattxts[c].x=statchangex+(statchangexs*((c-1)%3))
					stattxts[c].y=statchangey+(50*math.floor((c-1)/3))
					gum:insert( stattxts[c] )
					eqpstatchnge=true
				elseif statchange[c]<0 then
					stattxts[c]=display.newText( (stats[c].." "..statchange[c]) ,0,0,"MoolBoran",60)
					stattxts[c]:setTextColor( 180, 60, 60)
					stattxts[c].x=statchangex+(statchangexs*((c-1)%3))
					stattxts[c].y=statchangey+(50*math.floor((c-1)/3))
					gum:insert( stattxts[c] )
					eqpstatchnge=true
				end
			end
			
			if eqpstatchnge==false then
				stattxts[1]=display.newText( ("No change.") ,0,0,"MoolBoran",55)
				stattxts[1]:setTextColor( 180, 180, 180)
				stattxts[1].y=(display.contentHeight/2)-50
				stattxts[1].x=display.contentWidth/2
				gum:insert( stattxts[1] )
			end
		end
		if itemstats[1]==2 then
			local descrip=display.newText( (itemstats[3]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
		end
		if itemstats[1]==3 then
			local descrip=display.newText( (itemstats[4]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
		end
		if itemstats[1]==4 then
			local descrip=display.newText( (itemstats[4]) ,0,0,"MoolBoran",55)
			descrip.y=(display.contentHeight/2)-50
			descrip.x=display.contentWidth/2
			descrip:setTextColor( 180, 180, 180)
			gum:insert( descrip )
		end
		
	else
		isUse=false
		statchange={}
		for i=gum.numChildren,1,-1 do
			local child = gum[i]
			child.parent:remove( child )
		end
		gum=nil
	end
end

function AtTheMall()
	return atShop
end
