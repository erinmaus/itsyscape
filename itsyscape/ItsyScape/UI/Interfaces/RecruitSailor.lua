--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/RecruitSailor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local NullActor = require "ItsyScape.Game.Null.Actor"
local ActorView = require "ItsyScape.Graphics.ActorView"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local RecruitSailor = Class(Interface)
RecruitSailor.WIDTH = 800
RecruitSailor.HEIGHT = 600
RecruitSailor.TAB_SIZE = 48
RecruitSailor.CARD_BUTTON_WIDTH = 160
RecruitSailor.CARD_BUTTON_HEIGHT = 180
RecruitSailor.PADDING = 8

RecruitSailor.GENDERS = {
	["male"] = "Male",
	["female"] = "Female",
	["x"] = "Non-binary"
}

RecruitSailor.ACTIVE_CREW_STYLE = function()
	return {
		pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
		inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
		fontSize = 16,
		textShadow = true
	}
end

RecruitSailor.INACTIVE_CREW_STYLE = function()
	return {
		pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
		inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
		fontSize = 16,
		textShadow = true
	}
end

function RecruitSailor:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(RecruitSailor.WIDTH, RecruitSailor.HEIGHT)
	self:setPosition(
		(w - RecruitSailor.WIDTH) / 2,
		(h - RecruitSailor.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(RecruitSailor.WIDTH, RecruitSailor.HEIGHT)
	self:addChild(panel)

	self.closeButton = Button()
	self.closeButton:setSize(RecruitSailor.TAB_SIZE, RecruitSailor.TAB_SIZE)
	self.closeButton:setPosition(RecruitSailor.WIDTH - RecruitSailor.TAB_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(5)
	self.camera:setPosition(Vector.UNIT_Y)
	self.camera:setUp(-Vector.UNIT_Y)
	self.camera:setVerticalRotation(-math.pi / 2)
	self.camera:setHorizontalRotation(-math.pi / 12)
	self.camera:setWidth(RecruitSailor.CARD_BUTTON_WIDTH)
	self.camera:setHeight(RecruitSailor.CARD_BUTTON_HEIGHT)

	self.recruitablesPanel = ScrollablePanel(GridLayout)
	self.recruitablesPanel:getInnerPanel():setWrapContents(true)
	self.recruitablesPanel:getInnerPanel():setPadding(
		RecruitSailor.PADDING,
		RecruitSailor.PADDING)
	self.recruitablesPanel:getInnerPanel():setUniformSize(
		true,
		RecruitSailor.CARD_BUTTON_WIDTH,
		RecruitSailor.CARD_BUTTON_HEIGHT)
	self.recruitablesPanel:setSize(
		RecruitSailor.WIDTH / 2,
		RecruitSailor.HEIGHT)
	self:addChild(self.recruitablesPanel)

	self.crewPanel = Panel()
	self.crewPanel:setStyle(PanelStyle({}, ui:getResources()))
	self.crewPanel:setSize(RecruitSailor.WIDTH / 2,
		RecruitSailor.HEIGHT)
	self.crewPanel:setPosition(RecruitSailor.WIDTH / 2, RecruitSailor.TAB_SIZE)
	self:addChild(self.crewPanel)

	self.crewInfoPanel = Panel()
	self.crewInfoPanel:setStyle(PanelStyle({}, ui:getResources()))
	self.crewInfoPanel:setSize(
		RecruitSailor.WIDTH / 2,
		RecruitSailor.HEIGHT / 2 - RecruitSailor.PADDING * 2 - RecruitSailor.TAB_SIZE)
	self.crewInfoPanel:setPosition(0, 0)
	do
		local panelWidth, panelHeight = self.crewInfoPanel:getSize()

		local header = Label()
		header:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 26,
			textShadow = true,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		header:setPosition(RecruitSailor.PADDING, RecruitSailor.PADDING)
		self.crewInfoPanel:addChild(header)

		local description = Label()
		description:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
			fontSize = 24,
			textShadow = true,
			width = panelWidth - RecruitSailor.PADDING * 2,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		description:setPosition(
			RecruitSailor.PADDING,
			RecruitSailor.PADDING + 32)
		self.crewInfoPanel:addChild(description)

		local gender = Label()
		gender:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
			fontSize = 24,
			textShadow = true,
			width = panelWidth - RecruitSailor.PADDING * 2,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		gender:setPosition(
			RecruitSailor.PADDING,
			panelHeight - RecruitSailor.PADDING - 24 * 2)
		self.crewInfoPanel:addChild(gender)

		self.crewInfoPanel:setData('header', header)
		self.crewInfoPanel:setData('description', description)
		self.crewInfoPanel:setData('gender', gender)
	end
	self.crewPanel:addChild(self.crewInfoPanel)

	self.buyPanel = Panel()
	self.buyPanel:setStyle(PanelStyle({}, ui:getResources()))
	self.buyPanel:setSize(
		RecruitSailor.WIDTH / 2,
		RecruitSailor.HEIGHT / 2 - RecruitSailor.PADDING * 2 - RecruitSailor.TAB_SIZE)
	self.buyPanel:setPosition(
		0,
		RecruitSailor.HEIGHT / 2)
	do
		local panelWidth, panelHeight = self.buyPanel:getSize()

		self.requirementsConstraints = ConstraintsPanel(ui)
		self.requirementsConstraints:setSize(
			panelWidth / 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
			0)
		self.requirementsConstraints:setText("Requirements")

		local requirementsConstraintsParent = ScrollablePanel(Panel)
		requirementsConstraintsParent:getInnerPanel():setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, ui:getResources()))
		requirementsConstraintsParent:addChild(self.requirementsConstraints)
		requirementsConstraintsParent:setSize(panelWidth / 2, panelHeight - RecruitSailor.TAB_SIZE - RecruitSailor.PADDING * 2)
		requirementsConstraintsParent:setPosition(0, 0)
		self.buyPanel:addChild(requirementsConstraintsParent)

		self.inputConstraints = ConstraintsPanel(ui)
		self.inputConstraints:setSize(
			panelWidth / 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
			0)
		self.inputConstraints:setText("Cost")

		local inputConstraintsParent = ScrollablePanel(Panel)
		inputConstraintsParent:getInnerPanel():setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, ui:getResources()))
		inputConstraintsParent:addChild(self.inputConstraints)
		inputConstraintsParent:setSize(panelWidth / 2, panelHeight - RecruitSailor.TAB_SIZE - RecruitSailor.PADDING * 2)
		inputConstraintsParent:setPosition(panelWidth / 2, 0)
		self.buyPanel:addChild(inputConstraintsParent)

		local buyButton = Button()
		buyButton:setSize(panelWidth / 2, RecruitSailor.TAB_SIZE)
		buyButton:setPosition(panelWidth / 4, panelHeight - RecruitSailor.TAB_SIZE - RecruitSailor.PADDING)
		buyButton:setText("Recruit!")
		buyButton.onClick:register(self.recruit, self)
		self.buyPanel:addChild(buyButton)

		local label = Label()
		label:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
			fontSize = 24,
			textShadow = true,
			width = panelWidth - RecruitSailor.PADDING * 2,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		label:setPosition(RecruitSailor.PADDING, panelHeight - RecruitSailor.TAB_SIZE - RecruitSailor.PADDING)
		label:setText('You must discharge a crew member to recruit another.')
		self.buyPanel:addChild(label)

		self.buyPanel:setData('button', buyButton)
		self.buyPanel:setData('label', label)
	end
	self.crewPanel:addChild(self.buyPanel)

	self.recruitables = {}
	self:populateRecruitables(true)
end

function RecruitSailor:populateRecruitable(recruitable, index)
	local button = Button()

	if self.activeRecruitableID == recruitable.id then
		button:setStyle(ButtonStyle(
			RecruitSailor.ACTIVE_CREW_STYLE(),
			self:getView():getResources()))
		self.activeButton = button
		self:populateCrewPanel(recruitable)
	else
		button:setStyle(ButtonStyle(
			RecruitSailor.INACTIVE_CREW_STYLE(),
			self:getView():getResources()))
	end

	button:setToolTip(
		ToolTip.Header(recruitable.flavor.name),
		ToolTip.Text(recruitable.name),
		ToolTip.Text(recruitable.description))

	local scene = SceneSnippet()
	scene:setSize(RecruitSailor.CARD_BUTTON_WIDTH, RecruitSailor.CARD_BUTTON_HEIGHT)
	scene:setCamera(self.camera)
	button:addChild(scene)

	do
		local actor = NullActor()
		local actorView = ActorView(actor, index)
		actorView:attach(self:getView():getGameView())

		actor:setBody(CacheRef(
			recruitable.storage.body.type,
			recruitable.storage.body.filename))

		local animation = string.format(
			"Resources/Game/Animations/%s_Idle_1/Script.lua",
			recruitable.storage.body.filename:match("([%w_]+)%.lskel$"))
		actor:playAnimation(
			1,
			math.huge,
			CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				animation))

		for i = 1, #recruitable.storage.skin do
			local skin = recruitable.storage.skin[i]
			local priority = skin.priority
			local slot = skin.slot
			local skinType = skin.type
			local skinFilename = skin.filename

			if skinType and skinFilename then
				actor:setSkin(slot, priority, CacheRef(skinType, skinFilename))
			end
		end

		scene:setRoot(actorView:getSceneNode())
		button:setData('view', actorView)
	end

	local label = Label()
	label:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 18,
		textShadow = true,
		color = { 1, 1, 1, 1 },
		width = RecruitSailor.CARD_BUTTON_WIDTH - RecruitSailor.PADDING * 2
	}, self:getView():getResources()))
	label:setText(recruitable.flavor.name)
	label:setPosition(
		RecruitSailor.PADDING,
		RecruitSailor.CARD_BUTTON_HEIGHT - RecruitSailor.PADDING - 18)
	button:addChild(label)

	button.onClick:register(self.onClickSailor, self, recruitable)

	return button
end

function RecruitSailor:populateRecruitables(init)
	for i = 1, #self.recruitables do
		self.recruitablesPanel:removeChild(self.recruitables[i])
	end
	self.recruitables = {}

	local state = self:getState()
	if init and #state.recruitables >= 1 then
		local firstRecruitable = state.recruitables[1]

		self.activeRecruitableID = firstRecruitable.id
	end

	for i = 1, #state.recruitables do
		local recruitable = state.recruitables[i]
		local button = self:populateRecruitable(recruitable)

		self.recruitablesPanel:addChild(button)
		table.insert(self.recruitables, button)
	end

	self.recruitablesPanel:setScrollSize(
		self.recruitablesPanel:getInnerPanel():getSize())
	self.recruitablesPanel:performLayout()
	if init then
		self.recruitablesPanel:getInnerPanel():setScroll(0, 0)
	end
end

function RecruitSailor:populateCrew()
	self:populateRecruitables(false)
end

function  RecruitSailor:update(delta)
	Interface.update(self, delta)

	for i = 1, #self.recruitables do
		local actorView = self.recruitables[i]:getData('view')
		if actorView then
			actorView:update(delta)
		end
	end

	local canRecruit = self:getState().canRecruit
	if canRecruit ~= self.canRecruit and self.recruitable then
		self:populateCrewPanel(self.recruitable)
	end
end

function RecruitSailor:populateCrewPanel(recruitable)
	self.requirementsConstraints:setData("skillAsLevel", true)
	self.requirementsConstraints:setConstraints(recruitable.constraints.requirements)
	self.requirementsConstraints:getParent():setSize(self.requirementsConstraints:getSize())
	self.requirementsConstraints:getParent():setScroll(0, 0)
	self.requirementsConstraints:getParent():getParent():setScrollSize(self.requirementsConstraints:getParent():getSize())

	self.inputConstraints:setData("skillAsLevel", false)
	self.inputConstraints:setConstraints(recruitable.constraints.inputs)
	self.inputConstraints:getParent():setSize(self.inputConstraints:getSize())
	self.inputConstraints:getParent():setScroll(0, 0)
	self.inputConstraints:getParent():getParent():setScrollSize(self.inputConstraints:getParent():getSize())

	local name = self.crewInfoPanel:getData('header')
	name:setText(string.format("%s (%s)", recruitable.flavor.name, recruitable.name))

	local description = self.crewInfoPanel:getData('description')
	description:setText(recruitable.description)

	local gender = self.crewInfoPanel:getData('gender')
	gender:setText(string.format("%s: %s/%s/%s",
		recruitable.flavor.gender,
		recruitable.flavor.pronouns[1],
		recruitable.flavor.pronouns[2],
		recruitable.flavor.pronouns[3]))

	local recruitButton = self.buyPanel:getData('button')
	local warningLabel = self.buyPanel:getData('label')

	local state = self:getState()
	if state.canRecruit then
		self.buyPanel:addChild(recruitButton)
		self.buyPanel:removeChild(warningLabel)
	else
		self.buyPanel:addChild(warningLabel)
		self.buyPanel:removeChild(recruitButton)
	end

	self.canRecruit = state.canRecruit
	self.recruitable = recruitable
end

function RecruitSailor:onClickSailor(recruitable, button)
	if self.activeButton then
		self.activeButton:setStyle(ButtonStyle(
			RecruitSailor.INACTIVE_CREW_STYLE(),
			self:getView():getResources()))
	end

	button:setStyle(ButtonStyle(
		RecruitSailor.ACTIVE_CREW_STYLE(),
		self:getView():getResources()))

	self.activeButton = button
	self.activeRecruitableID = recruitable.id

	self:populateCrewPanel(recruitable)
end

function RecruitSailor:recruit()
	if self.activeRecruitableID then
		self:sendPoke("recruit", nil, { id = self.activeRecruitableID })
	end
end

return RecruitSailor
