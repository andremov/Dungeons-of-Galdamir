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
local curMusic
local Loaded
local mChannel=20
local didChange=false
local shutup=false

function LoadSounds()
	if not (soundboard)then
		if ( "simulator" == system.getInfo("environment") ) then
			Sound=0.0
			Music=0.0
			devstartup= audio.loadSound("sounds/level.mp3")
			-- audio.play( devstartup, {channel=1} )
			devstartup=nil
		else
			Sound=0.5
			Music=0.5
		end
		soundboard={}
		musicboard={}
		soundboard[1] = audio.loadSound		("sounds/gold.mp3")
		if (soundboard[1])then
			soundboard[2] = audio.loadSound	("sounds/gate.mp3")
			soundboard[3] = audio.loadSound	("sounds/open.mp3")
			soundboard[4] = audio.loadSound	("sounds/close.mp3")
			soundboard[5] = audio.loadSound	("sounds/heal.mp3")
			soundboard[6] = audio.loadSound	("sounds/portal.mp3")
			soundboard[7] = audio.loadSound	("sounds/rock.mp3")
			soundboard[8] = audio.loadSound	("sounds/equip.mp3")
			soundboard[9] = audio.loadSound	("sounds/level.mp3")
			soundboard[10] = audio.loadSound	("sounds/melee.mp3")
			soundboard[11] = audio.loadSound	("sounds/magic.mp3")
			soundboard[12] = audio.loadSound	("sounds/click.mp3")
			soundboard[13] = audio.loadSound	("sounds/hit.mp3")
			soundboard[14] = audio.loadSound	("sounds/step1.mp3")
			soundboard[15] = audio.loadSound	("sounds/step2.mp3")
			soundboard[16] = audio.loadSound	("sounds/step3.mp3")
			soundboard[17] = audio.loadSound	("sounds/step4.mp3")
			soundboard[18] = audio.loadSound	("sounds/click2.mp3")
			--
			--
			Loaded=true
		else
			Loaded=false
			print ("\n".."There goes the sound.")
		end
	end
end

function Play(id)
	if Loaded==true and shutup==false then
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
	if Loaded==true and shutup==false then
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
	if Loaded==true and shutup==false then
		local check=audio.isChannelPlaying(mChannel)
		if check==false then
			if curMusic==1 then
				musicboard[1] = audio.loadStream	("sounds/menu.mp3")
				audio.setVolume( 0.5*Music, { channel=mChannel  })
			elseif curMusic==2 then
				musicboard[2] = audio.loadStream	("sounds/music.mp3")
				audio.setVolume( 0.7*Music, { channel=mChannel  })
			elseif curMusic==3 then
				musicboard[3] = audio.loadStream	("sounds/battle.mp3")
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

function RepeatBkg()
	if didChange==true then
		didChange=false
		for i in pairs (musicboard) do
			audio.dispose(musicboard[i])
			musicboard[i]=nil
		end
		timer.performWithDelay(3000,PlayMusic)
	else
		timer.performWithDelay(15000,PlayMusic)
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