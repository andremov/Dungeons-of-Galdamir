local _M = {}

local mFloor = math.floor
local sGetInfo = system.getInfo
local sGetTimer = system.getTimer

local prevTime = 0
_M.added = true

local function createText()
	local memory = display.newText('00 00.00 000',10,0, native.systemFont, 40);
	memory:setFillColor(0,0,0)
	memory.anchorY = 0
	memory.x, memory.y = display.contentCenterX, display.actualContentHeight-50
	
	background=display.newRect(memory.x, memory.y+20,245,45)
	
	function background:tap()
		collectgarbage('collect')
		if _M.added then
			Runtime:removeEventListener('enterFrame', _M.labelUpdater)
			_M.added = false
			background.alpha = .01
			memory.alpha = .01
		else
			Runtime:addEventListener('enterFrame', _M.labelUpdater)
			_M.added = true
			background.alpha = 1
			memory.alpha = 1
		end
	end
	background:addEventListener('tap', background)
	return memory, background
end

function _M.labelUpdater(event)
	local curTime = sGetTimer()
	_M.text.text = tostring(mFloor( 1000 / (curTime - prevTime))) .. ' ' ..
			tostring(mFloor(sGetInfo('textureMemoryUsed') * 0.0001) * 0.01) .. ' ' ..
			tostring(mFloor(collectgarbage('count')))
	_M.bkg:toFront()
	_M.text:toFront()
	prevTime = curTime
end

function _M:newPerformanceMeter()
	self.text, self.bkg = createText(self)
	Runtime:addEventListener('enterFrame', _M.labelUpdater)
end

return _M
