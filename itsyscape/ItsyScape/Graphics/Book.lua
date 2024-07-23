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
local SceneNode = require "ItsyScape.Graphics.SceneNode"

local Book = Class()

Book.PART_TYPE_BOOK  = "book"
Book.PART_TYPE_FRONT = "front"
Book.PART_TYPE_BACK  = "back"
Book.PART_TYPE_PAGE  = "pages"

Book.DEFAULT_SKELETON = "../Common/Book.lskel"

Book.DEFAULT_MODELS = {
	[Book.PART_TYPE_BOOK] = {
		--{ model = "../Common/Book.lmesh", texture = "../Common/Book.png" }
	},

	[Book.PART_TYPE_FRONT] = {
		--{ model = "../Common/Front.lmesh", texture = "../Common/Front.png", canvas = true }
	},

	[Book.PART_TYPE_BACK] = {
		--{ model = "../Common/Back.lmesh", texture = "../Common/Back.png", canvas = true }
	},

	[Book.PART_TYPE_PAGE] = {
		{ model = "../Common/Page.lmesh", texture = "../Common/Page.png", canvas = true }
	}
}

Book.DEFAULT_ANIMATIONS = {
	{
		name = "book-open",
		animation = "../Common/Open.lanim"
	},
	{
		name = "book-close",
		animation = "../Common/Close.lanim"
	},
	{
		name = "page-flip",
		animation = "../Common/Flip.lanim"
	 }
}

Book.Part = Class()

function Book.Part:new(book, partType, config, frontFace)
	self.book = book
	self.type = partType
	self.config = config or {}
	self.frontFace = frontFace or "ccw"
	self.depthOffset = 0

	self.models = {}
	self.canvasModel = false

	self.animations = {}

	self.resources = {
		[FontResource] = {},
		[TextureResource] = {}
	}

	if partType == Book.PART_TYPE_PAGE then
		print(">>> the font face value is", self.frontFace)
	end

	self.visible = false
end

function Book.Part:getBook()
	return self.book
end

function Book.Part:getType()
	return self.type
end

function Book.Part:getResourceManager()
	return self.book:getResourceManager()
end

function Book.Part:getConfig()
	return self.config
end

function Book.Part:setDepthOffset(value)
	self.depthOffset = value or 0
end

function Book.Part:getDepthOffset()
	return self.depthOffset
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
		left = math.min(left, vertex[textureCoordinateOffset])
		right = math.max(right, vertex[textureCoordinateOffset])
		top = math.min(top, vertex[textureCoordinateOffset + 1])
		bottom = math.max(bottom, vertex[textureCoordinateOffset + 1])
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
		self:getResourceManager():queue(
			ModelResource,
			string.format("%s/%s", self:getBook():getBaseFilename(), modelConfig.model),
			function(resource)
				model.model = resource

				if modelConfig.canvas then
					self:_pullTextureCoordinates(model)
				end
			end)

		self:getResourceManager():queue(
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
		modelsConfig = Book.DEFAULT_MODELS[self.type]
	end

	for _, modelConfig in ipairs(modelsConfig) do
		self:loadModel(modelConfig)
	end
end

function Book.Part:loadAnimation(animationConfig)
	if not (animationConfig.animation and animationConfig.name) then
		return
	end

	local animation = { name = animationConfig.name, reverse = false, isPlaying = false }
	do
		self:getResourceManager():queue(
			SkeletonAnimationResource,
			string.format("%s/%s", self:getBook():getBaseFilename(), animationConfig.animation),
			function(resource)
				animation.animation = resource:getResource()
			end,
			self.skeleton)

		animation.bones = {}
		for _, bone in ipairs(animationConfig.bones or {}) do
			table.insert(animation.bones, bone)
		end
	end
	table.insert(self.animations, animation)
end

function Book.Part:loadAnimations(animationsConfig)
	if #animationsConfig == 0 then
		animationsConfig = Book.DEFAULT_ANIMATIONS
	end

	self:getResourceManager():queue(
		SkeletonResource,
		string.format("%s/%s", self:getBook():getBaseFilename(), self.config.skeleton or Book.DEFAULT_SKELETON),
		function(resource)
			self.skeleton = resource:getResource()

			for _, animationConfig in ipairs(animationsConfig) do
				self:loadAnimation(animationConfig)
			end
		end)
end

function Book.Part:_drawText(command, width, height)
	if not (command.fontFamily and command.fontSize) then
		return
	end

	local fontSize = math.floor((command.fontSize / 100) * height)
	local filename = string.format("Resources/Renderers/Widget/Common/%s.ttf@%d", command.fontFamily, fontSize)

	local font = self.resources[FontResource][filename]
	if font == nil then
		self.resources[FontResource][filename] = false
		self:getResourceManager():queue(
			FontResource,
			filename,
			function(resource)
				self.resources[FontResource][filename] = resource
			end)
	end

	if not font or not font:getIsReady() then
		return
	end

	local value = command.value or ""
	local x = (command.x or 0) / 100 * width
	local y = (command.y or 0) / 100 * height
	local scaleX = (command.scaleX or 100) / 100
	local scaleY = (command.scaleY or 100) / 100
	local rotation = math.rad(command.rotation or 0)
	local color = Color.fromHexString(command.color or "000000")
	local align = command.align or "left"
	local textWidth = (command.width or 100) / 100 * width
	local _, lines = font:getResource():getWrap(value, textWidth)
	local originX = (command.originX or 0) / 100 * textWidth
	local originY = (command.originY or 0) / 100 * (#lines * font:getResource():getHeight())

	love.graphics.setColor(color:get())
	love.graphics.setFont(font:getResource())
	love.graphics.printf(value, x, y, textWidth, align, rotation, scaleX, scaleY, originX, originY)
end

function Book.Part:_drawImage(command, width, height)
	if not command.value then
		return
	end

	local filename = string.format("%s/%s", self:getBook():getBaseFilename(), command.value)
	local image = self.resources[TextureResource][filename]
	if image == nil then
		self.resources[TextureResource][filename] = false
		self:getResourceManager():queue(
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

function Book.Part:getIsVisible()
	return self.visible
end

function Book.Part:show()
	self.visible = true
end

function Book.Part:hide()
	self.visible = false
end

function Book.Part:playAnimation(name, reverse)
	reverse = not not reverse

	for _, animation in ipairs(self.animations) do
		if animation.name == name then
			if not animation.isPlaying and not animation.animation and animation.reverse == reverse then
				animation.time = 0
			else
				if animation.reverse ~= reverse then
					animation.time = animation.animation:getDuration() - (animation.time or 0)
				else
					animation.time = 0
				end
			end

			animation.reverse = reverse
			animation.isPlaying = true
		else
			animation.isPlaying = false
		end
	end
end

function Book.Part:stopAnimation(name, reverse)
	for _, animation in ipairs(self.animations) do
		if animation.name == name then
			animation.isPlaying = true

			if not animation.animation then
				animation.time = math.huge
			else
				animation.time = animation.animation:getDuration()
			end

			animation.reverse = not not reverse
		else
			animation.isPlaying = false
		end
	end
end

function Book.Part:getAnimationDelta(name)
	for _, animation in ipairs(self.animations) do
		if animation.isPlaying and animation.animation and animation.name == name then
			local time
			if animation.time == math.huge then
				time = animation.animation:getDuration()
			else
				time = animation.time
			end

			local delta = (time or 0) / animation.animation:getDuration()
			if animation.reverse then
				delta = 1 - delta
			end

			return delta
		end
	end

	return nil
end

function Book.Part:update(delta)
	for _, model in ipairs(self.models) do
		if model.transforms then
			model.transforms:reset()
		end
	end

	for _, animation in ipairs(self.animations) do
		if animation.isPlaying then
			animation.time = (animation.time or 0) + delta

			if animation.animation then
				animation.time = math.min(animation.time, animation.animation:getDuration())

				for _, model in ipairs(self.models) do
					if model.transforms and model.filter[animation] then
						local time
						if animation.time == math.huge then
							if animation.reverse then
								time = 0
							else
								time = animation.animation:getDuration()
							end
						else
							if animation.reverse then
								time = animation.animation:getDuration() - animation.time
							else
								time = animation.time
							end
						end

						--print(">>> compute", animation.name, time)
						animation.animation:computeFilteredTransforms(time, model.transforms, model.filter[animation])
					end
				end
			end
		end
	end

	for _, model in ipairs(self.models) do
		if model.model and model.texture and self.skeleton then
			if not model.sceneNode then
				model.transforms = self.skeleton:createTransforms()

				model.model:getResource():bindSkeleton(self.skeleton)
				model.sceneNode = ModelSceneNode()
				model.sceneNode:setModel(model.model)
				model.sceneNode:setTransforms(model.transforms)
				model.sceneNode:onWillRender(function(renderer, delta)
					local shader = renderer:getCurrentShader()
					if shader:hasUniform("scape_DepthOffset") then
						shader:send("scape_DepthOffset", self.depthOffset)
					end

					love.graphics.setFrontFaceWinding(self.frontFace)
				end)
			end

			if self.visible and not model.sceneNode:getParent() then
				model.sceneNode:setParent(self.book:getSceneNode())
			elseif not self.visible and model.sceneNode:getParent() then
				model.sceneNode:setParent(nil)
			end

			self.skeleton:applyTransforms(model.transforms)
			self.skeleton:applyBindPose(model.transforms)

			if model.canvasTexture then
				model.sceneNode:getMaterial():setTextures(model.canvasTexture)
			else
				model.sceneNode:getMaterial():setTextures(model.texture)
			end

			for _, animation in ipairs(self.animations) do
				if animation.animation and not model.filter[animation] then
					local filter = self.skeleton:createFilter()
					model.filter[animation] = filter

					if #animation.bones == 0 then
						filter:enableAllBones()
					else
						filter:disableAllBones()

						for _, bone in ipairs(animation.bones) do
							local boneIndex = self.skeleton:getBoneIndex(bone)
							if boneIndex and boneIndex >= 1 then
								filter:enableBoneAtIndex(boneIndex)
							end
						end
					end
				end
			end
		end
	end
end

function Book.Part:draw(commands)
	if not self.canvasModel then
		return
	end

	local commands = commands or self.config.commands
	if not commands then
		return
	end

	local model = self.canvasModel
	if not model.canvas then
		if not model.texture or not model.textureCoordinates then
			return
		end

		local canvas = love.graphics.newCanvas(
			model.texture:getWidth(),
			model.texture:getHeight())
		model.canvas = canvas
		model.canvasTexture = TextureResource(canvas)
	end

	local left = model.canvas:getWidth() * model.textureCoordinates.left
	local right = model.canvas:getWidth() * model.textureCoordinates.right
	local top = model.canvas:getHeight() * model.textureCoordinates.top
	local bottom = model.canvas:getHeight() * model.textureCoordinates.bottom
	local width = right - left
	local height = bottom - top

	love.graphics.push("all")
	love.graphics.origin()
	love.graphics.translate(left, top, 0)
	love.graphics.setCanvas(model.canvas)
	if model.texture and model.texture:getIsReady() then
		love.graphics.draw(model.texture:getResource())
	end

	for _, command in ipairs(commands) do
		if command.command == "text" then
			self:_drawText(command, width, height)
		elseif command.command == "image" then
			self:_drawText(command, width, height)
		end
	end
	love.graphics.pop()
end

function Book:new(bookConfig, resource, gameView)
	self.bookConfig = bookConfig
	self.resource = resource
	self.gameView = gameView

	self.sceneNode = SceneNode()

	self.previousPage = 0
	self.currentPage = 0

	self.bookParts = {}
	do
		self:_prepareBookPart(Book.PART_TYPE_BOOK, bookConfig.book or {})
		self:_prepareBookPart(Book.PART_TYPE_FRONT, bookConfig.front or {})
		self:_prepareBookPart(Book.PART_TYPE_BACK, bookConfig.back or {})
	end

	self.bookPages = {}
	do
		for index, page in ipairs(bookConfig.pages or {}) do
			local frontFace = index % 2 == 0 and "ccw" or "cw"
			print(">>> index", index, "is even", index % 2 == 0, "frontFace", frontFace)
			self:_prepareBookPage(page, frontFace)
		end

		if #self.bookPages % 2 == 0 then
			-- Books should have an odd number of pages,
			-- even if the last page is just blank.
			local lastPage = bookConfig.pages[#bookConfig.pages]

			self:_prepareBookPage({ models = lastPage.models, animations = lastPage.animations }, "cw")
		end
	end
end

function Book:_initAnimations()
	for _, part in ipairs(self.bookParts) do
		part:show()
		part:stopAnimation("book-open", true)
	end

	for _, page in ipairs(self.bookPages) do
		page:show()
		page:stopAnimation("page-flip", true)
	end
end

function Book:_prepareBookPart(partType, config)
	table.insert(self.bookParts, Book.Part(self, partType, config))
end

function Book:_prepareBookPage(config, frontFace)
	table.insert(self.bookPages, Book.Part(self, Book.PART_TYPE_PAGE, config, frontFace))
end

function Book:getSceneNode()
	return self.sceneNode
end

function Book:_flip(reverse)
	local lowPage = math.min(self.currentPage, self.previousPage)
	local highPage = math.max(self.currentPage, self.previousPage)

	if lowPage ~= highPage then
		if lowPage == 0 then
			for _, part in ipairs(self.bookParts) do
				part:playAnimation("book-open", reverse)
			end

			if highPage - 1 >= 1 then
				self.bookPages[highPage - 1]:playAnimation("book-open", reverse)
				print(">>> play book-open", highPage - 1)
			end

			if highPage <= #self.bookPages and highPage >= 1 then
				self.bookPages[highPage]:playAnimation("book-open", reverse)
				print(">>> play book-open", highPage)
			end

			if not reverse and highPage + 1 <= #self.bookPages and highPage + 1 >= 1 then
				self.bookPages[highPage + 1]:stopAnimation("book-open", true)
				print(">>> keep page-flip", highPage + 1)
			end
		elseif highPage >= #self.bookPages + 1 then
			for _, part in ipairs(self.bookParts) do
				part:playAnimation("book-close", reverse)
			end

			if lowPage + 1 <= #self.bookPages and lowPage + 1 >= 1 then
				self.bookPages[lowPage + 1]:playAnimation("book-close", reverse)
			end
		else
			if lowPage + 1 <= #self.bookPages and lowPage + 1 >= 1 then
				self.bookPages[lowPage + 1]:playAnimation("page-flip", reverse)
				print(">>>> play page-flip", lowPage + 1)
			end

			if highPage <= #self.bookPages and highPage >= 1 then
				self.bookPages[highPage]:playAnimation("page-flip", reverse)
				print(">>>> start page-flip", highPage)
			end

			if not reverse and highPage + 1 <= #self.bookPages and highPage + 1 >= 1 then
				self.bookPages[highPage + 1]:stopAnimation("page-flip", true)
				print(">>>> keep page-flip", highPage + 1)
			end
		end
	end
end

function Book:flipForward()
	self.previousPage = self.currentPage
	self.currentPage = math.min(self.currentPage + 2, #self.bookPages + 1)

	self:_flip(false)
end

function Book:flipBackward()
	self.previousPage = self.currentPage
	self.currentPage = math.max(self.currentPage - 2, 0)

	self:_flip(true)
end

function Book:getResource()
	return self.resource
end

function Book:getResourceManager()
	if not self.resourceView or not self.resourceView:getIsPending() then
		self.resourceView = self.gameView:getResourceManager():newView()
	end

	return self.resourceView
end

function Book:getIsLoading()
	return not self.resourceView or self.resourceView:getIsPending()
end

function Book:getBaseFilename()
	return string.format("Resources/Game/Books/%s", self.resource.name)
end

function Book:load()
	for _, part in ipairs(self.bookParts) do
		part:load()
	end

	for _, page in ipairs(self.bookPages) do
		page:load()
	end
end

function Book:update(delta)
	if not self.didInitializeAnimations and not self:getIsLoading() then
		self:_initAnimations()
		self.didInitializeAnimations = true
	end

	for i = 2, self.currentPage + 1 do
		local currentPage = self.bookPages[i]
		local previousPage = self.bookPages[i - 1]

		if currentPage and previousPage then
			local delta = currentPage:getAnimationDelta("page-flip")
			--local delta = nextPage:getAnimationDelta("page-flip") or nextPage:getAnimationDelta("book-open") or nextPage:getAnimationDelta("book-close")
			if delta and delta >= 1 then
				if previousPage:getIsVisible() then end
				--print(">>> hide", i, delta) end
				--previousPage:hide()
			else
				if not previousPage:getIsVisible() then end
				--print(">>> show", i) end
				--previousPage:show()
			end
		end
	end

	-- for i = self.previousPage, self.currentPage do
	-- 	local currentPage = self.bookPages[i]
	-- 	if currentPage then
	-- 		--print(">>>> force show", i)
	-- 		currentPage:show()
	-- 	end
	-- end

	for _, part in ipairs(self.bookParts) do
		part:update(delta)
	end

	for _, page in ipairs(self.bookPages) do
		page:update(delta)
	end
end

function Book:draw()
	for _, part in ipairs(self.bookParts) do
		part:draw()
	end

	for _, page in ipairs(self.bookPages) do
		if page:getIsVisible() then
			page:draw()
		end
	end
end

return Book
