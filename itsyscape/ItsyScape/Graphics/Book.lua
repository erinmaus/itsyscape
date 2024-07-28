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
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"

local Book = Class()

Book.WHITE_SHADER = love.graphics.newShader [[
	vec4 effect(vec4 color, Image image, vec2 textureCoordinates, vec2 screenCoordinates)
	{
		float alpha = Texel(image, textureCoordinates).a;
		return vec4(vec3(1.0), color.a * alpha);
	}
]]

Book.PART_TYPE_BOOK  = "book"
Book.PART_TYPE_FRONT = "front"
Book.PART_TYPE_BACK  = "back"
Book.PART_TYPE_PAGE  = "pages"

Book.STATE_FRONT_COVER = "front"
Book.STATE_BACK_COVER  = "back"
Book.STATE_OPEN        = "open"

Book.DEFAULT_SKELETON = "../Common/Book.lskel"

Book.DEFAULT_MODELS = {
	[Book.PART_TYPE_BOOK] = {
		{ model = "../Common/Book.lmesh", texture = "../Common/Book.png" },
		{ model = "../Common/Pages.lmesh", texture = "../Common/Pages.png" },
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
		name = "book-open",
		animation = "../Common/Open.lanim"
	},
	{
		name = "book-open-page",
		animation = "../Common/Open_Page.lanim"
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

	self.sceneNode = SceneNode()

	self.models = {}
	self.canvasModel = false

	self.animations = {}

	self.resources = {
		[FontResource] = {},
		[TextureResource] = {}
	}

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

function Book.Part:getSceneNode()
	return self.sceneNode
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

function Book.Part:_drawText(pass, command, width, height)
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
	local textWidth = command.width and (command.width / 100 * width)
	local lines = textWidth and select(2, font:getResource():getWrap(value, textWidth))
	local originX = (command.originX or 0) / 100 * (textWidth or font:getResource():getWidth(value))
	local originY = (command.originY or 0) / 100 * (#(lines or { value }) * font:getResource():getHeight())

	love.graphics.setFont(font:getResource())
	if pass == RendererPass.PASS_OUTLINE then
		love.graphics.setColor(0, 0, 0, 1)

		for i = -1, 1, 1 do
			for j = -1, 1, 1 do
				if not (i == 0 and j == 0) then
					if textWidth then
						love.graphics.printf(value, x + i * 6, y + j * 6, textWidth, align, rotation, scaleX, scaleY, originX, originY)
					else
						love.graphics.print(value, x + i * 6, y + j * 6, rotation, scaleX, scaleY, originX, originY)
					end
				end
			end
		end

		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.setColor(color:get())
	end

	if textWidth then
		love.graphics.printf(value, x, y, textWidth, align, rotation, scaleX, scaleY, originX, originY)
	else
		love.graphics.print(value, x, y, rotation, scaleX, scaleY, originX, originY)
	end
end

function Book.Part:_drawImage(pass, command, width, height)
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


	local texture
	if pass == RendererPass.PASS_OUTLINE then
		texture = image:getHandle():getPerPassTexture(pass)
		if texture == image:getResource() then
			love.graphics.setShader(Book.WHITE_SHADER)
		end
	else
		texture = image:getResource()
	end

	love.graphics.setColor(color:get())
	love.graphics.draw(texture, x, y, rotation, scaleX, scaleY, originX, originY)

	love.graphics.setShader()
end

function Book.Part:getIsVisible()
	return self.visible
end

function Book.Part:_updateVisibility()
	for _, model in ipairs(self.models) do
		if model.sceneNode then
			if self.visible and not model.sceneNode:getParent() then
				model.sceneNode:setParent(self.sceneNode)
			elseif not self.visible and model.sceneNode:getParent() then
				model.sceneNode:setParent(nil)
			end
		end
	end
end

function Book.Part:show()
	self.visible = true
	self:_updateVisibility()
end

function Book.Part:hide()
	self.visible = false
	self:_updateVisibility()
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
		if animation.isPlaying and animation.animation and (not name or animation.name == name) then
			local time
			if animation.time == math.huge then
				time = animation.animation:getDuration()
			else
				time = animation.time
			end

			local delta = (time or 0) / animation.animation:getDuration()
			if animation.reverse then
--				delta = 1 - delta
			end

			return delta, animation.name
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
			local t = animation.time
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

				if self.type ~= Book.PART_TYPE_PAGE then
					model.sceneNode:getMaterial():setOutlineThreshold(0.025)
				end

				model.sceneNode:setModel(model.model)
				model.sceneNode:setTransforms(model.transforms)
				model.sceneNode:onWillRender(function(renderer, delta)
					love.graphics.setFrontFaceWinding(self.frontFace)
				end)
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

	self:_updateVisibility()
end

function Book.Part:_draw(left, right, top, bottom, pass, commands)
	love.graphics.push("all")

	local width = right - left
	local height = bottom - top

	love.graphics.origin()
	if self.frontFace == "cw" then
		love.graphics.translate(right, 0, 0)
		love.graphics.scale(-1, 1, 1)
	else
		love.graphics.translate(left, top, 0)
	end

	for _, command in ipairs(commands) do
		if command.command == "text" then
			self:_drawText(pass, command, width, height)
		elseif command.command == "image" then
			self:_drawText(pass, command, width, height)
		end
	end

	love.graphics.pop()
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

		local outlinePerPassTexture = model.texture:getHandle():getPerPassTexture(TextureResource.PASSES.Outline)
		if outlinePerPassTexture and outlinePerPassTexture ~= model.texture:getResource() then
			local outlineCanvas = love.graphics.newCanvas(
				model.texture:getWidth(),
				model.texture:getHeight())
			model.outlineCanvas = outlineCanvas
			model.canvasTexture:getHandle():setPerPassTexture(TextureResource.PASSES.Outline, model.outlineCanvas)
		end
	end

	local left = model.canvas:getWidth() * model.textureCoordinates.left
	local right = model.canvas:getWidth() * model.textureCoordinates.right
	local top = model.canvas:getHeight() * model.textureCoordinates.top
	local bottom = model.canvas:getHeight() * model.textureCoordinates.bottom

	love.graphics.push("all")
	love.graphics.origin()

	love.graphics.setCanvas(model.canvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.draw(model.texture:getResource())

	self:_draw(left, right, top, bottom, RendererPass.PASS_NONE, commands)

	if model.outlineCanvas then
		love.graphics.setCanvas(model.outlineCanvas)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.draw(model.texture:getHandle():getPerPassTexture(TextureResource.PASSES.Outline))

		self:_draw(left, right, top, bottom, RendererPass.PASS_OUTLINE, commands)
	end

	if love.keyboard.isDown("space") then
		love.graphics.setCanvas()

		if model.outlineCanvas then
			model.outlineCanvas:newImageData():encode("png", string.format("%s_outline.png", self.type))
		end

		model.canvas:newImageData():encode("png", string.format("%s_diffuse.png", self.type))
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
			local frontFace = index % 2 == 0 and "cw" or "ccw"
			self:_prepareBookPage({
				skeleton = page.skeleton or (bookConfig.page and bookConfig.page.skeleton or nil),
				models = page.models or (bookConfig.page and bookConfig.page.models or nil),
				animations = page.animations or (bookConfig.page and bookConfig.page.animations or nil),
				commands = page.commands or (bookConfig.page and bookConfig.page.commands or nil),
			}, frontFace)
		end

		if #self.bookPages % 2 == 0 then
			-- Books should have an odd number of pages,
			-- even if the last page is just blank.
			local lastPage = bookConfig.pages[#bookConfig.pages]

			self:_prepareBookPage({
				skeleton = lastPage.skeleton or (bookConfig.page and bookConfig.page.skeleton or nil),
				models = lastPage.models or (bookConfig.page and bookConfig.page.models or nil),
				animations = lastPage.animations or (bookConfig.page and bookConfig.page.animations or nil),
			}, "ccw")
		end
	end
end

function Book:_initAnimations()
	for _, part in ipairs(self.bookParts) do
		part:getSceneNode():setParent(self.sceneNode)

		part:show()
		part:stopAnimation("book-open", true)
	end

	for _, page in ipairs(self.bookPages) do
		page:getSceneNode():setParent(self.sceneNode)

		page:show()
		page:stopAnimation("book-open", true)
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
				self.bookPages[highPage - 1]:playAnimation("book-open-page", reverse)
			end

			if highPage <= #self.bookPages and highPage >= 1 then
				self.bookPages[highPage]:playAnimation("book-open-page", reverse)
			end

			if highPage + 1 <= #self.bookPages and highPage + 1 >= 1 then
				self.bookPages[highPage + 1]:playAnimation("book-open", reverse)
			end
		elseif highPage >= #self.bookPages + 1 then
			for _, part in ipairs(self.bookParts) do
				part:playAnimation("book-open", not reverse)
			end

			if lowPage <= #self.bookPages and lowPage >= 1 then
				self.bookPages[lowPage]:stopAnimation("book-open-page")
				self.bookPages[lowPage]:playAnimation("book-open-page", not reverse)
			end

			if highPage - 1 <= #self.bookPages and highPage - 1 >= 1 then
				self.bookPages[highPage - 1]:playAnimation("book-open", not reverse)
			end
		else
			if lowPage + 1 <= #self.bookPages and lowPage + 1 >= 1 then
				self.bookPages[lowPage + 1]:playAnimation("page-flip", reverse)
			end

			if highPage <= #self.bookPages and highPage >= 1 then
				self.bookPages[highPage]:playAnimation("page-flip", reverse)
			end

			if not reverse and highPage + 1 <= #self.bookPages and highPage + 1 >= 1 then
				self.bookPages[highPage + 1]:stopAnimation("page-flip", true)
			end
		end
	end
end

function Book:getCurrentPages()
	return self.currentPage, self.currentPage + 1
end

function Book:getNumPages()
	return #self.bookPages
end

function Book:getWillFlipForwardCloseBook()
	return self.currentPage + 2 > #self.bookPages
end

function Book:getWillFlipBackwardCloseBook()
	return self.currentPage - 2 <= 0
end

function Book:getIsClosed()
	return self.currentPage < 1 or self.currentPage > #self.bookPages
end

function Book:getCurrentState()
	if self.currentPage < 1 then
		return Book.STATE_FRONT_COVER
	elseif self.currentPage > #self.bookPages then
		return Book.STATE_BACK_COVER
	else
		return Book.STATE_OPEN
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

function Book:getIsFlipping()
	for _, page in ipairs(self.bookPages) do
		local animationDelta = page:getAnimationDelta()

		if animationDelta and animationDelta < 0.75 then
			return true
		end
	end

	return false
end

function Book:getIsOpeningOrClosing()
	for _, part in ipairs(self.bookParts) do
		local openDelta = part:getAnimationDelta()

		if openDelta and openDelta < 0.95 then
			return true
		end
	end

	return false
end

function Book:update(delta)
	if not self.didInitializeAnimations and not self:getIsLoading() then
		self:_initAnimations()
		self.didInitializeAnimations = true
	end

	for _, part in ipairs(self.bookParts) do
		part:update(delta)
	end

	for _, page in ipairs(self.bookPages) do
		page:update(delta)
	end

	do
		local lowPage = math.min(self.currentPage, self.previousPage)
		local highPage = math.max(self.currentPage, self.previousPage)
		local minPage = math.clamp(self.currentPage, 1, #self.bookPages) - 1
		local maxPage = math.clamp(self.currentPage, 1, #self.bookPages) + 1

		for i = 1, #self.bookPages do
			local page = self.bookPages[i]

			local v = page:getIsVisible()
			if i < minPage then
				local nextPage = self.bookPages[i + 1]
				local nextPageDelta = nextPage and nextPage:getAnimationDelta()
				if nextPageDelta and nextPageDelta < 1 then
					page:show()
				else
					page:hide()
				end
			elseif i >= minPage and i < maxPage then
				page:show()
			elseif i == maxPage then
				local animationDelta = page:getAnimationDelta()
				if animationDelta and animationDelta < 1 then
					page:show()
				elseif self.currentPage > self.previousPage then
					local previousPage = self.bookPages[i - 1]
					local previousPageDelta = previousPage and previousPage:getAnimationDelta()

					if previousPageDelta and previousPageDelta > 0.1 then
						page:show()
					else
						page:hide()
					end
				else
					local nextPage = self.bookPages[i + 1]
					local nextPageDelta = nextPage and nextPage:getAnimationDelta()

					if nextPageDelta and nextPageDelta > 0.1 or self.previousPage == #self.bookPages + 1 or self.currentPage == 0 then
						page:show()
					else
						page:hide()
					end
				end
			else
				local previousPage = self.bookPages[i - 1]
				local previousPageDelta = previousPage and previousPage:getAnimationDelta()

				local animationDelta = page:getAnimationDelta()
				if (animationDelta and animationDelta < 1) or (previousPageDelta and previousPageDelta < 0.9) then
					page:show()
				else
					page:hide()
				end
			end
		end
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
