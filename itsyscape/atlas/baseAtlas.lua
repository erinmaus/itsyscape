-- Copyright (c) 2021 EngineerSmith
-- Under the MIT license, see license suppiled with this file
local path = select(1, ...):match("(.-)[^%.]+$")
local util = require(path .. "util")

local lg = love.graphics

local baseAtlas = {
  _canvasSettings = {
    dpiscale = 1,
  },
  _maxCanvasSize = lg and (lg.getSystemLimits().texturesize - 1) or 2048,
}
baseAtlas.__index = baseAtlas

baseAtlas.new = function(padding, extrude, spacing)
  return setmetatable({
    padding = padding or 1,
    extrude = extrude or 0,
    spacing = spacing or 0,
    images = {},
    ids = {},
    quads = {},
    filterMin = "linear",
    filterMag = "linear",
    bakeAsPow2 = false,
    _pureImageMode = not lg, -- If this is true, no dependency to love.graphics is needed
    _dirty = false, -- Marked dirty if image is added or removed,
    _hardBake = false, -- Marked true if hardBake has been called, cannot use add, remove or bake once true
  }, baseAtlas)
end

baseAtlas._ensureCorrectImage = function(self, image)
  if self._pureImageMode then
    if image:typeOf("Texture") then
      error("Cannot convert Texture to ImageData")
    end
  else
    if image:typeOf("ImageData") then
      if lg then
        return lg.newImage(image)
      else
        error("Cannot convert ImageData to Image")
      end
    end
  end
  return image
end

baseAtlas.useImageData = function(self, mode)
  if (not mode) and (not lg) then
    error("love.graphics is required for useImageData(false)")
  end
  if next(self.images) then
    error("Cannot change image data mode if there's image in atlas")
  end
  self._pureImageMode = not not mode
  self._dirty = true
  return self
end

-- TA:add(img, "foo")
-- TA:add(img, 68513, true)
baseAtlas.add = function(self, image, id, bake, ...)
  if self._hardBake then
    error("Cannot add images to a texture atlas that has been hard baked")
  end
  local index = #self.images + 1
  local actualImage = self:_ensureCorrectImage(image)
  assert(type(id) ~= "nil", "Must give an id")
  self:remove(id)
  self.images[index] = {
    image = actualImage,
    id = id,
    index = index,
  }
  self.ids[id] = index

  self._dirty = true
  if bake then
    self:bake(...)
  end

  return self
end

baseAtlas.markDirty = function(self)
  self._dirty = true
end

-- TA:remove("foo", true)
-- TA:remove(68513)
baseAtlas.remove = function(self, id, bake, ...)
  if self._hardBake then
    error("Cannot remove images from a texture atlas that has been hard baked")
  end
  local index = self.ids[id]
  if index then
    table.remove(self.images, index)
    self.quads[id] = nil
    self.ids[id] = nil
    for i = 1, #self.images do
      self.images[i].index = i
      self.ids[self.images[i].id] = i
    end
    self._dirty = true
    if bake == true then
      self:bake(...)
    end
  end

  return self
end

baseAtlas.bake = function(self)
  error("Warning! Created atlas hasn't overriden bake function!")
  return self
end

baseAtlas.hardBake = function(self, ...)
  local _, data = self:bake(...)
  self.images = nil
  self.ids = nil
  self._hardBake = true
  return self, data
end

-- returns position on texture atlas, x,y, w,h
baseAtlas.getViewport = function(self, id)
  local quad = self.quads[id]
  if quad then
    if self._pureImageMode then
      return quad[1], quad[2], quad[3], quad[4]
    else
      return quad:getViewport()
    end
  end
  error("Warning! Quad hasn't been baked for id: " .. tostring(id))
end

baseAtlas.setFilter = function(self, min, mag)
  if self._pureImageMode then
    error("Warning! This function is unsupported within current image data mode!")
  end
  self.filterMin = min or "linear"
  self.filterMag = mag or self.filterMin
  if self.image then
    self.image:setFilter(self.filterMin, self.filterMag)
  end
  self._dirty = true
  return self
end

baseAtlas.setBakeAsPow2 = function(self, bakeAsPow2)
  self.bakeAsPow2 = bakeAsPow2 or false
  self._dirty = true
  return self
end

baseAtlas.setPadding = function(self, padding)
  self.padding = padding or 1
  self._dirty = true
  return self
end

baseAtlas.setExtrude = function(self, extrude)
  self.extrude = extrude or 0
  self._dirty = true
  return self
end

baseAtlas.setSpacing = function(self, spacing)
  self.spacing = spacing or 0
  self._dirty = true
  return self
end

baseAtlas.setMaxSize = function(self, width, height)
  self.maxWidth = width or baseAtlas._maxCanvasSize
  self.maxHeight = height or baseAtlas._maxCanvasSize
  self._dirty = true
  return self
end

baseAtlas.draw = function(self, id, ...)
  if self._pureImageMode then
    error("Warning! This function is unsupported within current image data mode!")
  end
  lg.draw(self.image, self.quads[id], ...)
end

baseAtlas.getDrawFuncForID = function(self, id)
  if self._pureImageMode then
    error("Warning! This function is unsupported within current image data mode!")
  end
  return function(...)
    lg.draw(self.image, self.quads[id], ...)
  end
end

return baseAtlas
