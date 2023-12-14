--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CookingWindow.lua
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
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local ToolTip = require "ItsyScape.UI.ToolTip"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local CookingWindow = Class(Interface)

CookingWindow.WIDTH  = 984

if _MOBILE then
	CookingWindow.HEIGHT = 560
else
	CookingWindow.HEIGHT = 640
end

CookingWindow.POP_UP_WIDTH  = 384
CookingWindow.POP_UP_HEIGHT = 480

CookingWindow.BUTTON_SIZE    = 48
CookingWindow.BUTTON_PADDING = 8

CookingWindow.INACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 22,
	textShadow = true
}

CookingWindow.ACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 22,
	textShadow = true
}

CookingWindow.INVENTORY_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
	inactive = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
	hover = "Resources/Renderers/Widget/Button/InventoryItem.9.png"
}

CookingWindow.INSTRUCTIONS_LABEL = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 22,
	textShadow = true,
	color = { 1, 1, 1, 1 },
	align = 'center'
}

CookingWindow.HEADER_LABEL = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 22,
	textShadow = true,
	color = { 1, 1, 1, 1 }
}

function CookingWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local width, height = love.graphics.getScaledMode()

	self:setPosition(
		width / 2 - CookingWindow.WIDTH / 2,
		height / 2 - CookingWindow.HEIGHT / 2)
	self:setSize(CookingWindow.WIDTH, CookingWindow.HEIGHT)

	self.panel = Panel()
	self.panel:setSize(CookingWindow.WIDTH, CookingWindow.HEIGHT)
	self:addChild(self.panel)

	self.closeButton = Button()
	self.closeButton:setSize(CookingWindow.BUTTON_SIZE, CookingWindow.BUTTON_SIZE)
	self.closeButton:setPosition(CookingWindow.WIDTH - CookingWindow.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.grid = ScrollablePanel(GridLayout)
	self.grid:getInnerPanel():setWrapContents(true)
	self.grid:getInnerPanel():setSize(CookingWindow.WIDTH * (1 / 3), 0)
	self.grid:getInnerPanel():setPadding(CookingWindow.BUTTON_PADDING, CookingWindow.BUTTON_PADDING)
	self.grid:getInnerPanel():setUniformSize(
		true,
		CookingWindow.WIDTH * (1 / 3) - CookingWindow.BUTTON_PADDING * 2,
		CookingWindow.BUTTON_SIZE)
	self.grid:setSize(CookingWindow.WIDTH * (1 / 3) + ScrollablePanel.DEFAULT_SCROLL_SIZE, CookingWindow.HEIGHT)
	self:addChild(self.grid)

	self.recipeInstructionsPanel = Panel()
	self.recipeInstructionsPanel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
	self.recipeInstructionsPanel:setSize(CookingWindow.WIDTH * (2 / 3) - ScrollablePanel.DEFAULT_SCROLL_SIZE, CookingWindow.HEIGHT - ScrollablePanel.DEFAULT_SCROLL_SIZE)
	self.recipeInstructionsPanel:setPosition(CookingWindow.WIDTH * (1 / 3) + ScrollablePanel.DEFAULT_SCROLL_SIZE, ScrollablePanel.DEFAULT_SCROLL_SIZE)
	do
		local instructions = Label()
		instructions:setPosition(0, CookingWindow.HEIGHT / 2 - CookingWindow.BUTTON_SIZE)
		instructions:setText("Click a recipe to get started!")
		instructions:setStyle(LabelStyle(CookingWindow.INSTRUCTIONS_LABEL, self:getView():getResources()))

		self.recipeInstructionsPanel:addChild(instructions)
	end
	self:addChild(self.recipeInstructionsPanel)

	self.recipeBuilderPanel = Panel()
	self.recipeBuilderPanel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
	self.recipeBuilderPanel:setSize(self.recipeInstructionsPanel:getSize())
	self.recipeBuilderPanel:setPosition(self.recipeInstructionsPanel:getPosition())
	do
		local w, h = self.recipeBuilderPanel:getSize()
		w = w / 2

		local recipeHeader = Label()
		recipeHeader:setPosition(CookingWindow.BUTTON_PADDING, CookingWindow.BUTTON_PADDING)
		recipeHeader:setText("Recipe")
		recipeHeader:setStyle(LabelStyle(CookingWindow.HEADER_LABEL, self:getView():getResources()))
		self.recipeBuilderPanel:addChild(recipeHeader)

		local ingredientPanel = Panel()
		ingredientPanel:setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, self:getView():getResources()))
		ingredientPanel:setSize(
			w - CookingWindow.BUTTON_PADDING * 2,
			CookingWindow.HEIGHT * (1 / 3) - CookingWindow.BUTTON_PADDING * 2)
		ingredientPanel:setPosition(
			CookingWindow.BUTTON_PADDING,
			CookingWindow.BUTTON_PADDING + CookingWindow.BUTTON_SIZE)
		self.recipeBuilderPanel:addChild(ingredientPanel)

		w, h = ingredientPanel:getSize()

		self.ingredientsList = ScrollablePanel(GridLayout)
		self.ingredientsList:setID("CookingWindow-Pending")
		self.ingredientsList:getInnerPanel():setWrapContents(true)
		self.ingredientsList:getInnerPanel():setPadding(CookingWindow.BUTTON_PADDING, CookingWindow.BUTTON_PADDING)
		self.ingredientsList:getInnerPanel():setUniformSize(true, CookingWindow.BUTTON_SIZE, CookingWindow.BUTTON_SIZE)
		self.ingredientsList:getInnerPanel():setSize(w - ScrollablePanel.DEFAULT_SCROLL_SIZE, 0)
		self.ingredientsList:setSize(ingredientPanel:getSize())

		local inventoryHeader = Label()
		inventoryHeader:setPosition(
			CookingWindow.BUTTON_PADDING,
			CookingWindow.BUTTON_PADDING * 2 + CookingWindow.BUTTON_SIZE + CookingWindow.HEIGHT * (1 / 3))
		inventoryHeader:setText("Ingredients")
		inventoryHeader:setStyle(LabelStyle(CookingWindow.HEADER_LABEL, self:getView():getResources()))
		self.recipeBuilderPanel:addChild(inventoryHeader)

		w, h = self.recipeBuilderPanel:getSize()
		w = w / 2

		ingredientPanel:addChild(self.ingredientsList)
		local inventoryPanel = Panel()
		inventoryPanel:setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, self:getView():getResources()))
		inventoryPanel:setSize(w - CookingWindow.BUTTON_PADDING * 2, CookingWindow.HEIGHT * (2 / 3) - CookingWindow.BUTTON_PADDING * 5 - CookingWindow.BUTTON_SIZE * 3)
		inventoryPanel:setPosition(
			CookingWindow.BUTTON_PADDING,
			CookingWindow.BUTTON_PADDING * 2 + CookingWindow.BUTTON_SIZE * 2 + CookingWindow.HEIGHT * (1 / 3))
		self.recipeBuilderPanel:addChild(inventoryPanel)

		w, h = inventoryPanel:getSize()

		self.inventoryList = ScrollablePanel(GridLayout)
		self.inventoryList:setID("CookingWindow-Inventory")
		self.inventoryList:getInnerPanel():setWrapContents(true)
		self.inventoryList:getInnerPanel():setPadding(CookingWindow.BUTTON_PADDING, CookingWindow.BUTTON_PADDING)
		self.inventoryList:getInnerPanel():setUniformSize(true, CookingWindow.BUTTON_SIZE, CookingWindow.BUTTON_SIZE)
		self.inventoryList:getInnerPanel():setSize(w - ScrollablePanel.DEFAULT_SCROLL_SIZE, 0)
		self.inventoryList:setSize(inventoryPanel:getSize())
		inventoryPanel:addChild(self.inventoryList)

		local w, h = self.recipeBuilderPanel:getSize()
		w = w / 2

		self.requirementsPanel = ScrollablePanel(GridLayout)
		self.requirementsPanel:getInnerPanel():setPadding(0, 0)
		self.requirementsPanel:getInnerPanel():setWrapContents(true)
		self.requirementsPanel:setSize(w, h - CookingWindow.BUTTON_SIZE - CookingWindow.BUTTON_PADDING * 2)
		self.requirementsPanel:setPosition(w + CookingWindow.BUTTON_PADDING)
		self.recipeBuilderPanel:addChild(self.requirementsPanel)

		self.cookButton = Button()
		self.cookButton:setID("CookingWindow-Cook")
		self.cookButton:setSize(w - CookingWindow.BUTTON_PADDING * 2, CookingWindow.BUTTON_SIZE)
		self.cookButton:setPosition(w + CookingWindow.BUTTON_PADDING, h - CookingWindow.BUTTON_SIZE - CookingWindow.BUTTON_PADDING * 3)
		self.cookButton:setText("Cook!")
		self.cookButton.onClick:register(function()
			self:sendPoke("cook", nil, {})
		end)
		self.recipeBuilderPanel:addChild(self.cookButton)
	end

	local state = self:getState()
	if state and state.recipes then
		for i = 1, #state.recipes do
			local recipe = state.recipes[i]
			local item = recipe.output or recipe

			local button = Button()
			button:setText(item.name)
			button:setToolTip(ToolTip.Header(item.name), ToolTip.Text(item.description))
			button:setStyle(ButtonStyle(
				CookingWindow.INACTIVE_BUTTON_STYLE,
				self:getView():getResources()))
			button:setID(string.format("CookingWindow-Recipe-%s", item.resource))

			local itemIcon = ItemIcon()
			itemIcon:setItemID(item.resource)
			button:addChild(itemIcon)
			button.onClick:register(CookingWindow.selectRecipe, self, i)

			self.grid:addChild(button)
		end
	end

	self.grid:setScrollSize(self.grid:getInnerPanel():getSize())

	self.popUp = Panel()
	self.popUp:setStyle(PanelStyle({ image = false, color = { 0, 0, 0, 0.2 } }, self:getView():getResources()))
	self.popUp:setSize(self:getSize())

	do
		local popUpPanel = Panel()
		popUpPanel:setID("CookingWindow-Result")
		popUpPanel:setSize(CookingWindow.POP_UP_WIDTH, CookingWindow.POP_UP_HEIGHT)
		popUpPanel:setPosition(
			CookingWindow.WIDTH / 2 - CookingWindow.POP_UP_WIDTH / 2,
			CookingWindow.HEIGHT / 2 - CookingWindow.POP_UP_HEIGHT / 2)
		self.popUp:addChild(popUpPanel)

		local popUpBackground = Panel()
		popUpBackground:setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, self:getView():getResources()))
		popUpBackground:setPosition(
			CookingWindow.BUTTON_PADDING,
			CookingWindow.BUTTON_PADDING)
		popUpBackground:setSize(
			CookingWindow.POP_UP_WIDTH - CookingWindow.BUTTON_PADDING * 2,
			CookingWindow.POP_UP_HEIGHT - CookingWindow.BUTTON_PADDING * 3 - CookingWindow.BUTTON_SIZE)
		popUpPanel:addChild(popUpBackground)

		local closeButton = Button()
		closeButton:setText("Close")
		closeButton:setPosition(
			CookingWindow.BUTTON_PADDING,
			CookingWindow.POP_UP_HEIGHT - CookingWindow.BUTTON_SIZE - CookingWindow.BUTTON_PADDING)
		closeButton:setSize(
			CookingWindow.POP_UP_WIDTH - CookingWindow.BUTTON_PADDING * 2,
			CookingWindow.BUTTON_SIZE)
		closeButton.onClick:register(function()
			local parent = self.popUp:getParent()
			if parent then
				parent:removeChild(self.popUp)
			end

			self:sendPoke("clear", nil, {})
		end)
		popUpPanel:addChild(closeButton)

		self.scrollablePopUpPanel = ScrollablePanel()
		self.scrollablePopUpPanel:getInnerPanel():setStyle(PanelStyle({ image = false }, self:getView():getResources()))
		self.scrollablePopUpPanel:setPosition(
			CookingWindow.BUTTON_PADDING * 2,
			CookingWindow.BUTTON_PADDING * 2)
		self.scrollablePopUpPanel:setSize(
			CookingWindow.POP_UP_WIDTH - CookingWindow.BUTTON_PADDING * 4,
			CookingWindow.POP_UP_HEIGHT - CookingWindow.BUTTON_PADDING * 5 - CookingWindow.BUTTON_SIZE)
		popUpPanel:addChild(self.scrollablePopUpPanel)

		self.cookItemIcon = ItemIcon()
		self.cookItemIcon:setPosition(
			self.scrollablePopUpPanel:getSize() / 2 - self.cookItemIcon:getSize() / 2,
			CookingWindow.BUTTON_PADDING)
		self.scrollablePopUpPanel:addChild(self.cookItemIcon)

		self.cookText = Label()
		self.cookText:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 24,
			textShadow = true,
			align = 'center'
		}, self:getView():getResources()))
		self.cookText:setPosition(
			CookingWindow.BUTTON_PADDING,
			CookingWindow.BUTTON_PADDING * 2 + self.cookItemIcon:getSize())
		self.scrollablePopUpPanel:addChild(self.cookText)

		self.cookDescriptionText = Label()
		self.cookDescriptionText:setStyle(LabelStyle({
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
			fontSize = 22,
			textShadow = true
		}, self:getView():getResources()))
		self.scrollablePopUpPanel:addChild(self.cookDescriptionText)
	end

	self.currentRecipeIngredientButtons = {}
end

function CookingWindow:getIsFullscreen()
	return _MOBILE
end

function CookingWindow:selectRecipe(index, buttonWidget, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	if self.previousRecipeButton == buttonWidget then
		return
	end

	if self.previousRecipeButton and self.previousRecipeButton ~= buttonWidget then
		self.previousRecipeButton:setStyle(ButtonStyle(CookingWindow.INACTIVE_BUTTON_STYLE, self:getView():getResources()))
	end

	buttonWidget:setStyle(ButtonStyle(CookingWindow.ACTIVE_BUTTON_STYLE, self:getView():getResources()))
	self.previousRecipeButton = buttonWidget

	self:sendPoke("populateRecipe", nil, { index = index })
end

function CookingWindow:populateRequirements(constraints, additionalXP)
	additionalXP = additionalXP or 0

	local width = self.requirementsPanel:getSize()
	local height = 0

	local function emitSection(t, title, options)
		options = options or {}

		local panel = ConstraintsPanel(self:getView())
		panel:setText(title)
		if options.skillAsLevel then
			panel:setData("skillAsLevel", true)
		end
		panel:setSize(width - ScrollablePanel.DEFAULT_SCROLL_SIZE)
		panel:setConstraints(t)

		self.requirementsPanel:addChild(panel)
	end

	local outputs = {}
	do
		for _, output in ipairs(constraints.outputs) do
			if output.type == "Skill" and output.resource == "Cooking" then
				table.insert(outputs, {
					type = output.type,
					resource = output.resource,
					name = output.name,
					description = output.description,
					count = output.count + additionalXP,
				})
			else
				table.insert(outputs, output)
			end
		end
	end

	self.requirementsPanel:getInnerPanel():clearChildren()

	emitSection(constraints.requirements, "Requirements", { skillAsLevel = true })
	emitSection(constraints.inputs, "Inputs")
	emitSection(outputs, "Outputs")

	local _, innerPanelHeight = self.requirementsPanel:getInnerPanel():getSize()
	self.requirementsPanel:setScrollSize(width, innerPanelHeight)

	local visibleWidth, visibleHeight = self.requirementsPanel:getSize()
	local currentScrollX, currentScrollY = self.requirementsPanel:getInnerPanel():getScroll()
	self.requirementsPanel:getInnerPanel():setScroll(
		0,
		math.min(math.max(innerPanelHeight - visibleHeight, 0), currentScrollY))
	self.requirementsPanel:performLayout()
end

function CookingWindow:populateRecipe(currentRecipe)
	self.ingredientsList:getInnerPanel():clearChildren()
	self.ingredientsList:getInnerPanel():setSize(self.ingredientsList:getInnerPanel():getSize(), 0)

	self.currentRecipeIngredientButtons = {}
	for i = 1, #currentRecipe do
		local ingredient = currentRecipe[i]

		local button = Button()
		button:setStyle(ButtonStyle(CookingWindow.INVENTORY_BUTTON_STYLE, self:getView():getResources()))
		button:setSize(CookingWindow.BUTTON_SIZE, CookingWindow.BUTTON_SIZE)
		button.onClick:register(self.removeIngredient, self, i)

		local icon = ItemIcon()
		icon:setItemID(ingredient.item.resource)
		icon:setIsDisabled(not ingredient.slotted)

		button:addChild(icon)
		button:setData("icon", icon)

		self.ingredientsList:addChild(button)
		table.insert(self.currentRecipeIngredientButtons, button)
	end

	self.ingredientsList:setScrollSize(self.ingredientsList:getInnerPanel():getSize())
	self.ingredientsList:setScroll(0, 0)

	self:removeChild(self.recipeInstructionsPanel)
	self:addChild(self.recipeBuilderPanel)

	local state = self:getState()
	self:populateRequirements(state.recipes[currentRecipe.index].constraints)
end

function CookingWindow:addIngredient(button)
	local inventoryIndex = button:getData("inventoryIndex")

	local inventory = self:getState().inventory
	local ref = inventory[inventoryIndex].ref

	self:sendPoke("addIngredient", nil, { ref = ref })
end

function CookingWindow:removeIngredient(index)
	self:sendPoke("removeIngredient", nil, { index = index })
end

function CookingWindow:populateInventory(inventory)
	local inventorySize = #inventory

	local grid = self.inventoryList:getInnerPanel()

	local resetScroll = false
	if inventorySize > grid:getNumChildren() then
		while grid:getNumChildren() < inventorySize do
			local button = Button()
			button:setStyle(ButtonStyle(
				CookingWindow.INVENTORY_BUTTON_STYLE,
				self:getView():getResources()))

			local itemIcon = ItemIcon()
			button:addChild(itemIcon)
			button:setData("icon", itemIcon)
			button.onClick:register(self.addIngredient, self)

			grid:addChild(button)
		end

		resetScroll = true
	elseif inventorySize < grid:getNumChildren() then
		while grid:getNumChildren() > inventorySize do
			grid:removeChild(grid:getChildAt(grid:getNumChildren()))
		end

		resetScroll = true
	end

	local currentButtonIndex = 1
	for i = 1, #inventory do
		local item = inventory[i]
		local button = grid:getChildAt(currentButtonIndex)
		button:setData("inventoryIndex", i)
		button:setID(string.format("CookingWindow-Inventory-%s", item.resource))

		local usable, xp
		if item.usable and item.count > 0 then
			usable = ToolTip.Text("You can cook with this ingredient.")

			if item.xp > 0 then
				xp = ToolTip.Text(string.format("Gives +%d additional Cooking XP.", item.xp or 0))
			end
		elseif not item.usable then
			usable = ToolTip.Text("You do not meet the requirements to cook with this ingredient.")
		elseif item.count == 0 then
			usable = ToolTip.Text("You've already added every ingredient of this type that you have.")
		end

		local hints = {}
		for _, hint in ipairs(item.hints) do
			table.insert(hints, string.format("- %s", hint))
		end

		button:setToolTip(
			ToolTip.Header("Add " .. item.name),
			ToolTip.Text(item.description),
			usable,
			xp,
			ToolTip.Text(table.concat(hints, "\n")))

		local itemIcon = button:getData("icon")
		itemIcon:setItemID(item.resource)
		itemIcon:setItemCount(item.count)
		itemIcon:setIsDisabled(not item.usable or item.count == 0)

		currentButtonIndex = currentButtonIndex + 1
	end

	if resetScroll then
		self.inventoryList:setScrollSize(grid:getSize())
		self.inventoryList:setScroll(0, 0)
	end
end

function CookingWindow:updateCurrentRecipe()
	local state = self:getState()
	local currentRecipe = state.currentRecipe
	if not currentRecipe then
		return
	end

	local additionalXP = 0
	for i = 1, #currentRecipe do
		local ingredient = currentRecipe[i]

		local button = self.currentRecipeIngredientButtons[i]
		if button then
			local icon = button:getData("icon")
			icon:setItemID(ingredient.item.resource)
			icon:setIsDisabled(ingredient.count == 0)

			if ingredient.count == 0 then
				button:setToolTip(
					ToolTip.Header(ingredient.item.name),
					ToolTip.Text(ingredient.item.description))
			else
				button:setToolTip(
					ToolTip.Header("Remove " .. ingredient.item.name),
					ToolTip.Text(ingredient.item.description))
				additionalXP = additionalXP + (ingredient.item.xp or 0)
			end

			button:setID(string.format("CookingWindow-Pending-%s", ingredient.item.resource))
		end
	end

	self:populateRequirements(state.recipes[currentRecipe.index].constraints, additionalXP)
end

function CookingWindow:updatePopUp()
	local lastCookedItem = self:getState().lastCookedItem
	if not lastCookedItem then
		return
	end

	if not self.lastCookedItem or self.lastCookedItem.ref ~= lastCookedItem.ref then
		self:addChild(self.popUp)

		local function populate(width)
			self.cookItemIcon:setPosition(
				width / 2 - self.cookItemIcon:getSize() / 2,
				CookingWindow.BUTTON_PADDING)
			self.cookItemIcon:setItemID(lastCookedItem.resource)

			local isVowel = lastCookedItem.name:lower():match("^[aeiou].*")
			local message = string.format("You successfully cooked %s %s!", isVowel and "an" or "a", lastCookedItem.name:lower())
			self.cookText:setText(message)

			local cookTextFont = self.cookText:getStyle().font
			local _, cookTextLines = cookTextFont:getWrap(self.cookText:getText(), width)
			local _, cookTextY = self.cookText:getPosition()
			self.cookText:setSize(
				width - CookingWindow.BUTTON_PADDING * 3,
				cookTextFont:getHeight() * #cookTextLines)

			local description = string.format("You gained %d cooking XP.\n%s", lastCookedItem.totalXP, lastCookedItem.description)
			description = description:gsub("\n", "\n\n")

			self.cookDescriptionText:setText(description)
			local cookDescriptionFont = self.cookDescriptionText:getStyle().font
			local _, cookDescriptionLines = cookDescriptionFont:getWrap(self.cookDescriptionText:getText(), width)
			self.cookDescriptionText:setPosition(
				CookingWindow.BUTTON_PADDING,
				cookTextY + CookingWindow.BUTTON_PADDING * 2 + cookTextFont:getHeight() * #cookTextLines)
			self.cookDescriptionText:setSize(
				width - CookingWindow.BUTTON_PADDING * 3,
				cookDescriptionFont:getHeight() * #cookDescriptionLines)

			self.scrollablePopUpPanel:setScrollSize(
				width,
				self.cookItemIcon:getSize() + CookingWindow.BUTTON_PADDING * 2 +
				cookTextFont:getHeight() * #cookTextLines + CookingWindow.BUTTON_PADDING +
				cookDescriptionFont:getHeight() * #cookDescriptionLines + CookingWindow.BUTTON_PADDING)

			local _, scrollY = self.scrollablePopUpPanel:getScrollBarActive()
			return not scrollY
		end

		if not populate(self.scrollablePopUpPanel:getSize()) then
			populate(self.scrollablePopUpPanel:getSize() - ScrollablePanel.DEFAULT_SCROLL_SIZE)
		end

		self.scrollablePopUpPanel:setScroll(0, 0)

		self.lastCookedItem = lastCookedItem
	end
end

function CookingWindow:update(...)
	Interface.update(self, ...)

	self:updateCurrentRecipe()
	self:updatePopUp()
end

return CookingWindow
