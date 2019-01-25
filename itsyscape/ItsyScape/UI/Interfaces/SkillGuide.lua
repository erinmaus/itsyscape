--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/SkillGuide.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"
local SpellIcon = require "ItsyScape.UI.SpellIcon"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Widget = require "ItsyScape.UI.Widget"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local SkillGuide = Class(Interface)
SkillGuide.WIDTH = 480
SkillGuide.HEIGHT = 320
SkillGuide.BUTTON_SIZE = 48
SkillGuide.BUTTON_PADDING = 4
SkillGuide.PADDING = 4

SkillGuide.INACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 16,
	textShadow = true
}

SkillGuide.ACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 16,
	textShadow = true
}

function SkillGuide:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	local WIDTH = math.max(math.floor(w / 2), SkillGuide.WIDTH)
	local HEIGHT = math.max(math.floor(h / 2), SkillGuide.HEIGHT)

	self:setSize(WIDTH, HEIGHT)
	self:setPosition(
		(w - WIDTH) / 2,
		(h - HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.grid = ScrollablePanel(GridLayout)
	self.grid:getInnerPanel():setUniformSize(
		true,
		WIDTH * (1 / 2) - ScrollablePanel.DEFAULT_SCROLL_SIZE - SkillGuide.PADDING * 2,
		SkillGuide.BUTTON_SIZE + SkillGuide.BUTTON_PADDING * 2)
	self.grid:getInnerPanel():setWrapContents(true)
	self.grid:getInnerPanel():setPadding(SkillGuide.BUTTON_PADDING)
	self.grid:setSize(WIDTH * (1 / 2), HEIGHT)
	self:addChild(self.grid)

	self.infoPanel = ScrollablePanel(GridLayout)
	self.infoPanel:getInnerPanel():setWrapContents(true)
	self.infoPanel:getInnerPanel():setPadding(0, 0)
	self.infoPanel:getInnerPanel():setSize(WIDTH * (1 / 2), 0)
	self.infoPanel:setPosition(WIDTH * (1 / 2), 0)
	self.infoPanel:setSize(WIDTH * (1 / 2), HEIGHT)
	self:addChild(self.infoPanel)

	self.requirementsPanel = ConstraintsPanel(self:getView())
	self.requirementsPanel:setData('skillAsLevel', true)
	self.requirementsPanel:setText("Requirements")
	self.requirementsPanel:setSize(WIDTH * (1 / 2), 03)
	self.requirementsPanel:setPosition(WIDTH * (1 / 2), 0)
	self.infoPanel:addChild(self.requirementsPanel)

	self.inputsPanel = ConstraintsPanel(self:getView())
	self.inputsPanel:setText("Inputs")
	self.inputsPanel:setSize(WIDTH * (1 / 2), HEIGHT / 3)
	self.inputsPanel:setPosition(WIDTH * (1 / 2), HEIGHT / 3)
	self.infoPanel:addChild(self.inputsPanel)

	self.outputsPanel = ConstraintsPanel(self:getView())
	self.outputsPanel:setText("Outputs")
	self.outputsPanel:setSize(WIDTH * (1 / 2), HEIGHT / 3)
	self.outputsPanel:setPosition(WIDTH * (1 / 2), HEIGHT / 3)
	self.infoPanel:addChild(self.outputsPanel)

	self.closeButton = Button()
	self.closeButton:setSize(SkillGuide.BUTTON_SIZE, SkillGuide.BUTTON_SIZE)
	self.closeButton:setPosition(WIDTH - SkillGuide.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.ready = false
	self.activeItem = false
	self.previousSelection = false
end

function SkillGuide:update(...)
	Interface.update(self, ...)

	if not self.ready then
		local state = self:getState()
		local gameDB = self:getView():getGame():getGameDB()
		local brochure = gameDB:getBrochure()
		for i = 1, #state.actions do
			local action = gameDB:getAction(state.actions[i].id)
			if action then
				local item, quantity
				local prop, peep, spell, prayer
				for output in brochure:getOutputs(action) do
					local outputResource = brochure:getConstraintResource(output)
					local outputType = brochure:getResourceTypeFromResource(outputResource)
					if outputType.name == "Item" then
						item = outputResource
						quantity = output.count
						break
					end
				end

				for resource in brochure:findResourcesByAction(action) do
					local resourceType = brochure:getResourceTypeFromResource(resource)
					if resourceType.name == "Prop" then
						prop = resource
						break
					elseif resourceType.name == "Peep" then
						peep = resource
						break
					elseif resourceType.name == "Spell" then
						spell = resource
						break
					elseif resourceType.name == "Effect" then
						prayer = resource
						break
					end
				end

				if not item then
					for input in brochure:getInputs(action) do
						local inputResource = brochure:getConstraintResource(input)
						local inputType = brochure:getResourceTypeFromResource(inputResource)
						if inputType.name == "Item" then
							item = inputResource
							quantity = input.count
							break
						end
					end
				end

				if not item then
					for resource in brochure:findResourcesByAction(action) do
						local resourceType = brochure:getResourceTypeFromResource(resource)
						if resourceType.name == "Item" then
							item = resource
							quantity = 1
							break
						end
					end
				end

				if item or peep or prop or prayer then
					local button = Button()
					button.onClick:register(self.selectItem, self, state.actions[i])

					if spell then
						local spellIcon = SpellIcon()
						spellIcon:setSpellID(spell.name)
						spellIcon:setSpellEnabled(true)
						spellIcon:setPosition(4, 4)

						button:addChild(spellIcon)
					elseif prayer then
						local icon = Icon()
						icon:setIcon(string.format("Resources/Game/Effects/%s/Icon.png", prayer.name))
						icon:setPosition(4, 4)

						button:addChild(icon)
					elseif item then
						local itemIcon = ItemIcon()
						itemIcon:setItemID(item.name)
						if quantity > 1 then
							itemIcon:setItemCount(quantity)
						end
						itemIcon:setPosition(4, 4)

						button:addChild(itemIcon)
					end

					if peep then
						button:setText(Utility.getName(peep, gameDB))
					elseif prop then
						button:setText(Utility.getName(prop, gameDB))
					elseif spell then
						button:setText(Utility.getName(spell, gameDB))
					elseif prayer then
						button:setText(Utility.getName(prayer, gameDB))
					else
						button:setText(Utility.getName(item, gameDB))
					end

					button:setStyle(
						ButtonStyle(
							SkillGuide.INACTIVE_BUTTON_STYLE,
							self:getView():getResources()))

					self.grid:addChild(button)
				end
			end
		end

		self.grid:setScrollSize(self.grid:getInnerPanel():getSize())

		self.ready = true
	end
end

function SkillGuide:selectItem(action, button)
	if self.previousSelection then
		self.previousSelection:setStyle(
			ButtonStyle(
				SkillGuide.INACTIVE_BUTTON_STYLE,
				self:getView():getResources()))
	end

	if self.previousSelection ~= button then
		button:setStyle(
			ButtonStyle(
				SkillGuide.ACTIVE_BUTTON_STYLE,
				self:getView():getResources()))

		self.activeItem = action
		self.previousSelection = button

		self:sendPoke("select", nil, { id = action.id })
	else
		self.activeItem = false
		self.previousSelection = false
		self:populateRequirements({
			requirements = {},
			inputs = {},
			outputs = {}
		})
	end
end

function SkillGuide:populateRequirements(e)
	self.requirementsPanel:setConstraints(e.requirements)
	self.inputsPanel:setConstraints(e.inputs)
	self.outputsPanel:setConstraints(e.outputs)

	self.infoPanel:getInnerPanel():performLayout()
	self.infoPanel:getInnerPanel():setScroll(0, 0)
	self.infoPanel:setScrollSize(self.infoPanel:getInnerPanel():getSize())
	self.infoPanel:performLayout()
end

return SkillGuide
