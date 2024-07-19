--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Book.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Color = require "ItsyScape.Graphics.Color"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"

local Book = Class()

Book.PART_TYPE_BOOK  = "book"
Book.PART_TYPE_FRONT = "front"
Book.PART_TYPE_BACK  = "back"
Book.PART_TYPE_PAGE  = "pages"

Book.DEFAULT_SKELETON = "../Common/Book.lskel"

Book.DEFAULT_MODELS = {
	[Book.PART_TYPE_BOOK] = {
		{ model = "../Common/Book.lmesh", texture = "../Common/Book.png" }
	},

	[Book.PART_TYPE_FRONT] = {
		{ model = "../Common/Front.lmesh", texture = "../Common/Front.png", canvas = true }
	},

	[Book.PART_TYPE_BACK] = {
		{ model = "../Common/Back.lmesh", texture = "../Common/Back.png", canvas = true }
	},

	[Book.PART_TYPE_PAGE] = {
		{ model = "../Common/Page.lmesh", texture = "../Common/Page.png", canvas = true }
	}
}

Book.Part = Class()

function Book.Part:new(book, partType, config)
	self.book = book
	self.type = partType
	self.config = config or {}

	self.models = {}
	self.canvasModel = false
end

function Book.Part:getBook()
	return self.book
end

function Book.Part:getType()
	return self.type
end

function Book.Part:getResources()
	return self.book:getResources()
end

function Book.Part:getConfig()
	return self.config
end

function Book.Part:load()
	self:loadModels(self.config.models or {})
	self:loadAnimations(self.config.animations or {})
end

function Book.Part:_pullTextureCoordinates(model)
	local vertices = model.model:getResource():getVertices()
	local format = model.model:getResource():getFormat()

	local LOVE_VERTEX_FORMAT_COUNT_INDEX = 3
	local LOVE_VERTEX_FORMAT_NAME_INDEX = 1

	local textureCoordinateOffset = 1
	local textureCoordinateCount
	for index, attribute in ipairs(format) do
		if attribute[LOVE_VERTEX_FORMAT_NAME_INDEX] == "VertexTexture" then
			textureCoordinateCount = attribute[LOVE_VERTEX_FORMAT_COUNT_INDEX]
			break
		end

		textureCoordinateOffset = textureCoordinateOffset + attribute[LOVE_VERTEX_FORMAT_COUNT_INDEX]
	end

	if not textureCoordinateCount or #vertices == 0 then
		model.textureCoordinates = {
			left = 0,
			right = 1,
			top = 0,
			bottom = 1
		}

		return
	end

	local left, right = math.huge, -math.huge
	local top, bottom = math.huge, -math.huge

	for _, vertex in ipairs(vertices) do
		left = math.min(vertex[textureCoordinateOffset])
		right = math.max(vertex[textureCoordinateOffset])
		top = math.min(vertex[textureCoordinateOffset] + 1)
		bottom = math.max(vertex[textureCoordinateOffset] + 1)
	end

	model.textureCoordinates = {
		left = left,
		right = right,
		top = top,
		bottom = bottom
	}
end

function Book.Part:loadModel(modelConfig)
	if not (modelConfig.model and modelConfig.texture) then
		return
	end

	local model = {}
	do
		self:getResources():queueAsync(
			SkeletonResource,
			string.format("%s/%s", self:getBook():getBaseFilename(), modelConfig.skeleton or Book.DEFAULT_SKELETON),
			function(resource)
				model.skeleton = resource
			end)

		self:getResources():queueAsync(
			ModelResource,
			string.format("%s/%s", self:getBook():getBaseFilename(), modelConfig.model),
			function(resource)
				model.model = resource

				if modelConfig.canvas then
					self:_pullTextureCoordinates(model)
				end
			end)

		self:getResources():queueAsync(
			TextureResource,
			string.format("%s/%s", self:getBook():getBaseFilename(), modelConfig.texture),
			function(resource)
				model.texture = resource
			end)

		model.isCanvas = not not modelConfig.canvas
	end
	table.insert(self.models, model)

	if modelConfig.canvas then
		if self.canvasModel then
			Log.warn("Book '%s' already has a canvas model for part '%s'!", self:getBook():getResource().name, self.type)
		else
			self.canvasModel = model						
		end
	end
end

function Book.Part:loadModels(modelsConfig)
	if #modelsConfig == 0 then
	else
		for _, modelConfig in ipairs(modelsConfig) do
			self:loadModel
		end
	end
end

function Book.Part:loadAnimations()
	-- Nothing.
end

Book.ANIMATION_CLOSED = 1
Book.ANIMATION_OPENED = 2

function Book:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.previousProgress = 0
	self.shaken = 0
	self.spawned = false
	self.depleted = false
	self.time = 0
	self.transforms = {}
	self.animations = {}
end

function Book:getBaseFilename()
	return Class.ABSTRACT()
end

function Book:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function Book:done()
	-- Nothing.
end

function Book:getCurrentAnimation()
	return self.animations[self.currentAnimation]
	    or self.animations[Book.ANIMATION_IDLE]
end

function Book:applyAnimation(time, animation)
	self.transforms:reset()
	animation:computeFilteredTransforms(time, self.transforms)

	local skeleton = self.skeleton:getResource()
	skeleton:applyTransforms(self.transforms)
	skeleton:applyBindPose(self.transforms)
end

function Book:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Tree.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Spawn.lanim"),
				function(animation)
					self.animations[Book.ANIMATION_SPAWNED] = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Idle.lanim"),
				function(animation)
					self.animations[Book.ANIMATION_IDLE] = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Chopped.lanim"),
				function(animation)
					self.animations[Book.ANIMATION_CHOPPED] = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Felled.lanim"),
				function(animation)
					self.animations[Book.ANIMATION_FELLED] = animation:getResource()
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.node:setModel(self.model)
				self.node:getMaterial():setTextures(self.texture)
				self.node:setParent(root)

				local idleDuration = self.animations[Book.ANIMATION_IDLE]:getDuration()

				root:onWillRender(function()
					local animation = self:getCurrentAnimation()
					if (self.currentAnimation ~= Book.ANIMATION_IDLE and idleDuration <= 1 / 30) or
					   self.time <= animation:getDuration()
					then
						self:applyAnimation(self.time, animation)
					end
				end)

				local offset = idleDuration * math.random()
				self.time = offset
				self:applyAnimation(offset, self.animations[Book.ANIMATION_IDLE])
				self.node:setTransforms(self.transforms)

				local state = self:getProp():getState().resource
				if state then
					if state.depleted then
						self.currentAnimation = Book.ANIMATION_FELLED
						self.time = self.animations[Book.ANIMATION_FELLED]:getDuration()
						self.depleted = true
					else
						self.currentAnimation = Book.ANIMATION_IDLE
						self.time = math.random() * self.animations[Book.ANIMATION_IDLE]:getDuration()
						self.depleted = false
					end

					self.shaken = state.shaken
				else
					self.time = self:getCurrentAnimation():getDuration()
				end

				self:done()

				self.spawned = true
			end)
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Tree.lmodel"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.model = model
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Texture.png"),
		function(texture)
			self.texture = texture
		end)
	if love.filesystem.getInfo(self:getResourcePath("Depleted.png")) then
		resources:queue(
			TextureResource,
			self:getResourcePath("Depleted.png"),
			function(depletedTexture)
				self.depletedTexture = depletedTexture
			end)
	end
end

function Book:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function Book:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.resource then
		local r = state.resource
		if r.progress > 0 and r.progress < 100 and (not self.progressBar or not self.progressBar:getIsSpawned()) then
			self.progressBar = self:getGameView():getSpriteManager():add(
				"ResourceProgressBar",
				self:getRoot(),
				Vector(0, 2, 0),
				self:getProp())
		end

		if self.previousProgress ~= r.progress or self.shaken ~= r.shaken then
			self:getResources():queueEvent(function()
				self.currentAnimation = Book.ANIMATION_CHOPPED
				self.time = 0
			end)

			self.previousProgress = r.progress
			self.shaken = r.shaken

			if self.shaken > 0 and self.depletedTexture then
				self.node:getMaterial():setTextures(self.depletedTexture)
			elseif self.shaken <= 0 and self.texture then
				self.node:getMaterial():setTextures(self.texture)
			end
		end

		if r.depleted ~= self.depleted then
			self:getResources():queueEvent(function()
				if r.depleted then
					self.currentAnimation = Book.ANIMATION_FELLED
				else
					self.currentAnimation = Book.ANIMATION_SPAWNED
				end
			end)

			self.depleted = r.depleted
		end
	end
end

function Book:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		local animation = self:getCurrentAnimation()

		self.time = math.min(self.time + delta, animation:getDuration())

		if (self.currentAnimation == Book.ANIMATION_CHOPPED or
			self.currentAnimation == Book.ANIMATION_IDLE or
			self.currentAnimation == Book.ANIMATION_SPAWNED) and
			self.time >= animation:getDuration()
		then
			self.time = 0
			self.currentAnimation = Book.ANIMATION_IDLE
		end
	end
end

return Book
