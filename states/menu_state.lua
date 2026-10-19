local UI = require("ui")
local HighScore = require("love_highscore")
local Menu = {}

function Menu:enter()
    self.best = HighScore:load()
end

function Menu:update(dt)
end

function Menu:draw()
    local c = UI.colors
    local t = UI.clock()

    UI.text("S / SNAKE LAB", 65, 34, 340, "left", "body", c.green)
    UI.text("LUA  /  LOVE2D", 560, 36, 195, "right", "small", c.muted)

    UI.card(66, 91, 688, 605, 30)

    UI.text("THE CLASSIC, REIMAGINED", 120, 145, 580, "center", "small", c.green)
    UI.text("SNAKE", 110, 176, 600, "center", "hero", c.white)
    UI.text("Move. Eat. Grow. Repeat.", 110, 280, 600, "center", "body", c.muted)

    UI.glow(410, 377, 132, c.green)

    local x = 292
    local y = 363 + math.sin(t * 2) * 3
    love.graphics.setColor(c.greenDark)
    love.graphics.setLineWidth(25)
    love.graphics.setLineStyle("smooth")
    love.graphics.line(x, y + 30, x + 48, y + 30, x + 48, y - 18, x + 102, y - 18)
    love.graphics.setColor(c.green)
    love.graphics.circle("fill", x + 102, y - 18, 15)
    love.graphics.setColor(c.background)
    love.graphics.circle("fill", x + 107, y - 23, 3)
    love.graphics.setLineWidth(1)

    UI.button(288, 470, 244, 60, "START GAME  >")
    UI.text("PRESS ENTER OR CLICK TO PLAY", 175, 550, 470, "center", "small", c.muted)

    love.graphics.setColor(c.border)
    love.graphics.line(145, 595, 675, 595)

    UI.text("ARROWS / WASD  TO MOVE", 120, 615, 580, "center", "small", c.white)
    UI.text("BEST SCORE  " .. tostring(self.best or 0), 120, 645, 580, "center", "small", c.green)
    UI.text("ESC TO EXIT", 0, 718, 820, "center", "small", c.muted)
end

return Menu
