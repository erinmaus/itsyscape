--------------------------------------------------------------------------------
-- ItsyScape/UI/UIView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local DynamicAtlas = require "atlas.dynamicSize"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Button = require "ItsyScape.UI.Button"
local ButtonRenderer = require "ItsyScape.UI.ButtonRenderer"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local Drawable = require "ItsyScape.UI.Drawable"
local DrawableRenderer = require "ItsyScape.UI.DrawableRenderer"
local Icon = require "ItsyScape.UI.Icon"
local IconRenderer = require "ItsyScape.UI.IconRenderer"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local ItemIconRenderer = require "ItsyScape.UI.ItemIconRenderer"
local Label = require "ItsyScape.UI.Label"
local LabelRenderer = require "ItsyScape.UI.LabelRenderer"
local PokeMenu = require "ItsyScape.UI.PokeMenu"
local Panel = require "ItsyScape.UI.Panel"
local PanelRenderer = require "ItsyScape.UI.PanelRenderer"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local RichTextLabelRenderer = require "ItsyScape.UI.RichTextLabelRenderer"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local SceneSnippetRenderer = require "ItsyScape.UI.SceneSnippetRenderer"
local SpellIcon = require "ItsyScape.UI.SpellIcon"
local SpellIconRenderer = require "ItsyScape.UI.SpellIconRenderer"
local TextInput = require "ItsyScape.UI.TextInput"
local TextInputRenderer = require "ItsyScape.UI.TextInputRenderer"
local Texture = require "ItsyScape.UI.Texture"
local TextureRenderer = require "ItsyScape.UI.TextureRenderer"
local ToolTip = require "ItsyScape.UI.ToolTip"
local ToolTipRenderer = require "ItsyScape.UI.ToolTipRenderer"
local Widget = require "ItsyScape.UI.Widget"
local WidgetInputProvider = require "ItsyScape.UI.WidgetInputProvider"
local WidgetRenderManager = require "ItsyScape.UI.WidgetRenderManager"
local WidgetResourceManager = require "ItsyScape.UI.WidgetResourceManager"

local UIView = Class()

UIView.WIDTH  = 1920
UIView.HEIGHT = 1080

function love.graphics.getScaledMode()
	local currentWidth, currentHeight = love.window.getMode()
	local desiredWidth, desiredHeight = UIView.WIDTH, UIView.HEIGHT

	local scale
	if currentWidth > desiredWidth then
		scale = math.floor(currentWidth / desiredWidth + 0.5)
	else
		scale = 1
	end

	local realWidth = currentWidth / scale
	local realHeight = currentHeight / scale

	return math.floor(realWidth), math.floor(realHeight), scale, scale
end

function love.graphics.getScaledPoint(x, y)
	local _, _, sx, sy = love.graphics.getScaledMode()
	x = x / sx
	y = y / sy

	return x, y
end

local graphicsState = {
	currentTextures = {},
	textureTimeoutSeconds = 5,
	text = {},
	atlas = DynamicAtlas.new(0, 1, 0),
	transform = love.math.newTransform(),
	pseudoScissor = {},
	drawQueue = {}
}

do
	graphicsState.atlas.maxWidth = 2048
	graphicsState.atlas.maxHeight = 2048

	local w, h = love.window.getMode()
	table.insert(graphicsState.pseudoScissor, { 0, 0, w, h })

	setmetatable(graphicsState.text, { __mode = 'k' })
end

function itsyrealm.graphics.impl.captureRenderState()
	return {
		color = { love.graphics.getColor() },
		font = love.graphics.getFont(),
		lineHeight = love.graphics.getFont():getLineHeight(),
		lineWidth = love.graphics.getLineWidth()
	}
end

function itsyrealm.graphics.impl.setRenderState(renderState)
	love.graphics.setColor(renderState.color)
	love.graphics.setLineWidth(renderState.lineWidth)
	love.graphics.setBlendMode("alpha")
end

function itsyrealm.graphics.impl.drawq(renderState, image, quad, ...)
	local atlas = graphicsState.atlas.image
	local atlasImage = graphicsState.atlas.images[graphicsState.atlas.ids[image]]
	local atlasQuad = graphicsState.atlas.quads[image]

	local qx, qy, qw, qh = quad:getViewport()
	local ax, ay, aw, ah = atlasQuad:getViewport()
	local tw, th = atlasQuad:getTextureDimensions()
	if not graphicsState.quad then
		graphicsState.quad = love.graphics.newQuad(
			ax + qx, ay + qy, qw, qh, tw, th)
	else
		graphicsState.quad:setViewport(
			ax + qx, ay + qy, qw, qh, tw, th)
	end

	love.graphics.setColor(renderState.color)
	love.graphics.drawLayer(atlas, atlasImage.layer, graphicsState.quad, ...)
end

function itsyrealm.graphics.impl.draw(renderState, image, ...)
	local atlas = graphicsState.atlas.image
	local atlasImage = graphicsState.atlas.images[graphicsState.atlas.ids[image]]
	local atlasQuad = graphicsState.atlas.quads[image]

	love.graphics.setColor(renderState.color)
	love.graphics.drawLayer(atlas, atlasImage.layer, atlasQuad, ...)
end

function itsyrealm.graphics.impl.uncachedDraw(renderState, image, ...)
	love.graphics.setColor(renderState.color)
	love.graphics.draw(image, ...)
end

function itsyrealm.graphics.impl.print(renderState, text, ...)
	love.graphics.setFont(renderState.font)
	love.graphics.setColor(renderState.color)
	local oldLineHeight = renderState.font:getLineHeight()
	renderState.font:setLineHeight(renderState.lineHeight)
	love.graphics.setBlendMode("alpha")
	love.graphics.print(text, ...)
	renderState.font:setLineHeight(oldLineHeight)
end

function itsyrealm.graphics.impl.printf(renderState, text, ...)
	love.graphics.setFont(renderState.font)
	love.graphics.setColor(renderState.color)
	local oldLineHeight = renderState.font:getLineHeight()
	renderState.font:setLineHeight(renderState.lineHeight)
	love.graphics.setBlendMode("alpha")
	love.graphics.printf(text, ...)
	renderState.font:setLineHeight(oldLineHeight)
end

function itsyrealm.graphics.impl.setScissor(x, y, w, h)
	love.graphics.setScissor(x, y, w, h)
end

function itsyrealm.graphics.impl.clearScissor()
	love.graphics.setScissor()
end

function itsyrealm.graphics.start()	
	graphicsState.transform:reset()
end

function itsyrealm.graphics.stop()
	local currentTime = love.timer.getTime()
	for texture, textureTime in pairs(graphicsState.currentTextures) do
		local staleSeconds = currentTime - textureTime
		if staleSeconds > graphicsState.textureTimeoutSeconds then
			graphicsState.atlas:remove(texture)
			graphicsState.currentTextures[texture] = nil
		end
	end

	graphicsState.atlas:bake("width")

	love.graphics.push('all')
	for i = 1, #graphicsState.drawQueue do
		local draw = graphicsState.drawQueue[i]
		love.graphics.setBlendMode('alpha', 'premultiplied')
		draw.command(unpack(draw, 1, draw.n))
	end
	table.clear(graphicsState.drawQueue)
	love.graphics.pop()
end

function itsyrealm.graphics.clearPseudoScissor()
	local w, h = love.window.getMode()
	graphicsState.pseudoScissor = { { 0, 0, w, h } }
end

function itsyrealm.graphics.impl.push(command, ...)
	table.insert(
		graphicsState.drawQueue,
		{
			command = command,
			n = select('#', ...),
			...
		})
end

function itsyrealm.graphics.resetPseudoScissor()
	local w, h = love.window.getMode()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setScissor,
		0, 0, w, h)
end

function itsyrealm.graphics.intersectPseudoScissor(x, y, w, h)
	local pseudoScissor = graphicsState.pseudoScissor[#graphicsState.pseudoScissor]
	local x1 = math.max(pseudoScissor[1], x)
	local y1 = math.max(pseudoScissor[2], y)
	local x2 = math.min(
		pseudoScissor[1] + pseudoScissor[3],
		x + w)
	local y2 = math.min(
		pseudoScissor[2] + pseudoScissor[4],
		y + h)

	local newPseudoScissor = { x1, y1, math.max(0, x2 - x1), math.max(0, y2 - y1) }

	table.insert(graphicsState.pseudoScissor, newPseudoScissor)
end

function itsyrealm.graphics.popPseudoScissor()
	table.remove(graphicsState.pseudoScissor)
end

function itsyrealm.graphics.applyPseudoScissor()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setScissor,
		unpack(graphicsState.pseudoScissor[#graphicsState.pseudoScissor]))
end

function itsyrealm.graphics.getPseudoScissor()
	return unpack(graphicsState.pseudoScissor[#graphicsState.pseudoScissor])
end

function itsyrealm.graphics.drawq(image, quad, ...)
	if not graphicsState.currentTextures[image] then
		graphicsState.atlas:add(image, image)
	end
	graphicsState.currentTextures[image] = love.timer.getTime()

	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.drawq,
		itsyrealm.graphics.impl.captureRenderState(),
		image,
		quad,
		...)
end

function itsyrealm.graphics.draw(image, ...)
	if not graphicsState.currentTextures[image] then
		graphicsState.atlas:add(image, image)
	end
	graphicsState.currentTextures[image] = love.timer.getTime()

	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.draw,
		itsyrealm.graphics.impl.captureRenderState(),
		image,
		...)
end

function itsyrealm.graphics.line(...)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		love.graphics.line, ...)
end

function itsyrealm.graphics.rectangle(...)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		love.graphics.rectangle, ...)
end

function itsyrealm.graphics.circle(...)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		love.graphics.circle, ...)
end

function itsyrealm.graphics.arc(...)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		love.graphics.arc, ...)
end

function itsyrealm.graphics.polygon(...)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		love.graphics.polygon, ...)
end

function itsyrealm.graphics.uncachedDraw(...)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.uncachedDraw,
		itsyrealm.graphics.impl.captureRenderState(),
		...)
end

function itsyrealm.graphics.print(text, ...)
	if type(text) == 'table' then
		itsyrealm.graphics.impl.push(
			itsyrealm.graphics.impl.print,
			itsyrealm.graphics.impl.captureRenderState(),
			text,
			...)
	else
		local font = love.graphics.getFont()
		local fontTexts = graphicsState.text[font] or {}
		local fontTextCanvas = fontTexts[text]
		if not fontTextCanvas then
			local width = font:getWidth(text)
			local height = font:getHeight()

			if width == 0 or height == 0 then
				return
			end

			love.graphics.push('all')
			local canvas = love.graphics.newCanvas(width, height)
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.setScissor()
			love.graphics.origin()
			love.graphics.setBlendMode("alpha")
			love.graphics.setCanvas(canvas)
			love.graphics.print(text, 0, 0)
			love.graphics.pop()

			fontTextCanvas = {
				image = canvas,
				time = love.timer.getTime()
			}

			fontTexts[text] = fontTextCanvas
		end

		graphicsState.text[font] = fontTexts
		itsyrealm.graphics.draw(fontTextCanvas.image, ...)
	end
end

function itsyrealm.graphics.printf(text, x, y, width, align, ...)
	if type(text) == 'table' then
		itsyrealm.graphics.impl.push(
			itsyrealm.graphics.impl.printf,
			itsyrealm.graphics.impl.captureRenderState(),
			text,
			x,
			y,
			width,
			align,
			...)
	else
		local font = love.graphics.getFont()
		local fontTexts = graphicsState.text[font] or {}
		local fontTextCanvas = fontTexts[text]
		if not fontTextCanvas then
			local _, lines = font:getWrap(text, width)
			local height = font:getHeight() * font:getLineHeight() * #lines

			if width == 0 or height == 0 then
				return
			end

			love.graphics.push('all')
			local canvas = love.graphics.newCanvas(width, height)
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.setScissor()
			love.graphics.origin()
			love.graphics.setBlendMode("alpha", "premultiplied")
			love.graphics.setCanvas(canvas)
			love.graphics.printf(text, 0, 0, width, align)
			love.graphics.pop()

			fontTextCanvas = {
				image = canvas,
				time = love.timer.getTime()
			}

			fontTexts[text] = fontTextCanvas
		end

		graphicsState.text[font] = fontTexts
		itsyrealm.graphics.draw(fontTextCanvas.image, x, y, ...)
	end
end

function itsyrealm.graphics.translate(...)
	itsyrealm.graphics.impl.push(
		love.graphics.translate,
		...)
	graphicsState.transform:translate(...)
end

function itsyrealm.graphics.scale(...)
	itsyrealm.graphics.impl.push(
		love.graphics.scale,
		...)
	graphicsState.transform:scale(...)
end

function itsyrealm.graphics.transformPoint(...)
	return graphicsState.transform:transformPoint(...)
end

function itsyrealm.graphics.inverseTransformPoint(...)
	return graphicsState.transform:inverseTransformPoint(...)
end

function UIView:new(gameView)
	self.game = gameView:getGame()
	self.gameView = gameView

	local ui = self.game:getUI()
	ui.onOpen:register(self.open, self)
	ui.onClose:register(self.close, self)
	ui.onPoke:register(self.poke, self)

	self.root = Widget()
	self.root:setID("root")
	self.inputProvider = WidgetInputProvider(self.root)

	self.resources = WidgetResourceManager()

	self.renderManager = WidgetRenderManager(self.inputProvider)
	self.renderManager:addRenderer(Button, ButtonRenderer(self.resources))
	self.renderManager:addRenderer(DraggableButton, ButtonRenderer(self.resources))
	self.renderManager:addRenderer(DraggablePanel, PanelRenderer(self.resources))
	self.renderManager:addRenderer(Drawable, DrawableRenderer(self.resources))
	self.renderManager:addRenderer(Label, LabelRenderer(self.resources))
	self.renderManager:addRenderer(Icon, IconRenderer(self.resources))
	self.renderManager:addRenderer(ItemIcon, ItemIconRenderer(self.resources))
	self.renderManager:addRenderer(Panel, PanelRenderer(self.resources))
	self.renderManager:addRenderer(PokeMenu, PanelRenderer(self.resources))
	self.renderManager:addRenderer(RichTextLabel, RichTextLabelRenderer(self.resources))
	self.renderManager:addRenderer(SceneSnippet, SceneSnippetRenderer(self.resources))
	self.renderManager:addRenderer(SpellIcon, SpellIconRenderer(self.resources))
	self.renderManager:addRenderer(TextInput, TextInputRenderer(self.resources))
	self.renderManager:addRenderer(Texture, TextureRenderer(self.resources))
	self.renderManager:addRenderer(ToolTip, ToolTipRenderer(self.resources))

	self.interfaces = {}

	self.pokeMenu = false

	self.keyBinds = {}

	self.pokes = {}
end

function UIView:release()
	local ui = self:getUI()
	ui.onOpen:unregister(self.open)
	ui.onClose:unregister(self.close)
end

function UIView:getIsFullscreen()
	for _, child in self.root:iterate() do
		if child and child.getIsFullscreen and child:getIsFullscreen() then
			return true
		end
	end

	return false
end

function UIView:getGame()
	return self.game
end

function UIView:getGameView()
	return self.gameView
end

function UIView:getUI()
	return self.game:getUI()
end

function UIView:getInputProvider()
	return self.inputProvider
end

function UIView:getRenderManager()
	return self.renderManager
end

function UIView:getRoot()
	return self.root
end

function UIView:getResources()
	return self.resources
end

function UIView:getInterfaces(interfaceID)
	return pairs(self.interfaces[interfaceID] or {})
end

function UIView:open(ui, interfaceID, index)
	local TypeName = string.format("ItsyScape.UI.Interfaces.%s", interfaceID)
	local Type = require(TypeName)

	local interfaces = self.interfaces[interfaceID] or {}
	local interface = Type(interfaceID, index, self)
	interfaces[index] = interface
	self.interfaces[interfaceID] = interfaces

	self.root:addChild(interface)
end

function UIView:close(ui, interfaceID, index)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		local interface = interfaces[index]
		if interface then
			self.root:removeChild(interface)
			interfaces[index] = nil
		end
	end
end

function UIView:poke(ui, interfaceID, index, actionID, actionIndex, e)
	table.insert(self.pokes, {
		interfaceID = interfaceID,
		index = index,
		actionID = actionID,
		actionIndex = actionIndex,
		e = e
	})
end

function UIView:examine(a, b)
	local object, description
	if a and b then
		object = a
		description = b
	elseif a then
		do
			local id = a
			local gameDB = self.game:getGameDB()
			object = Utility.Item.getName(id, gameDB, "en-US")
			if not object then
				object = "*" .. id
			end

			local resource = gameDB:getResource(id, "Item")
			if resource then
				description = Utility.getDescription(resource, gameDB)
			else
				description = string.format("It's a %s.", object)
			end
		end
	end

	local toolTip = self.renderManager:setToolTip(
		math.max(#description / 8, 1.5), 
		ToolTip.Header(object),
		ToolTip.Text(description))
	toolTip:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Examine.9.png"
	}, self.resources))
end

function UIView:probe(actions)
	if self.pokeMenu then
		self.pokeMenu:close()
	end

	self.pokeMenu = PokeMenu(self, actions)
	do
		local windowWidth, windowHeight = love.window.getMode()
		local menuWidth, menuHeight = self.pokeMenu:getSize()
		local mouseX, mouseY = love.mouse.getPosition()
		local menuX = mouseX - PokeMenu.PADDING
		local menuY = mouseY - PokeMenu.PADDING

		if menuX + menuWidth > windowWidth then
			local difference = menuX + menuWidth - windowWidth
			menuX = menuX - difference
		end

		if menuY + menuHeight > windowHeight then
			local difference = menuY + menuHeight - windowHeight
			menuY = menuY - difference
		end

		self.pokeMenu:setPosition(
			menuX,
			menuY)

		self.pokeMenu.onClose:register(function() self.pokeMenu = false end)

		self.root:addChild(self.pokeMenu)
	end
end

function UIView:findWidgetByID(id, topLevelWidget)
	topLevelWidget = topLevelWidget or self.root

	if topLevelWidget:getID() == id then
		return topLevelWidget
	else
		for _, childWidget in topLevelWidget:iterate() do
			local result = self:findWidgetByID(id, childWidget)
			if result then
				return result
			end
		end
	end

	return nil
end

function UIView:update(delta)
	for i = 1, #self.pokes do
		local poke = self.pokes[i]

		local interfaces = self.interfaces[poke.interfaceID]
		if interfaces then
			local interface = interfaces[poke.index]
			if interface then
				interface:poke(poke.actionID, poke.actionIndex, poke.e)
			end
		end
	end
	table.clear(self.pokes)

	self.root:update(delta)

	local toolTips = self.renderManager:getToolTips()
	for i = 1, #toolTips do
		toolTips[i]:update(delta)
	end
end

function UIView:draw()
	local width, height = self:getMode()
	self.root:setSize(width, height)

	love.graphics.setBlendMode('alpha')
	love.graphics.origin()
	love.graphics.ortho(love.window.getMode())

	itsyrealm.graphics.start()
	love.graphics.push("all")
	DebugStats.GLOBAL:measure("WidgetRenderManager.start", self.renderManager.start, self.renderManager)
	DebugStats.GLOBAL:measure("WidgetRenderManager.draw", self.renderManager.draw, self.renderManager, self.root)
	DebugStats.GLOBAL:measure("WidgetRenderManager.stop", self.renderManager.stop, self.renderManager)
	love.graphics.pop()
	DebugStats.GLOBAL:measure("itsyrealm.graphics.stop()", itsyrealm.graphics.stop)
end

function UIView:getMode()
	return love.graphics.getScaledMode()
end

return UIView
