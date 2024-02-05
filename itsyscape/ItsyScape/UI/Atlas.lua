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
Atlas.STALE_LIMIT_SECONDS = 30

Atlas.Image = Class()
function Atlas.Image:new(image)
	self.image = image
	self.x = 0
	self.y = 0
	self.time = love.timer.getTime()
	self.layer = 0
end

function Atlas.Image:getWidth()
	return self.image:getWidth()
end

function Atlas.Image:getHeight()
	return self.image:getHeight()
end

function Atlas.Image:getTexture()
	return self.image
end

function Atlas.Image:setLayer(value)
	self.layer = value
end

function Atlas.Image:getLayer()
	return self.layer
end

function Atlas.Image:update()
	self.time = love.timer.getTime()
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

	self.cells = {}
	for i = 1, cellWidth do
		for j = 1, cellHeight do
			self.cells[j * self.cellWidth + i] = false
		end
	end

	self.rectangles = {
		{
			i = 1,
			j = 1,
			width = self.cellWidth,
			height = self.cellHeight
		}
	}

	self.pendingUpdates = {}
end

function Atlas.Layer:getCellByPosition(x, y)
	local i = math.floor(x / sell.cellSize) + 1
	local j = math.floor(y / sell.cellSize) + 1

	return self:getCellByIndex(i, j)
end

function Atlas.Layer:getCellByIndex(i, j)
	return self.cells[j * self.cellWidth + i]
end

function Atlas.Layer:tryAdd(image)
	local width = math.ceil(image:getWidth() / self.cellSize)
	local height = math.ceil(image:getHeight() / self.cellSize)

	for index, rectangle in ipairs(self.rectangles) do
		if rectangle.width >= width and rectangle.height >= height and
		   (not rectangle.image or rectangle.image:stale())
		then
			if (rectangle.width == width or rectangle.height == height) and
				not (rectangle.width == width and rectangle.height == height)
			then
				-- Split into two if width or height are equal
				if rectangle.width == width then
					rectangle.height = height

					table.insert(self.rectangles, {
						i = rectangle.i,
						j = rectangle.j + height,
						width = width,
						height = rectangle.height - height
					})
				elseif rectangle.height == height then
					rectangle.width = width

					table.insert(self.rectangles, {
						i = rectangle.i + width,
						j = rectangle.j,
						width = rectangle.width - width,
						height = rectangle.height - height
					})
				end
			else
				local newRectangles = {
					{
						i = rectangle.i + width,
						j = rectangle.j,
						width = rectangle.width - width,
						height = height
					},
					{
						i = rectangle.i,
						j = rectangle.j + width,
						width = width,
						height = rectangle.height - height
					},
					{
						i = rectangle.i + width,
						j = rectangle.j + height,
						width = rectangle.width - width,
						height = rectangle.height - height
					}
				}

				-- Split this rectangle into three others.
				-- Try and find adjacent rectangles that can merge.
				for _, otherRectangle in ipairs(self.rectangles) do
					for newIndex, newRectangle in ipairs(newRectangles) do
						if newRectangle.i + newRectangle.width == otherRectangle.i and
						   newRectangle.height == otherRectangle.height and
						   (not otherRectangle.image or otherRectangle.image:stale())
						then
							otherRectangle.i = newRectangle.i
							otherRectangle.width = otherRectangle.width + newRectangle.width
							otherRectangle.image = false

							table.remove(newRectangles, newIndex)
							break
						end
					end
				end

				for _, newRectangle in ipairs(newRectangles) do
					table.insert(self.rectangles, newRectangle)
				end
			end

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

function Atlas:has(image)
	return self.handles[image] ~= nil
end

function Atlas:visit(image)
	if self:has(image) then
		self.handles[image]:update()
	end
end

function Atlas:add(image)
	if image:getWidth() >= self.width or image:getHeight() >= self.height then
		return false
	end

	if not self:has(image) then
		table.insert(self.images, image)
		local wrappedImage = Atlas.Image(image)
		self.handles[image] = wrappedImage

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

function Atlas:quad(image)
	if self:has(image) then
		return self.handles[image]:getQuad()
	end
end

function Atlas:layer(image)
	if self:has(image) then
		return self.handles[image]:getLayer()
	end
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

	love.graphics.pop()
end

return Atlas
