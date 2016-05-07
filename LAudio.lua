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
local bkgMus=true
local Loaded

function LoadSounds()
	if not (soundboard)then
		Sound=1.0
		Music=1.0
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
		--	soundboard[12] = audio.loadSound	("sounds/Button.wav")
			soundboard[13] = audio.loadSound	("sounds/rock1.mp3")
			soundboard[14] = audio.loadSound	("sounds/rock2.mp3")
			soundboard[15] = audio.loadSound	("sounds/rock3.mp3")
			soundboard[16] = audio.loadSound	("sounds/rock4.mp3")
			soundboard[17] = audio.loadSound	("sounds/rock5.mp3")
			Loaded=true
		else
			Loaded=false
			print ("\n".."There goes the sound.")
		end
	end
end

function Play(id)
	if Loaded==true then
		local check=audio.isChannelPlaying(id)
		if check==false then
			if id==10 and Stawp==false and bkgMus==true then
				audio.setVolume( 0.5*Music, { channel=id  })
				bkgmusic=audio.play( soundboard[id], {channel=id, onComplete=RepeatBkg} )
				if Music==0.0 then
					audio.pause(bkgmusic)
				end
			elseif Sound~=0.0 then
				if id==13 then
					id=id+(math.random(0,4))
				end
				if id==15 or id==16 then
					audio.setVolume( 0.4*Sound, { channel=id  })
				end
				audio.play( soundboard[id], {channel=id} )
			end
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

function MusicVol(value)
	Music=value
	if Music==0.0 then
		audio.pause(bkgmusic)
	else
		audio.setVolume( 0.1*Music, { channel=10  })
	end
end

function SoundVol(value)
	Sound=value
end

function sfx()
	return Sound
end

function muse()
	return Music
end