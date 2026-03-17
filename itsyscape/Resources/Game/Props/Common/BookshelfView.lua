--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/BookshelfView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Palette = require "ItsyScape.Game.Palette"
local Building = require "ItsyScape.Graphics.Building"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Bookshelf = Class(SimpleStaticView)

Bookshelf.CONFIGURATION_LEFT_RIGHT = "left-right"
Bookshelf.CONFIGURATION_BOTTOM_TOP = "bottom-top"
Bookshelf.CONFIGURATION_EMPTY = "empty"

Bookshelf.MIN_NUM_BOOKS = 1
Bookshelf.MAX_NUM_BOOKS = 4

Bookshelf.MIN_BOOK_SCALE  = 0.4
Bookshelf.MAX_BOOK_SCALE  = 1.1
Bookshelf.BOOK_SCALE_STEP = 0.1

Bookshelf.MIN_BOOK_TILT_LEFT_RIGHT = -math.pi / 16
Bookshelf.MAX_BOOK_TILT_LEFT_RIGHT = math.pi / 16
Bookshelf.MIN_BOOK_TILT_BOTTOM_TOP = -math.pi / 8
Bookshelf.MAX_BOOK_TILT_BOTTOM_TOP = math.pi / 8
Bookshelf.TILT_THRESHOLD           = 0.7
Bookshelf.BOOK_TILT_SQUISH         = 0.8

Bookshelf.MIN_EMPTY_WIDTH = 0.1
Bookshelf.MAX_EMPTY_WIDTH = 0.2

Bookshelf.WEIGHTED_CONFIGURATIONS = {
	Bookshelf.CONFIGURATION_LEFT_RIGHT,
	Bookshelf.CONFIGURATION_LEFT_RIGHT,
	Bookshelf.CONFIGURATION_LEFT_RIGHT,
	Bookshelf.CONFIGURATION_BOTTOM_TOP,
	Bookshelf.CONFIGURATION_BOTTOM_TOP,
	Bookshelf.CONFIGURATION_EMPTY,
}

Bookshelf.SHELF_CENTERS = {
	Vector(0, 3.475, -0.05):keep(),
	Vector(0, 2.5, -0.05):keep(),
	Vector(0, 1.5, -0.05):keep(),
	Vector(0, 0.525, -0.05):keep()
}

Bookshelf.SHELF_SIZES = {
	Vector(1.7, 0.5, 0.85):keep(),
	Vector(1.7, 0.5, 0.85):keep(),
	Vector(1.7, 0.5, 0.85):keep(),
	Vector(1.7, 0.5, 0.85):keep()
}

Bookshelf.COLORS = {
	["book"] = {
		Palette.PRIMARY_RED,
		Palette.PRIMARY_GREEN,
		Palette.PRIMARY_BLUE,
		Palette.PRIMARY_YELLOW,
		Palette.PRIMARY_PURPLE,
		Palette.PRIMARY_PINK,
		Palette.PRIMARY_BROWN,
		Palette.PRIMARY_WHITE,
		Palette.PRIMARY_GREY,
		Palette.PRIMARY_BLACK,
	},

	["book.pages"] = {
		Color.fromHexString("ffffff")
	},

	["book.cover"] = {
		Palette.PRIMARY_RED,
		Palette.PRIMARY_GREEN,
		Palette.PRIMARY_BLUE,
		Palette.PRIMARY_YELLOW,
		Palette.PRIMARY_PURPLE,
		Palette.PRIMARY_PINK,
		Palette.PRIMARY_BROWN,
		Palette.PRIMARY_WHITE,
		Palette.PRIMARY_GREY,
		Palette.PRIMARY_BLACK,
	}
}

Bookshelf.BOOK_SIZE = Vector(0.2, 0.7, 0.4)

Bookshelf.BOOK_DECORATION_TILE_SET = "Books1"

function Bookshelf:new(...)
	SimpleStaticView.new(self, ...)

	self.bookSceneNodes = {}
end

function Bookshelf:load()
	SimpleStaticView.load(self)

	self:_tryLoad()
end

function Bookshelf:_addBook(position, rotation, scale, rng, building, decoration)
	local groupIndex = rng:random(building:getNumDecorationGroups())
	local group = building:getDecorationGroupByIndex(groupIndex)

	for _, feature in group:iterate() do
		local colors = self.COLORS[feature:getID()] or { Color(1) }
		local color = colors[rng:random(#colors)]

		decoration:add(feature:getID(), position, rotation, scale, color, feature:getTexture() or 1, feature:getMaterial())
	end
end

function Bookshelf:_populateLeftRight(x, min, max, center, rng, building, decoration)
	local numBooks = rng:random(self.MIN_NUM_BOOKS, self.MAX_NUM_BOOKS)
	local halfBookSize = self.BOOK_SIZE / 2

	repeat
		numBooks = numBooks - 1

		local scale = math.lerp(self.MIN_BOOK_SCALE, self.MAX_BOOK_SCALE, rng:random())

		local angle
		local doTilt = rng:random() >= self.TILT_THRESHOLD
		if doTilt then
			angle = math.lerp(self.MIN_BOOK_TILT_LEFT_RIGHT, self.MAX_BOOK_TILT_LEFT_RIGHT, rng:random())
		else
			angle = 0
		end

		local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle)
		local scale = Vector(scale)

		local transform = MathCommon.makeTransform(
			Vector.ZERO,
			rotation,
			scale,
			Vector.ZERO)

		local bookMin, bookMax = Vector.transformBounds(-halfBookSize, halfBookSize, transform)
		if doTilt then
			bookMin.x = bookMin.x * self.BOOK_TILT_SQUISH
			bookMax.x = bookMax.x * self.BOOK_TILT_SQUISH
		end

		local nextX = x + (bookMax.x - bookMin.x)
		if nextX <= max.x then
			local position = Vector(
				x + (bookMax.x - bookMin.x) / 2,
				-(max.y - min.y) + (bookMax.y - bookMin.y) / 2,
				0)

			self:_addBook(position + center, rotation, scale, rng, building, decoration)
		end

		x = nextX
	until numBooks <= 0 or x >= max.x

	return x
end

function Bookshelf:_populateBottomTop(x, min, max, center, rng, building, decoration)
	local numBooks = rng:random(self.MIN_NUM_BOOKS, self.MAX_NUM_BOOKS)

	local baseRotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 2)
	local bookSize = baseRotation:transformVector(self.BOOK_SIZE)
	bookSize = Vector(math.abs(bookSize.x), math.abs(bookSize.y), math.abs(bookSize.z))

	local halfBookSize = bookSize / 2

	local remainingWidth = max.x - x
	local minWidth = bookSize.x * self.MIN_BOOK_SCALE
	local maxScale = remainingWidth / bookSize.x
	if minWidth > remainingWidth then
		return max.x
	end

	local minScale = self.MIN_BOOK_SCALE
	local maxScale = math.min(self.MAX_BOOK_SCALE, maxScale)
	local previousScale = self.MAX_BOOK_SCALE

	local y = 0
	local nextX = 0
	repeat
		numBooks = numBooks - 1

		local scale = math.lerp(self.MIN_BOOK_SCALE, self.MAX_BOOK_SCALE, rng:random())
		scale = math.min(previousScale, scale, maxScale)

		local angle
		if rng:random() >= self.TILT_THRESHOLD then
			angle = math.lerp(self.MIN_BOOK_TILT_BOTTOM_TOP, self.MAX_BOOK_TILT_BOTTOM_TOP, rng:random())
		else
			angle = 0
		end

		local r = Quaternion.fromAxisAngle(Vector.UNIT_Y, angle)
		local s = Vector(scale)

		local transform = MathCommon.makeTransform(
			Vector.ZERO,
			r,
			s,
			Vector.ZERO)

		local bookMin, bookMax = Vector.transformBounds(-halfBookSize, halfBookSize, transform)

		local nextY = y + (bookMax.y - bookMin.y)
		if nextY <= max.y then
			local position = Vector(
				x + (bookMax.x - bookMin.x) / 2,
				y + -(max.y - min.y) + (bookMax.y - bookMin.y) / 2,
				0)

			self:_addBook(position + center, (r * baseRotation):getNormal(), s, rng, building, decoration)
		end
		y = nextY

		minScale = math.max(minScale - self.BOOK_SCALE_STEP, self.BOOK_SCALE_STEP)
		maxScale = math.max(maxScale - self.BOOK_SCALE_STEP, self.BOOK_SCALE_STEP)
		previousScale = scale

		nextX = math.max(x + (bookMax.x - bookMin.x), nextX)
	until numBooks <= 0 or y >= max.y

	return nextX
end

function Bookshelf:_populateShelf(center, size, rng, building, decoration)
	local halfSize = size / 2
	local min, max = center - halfSize, center + halfSize

	local x = min.x
	repeat
		local configuration = self.WEIGHTED_CONFIGURATIONS[rng:random(#self.WEIGHTED_CONFIGURATIONS)]
		if configuration == self.CONFIGURATION_LEFT_RIGHT then
			x = self:_populateLeftRight(x, min, max, center, rng, building, decoration)
		elseif configuration == self.CONFIGURATION_BOTTOM_TOP then
			x = self:_populateBottomTop(x, min, max, center, rng, building, decoration)
		elseif configuration == self.CONFIGURATION_EMPTY then
			x = x + math.lerp(self.MIN_EMPTY_WIDTH, self.MAX_EMPTY_WIDTH, rng:random())
		end
	until x >= max.x
end

function Bookshelf:_load()
	local a, b = self:getProp():getTile()
	local position = self:getProp():getPosition()
	local rng = love.math.newRandomGenerator(a, b)

	local building = Building(string.format("Resources/Game/TileSets/%s/Building.lua", self.BOOK_DECORATION_TILE_SET))
	local decoration = Decoration()

	for i = 1, math.min(#self.SHELF_CENTERS, #self.SHELF_SIZES) do
		local center = self.SHELF_CENTERS[i]
		local size = self.SHELF_SIZES[i]
		self:_populateShelf(center, size, rng, building, decoration)
	end

	local baseMaterials = building:getMaterials()
	local decorationsByMaterial = {}
	for feature in decoration:iterate() do
		local material = feature:getMaterial()

		local g = decorationsByMaterial[material]
		if not g then
			g = Decoration()
			decorationsByMaterial[material] = g
		end

		g:push(feature)
	end

	for _, sceneNode in ipairs(self.bookSceneNodes) do
		sceneNode:setParent()
	end

	self.bookSceneNodes = {}
	local bookSceneNodes = self.bookSceneNodes

	self:getResources():queue(
		StaticMeshResource,
		string.format("Resources/Game/TileSets/%s/Layout.lstatic", self.BOOK_DECORATION_TILE_SET),
		function(mesh)
			for materialName, subDecoration in pairs(decorationsByMaterial) do
				if bookSceneNodes ~= self.bookSceneNodes then
					return
				end

				local sceneNode = DecorationSceneNode()
				sceneNode:fromDecoration(subDecoration, mesh:getResource())
				sceneNode:setParent(self:getRoot())

				local material = baseMaterials[materialName]
				if material then
					material:apply(sceneNode, self:getResources())
				end

				table.insert(self.bookSceneNodes, sceneNode)
			end
		end)
end

function Bookshelf:_tryLoad()
	local currentI, currentJ = self:getProp():getTile()
	if not (self.currentI == currentI and self.currentJ == currentJ) then
		self.currentI = currentI
		self.currentJ = currentJ
		self:_load()
	end
end

function Bookshelf:updateTransform()
	SimpleStaticView.updateTransform(self)
	self:_tryLoad()
end

return Bookshelf
