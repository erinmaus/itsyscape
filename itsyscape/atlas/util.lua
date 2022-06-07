-- Copyright (c) 2021 EngineerSmith
-- Under the MIT license, see license suppiled with this file

local util = {}

util.getImageDimensions = function(image)
  if image:typeOf("Texture") then
    return image:getPixelDimensions()
  else
    return image:getDimensions()
  end
end


-- TODO: Remove closure usage
local fillImageData = function(imageData, x, y, w, h, r, g, b, a)
  imageData:mapPixel(function()
    return r, g, b, a
  end, x, y, w, h)
end

local extrudeImageData = function(dest, src, n, x, y, dx, dy, sx, sy, sw, sh)
  for i = 1, n do
    dest:paste(src, x + i * dx, y + i * dy, sx, sy, sw, sh)
  end
end

util.extrudeWithFill = function(dest, src, n, x, y)
  local iw, ih = src:getDimensions()
  extrudeImageData(dest, src, n, x, y, 0, -1, 0, 0, iw, 1) -- top
  extrudeImageData(dest, src, n, x, y, -1, 0, 0, 0, 1, ih) -- left
  extrudeImageData(dest, src, n, x, y + ih - 1, 0, 1, 0, ih - 1, iw, 1) -- bottom
  extrudeImageData(dest, src, n, x + iw - 1, y, 1, 0, iw - 1, 0, 1, ih) -- right
  fillImageData(dest, x - n, y - n, n, n, src:getPixel(0, 0)) -- top-left
  fillImageData(dest, x + iw, y - n, n, n, src:getPixel(iw - 1, 0)) -- top-right
  fillImageData(dest, x + iw, y + ih, n, n, src:getPixel(iw - 1, ih - 1)) -- bottom-right
  fillImageData(dest, x - n, y + ih, n, n, src:getPixel(0, ih - 1)) -- bottom-left
end

return util
