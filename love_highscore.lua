local HighScore = {}
local PATH = "highscore.txt"

function HighScore:save(score)
    local ok, err = love.filesystem.write(PATH, tostring(score))
    if not ok then print("Save failed:", err) end
    return ok
end

function HighScore:load()
    local content = love.filesystem.read(PATH)
    return tonumber(content) or 0
end

return HighScore
