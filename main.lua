function love.load()
    love.graphics.setDefaultFilter('nearest')

    lovesize = require 'lib.lovesize'
    graphics = require "modules.graphics" -- module by HTV04
    Timer = require "lib.timer"

    math.randomseed(os.time())
    PADDLE_SPEED = 175
    windowX, windowY = love.window.getPosition()
    SpinAmount = 0
    the = {
        [1] = 0,
        [2] = 0,
    }
    the[1], the[2] = love.window.getPosition()

    font = love.graphics.newFont('fonts/main.ttf', 12)
    love.graphics.setFont(font)

    love.window.setMode(800, 450, {
        fullscreen = false,
        resizable = false,
        vsync = true
    }) 
    function wtf() -- 10/10 code if I say so myself tbh
        Timer.tween(
            0.8,
            the,
            {
                [1] = 0,
                [2] = 0
            },
            "linear",
            function()
                Timer.tween(
                    0.8,
                    the,
                    {
                        [1] = 575,
                        [2] = 300
                    },
                    "in-bounce",
                    function()
                        Timer.tween(
                            0.8,
                            the,
                            {
                                [1] = 0
                            },
                            "out-quad",
                            function()
                                Timer.tween(
                                    0.8,
                                    the,
                                    {
                                        [1] = 575,
                                        [2] = 0
                                    },
                                    "in-bounce",
                                    function()
                                        Timer.tween(
                                            0.8,
                                            the,
                                            {
                                                [2] = 300
                                            },
                                            "out-quad",
                                            function()
                                                Timer.tween(
                                                    0.8,
                                                    the,
                                                    {
                                                        [1] = 0,
                                                        [2] = 0
                                                    },
                                                    "in-bounce",
                                                    function()
                                                        Timer.tween(
                                                            0.8,
                                                            the,
                                                            {
                                                                [2] = 300
                                                            },
                                                            "out-quad",
                                                            function()
                                                                Timer.tween(
                                                                    0.8,
                                                                    the,
                                                                    {
                                                                        [1] = 575,
                                                                        [2] = 0
                                                                    },
                                                                    "in-bounce",
                                                                    function()
                                                                        wtf()
                                                                    end
                                                                )
                                                            end
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
               
            end
        )
    end

    wtf()
    lovesize.set(432, 243)

    player1Points = 0
    player2Points = 0

    player1Y = 30
    player2Y = lovesize.getHeight() - 50

    ballX = lovesize.getWidth() / 2 - 2
    ballY = lovesize.getHeight() / 2 - 2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-100, 100)

    playing = false
end

function love.update(dt)
    --[[
    thisX, thisY = math.sin(SpinAmount * (SpinAmount / 2)) * 100, math.sin(SpinAmount * (SpinAmount)) * 100
	xVal, yVal = windowX + thisX, windowY + thisY
	love.window.setPosition(xVal, yVal)
	SpinAmount = SpinAmount + 0.4 * love.timer.getDelta()
    --]]--
    
    graphics.screenBase(lovesize.getWidth(), lovesize.getHeight())
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(lovesize.getHeight() - 20, player1Y + PADDLE_SPEED * dt)
    end
    if love.keyboard.isDown('1') then
        player1Points = player1Points + 1
    end
    Timer.update(dt)
    love.window.setPosition(the[1], the[2])

    --[[
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(lovesize.getHeight() - 20, player2Y + PADDLE_SPEED * dt)
    end
    --]]

    if playing then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
        
    end
    if ballDX ~= -100 and playing then
        player2Y = ballY

    end

    -- screen boundries
    if ballX >= lovesize.getWidth() - 4 then
        player1Points = player1Points + 1
        ballX = lovesize.getWidth() / 2 - 2
        ballY = lovesize.getHeight() / 2 - 2
        ballDX, ballDY = -ballDX, -ballDY
        playing = false
    elseif ballX <= 0 + 4 then
        player2Points = player2Points + 1
        ballX = lovesize.getWidth() / 2 - 2
        ballY = lovesize.getHeight() / 2 - 2
        ballDX, ballDY = -ballDX, -ballDY
        playing = false
    elseif ballY >= lovesize.getHeight() - 4 then
        ballDY = -ballDY
    elseif ballY <= 0 + 4 then
        ballDY = -ballDY
    end
    -- player boundries
    if ballX <= 0 + 17 then
        if ballY >= player1Y and ballY <= player1Y + 24 then
            ballDY = math.random(-100, 100)
            ballDX = -ballDX
        end
    elseif ballX >= lovesize.getWidth() - 17 then
        if ballY >= player2Y and ballY <= player2Y + 24 then
            ballDY = math.random(-100, 100)
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
        if not playing then
            playing = true
        else
            playing = false

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