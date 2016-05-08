-----------------------------------------------------------------------------------------
--
-- Audio.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local Sound
local Music
local soundboard
local musicboard
local bkgMus=true
local Loaded
local curMusic
local mChannel=20
local didChange=false

function LoadSounds()
	if not (soundboard)then
	--	Sound=0.5
	--	Music=0.5
		Sound=0.0
		Music=0.0
		soundboard={}
		musicboard={}
		soundboard[1] = audio.loadSound		("sounds/gold.wav")
		if (soundboard[1])then
			soundboard[2] = audio.loadSound		("sounds/gate.wav")
			soundboard[3] = audio.loadSound		("sounds/open.wav")
			soundboard[4] = audio.loadSound		("sounds/close.wav")
			soundboard[5] = audio.loadSound		("sounds/heal.wav")
			soundboard[6] = audio.loadSound		("sounds/portal.wav")
			soundboard[7] = audio.loadSound		("sounds/rock.wav")
			soundboard[8] = audio.loadSound		("sounds/equip.wav")
			soundboard[9] = audio.loadSound		("sounds/level.wav")
			soundboard[10] = audio.loadSound	("sounds/melee.wav")
			soundboard[11] = audio.loadSound	("sounds/magic.wav")
			soundboard[12] = audio.loadSound	("sounds/click.wav")
			soundboard[13] = audio.loadSound	("sounds/hit.wav")
			soundboard[14] = audio.loadSound	("sounds/step1.wav")
			soundboard[15] = audio.loadSound	("sounds/step2.wav")
			soundboard[16] = audio.loadSound	("sounds/step3.wav")
			soundboard[17] = audio.loadSound	("sounds/step4.wav")
			--
			musicboard[1] = audio.loadSound		("sounds/menu.wav")
			musicboard[2] = audio.loadSound		("sounds/music.wav")
			musicboard[3] = audio.loadSound		("sounds/battle.wav")
			--
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
		else
			audio.stop(id)
		end
		if Sound~=0.0 then
			if id==12 then
				audio.setVolume( 0.3*Sound, { channel=id  })
				audio.play( soundboard[id], {channel=id} )
			elseif id==7 then
				audio.setVolume( 0.3*Sound, { channel=id  })
				audio.play( soundboard[id], {channel=id} )
			else
				audio.setVolume( 1.0*Sound, { channel=id  })
				audio.play( soundboard[id], {channel=id} )
			end
		end
	end
end

function Step()
	if Loaded==true then
		local check=audio.isChannelPlaying(14)
		if check==false then
			if Sound~=0.0 then
				audio.setVolume( 0.25*Sound, { channel=14  })
				audio.play( soundboard[math.random(14,17)], {channel=14} )
			end
		else
			audio.stop(14)
			if Sound~=0.0 then
				audio.setVolume( 0.25*Sound, { channel=14  })
				audio.play( soundboard[math.random(14,17)	], {channel=14} )
			end
		end
	end
end

function PlayMusic()
	if Loaded==true then
		local check=audio.isChannelPlaying(mChannel)
		if check==false then
			if curMusic==1 then
				audio.setVolume( 0.5*Music, { channel=mChannel  })
			elseif curMusic==2 then
				audio.setVolume( 0.2*Music, { channel=mChannel  })
			elseif curMusic==3 then
				audio.setVolume( 0.5*Music, { channel=mChannel  })
			end
			bkgmusic=audio.play( musicboard[curMusic], {channel=mChannel, onComplete=RepeatBkg} )
			if Music==0.0 then
				audio.pause(bkgmusic)
			end
		elseif check==true then
			audio.fadeOut( { channel=mChannel, time=2000 } )
		end
	end
end

function changeMusic(data)
	if curMusic~=data then
		curMusic=data
		if curMusic~=0 then
			didChange=true
			PlayMusic()
		end
	end
end

function Stopbkg()
	audio.fadeOut({ bkg, 100 })
end

function RepeatBkg()
	if didChange==true then
		didChange=false
		timer.performWithDelay(3000,PlayMusic)
	else
		timer.performWithDelay(10000,PlayMusic)
	end
end

function MusicVol(value)
	Music=value
	if Music==0.0 then
		audio.pause(bkgmusic)
	else
		audio.setVolume( 0.5*Music, { channel=mChannel  })
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