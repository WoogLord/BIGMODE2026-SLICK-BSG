function soundManager()
    musicManager()
    sfxManager()
end

function musicManager()
    love.audio.update()
    -- musicClubTracks.mus_04_funkyRave:setVolume(volumeMaster)
    -- musicClubTracks.mus_04_funkyRave:setFilter{type = "lowpass", highgain = 0.001}
    -- if gameState == "play" then
    --     musicClubTracks.mus_04_funkyRave:play()
    -- end
end

local nowPlaying = {}
function love.audio.update()
    local songsToRemove = {}
    for _, song in pairs(nowPlaying) do
        if song:isStopped() then
            songsToRemove[#songsToRemove+1] = song
        end
    end

    for i, song in ipairs(songsToRemove) do
        nowPlaying[song] = nil
    end
end

local play = love.audio.play
function love.audio.play(_what, _how, _loop)
    local src = _what
    if type(_what) ~= "userdata" or not _what:typeOf("Source") then
        src = love.audio.newSource(_what, _how)
        src:setLooping(_loop or false)
    end

    play(src)
    sources[src] = src
    return src
end

local stop = love.audio.stop
function love.audio.stop(_src)
    if not src then return end
    stop(_src)
    sources[_src] = nil
end

function sfxManager()
    
end
