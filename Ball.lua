Ball = Class{}

--constructor
--self... set its' x (the ball's x) to x/y etc 
function Ball:init(x,y, width, height)
	self.x = x
	self.y = y
	self.width = width 
	self.height = height 

--keep strack of balls velocity 
	self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function Ball:collides(paddle)

	--if the balls left is greater than the p1 paddle right edge there is no collision or 
	--if p2 paddle is bigger than the balls x+ width(from left) no col 

   if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
       
        --if bottom edge is higher than top edge of other 
       if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

        return true
end

--ball in middle of screen 
function Ball:reset()
	self.x = VirtWidth /2-2 
	self.y = VirtHeight /2-2 
	 self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function Ball:update(dt)
self.x = self.x + self.dx* dt
self.y = self.y + self.dy * dt 
end

function Ball:render()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end 