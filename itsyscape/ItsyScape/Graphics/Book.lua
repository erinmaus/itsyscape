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
local FontResource = require "ItsyScape.Graphics.FontResource"
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

Book.DEFAULT_ANIMATIONS = {
	{
		name = "open",
		animation = "../Common/Open.lanim",
		bones = { "cover.front", "cover.back", "spine", "root" }
	},
	{
		name = "close",
		animation = "../Common/Close.lanim",
		bones = { "cover.front", "cover.back", "spine", "root" }
	},
	{
		name = "flip",
		animation = "../Common/Flip.lanim",
		bones = { "page1", "page2", "page3", "page4", "page5", "page6", "page7" }
	 }
}

Book.Part = Class()

function Book.Part:new(book, partType, config)
	self.book = book
	self.type = partType
	self.config = config or {}

	self.models = {}
	self.canvasModel = false

	self.animations = {}

	self.resources = {
		[FontResource] = {},
		[TextureResource] = {}
	}
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

	local model = { filter = {} }
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
		self:loadModel(Book.DEFAULT_MODELS[self.type])
	else
		for _, modelConfig in ipairs(modelsConfig) do
			self:loadModel(modelConfig)
		end
	end
end

function Book.Part:loadAnimation(animationConfig)
	if not (animationConfig.animation and animationConfig.name) then
		return
	end

	local animation = { name = animationConfig }
	do
		self:getResources():queueAsync(
			SkeletonAnimationResource,
			string.format("%s/%s", self:getBook():getBaseFilename(), animationConfig.animation),
			function(resource)
				animation.animation = resource
			end)

		animation.bones = {}
		for _, bone in ipairs(animationsConfig.bones or {}) do
			table.insert(animation.bones, bone)
		end
	end
	table.insert(self.animations, animation)
end

function Book.Part:loadAnimations(animationsConfig)
	if #animationsConfig == 0 then
		self:loadModel(Book.DEFAULT_ANIMATIONS)
	else
		for _, modelConfig in ipairs(animationsConfig) do
			self:loadModel(modelConfig)
		end
	end
end

function Book.Park:_drawText(command, width, height)
	if not (command.fontFamily and command.fontSize) then
		return
	end

	local fontSize = math.floor((command.fontSize / 100) * height)
	local filename = string.format("Resources/Widget/Common/%s.ttf@%d", command.fontFamily, fontSize)

	local font = self.resources[FontResource][filename]
	if font == nil then
		self.resources[FontResource][filename] = false
		self:getResources():queueAsync(
			FontResource,
			filename,
			function(resource)
				self.resources[FontResource][filename] = resource
			end)
	elseif not font or not font:getIsReady() then
		return
	end

	local x = (command.x or 0) / 100 * width
	local y = (command.y or 0) / 100 * height
	local scaleX = (command.scaleX or 100) / 100
	local scaleY = (command.scaleY or 100) / 100
	local rotation = math.rad(command.rotation or 0)
	local color = Color.fromHexString(command.color or "000000")
	local align = command.align or "left"
	local textWidth = (command.width or 100) / 100 * width
	local _, lines = font:getResource():getWrap(textWidth)
	local originX = (command.originX or 0) / 100 * textWidth
	local originY = (command.originY or 0) / 100 * (#lines * font:getResource():getHeight())

	love.graphics.setColor(color:get())
	love.graphics.setFont(font:getResource())
	love.graphics.printf(command.value or "", x, y, textWidth, align, rotation, scaleX, scaleY, originX, originY)
end

function Book.Park:_drawImage(command, width, height)
	if not command.value then
		return
	end

	local filename = string.format("%s/%s", self:getBook():getBaseFilename(), command.value)
	local image = self.resources[TextureResource][filename]
	if image == nil then
		self.resources[TextureResource][filename] = false
		self:getResources():queueAsync(
			TextureResource,
			filename,
			function(resource)
				self.resources[TextureResource][filename] = resource
			end)
	elseif not image or not image:getIsReady() then
		return
	end

	local x = (command.x or 0) / 100 * width
	local y = (command.y or 0) / 100 * height
	local scaleX = (command.scaleX or 100) / 100
	local scaleY = (command.scaleY or 100) / 100
	local rotation = math.rad(command.rotation or 0)
	local color = Color.fromHexString(command.color or "ffffff")
	local originX = (command.originX or 0) / 100 * image:getWidth()
	local originY = (command.originY or 0) / 100 * image:getHeight()

	love.graphics.setColor(color:get())
	love.graphics.draw(image:getResource(), x, y, rotation, scaleX, scaleY, originX, originY)
end

function Book.Part:show()
	self.visible = true
end

function Book.Part:hide()
	self.visible = false
end

function Book.Part:startAnimation(name)
	for _, animation in ipairs(self.animations) do
		if animation.name == name then
			if not (animation.animation and animation.animation:getIsReady()) then
				animation.time = 0
			else
				animation.time = animation.animation:getResource():getDuration() - animation.time
			end

			break
		end
	end
end

function Book.Part:finishAnimation(name)
	for _, animation in ipairs(self.animations) do
		if animation.name == name then
			if not (animation.animation and animation.animation:getIsReady()) then
				animation.time = math.huge
			else
				animation.time = animation.animation:getResource():getDuration()
			end

			break
		end
	end
end

function Book.Part:update(delta)
	for _, model in ipairs(self.models) do
		if model.model and model.texture and model.skeleton then
			if not model.sceneNode then
				model.transforms = model.skeleton:createTransforms()

				model.model:bindSkeleton(model.skeleton)
				model.sceneNode = ModelSceneNode()
				model.sceneNode:setModel(model.model)
				model.sceneNode:setTransforms(model.transforms)
			end

			if self.visible and not model.sceneNode:getParent() then
				model.sceneNode:setParent(self.book:getSceneNode())
			elseif not self.visible and model.sceneNode:getParent() then
				model.sceneNode:setParent(nil)
			end

			if model.canvas then
				model.sceneNode:getMaterial():setTextures(model.canvas)
			else
				model.sceneNode:getMaterial():setTextures(model.texture)
			end

			for _, animation in ipairs(self.animations) do
				if animation.animation and not model.filter[animation] then
					local filter = model.skeleton:createFilter()
					animation.filter[animation] = filter

					animation.filter:disableAllBones()
					for _, bone in ipairs(animation.bones) do
						local boneIndex = model.skeleton:getBoneIndex(bone)
						if boneIndex and boneIndex >= 1 then
							animation.filter:enableBoneAtIndex(boneIndex)
						end
					end
				end
			end
		end
	end

	for _, animation in ipairs(self.animations) do
		animation.time = animation.time + delta
	end
end

function Book.Part:draw(commands)
	if not self.canvasModel then
		return
	end

	local commands = commands or self.config.commands
	if not command then
		return
	end

	local model = self.canvasModel
	if not model.canvas then
		local canvas = love.graphics.newCanvas(
			model.texture:getWidth(),
			model.texture:getHeight())
		model.canvas = TextureResource(canvas)
	end

	love.graphics.push("all")
	love.graphics.setCanvas(model.canvas:getTexture())
	if model.texture and model.texture:getIsReady() then
		love.graphics.draw(model.texture:getResource())
	end

	for _, command in ipairs(commands) do
		if command.command == "text" then
			self:_drawText(command, model.canvas:getWidth(), model.canvas:getHeight())
		elseif command.command = "image" then
			self:_drawText(command, model.canvas:getWidth(), model.canvas:getHeight())
		end
	end
	love.graphics.pop()
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
