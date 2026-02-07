function initUI()
    selOptionMain = 1
    selOptionInv = 1
    selDialogOption = 1
    currentDialogTreeId = "1"
    menuOptionsMain = {"PLAY", "VOLUME", "QUIT"}
    menuOptionsPause = {"UNPAUSE", "VOLUME", "QUIT"}
    selOptionPause = 1

    mainMenuImage = love.graphics.newImage("assets/art/bgs/Intro_title_screen.png")

    buttonsMainMenu = {
        play = {x = (currWinDim.w / 2) - 200, y = 150, w = 400, h = 50, label = "play"}
        , quit = {x = (currWinDim.w / 2) - 200, y = 250, w = 400, h = 50, label = "QUIT", r=200, g=0, b=0}
    }

    chatbox_9slice  = {
        fill = love.graphics.newImage("assets/art/nineslices/nineslice_chatbox_fill.png")
        , outline = love.graphics.newImage("assets/art/nineslices/nineslice_chatbox_outline.png")
    }   

    love.math.setRandomSeed(os.time())
end
