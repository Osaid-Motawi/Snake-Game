local GameState = require("gamestate")
local Input = require("input")
local Events = require("events")
local UI = require("ui")

local manager = GameState:new()
local input = Input:new()

local function move(dx, dy)
    if manager.current == "playing" then
        manager.states.playing:changeDirection(dx, dy)
    end
end

input:bind("up", function() move(0, -1) end)
input:bind("w", function() move(0, -1) end)
input:bind("down", function() move(0, 1) end)
input:bind("s", function() move(0, 1) end)
input:bind("left", function() move(-1, 0) end)
input:bind("a", function() move(-1, 0) end)
input:bind("right", function() move(1, 0) end)
input:bind("d", function() move(1, 0) end)

input:bind("return", function()
    if manager.current == "menu" then
        manager:switch("playing")
    elseif manager.states.playing.game and manager.states.playing.game.gameOver then
        manager:switch("playing")
    end
end)

input:bind("space", function()
    if manager.current == "playing" then
        local game = manager.states.playing.game
        if game and game.gameOver then
            manager:switch("playing")
        else
            manager:switch("menu")
        end
    elseif manager.current == "menu" then
        manager:switch("playing")
    end
end)

input:bind("backspace", function()
    if manager.current == "playing" then
        manager:switch("menu")
    end
end)

input:bind("escape", function() love.event.quit() end)

Events:subscribe("food_eaten", function(data)
    print("Food eaten! Score:", data.score)
end)

Events:subscribe("game_over", function(data)
    print("Game Over! Final Score:", data.score)
end)

function love.load()
    love.filesystem.setIdentity("lua_snake_assignment")
    love.window.setMode(820, 760, {resizable = false, vsync = 1})
    love.window.setTitle("SNAKE / Modern Edition")
    UI.load()
end

function love.update(dt)
    UI.update(dt)
    manager:update(dt)
end

function love.draw()
    UI.background()
    manager:draw()
end

function love.keypressed(key)
    input:handleKey(key)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if manager.current == "menu" and UI.inRect(x, y, 288, 470, 244, 60) then
            manager:switch("playing")
        elseif manager.current == "playing" then
            local game = manager.states.playing.game
            if game and game.gameOver and UI.inRect(x, y, 298, 472, 224, 54) then
                manager:switch("playing")
            end
        end
    end
end
