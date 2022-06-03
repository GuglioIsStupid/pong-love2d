push = require 'lib.push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest')

    math.randomseed(os.time())

    font = love.graphics.newFont('fonts/font.TTF', 12)
    love.graphics.setFont(font)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1Points = 0
    player2Points = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState = 'start'
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

    -- screen boundries
    if ballX >= VIRTUAL_WIDTH - 4 then
        player1Points = player1Points + 1
        ballX = VIRTUAL_WIDTH / 2 - 2
        ballY = VIRTUAL_HEIGHT / 2 - 2
        ballDX, ballDY = -ballDX, -ballDY
        gameState = 'start'
    elseif ballX <= 0 + 4 then
        player2Points = player2Points + 1
        ballX = VIRTUAL_WIDTH / 2 - 2
        ballY = VIRTUAL_HEIGHT / 2 - 2
        ballDX, ballDY = -ballDX, -ballDY
        gameState = 'start'
    elseif ballY >= VIRTUAL_HEIGHT - 4 then
        ballDY = -ballDY
    elseif ballY <= 0 then
        ballDY = -ballDY
    end
    -- player boundries
    if ballX <= 0 + 17 then
        if ballY >= player1Y and ballY <= player1Y + 24 then
            ballDX = -ballDX
        end
    elseif ballX >= VIRTUAL_WIDTH - 17 then
        if ballY >= player2Y and ballY <= player2Y + 24 then
            ballDX = -ballDX
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end
    end
end

function love.draw()
    love.graphics.push()
        push:apply('start')

        love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

        love.graphics.setFont(font)

        love.graphics.rectangle('fill', 10, player1Y, 5, 30)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, 5, 30)

        love.graphics.circle('fill', ballX, ballY, 4)

        love.graphics.printf(tostring(player1Points), 432 / 2 - 95, 243 / 4, 30, "center", 0, 2, 2)
        love.graphics.printf(tostring(player2Points), 432 / 2 + 75, 243 / 4, 30, "center", 0, 2, 2)

        push:apply('end')
    love.graphics.pop()
end