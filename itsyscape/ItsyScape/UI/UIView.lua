--------------------------------------------------------------------------------
-- ItsyScape/UI/UIView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Color = require "ItsyScape.Graphics.Color"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Atlas = require "ItsyScape.UI.Atlas"
local Button = require "ItsyScape.UI.Button"
local ButtonRenderer = require "ItsyScape.UI.ButtonRenderer"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local Drawable = require "ItsyScape.UI.Drawable"
local DrawableRenderer = require "ItsyScape.UI.DrawableRenderer"
local Icon = require "ItsyScape.UI.Icon"
local IconRenderer = require "ItsyScape.UI.IconRenderer"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local ItemIconRenderer = require "ItsyScape.UI.ItemIconRenderer"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local LabelRenderer = require "ItsyScape.UI.LabelRenderer"
local GamepadPokeMenu = require "ItsyScape.UI.GamepadPokeMenu"
local GamepadIcon = require "ItsyScape.UI.GamepadIcon"
local GamepadIconRenderer = require "ItsyScape.UI.GamepadIconRenderer"
local Panel = require "ItsyScape.UI.Panel"
local PanelRenderer = require "ItsyScape.UI.PanelRenderer"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local RichTextLabelRenderer = require "ItsyScape.UI.RichTextLabelRenderer"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local SceneSnippetRenderer = require "ItsyScape.UI.SceneSnippetRenderer"
local ScrollBar = require "ItsyScape.UI.ScrollBar"
local ScrollButtonRenderer = require "ItsyScape.UI.ScrollButtonRenderer"
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
local ControlManager = require "ItsyScape.UI.ControlManager"

local UIView = Class()

UIView.Root = Class(Widget)
function UIView.Root:getOverflow()
	return true
end

UIView.WIDTH  = 1920
UIView.HEIGHT = 1080
UIView.MOBILE_HEIGHT    = 720
UIView.MOBILE_X_PADDING = 48
UIView.MOBILE_Y_PADDING = 24
UIView.MOBILE_SCALE     = 0.65

UIView.INPUT_SCHEME_MOUSE_KEYBOARD = "mouse/keyboard"
UIView.INPUT_SCHEME_TOUCH          = "touch"
UIView.INPUT_SCHEME_GYRO           = "gyro"
UIView.INPUT_SCHEME_GAMEPAD        = "gamepad"

local uiScale = 1
function itsyrealm.graphics.setUIScale(value)
	if type(value) == "number" or type(value) == "nil" then
		uiScale = value or 1
	end
end

local _mode
function itsyrealm.graphics.getScaledMode()
	local currentWidth, currentHeight = love.window.getMode(_mode)
	local desiredWidth, desiredHeight = UIView.WIDTH, UIView.HEIGHT
	local paddingX, paddingY = 0, 0

	local scale
	if currentHeight < UIView.MOBILE_HEIGHT then
		if _MOBILE or true then
			paddingX, paddingY = UIView.MOBILE_X_PADDING, UIView.MOBILE_Y_PADDING
		end

		scale = UIView.MOBILE_SCALE
	elseif currentWidth > desiredWidth then
		scale = math.floor(currentWidth / desiredWidth + 0.5)
	else
		scale = 1
	end
	scale = scale * (uiScale or 1)

	local realWidth = currentWidth / scale - paddingX * 2
	local realHeight = currentHeight / scale - paddingY * 2

	return math.floor(realWidth), math.floor(realHeight), scale, scale, paddingX, paddingY
end

function itsyrealm.graphics.getScaledPoint(x, y)
	local _, _, sx, sy, ox, oy = itsyrealm.graphics.getScaledMode()
	x = x / sx
	y = y / sy

	return x, y
end

function itsyrealm.graphics.inverseGetScaledPoint(x, y)
	local _, _, sx, sy, ox, oy = itsyrealm.graphics.getScaledMode()
	x = x * sx
	y = y * sy

	return x, y
end

function love.graphics.getScaledMode()
	return itsyrealm.graphics.getScaledMode()
end

function love.graphics.getScaledPoint(x, y)
	return itsyrealm.graphics.getScaledPoint(x, y)
end

local graphicsState = {
	transform = love.math.newTransform(),
	sizeTransform = love.math.newTransform(),
	transforms = {},
	renderStates = {},
	pseudoScissor = { n = 0 },
	appliedPseudoScissor = { n = 0 },
	sizes = {},
	drawQueue = { n = 0 },
	oldSizes = setmetatable({}, { __mode = "k" }),
	currentSizes = setmetatable({}, { __mode = "k" }),
	pendingSizes = {},
	seenSizes = {},
	time = 0
}

do
	local limits = love.graphics.getSystemLimits()

	local textureSize = 2048
	local _, _, scale = love.graphics.getScaledMode()
	if scale > 2 then
		textureSize = 4096
	end

	textureSize = math.min(limits.texturesize, textureSize)

	graphicsState.atlas = Atlas(textureSize, textureSize, 32)

	local w, h = love.window.getMode()
	table.insert(graphicsState.pseudoScissor, { 0, 0, w, h })
	graphicsState.pseudoScissor.n = 1

	table.insert(graphicsState.appliedPseudoScissor, { 0, 0, w, h })
end

function itsyrealm.mouse.getPosition()
	if _APP then
		return _APP:getMousePosition()
	end

	return love.mouse.getPosition()
end

function itsyrealm.graphics.getTime()
	return graphicsState.time
end

function itsyrealm.graphics.impl.captureRenderState()
	local index = graphicsState.drawQueue.n + 1

	local transform
	if graphicsState.recording then
		transform = love.math.newTransform()
	else
		transform = graphicsState.transforms[index]
		if not transform then
			transform = love.math.newTransform()
			graphicsState.transforms[index] = transform
		else
			transform:reset()
		end
	end

	transform:apply(graphicsState.transform)

	local renderState
	if graphicsState.recording then
		renderState = { color = {} }
	else
		renderState = graphicsState.renderStates[index]
		if not renderState then
			renderState = { color = {} }
			graphicsState.renderStates[index] = renderState
		end
	end

	renderState.color[1], renderState.color[2], renderState.color[3], renderState.color[4] = love.graphics.getColor()
	renderState.font = love.graphics.getFont()
	renderState.lineHeight = love.graphics.getFont():getLineHeight()
	renderState.lineWidth = love.graphics.getLineWidth()
	renderState.lineStyle = love.graphics.getLineStyle()
	renderState.transform = transform

	return renderState
end

function itsyrealm.graphics.impl.setRenderState(renderState)
	love.graphics.setColor(renderState.color)
	love.graphics.setLineWidth(renderState.lineWidth)
	love.graphics.setLineStyle(renderState.lineStyle)
	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
end

function itsyrealm.graphics.impl.line(...)
	love.graphics.setBlendMode("alpha")
	love.graphics.line(...)
end

function itsyrealm.graphics.impl.rectangle(...)
	love.graphics.setBlendMode("alpha")
	love.graphics.rectangle(...)
end

function itsyrealm.graphics.impl.circle(...)
	love.graphics.setBlendMode("alpha")
	love.graphics.circle(...)
end

function itsyrealm.graphics.impl.arc(...)
	love.graphics.setBlendMode("alpha")
	love.graphics.arc(...)
end

function itsyrealm.graphics.impl.polygon(...)
	love.graphics.setBlendMode("alpha")
	love.graphics.polygon(...)
end

function itsyrealm.graphics.impl.drawItemIcon(width, height, icon, count, color, note, disabled)
	local scaleX, scaleY
	local x, y
	local originX, originY
	do
		scaleX = width / icon:getWidth()
		scaleY = height / icon:getHeight()
		x, y = width / 2 * scaleX, height / 2 * scaleY
		originX = width / 2
		originY = height / 2
	end

	local itemScaleX, itemScaleY = scaleX, scaleY
	if note then
		itemScaleX = scaleX * 0.8
		itemScaleY = scaleY * 0.8

		love.graphics.draw(
			note,
			originX, originY,
			0,
			scaleX, scaleY,
			originX, originY)
	end

	local r, g, b, a = love.graphics.getColor()

	if disabled then
		love.graphics.setColor(0.3, 0.3, 0.3, a)
	else
		love.graphics.setColor(1, 1, 1, a)
	end

	love.graphics.draw(icon, x, y, 0, itemScaleX, itemScaleY, originX, originY)

	if count ~= "1" then
		local textWidth = love.graphics.getFont():getWidth(count)

		local x = width - textWidth - 2
		local y = 2

		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.print(count, x - 2, y - 2, 0, scaleX, scaleY)
		love.graphics.print(count, x + 2, y - 2, 0, scaleX, scaleY)
		love.graphics.print(count, x - 2, y + 2, 0, scaleX, scaleY)
		love.graphics.print(count, x + 2, y + 2, 0, scaleX, scaleY)

		love.graphics.setColor(unpack(color))
		love.graphics.print(count, x, y, 0, scaleX, scaleY)
	end

	love.graphics.setColor(r, g, b, a)
end

function itsyrealm.graphics.impl.newItemIcon(width, height, ...)
	local canvas = love.graphics.newCanvas(width, height)

	love.graphics.push("all")
	love.graphics.origin()
	love.graphics.setCanvas(canvas)
	love.graphics.origin()
	love.graphics.setScissor()
	love.graphics.setColor(1, 1, 1, 1)

	itsyrealm.graphics.impl.drawItemIcon(width, height, ...)

	love.graphics.pop()

	local image = love.graphics.newImage(canvas:newImageData())
	canvas:release()

	return image
end

function itsyrealm.graphics.impl.drawItem(renderState, handle, active)
	local atlas = graphicsState.atlas:getTexture()
	local layer = graphicsState.atlas:layer(handle)
	local atlasQuad = graphicsState.atlas:quad(handle)

	local alpha
	if active then
		alpha = math.min(math.abs(math.sin(love.timer.getTime() * math.pi + math.pi / 4)) * 1.75, 1)
	else
		alpha = 1
	end

	local r, g, b, a = unpack(renderState.color)
	love.graphics.setColor(r, g, b, a * alpha)

	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
	love.graphics.drawLayer(atlas, layer, atlasQuad)
end

function itsyrealm.graphics.impl.drawq(renderState, image, quad, ...)
	local atlas = graphicsState.atlas:getTexture()
	local layer = graphicsState.atlas:layer(image)
	local atlasQuad = graphicsState.atlas:quad(image)

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

	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
	love.graphics.setColor(renderState.color)
	love.graphics.drawLayer(atlas, layer, graphicsState.quad, ...)
end

function itsyrealm.graphics.impl.draw(renderState, image, ...)
	local atlas = graphicsState.atlas:getTexture()
	local layer = graphicsState.atlas:layer(image)
	local atlasQuad = graphicsState.atlas:quad(image)

	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
	love.graphics.setColor(renderState.color)
	love.graphics.drawLayer(atlas, layer, atlasQuad, ...)
end

function itsyrealm.graphics.impl.drawCallback(renderState, func, ...)
	love.graphics.setColor(renderState.color)
	love.graphics.setBlendMode("alpha")
	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
	func(...)
end

function itsyrealm.graphics.impl.uncachedDraw(renderState, image, ...)
	love.graphics.setColor(renderState.color)
	love.graphics.setBlendMode("alpha")
	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
	love.graphics.draw(image, ...)
end

function itsyrealm.graphics.impl.uncachedDrawLayer(renderState, image, ...)
	love.graphics.setColor(renderState.color)
	love.graphics.setBlendMode("alpha")
	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
	love.graphics.drawLayer(image, ...)
end

function itsyrealm.graphics.impl.print(renderState, text, ...)
	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
	love.graphics.setFont(renderState.font)
	love.graphics.setColor(renderState.color)
	local oldLineHeight = renderState.font:getLineHeight()
	renderState.font:setLineHeight(renderState.lineHeight)
	love.graphics.setBlendMode("alpha")
	love.graphics.print(text, ...)
	renderState.font:setLineHeight(oldLineHeight)
end

function itsyrealm.graphics.impl.printf(renderState, text, ...)
	love.graphics.origin()
	love.graphics.applyTransform(renderState.transform)
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

function itsyrealm.graphics.impl.noOp()
	-- Nothing; it's a no-op.
end

function itsyrealm.graphics.dirty()
	graphicsState.atlas:dirty()
end

function itsyrealm.graphics.replay(replay)
	assert(not graphicsState.recording, "cannot replay while recording")
	for _, r in ipairs(replay) do
		if r.immediate then
			r.command(unpack(r, 1, r.n))
		else
			itsyrealm.graphics.impl.push(r.command, unpack(r, 1, r.n))
		end
	end
end

function itsyrealm.graphics.startRecording()
	assert(not graphicsState.recording, "already recording")
	graphicsState.recording = {}

	return graphicsState.recording
end

function itsyrealm.graphics.stopRecording()
	assert(graphicsState.recording, "not recording")
	graphicsState.recording = nil
end

itsyrealm.graphics.disabled = {}

function itsyrealm.graphics.disable()
	if not graphicsState.isDisabled then
		for key, value in pairs(itsyrealm.graphics) do
			local l = love.graphics[key]
			if type(value) == 'function' then
				if l then
					itsyrealm.graphics[key] = l
					Log.engine(
						"Replaced `itsyrealm.graphics.%s` with `love.graphics.%s`.",
						key, key)
				else
					itsyrealm.graphics[key] = itsyrealm.graphics.disabled[key] or itsyrealm.graphics.impl.noOp
					Log.engine(
						"Poofed `itsyrealm.graphics.%s` (no-op = %s).",
						key, Log.boolean(itsyrealm.graphics[key] == itsyrealm.graphics.impl.noOp))
				end
			end
		end

		graphicsState.isDisabled = true
	else
		Log.info("Advanced UI caching already disabled.")
	end
end

function itsyrealm.graphics.start()
	graphicsState.time = graphicsState.time + love.timer.getDelta()

	graphicsState.transform:reset()
end

function itsyrealm.graphics.debug()
	love.graphics.push("all")
	love.graphics.scale(0.5, 0.5)

	local cellSize = graphicsState.atlas:getCellSize()

	love.graphics.setColor(1, 1, 1, 1)
	for i = 1, #graphicsState.atlas.layers do
		if i <= 10 and love.keyboard.isDown(tostring(i - 1)) then
			love.graphics.rectangle("fill", 0, 0, graphicsState.atlas:getWidth(), graphicsState.atlas:getWidth())

			for j = 1, #graphicsState.atlas.layers[i].rectangles do
				if graphicsState.atlas.layers[i].rectangles[j].image then
					love.graphics.draw(
						graphicsState.atlas.layers[i].rectangles[j].image:getTexture(),
						graphicsState.atlas.layers[i].rectangles[j].i * cellSize,
						graphicsState.atlas.layers[i].rectangles[j].j * cellSize)
				end
			end

			for j = 1, #graphicsState.atlas.layers[i].rectangles do
				local isCollision = false

				for k = 1, #graphicsState.atlas.layers[i].rectangles do
					local a = graphicsState.atlas.layers[i].rectangles[j]
					local b = graphicsState.atlas.layers[i].rectangles[k]

					if a ~= b and a.i + a.width > b.i and a.i < b.i + b.width and a.j + a.height > b.j and a.j < b.j + b.height then
						isCollision = true
					end
				end

				if graphicsState.atlas.layers[i].rectangles[j].image then
					love.graphics.setColor(1, 1, 1, 1)
					love.graphics.draw(
						graphicsState.atlas.layers[i].rectangles[j].image:getTexture(),
						graphicsState.atlas.layers[i].rectangles[j].i * cellSize,
						graphicsState.atlas.layers[i].rectangles[j].j * cellSize)

					love.graphics.push("all")
					love.graphics.setColor(0, 0, 0, 1)
					love.graphics.scale(2, 2)
					love.graphics.print(
						string.format("%.2f", itsyrealm.graphics.getTime() - graphicsState.atlas.layers[i].rectangles[j].image.time),
						graphicsState.atlas.layers[i].rectangles[j].i * cellSize / 2,
						graphicsState.atlas.layers[i].rectangles[j].j * cellSize / 2)
					love.graphics.pop()
				end

				if isCollision then
					love.graphics.setColor(1, 0, 0, 1)
					love.graphics.setLineWidth(4)
				else
					love.graphics.setColor(0, 1, 0, 0.25)
					love.graphics.setLineWidth(1)
				end

				love.graphics.rectangle(
					"line",
					graphicsState.atlas.layers[i].rectangles[j].i * cellSize,
					graphicsState.atlas.layers[i].rectangles[j].j * cellSize,
					graphicsState.atlas.layers[i].rectangles[j].width * cellSize,
					graphicsState.atlas.layers[i].rectangles[j].height * cellSize)

				isCollision = false
			end
		end
	end

	love.graphics.pop()
end

local function isSizeBlocking(currentSize, otherSize)
	if currentSize.handle == otherSize.handle then
		return false
	end

	if currentSize.force or otherSize.force then
		return true
	end

	if currentSize.x + currentSize.width > otherSize.x and
	   currentSize.x < otherSize.x + otherSize.width and
	   currentSize.y + currentSize.height > otherSize.y and
	   currentSize.y < otherSize.y + otherSize.height
	then
		return true
	end

	return false
end

function itsyrealm.graphics.shouldFlush(nextSize)
	for _, currentSizes in pairs(graphicsState.currentSizes) do
		for _, otherSizes in pairs(graphicsState.currentSizes) do
			if currentSizes ~= otherSizes then
				for i, currentSize in ipairs(currentSizes.values) do
					if type(nextSize.handle) ~= "userdata" and isSizeBlocking(currentSize, nextSize) then
						return true
					end

					for j, otherSize in ipairs(otherSizes.values) do
						if isSizeBlocking(currentSize, otherSize) then
							return true
						end
					end
				end
			end
		end
	end

	return false
end

function itsyrealm.graphics.flush()
	for _, handle in ipairs(graphicsState.pendingSizes) do
		if type(handle) == "userdata" and handle.type then
			local type = handle:type()
			if itsyrealm.graphics.flushes[type] then
				itsyrealm.graphics.flushes[type].flush(handle)
			end
		end
	end

	for handle, size in pairs(graphicsState.currentSizes) do
		table.clear(size.values)
		graphicsState.oldSizes[handle] = size
	end

	table.clear(graphicsState.currentSizes)
	table.clear(graphicsState.pendingSizes)
end

function itsyrealm.graphics.impl.addSizeToQueue(handle)
	if not graphicsState.currentSizes[handle] then
		graphicsState.currentSizes[handle] = graphicsState.oldSizes[handle] or { values = {} }
		table.insert(graphicsState.pendingSizes, handle)

		return 1
	end

	return 0
end

function itsyrealm.graphics.queue(size, ...)
	local type = size:type()
	if itsyrealm.graphics.flushes[type] then
		itsyrealm.graphics.flushes[type].queue(...)
	end
end

itsyrealm.graphics.flushes = { Font = {} }

itsyrealm.graphics.flushes.Font.recolorCache = {}
itsyrealm.graphics.flushes.Font.recolorResult = {}

function itsyrealm.graphics.flushes.Font.recolor(text, color)
	local cache = itsyrealm.graphics.flushes.Font.recolorCache
	local result = itsyrealm.graphics.flushes.Font.recolorResult
	table.clear(result)

	local r, g, b, a = unpack(color)
	for i = 1, #text, 2 do
		local c = cache[i] or {}
		cache[i] = c

		c[1] = (text[i][1] or 1) * (r or 1)
		c[2] = (text[i][2] or 1) * (g or 1)
		c[3] = (text[i][3] or 1) * (b or 1)
		c[4] = (text[i][4] or 1) * (a or 1)

		result[i] = c
		result[i + 1] = text[i + 1]
	end

	return result
end

function itsyrealm.graphics.flushes.Font.getBatch(handle)
	local pending = graphicsState.currentSizes[handle]
	if pending then
		if not pending.batch then
			pending.batch = love.graphics.newText(handle)
		end

		return pending.batch
	end

	return nil
end

local _queuePrintColor = {}
function itsyrealm.graphics.flushes.Font.queuePrint(size, renderState, text, x, y, angle, sx, sy, ...)
	local _, _, scaleX, scaleY, paddingX, paddingY = love.graphics.getScaledMode()
	local batch = itsyrealm.graphics.flushes.Font.getBatch(size.handle)
	if batch then
		local oldLineHeight = batch:getFont():getLineHeight()
		batch:getFont():setLineHeight(renderState.lineHeight)
		if type(text) == "string" then
			_queuePrintColor[1] = renderState.color
			_queuePrintColor[2] = text
			batch:add(_queuePrintColor, size.x, size.y, angle, (sx or 1) * scaleX, (sy or 1) * scaleY, ...)
		else
			batch:add(itsyrealm.graphics.flushes.Font.recolor(text, renderState.color), size.x, size.y, angle, (sx or 1) * scaleX, (sy or 1) * scaleY, ...)
		end
		batch:getFont():setLineHeight(oldLineHeight)
	end
end

function itsyrealm.graphics.flushes.Font.queuePrintF(size, renderState, text, x, y, limit, align, angle, sx, sy, ...)
	local _, _, scaleX, scaleY, paddingX, paddingY = love.graphics.getScaledMode()
	local batch = itsyrealm.graphics.flushes.Font.getBatch(size.handle)
	if batch then
		local oldLineHeight = batch:getFont():getLineHeight()
		batch:getFont():setLineHeight(renderState.lineHeight)
		if type(text) == "string" then
			_queuePrintColor[1] = renderState.color
			_queuePrintColor[2] = text
			batch:addf(_queuePrintColor, limit, align or "left", size.x, size.y, angle, (sx or 1) * scaleX, (sy or 1) * scaleY, ...)
		else
			batch:addf(itsyrealm.graphics.flushes.Font.recolor(text, renderState.color), limit, align or "left", size.x, size.y, angle, (sx or 1) * scaleX, (sy or 1) * scaleY, ...)
		end
		batch:getFont():setLineHeight(oldLineHeight)
	end
end

function itsyrealm.graphics.flushes.Font.queue(size, command, ...)
	if command == itsyrealm.graphics.impl.print then
		itsyrealm.graphics.flushes.Font.queuePrint(size, ...)
	elseif command == itsyrealm.graphics.impl.printf then
		itsyrealm.graphics.flushes.Font.queuePrintF(size, ...)
	end
end

function itsyrealm.graphics.flushes.Font.flush(handle)
	local batch = itsyrealm.graphics.flushes.Font.getBatch(handle)

	if batch then
		love.graphics.push("all")
		love.graphics.origin()
		love.graphics.setBlendMode('alpha')
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(batch)
		love.graphics.pop()
		batch:clear()
	end
end

function itsyrealm.graphics.stop()
	graphicsState.atlas:update()

	love.graphics.push('all')

	local defaultHandle = "*"
	local previousHandle, currentHandle

	local currentNumSizes = 0
	local toFlush = {}
	for i = 1, graphicsState.drawQueue.n do
		local draw = graphicsState.drawQueue[i]
		local size = graphicsState.sizes[i]

		local shouldFlush = false
		if size and size.handle ~= nil then
			local handle = size.handle or defaultHandle

			previousHandle = currentHandle
			currentHandle = handle

			if not graphicsState.currentSizes[handle] then
				currentNumSizes = currentNumSizes + 1
				graphicsState.currentSizes[handle] = graphicsState.oldSizes[handle] or { values = {} }
				table.insert(graphicsState.pendingSizes, handle)
			end

			if currentNumSizes > 1 then
				if size.force or (previousHandle ~= currentHandle and itsyrealm.graphics.shouldFlush(size)) then
					shouldFlush = true
				end
			end

			table.insert(graphicsState.currentSizes[handle].values, size)
		end

		if type(currentHandle) == "userdata" and size then
			itsyrealm.graphics.queue(currentHandle, size, draw.command, unpack(draw, 1, draw.n))
		else
			if shouldFlush then
				itsyrealm.graphics.flush()
				currentNumSizes = 0

				shouldFlush = false
			end

			love.graphics.setBlendMode('alpha')
			draw.command(unpack(draw, 1, draw.n))
		end

		if shouldFlush then
			itsyrealm.graphics.flush()
			currentNumSizes = 0
		end

		if size then
			table.insert(graphicsState.seenSizes, size)
		end
	end
	itsyrealm.graphics.flush()

	graphicsState.drawQueue.n = 0
	love.graphics.pop()

	for _, size in ipairs(graphicsState.seenSizes) do
		table.clear(size)
	end
	table.clear(graphicsState.seenSizes)

	if _DEBUG then
		itsyrealm.graphics.debug()
	end
end

function itsyrealm.graphics.clearPseudoScissor()
	local w, h = love.window.getMode()

	graphicsState.pseudoScissor.n = 1
	graphicsState.pseudoScissor[1][1] = 0
	graphicsState.pseudoScissor[1][2] = 0
	graphicsState.pseudoScissor[1][3] = w
	graphicsState.pseudoScissor[1][4] = h

	graphicsState.appliedPseudoScissor.n = 0
end

function itsyrealm.graphics.pushInterface(width, height)
	if width > 0 and height > 0 then
		itsyrealm.graphics.impl.pushSize(nil, 0, 0, width, height)
		itsyrealm.graphics.impl.push(itsyrealm.graphics.impl.noOp)
	end
end

function itsyrealm.graphics.impl.pushSize(handle, x, y, width, height, scaleX, scaleY, transform)
	if graphicsState.recording then
		table.insert(graphicsState.recording, {
			command = itsyrealm.graphics.impl.pushSize,
			immediate = true,

			n = 8,
			handle,
			x,
			y,
			width,
			height,
			scaleX,
			scaleY,
			transform
		})

		return
	end

	transform = transform == nil and true or false

	scaleX = scaleX or 1
	scaleY = scaleY or 1

	local index = graphicsState.drawQueue.n + 1
	local size = graphicsState.sizes[index]

	if not size then
		size = {}
		graphicsState.sizes[index] = size
	end

	graphicsState.sizeTransform:reset()
	if transform then
		graphicsState.sizeTransform:apply(graphicsState.transform)
	end

	size.handle = handle or false
	if x and y and width and height then
		local tX1, tY1 = graphicsState.sizeTransform:transformPoint(x, y)
		local tX2, tY2 = graphicsState.sizeTransform:transformPoint(x + width * scaleX, y + height * scaleY)

		size.x = tX1
		size.y = tY1
		size.width = tX2 - tX1
		size.height = tY2 - tY1
		size.force = false
	else
		size.x = -math.huge
		size.y = -math.huge
		size.width = math.huge
		size.height = math.huge
		size.force = true
	end

	return size
end

function itsyrealm.graphics.impl.push(command, ...)
	if graphicsState.drawQueue.n < #graphicsState.drawQueue then
		local n = graphicsState.drawQueue.n + 1
		local q = graphicsState.drawQueue[n]

		table.clear(q)

		q.command = command
		q.n = select('#', ...)
		for i = 1, q.n do
			q[i] = select(i, ...)
		end

		graphicsState.drawQueue.n = n
	else
		table.insert(
			graphicsState.drawQueue,
			{
				command = command,
				n = select('#', ...),
				...
			})

		graphicsState.drawQueue.n = graphicsState.drawQueue.n + 1
	end

	if graphicsState.recording then
		table.insert(
			graphicsState.recording,
			{
				command = command,
				n = select('#', ...),
				...
			})
	end
end

function itsyrealm.graphics.resetPseudoScissor()
	graphicsState.appliedPseudoScissor.n = graphicsState.appliedPseudoScissor.n - 1
	assert(graphicsState.appliedPseudoScissor.n >= 0, "unbalanced pseudo scissor stack")

	table.remove(graphicsState.appliedPseudoScissor)

	if graphicsState.appliedPseudoScissor.n > 0 then
		itsyrealm.graphics.impl.pushSize()
		itsyrealm.graphics.impl.push(
			itsyrealm.graphics.impl.setScissor,
			unpack(graphicsState.appliedPseudoScissor[#graphicsState.appliedPseudoScissor]))
	else
		local w, h = love.window.getMode()
		itsyrealm.graphics.impl.pushSize()
		itsyrealm.graphics.impl.push(
			itsyrealm.graphics.impl.setScissor,
			0, 0, w, h)
	end
end

function itsyrealm.graphics.intersectPseudoScissor(x, y, w, h)
	if graphicsState.pseudoScissor.n == 0 then
		Log.error("Can't apply pseudo scissor: stack is empty.")
		return
	end

	local pseudoScissor = graphicsState.pseudoScissor[graphicsState.pseudoScissor.n]
	local x1 = math.max(pseudoScissor[1], x)
	local y1 = math.max(pseudoScissor[2], y)
	local x2 = math.min(
		pseudoScissor[1] + pseudoScissor[3],
		x + w)
	local y2 = math.min(
		pseudoScissor[2] + pseudoScissor[4],
		y + h)

	graphicsState.pseudoScissor.n = graphicsState.pseudoScissor.n + 1

	local newPseudoScissor = graphicsState.pseudoScissor[graphicsState.pseudoScissor.n] or {}
	newPseudoScissor[1] = x1
	newPseudoScissor[2] = y1
	newPseudoScissor[3] = math.max(0, x2 - x1)
	newPseudoScissor[4] = math.max(0, y2 - y1)

	graphicsState.pseudoScissor[graphicsState.pseudoScissor.n] = newPseudoScissor
end

function itsyrealm.graphics.popPseudoScissor()
	graphicsState.pseudoScissor.n = graphicsState.pseudoScissor.n - 1
end

function itsyrealm.graphics.applyPseudoScissor()
	table.insert(graphicsState.appliedPseudoScissor, graphicsState.pseudoScissor[graphicsState.pseudoScissor.n])
	graphicsState.appliedPseudoScissor.n = graphicsState.appliedPseudoScissor.n + 1

	itsyrealm.graphics.impl.pushSize()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setScissor,
		unpack(graphicsState.pseudoScissor[graphicsState.pseudoScissor.n]))
end

function itsyrealm.graphics.getPseudoScissor()
	return unpack(graphicsState.pseudoScissor[graphicsState.pseudoScissor.n])
end

function itsyrealm.graphics.getPseudoScissorN()
	return graphicsState.pseudoScissor.n
end

function itsyrealm.graphics.drawItem(handle, width, height, icon, itemID, count, color, note, disabled, active)
	local key = string.format(
		"%s_%dx%d_%s_%s_%s",
		itemID,
		width,
		height,
		count,
		Log.boolean(note),
		Log.boolean(disabled))

	if not graphicsState.atlas:has(handle) then
		graphicsState.atlas:add(handle, itsyrealm.graphics.impl.newItemIcon(width, height, icon, count, color, note, disabled, active), key)
	elseif graphicsState.atlas:reset(handle, key) then
		graphicsState.atlas:replace(handle, itsyrealm.graphics.impl.newItemIcon(width, height, icon, count, color, note, disabled, active))
	else
		graphicsState.atlas:visit(handle)
	end

	itsyrealm.graphics.impl.pushSize(nil, 0, 0, width, height)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.drawItem,
		itsyrealm.graphics.impl.captureRenderState(),
		handle,
		active)
end

function itsyrealm.graphics.drawq(image, quad, x, y, rotation, scaleX, scaleY, ...)
	if graphicsState.atlas:has(image) then
		graphicsState.atlas:visit(image)
	else
		graphicsState.atlas:add(image)
	end

	local _, _, width, height = quad:getViewport()
	itsyrealm.graphics.impl.pushSize(nil, x, y, width, height, scaleX, scaleY)

	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.drawq,
		itsyrealm.graphics.impl.captureRenderState(),
		image,
		quad,
		x, y, rotation, scaleX, scaleY, ...)
end

function itsyrealm.graphics.draw(image, x, y, rotation, scaleX, scaleY, ...)
	if graphicsState.atlas:has(image) then
		graphicsState.atlas:visit(image)
	else
		graphicsState.atlas:add(image)
	end

	itsyrealm.graphics.impl.pushSize(nil, x, y, image:getWidth(), image:getHeight(), scaleX, scaleY)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.draw,
		itsyrealm.graphics.impl.captureRenderState(),
		image,
		x, y, rotation, scaleX, scaleY, ...)
end

function itsyrealm.graphics.line(...)
	itsyrealm.graphics.impl.pushSize()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.line, ...)
end

function itsyrealm.graphics.rectangle(style, x, y, w, h, ...)
	itsyrealm.graphics.impl.pushSize(nil, x, y, w, h)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.rectangle, style, x, y, w, h, ...)
end

function itsyrealm.graphics.circle(...)
	itsyrealm.graphics.impl.pushSize()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.circle, ...)
end

function itsyrealm.graphics.arc(...)
	itsyrealm.graphics.impl.pushSize()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.arc, ...)
end

function itsyrealm.graphics.polygon(...)
	itsyrealm.graphics.impl.pushSize()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.setRenderState,
		itsyrealm.graphics.impl.captureRenderState())
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.polygon, ...)
end

function itsyrealm.graphics.pushCallback(func, ...)
	itsyrealm.graphics.impl.pushSize()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.drawCallback,
		itsyrealm.graphics.impl.captureRenderState(),
		func, ...)
end

function itsyrealm.graphics.uncachedDraw(...)
	itsyrealm.graphics.impl.pushSize()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.uncachedDraw,
		itsyrealm.graphics.impl.captureRenderState(),
		...)
end

function itsyrealm.graphics.uncachedDrawLayer(...)
	itsyrealm.graphics.impl.pushSize()
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.uncachedDrawLayer,
		itsyrealm.graphics.impl.captureRenderState(),
		...)
end

function itsyrealm.graphics.print(text, x, y, rotation, scaleX, scaleY, ...)
	local font = love.graphics.getFont()
	local lineHeight = font:getLineHeight()
	local width, lines = font:getWrap(text, math.huge)

	itsyrealm.graphics.impl.pushSize(font, x, y, width, #lines * font:getHeight() * lineHeight, scaleX, scaleY)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.print,
		itsyrealm.graphics.impl.captureRenderState(),
		text,
		x, y, rotation, scaleX, scaleY, ...)
end

function itsyrealm.graphics.printf(text, x, y, limit, align, rotation, scaleX, scaleY, ...)
	local font = love.graphics.getFont()
	local lineHeight = font:getLineHeight()
	local width, lines = font:getWrap(text, limit)

	itsyrealm.graphics.impl.pushSize(font, x, y, width, #lines * font:getHeight() * lineHeight, scaleX, scaleY)
	itsyrealm.graphics.impl.push(
		itsyrealm.graphics.impl.printf,
		itsyrealm.graphics.impl.captureRenderState(),
		text,
		x, y, limit, align, rotation, scaleX, scaleY, ...)
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

itsyrealm.graphics.disabled.clearPseudoScissor = itsyrealm.graphics.clearPseudoScissor

function itsyrealm.graphics.disabled.drawItem(_, width, height, icon, id, ...)
	itsyrealm.graphics.impl.drawItemIcon(width, height, icon, ...)
end

function itsyrealm.graphics.disabled.resetPseudoScissor()
	local w, h = love.window.getMode()
	love.graphics.setScissor(0, 0, w, h)
end

itsyrealm.graphics.disabled.intersectPseudoScissor = itsyrealm.graphics.intersectPseudoScissor
itsyrealm.graphics.disabled.popPseudoScissor = itsyrealm.graphics.popPseudoScissor

function itsyrealm.graphics.disabled.applyPseudoScissor()
	love.graphics.setScissor(unpack(graphicsState.pseudoScissor[graphicsState.pseudoScissor.n]))
end

itsyrealm.graphics.disabled.getPseudoScissor = itsyrealm.graphics.getPseudoScissor

itsyrealm.graphics.disabled.drawq = love.graphics.draw
itsyrealm.graphics.disabled.uncachedDraw = love.graphics.draw
itsyrealm.graphics.disabled.uncachedDrawLayer = love.graphics.drawLayer

function UIView:new(gameView)
	self.game = gameView:getGame()
	self.gameView = gameView
	self.currentInputSchemes = {
		[
			_MOBILE and UIView.INPUT_SCHEME_MOUSE_KEYBOARD or UIView.INPUT_SCHEME_TOUCH
		] = true
	}

	self.currentInputScheme = _MOBILE and UIView.INPUT_SCHEME_MOUSE_KEYBOARD or UIView.INPUT_SCHEME_TOUCH

	local ui = self.game:getUI()
	ui.onOpen:register(self.open, self)
	ui.onClose:register(self.close, self)
	ui.onPoke:register(self.poke, self)

	self.controlManager = ControlManager(self)

	self.root = UIView.Root()
	self.root:setID("root")
	self.inputProvider = WidgetInputProvider(self.root)

	self.inputProvider.onBlur:register(self._onBlur, self)
	self.inputProvider.onFocus:register(self._onFocus, self)
	self.interfaceFocusStack = {}
	self.hasPendingInterfaceFocus = false

	self.resources = WidgetResourceManager()
	self.root:setData(WidgetResourceManager, self.resources)
	self.root:setData(UIView, self)

	self.renderManager = WidgetRenderManager(self.inputProvider)
	self.renderManager:addRenderer(Button, ButtonRenderer(self.resources))
	self.renderManager:addRenderer(DraggableButton, ButtonRenderer(self.resources))
	self.renderManager:addRenderer(DraggablePanel, PanelRenderer(self.resources))
	self.renderManager:addRenderer(Drawable, DrawableRenderer(self.resources))
	self.renderManager:addRenderer(Label, LabelRenderer(self.resources))
	self.renderManager:addRenderer(Icon, IconRenderer(self.resources))
	self.renderManager:addRenderer(ItemIcon, ItemIconRenderer(self.resources))
	self.renderManager:addRenderer(Panel, PanelRenderer(self.resources))
	self.renderManager:addRenderer(GamepadPokeMenu, PanelRenderer(self.resources))
	self.renderManager:addRenderer(RichTextLabel, RichTextLabelRenderer(self.resources))
	self.renderManager:addRenderer(SceneSnippet, SceneSnippetRenderer(self.resources, self.gameView))
	self.renderManager:addRenderer(ScrollBar.Button, ScrollButtonRenderer(self.resources))
	self.renderManager:addRenderer(ScrollBar.DragButton, ScrollButtonRenderer(self.resources))
	self.renderManager:addRenderer(SpellIcon, SpellIconRenderer(self.resources))
	self.renderManager:addRenderer(TextInput, TextInputRenderer(self.resources))
	self.renderManager:addRenderer(Texture, TextureRenderer(self.resources))
	self.renderManager:addRenderer(ToolTip, ToolTipRenderer(self.resources))
	self.renderManager:addRenderer(GamepadIcon, GamepadIconRenderer(self.resources))

	self.interfaces = {}

	self.pokeMenu = false

	self.keyBinds = {}

	self.pokes = {}

	self.uiState = {}
end

function UIView:restoreFocus(interface)
	if not interface then
		return
	end

	self:_removeFromFocusStack(interface)
	table.insert(self.interfaceFocusStack, math.max(#self.interfaceFocusStack, 1), interface)

	self.hasPendingInterfaceFocus = true
end

function UIView:_removeFromFocusStack(interface)
	for i = #self.interfaceFocusStack, 1, -1 do
		if self.interfaceFocusStack[i] == interface then
			table.remove(self.interfaceFocusStack, i)
		end
	end
end

function UIView:_onBlur(_, widget)
	local interface = widget:getParentOfType(Interface)
	if not interface or interface:getRootParent() ~= self.root then
		return
	end

	self:_removeFromFocusStack(interface)
	table.insert(self.interfaceFocusStack, math.max(#self.interfaceFocusStack, 1), interface)

	local top = self.interfaceFocusStack[#self.interfaceFocusStack]
	if top and top ~= interface then
		self.hasPendingInterfaceFocus = true
	end
end

function UIView:_onFocus(_, widget)
	local interface = widget:getParentOfType(Interface)
	if not interface or interface:getRootParent() ~= self.root then
		return
	end

	local wasFocused = self.interfaceFocusStack[#self.interfaceFocusStack] == interface

	self:_removeFromFocusStack(interface)
	table.insert(self.interfaceFocusStack, interface)

	if not wasFocused then
		Log.info("Interface '%s' (index %d) captured focus.", interface:getDebugInfo().shortName, #self.interfaceFocusStack)
	end

	self.hasPendingInterfaceFocus = false
end

function UIView:enableInputScheme(inputScheme)
	self.currentInputSchemes[inputScheme]= true
end

function UIView:disableInputScheme(inputScheme)
	self.currentInputSchemes[inputScheme]= nil
end

function UIView:hasInputScheme(inputScheme)
	return self.currentInputSchemes[inputScheme] == true
end

local VALID_INPUT_SCHEMES = {
	[UIView.INPUT_SCHEME_MOUSE_KEYBOARD] = true,
	[UIView.INPUT_SCHEME_TOUCH] = true,
	[UIView.INPUT_SCHEME_GAMEPAD] = true,
	[UIView.INPUT_SCHEME_GYRO] = true
}

function UIView:isInputSchemeValid(inputScheme)
	return VALID_INPUT_SCHEMES[inputScheme] == true
end

function UIView:getCurrentInputScheme()
	return self.currentInputScheme
end

function UIView:setCurrentInputScheme(value)
	if self:isInputSchemeValid(value) then
		self:enableInputScheme(value)
		self.currentInputScheme = value
	end
end

function UIView:pull(interfaceID, interfaceIndex)
	local interfaces = self.uiState[interfaceID]
	if not interfaces then
		interfaces = {}
		self.uiState[interfaceID] = interfaces
	end

	local state = interfaces[interfaceIndex]
	if not state then
		state = self.game:getUI():pull(interfaceID, interfaceIndex)
		interfaces[interfaceIndex] = state
	end

	return state or {}
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

function UIView:getInterface(interfaceID, index)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		index = index or next(interfaces)
		if index then
			return interfaces[index]
		end
	end

	return nil
end

function UIView:open(ui, interfaceID, index)
	local TypeName = string.format("ItsyScape.UI.Interfaces.%s", interfaceID)
	local Type = require(TypeName)

	local interfaces = self.interfaces[interfaceID] or {}
	local interface = Type(interfaceID, index, self)
	interfaces[index] = interface
	self.interfaces[interfaceID] = interfaces

	self.root:addChild(interface)
	interface:attach()
end

function UIView:close(ui, interfaceID, index)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		local interface = interfaces[index]
		if interface then
			interface:onClose()

			self.root:removeChild(interface)
			interfaces[index] = nil

			if self.interfaceFocusStack[#self.interfaceFocusStack] == interface then
				self.hasPendingInterfaceFocus = true
			end

			self:_removeFromFocusStack(interface)
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

function UIView:keyDown(...)
	self.inputProvider:keyDown(...)
	self.controlManager:keyDown(...)
end

function UIView:keyUp(...)
	self.inputProvider:keyUp(...)
	self.controlManager:keyUp(...)
end

function UIView:type(...)
	self.inputProvider:type(...)
end

function UIView:joystickAdd(...)
	self.inputProvider:joystickAdd(...)
	self.controlManager:joystickAdd(...)
end

function UIView:joystickRemove(...)
	self.inputProvider:joystickRemove(...)
	self.controlManager:joystickRemove(...)
end

function UIView:gamepadRelease(...)
	self.inputProvider:gamepadRelease(...)
	self.controlManager:gamepadRelease(...)
end

function UIView:gamepadAxis(...)
	self.inputProvider:gamepadAxis(...)
	self.controlManager:gamepadAxis(...)
end

function UIView:mousePress(...)
	self.inputProvider:mousePress(...)
end

function UIView:mouseScroll(...)
	self.inputProvider:mouseScroll(...)
end

function UIView:mouseRelease(...)
	self.inputProvider:mouseRelease(...)
end

function UIView:mouseMove(...)
	self.inputProvider:mouseMove(...)
end

function UIView:touchPress(...)
	-- Nothing.
end

function UIView:touchRelease(...)
	-- Nothing.
end

function UIView:touchMove(...)
	-- Nothing.
end

function UIView:_layoutToolTip(widget, toolTip)
	local absoluteX, absoluteY = widget:getAbsolutePosition()
	local widgetWidth, widgetHeight = widget:getSize()
	local toolTipWidth, toolTipHeight = toolTip:getSize()
	toolTip:setPosition(absoluteX - toolTipWidth / 2, absoluteY + widgetHeight / 2)
end

local function _sortItemStats(a, b)
	return a.value > b.value
end

local function _match(a, b, pattern)
	if pattern or pattern == nil then
		return a:match(b)
	end

	return a == b
end

function UIView:_getItemSoundEffectFilename(itemState, itemActionState)
	local soundEffects = Config.get("SoundEffects", "SFX", "category", "item", "_", {})

	if not (itemState and itemActionState) then
		return nil
	end

	local gameDB = self.game:getGameDB()
	local itemRecord = gameDB:getResource(itemState.id, "Item")
	local lootCategoryID = itemRecord and gameDB:getRecord("LootCategory", { Item = itemRecord })
	lootCategoryID = lootCategoryID and lootCategoryID:get("Category").name
	local equipRecord = itemRecord and gameDB:getRecord("Equipment", { Resource = itemRecord })
	local equipSlot = equipRecord and equipRecord:get("EquipSlot")

	local equipmentStats = {}
	if itemState.stats then
		for _, stat in ipairs(itemState.stats) do
			table.insert(equipmentStats, stat)
		end
	elseif equipRecord then
		for _, statName in ipairs(Equipment.STATS) do
			table.insert(equipmentStats, { name = statName, value = equipRecord:get(statName) or 0 })
		end
	end

	local actionConstraints
	do
		local action = Mapp.Action()
		if itemActionState.id >= 1 and gameDB:getBrochure():tryGetAction(Mapp.ID(itemActionState.id), action) then
			actionConstraints = Utility.getActionConstraints(self.game, action)
		else
			actionConstraints = { requirements = {}, inputs = {}, outputs = {} }
		end
	end


	local soundEffectFilename
	for _, soundEffect in ipairs(soundEffects) do
		if not soundEffect.match or #soundEffect.match == 0 then
			soundEffectFilename = soundEffect.filename
			break
		end

		for _, match in ipairs(soundEffect.match) do
			local hasAllRequirements = true

			for _, requirement in ipairs(match) do
				if requirement.resourceID then
					if not _match(itemState.id, requirement.resourceID, requirement.pattern) then
						hasAllRequirements = false
						break
					end
				end

				if requirement.actionType then
					if not _match(itemActionState.type, requirement.actionType, requirement.pattern) then
						hasAllRequirements = false
						break
					end
				end

				if requirement.lootCategoryID then
					if not lootCategoryID or not _match(lootCategoryID, requirement.lootCategoryID, requirement.pattern) then
						hasAllRequirements = false
						break
					end
				end

				if requirement.requirementResourceID or requirement.requirementResourceType then
					local hasConstraint = false
					for _, requirementConstraint in ipairs(actionConstraints.requirements) do
						if (not requirement.requirementResourceID or _match(requirementConstraint.resource, requirement.requirementResourceID, requirement.pattern)) and
						   (not requirement.requirementResourceType or _match(requirementConstraint.type, requirement.requirementResourceType, requirement.pattern))
						then
							hasConstraint = true
							break
						end
					end

					if not hasConstraint then
						hasAllRequirements = false
						break
					end
				end

				if requirement.equipmentSlots then
					local hasSlot = false
					for _, requiredSlot in ipairs(requirement.equipmentSlots) do
						local requiredSlotIndex
						do
							local requiredSlotFullName = string.format("PLAYER_SLOT_%s", requiredSlot)
							for i, slot in pairs(Equipment.PLAYER_SLOT_NAMES) do
								if slot == requiredSlotFullName then
									requiredSlotIndex = i
									break
								end
							end
						end

						if requiredSlotIndex and requiredSlotIndex == equipSlot then
							hasSlot = true
							break
						end
					end

					if not hasSlot then
						hasAllRequirements = false
						break
					end
				end

				if requirement.maxEquipmentStat then
					local hasStat = false

					for i = 1, #equipmentStats do
						if i > 1 and equipmentStats[i - 1].value > equipmentStats[i].value then
							break
						end

						if equipmentStats[i].name == requirement.maxEquipmentStat then
							hasStat = true
							break
						end
					end

					if not hasStat then
						hasAllRequirements = false
						break
					end
				end
			end

			if hasAllRequirements then
				soundEffectFilename = soundEffect.filename
				break
			end
		end

		if soundEffectFilename then
			break
		end
	end

	return soundEffectFilename
end

function UIView:playItemSoundEffect(itemState, itemActionState)
	local soundEffects = Config.get("SoundEffects", "SFX", "category", "item", "_", {})
	local roots = Config.get("SoundEffects", "ROOTS", "category", "item", "_", {})
	local minPitch = Config.get("SoundEffects", "MIN_PITCH", "category", "item", "_", 0.8)
	local maxPitch = Config.get("SoundEffects", "MIN_PITCH", "category", "item", "_", 1.0)

	local soundEffectFilename = self:_getItemSoundEffectFilename(itemState, itemActionState)
	if not soundEffectFilename then
		soundEffectFilename = soundEffects[#soundEffects] and soundEffects[#soundEffects].filename
	end	

	if soundEffectFilename then
		for _, root in ipairs(roots) do
			local filename = string.format("%s/%s", root, soundEffectFilename)

			if love.filesystem.getInfo(filename) then
				local sound = love.audio.newSource(filename, "static")
				sound:setVolume((_CONF.soundEffectsVolume or 1) * (_CONF.volume or 1))
				sound:setPitch(love.math.random() * (maxPitch - minPitch) + minPitch)
				sound:play()
				
				return true
			end
		end
	end

	return false
end

function UIView:examine(a, b, w)
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

		description = { description }
	end

	local player = self:getGame():getPlayer()
	if player then
		if type(description) == "string" then
			player:addExclusiveChatMessage(description)
		elseif description[1] and description[1].text then
			player:addExclusiveChatMessage(description[1].text)
		end
	end

	if not Class.isCompatibleType(object, ToolTip.Component) then
		object = ToolTip.Header(object, {
			shadow = true,
			color = Color(1, 1, 1)
		})
	end

	if type(description) == "string" then
		description = {
			ToolTip.Text(description, {
				shadow = true,
				color = Color(1, 1, 1)
			})
		}
	end

	local toolTip = self.renderManager:setToolTip(
		math.max(#description + 3, 4), 
		object,
		unpack(description))

	if not _MOBILE then
		toolTip:setStyle(PanelStyle({
			image = "Resources/Game/UI/Panels/ToolTip.png"
		}, self.resources))
	end

	if w then
		toolTip.onLayout:register(self._layoutToolTip, self, w)
	end

	return toolTip
end

function UIView:probe(actions, x, y, centerX, centerY)
	self:closePokeMenu()

	self.pendingPokeMenu = GamepadPokeMenu(self, actions)
	do
		local windowWidth, windowHeight, _, _, offsetX, offsetY = love.graphics.getScaledMode()
		local menuWidth, menuHeight = self.pendingPokeMenu:getSize()
		local mouseX, mouseY = itsyrealm.graphics.getScaledPoint(itsyrealm.mouse.getPosition())
		mouseX = x or mouseX
		mouseY = y or mouseY

		if centerX then
			local pokeMenuWidth = self.pendingPokeMenu:getSize()
			mouseX = mouseX - pokeMenuWidth / 2
		end

		if centerY then
			local _, pokeMenuHeight = self.pendingPokeMenu:getSize()
			mouseY = mouseY - pokeMenuHeight / 2
		end

		mouseX = mouseX - offsetX
		mouseY = mouseY - offsetY

		local menuX = mouseX - GamepadPokeMenu.PADDING
		local menuY = mouseY - GamepadPokeMenu.PADDING

		if menuX + menuWidth > windowWidth then
			local difference = menuX + menuWidth - windowWidth
			menuX = menuX - difference
		end

		if menuY + menuHeight > windowHeight then
			local difference = menuY + menuHeight - windowHeight
			menuY = menuY - difference
		end

		self.pendingPokeMenu:setPosition(
			menuX,
			menuY)

		self.pendingPokeMenu.onClose:register(self._onPokeMenuClosed, self)

		self.root:addChild(self.pendingPokeMenu)
	end

	self.previousFocusedWidget = self.inputProvider:getFocusedWidget()
	self.inputProvider:setFocusedWidget(self.pendingPokeMenu, "select")

	return self.pendingPokeMenu
end

function UIView:_onPokeMenuClosed(pokeMenu)
	if self.pokeMenu == pokeMenu and self.previousFocusedWidget then
		self.inputProvider:setFocusedWidget(self.previousFocusedWidget, "select")
		self.previousFocusedWidget = nil
	end

	if self.pendingPokeMenu == pokeMenu then
		self.pendingPokeMenu = nil
	end
end

function UIView:isPokeMenu(widget)
	if self.pokeMenu then
		return self.pokeMenu == widget or self.pokeMenu:isParentOf(widget)
	end

	return false
end

function UIView:closePokeMenu()
	if self.pokeMenu then
		self.pokeMenu:close()
		self.pokeMenu = false
	end
end

function UIView:focus(widget, reason)
	self.inputProvider:setFocusedWidget(widget, reason)
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

function UIView:tick()
	self.uiState = {}

	for _, interfaces in pairs(self.interfaces) do
		for _, interface in pairs(interfaces) do
			interface:tick()
		end
	end
end

function UIView:update(delta)
	self.inputProvider:update(delta)

	if self.pendingPokeMenu then
		self.pokeMenu = self.pendingPokeMenu
		self.pendingPokeMenu = nil
	end

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

	if _MOBILE then
		local focusedWidget = self.inputProvider:getFocusedWidget()
		if focusedWidget ~= self.currentFocusedWidget then
			if focusedWidget and Class.isCompatibleType(focusedWidget, TextInput) then
				local focusedWidgetX, focusedWidgetY = focusedWidget:getPosition()
				local focusedWidgetWidth, focusedWidgetHeight = focusedWidget:getSize()

				local hintLabel
				if focusedWidget:getHint() ~= "" then
					hintLabel = Label()
					hintLabel:setStyle(LabelStyle({
						font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
						fontSize = 30,
						color = { 1, 1, 1, 1 },
						align = "center",
						textShadow = true
					}, self.resources))
					hintLabel:setText(focusedWidget:getHint())
					hintLabel:setSize(0, focusedWidgetHeight)

					hintLabel:setPosition(focusedWidgetX + focusedWidgetWidth / 2, focusedWidgetY)
				end

				self.renderManager:setInput(focusedWidget, hintLabel)
				self.currentFocusedWidget = focusedWidget
			else
				self.renderManager:setInput()
			end

			self.currentFocusedWidget = focusedWidget
		end
	end

	if self.hasPendingInterfaceFocus then
		for i = #self.interfaceFocusStack, 1, -1 do
			local top = self.interfaceFocusStack[i]
			local result = top:restoreFocus()
			if result == nil or result then
				Log.info("Restored focus to interface '%s' (index %d).", top:getDebugInfo().shortName, #self.interfaceFocusStack)
				break
			end
		end

		self.hasPendingInterfaceFocus = false
	end
end

function UIView:draw()
	local width, height, _, _, offsetX, offsetY = self:getMode()
	self.root:setSize(width, height)
	self.root:setPosition(offsetX, offsetY)

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

function UIView:reset()
	self.root:clearChildren()
end

function UIView:getMode()
	return love.graphics.getScaledMode()
end

return UIView
