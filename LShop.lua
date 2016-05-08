-----------------------------------------------------------------------------------------
--
-- Shop.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local ui=require("Lui")
local b=require("Lbuilder")
local mov=require("Lmoves")
local WD=require("Lprogress")
local it=require("Litems")
local gp=require("Lgold")
local p=require("Lplayers")
local inv=require("Lwindow")
local a=require("Laudio")
local sav=require("Lsaving")
local menu=require("Lmenu")
local swg
local gbm
local gsm
local BoughtTxt
local atShop=false
local page

function DisplayShop(id,room)
	a.Play(3)
	atShop=true
	swg=display.newGroup()
	gp.ShowGCounter()
	p.LetsYodaIt()
	Shops=b.GetData(7)
	curShop=Shops[room][id]
	ShopID=id
	page=1
	menu.FindMe(7)
	isUse=false
	window=display.newImageRect("shop.png", 768, 600)
	window.x,window.y = display.contentWidth*0.5, 425
	swg:insert(window)
	
	shopsign=display.newImageRect("shopsign.png", 128, 64)
	shopsign.x,shopsign.y = display.contentWidth*0.5, 150
	shopsign.yScale=1.5
	shopsign.xScale=shopsign.yScale
	swg:insert(shopsign)
	
	local ResumBtn=  widget.newButton{
		label="Close",
		labelColor = { default={255,255,255}, over={0,0,0} },
		font="MoolBoran",
		fontSize=50,
		labelYOffset=10,
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
	if (gbm) then
		for i=gbm.numChildren,1,-1 do
			display.remove(gbm[i])
			gbm[i]=nil
		end
		gbm=nil
	end
	gbm=display.newGroup()
	item={}
	itemw={}
	for s=1,4 do
		if (curShop.item[s][1]) then
			item[s]=display.newImageRect( "items/"..curShop.item[s][2]..".png" ,64,64)
			item[s].x = display.contentCenterX+60
			item[s].y = 280+((s-1)*100)
			item[s].txt=display.newText( (curShop.item[s][2]) ,item[s].x+50,item[s].y-40,"MoolBoran",50)
			item[s].prc=display.newText( ("Buy for "..curShop.item[s][3].." gold.") ,item[s].x+50,item[s].y,"MoolBoran",40)
			item[s].prc:setTextColor( 255, 255, 0)
			itemw[s]=display.newRect(0,0,350,80)
			itemw[s].x = item[s].x+135
			itemw[s].y = item[s].y
			itemw[s]:setFillColor(0,0,0,0)
			function itemGet()
				ItemInfo(s)
			end
			itemw[s]:addEventListener("tap",itemGet)
			gbm:insert(item[s])
			gbm:insert(item[s].txt)
			gbm:insert(item[s].prc)
			gbm:insert(itemw[s])
		end
	end
	
	gbm:toFront()
end

function SellMenu()
	local p1=p.GetPlayer()
	if (gsm) then
		for i=gsm.numChildren,1,-1 do
			display.remove(gsm[i])
			gsm[i]=nil
		end
		gsm=nil
	end
	gsm=display.newGroup()
	pinv={}
	pitem={}
	pitemw={}
	for m=1,5 do
		if (p1.inv[m+((page-1)*5)]) then
			pinv[m]={}
			pinv[m][1]=p1.inv[m+((page-1)*5)][1]
			pinv[m][2]=p1.inv[m+((page-1)*5)][2]
			pinv[m][3],pinv[m][4]=it.ShopStock(1,pinv[m][1])
			if pinv[m][4]~=nil then
				pinv[m][4]=math.ceil(pinv[m][4]/2)
			end
		end
	end
	for s=1,5 do
		if (pinv[s]) then
			pitem[s]=display.newImageRect( "items/"..pinv[s][3]..".png" ,64,64)
			pitem[s].x = 60
			pitem[s].y = 280+((s-1)*80)
			pitem[s].txt=display.newText( (pinv[s][3]) ,pitem[s].x+50,pitem[s].y-40,"MoolBoran",50)
			if pinv[s][2]~=1 then
				if pinv[s][2]>9 then
					pitem[s].num=display.newText( (pinv[s][2]) ,pitem[s].x+5,pitem[s].y-5,"Game Over",80)
				elseif pinv[s][2]<=9 then
					pitem[s].num=display.newText( (pinv[s][2]) ,pitem[s].x+15,pitem[s].y-5,"Game Over",80)
				end
			end
			if pinv[s][4]~=nil then
				pitem[s].prc=display.newText( ("Sell for "..pinv[s][4].." gold.") ,pitem[s].x+50,pitem[s].y,"MoolBoran",40)
				pitem[s].prc:setTextColor( 255, 255, 0)
			end
			pitemw[s]=display.newRect(0,0,350,80)
			pitemw[s].x = pitem[s].x+135
			pitemw[s].y = pitem[s].y
			pitemw[s]:setFillColor(0,0,0,0)
			function itemGive()
				SellItem(pinv[s][4],(s+(5*(page-1))))
			end
			if pinv[s][4]~=nil then
				pitemw[s]:addEventListener("tap",itemGive)
			end
			gsm:insert(pitem[s])
			gsm:insert(pitem[s].txt)
			gsm:insert(pitemw[s])
			if (pitem[s].prc) then
				gsm:insert(pitem[s].prc)
			end
			if (pitem[s].num) then
				gsm:insert( pitem[s].num )
			end
		end
	end
	
	PageTxt=display.newText( ("Page "..page.."/"..math.ceil(table.maxn(p1.inv)/5)),0,0,"MoolBoran",50 )
	PageTxt.x = (display.contentCenterX/2)
	PageTxt.y = (display.contentCenterY)+160
	gsm:insert(PageTxt)
	
	if page>1 then
		PrevBtn=  widget.newButton{
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
		NextBtn=  widget.newButton{
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

function SellItem(prc,slot)
	if isUse==false then
		local p1=p.GetPlayer()
		a.Play(1)
		
		if p1.inv[slot][2]==1 then
			table.remove( p1.inv, slot )
		else
			p1.inv[slot][2]=p1.inv[slot][2]-1
		end
		if page>math.ceil(table.maxn(p1.inv)/5) then
			page=page-1
		end
		SellMenu()
		
		gp.CallAddCoins(prc)
	end
end

function NextPage()
	page=page+1
	SellMenu()
end

function PrevPage()
	page=page-1
	SellMenu()
end

function CloseShop()
	a.Play(4)
	menu.FindMe(6)
	if isUse==true then
		ItemInfo()
	end
	atShop=false
	if (gsm) then
		for i=gsm.numChildren,1,-1 do
			display.remove(gsm[i])
			gsm[i]=nil
		end
		gsm=nil
	end
	if (gbm) then
		for i=gbm.numChildren,1,-1 do
			display.remove(gbm[i])
			gbm[i]=nil
		end
		gbm=nil
	end
	for i=swg.numChildren,1,-1 do
		display.remove(swg[i])
		swg[i]=nil
	end
	swg=nil
	gp.ShowGCounter()
	p.LetsYodaIt()
	mov.Visibility()
end

function BuyItem(id,name,prc)
	local stacks=it.ReturnInfo(id,3)
	local Full=inv.InvFull()
	local p1=p.GetPlayer()
	if Full==true or prc>p1.gp then
	else
		a.Play(1)
		inv.AddItem(id,stacks,1)
		gp.CallAddCoins(-prc)
	end
end

function ItemInfo(slot)
	if (slot) and type(slot)=="number"  then
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
		end
		
		for s in pairs(pitemw) do
			display.remove(pitemw[s])
			pitemw[s]=nil
		end
		
		for s in pairs(itemw) do
			display.remove(itemw[s])
			itemw[s]=nil
		end
		
		window=display.newImageRect("usemenu.png", 768, 308)
		window.x,window.y = display.contentWidth/2, 450
		gum:insert( window )
		
		if curShop.item[slot][3]>p1.gp then
			local usebtn=  widget.newButton{
				label="Buy",
				labelColor = { default={255,255,255}, over={0,0,0} },
				font="MoolBoran",
				fontSize=50,
				labelYOffset=10,
				defaultFile="nbutton.png",
				overFile="nbutton-over.png",
				width=200, height=55,
			}
			usebtn:setReferencePoint( display.CenterReferencePoint )
			usebtn.x = (display.contentWidth/2)-120
			usebtn.y = (display.contentHeight/2)+30
			gum:insert( usebtn )
		else
			local usebtn=  widget.newButton{
				label="Buy",
				labelColor = { default={255,255,255}, over={0,0,0} },
				font="MoolBoran",
				fontSize=50,
				labelYOffset=10,
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
		
		local backbtn=  widget.newButton{
			label="Back",
			labelColor = { default={255,255,255}, over={0,0,0} },
			font="MoolBoran",
			fontSize=50,
			labelYOffset=10,
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
					equipstats={it.ReturnInfo(p1.eqp[i][1],4)}
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
		
	elseif isUse==true then
		statchange={}
		timer.performWithDelay(100,SellMenu)
		timer.performWithDelay(100,BuyMenu)
		for i=gum.numChildren,1,-1 do
			local child = gum[i]
			child.parent:remove( child )
		end
		gum=nil
		isUse=false
	end
end

function AtTheMall()
	return atShop
end
