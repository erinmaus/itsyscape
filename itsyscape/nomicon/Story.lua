local PATH = (...):gsub("%.[^%.]+$", "")

local container = require(PATH .. "impl.container")

--- @class nomicon.story
--- @field private _story table
--- @field private _currentOutputStream table
--- @field private _stringBuilder table
--- @field private _isCurrentOutputStreamDirty boolean
--- @field private _currentText string
local story = {}
story.__mt = { __index = story }

--- Creates a new story.
---
--- @param table ink Pre-parsed Ink JSON.
--- @return nomicon.story
function story.new(ink)
    local result = setmetatable({
        _story = ink,
        _currentOutputStream = {},
        _stringBuilder = {},
        _currentText = "",
        _currentTags = {},
        _isCurrentOutputStreamDirty = false,
    }, story)
    result:reset()

    return result
end

function story:reset()
    self._currentOutputStream = table_clear(self._currentOutputStream or {})
    self._stringBuilder = table_clear(self._stringBuilder or {})
    self._currentText = ""
    self._isCurrentOutputStreamDirty = false

    local stack = { self._story.root }
    while stack do
        local current = stack[#current]
        table.remove(stack, #stack)
    end
end

function story:parse()

end

--- Gets the current text of the story.
--- @return string
function story:get_current_text()
    if self._isCurrentOutputStreamDirty then
        self._currentText = table.concat(self._currentOutputStream, "")
    end
end

local s = story.new()

return setmetatable(story, {
    __call = function(_, ...)
        return story.new(...)
    end
})
