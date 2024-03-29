--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/StrategyBar.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Drawable = require "ItsyScape.UI.Drawable"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local Keybinds = require "ItsyScape.UI.Keybinds"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"

local StrategyBar = Class(Interface)
StrategyBar.BUTTON_SIZE = 48
StrategyBar.PADDING = 8
StrategyBar.NUM_BUTTONS = 10
StrategyBar.WIDTH = (StrategyBar.NUM_BUTTONS + 1) * (StrategyBar.BUTTON_SIZE + StrategyBar.PADDING) + StrategyBar.PADDING
StrategyBar.HEIGHT = StrategyBar.BUTTON_SIZE + StrategyBar.PADDING * 2
StrategyBar.KEY_BIND_PREFIX = "STRATEGY_BAR_SLOT"

StrategyBar.Pending = Class(Drawable)
function StrategyBar.Pending:draw(resources, state)
	local w, h = self:getSize()
	local time = love.timer.getTime() * math.pi * 2
	local startAngle = time
	local endAngle = startAngle + math.pi * 2 * (3 / 4)

	startAngle = startAngle % (math.pi * 2)
	endAngle = endAngle % (math.pi * 2)

	if startAngle > endAngle then
		startAngle = startAngle - math.pi * 2
	end

	love.graphics.setLineWidth(4)

	love.graphics.setColor(0, 0, 0, 1)
	itsyrealm.graphics.arc('line', 'open', w / 2 + 1, h / 2 + 1, math.min(w, h) / 4, startAngle, endAngle, 16)
	love.graphics.setColor(1, 1, 1, 1)
	itsyrealm.graphics.arc('line', 'open', w / 2, h / 2, math.min(w, h) / 4, startAngle, endAngle, 16)

	love.graphics.setLineWidth(1)
end

function StrategyBar:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()

	self:setSize(StrategyBar.WIDTH, StrategyBar.HEIGHT)
	self:setPosition(w / 2 - StrategyBar.WIDTH / 2, 0)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.layout = GridLayout()
	self.layout:setUniformSize(true, StrategyBar.BUTTON_SIZE, StrategyBar.BUTTON_SIZE)
	self.layout:setPadding(StrategyBar.PADDING, StrategyBar.PADDING)
	self.layout:setSize(self:getSize())
	self:addChild(self.layout)

	self.styleIcon = Icon()
	self.styleIcon:setIcon("Resources/Game/UI/Icons/Skills/Attack.png")
	self.layout:addChild(self.styleIcon)

	self.buttons = {}
	for i = 1, StrategyBar.NUM_BUTTONS do
		local button = Button()

		button:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/Ability.9.png",
			hover = "Resources/Renderers/Widget/Button/Ability.9.png",
			pressed = "Resources/Renderers/Widget/Button/Ability.9.png"
		}, self:getView():getResources()))

		local icon = Icon()
		icon:setSize(StrategyBar.BUTTON_SIZE, StrategyBar.BUTTON_SIZE)
		button:setData('icon', icon)
		button:addChild(icon)

		button.onClick:register(function(_, button)
			if button == 1 then
				self:activate(i, false)
			elseif button == 2 then
				self:activate(i, true)
			end
		end)

		local coolDown = Label()
		coolDown:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/TinySansSerif/Regular.ttf",
			color = { 1, 1, 0, 1 },
			fontSize = 22,
			textShadow = true
		}, self:getView():getResources()))
		coolDown:setPosition(StrategyBar.PADDING, StrategyBar.BUTTON_SIZE - 22 - StrategyBar.PADDING)
		button:setData('coolDown', coolDown)
		button:addChild(coolDown)

		self.layout:addChild(button)
		table.insert(self.buttons, button)
	end

	self.pending = StrategyBar.Pending()
	self.pending:setSize(StrategyBar.BUTTON_SIZE, StrategyBar.BUTTON_SIZE)

	self.keybinds = {}
	self:updateKeybindState()
end

function StrategyBar:getOverflow()
	return true
end

function StrategyBar:activate(index, bind)
	self:sendPoke("activate", nil, {
		index = index,
		bind = bind
	})
end

function StrategyBar:bindAbility(index, ...)
	local powers = { ... }

	local poke = {}
	for i = 1, #powers do
		table.insert(poke, {
			id = i,
			verb = "Bind",
			object = powers[i].name,
			callback = function()
				self:sendPoke("bind", nil, {
					index = index,
					power = powers[i].id
				})
			end
		})
	end

	table.insert(poke, {
		id = i,
		verb = "Clear",
		object = "",
		callback = function()
			self:sendPoke("unbind", nil, { index = index })
		end
	})

	self:getView():probe(poke)
end

function StrategyBar:updateKeybindState()
	for i = 1, StrategyBar.NUM_BUTTONS do
		local keybindName = string.format(
			"%s_%d", StrategyBar.KEY_BIND_PREFIX, i)
		local keybind = Keybinds[keybindName]
		if keybind then
			self.keybinds[i] = keybind:isDown()
		end
	end
end

function StrategyBar:activatePendingKeybinds()
	for i = 1, StrategyBar.NUM_BUTTONS do
		local keybindName = string.format(
			"%s_%d", StrategyBar.KEY_BIND_PREFIX, i)
		local keybind = Keybinds[keybindName]
		if keybind then
			local isPreviousDown = self.keybinds[i]
			local isCurrentDown = keybind:isDown()

			if isCurrentDown and not isPreviousDown then
				Log.info("Activated keybind '%s'.", keybindName)
				self:activate(i, nil)
			end
		end
	end
end

function StrategyBar:update(...)
	Interface.update(self, ...)

	self:activatePendingKeybinds()
	self:updateKeybindState()

	local state = self:getState()
	for i = 1, StrategyBar.NUM_BUTTONS do
		local keybindKeys
		do
			local keybindName = string.format(
				"%s_%d", StrategyBar.KEY_BIND_PREFIX, i)
			local keybind = Keybinds[keybindName]

			keybindKeys = keybind:getBinding()
		end

		local power = state.powers[i]

		local coolDown = self.buttons[i]:getData('coolDown')
		local icon = self.buttons[i]:getData('icon')

		if power then
			local t = power.type
			if t:lower() == "power" then
				icon:setIcon(string.format("Resources/Game/Powers/%s/Icon.png", power.id))
			elseif t:lower() == "prayer" then
				icon:setIcon(string.format("Resources/Game/Effects/%s/Icon.png", power.id))
			elseif t:lower() == "item" then
				icon:setIcon(string.format("Resources/Game/Items/%s/Icon.png", power.id))
			else
				icon:setIcon(false)
			end

			local description = {}
			for i = 1, #power.description do
				table.insert(description, ToolTip.Text(power.description[i]))
			end

			local toolTip = {
				ToolTip.Header(power.name),
				unpack(power.description)
			}

			table.insert(toolTip, ToolTip.Header("Keybind"))
			table.insert(toolTip, ToolTip.Text("Press: " .. keybindKeys))

			self.buttons[i]:setToolTip(unpack(toolTip))

			if power.coolDown then
				coolDown:setText(tostring(power.coolDown))
			else
				coolDown:setText("")
			end

			if state.pending == i then
				self.buttons[i]:addChild(self.pending)
			else
				self.buttons[i]:removeChild(self.pending)
			end
		else
			coolDown:setText("")
			icon:setIcon(false)
			self.buttons[i]:setToolTip()
		end
	end

	if not state.pending and self.pending:getParent() then
		self.pending:getParent():removeChild(self.pending)
	end

	self.styleIcon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", state.style))
end

return StrategyBar
