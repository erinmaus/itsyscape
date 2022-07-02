-- Copyright (c) 2021 EngineerSmith
-- Under the MIT license, see license suppiled with this file

local path = select(1, ...):match("(.-)[^%.]+$")
local baseAtlas = require(path .. "baseAtlas")
local util = require(path .. "util")
local fixedSizeTA = setmetatable({}, baseAtlas)
fixedSizeTA.__index = fixedSizeTA

local lg = love.graphics
local newImageData = love.image.newImageData
local ceil, floor, sqrt = math.ceil, math.sqrt, math.floor

fixedSizeTA.new = function(width, height, padding, extrude, spacing)
  local self = setmetatable(baseAtlas.new(padding, extrude, spacing), fixedSizeTA)
  self.width = width or error("Width required")
  self.height = height or width
  return self
end

fixedSizeTA.add = function(self, image, id, bake)
  local width, height = util.getImageDimensions(image)
  if width ~= self.width or height ~= self.height then
    error("Given image cannot fit into a fixed sized texture atlas\n Gave: W:".. tostring(width) .. " H:" ..tostring(height) .. ", Expected: W:"..self.width.." H:"..self.height)
  end
  return baseAtlas.add(self, image, id, bake)
end

fixedSizeTA.bake = function(self)
  if self._dirty and not self._hardBake then
    local columns = ceil(sqrt(self.imagesSize))
    local width, height = self.width, self.height
    local widthPadded = width + self.spacing + self.extrude * 2 + self.padding * 2
    local heightPadded = height + self.spacing + self.extrude * 2 + self.padding * 2
    local maxIndex = self.imagesSize
    local data
    
    local widthCanvas = columns * widthPadded
    if widthCanvas > (self.maxWidth or self._maxCanvasSize) then
      error("Required width for atlas cannot be created due to reaching limits. Required: "..widthCanvas..", width limit: "..(self.maxWidth or self._maxCanvasSize))
    end
    
    local rows = ceil(self.imagesSize / columns)
    local heightCanvas = rows * heightPadded
    if heightPadded > (self.maxHeight or self._maxCanvasSize) then
      error("Required height for atlas cannot be created due to reaching limits. Required: "..heightCanvas..", height limit: "..(self.maxHeight or self._maxCanvasSize))
    end
    
    widthCanvas, heightCanvas = widthCanvas - self.spacing, heightCanvas - self.spacing
    if self.bakeAsPow2 then
      widthCanvas = math.pow(2, math.ceil(math.log(widthCanvas)/math.log(2)))
      heightCanvas = math.pow(2, math.ceil(math.log(heightCanvas)/math.log(2)))
    end
    
    if self._pureImageMode then
      data = newImageData(widthCanvas, heightCanvas, "rgba8")
      for x=0, columns-1 do
        for y=0, rows-1 do
          local index = (x*rows+y)+1
          if index > maxIndex then
            break
          end
          local x, y = x * widthPadded + self.padding + self.extrude, y * heightPadded + self.padding + self.extrude
          local image = self.images[index]
          data:paste(image.image, x, y, 0, 0, image.image:getDimensions())
          if self.extrude > 0 then
            util.extrudeWithFill(data, image.image, self.extrude, x, y)
          end
          self.quads[image.id] = {x+self.extrude, y+self.extrude, width, height}
        end
      end
    else
      local extrudeQuad = lg.newQuad(-self.extrude, -self.extrude, width+self.extrude*2, height+self.extrude*2, self.width, self.height)
      local canvas = lg.newCanvas(widthCanvas, heightCanvas, self._canvasSettings)
      lg.push("all")
      lg.setBlendMode("replace")
      lg.setCanvas(canvas)
      for x=0, columns-1 do
        for y=0, rows-1 do
          local index = (x*rows+y)+1
          if index > maxIndex then
            break
          end
          local x, y = x * widthPadded + self.padding, y * heightPadded + self.padding
          local image = self.images[index]
          lg.draw(image.image, extrudeQuad, x, y)
          self.quads[image.id] = lg.newQuad(x+self.extrude, y+self.extrude, width, height, widthCanvas, heightCanvas)
        end
      end
      lg.pop()
      data = canvas:newImageData()
      self.image = lg.newImage(data)
      self.image:setFilter(self.filterMin, self.filterMag)
    end

    self._dirty = false
    return self, data
  end

  return self
end

return fixedSizeTA
