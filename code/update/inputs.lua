function love.keypressed(key)
    if key == INPUTS_ARR.debug then isDebug = not isDebug end
    if key == INPUTS_ARR.pause then love.event.quit() end
    if key == INPUTS_ARR.fullscreen then isFullScreen = not isFullScreen
        love.window.setFullscreen(isFullScreen)
    end
end