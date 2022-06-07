-- Copyright (c) 2021 EngineerSmith
-- Under the MIT license, see license suppiled with this file
local path = select(1, ...):match("(.-)[^%.]+$")
local util = require(path .. "util")
local baseAtlas = require(path .. "baseAtlas")
local dynamicSizeTA = setmetatable({}, baseAtlas)
dynamicSizeTA.__index = dynamicSizeTA

-- Custom algorithm, see the file for more information
local grid = require(path .. "packing")

local lg = love.graphics
local newImageData = love.image.newImageData
local sort = table.sort

dynamicSizeTA.new = function(padding, extrude, spacing)
  return setmetatable(baseAtlas.new(padding, extrude, spacing), dynamicSizeTA)
end

local area = function(a, b)
  local aW, aH = util.getImageDimensions(a.image)
  local bW, bH = util.getImageDimensions(b.image)
  return aW * aH > bW * bH
end

local height = function(a, b)
  local aH = select(2, util.getImageDimensions(a.image))
  local bH = select(2, util.getImageDimensions(b.image))
  return aH > bH
end

local width = function(a, b)
  local aW = util.getImageDimensions(a.image)
  local bW = util.getImageDimensions(b.image)
  return aW > bW
end

-- sortBy options: "height"(default), "area", "width", "none"
dynamicSizeTA.bake = function(self, sortBy)
  if self._dirty and not self._hardBake then
    local shallowCopy = {unpack(self.images)}

    if sortBy == "height" then
      sort(shallowCopy, height)
    elseif sortBy == "area" or sortBy == nil then
      sort(shallowCopy, area)
    elseif sortBy == "width" then
      sort(shallowCopy, width)
    end

    -- Calculate positions and size of canvas
    local grids = {
      grid.new(self.maxWidth or self._maxCanvasSize, self.maxHeight or self._maxCanvasSize)
    }

    for _, image in ipairs(shallowCopy) do
      local img = image.image
      local width, height = util.getImageDimensions(img)
      width = width + self.spacing + self.extrude * 2 + self.padding * 2
      height = height + self.spacing + self.extrude * 2 + self.padding * 2

      local success = false
      for i = 1, #grids do
        success = grids[i]:insert(width, height, image)
        if success then
          image.layer = i
          break
        end
      end

      if not success then
        local g = grid.new(self.maxWidth or self._maxCanvasSize, self.maxHeight or self._maxCanvasSize)
        g:insert(width, height, image)
        table.insert(grids, g)
        image.layer = #grids
      end
    end

    local maxWidth, maxHeight = self.maxWidth or self._maxCanvasSize, self.maxHeight or self._maxCanvasSize

    local images = {}
    if self._pureImageMode then
      if #grid > 1 then
        error("Warning! Can't build texture array atlas in pure image mode.")
      end

      local data = newImageData(maxWidth, maxHeight, "rgba8")
      grid[1]:draw(self.quads, maxWidth, maxHeight, self.extrude, self.padding, data)
      self.image = data
    else
      for i = 1, #grids do
        local canvas = lg.newCanvas(maxWidth, maxHeight, self._canvasSettings)
        lg.push("all")
        lg.setBlendMode("replace")
        lg.setCanvas(canvas)
        lg.origin()
        lg.setScissor()
        lg.setColor(1, 1, 1, 1)
        grids[i]:draw(self.quads, maxWidth, maxHeight, self.extrude, self.padding)
        lg.pop()
        table.insert(images, canvas:newImageData())
      end

      self.image = lg.newArrayImage(images)
      self.image:setFilter(self.filterMin, self.filterMag)
    end

    self._dirty = false
    return self, self.image
  end

  return self, self.image
end

return dynamicSizeTA
