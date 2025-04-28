--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerPowers.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local Icon = require "ItsyScape.UI.Icon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"
local PendingPowerIcon = require "ItsyScape.UI.Interfaces.Components.PendingPowerIcon"
local RechargingPowerBar = require "ItsyScape.UI.Interfaces.Components.RechargingPowerBar"

local PlayerPowers = Class(PlayerTab)
PlayerPowers.TITLE_SIZE = 28
PlayerPowers.BUTTON_SIZE = 48
PlayerPowers.BUTTON_PADDING = 2

function PlayerPowers:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.subPending = PendingPowerIcon()
	self.subPending:setSize(PlayerPowers.BUTTON_SIZE, PlayerPowers.BUTTON_SIZE)

	self.layout = GridLayout()
	self.layout:setWrapContents(true)
	self.layout:setPadding(0, PlayerPowers.BUTTON_PADDING)
	self.layout:setSize(self:getSize(), 0)
	self:addChild(self.layout)

	do
		local offensivePowersTitle = GridLayout()
		offensivePowersTitle:setWrapContents(true)
		offensivePowersTitle:setSize(self:getSize(), 0)

		self.offensivePowersIcon = Icon()
		self.offensivePowersIcon:setSize(PlayerPowers.TITLE_SIZE, PlayerPowers.TITLE_SIZE)
		offensivePowersTitle:addChild(self.offensivePowersIcon)

		local attackLabel = Label()
		attackLabel:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 26,
			textShadow = true,
			center = true
		}, self:getView():getResources()))
		attackLabel:setText("Rites of malice")
		offensivePowersTitle:addChild(attackLabel)

		self.layout:addChild(offensivePowersTitle)
	end

	self.offensivePowersLayout = GridLayout()
	self.offensivePowersLayout:setID("PlayerPowers-Offensive")
	self.offensivePowersLayout:setWrapContents(true)
	self.offensivePowersLayout:setUniformSize(
		true,
		PlayerPowers.BUTTON_SIZE + PlayerPowers.BUTTON_PADDING * 2,
		PlayerPowers.BUTTON_SIZE + PlayerPowers.BUTTON_PADDING * 2)
	self.offensivePowersLayout:setSize(self:getSize(), 0)

	self.layout:addChild(self.offensivePowersLayout)

	do
		local defensivePowersTitle = GridLayout()
		defensivePowersTitle:setWrapContents(true)
		defensivePowersTitle:setSize(self:getSize(), 0)

		local defensivePowersIcon = Icon()
		defensivePowersIcon:setSize(PlayerPowers.TITLE_SIZE, PlayerPowers.TITLE_SIZE)
		defensivePowersIcon:setIcon("Resources/Game/UI/Icons/Skills/Defense.png")
		defensivePowersTitle:addChild(defensivePowersIcon)

		local defendLabel = Label()
		defendLabel:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 26,
			textShadow = true,
			center = true
		}, self:getView():getResources()))
		defendLabel:setText("Rites of bulwark")
		defensivePowersTitle:addChild(defendLabel)

		self.layout:addChild(defensivePowersTitle)
	end

	self.defensivePowersLayout = GridLayout()
	self.defensivePowersLayout:setID("PlayerPowers-Defensive")
	self.defensivePowersLayout:setWrapContents(true)
	self.defensivePowersLayout:setUniformSize(
		true,
		PlayerPowers.BUTTON_SIZE + PlayerPowers.BUTTON_PADDING * 2,
		PlayerPowers.BUTTON_SIZE + PlayerPowers.BUTTON_PADDING * 2)
	self.defensivePowersLayout:setSize(self:getSize(), 0)

	self.layout:addChild(self.defensivePowersLayout)

	self:refresh()
end

function PlayerPowers:onActivateOffensivePower(index)
	self:sendPoke("activateOffensivePower", nil, {
		index = index
	})
end

function PlayerPowers:onActivateDefensivePower(index)
	self:sendPoke("activateDefensivePower", nil, {
		index = index
	})
end

function PlayerPowers:createPowerButtons(powers, layout, onClick)
	layout:clearChildren()
	layout:setSize(self:getSize(), 0)

	local buttons = {}
	for i = 1, #powers do
		local button = Button()

		local icon = Icon()
		icon:setPosition(PlayerPowers.BUTTON_PADDING, PlayerPowers.BUTTON_PADDING)
		icon:setSize(PlayerPowers.BUTTON_SIZE, PlayerPowers.BUTTON_SIZE)
		button:setData("icon", icon)
		button:addChild(icon)

		button.onClick:register(onClick, self, i)

		local rechargeBar = RechargingPowerBar()
		button:setData("recharge", rechargeBar)

		layout:addChild(button)

		table.insert(buttons, button)
	end

	return buttons
end

function PlayerPowers:initOffensivePowers()
	local state = self:getState()
	local powers = state.offensive

	self.offensivePowersButtons = self:createPowerButtons(powers, self.offensivePowersLayout, self.onActivateOffensivePower)
end

function PlayerPowers:initDefensivePowers()
	local state = self:getState()
	local powers = state.defensive

	self.defensivePowersButtons = self:createPowerButtons(powers, self.defensivePowersLayout, self.onActivateDefensivePower)
end

function PlayerPowers:refresh()
	self:initOffensivePowers()
	self:initDefensivePowers()

	self.layout:performLayout()
end

function PlayerPowers:updatePowers(buttons, powers, pendingID)
	local state = self:getState()

	for i = 1, #powers do
		local power = powers[i]
		local button = buttons[i]

		if power and button then
			local icon = button:getData("icon")

			icon:setIcon(string.format("Resources/Game/Powers/%s/Icon.png", power.id))

			if math.floor(power.zeal * 100) > math.floor(state.zeal.current * 100) then
				icon:setColor(Color(0.25))
			else
				icon:setColor(Color(1))
			end

			local description = {}
			for i = 1, #power.description do
				table.insert(description, ToolTip.Text(power.description[i]))
			end

			local toolTip = {
				ToolTip.Header(power.name),
				ToolTip.Text(string.format("This rite uses %d%% zeal.", power.zeal * 100)),
				unpack(power.description)
			}

			local rechargeBar = button:getData("recharge")
			rechargeBar:updateRecharge(power.pending, power.zeal)

			local buttonWidth, buttonHeight = button:getSize()
			rechargeBar:setPosition(self.BUTTON_PADDING, buttonHeight - 8 - self.BUTTON_PADDING)
			rechargeBar:setSize(buttonWidth - self.BUTTON_PADDING * 2, 8)

			if rechargeBar:getParent() ~= button then
				button:addChild(rechargeBar)
			end

			button:setToolTip(unpack(toolTip))

			button:setID("PlayerPowers-Power-" .. power.id)

			if pendingID == power.id then
				button:addChild(self.subPending)
			else
				button:removeChild(self.subPending)
			end
		end
	end
end

function PlayerPowers:update(delta)
	PlayerTab.update(self, delta)

	local state = self:getState()

	self.offensivePowersIcon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", state.style))

	self:updatePowers(
		self.offensivePowersButtons,
		state.offensive,
		state.pendingID)
	self:updatePowers(
		self.defensivePowersButtons,
		state.defensive,
		state.pendingID)
end

return PlayerPowers
