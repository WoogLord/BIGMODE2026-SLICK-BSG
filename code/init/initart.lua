function assignSpriteSheets()
    -- player
    player.spriteSheet = love.graphics.newImage("assets/art/spritesheets/player-sheet.png")
    player.anim = playerAnimationArray
    player.anim:BuildAnimations(player.spriteSheet)
    player.anim.currAnimState = 3

    -- everyone Else
    interactables.gothGirl.spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Goth girl security.png")
    interactables.sororityGirl.spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Frat girl.png")

    thingsBeingAnimated = {
        player.anim
    }

    for i, interacts in pairs(interactables) do
        interacts.anim = everyoneElseAnimationArray
        interacts.anim:BuildAnimations(interacts.spriteSheet)
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
end