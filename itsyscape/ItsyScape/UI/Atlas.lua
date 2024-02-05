--------------------------------------------------------------------------------
-- ItsyScape/UI/Atlas.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Atlas = Class()
Atlas.STALE_LIMIT_SECONDS = 5

Atlas.Image = Class()
function Atlas.Image:new(texture)
	self.texture = texture
	self.x = 0
	self.y = 0
	self.time = love.timer.getTime()
	self.layer = 0
	self.key = false
end

function Atlas.Image:getWidth()
	return self.texture:getWidth()
end

function Atlas.Image:getHeight()
	return self.texture:getHeight()
end

function Atlas.Image:getTexture()
	return self.texture
end

function Atlas.Image:setLayer(value)
	self.layer = value
end

function Atlas.Image:getLayer()
	return self.layer
end

function Atlas.Image:replace(texture)
	self.texture = texture
end

function Atlas.Image:update()
	self.time = love.timer.getTime()
end

function Atlas.Image:reset(key)
	if self.key ~= key then
		self.key = key

		return true
	end

	return false
end

function Atlas.Image:stale()
	local currentTime = love.timer.getTime()
	return currentTime > self.time + Atlas.STALE_LIMIT_SECONDS
end

function Atlas.Image:setQuad(quad)
	self.quad = quad
end

function Atlas.Image:getQuad()
	return self.quad
end

Atlas.Layer = Class()
function Atlas.Layer:new(cellWidth, cellHeight, cellSize)
	self.images = {}

	self.cellWidth = cellWidth
	self.cellHeight = cellHeight
	self.cellSize = cellSize
	self.pendingClean = false

	self.rectangles = {
		{
			i = 0,
			j = 0,
			width = self.cellWidth,
			height = self.cellHeight
		}
	}

	self.pendingUpdates = {}
end

local function _tryMerge(otherRectangle, newRectangle)
	if otherRectangle.image and not otherRectangle.image:stale() then
		return false
	end

	if newRectangle.image and not newRectangle.image:stale() then
		return false
	end

	if newRectangle.i + newRectangle.width == otherRectangle.i and
	   newRectangle.j == otherRectangle.j and
	   newRectangle.height == otherRectangle.height
	then
		otherRectangle.i = newRectangle.i
		otherRectangle.width = otherRectangle.width + newRectangle.width
		otherRectangle.image = nil
		
		return true
	elseif newRectangle.i == otherRectangle.i and
	       newRectangle.j + newRectangle.height == otherRectangle.j and
	       newRectangle.width == otherRectangle.width
	then
		otherRectangle.j = newRectangle.j
		otherRectangle.height = otherRectangle.height + newRectangle.height
		otherRectangle.image = nil

		return true
	end

	return false
end

function Atlas.Layer:tryAdd(image)
	local width = math.ceil(image:getWidth() / self.cellSize)
	local height = math.ceil(image:getHeight() / self.cellSize)

	self:clean()

	for _, rectangle in ipairs(self.rectangles) do
		if rectangle.width >= width and rectangle.height >= height and
		   (not rectangle.image or rectangle.image:stale())
		then
			local newRectangles = {
				{
					i = rectangle.i + width,
					j = rectangle.j,
					width = rectangle.width - width,
					height = height
				},
				{
					i = rectangle.i,
					j = rectangle.j + height,
					width = rectangle.width,
					height = rectangle.height - height
				}
			}

			for i = #newRectangles, 1, -1 do
				if newRectangles[i].width == 0 or newRectangles[i].height == 0 then
					table.remove(newRectangles, i)
				end
			end

			-- Split this rectangle into two others.
			-- Try and find adjacent rectangles that can merge.
			for _, otherRectangle in ipairs(self.rectangles) do
				for newIndex, newRectangle in ipairs(newRectangles) do
					if _tryMerge(otherRectangle, newRectangle) then
						table.remove(newRectangles, newIndex)
						break
					end
				end
			end

			for _, newRectangle in ipairs(newRectangles) do
				table.insert(self.rectangles, newRectangle)
			end

			rectangle.width = width
			rectangle.height = height
			rectangle.image = image

			local quad = love.graphics.newQuad(
				rectangle.i * self.cellSize,
				rectangle.j * self.cellSize,
				image:getWidth(),
				image:getHeight(),
				self.cellSize * self.cellWidth,
				self.cellSize * self.cellHeight)
			image:setQuad(quad)
			table.insert(self.pendingUpdates, rectangle)

			return true
		end
	end

	return false
end

function Atlas.Layer:clean()
	if not self.pendingClean then
		return
	end

	local didMerge = true
	while didMerge do
		didMerge = false

		for _, a in ipairs(self.rectangles) do
			for index, b in ipairs(self.rectangles) do
				if a ~= b and _tryMerge(a, b) then
					didMerge = true
					table.remove(self.rectangles, index)
					break
				end
			end

			if didMerge then
				break
			end
		end
	end

	self.pendingClean = false
end

function Atlas.Layer:remove(image)
	self.pendingClean = true
end

function Atlas.Layer:replace(image)
	for _, rectangle in ipairs(self.rectangles) do
		if rectangle.image == image then
			table.insert(self.pendingUpdates, rectangle)
			break
		end
	end
end

function Atlas.Layer:dirty()
	table.clear(self.pendingUpdates)
	for _, rectangle in ipairs(self.rectangles) do
		if rectangle.image and not rectangle.image:stale() then
			table.insert(self.pendingUpdates, rectangle)
		end
	end
end

function Atlas.Layer:getIsDirty()
	return #self.pendingUpdates >= 1
end

function Atlas.Layer:update()
	for _, rectangle in ipairs(self.pendingUpdates) do
		love.graphics.draw(rectangle.image:getTexture(), rectangle.i * self.cellSize, rectangle.j * self.cellSize)
	end

	table.clear(self.pendingUpdates)
end

function Atlas:new(width, height, cellSize)
	self.images = {}
	self.handles = {}
	self.width = width
	self.height = height
	self.cellWidth = math.floor(self.width / cellSize)
	self.cellHeight = math.floor(self.height / cellSize)
	self.cellSize = cellSize
	self.layers = {}
end

function Atlas:getWidth()
	return self.width
end

function Atlas:getHeight()
	return self.height
end

function Atlas:getCellWidth()
	return self.cellWidth
end

function Atlas:getCellHeight()
	return self.cellHeight
end

function Atlas:getCellSize()
	return self.cellSize
end

function Atlas:has(handle)
	return self.handles[handle] ~= nil
end

function Atlas:visit(handle)
	if self:has(handle) then
		self.handles[handle]:update()
	end
end

function Atlas:add(handle, image, key)
	image = image or handle

	if image:getWidth() >= self.width or image:getHeight() >= self.height then
		return false
	end

	if not self:has(handle) then
		table.insert(self.images, handle)
		local wrappedImage = Atlas.Image(image)
		self.handles[handle] = wrappedImage

		if key then
			wrappedImage:reset(key)
		end

		for index, layer in ipairs(self.layers) do
			if layer:tryAdd(wrappedImage) then
				wrappedImage:setLayer(index)
				return true
			end
		end

		local layer = Atlas.Layer(self.cellWidth, self.cellHeight, self.cellSize)
		if layer:tryAdd(wrappedImage) then
			table.insert(self.layers, layer)
			wrappedImage:setLayer(#self.layers)

			return true
		end

		return false
	end

	return true
end

function Atlas:reset(handle, key)
	if self:has(handle) then
		local handle = self.handles[handle]
		return handle:reset(key)
	end

	return false
end

function Atlas:replace(handle, image)
	if self:has(handle) then
		local wrappedImage = self.handles[handle]
		wrappedImage:replace(image)
		wrappedImage:update()

		local layer = wrappedImage:getLayer()
		self.layers[layer]:replace(wrappedImage)
	end
end

function Atlas:quad(handle)
	if self:has(handle) then
		return self.handles[handle]:getQuad()
	end
end

function Atlas:layer(handle)
	if self:has(handle) then
		return self.handles[handle]:getLayer()
	end
end

function Atlas:texture(handle)
	if self:has(handle) then
		return self.handles[handle]:getTexture()
	end

	return nil
end

function Atlas:dirty()
	for _, layer in ipairs(self.layers) do
		layer:dirty()
	end
end

function Atlas:getTexture()
	return self.canvas
end

function Atlas:update()
	for i = #self.images, 1, -1 do
		local handle = self.images[i]

		local image = self.handles[handle]
		if image:stale() then
			self.layers[image:getLayer()]:remove(image)

			table.remove(self.images, i)
			self.handles[handle] = nil
		end
	end

	love.graphics.push("all")
	love.graphics.setBlendMode("replace")
	love.graphics.setCanvas(canvas)
	love.graphics.origin()
	love.graphics.setScissor()
	love.graphics.setColor(1, 1, 1, 1)

	if (not self.canvas or #self.layers > self.canvas:getLayerCount()) and #self.layers >= 1 then
		self.canvas = love.graphics.newCanvas(self.width, self.height, #self.layers)

		for index, layer in ipairs(self.layers) do
			love.graphics.setCanvas(self.canvas, index)

			layer:dirty()
			layer:update()
		end

	else
		for index, layer in ipairs(self.layers) do
			if layer:getIsDirty() then
				love.graphics.setCanvas(self.canvas, index)
				layer:update()
			end
		end
	end

	love.graphics.setCanvas()
	love.graphics.pop()
end

return Atlas
