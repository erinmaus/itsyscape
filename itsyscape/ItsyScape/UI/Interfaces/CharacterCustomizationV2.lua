--------------------------------------------------------------------------------
-- ItsyScape/UI/CharacterCustomizationV2.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local NullActor = require "ItsyScape.Game.Null.Actor"
local ActorView = require "ItsyScape.Graphics.ActorView"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Drawable = require "ItsyScape.UI.Drawable"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"
local Texture = require "ItsyScape.UI.Texture"
local Widget = require "ItsyScape.UI.Widget"
local DialogBox = require "ItsyScape.UI.Interfaces.DialogBox"
local patchy = require "patchy"

local CharacterCustomization = Class(Interface)

CharacterCustomization.ColorComponentSlider = Class(Drawable)
CharacterCustomization.ColorComponentSlider.SHADER = love.graphics.newShader([[
	uniform vec2 scape_Hue;
	uniform vec2 scape_Saturation;
	uniform vec2 scape_Lightness;

	// From https://github.com/tobspr/GLSL-Color-Spaces
	const float HCV_EPSILON = 1e-10;
	const float HSL_EPSILON = 1e-10;

	vec3 rgb_to_hcv(vec3 rgb)
	{
	    // Based on work by Sam Hocevar and Emil Persson
	    vec4 P = (rgb.g < rgb.b) ? vec4(rgb.bg, -1.0, 2.0/3.0) : vec4(rgb.gb, 0.0, -1.0/3.0);
	    vec4 Q = (rgb.r < P.x) ? vec4(P.xyw, rgb.r) : vec4(rgb.r, P.yzx);
	    float C = Q.x - min(Q.w, Q.y);
	    float H = abs((Q.w - Q.y) / (6.0 * C + HCV_EPSILON) + Q.z);
	    return vec3(H, C, Q.x);
	}

	vec3 hue_to_rgb(float hue)
	{
	    float R = abs(hue * 6.0 - 3.0) - 1.0;
	    float G = 2.0 - abs(hue * 6.0 - 2.0);
	    float B = 2.0 - abs(hue * 6.0 - 4.0);
	    return clamp(vec3(R,G,B), vec3(0.0), vec3(1.0));
	}

	// Converts from linear rgb to HSL
	vec3 rgb_to_hsl(vec3 rgb)
	{
	    vec3 HCV = rgb_to_hcv(rgb);
	    float L = HCV.z - HCV.y * 0.5;
	    float S = HCV.y / (1.0 - abs(L * 2.0 - 1.0) + HSL_EPSILON);
	    return vec3(HCV.x, S, L);
	}

	vec3 hsl_to_rgb(vec3 hsl)
	{
	    vec3 rgb = hue_to_rgb(hsl.x);
	    float C = (1.0 - abs(2.0 * hsl.z - 1.0)) * hsl.y;
	    return (rgb - 0.5) * C + hsl.z;
	}

	vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
	{
		vec3 hsl = vec3(
			mix(scape_Hue.x, scape_Hue.y, textureCoordinate.x),
			mix(scape_Saturation.x, scape_Saturation.y, textureCoordinate.x),
			mix(scape_Lightness.x, scape_Lightness.y, textureCoordinate.x)
		);

		vec3 rgb = hsl_to_rgb(hsl);
		return vec4(rgb, 1.0);
	}
]])

function CharacterCustomization.ColorComponentSlider:new(min, max)
	Drawable.new(self)

	self.isSliding = false
	self.min = min
	self.max = max
	self.currentValue = math.floor((max - min) / 2)

	self.onUpdateValue = Callback()
end

function CharacterCustomization.ColorComponentSlider:getIsFocusable()
	return true
end

function CharacterCustomization.ColorComponentSlider:_handleMouseAction(x, y)
	local width = self:getSize()
	local positionX = self:getAbsolutePosition()
	local relativeX = math.clamp(x - positionX, 0, width)
	local value = math.floor((relativeX / width) * (self.max - self.min) + self.min)

	self:updateValue(value)
end

function CharacterCustomization.ColorComponentSlider:mousePress(x, y, button)
	Widget.mousePress(self, x, y, button)

	self.isSliding = true
	self:_handleMouseAction(x, y)
end

function CharacterCustomization.ColorComponentSlider:mouseRelease(x, y, button)
	Widget.mousePress(self, x, y, button)

	if self.isSliding then
		self:_handleMouseAction(x, y)
		self.isSliding = false
	end
end

function CharacterCustomization.ColorComponentSlider:mouseMove(x, y, ...)
	Widget.mouseMove(self, x, y, ...)

	if self.isSliding then
		self:_handleMouseAction(x)
	end
end

function CharacterCustomization.ColorComponentSlider:updateImage(hue, saturation, lightness)
	self.pixel = self.pixel or love.graphics.newImage(love.image.newImageData(1, 1))

	local width, height = self:getSize()
	if not self.image or width ~= self.image:getWidth() or height ~= self.image:getHeight() then
		self.image = love.graphics.newCanvas(width, height)
	end

	love.graphics.push("all")
	love.graphics.origin()
	love.graphics.setScissor()
	love.graphics.setCanvas(self.image)
	love.graphics.setShader(CharacterCustomization.ColorComponentSlider.SHADER)

	if hue then
		CharacterCustomization.ColorComponentSlider.SHADER:send("scape_Hue", { hue, hue })
	else
		CharacterCustomization.ColorComponentSlider.SHADER:send("scape_Hue", { 0, 1 })
	end

	if saturation then
		CharacterCustomization.ColorComponentSlider.SHADER:send("scape_Saturation", { saturation, saturation })
	else
		CharacterCustomization.ColorComponentSlider.SHADER:send("scape_Saturation", { 0, 1 })
	end

	if lightness then
		CharacterCustomization.ColorComponentSlider.SHADER:send("scape_Lightness", { lightness, lightness })
	else
		CharacterCustomization.ColorComponentSlider.SHADER:send("scape_Lightness", { 0, 1 })
	end

	love.graphics.draw(self.pixel, 0, 0, 0, width, height)
	love.graphics.pop()
end

function CharacterCustomization.ColorComponentSlider:getImage()
	return self.image
end

function CharacterCustomization.ColorComponentSlider:updateColor(h, s, l)
	-- Nothing.
end

function CharacterCustomization.ColorComponentSlider:getValue()
	return self.currentValue
end

function CharacterCustomization.ColorComponentSlider:updateValue(newValue)
	self:onUpdateValue(newValue, self.currentValue)

	self.currentValue = newValue
end

function CharacterCustomization.ColorComponentSlider:draw(resources, state)
	local width, height = self:getSize()

	local image = self:getImage()

	if image then
		itsyrealm.graphics.uncachedDraw(image)
	end

	if not self.border then
		self.border = resources:load(patchy.load, "Resources/Renderers/Widget/Button/InventoryItem.9.png")
	end

	self.border:draw(-2, -2, width + 4, height + 4)

	if true then
		return
	end

	if not self.sliderImage then
		self.sliderImage = resources:load(love.graphics.newImage, "Resources/Renderers/Widget/Common/Slider.png")
	end

	local width = self:getSize()
	local x = math.floor(width * ((self.currentValue - self.min) / (self.max - self.min)))

	local scale = 1
	if self.isSliding then
		scale = 1.25
	end

	itsyrealm.graphics.draw(
		self.sliderImage,
		x, -(self.sliderImage:getHeight() / 2),
		0,
		scale, scale,
		self.sliderImage:getWidth() / 2, self.sliderImage:getHeight() /2)
end

CharacterCustomization.HueSlider = Class(CharacterCustomization.ColorComponentSlider)

function CharacterCustomization.HueSlider:new()
	self.saturation = 128
	self.lightness = 255

	return CharacterCustomization.ColorComponentSlider.new(self, 0, 255)
end

function CharacterCustomization.HueSlider:_updateImage()
	self:updateImage(nil, 1, 0.5)
end

function CharacterCustomization.HueSlider:setSize(...)
	Widget.setSize(self, ...)

	self:_updateImage()
end

function CharacterCustomization.HueSlider:updateColor(h, s, l)
	self.saturation = s
	self.lightness = l

	self:_updateImage()
end

CharacterCustomization.SaturationSlider = Class(CharacterCustomization.ColorComponentSlider)

function CharacterCustomization.SaturationSlider:new()
	self.hue = 255
	self.lightness = 255

	return CharacterCustomization.ColorComponentSlider.new(self, 0, 255)
end

function CharacterCustomization.SaturationSlider:_updateImage()
	self:updateImage(self.hue / 255, nil, self.lightness / 255)
end

function CharacterCustomization.SaturationSlider:setSize(...)
	Widget.setSize(self, ...)

	self:_updateImage()
end

function CharacterCustomization.SaturationSlider:updateColor(h, s, l)
	self.hue = h
	self.lightness = l

	self:_updateImage()
end

CharacterCustomization.LightnessSlider = Class(CharacterCustomization.ColorComponentSlider)

function CharacterCustomization.LightnessSlider:new()
	self.hue = 255
	self.saturation = 255

	return CharacterCustomization.ColorComponentSlider.new(self, 0, 255)
end

function CharacterCustomization.LightnessSlider:_updateImage()
	self:updateImage(self.hue / 255, self.saturation / 255, nil)
end

function CharacterCustomization.LightnessSlider:setSize(...)
	Widget.setSize(self, ...)

	self:_updateImage()
end

function CharacterCustomization.LightnessSlider:updateColor(h, s, l)
	self.hue = h
	self.saturation = s

	self:_updateImage()
end

CharacterCustomization.INACTIVE_SKIN_BUTTON_STYLE = {
	inactive = Color(0, 0, 0, 0),
	hover = Color(0.7, 0.6, 0.5),
	active = Color(0.5, 0.4, 0.3)
}

CharacterCustomization.ACTIVE_SKIN_BUTTON_STYLE = {
	inactive = Color(0.7, 0.6, 0.5),
	hover = Color(0.7, 0.6, 0.5),
	active = Color(0.5, 0.4, 0.3)
}

CharacterCustomization.INACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = _MOBILE and 28 or 24
}

CharacterCustomization.ACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = _MOBILE and 28 or 24
}

CharacterCustomization.BUTTON_SIZE = 48

CharacterCustomization.GROUP = {
	image = "Resources/Renderers/Widget/Panel/Group.9.png"
}

CharacterCustomization.NUM_MAIN_COLUMNS = 3
CharacterCustomization.NUM_SKIN_COLUMNS = _MOBILE and 2 or 3

CharacterCustomization.PADDING = 8

CharacterCustomization.PLAYER_SKIN_TYPE_NAME = "ItsyScape.Game.Skin.ModelSkin"

CharacterCustomization.CAMERA = {
	hair = {
		zoom = 2.5,
		position = Vector(0, 1.5, 0)
	},

	eyes = {
		zoom = 2,
		position = Vector(0, 1.5, 0)
	},

	head = {
		zoom = 1.75,
		position = Vector(0, 1.25, 0)
	},

	body = {
		zoom = 2.5,
		position = Vector(0, 0.5, 0)
	},

	hands = {
		zoom = 2.5,
		position = Vector(0, 0.5, 0)
	},

	feet = {
		zoom = 2,
		position = Vector(0, 0.25, 0)
	}
}

CharacterCustomization.SLOTS = {
	{
		niceName = "Hair",
		slot = "hair"
	},
	{
		niceName = "Eyes",
		slot = "eyes"
	},
	{
		niceName = "Head",
		slot = "head"
	},
	{
		niceName = "Body",
		slot = "body"
	},
	{
		niceName = "Hands",
		slot = "hands"
	},
	{
		niceName = "Feet",
		slot = "feet"
	}
}

function CharacterCustomization:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	local columnWidth = math.floor(w / self.NUM_MAIN_COLUMNS)
	self:setSize(w, h)

	self.skinOptionCamera = ThirdPersonCamera()
	self.skinOptionCamera:setUp(-Vector.UNIT_Y)
	self.skinOptionCamera:setVerticalRotation(-math.pi / 2)
	self.skinOptionCamera:setHorizontalRotation(-math.pi / 12)
	self.skinOptionCamera:setPosition(Vector(0, 1.5, 0))
	self.skinOptionCamera:setDistance(2.5)

	self.characterCamera = ThirdPersonCamera()
	self.characterCamera:setUp(-Vector.UNIT_Y)
	self.characterCamera:setDistance(7)
	self.characterCamera:setVerticalRotation(-math.pi / 2)
	self.characterCamera:setHorizontalRotation(-math.pi / 12)
	self.characterCamera:setPosition(Vector.UNIT_Y)
	self.characterCamera:setWidth(columnWidth)
	self.characterCamera:setHeight(h)

	local panel = Panel()
	panel:setSize(w, h)
	self:addChild(panel)

	self.slotsLayout = GridLayout()
	self.slotsLayout:setPosition(self.PADDING, self.PADDING)
	self.slotsLayout:setSize(columnWidth, h)
	self.slotsLayout:setUniformSize(true, columnWidth - self.PADDING * 2, self.BUTTON_SIZE)
	self.slotsLayout:setPadding(self.PADDING)
	self:addChild(self.slotsLayout)

	local function addSlot(niceName, onClick, isActive)
		local button = Button()
		button:setText(niceName)

		if isActive then
			self.activeButton = button
			button:setStyle(ButtonStyle(self.ACTIVE_BUTTON_STYLE, self:getView():getResources()))

			onClick()
		else
			button:setStyle(ButtonStyle(self.INACTIVE_BUTTON_STYLE, self:getView():getResources()))
		end

		button.onClick:register(function(_, mouseButton)
			if self.activeButton == button then
				return
			end

			if mouseButton == 1 then
				onClick()
			end

			if self.activeButton then
				self.activeButton:setStyle(ButtonStyle(self.INACTIVE_BUTTON_STYLE, self:getView():getResources()))
			end

			button:setStyle(ButtonStyle(self.ACTIVE_BUTTON_STYLE, self:getView():getResources()))
			self.activeButton = button
		end)

		self.slotsLayout:addChild(button)
	end

	for _, slotInfo in ipairs(CharacterCustomization.SLOTS) do
		addSlot(slotInfo.niceName, Callback.bind(self.changeSlot, self, slotInfo.slot), false)
	end
	addSlot("Description", Callback.bind(self.openDescription, self), true)

	self.characterSceneSnippet = SceneSnippet()
	self.characterSceneSnippet:setSize(columnWidth, h)
	self.characterSceneSnippet:setPosition(columnWidth, 0)
	self.characterSceneSnippet:setCamera(self.characterCamera)
	self.characterSceneSnippet:setAlwaysRender(true)
	self:addChild(self.characterSceneSnippet)

	local colorLayoutHeight = 6 * (self.BUTTON_SIZE + self.PADDING) + self.PADDING
	self.colorLayout = GridLayout()
	self.colorLayout:setSize(columnWidth, colorLayoutHeight)
	self.colorLayout:setPadding(self.PADDING, self.PADDING)
	self.colorLayout:setPosition(columnWidth * 2, h - colorLayoutHeight - self.PADDING)
	self:addChild(self.colorLayout)

	self.hueSlider = CharacterCustomization.HueSlider()
	self.hueSlider:setSize(columnWidth - self.PADDING * 2, self.BUTTON_SIZE)
	self.hueSlider.onUpdateValue:register(self.updateHue, self)
	self.colorLayout:addChild(self.hueSlider)

	self.saturationSlider = CharacterCustomization.SaturationSlider()
	self.saturationSlider:setSize(columnWidth - self.PADDING * 2, self.BUTTON_SIZE)
	self.saturationSlider.onUpdateValue:register(self.updateSaturation, self)
	self.colorLayout:addChild(self.saturationSlider)

	self.lightnessSlider = CharacterCustomization.LightnessSlider()
	self.lightnessSlider:setSize(columnWidth - self.PADDING * 2, self.BUTTON_SIZE)
	self.lightnessSlider.onUpdateValue:register(self.updateLightness, self)
	self.colorLayout:addChild(self.lightnessSlider)

	local skinButtonSize = math.floor((columnWidth - ScrollablePanel.DEFAULT_SCROLL_SIZE - self.PADDING) / self.NUM_SKIN_COLUMNS) - self.PADDING * 2
	self.skinOptionLayout = ScrollablePanel(GridLayout)
	self.skinOptionLayout:setSize(columnWidth - self.PADDING, h - colorLayoutHeight - self.PADDING)
	self.skinOptionLayout:setPosition(columnWidth * 2, self.PADDING)
	self.skinOptionLayout:getInnerPanel():setUniformSize(true, skinButtonSize, skinButtonSize)
	self.skinOptionLayout:getInnerPanel():setPadding(self.PADDING, self.PADDING)
	self.skinOptionLayout:getInnerPanel():setWrapContents(true)

	local skinOptionLayoutBackground = Panel()
	skinOptionLayoutBackground:setSize(self.skinOptionLayout:getSize())
	skinOptionLayoutBackground:setPosition(self.skinOptionLayout:getPosition())
	skinOptionLayoutBackground:setStyle(PanelStyle(self.GROUP, self:getView():getResources()))

	self:addChild(skinOptionLayoutBackground)
	self:addChild(self.skinOptionLayout)

	self.colorConfig = {}
	self.currentColorIndex = 1
end

function CharacterCustomization:getIsFullscreen()
	return true
end

function CharacterCustomization:openDescription()
	-- TODO
end

function CharacterCustomization:changeSlot(slot)
	self.currentSlot = slot
	self:sendPoke("changeSlot", nil, { slot = slot })
end

function CharacterCustomization:updateColor(h, s, l)
	self.hueSlider:updateColor(h, s, l)
	self.saturationSlider:updateColor(h, s, l)
	self.lightnessSlider:updateColor(h, s, l)

	h = h / 255
	s = s / 255
	l = l / 255

	if not self.currentSlot then
		return
	end

	local colors = self.colorConfig[self.currentSlot]
	if not colors then
		colors = {}
		self.colorConfig[self.currentSlot] = colors
	end

	colors[self.currentColorIndex] = { h = h, s = s, l = l, Color.fromHSL(h, s, l):get() }

	self.currentPlayerActor, self.currentPlayerActorView = self:updateCurrentPlayer(self.characterSceneSnippet, self:getState().skins, nil, self.currentPlayerActor, self.currentPlayerActorView)
	self._updateSkinOptions()
end

function CharacterCustomization:updateHue(_, value)
	self:updateColor(value, self.saturationSlider:getValue(), self.hueSlider:getValue())
end

function CharacterCustomization:updateSaturation(_, value)
	self:updateColor(self.hueSlider:getValue(), value, self.hueSlider:getValue())
end

function CharacterCustomization:updateLightness(_, value)
	self:updateColor(self.hueSlider:getValue(), self.saturationSlider:getValue(), value)
end

function CharacterCustomization:updateCurrentPlayer(sceneSnippet, playerSkinStorage, skinOverride, actor, actorView)
	if not actor or not actorView then
		actor = NullActor()
		actor:spawn(1)

		actorView = ActorView(actor, "Player")
		actorView:attach(_APP:getGameView())


		actor:setBody(CacheRef("ItsyScape.Game.Body", "Resources/Game/Bodies/Human.lskel"))
		actor:playAnimation(
			"idle",
			0,
			CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/Human_Idle_1/Script.lua"))
	end

	for slot, skin in pairs(playerSkinStorage) do
		if skin.type then
			actor:setSkin(skin.slot, skin.priority, CacheRef(skin.type, skin.filename), self.colorConfig[slot] or {})
		end
	end

	for slot, skin in pairs(skinOverride or {}) do
		if skin.type then
			actor:setSkin(skin.slot, skin.priority, CacheRef(skin.type, skin.filename), self.colorConfig[slot] or {})
		end
	end

	if sceneSnippet then
		sceneSnippet:setChildNode(actorView:getSceneNode())

		local parentNode = SceneNode()
		parentNode:setParent(sceneSnippet:getRoot())

		local ambientLightSceneNode = AmbientLightSceneNode()
		ambientLightSceneNode:setAmbience(1)
		ambientLightSceneNode:setParent(parentNode)

		sceneSnippet:setParentNode(parentNode)
	end

	return actor, actorView
end

function CharacterCustomization:updateSkinOptions(skins, slot, priority, niceName)
	for i, button in self.skinOptionLayout:getInnerPanel():iterate() do
		local skin = skins[i]
		local actor = button:getData("actor")
		local actorView = button:getData("actorView")
		local sceneSnippet = button:getData("scene")

		actor, actorView = self:updateCurrentPlayer(sceneSnippet, self:getState().skins, {
			[niceName] = {
				slot = slot,
				priority = priority,
				type = "ItsyScape.Game.Skin.ModelSkin",
				filename = skin.filename
			}
		}, actor, actorView)

		button:setData("actor", actor)
		button:setData("actorView", actorView)
	end
end

function CharacterCustomization:populateSkinOptions(playerSkinStorage, skins, slot, priority, niceName, palette)
	self.skinOptionLayout:clearChildren()

	local _, buttonWidth, buttonHeight = self.skinOptionLayout:getInnerPanel():getUniformSize()
	self.skinOptionCamera:setWidth(buttonWidth)
	self.skinOptionCamera:setHeight(buttonHeight)

	local cameraConfig = self.CAMERA[niceName]
	if cameraConfig then
		self.skinOptionCamera:setPosition(cameraConfig.position)
		self.skinOptionCamera:setDistance(cameraConfig.zoom)
	end

	if not self.colorConfig[niceName] then
		local config
		do
			if playerSkinStorage[niceName].config then
				config = playerSkinStorage[niceName].config
			end

			if not config and palette then
				config = palette
			end

			if not config or #config == 0 then
				local color = Color(Vector(love.math.random(), love.math.random(), love.math.random()):getNormal():get())
				config = { color }
			end
		end

		local colors = {}
		for index, color in ipairs(config) do
			local c = Color(unpack(color))
			local h, s, l = c:toHSL()
			colors[index] = { h = h, s = s, l = l, unpack(color) }
		end

		self.colorConfig[niceName] = colors
	end

	self.currentColorIndex = math.clamp(self.currentColorIndex, 1, #self.colorConfig[niceName])

	for _, skin in ipairs(skins) do
		local button = Button()
		button:setToolTip(skin.name)

		local isActive = false
		for _, otherSkin in pairs(playerSkinStorage) do
			if otherSkin.filename == skin.filename then
				isActive = true
				break
			end
		end

		local sceneSnippet = SceneSnippet()
		sceneSnippet:setCamera(self.skinOptionCamera)
		sceneSnippet:setSize(buttonWidth, buttonHeight)
		button:addChild(sceneSnippet)
		button:setData("scene", sceneSnippet)

		if isActive then
			button:setStyle(ButtonStyle(self.ACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
		else
			button:setStyle(ButtonStyle(self.INACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
		end

		self.skinOptionLayout:addChild(button)
	end

	self._updateSkinOptions = Callback.bind(self.updateSkinOptions, self, skins, slot, priority, niceName)
	self._updateSkinOptions()

	self.skinOptionLayout:getInnerPanel():setScroll(0, 0)
	self.skinOptionLayout:setScrollSize(self.skinOptionLayout:getInnerPanel():getSize())
end

function CharacterCustomization:update(delta)
	Widget.update(self, delta)

	if not self.currentPlayerActorView then
		self.currentPlayerActor, self.currentPlayerActorView = self:updateCurrentPlayer(self.characterSceneSnippet, self:getState().skins)
	end
	self.currentPlayerActorView:update(delta)

	for _, widget in self.skinOptionLayout:getInnerPanel():iterate() do
		local actorView = widget:getData("actorView")
		if actorView then
			actorView:update(0)
		end
	end
end

return CharacterCustomization
