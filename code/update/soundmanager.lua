function soundManager()
    musicManager()
end

function musicManager()
    local hg = player.inClub and 1 or 0.001
    if currentTrack then currentTrack:setFilter{type = "lowpass", highgain = hg} end

    titleMusic:setVolume(volumeMaster)

    if gameState == "mainmenu" then
        titleMusic:play()
        needNextTrack = true
    elseif gameState == "play" then
        titleMusic:stop()

        if needNextTrack then
            currentTrack = pickRandomTrack()
            lastPlayedMusic = currentTrack
            currentTrack:setVolume(volumeMaster)
            currentSongDuration = currentTrack:getDuration()
            currentTrack:play()
            needNextTrack = false
        end
        if not currentTrack or not currentTrack:isPlaying() then
            needNextTrack = true
        end
    end
end

function pickRandomTrack()
    local track
    repeat
        track = flattenedMusicClubTracks[math.random(#flattenedMusicClubTracks)]
    until track ~= lastPlayedMusic
    return track
end

function sfxManager(_sfxToPlay, _inClubNeeded)
    local hg = player.inClub and 1 or 0.001
    if _inClubNeeded then _sfxToPlay:setFilter{type = "lowpass", highgain = hg}
    else _sfxToPlay:setFilter{type = "lowpass", highgain = 1}
    end
    _sfxToPlay:stop()
    _sfxToPlay:setVolume(volumeMaster)
    _sfxToPlay:play()
end
