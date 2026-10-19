local UI = {}
local fonts = {}
local time = 0

UI.colors = {
    background = {0.035, 0.052, 0.080},
    panel = {0.075, 0.105, 0.145},
    panel2 = {0.095, 0.132, 0.175},
    border = {0.19, 0.26, 0.32},
    white = {0.95, 0.98, 0.99},
    muted = {0.53, 0.63, 0.70},
    green = {0.40, 0.96, 0.70},
    greenDark = {0.13, 0.55, 0.40},
    red = {1.00, 0.34, 0.44}
}

function UI.load()
    fonts.small = love.graphics.newFont(13)
    fonts.body = love.graphics.newFont(17)
    fonts.medium = love.graphics.newFont(22)
    fonts.bold = love.graphics.newFont(32)
    fonts.hero = love.graphics.newFont(76)
end

function UI.font(name)
    love.graphics.setFont(fonts[name] or fonts.body)
end

function UI.update(dt)
    time = time + dt
end

function UI.clock()
    return time
end

function UI.inRect(mx, my, x, y, w, h)
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function UI.text(str, x, y, width, align, font, color)
    UI.font(font or "body")
    love.graphics.setColor(color or UI.colors.white)
    love.graphics.printf(str, x, y, width, align or "left")
end

function UI.card(x, y, w, h, radius, color)
    love.graphics.setColor(0, 0, 0, 0.24)
    love.graphics.rectangle("fill", x, y + 9, w, h, radius, radius)
    love.graphics.setColor(color or UI.colors.panel)
    love.graphics.rectangle("fill", x, y, w, h, radius, radius)
    love.graphics.setColor(UI.colors.border)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x + 0.5, y + 0.5, w - 1, h - 1, radius, radius)
end

function UI.button(x, y, w, h, label)
    local mx, my = love.mouse.getPosition()
    local hover = UI.inRect(mx, my, x, y, w, h)
    love.graphics.setColor(0.04, 0.17, 0.14, 0.5)
    love.graphics.rectangle("fill", x, y + 7, w, h, 17, 17)
    love.graphics.setColor(hover and {0.52, 1, 0.77} or UI.colors.green)
    love.graphics.rectangle("fill", x, y, w, h, 17, 17)
    UI.text(label, x, y + (h - 23) / 2, w, "center", "medium", {0.03, 0.17, 0.13})
end

function UI.glow(x, y, r, color)
    for i = 8, 1, -1 do
        local k = i / 8
        love.graphics.setColor(color[1], color[2], color[3], 0.009 * (9 - i))
        love.graphics.circle("fill", x, y, r * k)
    end
end

function UI.background()
    love.graphics.setBackgroundColor(UI.colors.background)
    love.graphics.clear(UI.colors.background)
    UI.glow(130 + math.sin(time * 0.45) * 30, 180, 280, UI.colors.green)
    UI.glow(680, 600 + math.cos(time * 0.35) * 28, 340, {0.22, 0.46, 0.84})
    love.graphics.setColor(1, 1, 1, 0.018)
    for x = 20, 820, 40 do
        for y = 20, 760, 40 do
            love.graphics.circle("fill", x, y, 1)
        end
    end
end

return UI
