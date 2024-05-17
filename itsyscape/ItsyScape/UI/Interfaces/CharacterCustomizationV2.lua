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
local ModelSkin = require "ItsyScape.Game.Skin.ModelSkin"
local NullActor = require "ItsyScape.Game.Null.Actor"
local ActorView = require "ItsyScape.Graphics.ActorView"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local DefaultCameraController = require "ItsyScape.Graphics.DefaultCameraController"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local ConfirmWindow = require "ItsyScape.Editor.Common.ConfirmWindow"
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

CharacterCustomization.ColorComponentSlider.SLIDER_WIDTH = 24

function CharacterCustomization.ColorComponentSlider:new(min, max)
	Drawable.new(self)

	self.isSliding = false
	self.min = min
	self.max = max
	self.currentValue = math.floor((max - min) / 2)
	self.sliderColor = Color()

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
	self.sliderColor = Color.fromHSL(h / 255, s / 255, l / 255)
end

function CharacterCustomization.ColorComponentSlider:setValue(value)
	self.currentValue = value or self.currentValue
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

	local scale = 1
	if self.isSliding then
		scale = 1.25
	end

	local sliderWidth = self.SLIDER_WIDTH * scale
	local sliderHeight = height * scale
	local x = math.floor(width * ((self.currentValue - self.min) / (self.max - self.min))) - (sliderWidth / 2)
	local y = height / 2 - (sliderHeight / 2)

	love.graphics.setColor(0, 0, 0, 0.5)
	itsyrealm.graphics.rectangle("fill", x + 2, y + 2, sliderWidth, sliderHeight)

	love.graphics.setColor(self.sliderColor:get())
	itsyrealm.graphics.rectangle("fill", x, y, sliderWidth, sliderHeight)

	love.graphics.setColor(1, 1, 1, 1)
	itsyrealm.graphics.rectangle("line", x, y, sliderWidth, sliderHeight)
end

CharacterCustomization.HueSlider = Class(CharacterCustomization.ColorComponentSlider)

function CharacterCustomization.HueSlider:new()
	CharacterCustomization.ColorComponentSlider.new(self, 0, 255)

	self.saturation = 128
	self.lightness = 255
end

function CharacterCustomization.HueSlider:_updateImage()
	self:updateImage(nil, 1, 0.5)
end

function CharacterCustomization.HueSlider:setSize(...)
	Widget.setSize(self, ...)

	self:_updateImage()
end

function CharacterCustomization.HueSlider:updateColor(h, s, l)
	CharacterCustomization.ColorComponentSlider.updateColor(self, h, s, l)

	self:setValue(h)
	self.saturation = s
	self.lightness = l

	self:_updateImage()
end

CharacterCustomization.SaturationSlider = Class(CharacterCustomization.ColorComponentSlider)

function CharacterCustomization.SaturationSlider:new()
	CharacterCustomization.ColorComponentSlider.new(self, 0, 255)

	self.hue = 255
	self.lightness = 255
end

function CharacterCustomization.SaturationSlider:_updateImage()
	self:updateImage(self.hue / 255, nil, self.lightness / 255)
end

function CharacterCustomization.SaturationSlider:setSize(...)
	Widget.setSize(self, ...)

	self:_updateImage()
end

function CharacterCustomization.SaturationSlider:updateColor(h, s, l)
	CharacterCustomization.ColorComponentSlider.updateColor(self, h, s, l)

	self.hue = h
	self:setValue(s)
	self.lightness = l

	self:_updateImage()
end

CharacterCustomization.LightnessSlider = Class(CharacterCustomization.ColorComponentSlider)

function CharacterCustomization.LightnessSlider:new()
	CharacterCustomization.ColorComponentSlider.new(self, 0, 255)

	self.hue = 255
	self.saturation = 255
end

function CharacterCustomization.LightnessSlider:_updateImage()
	self:updateImage(self.hue / 255, self.saturation / 255, nil)
end

function CharacterCustomization.LightnessSlider:setSize(...)
	Widget.setSize(self, ...)

	self:_updateImage()
end

function CharacterCustomization.LightnessSlider:updateColor(h, s, l)
	CharacterCustomization.ColorComponentSlider.updateColor(self, h, s, l)

	self.hue = h
	self.saturation = s
	self:setValue(l)

	self:_updateImage()
end

CharacterCustomization.UPDATE_COLOR_FPS = 1 / 15

CharacterCustomization.INACTIVE_SKIN_BUTTON_STYLE = {
	inactive = Color(0, 0, 0, 0),
	hover = Color(0.7, 0.6, 0.5),
	pressed = Color(0.5, 0.4, 0.3),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = _MOBILE and 28 or 24,
	textX = 0.0,
	textY = 0.5,
	textAlign = 'left',
	textShadow = true
}

CharacterCustomization.ACTIVE_SKIN_BUTTON_STYLE = {
	inactive = Color(0.7, 0.6, 0.5),
	hover = Color(0.7, 0.6, 0.5),
	pressed = Color(0.5, 0.4, 0.3),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = _MOBILE and 28 or 24,
	textX = 0.0,
	textY = 0.5,
	textAlign = 'left',
	textShadow = true
}

CharacterCustomization.INACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = _MOBILE and 28 or 24
}

CharacterCustomization.ACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = _MOBILE and 28 or 24
}

CharacterCustomization.CANCEL_BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = _MOBILE and 32 or 28
}

CharacterCustomization.CONFIRM_BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/Purple-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Purple-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Purple-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = _MOBILE and 32 or 28
}

CharacterCustomization.BUTTON_SIZE = 48

CharacterCustomization.GROUP = {
	image = "Resources/Renderers/Widget/Panel/Group.9.png"
}

CharacterCustomization.TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true
}

CharacterCustomization.VALUE_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = _MOBILE and 28 or 24,
	textShadow = true
}

CharacterCustomization.TEXT_INPUT_STYLE = {
	inactive = "Resources/Renderers/Widget/TextInput/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/TextInput/Default-Hover.9.png",
	active = "Resources/Renderers/Widget/TextInput/Default-Active.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = _MOBILE and 36 or 24,
	color = Color(1, 1, 1, 1),
	textShadow = true,
	padding = 4
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

CharacterCustomization.GENDER_OPTIONS = {
	male = {
		pronouns = {
			subject = "he",
			object = "him",
			possessive = "his",
			formal = "ser",
			plural = false
		},

		gender = "male",
		description = "Guy"
	},
	female = {
		pronouns = {
			subject = "she",
			object = "her",
			possessive = "her",
			formal = "misse",
			plural = false
		},

		gender = "female",
		description = "Girl"
	},
	x = {
		pronouns = {
			subject = "they",
			object = "them",
			possessive = "their",
			formal = "patrician",
			plural = true
		},

		gender = "x",
		description = "Non-Binary"
	}
}

function CharacterCustomization:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.onChangeGender = Callback()
	self.onChangeGenderPronouns = Callback() 
	self.onChangeGenderPlurality = Callback() 
	self.onChangeGenderDescription = Callback() 

	local w, h = love.graphics.getScaledMode()
	local columnWidth = math.floor(w / self.NUM_MAIN_COLUMNS)
	self:setSize(w, h)

	self.skinOptionCamera = ThirdPersonCamera()
	self.skinOptionCamera:setUp(-Vector.UNIT_Y)
	self.skinOptionCamera:setVerticalRotation(DefaultCameraController.CAMERA_VERTICAL_ROTATION)
	self.skinOptionCamera:setHorizontalRotation(DefaultCameraController.CAMERA_HORIZONTAL_ROTATION)
	self.skinOptionCamera:setPosition(Vector(0, 1.5, 0))
	self.skinOptionCamera:setDistance(2.5)

	self.characterCamera = ThirdPersonCamera()
	self.characterCamera:setUp(-Vector.UNIT_Y)
	self.characterCamera:setDistance(7)
	self.characterCamera:setVerticalRotation(DefaultCameraController.CAMERA_VERTICAL_ROTATION)
	self.characterCamera:setHorizontalRotation(DefaultCameraController.CAMERA_HORIZONTAL_ROTATION)
	self.characterCamera:setPosition(Vector.UNIT_Y)
	self.characterCamera:setWidth(columnWidth)
	self.characterCamera:setHeight(h)

	local panel = Panel()
	panel:setSize(w, h)
	self:addChild(panel)

	self.characterSceneSnippet = SceneSnippet()
	self.characterSceneSnippet:setSize(columnWidth, h)
	self.characterSceneSnippet:setPosition(columnWidth, 0)
	self.characterSceneSnippet:setCamera(self.characterCamera)
	self.characterSceneSnippet:setAlwaysRender(true)
	self.characterSceneSnippet:setIsFocusable(true)
	self.characterSceneSnippet.onMousePress:register(self.onStartCameraDrag, self)
	self.characterSceneSnippet.onMouseRelease:register(self.onStopCameraDrag, self)
	self.characterSceneSnippet.onMouseMove:register(self.updateCameraDrag, self)
	self:addChild(self.characterSceneSnippet)

	self.skinPanel = Panel()
	self.skinPanel:setSize(columnWidth, h)
	self.skinPanel:setPosition(columnWidth * 2, 0)
	self.skinPanel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))

	local colorLayoutHeight = 6 * (self.BUTTON_SIZE + self.PADDING) + self.PADDING
	self.colorLayout = GridLayout()
	self.colorLayout:setSize(columnWidth, colorLayoutHeight)
	self.colorLayout:setPadding(self.PADDING, self.PADDING)
	self.colorLayout:setPosition(0, h - colorLayoutHeight)
	self.skinPanel:addChild(self.colorLayout)

	self.colorSelectionLayout = GridLayout()
	self.colorSelectionLayout:setEdgePadding(false)
	self.colorSelectionLayout:setUniformSize(true, self.BUTTON_SIZE, self.BUTTON_SIZE)
	self.colorSelectionLayout:setPadding(self.PADDING)
	self.colorSelectionLayout:setSize(columnWidth - self.PADDING * 3, self.BUTTON_SIZE)
	self.colorLayout:addChild(self.colorSelectionLayout)

	self.paletteLayout = GridLayout()
	self.paletteLayout:setEdgePadding(false)
	self.paletteLayout:setUniformSize(true, self.BUTTON_SIZE, self.BUTTON_SIZE)
	self.paletteLayout:setPadding(self.PADDING)
	self.paletteLayout:setSize(columnWidth - self.PADDING * 3, self.BUTTON_SIZE)
	self.colorLayout:addChild(self.paletteLayout)

	self.hueSlider = CharacterCustomization.HueSlider()
	self.hueSlider:setSize(columnWidth - self.PADDING * 3, self.BUTTON_SIZE)
	self.hueSlider.onUpdateValue:register(self.updateHue, self)
	self.colorLayout:addChild(self.hueSlider)

	self.saturationSlider = CharacterCustomization.SaturationSlider()
	self.saturationSlider:setSize(columnWidth - self.PADDING * 3, self.BUTTON_SIZE)
	self.saturationSlider.onUpdateValue:register(self.updateSaturation, self)
	self.colorLayout:addChild(self.saturationSlider)

	self.lightnessSlider = CharacterCustomization.LightnessSlider()
	self.lightnessSlider:setSize(columnWidth - self.PADDING * 3, self.BUTTON_SIZE)
	self.lightnessSlider.onUpdateValue:register(self.updateLightness, self)
	self.colorLayout:addChild(self.lightnessSlider)

	local skinButtonSize = math.floor((columnWidth - ScrollablePanel.DEFAULT_SCROLL_SIZE - self.PADDING) / self.NUM_SKIN_COLUMNS) - self.PADDING * 2
	self.skinOptionLayout = ScrollablePanel(GridLayout)
	self.skinOptionLayout:setSize(columnWidth - self.PADDING, h - colorLayoutHeight - self.PADDING)
	self.skinOptionLayout:setPosition(0, self.PADDING)
	self.skinOptionLayout:getInnerPanel():setUniformSize(true, skinButtonSize, skinButtonSize)
	self.skinOptionLayout:getInnerPanel():setPadding(self.PADDING, self.PADDING)
	self.skinOptionLayout:getInnerPanel():setWrapContents(true)

	local skinOptionLayoutBackground = Panel()
	skinOptionLayoutBackground:setSize(self.skinOptionLayout:getSize())
	skinOptionLayoutBackground:setPosition(self.skinOptionLayout:getPosition())
	skinOptionLayoutBackground:setStyle(PanelStyle(self.GROUP, self:getView():getResources()))

	self.skinPanel:addChild(skinOptionLayoutBackground)
	self.skinPanel:addChild(self.skinOptionLayout)

	self.descriptionPanel = Panel()
	self.descriptionPanel:setSize(columnWidth, h)
	self.descriptionPanel:setPosition(columnWidth * 2)
	self.descriptionPanel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))

	local descriptionLayout = ScrollablePanel(GridLayout)
	descriptionLayout:setSize(columnWidth - self.PADDING * 3 - ScrollablePanel.DEFAULT_SCROLL_SIZE, 0)
	descriptionLayout:getInnerPanel():setWrapContents(true)
	descriptionLayout:getInnerPanel():setPadding(self.PADDING, self.PADDING)
	descriptionLayout:getInnerPanel():setUniformSize(true, descriptionLayout:getInnerPanel():getSize(), 0)

	local function addDescriptionTitle(text)
		local label = Label()
		label:setText(text)
		label:setSize(0, self.BUTTON_SIZE)
		label:setStyle(LabelStyle(self.TITLE_LABEL_STYLE, self:getView():getResources()))

		descriptionLayout:addChild(label)
	end

	addDescriptionTitle("Name")

	local nameInput = TextInput()
	nameInput:setHint("Enter your name")
	nameInput:setStyle(TextInputStyle(self.TEXT_INPUT_STYLE, self:getView():getResources()))
	nameInput:setText(self:getState().name)
	nameInput:setSize(0, self.BUTTON_SIZE)
	nameInput.onFocus:register(function()
		nameInput:setCursor(0, #nameInput:getText() + 1)
	end)
	nameInput.onValueChanged:register(function()
		self:changeName(nameInput:getText())
	end)
	nameInput.onBlur:register(function()
		self:changeName(nameInput:getText())
	end)
	nameInput.onSubmit:register(function()
		self:changeName(nameInput:getText())
	end)
	descriptionLayout:addChild(nameInput)

	addDescriptionTitle("Gender")

	local genderSelect = ScrollablePanel(GridLayout)
	genderSelect:setScrollBarVisible(true, false)
	genderSelect:getInnerPanel():setPadding(0, 0)
	genderSelect:getInnerPanel():setWrapContents(true)
	genderSelect:getInnerPanel():setUniformSize(true,
		descriptionLayout:getSize() - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		self.BUTTON_SIZE)
	genderSelect:setSize(
		descriptionLayout:getSize(),
		self.BUTTON_SIZE * 3)

	local function addGender(name, value)
		local button = Button()
		button:setText(name)

		if self:getState().gender == value then
			button:setStyle(ButtonStyle(self.ACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
		else
			button:setStyle(ButtonStyle(self.INACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
		end

		local function onChangeGender(newValue)
			if newValue == value then
				button:setStyle(ButtonStyle(self.ACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
			else
				button:setStyle(ButtonStyle(self.INACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
			end
		end
		onChangeGender(self:getState().gender)

		self.onChangeGender:register(onChangeGender)
		button.onClick:register(self.changeGender, self, value)

		genderSelect:addChild(button)
	end

	addGender("- Guy", "male")
	addGender("- Girl", "female")
	addGender("- Something Else", "x")

	descriptionLayout:addChild(genderSelect)

	addDescriptionTitle("Gender Description")

	local descriptionInput = TextInput()
	descriptionInput:setHint("Enter your gender description")
	descriptionInput:setText(self:getState().description)
	descriptionInput:setStyle(TextInputStyle(CharacterCustomization.TEXT_INPUT_STYLE, self:getView():getResources()))
	descriptionInput.onValueChanged:register(function()
		self:changeGenderDescription(descriptionInput:getText())
	end)
	descriptionInput.onBlur:register(function()
		self:changeGenderDescription(descriptionInput:getText())
	end)
	descriptionInput.onSubmit:register(function()
		self:changeGenderDescription(descriptionInput:getText())
	end)
	descriptionInput.onFocus:register(function()
		descriptionInput:setCursor(0, #descriptionInput:getText() + 1)
	end)
	self.onChangeGenderDescription:register(function(value)
		descriptionInput:setText(value)
	end)
	descriptionInput:setSize(0, self.BUTTON_SIZE)
	descriptionLayout:addChild(descriptionInput)

	addDescriptionTitle("Pronouns")

	local pronounsLayout = GridLayout()
	pronounsLayout:setSize(descriptionLayout:getSize(), 0)
	pronounsLayout:setPadding(0, self.PADDING)
	pronounsLayout:setWrapContents(true)

	local function addPronoun(name, key)
		local width = descriptionLayout:getSize()
		local inputWidth = width / 2 - self.PADDING * 2

		local pronounLayout = GridLayout()
		pronounLayout:setSize(descriptionLayout:getSize(), self.BUTTON_SIZE)
		pronounLayout:setEdgePadding(false)
		pronounLayout:setPadding(self.PADDING, 0)
		pronounLayout:setUniformSize(true, inputWidth, self.BUTTON_SIZE)

		local label = Label()
		label:setText(name)
		label:setStyle(LabelStyle(CharacterCustomization.VALUE_LABEL_STYLE, self:getView():getResources()))
		pronounLayout:addChild(label)

		local input = TextInput()
		input:setHint(string.format("Enter your %s pronoun", name:lower()))
		input:setStyle(TextInputStyle(CharacterCustomization.TEXT_INPUT_STYLE, self:getView():getResources()))
		input:setText(self:getState().pronouns[key])
		input.onValueChanged:register(function()
			self:changePronoun(key, input:getText())
		end)
		input.onBlur:register(function()
			self:changePronoun(key, input:getText())
		end)
		input.onSubmit:register(function()
			self:changePronoun(key, input:getText())
		end)
		input.onFocus:register(function()
			input:setCursor(0, #input:getText() + 1)
		end)
		self.onChangeGenderPronouns:register(function(newValue)
			input:setText(newValue[key])
		end)
		pronounLayout:addChild(input)

		pronounsLayout:addChild(pronounLayout)
	end

	addPronoun("Subject", "subject")
	addPronoun("Object", "object")
	addPronoun("Possessive", "possessive")
	addPronoun("Formal", "formal")

	descriptionLayout:addChild(pronounsLayout)

	do
		local width = descriptionLayout:getSize()
		local inputWidth = width / 2 - self.PADDING * 2

		local layout = GridLayout()
		layout:setSize(descriptionLayout:getSize(), self.BUTTON_SIZE)
		layout:setEdgePadding(false)
		layout:setPadding(self.PADDING, 0)
		layout:setUniformSize(true, inputWidth, self.BUTTON_SIZE)

		local function setPronounPlurality(text, isPlural)
			local button = Button()
			button:setText(text)
			button.onClick:register(function()
				self:changePronounPlurality(isPlural)
			end)

			local setStyle = function(newValue)
				if isPlural == newValue then
					button:setStyle(ButtonStyle(CharacterCustomization.ACTIVE_BUTTON_STYLE, self:getView():getResources()))
				else
					button:setStyle(ButtonStyle(CharacterCustomization.INACTIVE_BUTTON_STYLE, self:getView():getResources()))
				end
			end

			self.onChangeGenderPlurality:register(setStyle)
			setStyle(self:getState().pronouns.plural)

			layout:addChild(button)
		end

		setPronounPlurality("Plural", true)
		setPronounPlurality("Singular", false)

		descriptionLayout:addChild(layout)
	end


	descriptionLayout:setSize(self.descriptionPanel:getSize())
	descriptionLayout:setScrollSize(descriptionLayout:getInnerPanel():getSize())

	self.descriptionPanel:addChild(descriptionLayout)

	self.slotsLayout = GridLayout()
	self.slotsLayout:setPosition(self.PADDING, self.PADDING)
	self.slotsLayout:setSize(columnWidth, h)
	self.slotsLayout:setUniformSize(true, columnWidth - self.PADDING * 2, 0)
	self.slotsLayout:setPadding(self.PADDING)
	self:addChild(self.slotsLayout)

	local function addSlot(niceName, onClick, isActive)
		local button = Button()
		button:setText(niceName)
		button:setSize(0, self.BUTTON_SIZE)

		if isActive then
			self.activeSlotButton = button
			button:setStyle(ButtonStyle(self.ACTIVE_BUTTON_STYLE, self:getView():getResources()))

			onClick()
		else
			button:setStyle(ButtonStyle(self.INACTIVE_BUTTON_STYLE, self:getView():getResources()))
		end

		button.onClick:register(function(_, mouseButton)
			if self.activeSlotButton == button then
				return
			end

			if mouseButton == 1 then
				onClick()
			end

			if self.activeSlotButton then
				self.activeSlotButton:setStyle(ButtonStyle(self.INACTIVE_BUTTON_STYLE, self:getView():getResources()))
			end

			button:setStyle(ButtonStyle(self.ACTIVE_BUTTON_STYLE, self:getView():getResources()))
			self.activeSlotButton = button
		end)

		self.slotsLayout:addChild(button)
	end

	for _, slotInfo in ipairs(CharacterCustomization.SLOTS) do
		addSlot(slotInfo.niceName, Callback.bind(self.changeSlot, self, slotInfo.slot), false)
	end
	addSlot("Description", Callback.bind(self.openDescription, self), true)

	local canCancel = not self:getState().isNewGame

	local width
	if canCancel then
		width = columnWidth / 2 - self.PADDING * 3

		local cancelButton = Button()
		cancelButton:setText("Cancel")
		cancelButton:setSize(width, self.BUTTON_SIZE * 2)
		cancelButton:setStyle(ButtonStyle(self.CANCEL_BUTTON_STYLE, self:getView():getResources()))
		cancelButton:setPosition(self.PADDING, h - self.BUTTON_SIZE * 2 - self.PADDING)
		cancelButton.onClick:register(function()
			local window = ConfirmWindow(_APP)

			window.onSubmit:register(function()
				self:sendPoke("close", nil, {})
			end)

			window:open("Are you sure you want to discard any changes?", nil, columnWidth)

			local x, y = self.slotsLayout:getAbsolutePosition()
			local slotsWidth, slotsHeight = self.slotsLayout:getSize()
			local windowWidth, windowHeight = window:getSize()
			window:setPosition(self.PADDING + (slotsWidth / 2 - windowWidth / 2), h - self.PADDING - windowHeight)
		end)

		self:addChild(cancelButton)
	else
		width = columnWidth - self.PADDING * 2
	end

	local confirmButton = Button()
	confirmButton:setText("Confirm")
	confirmButton:setSize(width, self.BUTTON_SIZE * 2)
	confirmButton:setStyle(ButtonStyle(self.CONFIRM_BUTTON_STYLE, self:getView():getResources()))
	confirmButton:setPosition(columnWidth - width - self.PADDING, h - self.BUTTON_SIZE * 2 - self.PADDING)
	confirmButton.onClick:register(function()
		self:submit()
	end)
	self:addChild(confirmButton)

	self.colorConfig = {}
	for niceName, skin in pairs(self:getState().skins) do
		if skin.config then
			self.colorConfig[niceName] = skin.config
		end
	end
	self.currentColorIndex = 1

	self.newPlayerSkin = {}
	do
		local state = self:getState()
		self.description = {
			pronouns = state.pronouns,
			name = state.name,
			gender = state.gender,
			description = state.description
		}
	end
end

function CharacterCustomization:onStartCameraDrag()
	self.isCameraDragging = true
end

function CharacterCustomization:onStopCameraDrag()
	self.isCameraDragging = false
end

function CharacterCustomization:updateCameraDrag(_, _, _, dx, dy)
	if not self.isCameraDragging then
		return
	end

	self.verticalOffset = (self.verticalOffset or 0) + dx / 128
	self.horizontalOffset = (self.horizontalOffset or 0) - dy / 128

	self.horizontalOffset = math.clamp(
		self.horizontalOffset,
		-DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET,
		DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)


	self.characterCamera:setVerticalRotation(DefaultCameraController.CAMERA_VERTICAL_ROTATION + self.verticalOffset)
	self.characterCamera:setHorizontalRotation(DefaultCameraController.CAMERA_HORIZONTAL_ROTATION + self.horizontalOffset)
end

function CharacterCustomization:getIsFullscreen()
	return true
end

function CharacterCustomization:openDescription()
	self:removeChild(self.skinPanel)
	self:addChild(self.descriptionPanel)
end

function CharacterCustomization:changeSlot(slot)
	self:addChild(self.skinPanel)
	self:removeChild(self.descriptionPanel)

	self.currentSlot = slot
	self:sendPoke("changeSlot", nil, { slot = slot })
end

function CharacterCustomization:changeName(value)
	self.description.name = value
end

function CharacterCustomization:changeGender(value)
	self.description = {
		name = self.description.name,

		pronouns = {
			subject = self.GENDER_OPTIONS[value].pronouns.subject,
			object = self.GENDER_OPTIONS[value].pronouns.object,
			possessive = self.GENDER_OPTIONS[value].pronouns.possessive,
			formal = self.GENDER_OPTIONS[value].pronouns.formal,
			plural = self.GENDER_OPTIONS[value].pronouns.plural,
		},

		gender = self.GENDER_OPTIONS[value].gender,
		description = self.GENDER_OPTIONS[value].description
	}

	self.onChangeGender(value)
	self.onChangeGenderPronouns(self.description.pronouns)
	self.onChangeGenderPlurality(self.description.pronouns.plural)
	self.onChangeGenderDescription(self.description.description)
end

function CharacterCustomization:changeGenderDescription(value)
	self.description.description = value
end

function CharacterCustomization:changePronounPlurality(value)
	self.description.pronouns.plural = value
	self.onChangeGenderPlurality(value)
end

function CharacterCustomization:updateColor(h, s, l)
	self.pendingUpdatedColor = { h, s, l }
end

function CharacterCustomization:_updateSkins()
	local h, s, l = unpack(self.pendingUpdatedColor)

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

	self.currentPlayerActor, self.currentPlayerActorView = self:updateCurrentPlayer(self.characterSceneSnippet, self:getState().skins, self.newPlayerSkin, self.currentPlayerActor, self.currentPlayerActorView)
	self._updateSkinOptions()
end

function CharacterCustomization:updateHue(_, value)
	self:updateColor(value, self.saturationSlider:getValue(), self.lightnessSlider:getValue())
end

function CharacterCustomization:updateSaturation(_, value)
	self:updateColor(self.hueSlider:getValue(), value, self.lightnessSlider:getValue())
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

		local parentNode = sceneSnippet:getParentNode()
		if not parentNode then
			parentNode = SceneNode()
			parentNode:setParent(sceneSnippet:getRoot())

			local ambientLightSceneNode = AmbientLightSceneNode()
			ambientLightSceneNode:setAmbience(1)
			ambientLightSceneNode:setParent(parentNode)

			sceneSnippet:setParentNode(parentNode)
		end
	end

	return actor, actorView
end

function CharacterCustomization:updateSkinOptions(skins, slot, priority, niceName)
	for i, button in self.skinOptionLayout:getInnerPanel():iterate() do
		local skin = skins[i]
		local actor = button:getData("actor")
		local actorView = button:getData("actorView")
		local sceneSnippet = button:getData("scene")

		local override = {
			[niceName] = {
				slot = slot,
				priority = priority,
				type = "ItsyScape.Game.Skin.ModelSkin",
				filename = skin.filename
			}
		}

		for key, value in pairs(self.newPlayerSkin) do
			if not override[key] then
				override[key] = value
			end
		end

		actor, actorView = self:updateCurrentPlayer(sceneSnippet, self:getState().skins, override, actor, actorView)

		button:setData("actor", actor)
		button:setData("actorView", actorView)

		if coroutine.running() then
			coroutine.yield()
		end
	end
end

function CharacterCustomization:populateSkinOptions(playerSkinStorage, skins, slot, priority, niceName, palette, defaultColorConfig)
	self.skinOptionLayout:clearChildren()

	local _, buttonWidth, buttonHeight = self.skinOptionLayout:getInnerPanel():getUniformSize()
	self.skinOptionCamera:setWidth(buttonWidth)
	self.skinOptionCamera:setHeight(buttonHeight)

	local cameraConfig = self.CAMERA[niceName]
	if cameraConfig then
		self.skinOptionCamera:setPosition(cameraConfig.position)
		self.skinOptionCamera:setDistance(cameraConfig.zoom)
	end

	if not self.colorConfig[niceName] or #self.colorConfig[niceName] == 0 then
		local config
		do
			if playerSkinStorage[niceName].config then
				config = playerSkinStorage[niceName].config
			end

			if not config or #config == 0 then
				config = defaultColorConfig or palette
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

	for _, skin in ipairs(skins) do
		local button = Button()
		button:setToolTip(skin.name)

		local isActive = false
		for _, otherSkin in pairs(self.newPlayerSkin) do
			if otherSkin.filename == skin.filename then
				isActive = true
				break
			end
		end

		if not isActive and not self.newPlayerSkin[niceName] then
			for _, otherSkin in pairs(playerSkinStorage) do
				if otherSkin.filename == skin.filename then
					isActive = true
					break
				end
			end
		end

		local sceneSnippet = SceneSnippet()
		sceneSnippet:setCamera(self.skinOptionCamera)
		sceneSnippet:setSize(buttonWidth, buttonHeight)
		button:addChild(sceneSnippet)
		button:setData("scene", sceneSnippet)

		local skinInfo = { skin = skin, slot = slot, priority = priority, niceName = niceName, palette = palette }
		button.onClick:register(self.onSelectSkin, self, skinInfo)

		if isActive then
			self:onSelectSkin(skinInfo, button)
		else
			button:setStyle(ButtonStyle(self.INACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
		end

		self.skinOptionLayout:addChild(button)
	end

	self._updateSkinOptions = Callback.bind(self.updateSkinOptions, self, skins, slot, priority, niceName)

	local gameView = self:getView():getGameView()
	gameView:getResourceManager():queueEvent(self._updateSkinOptions)

	self.skinOptionLayout:getInnerPanel():setScroll(0, 0)
	self.skinOptionLayout:setScrollSize(self.skinOptionLayout:getInnerPanel():getSize())

	self:populatePaletteOptions(palette or {})
end

function CharacterCustomization:onSelectSkin(skinInfo, button)
	if self.activeSkinButton == button then
		return
	end

	if self.activeSkinButton then
		self.activeSkinButton:setStyle(ButtonStyle(self.INACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
	end
	button:setStyle(ButtonStyle(self.ACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))

	self.activeSkinButton = button

	if skinInfo then
		self.newPlayerSkin[skinInfo.niceName] = {
			slot = skinInfo.slot,
			priority = skinInfo.priority,
			type = "ItsyScape.Game.Skin.ModelSkin",
			filename = skinInfo.skin.filename,
			name = skinInfo.skin.name
		}

		self.currentModelSkin = ModelSkin()
		self.currentModelSkin:loadFromFile(skinInfo.skin.filename)

		self:updateCurrentPlayer(
			self.characterSceneSnippet,
			self:getState().skins,
			self.newPlayerSkin,
			self.currentPlayerActor,
			self.currentPlayerActorView)

		self:updateColorOptions()
	end
end

function CharacterCustomization:populatePaletteOptions(palette)
	self.paletteLayout:clearChildren()

	for _, color in ipairs(palette) do
		local inactive = Color(unpack(color))
		local pressed = inactive - 0.2
		local hover = inactive + 0.2

		local style = {
			inactive = inactive,
			pressed = pressed,
			hover = hover
		}

		local h, s, l = inactive:toHSL()

		local button = Button()
		button:setStyle(ButtonStyle(style, self:getView():getResources()))
		button.onClick:register(self.updateColor, self, h * 255, s * 255, l * 255)

		self.paletteLayout:addChild(button)
	end
end

function CharacterCustomization:updateColorOptions()
	self.activeColorSelectionButton = nil

	local colorOptions = {}
	for _, color in ipairs(self.currentModelSkin:getColors()) do
		if not color.parent then
			table.insert(colorOptions, color.name)
		end
	end

	if #colorOptions == 0 then
		colorOptions = { "Primary" }
	end

	self.currentColorIndex = math.clamp(self.currentColorIndex, 1, #colorOptions)

	self.colorSelectionLayout:clearChildren()
	for index, name in ipairs(colorOptions) do
		local button = Button()

		if index == self.currentColorIndex then
			self.activeColorSelectionButton = button
			button:setStyle(ButtonStyle(self.ACTIVE_BUTTON_STYLE, self:getView():getResources()))
		else
			button:setStyle(ButtonStyle(self.INACTIVE_BUTTON_STYLE, self:getView():getResources()))
		end

		button.onClick:register(self.changeCurrentColorIndex, self, index)
		button:setToolTip(name)
		button:setText(tostring(index))

		self.colorSelectionLayout:addChild(button)
	end

	local colorConfig = self.colorConfig[self.currentSlot]
	local color = colorConfig and colorConfig[self.currentColorIndex]
	if color then
		local h, s, l = Color(unpack(color)):toHSL()
		self:updateColor(h * 255, s * 255, l * 255)
	end
end

function CharacterCustomization:changeCurrentColorIndex(index, button)
	if self.activeColorSelectionButton == button then
		return
	end

	if self.activeColorSelectionButton then
		self.activeColorSelectionButton:setStyle(ButtonStyle(self.INACTIVE_BUTTON_STYLE, self:getView():getResources()))
	end

	self.activeColorSelectionButton = button
	button:setStyle(ButtonStyle(self.ACTIVE_BUTTON_STYLE, self:getView():getResources()))

	self.currentColorIndex = math.clamp(index, 1, self.colorSelectionLayout:getNumChildren())

	local colors = self.colorConfig[self.currentSlot]
	local color = colors and colors[self.currentColorIndex]
	if color then
		local h, s, l = Color(unpack(color)):toHSL()
		self:updateColor(h * 255, s * 255, l * 255)
	end
end

function CharacterCustomization:submit()
	local e = {
		description = self.description,
		skins = self:getState().skins
	}

	for slotName, skin in pairs(self.newPlayerSkin) do
		local colorConfig = {}

		for _, color in ipairs(self.colorConfig[slotName] or {}) do
			table.insert(colorConfig, { unpack(color) })
		end

		e.skins[slotName] = {
			slot = skin.slot,
			priority = skin.priority,
			type = skin.type,
			filename = skin.filename,
			name = skin.name,
			config = colorConfig
		}
	end

	self:sendPoke("submit", nil, e)
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

	if self.pendingUpdatedColor then
		self.pendingUpdatedColorTime = (self.pendingUpdatedColorTime or 0) + delta

		if self.pendingUpdatedColorTime >= self.UPDATE_COLOR_FPS then
			self:_updateSkins()

			self.pendingUpdatedColor = nil
			self.pendingUpdatedColorTime = nil
		end
	end
end

return CharacterCustomization
