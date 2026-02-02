function soundManager()
    musicManager()
    sfxManager()
end

function musicManager()
    musicClubTracks.mus_04_funkyRave:setVolume(volumeMaster)
    musicClubTracks.mus_04_funkyRave:setFilter{type = "lowpass", highgain = 0.025}
    if gameState == "play" then
        musicClubTracks.mus_04_funkyRave:play()
    end
end

function sfxManager()
    
end
