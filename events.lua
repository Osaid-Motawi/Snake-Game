local Events = {}
local listeners = {}

function Events:subscribe(event, callback)
    if not listeners[event] then listeners[event] = {} end
    table.insert(listeners[event], callback)
end

function Events:emit(event, data)
    for _, callback in ipairs(listeners[event] or {}) do
        callback(data)
    end
end

return Events
