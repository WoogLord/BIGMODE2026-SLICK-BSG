local dir = love.filesystem.getSourceBaseDirectory()
package.path = dir .. "/?.lua;" .. dir .. "/?/init.lua;" .. package.path

-- love.load functions
local initF require "code.init.startgame"

-- love.update functions
local updF require "code.update.mainupdate"
local inputsF require "code.update.inputs"
local statsF require "code.update.statsmanager"

-- love.draw functions
local drawF require "code.draw.maindraw"

function love.load()
    init()
end

function love.update(dt)
    love.timer.sleep(1/60)
    gameManager()
    speedManager(dt)
end

function love.draw()
    drawStateMachine()
end