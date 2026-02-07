function soundManager(dt)
    musicManager(dt)
end

function musicManager(dt)
    local hg = player.inClub and 1 or 0.001 * 1.5
    if currentTrack then currentTrack:setFilter{type = "lowpass", highgain = hg} 
        if isInBossFight or bossFightIntroMovie:isPlaying() then 
            currentTrack:setVolume(0) 
        else currentTrack:setVolume(volumeMaster) 
        end    
    end
    if currentAnnouncement then currentAnnouncement:setFilter{type = "lowpass", highgain = hg} end

    titleMusic:setVolume(volumeMaster)    

    if gameState == "mainmenu" then
        titleMusic:play()
        needNextTrack = true
    elseif gameState == "play" then
        titleMusic:stop()
        if currentAnnouncement then else currentAnnouncement = pickRandomAnnouncement() end
        currentSongTimePlayedFor = currentSongTimePlayedFor + dt
        if currentSongTimePlayedFor > currentSongDuration - 4 and currentAnnouncement and not currentAnnouncement:isPlaying() then
            currentAnnouncement = pickRandomAnnouncement()
            sfxManager(currentAnnouncement, true)
        end
        if needNextTrack then
            currentTrack = pickRandomTrack()
            lastPlayedMusic = currentTrack
            currentTrack:setVolume(volumeMaster)
            currentSongDuration = currentTrack:getDuration()
            currentSongTimePlayedFor = 0
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

function pickRandomAnnouncement()
    local announcement
    repeat
        announcement = flattenedAnnouncements[math.random(#flattenedAnnouncements)]
    until announcement ~= lastPlayedAnnouncement
    return announcement
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