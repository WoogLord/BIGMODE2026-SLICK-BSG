function initUI()
    buttonsMainMenu = {
        play = {x = (currWinDim.w / 2) - 200, y = 150, w = 400, h = 50, label = "play"}
        , quit = {x = (currWinDim.w / 2) - 200, y = 250, w = 400, h = 50, label = "QUIT", r=200, g=0, b=0}
    }

    chatbox_9slice  = {
        fill = love.graphics.newImage("assets/art/nineslices/nineslice_chatbox_fill.png")
        , outline = love.graphics.newImage("assets/art/nineslices/nineslice_chatbox_outline.png")
    }   
end
