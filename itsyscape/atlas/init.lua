-- Copyright (c) 2021 EngineerSmith
-- Under the MIT license, see license suppiled with this file

local path = select(1, ...)
local textureAtlas = {
  newFixedSize = require(... .. ".fixedSize").new,
  newDynamicSize = require(... .. ".dynamicSize").new
}

return textureAtlas