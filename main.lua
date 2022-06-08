function love.load()
    love.graphics.setDefaultFilter('nearest')

    lovesize = require 'lib.lovesize'
    graphics = require "modules.graphics" -- module by HTV04

    math.randomseed(os.time())
    PADDLE_SPEED = 175

    font = love.graphics.newFont('fonts/font.TTF', 12)
    love.graphics.setFont(font)

    love.window.setMode(1280, 720, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    lovesize.set(432, 243)

    player1Points = 0
    player2Points = 0

    player1Y = 30
    player2Y = lovesize.getHeight() - 50

    ballX = lovesize.getWidth() / 2 - 2
    ballY = lovesize.getHeight() / 2 - 2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState = 'start'
end

function love.update(dt)
    graphics.screenBase(lovesize.getWidth(), lovesize.getHeight())
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(lovesize.getHeight() - 20, player1Y + PADDLE_SPEED * dt)
    end
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(lovesize.getHeight() - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

    -- screen boundries
    if ballX >= lovesize.getWidth() - 4 then
        player1Points = player1Points + 1
        ballX = lovesize.getWidth() / 2 - 2
        ballY = lovesize.getHeight() / 2 - 2
        ballDX, ballDY = -ballDX, -ballDY
        gameState = 'start'
    elseif ballX <= 0 + 4 then
        player2Points = player2Points + 1
        ballX = lovesize.getWidth() / 2 - 2
        ballY = lovesize.getHeight() / 2 - 2
        ballDX, ballDY = -ballDX, -ballDY
        gameState = 'start'
    elseif ballY >= lovesize.getHeight() - 4 then
        ballDY = -ballDY
    elseif ballY <= 0 then
        ballDY = -ballDY
    end
    -- player boundries
    if ballX <= 0 + 17 then
        if ballY >= player1Y and ballY <= player1Y + 24 then
            ballDX = -ballDX
        end
    elseif ballX >= lovesize.getWidth() - 17 then
        if ballY >= player2Y and ballY <= player2Y + 24 then
            ballDX = -ballDX
        end
    end
end
function love.resize(width, height)
	lovesize.resize(width, height)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ballX = lovesize.getWidth() / 2 - 2
            ballY = lovesize.getHeight() / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end
    end
end

function love.draw()
    love.graphics.push()
        graphics.screenBase(lovesize.getWidth(), lovesize.getHeight())
        lovesize.begin()
            love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

            love.graphics.setFont(font)

            love.graphics.rectangle('fill', 10, player1Y, 5, 30)
            love.graphics.rectangle('fill', lovesize.getWidth() - 15, player2Y, 5, 30)

            love.graphics.circle('fill', ballX, ballY, 4)

            love.graphics.printf(tostring(player1Points), 432 / 2 - 95, 243 / 4, 30, "center", 0, 2, 2)
            love.graphics.printf(tostring(player2Points), 432 / 2 + 75, 243 / 4, 30, "center", 0, 2, 2)

        lovesize.finish()
    love.graphics.pop()
end