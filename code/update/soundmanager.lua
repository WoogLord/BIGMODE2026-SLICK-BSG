function soundManager()
    musicManager()
    sfxManager()
end

function musicManager()
    musicClubTracks.mus_04_funkyRave:setVolume(volumeMaster)
    if gameState == "play" then
        musicClubTracks.mus_04_funkyRave:play()
    end
end

function sfxManager()
    
end
