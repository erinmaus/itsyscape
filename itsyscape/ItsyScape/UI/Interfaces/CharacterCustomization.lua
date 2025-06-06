--------------------------------------------------------------------------------
-- ItsyScape/UI/CharacterCustomization.lua
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
local Color = require "ItsyScape.Graphics.Color"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
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
local Widget = require "ItsyScape.UI.Widget"
local DialogBox = require "ItsyScape.UI.Interfaces.DialogBox"

local CharacterCustomization = Class(Interface)

CharacterCustomization.BUTTON_SIZE = 48
CharacterCustomization.CONFIRM_BUTTON_WIDTH = 128
CharacterCustomization.CONFIRM_BUTTON_HEIGHT = 64
CharacterCustomization.PADDING = 8
CharacterCustomization.CUSTOMIZATION_WIDTH = 480
CharacterCustomization.INFO_WIDTH = 320
CharacterCustomization.INFO_HEIGHT = 540
CharacterCustomization.CUSTOMIZATION_HEIGHT = 540
CharacterCustomization.INPUT_HEIGHT = 64
CharacterCustomization.LABEL_HEIGHT = 48

CharacterCustomization.MAX_WIDTH = 1280
CharacterCustomization.MAX_HEIGHT = 800

CharacterCustomization.TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true
}

CharacterCustomization.BUTTON_STYLE = {
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

CharacterCustomization.DESCRIPTION_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 32,
	textShadow = true
}

CharacterCustomization.SELECT_INACTIVE_BOX_BUTTON_STYLE = {
	inactive = Color(0, 0, 0, 0),
	hover = Color(0.7, 0.6, 0.5),
	active = Color(0.5, 0.4, 0.3),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = _MOBILE and 28 or 24,
	textX = 0.0,
	textY = 0.5,
	textAlign = 'left',
	textShadow = true
}

CharacterCustomization.SELECT_ACTIVE_BOX_BUTTON_STYLE = {
	inactive = Color(0.7, 0.6, 0.5),
	hover = Color(0.7, 0.6, 0.5),
	active = Color(0.5, 0.4, 0.3),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = _MOBILE and 28 or 24,
	textX = 0.0,
	textY = 0.5,
	textAlign = 'left',
	textShadow = true
}

CharacterCustomization.VALUE_STYLE = {
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

CharacterCustomization.DIALOG_WIDTH  = 960
CharacterCustomization.DIALOG_HEIGHT = 240
CharacterCustomization.DIALOG_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 32,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	align = 'center',
	spaceLines = true
}

CharacterCustomization.DIALOG_CLICK_TO_CONTINUE_STYLE = {
	align = 'center',
	textShadow = true,
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = _MOBILE and 28 or 24
}

function CharacterCustomization:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.onChangeSlot = Callback()
	self.onChangeGender = Callback()
	self.onChangeGenderDescription = Callback()
	self.onChangeGenderPronouns = Callback()
	self.onChangeGenderPlurality = Callback()

	local w, h = love.graphics.getScaledMode()
	self:setSize(
		math.min(w, CharacterCustomization.MAX_WIDTH),
		math.min(h, CharacterCustomization.MAX_HEIGHT))

	local selfW, selfH = self:getSize()
	self:setPosition(w / 2 - selfW / 2, h / 2 - selfH / 2)

	w, h = selfW, selfH

	local isTooSmall = h < (CharacterCustomization.INFO_HEIGHT + CharacterCustomization.DIALOG_HEIGHT)

	self.panel = Panel()
	self.panel:setSize(w, h)
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	self.inputs = {}

	local mainLayout = GridLayout()
	do
		local minWidth = CharacterCustomization.CUSTOMIZATION_WIDTH + CharacterCustomization.INFO_WIDTH * 2

		local columns
		if w < minWidth then
			columns = 2
			minWidth = CharacterCustomization.CUSTOMIZATION_WIDTH + CharacterCustomization.INFO_WIDTH
		else
			columns = 3
		end

		local padding = math.floor((w - minWidth) / columns)
		mainLayout:setSize(w, 0)
		mainLayout:setPadding(padding / 2, CharacterCustomization.PADDING)
		mainLayout:setWrapContents(true)
	end
	self:addChild(mainLayout)

	do
		local LABEL_WIDTH = 96
		local ARROW_BUTTON_WIDTH = 64
		local ARROW_BUTTON_WIDTH = 64
		local VALUE_WIDTH = 196

		local panel = Panel()
		panel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
		panel:setSize(CharacterCustomization.CUSTOMIZATION_WIDTH, CharacterCustomization.CUSTOMIZATION_HEIGHT)
		panel:setPosition(
			CharacterCustomization.PADDING,
			CharacterCustomization.PADDING)

		local titleLabel = Label()
		titleLabel:setText("Appearance")
		titleLabel:setStyle(LabelStyle(CharacterCustomization.TITLE_LABEL_STYLE, ui:getResources()))
		panel:addChild(titleLabel)

		local gridLayout = GridLayout()
		gridLayout:setSize(CharacterCustomization.CUSTOMIZATION_WIDTH, CharacterCustomization.CUSTOMIZATION_HEIGHT)
		gridLayout:setPosition(
			0,
			CharacterCustomization.PADDING + CharacterCustomization.BUTTON_SIZE)
		gridLayout:setPadding(4, 4)
		panel:addChild(gridLayout)

		self.peepSnippet = SceneSnippet()
		self.peepSnippet:setSize(
			VALUE_WIDTH,
			CharacterCustomization.CUSTOMIZATION_HEIGHT - CharacterCustomization.PADDING * 2)
		self.peepSnippet:setPosition(
			ARROW_BUTTON_WIDTH + LABEL_WIDTH + CharacterCustomization.PADDING,
			CharacterCustomization.PADDING + CharacterCustomization.BUTTON_SIZE)
		panel:addChild(self.peepSnippet)

		local function addOption(description, slot)
			local descriptionLabel = Label()
			descriptionLabel:setText(description .. ":")
			descriptionLabel:setStyle(LabelStyle(CharacterCustomization.DESCRIPTION_STYLE, self:getView():getResources()))
			descriptionLabel:setSize(LABEL_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			gridLayout:addChild(descriptionLabel)

			local descriptionPrev = Button()
			descriptionPrev:setSize(ARROW_BUTTON_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			descriptionPrev:setText("<")
			descriptionPrev:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
			descriptionPrev.onClick:register(self.previousWardrobe, self, slot)
			gridLayout:addChild(descriptionPrev)

			local panel = Panel()
			panel:setSize(VALUE_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			panel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
			gridLayout:addChild(panel)

			local descriptionNext = Button()
			descriptionNext:setSize(ARROW_BUTTON_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			descriptionNext:setText(">")
			descriptionNext.onClick:register(self.nextWardrobe, self, slot)
			descriptionNext:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
			gridLayout:addChild(descriptionNext)
		end

		addOption("Hair", "hair")
		addOption("Eyes", "eyes")
		addOption("Head", "head")
		addOption("Body", "body")
		addOption("Hands", "hands")
		addOption("Feet", "feet")

		mainLayout:addChild(panel)
	end

	do
		local state = self:getState()

		local INPUT_WIDTH = CharacterCustomization.INFO_WIDTH - CharacterCustomization.PADDING * 2
		local INPUT_HEIGHT = _MOBILE and CharacterCustomization.INPUT_HEIGHT or 48

		local panel = Panel()
		panel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
		panel:setSize(CharacterCustomization.INFO_WIDTH, CharacterCustomization.INFO_HEIGHT)
		panel:setPosition(
			CharacterCustomization.PADDING + CharacterCustomization.INFO_WIDTH,
			CharacterCustomization.PADDING)

		local titleLabel = Label()
		titleLabel:setText("Basics")
		titleLabel:setStyle(LabelStyle(CharacterCustomization.TITLE_LABEL_STYLE, ui:getResources()))
		panel:addChild(titleLabel)

		local basic = GridLayout()
		basic:setWrapContents(true)
		basic:setSize(CharacterCustomization.INFO_WIDTH, CharacterCustomization.INFO_HEIGHT)
		basic:setPadding(CharacterCustomization.PADDING, CharacterCustomization.PADDING)
		basic:setPosition(0, CharacterCustomization.BUTTON_SIZE)

		local nameLabel = Label()
		nameLabel:setText("Name:")
		nameLabel:setStyle(LabelStyle(CharacterCustomization.VALUE_STYLE, self:getView():getResources()))
		nameLabel:setSize(INPUT_WIDTH, CharacterCustomization.LABEL_HEIGHT)
		basic:addChild(nameLabel)

		local nameInput = TextInput()
		nameInput:setHint("Enter your name")
		nameInput:setStyle(TextInputStyle(CharacterCustomization.TEXT_INPUT_STYLE, ui:getResources()))
		nameInput:setText(state.name)
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
		nameInput:setSize(INPUT_WIDTH, INPUT_HEIGHT)
		basic:addChild(nameInput)
		table.insert(self.inputs, nameInput)

		local genderLabel = Label()
		genderLabel:setText("Gender:")
		genderLabel:setStyle(LabelStyle(CharacterCustomization.VALUE_STYLE, self:getView():getResources()))
		genderLabel:setSize(INPUT_WIDTH, CharacterCustomization.LABEL_HEIGHT)
		basic:addChild(genderLabel)

		local genderSelect = ScrollablePanel(GridLayout)
		genderSelect:setScrollBarVisible(true, false)
		genderSelect:getInnerPanel():setPadding(0, 0)
		genderSelect:getInnerPanel():setUniformSize(true,
			INPUT_WIDTH,
			INPUT_HEIGHT)
		genderSelect:getInnerPanel():setSize(
			INPUT_WIDTH,
			INPUT_HEIGHT * 3)
		genderSelect:setSize(
			INPUT_WIDTH,
			INPUT_HEIGHT * 3)

		local function addGender(name, value)
			local button = Button()
			button:setText(name)
			button:setStyle(ButtonStyle(CharacterCustomization.SELECT_INACTIVE_BOX_BUTTON_STYLE, self:getView():getResources()))
			button:setSize(CharacterCustomization.INFO_WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE)
			button.onClick:register(self.changeGender, self, value)
			self.onChangeGender:register(function(newValue)
				if value == newValue then
					button:setStyle(ButtonStyle(CharacterCustomization.SELECT_ACTIVE_BOX_BUTTON_STYLE, self:getView():getResources()))
				else
					button:setStyle(ButtonStyle(CharacterCustomization.SELECT_INACTIVE_BOX_BUTTON_STYLE, self:getView():getResources()))
				end
			end)

			genderSelect:addChild(button)
		end

		addGender("- Male", 'male')
		addGender("- Female", 'female')
		addGender("- Something Else", 'x')

		basic:addChild(genderSelect)

		local descriptionLabel = Label()
		descriptionLabel:setText("Gender Description:")
		descriptionLabel:setStyle(LabelStyle(CharacterCustomization.VALUE_STYLE, self:getView():getResources()))
		descriptionLabel:setSize(INPUT_WIDTH, CharacterCustomization.LABEL_HEIGHT)
		basic:addChild(descriptionLabel)

		local descriptionInput = TextInput()
		descriptionInput:setHint("Enter your description")
		descriptionInput:setText(state.description)
		descriptionInput:setStyle(TextInputStyle(CharacterCustomization.TEXT_INPUT_STYLE, ui:getResources()))
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
		descriptionInput:setSize(INPUT_WIDTH, INPUT_HEIGHT)
		self.onChangeGenderDescription:register(function(newValue)
			descriptionInput:setText(newValue)
		end)
		basic:addChild(descriptionInput)
		table.insert(self.inputs, descriptionInput)

		panel:addChild(basic)

		local basicWidth, basicHeight = basic:getSize()
		panel:setSize(basicWidth, basicHeight + CharacterCustomization.BUTTON_SIZE)
		mainLayout:addChild(panel)
	end

	do
		local state = self:getState()

		local INPUT_WIDTH = (CharacterCustomization.INFO_WIDTH - CharacterCustomization.PADDING * 2) / 2
		local INPUT_HEIGHT = _MOBILE and CharacterCustomization.INPUT_HEIGHT or 48

		local panel = Panel()
		panel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
		panel:setSize(CharacterCustomization.INFO_WIDTH, CharacterCustomization.INFO_HEIGHT)
		panel:setPosition(
			CharacterCustomization.PADDING * 3 + CharacterCustomization.INFO_WIDTH * 2,
			CharacterCustomization.PADDING)

		local titleLabel = Label()
		titleLabel:setText("Pronouns")
		titleLabel:setStyle(LabelStyle(CharacterCustomization.TITLE_LABEL_STYLE, ui:getResources()))
		panel:addChild(titleLabel)

		local grid = GridLayout()
		grid:setUniformSize(true, INPUT_WIDTH, INPUT_HEIGHT)
		grid:setPadding(0, CharacterCustomization.PADDING)
		grid:setSize(CharacterCustomization.INFO_WIDTH, 0)
		grid:setWrapContents(true)
		grid:setPosition(0, CharacterCustomization.BUTTON_SIZE)

		local function addPronoun(name, key)
			local label = Label()
			label:setText(name)
			label:setStyle(LabelStyle(CharacterCustomization.VALUE_STYLE, ui:getResources()))
			grid:addChild(label)

			local input = TextInput()
			input:setHint(string.format("Enter your %s pronoun", name:lower()))
			input:setStyle(TextInputStyle(CharacterCustomization.TEXT_INPUT_STYLE, ui:getResources()))
			input:setText(state.pronouns[key])
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
			grid:addChild(input)
			table.insert(self.inputs, input)
		end

		addPronoun("Subject", "subject")
		addPronoun("Object", "object")
		addPronoun("Possessive", "possessive")
		addPronoun("Formal", "formal")

		local function setPronounPlurality(text, isPlural)
			local button = Button()
			button:setText(text)
			button.onClick:register(function()
				self:changePronounPlurality(isPlural)
			end)

			local setStyle = function(newValue)
				if isPlural == newValue then
					button:setStyle(ButtonStyle(CharacterCustomization.ACTIVE_BUTTON_STYLE, ui:getResources()))
				else
					button:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
				end
			end

			self.onChangeGenderPlurality:register(setStyle)
			setStyle(state.pronouns.plural)

			grid:addChild(button)
		end

		setPronounPlurality("Plural", true)
		setPronounPlurality("Singular", false)

		panel:addChild(grid)
		mainLayout:addChild(panel)

		if isTooSmall then
			local x, y = panel:getPosition()
			local gridWidth, gridHeight = grid:getSize()

			local viewDialogButton = Button()
			viewDialogButton:setText("Dialogue Example")
			viewDialogButton:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
			viewDialogButton:setPosition(0, gridHeight + CharacterCustomization.PADDING + INPUT_HEIGHT)
			viewDialogButton:setSize(gridWidth - CharacterCustomization.PADDING * 2, CharacterCustomization.BUTTON_SIZE)
			viewDialogButton.onClick:register(self.showDialogExample, self)

			panel:addChild(viewDialogButton)

			local panelWidth, panelHeight = panel:getSize()
			panel:setSize(panelWidth, panelHeight + CharacterCustomization.BUTTON_SIZE + CharacterCustomization.PADDING)
		end
	end

	do
		local panel = Panel()
		panel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))

		if not isTooSmall then
			panel:setSize(CharacterCustomization.INFO_WIDTH, CharacterCustomization.INFO_HEIGHT)
			panel:setPosition(
				CharacterCustomization.PADDING * 3 + CharacterCustomization.INFO_WIDTH * 2,
				CharacterCustomization.PADDING)
			mainLayout:addChild(panel)
		end

		if isTooSmall then
			panel:setStyle(PanelStyle({ color = { 0, 0, 0, 0.75 } }, self:getView():getResources()))
			panel:setSize(w, h)

			self.dialogPanel = panel
		else
			local panelX, panelY = panel:getPosition()
			local mainLayoutWidth, mainLayoutHeight = mainLayout:getSize()
			local mainLayoutPaddingX, mainLayoutPaddingY = mainLayout:getPadding()
			local remainingWidth = mainLayoutWidth - panelX - mainLayoutPaddingX
			local remainingHeight = h - panelY - mainLayoutPaddingY * 2
			panel:setSize(remainingWidth, remainingHeight)
		end

		local panelWidth, panelHeight = panel:getSize()
		local dialogWidth, dialogHeight
		if isTooSmall then
			dialogWidth = CharacterCustomization.DIALOG_WIDTH
			dialogHeight = CharacterCustomization.DIALOG_HEIGHT
		else
			dialogWidth = math.min(panelWidth, CharacterCustomization.DIALOG_WIDTH)
			dialogHeight = math.min(panelHeight, CharacterCustomization.DIALOG_HEIGHT)
		end

		local dialogPanel = Panel()
		dialogPanel:setSize(dialogWidth, dialogHeight)
		dialogPanel:setPosition(
			panelWidth / 2 - dialogWidth / 2,
			panelHeight / 2 - dialogHeight / 2)
		panel:addChild(dialogPanel)

		if isTooSmall then
			local closeButton = Button()
			closeButton:setSize(dialogWidth / 2, CharacterCustomization.BUTTON_SIZE)

			local x, y = dialogPanel:getPosition()
			y = y + dialogHeight + CharacterCustomization.PADDING
			closeButton:setPosition(x + dialogWidth / 4, y)

			closeButton:setText("Return to character customization")
			closeButton.onClick:register(function()
				if panel:getParent() then
					panel:getParent():removeChild(panel)
				end
			end)

			closeButton:setStyle(ButtonStyle(CharacterCustomization.ACTIVE_BUTTON_STYLE, ui:getResources()))

			panel:addChild(closeButton)
		end

		local label = Label()
		label:setStyle(LabelStyle(CharacterCustomization.DIALOG_STYLE, ui:getResources()))
		label:setPosition(CharacterCustomization.PADDING, CharacterCustomization.PADDING)
		label:setSize(
			dialogWidth - CharacterCustomization.PADDING * 2,
			dialogHeight - CharacterCustomization.PADDING * 3 - 24)
		dialogPanel:addChild(label)

		local clickToContinue = Label()
		clickToContinue:setText("Click for example")
		clickToContinue:setStyle(LabelStyle(CharacterCustomization.DIALOG_CLICK_TO_CONTINUE_STYLE, ui:getResources()))
		clickToContinue:setSize(dialogWidth, 24)
		clickToContinue:setPosition(
			0,
			dialogHeight - 24 - CharacterCustomization.PADDING * 2)
		dialogPanel:addChild(clickToContinue)

		self.dialogLabel = label

		local nextButton = Button()
		nextButton:setStyle(ButtonStyle({
			hover = Color(0, 0, 0, 0.05),
			pressed = Color(0, 0, 0, 0.1)
		}, ui:getResources()))
		nextButton:setSize(dialogWidth, dialogHeight)
		nextButton.onClick:register(self.nextDialog, self)
		dialogPanel:addChild(nextButton)

		self:nextDialog()
	end

	self.closeButton = Button()
	self.closeButton:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
	self.closeButton:setSize(CharacterCustomization.BUTTON_SIZE, CharacterCustomization.BUTTON_SIZE)
	self.closeButton:setPosition(w - CharacterCustomization.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:submitTextInputs()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	local confirmButton = Button()
	confirmButton:setText("Confirm")
	confirmButton:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
	confirmButton:setSize(CharacterCustomization.CONFIRM_BUTTON_WIDTH, CharacterCustomization.CONFIRM_BUTTON_HEIGHT)
	confirmButton:setPosition(
		w - CharacterCustomization.CONFIRM_BUTTON_WIDTH - CharacterCustomization.PADDING,
		h - CharacterCustomization.CONFIRM_BUTTON_HEIGHT - CharacterCustomization.PADDING)
	confirmButton.onClick:register(function()
		self:submitTextInputs()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(confirmButton)

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(2.5)
	self.camera:setUp(Vector(0, -1, 0))
	self.peepSnippet:setCamera(self.camera)
end

function CharacterCustomization:getIsFullscreen()
	local w, h = love.graphics.getScaledMode()
	local selfW, selfH = self:getSize()
	return w == selfW and h == selfH
end

function CharacterCustomization:submitTextInputs()
	for i = 1, #self.inputs do
		self.inputs[i]:onSubmit(self.inputs[i]:getText())
	end
end

function CharacterCustomization:update(...)
	Interface.update(self, ...)

	if not self.ready then
		local state = self:getState()
		self.onChangeGender(state.gender)
		self.ready = true
	end

	self:updatePeep()
	self:refreshDialog()
end

function CharacterCustomization:updatePeep()
	local state = self:getState()

	local gameCamera = self:getView():getGameView():getRenderer():getCamera()
	self.camera:setHorizontalRotation(gameCamera:getHorizontalRotation())
	self.camera:setVerticalRotation(gameCamera:getVerticalRotation())

	local actor = self:getView():getGame():getPlayer():getActor()
	do
		local gameView = self:getView():getGameView()
		local actorView = gameView:getActor(actor)
		self.peepSnippet:setRoot(actorView:getSceneNode())
	end

	local offset
	local zoom
	if actor then
		local min, max = actor:getBounds()
		offset = (max.y - min.y) / 2 - 0.5
		zoom = (max.z - min.z) + math.max((max.y - min.y), (max.x - min.x)) + 4

		-- Flip if facing left.
		if actor:getDirection().x < 0 then
			self.camera:setVerticalRotation(
				self.camera:getVerticalRotation() + math.pi)
		end
	else
		offset = 0
		zoom = 1
	end

	local root = self.peepSnippet:getRoot()
	local transform = root:getTransform():getGlobalTransform()

	local x, y, z = transform:transformPoint(0, offset, 0)

	local w, h = self.peepSnippet:getSize()
	self.camera:setWidth(w)
	self.camera:setHeight(h)
	self.camera:setPosition(Vector(x, y, z))
	self.camera:setDistance(zoom)
end

function CharacterCustomization:updateGender(state)
	self.onChangeGender(state.gender)
	self.onChangeGenderDescription(state.description)
	self.onChangeGenderPronouns(state.pronouns)
	self.onChangeGenderPlurality(state.pronouns.plural)
end

function CharacterCustomization:previousWardrobe(slot)
	self:sendPoke("previousWardrobe", nil, {
		slot = slot
	})
end

function CharacterCustomization:nextWardrobe(slot)
	self:sendPoke("nextWardrobe", nil, {
		slot = slot
	})
end

function CharacterCustomization:changeSlot(slot, value)
	self.onChangeSlot(slot, value)
end

function CharacterCustomization:changeGender(value)
	self:sendPoke("changeGender", nil, {
		gender = value,
		refresh = false
	})
end

function CharacterCustomization:changeGenderDescription(value)
	self:sendPoke("changeGenderDescription", nil, {
		description = value,
		refresh = false
	})
end

function CharacterCustomization:changePronoun(index, value)
	self:sendPoke("changePronoun", nil, {
		index = index,
		value = value,
		refresh = false
	})
end

function CharacterCustomization:changePronounPlurality(value)
	self:sendPoke("changePronounPlurality", nil, {
		value = value,
		refresh = true
	})
end

function CharacterCustomization:changeName(value)
	self:sendPoke("changeName", nil, {
		name = value,
		refresh = false
	})
end

function CharacterCustomization:showDialogExample()
	self:addChild(self.dialogPanel)
end

function CharacterCustomization:nextDialog()
	local state = self:getState()
	self.dialogIndex = (((self.dialogIndex or -1) + 1) % #state.dialog)

	self:refreshDialog()
end

function CharacterCustomization:refreshDialog()
	local state = self:getState()
	local dialog = { state.dialog[self.dialogIndex + 1] }
	local preppedDialog = DialogBox.concatMessage(dialog)
	self.dialogLabel:setText(preppedDialog)
end

return CharacterCustomization
