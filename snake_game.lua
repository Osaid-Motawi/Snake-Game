local Vector2 = require("vector2")
local Entity = require("entity")
local Events = require("events")
local HighScore = require("love_highscore")
local UI = require("ui")

local SnakeGame = {}
SnakeGame.__index = SnakeGame

local GRID = 20
local CELL = 26
local X = 150
local Y = 160
local STEP_TIME = 0.12

function SnakeGame:new()
    local game = setmetatable({
        snake = {Vector2:new(10, 10), Vector2:new(9, 10), Vector2:new(8, 10)},
        direction = Vector2:new(1, 0),
        nextDirection = Vector2:new(1, 0),
        food = nil,
        score = 0,
        highScore = HighScore:load(),
        gameOver = false,
        won = false,
        timer = 0,
        turnLocked = false
    }, SnakeGame)

    game.entity = Entity:new()
    game.entity:addComponent("position", {x = 10, y = 10})
    game.entity:addComponent("movement", {dx = 1, dy = 0})
    game.entity:addComponent("renderer", {color = UI.colors.greenDark, size = CELL})
    game:spawnFood()
    return game
end

function SnakeGame:spawnFood()
    if #self.snake >= GRID * GRID then
        self.food = nil
        return
    end
    repeat
        self.food = Vector2:new(love.math.random(0, GRID - 1), love.math.random(0, GRID - 1))
        local occupied = false
        for _, part in ipairs(self.snake) do
            if part == self.food then
                occupied = true
                break
            end
        end
        if not occupied then return end
    until false
end

function SnakeGame:changeDirection(dx, dy)
    if self.gameOver or self.turnLocked then return end
    if math.abs(dx) + math.abs(dy) ~= 1 then return end
    if dx == -self.direction.x and dy == -self.direction.y then return end
    self.nextDirection = Vector2:new(dx, dy)
    self.turnLocked = true
end

function SnakeGame:updateHighScore()
    if self.score > self.highScore then
        self.highScore = self.score
        HighScore:save(self.highScore)
    end
end

function SnakeGame:finish(won)
    self.gameOver = true
    self.won = won or false
    Events:emit("game_over", {score = self.score})
end

function SnakeGame:moveSnake()
    self.direction = self.nextDirection
    self.turnLocked = false
    local head = self.snake[1] + self.direction

    if head.x < 0 or head.y < 0 or head.x >= GRID or head.y >= GRID then
        self:finish(false)
        return
    end

    local eating = head == self.food
    local limit = eating and #self.snake or #self.snake - 1
    for i = 1, limit do
        if head == self.snake[i] then
            self:finish(false)
            return
        end
    end

    table.insert(self.snake, 1, head)
    if eating then
        self.score = self.score + 1
        self:updateHighScore()
        Events:emit("food_eaten", {score = self.score})
        if #self.snake == GRID * GRID then
            self.food = nil
            self:finish(true)
        else
            self:spawnFood()
        end
    else
        table.remove(self.snake)
    end

    local position = self.entity:getComponent("position")
    position.x, position.y = head.x, head.y
    local movement = self.entity:getComponent("movement")
    movement.dx, movement.dy = self.direction.x, self.direction.y
end

function SnakeGame:update(dt)
    if self.gameOver then return end
    self.timer = self.timer + dt
    while self.timer >= STEP_TIME and not self.gameOver do
        self.timer = self.timer - STEP_TIME
        self:moveSnake()
    end
end

function SnakeGame:draw()
    local c = UI.colors
    UI.text("S / SNAKE LAB", 65, 28, 380, "left", "body", c.green)
    UI.text("BACKSPACE  MENU", 560, 32, 195, "right", "small", c.muted)

    UI.card(65, 71, 690, 635, 26)
    UI.text("SCORE", 102, 95, 190, "left", "small", c.muted)
    UI.text(tostring(self.score), 102, 114, 190, "left", "bold", c.white)
    UI.text("PERSONAL BEST", 538, 95, 180, "right", "small", c.muted)
    UI.text(tostring(self.highScore), 538, 114, 180, "right", "bold", c.green)

    love.graphics.setColor(c.background)
    love.graphics.rectangle("fill", X - 4, Y - 4, GRID * CELL + 8, GRID * CELL + 8, 20, 20)
    love.graphics.setColor(c.panel2)
    love.graphics.rectangle("fill", X, Y, GRID * CELL, GRID * CELL, 17, 17)

    love.graphics.setColor(0.48, 0.67, 0.68, 0.065)
    for n = 1, GRID - 1 do
        local d = n * CELL
        love.graphics.line(X + d, Y, X + d, Y + GRID * CELL)
        love.graphics.line(X, Y + d, X + GRID * CELL, Y + d)
    end

    if self.food then
        local fx = X + (self.food.x + 0.5) * CELL
        local fy = Y + (self.food.y + 0.5) * CELL
        UI.glow(fx, fy, 44, c.red)
        love.graphics.setColor(c.red)
        love.graphics.circle("fill", fx, fy, 9)
        love.graphics.setColor(1, 0.83, 0.83)
        love.graphics.circle("fill", fx - 3, fy - 3, 2.3)
    end

    local renderer = self.entity:getComponent("renderer")
    for i = #self.snake, 1, -1 do
        local part = self.snake[i]
        local px = X + part.x * CELL + CELL / 2
        local py = Y + part.y * CELL + CELL / 2
        if i == 1 then
            love.graphics.setColor(c.green)
        else
            love.graphics.setColor(renderer.color)
        end
        love.graphics.circle("fill", px, py, i == 1 and 11.5 or 10.5)
    end

    local head = self.snake[1]
    local hx = X + (head.x + 0.5) * CELL
    local hy = Y + (head.y + 0.5) * CELL
    love.graphics.setColor(c.background)
    if self.direction.x ~= 0 then
        local offset = self.direction.x * 4
        love.graphics.circle("fill", hx + offset, hy - 4, 2)
        love.graphics.circle("fill", hx + offset, hy + 4, 2)
    else
        local offset = self.direction.y * 4
        love.graphics.circle("fill", hx - 4, hy + offset, 2)
        love.graphics.circle("fill", hx + 4, hy + offset, 2)
    end

    UI.text("ARROWS / WASD TO MOVE", 100, 690, 620, "center", "small", c.muted)
    UI.text("SPACE TO MENU", 100, 724, 620, "center", "small", c.muted)

    if self.gameOver then
        love.graphics.setColor(0.025, 0.045, 0.066, 0.88)
        love.graphics.rectangle("fill", X, Y, GRID * CELL, GRID * CELL, 17, 17)
        UI.text(self.won and "YOU WIN!" or "GAME OVER", 160, 267, 500, "center", "bold", self.won and c.green or c.white)
        UI.text("FINAL SCORE", 160, 333, 500, "center", "small", c.muted)
        UI.text(tostring(self.score), 160, 356, 500, "center", "hero", c.green)
        UI.button(298, 472, 224, 54, "PLAY AGAIN")
        UI.text("ENTER / SPACE TO RESTART", 160, 549, 500, "center", "small", c.muted)
    end
end

return SnakeGame
