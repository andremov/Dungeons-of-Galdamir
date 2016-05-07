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

function DisplayShop()
	atShop=true
	Runtime:removeEventListener("enterFrame",ui.Dice)
	gsm=display.newGroup()
	gp.ShowGCounter()
	
	window=display.newImageRect("shop.png", 768, 500)
	window.x,window.y = display.contentWidth*0.5, 450
	gsm:insert(window)
	
	shopsign=display.newImageRect("shopsign.png", 128, 64)
	shopsign.x,shopsign.y = display.contentWidth*0.5, 215
	shopsign.yScale=1.5
	shopsign.xScale=shopsign.yScale
	gsm:insert(shopsign)
	
	local ResumBtn= widget.newButton{
	label="Close",
	labelColor = { default={255,255,255}, over={0,0,0} },
	fontSize=30,
	defaultFile="cbutton.png",
	overFile="cbutton2.png",
	width=308, height=80,
	onRelease = CloseShop
	}
	ResumBtn:setReferencePoint( display.CenterReferencePoint )
	ResumBtn.x = (display.contentWidth/2)+180
	ResumBtn.y = (display.contentHeight/2)+110
	gsm:insert(ResumBtn)
	
	local PosItems=it.ShopStock(0)
	
	if table.maxn(PosItems)>=1 then
		choice={}
		item={}
		for i=1,4 do
			choice[i]={}
			choice[i][1]=math.random(1,(table.maxn(PosItems)))
			if (choice[i][1]) then
				choice[i][2],choice[i][3]=it.ShopStock(1,PosItems[choice[i][1]])
				if PosItems[choice[i][1]]==2 then
					item[#item+1]=display.newSprite( HPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					item[#item]:play()
				elseif PosItems[choice[i][1]]==3 then
					item[#item+1]=display.newSprite( HPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					item[#item]:play()
				elseif PosItems[choice[i][1]]==7 then
					item[#item+1]=display.newSprite( MPot2sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					item[#item]:play()
				elseif PosItems[choice[i][1]]==8 then
					item[#item+1]=display.newSprite( MPot3sheet, { name="Pot2", start=1, count=16, time=1000 }  )
					item[#item]:play()
				else
					item[#item+1]=display.newImageRect( "items/"..choice[i][2]..".png" ,64,64)
				end
				item[#item].xScale=2
				item[#item].yScale=2
				item[#item].x = 100+(((#item-1)%2)*350)
				item[#item].y = 350+((math.floor((#item-1)/2))*160)
				item[#item].txt=display.newText( (choice[i][2]) ,item[#item].x+50,item[#item].y-40,"Game Over",80)
				item[#item].prc=display.newText( (choice[i][3].." gold.") ,item[#item].x+50,item[#item].y,"Game Over",80)
				item[#item].prc:setTextColor( 255, 255, 0)
				function itemGet()
					BuyItem(PosItems[choice[i]],choice[i][2],choice[i][3])
				end
				item[#item]:addEventListener("tap",itemGet)
				gsm:insert(item[#item])
				gsm:insert(item[#item].txt)
				gsm:insert(item[#item].prc)
			end
		end
	end
end

function CloseShop()
	atShop=false
	for i=gsm.numChildren,1,-1 do
		display.remove(gsm[i])
		gsm[i]=nil
	end
	gp.ShowGCounter()
	gsm=nil
	display.remove(BoughtTxt)
	BoughtTxt=nil
	mov.ShowArrows()
end

function BuyItem(id,name,prc)
	local stacks=it.ReturnInfo(id,"stacks")
	local Full=inv.InvFull()
	local p1=p.GetPlayer()
	if Full==true or (p1.gp-prc)<0 then
		if not(BoughtTxt) or BoughtTxt.text~=("Not enough gold.") then
			BoughtTxt=display.newText(("Not enough gold."),80,570,300,0,"Game Over",70)
		end
	else
		if (BoughtTxt) then
			if BoughtTxt.text==(("You bought a "..name..".")) then
				BoughtTxt.text=(("You bought another "..name.."."))
			elseif BoughtTxt.text==(("You bought another "..name..".")) then
				BoughtTxt.text=(("You bought yet another "..name.."."))
			elseif BoughtTxt.text==(("You bought yet another "..name..".")) then
				BoughtTxt.text=(("Another "..name.."? Really?"))
			elseif 	BoughtTxt.text==(("Another "..name.."? Really?")) then 
				BoughtTxt.text=(("You don't need that many "..name.."s."))
			elseif BoughtTxt.text==(("You don't need that many "..name.."s.")) then
				BoughtTxt.text=(("I think you might have a  "..name.." addiction."))
			elseif BoughtTxt.text==(("I think you might have a  "..name.." addiction.")) then
				
			else
				BoughtTxt.text=(("You bought a "..name.."."))
			end
		else
			BoughtTxt=display.newText(("You bought a "..name.."."),80,570,300,0,"Game Over",70)
		end
		a.Play(1)
		inv.AddItem(id,stacks,1)
		gp.CallAddCoins(-prc)
	end
end

function AtTheMall()
	return atShop
end
