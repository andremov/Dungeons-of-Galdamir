-----------------------------------------------------------------------------------------
--
-- Audio.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local Sound
local Music
local Stawp
local soundboard

function LoadSounds()
	if not (soundboard)then
		Sound=true
		Music=true
		Stawp=true
		soundboard={}
		soundboard[1] = audio.loadSound		("sounds/gold.wav")
		if (soundboard[1])then
			soundboard[2] = audio.loadSound		("sounds/OpenDoor.wav")
			soundboard[3] = audio.loadSound		("sounds/Start.wav")
			soundboard[4] = audio.loadSound		("sounds/TryAgain.wav")
			soundboard[5] = audio.loadSound		("sounds/pauseclose.wav")
			soundboard[6] = audio.loadSound		("sounds/pauseopen.wav")
			soundboard[7] = audio.loadSound		("sounds/NewLife.wav")
			soundboard[10] = audio.loadSound	("sounds/bkgmusic.wav")
			soundboard[11] = audio.loadSound	("sounds/portal.wav")
			soundboard[12] = audio.loadSound	("sounds/Button.wav")
			soundboard[13] = audio.loadSound	("sounds/rock1.mp3")
			soundboard[14] = audio.loadSound	("sounds/rock2.mp3")
			soundboard[15] = audio.loadSound	("sounds/rock3.mp3")
			soundboard[16] = audio.loadSound	("sounds/rock4.mp3")
			soundboard[17] = audio.loadSound	("sounds/rock5.mp3")
		else
			print ("\n".."There goes the sound.")
		end
	end
end

function Play(id)
	local check=audio.isChannelPlaying(id)
	if check==false and (soundboard[1]) then
		if id==10 and Stawp==false then
		--[[	bkgmusic=audio.play( soundboard[id], {channel=id, onComplete=RepeatBkg} )
			audio.setVolume( 0.1, { channel=id  })
			if Music==false then
				audio.pause(bkgmusic)
			end]]
		elseif Sound==true then
			if id==13 then
				id2=id+(math.random(0,4))
			else
				id2=id
			end
			audio.play( soundboard[id2], {channel=id} )
		end
	end
end

function Menu(val)
	if val==true then
		Stawp=true
	else
		Stawp=false
	end
end

function Stopbkg()
	audio.fadeOut({ bkg, 100 })
end

function RepeatBkg()
	timer.performWithDelay(10000,BkgMusic)
end

function SimpleMMute()
	Music=false
	local check=audio.isChannelPlaying(10)
	if check==true then
		audio.pause(bkgmusic)
	end
end

function SimpleMUnmute()
	Music=true
end

function SimpleSMute()
	Sound=false
end

function SimpleSUnmute()
	Sound=true
end

function sfx()
	return Sound
end

function muse()
	return Music
end