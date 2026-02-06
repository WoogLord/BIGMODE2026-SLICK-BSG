function assignSpriteSheets()
    -- player
    player.spriteSheet = love.graphics.newImage("assets/art/spritesheets/player-sheet.png")
    player.anim = playerAnimationArray
    player.anim:BuildAnimations(player.spriteSheet, tileWH, tileWH)
    player.anim.currAnimState = 3

    thingsBeingAnimated = {
        player.anim
    }

    -- girls
    interactables[1].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Goth girl security-Sheet.png")
    interactables[2].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Frat girl-Sheet.png")
    interactables[3].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Influencer sprite-Sheet.png")
    -- item NPCs
    interactables[4].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Leather Jacket guy-Sheet.png")
    interactables[5].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Hair guy for game-Sheet.png")
    interactables[6].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Kamina Shades Sprite-Sheet.png")
    interactables[7].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Abs npc Sprite-Sheet.png")
    interactables[8].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Girl with Blue hair sprite-Sheet.png")
    interactables[9].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Shorts NPC Sprite-Sheet.png")
    interactables[10].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Mewing Man Sprite-Sheet.png")
    -- Juice NPCs
    interactables[11].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Leather Jacket guy WO-Sheet.png")


    -- add everyone else to animation array
    for i, interacts in pairs(interactables) do
        if i == 4 or i == 11 then interacts.anim = jacketGuyAnimationArray else interacts.anim = everyoneElseAnimationArray end
        print(interacts.tileW..interacts.tileH)
        interacts.anim:BuildAnimations(interacts.spriteSheet, interacts.tileW, interacts.tileH)
        interacts.anim.currAnimState = 1
        table.insert(thingsBeingAnimated, interacts.anim)
        print(thingsBeingAnimated[i])
    end
end

function assignLayerArt()
    -- bgs
    bg_01_nightclub = love.graphics.newImage("assets/art/bgs/bg_01_master - All layers.png")

    -- top
    bg_01_topLayer = love.graphics.newImage("assets/art/bgs/bg_01_master - All layers.png")

    -- collision
    -- debug
    bg_01_collision = love.graphics.newImage("assets/art/bgs/bg_01_master - Collision.png")
    bg_01_collisionData = love.image.newImageData("assets/art/bgs/bg_01_master - Collision.png")

    -- interactables
    z_key_art = love.graphics.newImage("assets/art/ui/z_key.png")
end

function assignPortraits()
    -- tests
    port_test_360 = love.graphics.newImage("assets/art/portraits/360360.png")
    port_test_256 = love.graphics.newImage("assets/art/portraits/256256.png")

    -- chatbox
    interactables[1].chatbox = {
        fill = love.graphics.newImage("assets/art/ui/gothGirl_chatbox_fill.png")
        , outline = love.graphics.newImage("assets/art/ui/gothGirl_chatbox_outline.png")
    }

    -- portraits
    interactables[1].portrait = {spriteSheet = love.graphics.newImage("assets/art/portraits/Layla Sprite Sheet_FINAL.png")}
    interactables[2].portrait = {spriteSheet = love.graphics.newImage("assets/art/portraits/Sorority Sprite Sheet_FINAL.png")}
    interactables[3].portrait = {spriteSheet = love.graphics.newImage("assets/art/portraits/Starchild Sprite Sheet_FINAL.png")}

    portraitArr = {
        interactables[1].portrait,
        interactables[2].portrait,
        interactables[3].portrait,
    }

    -- portrait assignment for animations
    for i, portrait in pairs(portraitArr) do
        portrait.anim = portraitAnimationArray
        portrait.anim:BuildAnimations(portrait.spriteSheet, 360, 360)
        portrait.anim.currAnimState = 1
        table.insert(thingsBeingAnimated, portrait.anim)
        print(thingsBeingAnimated[i])
    end
    
    -- portrait Frame
    interactables[1].portraitFrame = love.graphics.newImage("assets/art/portraits/Influencer portrait.png")
    interactables[2].portraitFrame = love.graphics.newImage("assets/art/portraits/Influencer portrait.png")
    interactables[3].portraitFrame = love.graphics.newImage("assets/art/portraits/Influencer portrait.png")

end