local GameState = {}
GameState.__index = GameState

function GameState:new()
    return setmetatable({
        current = "menu",
        states = {
            menu = require("states.menu_state"),
            playing = require("states.game_state")
        }
    }, GameState)
end

function GameState:switch(name)
    local state = self.states[name]
    if not state then return end
    self.current = name
    if state.enter then state:enter() end
end

function GameState:update(dt)
    self.states[self.current]:update(dt)
end

function GameState:draw()
    self.states[self.current]:draw()
end

return GameState
