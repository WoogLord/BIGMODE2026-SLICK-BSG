function soundManager(dt)
    musicManager(dt)
    if isPlayingDelayedSfx and delayedSfx then
        if itemGetSfxDelayTime > itemGetSfxDelayTimer  then 
            if not delayedSfx:isPlaying() then
                sfxManager(delayedSfx, false)
            end
            isPlayingDelayedSfx = false
        end        
    end
end

function musicManager(dt)
    local hg = player.inClub and math.min(1,1) or math.max(0.001 * 1.5, 0.001 * 1.5)
    if currentTrack then currentTrack:setFilter{type = "lowpass", highgain = hg} 
        if isInBossFight then 
            if bossFightIntroMovie:isPlaying() then 
                currentTrack:setVolume(0)
            else
                bossFightMusic:setVolume(volumeMaster)
                bossFightMusic:play()
                if currentAnnouncement then 
                    currentAnnouncement:setVolume(0)
                end
            end
        elseif gameState == "victory" then
            currentTrack:setVolume(0) 
            bossFightMusic:setVolume(0)
        else currentTrack:setVolume(volumeMaster) 
            bossFightMusic:setVolume(0)
        end    
    end
    if currentAnnouncement then currentAnnouncement:setFilter{type = "lowpass", highgain = hg} end

    titleMusic:setVolume(volumeMaster)    

    if gameState == "mainmenu" then
        creditsMovie:getSource():setVolume(0)
        titleMusic:play()
        needNextTrack = true
    elseif gameState == "intro_cutscene" then
        titleMusic:stop()
    elseif gameState == "victory" then
        bossFightMusic:setVolume(0)
    elseif gameState == "play" then
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
    local hg = player.inClub and 1 or 0.001 * 1.5
    if _inClubNeeded then _sfxToPlay:setFilter{type = "lowpass", highgain = hg}
    else _sfxToPlay:setFilter{type = "lowpass", highgain = 1}
    end
    _sfxToPlay:stop()
    _sfxToPlay:setVolume(volumeMaster)
    _sfxToPlay:play()
end