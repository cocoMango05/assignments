
--variables 
--require
push = require("push")
--Class = require("Class")
Class = require("class")
require("Paddle")
require("Ball")

WindowWidth = 1300; 
WindowHeight = 800; 
VirtWidth = 1200; 
VirtHeight = 700; 

--player stats 
paddleSpeed = 200; 
player1Score = 0; 
player2Score = 0; 
servingPlayer = 1; 
--methods
function love.load()

love.graphics.setDefaultFilter('nearest', 'nearest')

love.window.setTitle('Pong')

--random seed , os time, updated everytime game is started 
math.randomseed(os.time())

--paddle font
smallfnt = love.graphics.newFont("font.ttf", 25)
largefnt = love.graphics.newFont("font.ttf", 70)
--score font 
scoreFnt = love.graphics.newFont("font.ttf", 50)

love.graphics.setFont(smallfnt)


push:setupScreen(WindowWidth, WindowHeight, VirtWidth, VirtHeight, { 

	fullscreen = false, 
	resizable = true,
	vsync = true,
})

player1Y = Paddle(10, 30, 5, 50); 
player2Y = Paddle(VirtWidth - 10, VirtHeight - 30, 5, 50)

--ball stats 
 ball = Ball(VirtWidth / 2 -2, VirtHeight/ 2 - 2, 10, 10)

gameState = 'start'

end

function love.resize(w, h)
push:resize(w,h)
end

--movement 
--update function 
function love.update(dt)

if gameState == 'serve' then 
	     ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
        elseif gameState == 'play' then
--reverse dx
if ball:collides(player1Y) then 
ball.dx = -ball.dx * 1.03
ball.x = player1Y.x + 5 -- +5 is the width of the paddle 
if ball.dy < 0 then 
	ball.dy = -math.random(10, 150)
else 
	ball.dy = math.random(10, 150)
	end
end


--player2 
if ball:collides(player2Y) then 
	ball.dx = -ball.dx * 1.03
	ball.x  = player2Y.x - 4

	if ball.dy < 0 then 
		ball.dy = -math.random(10, 150)
	else
		ball.dy = math.random(10, 150)
	end 
end 

   if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

          if ball.y >= VirtHeight - 4 then
            ball.y = VirtHeight - 4
            ball.dy = -ball.dy
        end

    if ball.x < 0 then 
    	servingPlayer = 1
    	player2Score = player2Score + 1 
    	if player2Score == 10 then 
    		winningPlayer = 2
    		gameState = 'done'
    		else
    			gameState = 'serve'
    			ball:reset()
    		end
    	end

    if ball.x > VirtWidth then 
    	servingPlayer = 2
    	player1Score = player1Score + 1 

    	if player1Score == 10 then 
    		winningPlayer = 1 
    		gameState = 'done'
    	else 
    		gameState = 'serve'
    		ball:reset()
    	end
    end 
end

	--[[if love.keyboard.isDown('w') then 
		player1Y.dy = -paddleSpeed --moves paddle up 
	elseif love.keyboard.isDown('s') then 
		player1Y.dy = paddleSpeed
	else
		player1Y.dy = 0 
	end]]

    --AI for p1 
	if player1Y.y + 4 < ball.y then 
		player1Y.dy = paddleSpeed
	elseif player1Y.y + 4 > ball.y then 
		player1Y.dy = -paddleSpeed
	else
		player1Y.dy = 0 
	end

     --AI for player 2 
   --[[ if player2Y.y + 4 < ball.y then 
    	player1Y.dy = paddleSpeed 
    elseif player1Y.y + 4 > ball.y then 
    	player1Y.dy = -paddleSpeed
    else 
    	player1Y.dy = 0
    end ]]

	if love.keyboard.isDown('up') then 
		player2Y.dy = -paddleSpeed
	elseif love.keyboard.isDown('down') then 
		player2Y.dy = paddleSpeed		else
			player2Y.dy = 0
	end
	--update ball movement only if in play state 
if gameState == 'play' then 
	ball:update(dt)
end

player1Y:update(dt)
player2Y:update(dt)

end


function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	if key == 'enter' or key == 'return' then 
		if gameState == 'start' then 
			gameState = 'serve'
		elseif gameState == 'serve' then 
			gameState = 'play'
		elseif gameState == 'done' then 
			gameState = 'serve'

			ball:reset()
			player1Score = 0; 
			player2Score = 0; 

			if winningPlayer == 1 then 
				servingPlayer = 2 
			else 
				servingPlayer = 1 
			end
		end
	end
end



function love.draw()

push:apply("start")

--fill screen with colour 
love.graphics.clear(0,0,0,255)

     love.graphics.setFont(smallfnt)

     displayScore()

     if gameState == 'start' then 
     	love.graphics.setFont(smallfnt)
	love.graphics.printf('Welcome, press enter to begin', 0, 5 , VirtWidth, 'center')
	love.graphics.printf('Press enter to begin', 0, 30 , VirtWidth, 'center')
elseif gameState == 'serve' then
	love.graphics.setFont(smallfnt)
	love.graphics.printf('Player '..tostring(servingPlayer).. " 's serve", 0, 10,VirtWidth, 'center')
	love.graphics.printf('Press Enter to serve!', 0, 30, VirtWidth, 'center')
	 elseif gameState == 'play' then
        -- no UI messages to display in play

    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(largefnt)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VirtWidth, 'center')
        love.graphics.setFont(smallfnt)
        love.graphics.printf('Press Enter to restart!', 0, 30, VirtHeight, 'center')
    end


	--display and update score 
	--[[love.graphics.setFont(scoreFnt)
	love.graphics.print(tostring(player1Score), VirtWidth/2 + 50 , VirtHeight)
	love.graphics.print(tostring(player2Score), VirtWidth/2 - 50, VirtHeight)]]

	--paddles and ball 
	player1Y:render()
	player2Y:render()
	ball:render()

    displayFps()

	push:apply("end")
end

function displayFps()
	love.graphics.setFont(smallfnt)
	love.graphics.setColor(0,255,0, 255)
	love.graphics.print('FPS: ' ..tostring(love.timer.getFPS(), 100, 100))

end

 function displayScore()
 	love.graphics.setFont(scoreFnt)
 	    love.graphics.print(tostring(player1Score), VirtWidth/ 2 - 50, 
        VirtHeight / 3)
    love.graphics.print(tostring(player2Score), VirtWidth / 2 + 30,
        VirtHeight/ 3)
end