--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Nominomicon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local Widget = require "ItsyScape.UI.Widget"

local Update = Class(Widget)

Update.WIDTH  = 640
Update.HEIGHT = 544
Update.PADDING = 8
Update.BUTTON_WIDTH = 128
Update.BUTTON_HEIGHT = 48

function Update:new(app)
	Widget.new(self)

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)

	local panel = Panel()
	panel:setPosition(w / 2 - Update.WIDTH / 2, h / 2 - Update.HEIGHT / 2)
	panel:setSize(Update.WIDTH, Update.HEIGHT)
	self:addChild(panel)

	local patchNotesContainerBackground = Panel()
	patchNotesContainerBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, app:getUIView():getResources()))
	patchNotesContainerBackground:setSize(
		Update.WIDTH - Update.PADDING * 2,
		Update.HEIGHT - Update.BUTTON_HEIGHT - Update.PADDING * 4)
	patchNotesContainerBackground:setPosition(Update.PADDING, Update.PADDING)
	panel:addChild(patchNotesContainerBackground)

	self.patchNotesContainer = ScrollablePanel(GridLayout)
	self.patchNotesContainer:setPosition(Update.PADDING * 2, Update.PADDING * 2)
	self.patchNotesContainer:setSize(
		Update.WIDTH - Update.PADDING * 4,
		Update.HEIGHT - Update.BUTTON_HEIGHT - Update.PADDING * 6)
	self.patchNotesContainer:getInnerPanel():setWrapContents(true)
	self.patchNotesContainer:getInnerPanel():setSize(Update.WIDTH - Update.PADDING * 5 - ScrollablePanel.DEFAULT_SCROLL_SIZE, 0)
	panel:addChild(self.patchNotesContainer)

	self.patchNotes = RichTextLabel()
	self.patchNotes:setSize(self.patchNotesContainer:getInnerPanel():getSize())
	self.patchNotes:setWrapContents(true)
	self.patchNotesContainer:addChild(self.patchNotes)
	self.patchNotes:setText(app.patchNotes.patchNotes)

	self.patchNotes.onSize:register(function()
		local _, scrollHeight = self.patchNotes:getSize()
		self.patchNotesContainer:getInnerPanel():setSize(self.patchNotes:getSize())
		self.patchNotesContainer:setScrollSize(self.patchNotesContainer:getSize(), scrollHeight)
	end)

	self.versionLabel = Label()
	self.versionLabel:setText(app.patchNotes.version)
	self.versionLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, app:getUIView():getResources()))
	self.versionLabel:setPosition(Update.PADDING, Update.HEIGHT - Update.BUTTON_HEIGHT - Update.PADDING)
	panel:addChild(self.versionLabel)

	self.closeButton = Button()
	self.closeButton:setText("Close")
	self.closeButton:setPosition(
		Update.WIDTH - Update.BUTTON_WIDTH - Update.PADDING,
		Update.HEIGHT - Update.BUTTON_HEIGHT - Update.PADDING * 2)
	self.closeButton:setSize(Update.BUTTON_WIDTH, Update.BUTTON_HEIGHT)
	self.closeButton.onClick:register(function()
		self:onClose()
	end)
	panel:addChild(self.closeButton)

	self.onClose = Callback()
end

function Update:updatePatchNotes(text)
	self.patchNotes:setText(text)
end

return Update
