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
local widget = require "widget"
local ui=require("LUI")
local b=require("LMapBuilder")
local mov=require("Lmovement")
local WD=require("LProgress")
local it=require("LItems")
local gp=require("LGold")
local p=require("Lplayers")
local inv=require("Lwindow")
local a=require("LAudio")
local sav=require("LSaving")
local gsm
local BoughtTxt
local atShop=false

function DisplayShop(id)
	atShop=true
	gsm=display.newGroup()
	gp.ShowGCounter()
	Shops=b.GetData(7)
	curShop=Shops[id]
	ShopID=id
	
	window=display.newImageRect("shop.png", 768, 600)
	window.x,window.y = display.contentWidth*0.5, 425
	gsm:insert(window)
	
	shopsign=display.newImageRect("shopsign.png", 128, 64)
	shopsign.x,shopsign.y = display.contentWidth*0.5, 150
	shopsign.yScale=1.5
	shopsign.xScale=shopsign.yScale
	gsm:insert(shopsign)
	
	local ResumBtn= widget.newButton{
		label="Close",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton2.png",
		width=303, height=52,
		onRelease = CloseShop
	}
	ResumBtn:setReferencePoint( display.CenterReferencePoint )
	ResumBtn.x = (display.contentWidth/4)*3
	ResumBtn.y = (display.contentHeight/2)+150
	gsm:insert(ResumBtn)
	
	SellMenu()
	
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
			else
				item[s]=display.newImageRect( "items/"..curShop.item[s][2]..".png" ,64,64)
			end
			item[s].x = display.contentCenterX+60
			item[s].y = 280+((s-1)*100)
			item[s].txt=display.newText( (curShop.item[s][2]) ,item[s].x+50,item[s].y-30,"Game Over",80)
			item[s].prc=display.newText( ("Buy for "..curShop.item[s][3].." gold.") ,item[s].x+50,item[s].y,"Game Over",70)
			item[s].prc:setTextColor( 255, 255, 0)
			function itemGet()
				BuyItem(curShop.item[s][1],curShop.item[s][2],curShop.item[s][3])
			end
			item[s]:addEventListener("tap",itemGet)
			gsm:insert(item[s])
			gsm:insert(item[s].txt)
			gsm:insert(item[s].prc)
		end
	end
end

function SellMenu()
	local p1=p.GetPlayer()
	page=1
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
			pitems[s].txt=display.newText( (pitems[s][3]) ,pitems[s].img.x+50,pitems[s].img.y-30,"Game Over",80)
			if pitems[s][4]~=nil then
				pitems[s].prc=display.newText( ("Sell for "..pitems[s][4].." gold.") ,pitems[s].img.x+50,pitems[s].img.y,"Game Over",70)
			end
			pitems[s].prc:setTextColor( 255, 255, 0)
			function itemGive()
				SellItem(pitems[s][1],pitems[s][3],pitems[s][4],(s+(5*(page-1))))
			end
			if pitems[s][4]~=nil then
				pitems[s].img:addEventListener("tap",itemGive)
			end
			gsm:insert(pitems[s].img)
			gsm:insert(pitems[s].txt)
			gsm:insert(pitems[s].prc)
		end
	end
	
	if page~=math.ceil(table.maxn(p1.inv)/5) then
		NextBtn= widget.newButton{
			defaultFile="arrow.png",
			overFile="arrow2.png",
			width=50, height=50,
			onRelease = NextPage
		}
		NextBtn:setReferencePoint( display.CenterReferencePoint )
		NextBtn.x = (display.contentWidth/4)+120
		NextBtn.y = (display.contentHeight/2)+150
		gsm:insert(NextBtn)
	end
end

function SellItem(id,name,prc,slot)
	local p1=p.GetPlayer()
	a.Play(1)
	if p1.inv[slot][2]==1 then
		table.remove( p1.inv, slot )
		CloseShop(true)
		DisplayShop(ShopID)
	else
		p1.inv[slot][2]=p1.inv[slot][2]-1
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
	local p1=p.GetPlayer()
	if table.maxn(p1.inv)>0 and page~=math.ceil(table.maxn(p1.inv)/5) then
		for s=table.maxn(pitems),1,-1 do
			display.remove(pitems[s].prc)
			pitems[s].prc=nil
			display.remove(pitems[s].txt)
			pitems[s].txt=nil
			display.remove(pitems[s].img)
			pitems[s].img=nil
			pitems[s]=nil
		end
		pitems=nil
		page=page+1
		pitems={}
		for m=1,5 do
			if (p1.inv[m+((page-1)*5)]) then
				pitems[m]={}
				pitems[m][1]=p1.inv[m+((page-1)*5)][1]
				pitems[m][2]=p1.inv[m+((page-1)*5)][2]
				pitems[m][3],pitems[m][4]=it.ShopStock(1,pitems[m][1])
				pitems[m][4]=math.ceil(pitems[m][4]/2)
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
				pitems[s].txt=display.newText( (pitems[s][3]) ,pitems[s].img.x+50,pitems[s].img.y-30,"Game Over",80)
				pitems[s].prc=display.newText( ("Sell for "..pitems[s][4].." gold.") ,pitems[s].img.x+50,pitems[s].img.y,"Game Over",70)
				pitems[s].prc:setTextColor( 255, 255, 0)
				function itemGive()
					SellItem(pitems[s][1],pitems[s][3],pitems[s][4],(s+(5*(page-1))))
				end
				pitems[s].img:addEventListener("tap",itemGive)
				gsm:insert(pitems[s].img)
				gsm:insert(pitems[s].txt)
				gsm:insert(pitems[s].prc)
			end
		end
		
		display.remove(PrevBtn)
		display.remove(NextBtn)

		if page~=math.ceil(table.maxn(p1.inv)/5) then
			NextBtn= widget.newButton{
				defaultFile="arrow.png",
				overFile="arrow2.png",
				width=50, height=50,
				onRelease = NextPage
			}
			NextBtn:setReferencePoint( display.CenterReferencePoint )
			NextBtn.x = (display.contentWidth/4)+120
			NextBtn.y = (display.contentHeight/2)+150
			gsm:insert(NextBtn)
		end
		
		PrevBtn= widget.newButton{
			defaultFile="arrow.png",
			overFile="arrow2.png",
			width=50, height=50,
			onRelease = PrevPage
		}
		PrevBtn:setReferencePoint( display.CenterReferencePoint )
		PrevBtn.x = (display.contentWidth/4)+120
		PrevBtn.y = (display.contentHeight/2)+150
		gsm:insert(PrevBtn)
	end
end

function PrevPage()
	local p1=p.GetPlayer()
	if page~=1 then
		for s=table.maxn(pitems),1,-1 do
			display.remove(pitems[s].prc)
			pitems[s].prc=nil
			display.remove(pitems[s].txt)
			pitems[s].txt=nil
			display.remove(pitems[s].img)
			pitems[s].img=nil
			pitems[s]=nil
		end
		page=page-1
		pitems={}
		for m=1,5 do
			if (p1.inv[m+((page-1)*5)]) then
				pitems[m]={}
				pitems[m][1]=p1.inv[m+((page-1)*5)][1]
				pitems[m][2]=p1.inv[m+((page-1)*5)][2]
				pitems[m][3],pitems[m][4]=it.ShopStock(1,pitems[m][1])
				pitems[m][4]=math.ceil(pitems[m][4]/2)
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
				pitems[s].txt=display.newText( (pitems[s][3]) ,pitems[s].img.x+50,pitems[s].img.y-30,"Game Over",80)
				pitems[s].prc=display.newText( ("Sell for "..pitems[s][4].." gold.") ,pitems[s].img.x+50,pitems[s].img.y,"Game Over",70)
				pitems[s].prc:setTextColor( 255, 255, 0)
				function itemGive()
					SellItem(pitems[s][1],pitems[s][3],pitems[s][4],(s+(5*(page-1))))
				end
				pitems[s].img:addEventListener("tap",itemGive)
				gsm:insert(pitems[s].img)
				gsm:insert(pitems[s].txt)
				gsm:insert(pitems[s].prc)
			end
		end
	
		display.remove(PrevBtn)
		display.remove(NextBtn)

		if page~=1 then
			PrevBtn= widget.newButton{
				defaultFile="arrow.png",
				overFile="arrow2.png",
				width=50, height=50,
				onRelease = PrevPage
			}
			PrevBtn:setReferencePoint( display.CenterReferencePoint )
			PrevBtn.x = (display.contentWidth/4)+120
			PrevBtn.y = (display.contentHeight/2)+150
			gsm:insert(PrevBtn)
		end
		
		NextBtn= widget.newButton{
			defaultFile="arrow.png",
			overFile="arrow2.png",
			width=50, height=50,
			onRelease = NextPage
		}
		NextBtn:setReferencePoint( display.CenterReferencePoint )
		NextBtn.x = (display.contentWidth/4)+120
		NextBtn.y = (display.contentHeight/2)+150
		gsm:insert(NextBtn)
	end
end

function CloseShop(data)
	atShop=false
	for i=gsm.numChildren,1,-1 do
		display.remove(gsm[i])
		gsm[i]=nil
	end
	gp.ShowGCounter()
	gsm=nil
	display.remove(BoughtTxt)
	BoughtTxt=nil
	if (data==true) then
	else
		mov.ShowArrows()
	end
end

function BuyItem(id,name,prc)
	local stacks=it.ReturnInfo(id,"stacks")
	local Full=inv.InvFull()
	local p1=p.GetPlayer()
	if Full==true then
		if (BoughtTxt) then
			display.remove(BoughtTxt)
			BoughtTxt=nil
		end
		--[[
		BoughtTxt=display.newText(("Inventory is full."),0,0,"Game Over",70)
		BoughtTxt:setTextColor( 255, 255, 0)
		BoughtTxt.x=display.contentCenterX
		BoughtTxt.y=750]]
	elseif (p1.gp-prc)<0 then
		if (BoughtTxt) then
			display.remove(BoughtTxt)
			BoughtTxt=nil
		end
		--[[
		BoughtTxt=display.newText(("Not enough gold."),0,0,"Game Over",70)
		BoughtTxt:setTextColor( 255, 255, 0)
		BoughtTxt.x=display.contentCenterX
		BoughtTxt.y=750]]
	else
		if (BoughtTxt) then
			display.remove(BoughtTxt)
			BoughtTxt=nil
		end
		
		a.Play(1)
		inv.AddItem(id,stacks,1)
		gp.CallAddCoins(-prc)
		
		CloseShop(true)
		DisplayShop(ShopID)
		--[[
		BoughtTxt=display.newText(("You bought a "..name.."."),0,0,"Game Over",70)
		BoughtTxt:setTextColor( 255, 255, 0)
		BoughtTxt.x=display.contentCenterX
		BoughtTxt.y=750]]
	end
end

function AtTheMall()
	return atShop
end
