local SnakeGame = require("snake_game")
local Playing = {}

function Playing:enter()
    self.game = SnakeGame:new()
end

function Playing:update(dt)
    if self.game then self.game:update(dt) end
end

function Playing:draw()
    if self.game then self.game:draw() end
end

function Playing:changeDirection(dx, dy)
    if self.game then self.game:changeDirection(dx, dy) end
end

return Playing
