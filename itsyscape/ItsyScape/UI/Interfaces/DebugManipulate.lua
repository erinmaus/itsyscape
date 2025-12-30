--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugManipulate.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local utf8 = require "utf8"
local Class = require "ItsyScape.Common.Class"
local Probe = require "ItsyScape.Game.Probe"
local Utility = require "ItsyScape.Game.Utility"
local Actor = require "ItsyScape.Game.Model.Actor"
local Prop = require "ItsyScape.Game.Model.Prop"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local CloseButton = require "ItsyScape.UI.CloseButton"
local Drawable = require "ItsyScape.UI.Drawable"
local FocusBoundary = require "ItsyScape.UI.FocusBoundary"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local SearchPrompt = require "ItsyScape.UI.Interfaces.Components.SearchPrompt"
local PropertiesPrompt = require "ItsyScape.UI.Interfaces.Components.PropertiesPrompt"
local Widget = require "ItsyScape.UI.Widget"

local DebugManipulate = Class(Interface)

DebugManipulate.Action = Class()

function DebugManipulate.Action:new(interface, object, hit)
	self.interface = interface
	self.object = object
	self.hit = hit
end

function DebugManipulate.Action:getInterface()
	return self.interface
end

function DebugManipulate.Action:getUIView()
	return self.interface:getView()
end

function DebugManipulate.Action:getGameView()
	return self.interface:getView():getGameView()
end

function DebugManipulate.Action:getGameDB()
	return self.interface:getView():getGameView():getGame():getGameDB()
end

function DebugManipulate.Action:getObject()
	return self.object
end

function DebugManipulate.Action:getHit()
	return self.hit
end

function DebugManipulate.Action:addPopup(widget)
	self:removePopup()

	self.interface:addPopup(widget)
	self.popup = widget
end

function DebugManipulate.Action:removePopup()
	if self.popup then
		self.interface:removePopup(self.popup)
		self.popup = nil
	end
end

function DebugManipulate.Action:close()
	self.interface:cancelAction()
end

function DebugManipulate.Action:start()
	-- Nothing.
end

function DebugManipulate.Action:cancel()
	self:done()
end

function DebugManipulate.Action:stop()
	self:done()
end

function DebugManipulate.Action:done()
	self:removePopup()
end

function DebugManipulate.Action:searchAllResourcesOfType(resourceType)
	local gameDB = self:getGameDB()

	local result = {}
	for resource in gameDB:getResources(resourceType) do
		local name = Utility.getName(resource, gameDB)
		local description = Utility.getDescription(resource, gameDB)

		table.insert(result, {
			id = resource.name,
			name = name,
			description = description
		})
	end

	return function(value)
		if utf8.len(value) <= 3 then
			return {}
		end

		local pattern = value:gsub("%W", "%%%1.*"):gsub("%w", function(s)
			return string.format("[%s%s].*", s:upper(), s:lower())
		end)

		local suggestions = {}
		for _, resource in ipairs(result) do
			if resource.id:match(pattern) or (resource.name and resource.name:match(pattern)) then
				local description
				if resource.name and resource.description then
					description = string.format("%s: %s", resource.name, resource.description)
				else
					description = resource.name or resource.description
				end

				table.insert(suggestions, SearchPrompt.Suggestion(resource.id, resource.id, description))
			end
		end

		return suggestions
	end
end

DebugManipulate.SpawnPropAction = Class(DebugManipulate.Action)

function DebugManipulate.SpawnPropAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.SpawnPropAction:start()
	DebugManipulate.Action.start(self)

	local searchPrompt = SearchPrompt()
	searchPrompt:setText("Find Prop")
	searchPrompt:setSuggestionsGenerator(self:searchAllResourcesOfType("Prop"))
	searchPrompt.onSubmit:register(self._spawn, self)
	searchPrompt.onCancel:register(self.close, self)

	self:addPopup(searchPrompt)
end

function DebugManipulate.SpawnPropAction:_spawn(_, value, suggestion)
	local id = suggestion and suggestion:getID() or value

	local _, _, layer = self:getObject():getTile()
	self:getInterface():sendPoke(
		"spawnProp",
		nil, {
			id = id,
			layer = layer,
			position = { self:getObject():getPosition():get() }
		})

	self:getInterface():stopAction()
end

DebugManipulate.SpawnActorAction = Class(DebugManipulate.Action)

function DebugManipulate.SpawnActorAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.SpawnActorAction:start()
	DebugManipulate.Action.start(self)

	local searchPrompt = SearchPrompt()
	searchPrompt:setText("Find Actor")
	searchPrompt:setSuggestionsGenerator(self:searchAllResourcesOfType("Peep"))
	searchPrompt.onSubmit:register(self._spawn, self)
	searchPrompt.onCancel:register(self.close, self)

	self:addPopup(searchPrompt)
end

function DebugManipulate.SpawnActorAction:_spawn(_, value, suggestion)
	local id = suggestion and suggestion:getID() or value

	local _, _, layer = self:getObject():getTile()
	self:getInterface():sendPoke(
		"spawnActor",
		nil, {
			id = id,
			layer = layer,
			position = { self:getObject():getPosition():get() }
		})

	self:getInterface():stopAction()
end

DebugManipulate.PlayAnimationAction = Class(DebugManipulate.Action)

function DebugManipulate.PlayAnimationAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.PlayAnimationAction:start()
	DebugManipulate.Action.start(self)

	local propertiesPrompt = PropertiesPrompt()
	propertiesPrompt.onSubmit:register(self._playAnimation, self)
	propertiesPrompt.onCancel:register(self.close, self)
	propertiesPrompt:setText("Play Animation")
	propertiesPrompt:setProperties({
		PropertiesPrompt.Property("Animation", "string", ""),
		PropertiesPrompt.Property("Slot", "string", "x-debug"),
		PropertiesPrompt.Property("Priority", "integer", 1000)
	})

	self:addPopup(propertiesPrompt)
end

function DebugManipulate.PlayAnimationAction:_playAnimation(_, _, form)
	local id = self:getObject():getID()

	self:getInterface():sendPoke(
		"playAnimation",
		nil, {
			actorID = id,
			animation = form.Animation,
			slot = form.Slot,
			priority = form.Priority
		})

	self:getInterface():stopAction()
end

DebugManipulate.WIDTH  = 800
DebugManipulate.HEIGHT = 600
DebugManipulate.TITLE_HEIGHT = 48

DebugManipulate.Root = Class(Widget)

function DebugManipulate.Root:getOverflow()
	return true
end

DebugManipulate.GizmoFacade = Class(Widget)
function DebugManipulate.GizmoFacade:new(interface, object)
	self.interface = interface
	self.object = object
end

DebugManipulate.InteractFacade = Class(Widget)
function DebugManipulate.InteractFacade:new(interface)
	Widget.new(self)

	self.interface = interface

	self:performLayout()
end

function DebugManipulate.InteractFacade:performLayout()
	Widget.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)
	self:setZDepth(-1000)
end

function DebugManipulate.InteractFacade:getIsFocusable()
	return true
end

function DebugManipulate.InteractFacade:mousePress(_x, _y, button)
	Widget.mousePress(self, _x, _y, button)

	_APP.cameraController:mousePress(false, _x, _y, button)

	if not (button == 1 or button == 2) then
		return
	end

	local x, y = love.mouse.getPosition()
	_APP:probe(x, y, false, function(probe)
		local actions = {}

		for _, hit in probe:hits() do
			local object = hit:getObject()

			if Class.isCompatibleType(object, Actor) then
				self.interface:buildActorActions(object, hit, actions)
			elseif Class.isCompatibleType(object, Prop) then
				self.interface:buildPropActions(object, hit, actions)
			elseif Class.isCompatibleType(object, Probe.Tile) then
				self.interface:buildTileActions(object, hit, actions)
			end
		end

		local ui = self:getUIView()
		if ui then
			ui:probe(actions, x, y)
		end
	end)
end

function DebugManipulate.InteractFacade:mouseMove(...)
	Widget.mouseMove(self, ...)

	_APP.cameraController:mouseMove(false, ...)
end

function DebugManipulate.InteractFacade:mouseRelease(...)
	Widget.mouseRelease(self, ...)

	_APP.cameraController:mouseRelease(false, ...)
end

function DebugManipulate:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.windowRoot = DebugManipulate.Root()
	self.windowRoot:setSize(self.WIDTH, self.HEIGHT)
	self:addChild(self.windowRoot)

	local titlePanel = Panel()
	titlePanel:setStyle(Theme.WINDOW_TITLE_PANEL_STYLE, PanelStyle)
	titlePanel:setPosition(0, 0)
	titlePanel:setSize(self.WIDTH, self.TITLE_HEIGHT + Theme.DEFAULT_OUTER_PADDING * 2)
	self.windowRoot:addChild(titlePanel)

	self.closeButton = Theme.newCloseButton(titlePanel)

	local titleLabel = Label()
	titleLabel:setStyle(Theme.WINDOW_TITLE_LABEL_STYLE, LabelStyle)
	titleLabel:setText("Reality Manipulator")
	titleLabel:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	titlePanel:addChild(titleLabel)

	local contentPanel = Theme.newContentPanel(
		self.windowRoot,
		self.WIDTH,
		self.HEIGHT - self.TITLE_HEIGHT - Theme.DEFAULT_OUTER_PADDING * 2,
		titlePanel)
	local contentWidth, contentHeight = contentPanel:getSize()

	self.presetListGrid = ScrollablePanel(GamepadGridLayout)
	self.presetListGrid:setSize(contentWidth / 3, contentHeight - Theme.DEFAULT_OUTER_PADDING)
	self.presetListGrid:getInnerPanel().onWrapFocus:register(self._wrapPresetGridsFocus, self)
	contentPanel:addChild(self.presetListGrid)

	self.presetGrid = ScrollablePanel(GamepadGridLayout)
	self.presetGrid:setSize(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, contentWidth, self.WIDTH / 3),
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, contentHeight))
	self.presetGrid:setPosition(contentWidth / 3 + Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.presetGrid:getInnerPanel().onWrapFocus:register(self._wrapPresetGridsFocus, self)

	contentPanel:addChild(self.presetGrid)

	self.popupInterfaces = {}
	self.popupPanel = Panel()
	self.popupPanel:setZDepth(100)
	self.popupPanel:setStyle({
		color = { 0, 0, 0, 0.5 },
		radius = 0
	}, PanelStyle)

	local state = self:getState()
	if state and state.presets then
		self:populatePresets(state.presets)
	end

	self:performLayout()
end

function DebugManipulate:getOverflow()
	return true
end

function DebugManipulate:performLayout()
	Interface.performLayout(self)

	local width, height = itsyrealm.graphics.getScaledMode()
	local windowWidth, windowHeight = self.windowRoot:getSize()
	self.windowRoot:setPosition((width - windowWidth) / 2, (height - windowHeight) / 2)

	if self.facade then
		self.facade:performLayout()
	end

	self.popupPanel:setSize(width, height)
end

function DebugManipulate:attach()
	self:focusChild(self.presetListGrid:getInnerPanel())
end

function DebugManipulate:detach()
	local root = self:getView():getRoot()
	root:addChild(self)

	if self.revealButton and self.revealButton:getParent() == root then
		root:removeChild(self.revealButton)
		self.revealButton = nil
	end

	if self.facade and self.facade:getParent() == root then
		root:removeChild(self.facade)
		self.facade = nil
	end
end

function DebugManipulate:_wrapPresetGridsFocus(grid, widget, directionX, directionY)
	if grid == self.presetListGrid and directionX == 1 then
		self:focusChild(self.presetGrid)
	elseif grid == self.presetGrid and directionX == -1 then
		self:focusChild(self.presetListGrid)
	else
		self:focusSpiralButton(widget)
	end
end

function DebugManipulate:_reveal(_, index)
	if index ~= 1 then
		return
	end

	self:show()
end

function DebugManipulate:restoreFocus()
	if #self.popupInterfaces >= 1 and self.popupInterfaces[#self.popupInterfaces].widget then
		self:focusChild(self.popupInterfaces[#self.popupInterfaces].widget)
	elseif self.selectedPresetResource and self.selectedPresetID then
		self:focusChild(self.presetGrid:getInnerPanel())
	else
		self:focusChild(self.presetListGrid:getInnerPanel())
	end
end

function DebugManipulate:addPopup(widget)
	self:removePopup(widget)

	local nextPopup = { root = widget }

	local currentPopup = self.popupInterfaces[#self.popupInterfaces]
	if currentPopup then
		self:removeChild(currentPopup.root)
	end

	table.insert(self.popupInterfaces, nextPopup)
	self.popupPanel:addChild(widget)

	self:addChild(self.popupPanel)
	widget:performLayout()
	self:focusChild(widget)
end

function DebugManipulate:removePopup(widget)
	for i, popup in ipairs(self.popupInterfaces) do
		if popup.root == widget then
			if i == #self.popupInterfaces then
				self.popupPanel:removeChild(popup.root)

				local previousPopup = self.popupInterfaces[i - 1]
				if previousPopup then
					self.popupPanel:addChild(previousPopup.root)
					previousPopup.root:performLayout()
					self:focusChild(previousPopup.root)
				else
					self:removeChild(self.popupPanel)
				end
			end

			table.remove(self.popupInterfaces, i)
			break
		end
	end
end

function DebugManipulate:_onFocusPopupChild(_, child)
	for _, popup in ipairs(self.popupInterfaces) do
		if popup.root:isParentOf(child) then
			popup.widget = child
			break
		end
	end
end

function DebugManipulate:_onBlurPopupChild(_, child)
	for _, popup in ipairs(self.popupInterfaces) do
		if popup.root:isParentOf(child) and popup.widget == child then
			popup.widget = nil
			break
		end
	end
end

function DebugManipulate:populatePresets(presets)
	local gridWidth, gridHeight = self.presetListGrid:getSize()

	self.presetListGrid:clearChildren()
	for index, presetInfo in ipairs(presets) do
		local button = Button()

		local label = Label()
		label:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
		label:setText(string.format("%s@%d", presetInfo.resource, presetInfo.id))
		button:addChild(label)

		button.onClick:register(self.selectPreset, self, presetInfo)

		self.presetListGrid:addChild(button)
	end

	if self.selectedPresetResource  and self.selectedPresetID then
		self:sendPoke("select", nil, { resource = self.selectedPresetResource, id = self.selectedPresetID })
	end

	local state = self:getState()
	for _, resource in ipairs(state.layers or {}) do
		local newButton = Button()
		newButton:setStyle(Theme.DEFAULT_ALTERNATE_BUTTON_STYLE, ButtonStyle)

		local label = Label()
		label:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
		label:setText(string.format("@%s", resource))
		newButton:addChild(label)

		newButton.onClick:register(self.newPreset, self, resource)

		self.presetListGrid:addChild(newButton)
	end

	Theme.layoutScrollablePanelWithGridLayout(self.presetListGrid, gridWidth - Theme.DEFAULT_INNER_PADDING * 2, Theme.DEFAULT_BUTTON_SIZE)
end

function DebugManipulate:probePreset(preset, button)
	local object = string.format("%s@%d", preset.resource, preset.id)

	local actions = {
		{
			id = 1,
			verb = "Select",
			object = object,
			callback = function()
				self:selectPreset(preset, button, 1)
			end
		},
		{
			id = 2,
			verb = "Delete",
			object = object,
			callback = function()
				self:deletePreset(preset)
			end
		}
	}

	local ui = self:getUIView()
	ui:probe(actions, button:getAbsoluteCenter())
end

function DebugManipulate:newPreset(resource)
	self:sendPoke("new", nil, { resource = resource })

	self.selectedPresetResource = nil
	self.selectedPresetID = nil
end

function DebugManipulate:deletePreset(preset)
	self:sendPoke("delete", nil, { resource = preset.resource, id = preset.id })

	if self.selectedPresetResource == preset.resource and self.selectedPresetID == preset.id then
		self.selectedPresetResource = nil
		self.selectedPresetID = nil
	end
end

function DebugManipulate:hide()
	self:removeChild(self.windowRoot)

	local button = Button()
	button:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
	button:setPosition(
		Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING),
		Theme.DEFAULT_OUTER_PADDING * 2)
	button:setSize(Theme.DEFAULT_ITEM_SIZE_WITH_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING)
	button:setToolTip("Reveal Amulet of Yendor reality manipulation interface.")
	button.onClick:register(self._reveal, self)

	local itemIcon = ItemIcon()
	itemIcon:setItemID("AmuletOfYendor")
	itemIcon:setPosition(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)
	button:addChild(itemIcon)

	local root = self:getView():getRoot()
	root:addChild(button)

	self.revealButton = button
end

function DebugManipulate:show()
	self:addChild(self.windowRoot)

	if self.revealButton and self.revealButton:getParent() == root then
		root:removeChild(self.revealButton)
		self.revealButton = nil
	end
end

function DebugManipulate:selectPreset(preset, button, index)
	if index == 2 then
		self:probePreset(preset, button)
		return
	end

	if index ~= 1 then
		return
	end

	if self.activeButton then
		self.activeButton:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
	end

	self.selectedPresetResource = preset.resource
	self.selectedPresetID = preset.id

	self.activeButton = button
	button:setStyle(Theme.DEFAULT_ACTIVE_BUTTON_STYLE, ButtonStyle)

	self:sendPoke("select", nil, { resource = preset.resource, id = preset.id })
end

function DebugManipulate:showPreset(presetInfo, preset)
	self.presetGrid:clearChildren()

	do
		local recordButton = Button()
		recordButton:setStyle(Theme.DEFAULT_ALTERNATE_BUTTON_STYLE, ButtonStyle)

		local label = Label()
		label:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
		label:setText("Record")
		recordButton:addChild(label)

		recordButton.onClick:register(self.record, self, presetInfo)

		self.presetGrid:addChild(recordButton)
	end

	local gridWidth, gridHeight = self.presetGrid:getSize()
	Theme.layoutScrollablePanelWithGridLayout(self.presetGrid, gridWidth - Theme.DEFAULT_INNER_PADDING * 2, Theme.DEFAULT_BUTTON_SIZE)
end

function DebugManipulate:buildActorActions(object, hit, actions)
	table.insert(actions, {
		id = #actions + 1,
		verb = "Play-Animation",
		objectID = object:getID(),
		objectType = "actor",
		object = object:getName(),
		callback = function()
			self:beginAction(DebugManipulate.PlayAnimationAction, object, hit)
		end
	})
end

function DebugManipulate:buildPropActions(object, hit, actions)
	table.insert(actions, {
		id = #actions + 1,
		verb  = "Nop",
		objectID = object:getID(),
		objectType = "prop",
		object = object:getName(),
		callback = function()
			print("buildPropActions")
		end
	})
end

function DebugManipulate:buildTileActions(object, hit, actions)
	local _, _, layer = object:getTile()

	local gameView = self:getView():getGameView()
	local resource = gameView:getMapResourceID(layer)
	local localLayer = gameView:getMapLocalLayer(layer)

	table.insert(actions, {
		id = #actions + 1,
		verb = "Spawn-Actor",
		objectID = layer,
		objectType = "map",
		object = string.format("%s@%s", resource or "???", localLayer or string.format("*%d", layer)),
		callback = function()
			self:beginAction(DebugManipulate.SpawnActorAction, object, hit)
		end
	})

	table.insert(actions, {
		id = #actions + 1,
		verb = "Spawn-Prop",
		objectID = layer,
		objectType = "map",
		object = string.format("%s@%s", resource or "???", localLayer or string.format("*%d", layer)),
		callback = function()
			self:beginAction(DebugManipulate.SpawnPropAction, object, hit)
		end
	})
end

function DebugManipulate:beginAction(ActionType, object, hit)
	self:cancelAction()

	self.currentAction = ActionType(self, object, hit)
	self.currentAction:start()
end

function DebugManipulate:cancelAction()
	if self.currentAction then
		self.currentAction:cancel()
		self.currentAction = nil
	end
end

function DebugManipulate:stopAction()
	if self.currentAction then
		self.currentAction:stop()
		self.currentAction = nil
	end
end

function DebugManipulate:record(preset, _, index)
	if index ~= 1 then
		return
	end

	self.facade = DebugManipulate.InteractFacade(self)

	local root = self:getView():getRoot()
	root:addChild(self.facade)

	self:hide()
	self:sendPoke("startRecording", nil, { resource = preset.resource, id = preset.id })
end

return DebugManipulate
