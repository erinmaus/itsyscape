--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/SailorEquipment.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Vector = require "ItsyScape.Common.Math.Vector"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ToolTip = require "ItsyScape.UI.ToolTip"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local SailorEquipment = Class(Interface)
SailorEquipment.WIDTH = 800
SailorEquipment.HEIGHT = 488

SailorEquipment.PADDING = 8
SailorEquipment.ICON_SIZE = 48
SailorEquipment.BUTTON_PADDING = 2

SailorEquipment.HEADER_HEIGHT = 48

SailorEquipment.PANEL_WIDTH = 248
SailorEquipment.PANEL_HEIGHT = 428

SailorEquipment.AVATAR_WIDTH = SailorEquipment.WIDTH - (SailorEquipment.PANEL_WIDTH * 2 + SailorEquipment.PADDING * 4)
SailorEquipment.AVATAR_HEIGHT = 428

SailorEquipment.ACCURACY = {
	{ "AccuracyStab", "Stab" },
	{ "AccuracySlash", "Slash" },
	{ "AccuracyCrush", "Crush" },
	{ "AccuracyMagic", "Magic" },
	{ "AccuracyRanged", "Ranged" }
}

SailorEquipment.DEFENSE = {
	{ "DefenseStab", "Stab" },
	{ "DefenseSlash", "Slash" },
	{ "DefenseCrush", "Crush" },
	{ "DefenseMagic", "Magic" },
	{ "DefenseRanged", "Ranged" }
}

SailorEquipment.STRENGTH = {
	{ "StrengthMelee", "Melee" },
	{ "StrengthMagic", "Magic" },
	{ "StrengthRanged", "Ranged" }
}

SailorEquipment.MISC = {
	{ "Prayer", "Divinity" }
}

function SailorEquipment:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(SailorEquipment.WIDTH, SailorEquipment.HEIGHT)
	self:setPosition(
		(w - SailorEquipment.WIDTH) / 2,
		(h - SailorEquipment.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(SailorEquipment.WIDTH, SailorEquipment.HEIGHT)
	self:addChild(panel)

	self.closeButton = Button()
	self.closeButton:setSize(SailorEquipment.HEADER_HEIGHT, SailorEquipment.HEADER_HEIGHT)
	self.closeButton:setPosition(SailorEquipment.WIDTH - SailorEquipment.HEADER_HEIGHT, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	do
		local equipmentPanelBackground = Panel()
		equipmentPanelBackground:setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, ui:getResources()))
		equipmentPanelBackground:setSize(
			SailorEquipment.PANEL_WIDTH,
			SailorEquipment.PANEL_HEIGHT)
		equipmentPanelBackground:setPosition(
			SailorEquipment.AVATAR_WIDTH + SailorEquipment.PADDING * 2,
			SailorEquipment.HEADER_HEIGHT)
		self:addChild(equipmentPanelBackground)

		self.equipmentLayout = GridLayout()
		self.equipmentLayout:setPadding(SailorEquipment.PADDING, SailorEquipment.PADDING)
		self.equipmentLayout:setUniformSize(
			true,
			SailorEquipment.ICON_SIZE + SailorEquipment.BUTTON_PADDING * 2,
			SailorEquipment.ICON_SIZE + SailorEquipment.BUTTON_PADDING * 2)
		self.equipmentLayout:setSize(
			SailorEquipment.PANEL_WIDTH,
			SailorEquipment.PANEL_HEIGHT)
		self.equipmentLayout:setPosition(equipmentPanelBackground:getPosition())
		self:addChild(self.equipmentLayout)
		self:initEquipment()

		do
			local stats = {}
			local statLayout = GridLayout()
			statLayout:setSize(SailorEquipment.PANEL_WIDTH, SailorEquipment.PANEL_HEIGHT / 2 + SailorEquipment.PADDING * 4)
			statLayout:setPadding(2)
			statLayout:setUniformSize(
				true,
				SailorEquipment.PANEL_WIDTH / 2 - SailorEquipment.PADDING / 2,
				SailorEquipment.PANEL_HEIGHT / 4 + 8)
			statLayout:setPosition(0, SailorEquipment.PANEL_HEIGHT / 2 - 32)

			local function emitLayout(t, title)
				local panel = Panel()
				panel:setStyle(PanelStyle({ image = false }))
				local titleLabel = Label()
				panel:setSize(SailorEquipment.PANEL_WIDTH / 2 - SailorEquipment.PADDING / 2, SailorEquipment.PANEL_HEIGHT / 4)
				titleLabel:setText(title)
				titleLabel:setPosition(
					SailorEquipment.PADDING / 2,
					SailorEquipment.PADDING / 2)
				titleLabel:setStyle(LabelStyle({
					fontSize = 16,
					font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
					textShadow = true
				}, self:getView():getResources()))
				panel:addChild(titleLabel)

				local layout = GridLayout()
				layout:setPadding(SailorEquipment.PADDING / 2)
				layout:setSize(SailorEquipment.PANEL_WIDTH / 2, SailorEquipment.PANEL_HEIGHT / 4)
				layout:setUniformSize(true, SailorEquipment.PANEL_WIDTH / 4 - SailorEquipment.PADDING, 8)
				layout:setPosition(SailorEquipment.PADDING / 2, 20)
				panel:addChild(layout)

				for i = 1, #t do
					local style = LabelStyle({
						fontSize = 12,
						font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
						textShadow = true
					}, self:getView():getResources())

					local left = Label()
					left:setText(t[i][2])
					left:setStyle(style)
					layout:addChild(left)

					local right = Label()
					right:setData('stat', t[i][1])
					right:setStyle(style)
					right:bind("text", "stats[{stat}]")
					layout:addChild(right)
				end

				statLayout:addChild(panel)
			end

			emitLayout(SailorEquipment.ACCURACY, "Accuracy")
			emitLayout(SailorEquipment.DEFENSE, "Defense")
			emitLayout(SailorEquipment.STRENGTH, "Strength")
			emitLayout(SailorEquipment.MISC, "Misc")

			equipmentPanelBackground:addChild(statLayout)
		end

		local label = Label()
		label:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 18,
			textShadow = true,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		label:setText("Sailor Equipment")
		label:setPosition(equipmentPanelBackground:getPosition(), SailorEquipment.PADDING)

		self:addChild(label)
	end

	do
		local inventoryPanelBackground = Panel()
		inventoryPanelBackground:setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, ui:getResources()))
		inventoryPanelBackground:setPosition(
			SailorEquipment.AVATAR_WIDTH + SailorEquipment.PANEL_WIDTH + SailorEquipment.PADDING * 3,
			SailorEquipment.HEADER_HEIGHT)
		inventoryPanelBackground:setSize(
			SailorEquipment.PANEL_WIDTH,
			SailorEquipment.PANEL_HEIGHT)
		self:addChild(inventoryPanelBackground)

		self.inventoryLayout = GridLayout()
		self.inventoryLayout:setPadding(SailorEquipment.PADDING, SailorEquipment.PADDING)
		self.inventoryLayout:setUniformSize(
			true,
			SailorEquipment.ICON_SIZE + SailorEquipment.BUTTON_PADDING * 2,
			SailorEquipment.ICON_SIZE + SailorEquipment.BUTTON_PADDING * 2)
		self.inventoryLayout:setSize(
			SailorEquipment.PANEL_WIDTH,
			SailorEquipment.PANEL_HEIGHT)
		self.inventoryLayout:setPosition(inventoryPanelBackground:getPosition())
		self:addChild(self.inventoryLayout)
		self:initInventory()

		local label = Label()
		label:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 18,
			textShadow = true,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		label:setText("Your Inventory")
		label:setPosition(inventoryPanelBackground:getPosition(), SailorEquipment.PADDING)
		self:addChild(label)
	end

	do
		self.camera = ThirdPersonCamera()
		self.camera:setDistance(2.5)
		self.camera:setUp(Vector(0, -1, 0))

		self.peep = SceneSnippet()
		self.peep:setSize(
			SailorEquipment.AVATAR_WIDTH,
			SailorEquipment.AVATAR_HEIGHT)
		self.peep:setPosition(
			SailorEquipment.PADDING,
			SailorEquipment.HEADER_HEIGHT)
		self.peep:setCamera(self.camera)
		self:addChild(self.peep)

		local nameLabel = Label()
		nameLabel:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 18,
			textShadow = true,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		nameLabel:bind("text", "name")
		nameLabel:setPosition(SailorEquipment.PADDING, SailorEquipment.PADDING)
		self:addChild(nameLabel)

		local statsLabel = Label()
		statsLabel:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 28,
			textShadow = true,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		statsLabel:bind("text", "level")
		statsLabel:setPosition(
			SailorEquipment.PADDING * 2 + 32,
			SailorEquipment.HEIGHT - 38 - SailorEquipment.PADDING)
		self:addChild(statsLabel)

		local statsIcon = Icon()
		statsIcon:setIcon("Resources/Game/UI/Icons/Common/Skills.png")
		statsIcon:setSize(32, 32)
		statsIcon:setPosition(SailorEquipment.PADDING, SailorEquipment.HEIGHT - 32 - SailorEquipment.PADDING)
		statsIcon:setToolTip(
			ToolTip.Text("Your sailor's combat stats are the same level as your unboosted Sailing level."))
		self:addChild(statsIcon)
	end
end

function SailorEquipment:initInventory()
	local state = self:getState()
	local inventory = state.inventory

	for i = 1, inventory.n do
		local button = Button()
		local icon = ItemIcon()
		icon:setData('index', i)
		icon:bind("itemID", "inventory[{index}].id")
		icon:bind("itemCount", "inventory[{index}].count")
		icon:bind("itemIsNoted", "inventory[{index}].noted")
		icon:bind("isDisabled", "inventory[{index}].disabled")
		icon:setSize(
			SailorEquipment.ICON_SIZE,
			SailorEquipment.ICON_SIZE)
		icon:setPosition(
			SailorEquipment.BUTTON_PADDING,
			SailorEquipment.BUTTON_PADDING)

		button:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			hover = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			pressed = "Resources/Renderers/Widget/Button/InventoryItem.9.png"
		}, self:getView():getResources()))

		button:addChild(icon)
		button:setData('icon', icon)
		button.onClick:register(self.equip, self, i)
		button.onMouseMove:register(self.examine, self, i, 'inventory')

		self.inventoryLayout:addChild(button)
	end
end

function SailorEquipment:initEquipment()
	local state = self:getState()
	local equipment = state.equipment

	for i = 1, equipment.n do
		local button = Button()
		local icon = ItemIcon()
		icon:setData('index', equipment.slots[i])
		icon:bind("itemID", "equipment[{index}].id")
		icon:bind("itemCount", "equipment[{index}].count")
		icon:bind("itemIsNoted", "equipment[{index}].noted")
		icon:setSize(
			SailorEquipment.ICON_SIZE,
			SailorEquipment.ICON_SIZE)
		icon:setPosition(
			SailorEquipment.BUTTON_PADDING,
			SailorEquipment.BUTTON_PADDING)

		button:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			hover = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			pressed = "Resources/Renderers/Widget/Button/InventoryItem.9.png"
		}, self:getView():getResources()))

		button:addChild(icon)
		button:setData('icon', icon)
		button.onClick:register(self.dequip, self, equipment.slots[i])
		button.onMouseMove:register(self.examine, self, equipment.slots[i], 'equipment')

		self.equipmentLayout:addChild(button)
	end
end

function SailorEquipment:examine(index, key, button)
	local icon = button:getData('icon')

	local item = self:getState()[key][index]
	if not item then
		icon:setToolTip()
		return
	end

	local object, description = Utility.Item.getInfo(
		item.id,
		self:getView():getGame():getGameDB())

	local action = item.actions[1]
	if action and (action.type:lower() == "equip" or action.type:lower() == "dequip") then
		object = action.verb .. " " .. object
	end

	icon:setToolTip(
		ToolTip.Header(object),
		ToolTip.Text(description))
end

function SailorEquipment:equip(index)
	self:sendPoke("equip", nil, { index = index })
end

function SailorEquipment:dequip(index)
	self:sendPoke("dequip", nil, { index = index })
end

function SailorEquipment:update()
	local state = self:getState()

	local gameCamera = self:getView():getGameView():getRenderer():getCamera()
	self.camera:setHorizontalRotation(gameCamera:getHorizontalRotation())
	self.camera:setVerticalRotation(gameCamera:getVerticalRotation())

	if state.actor and not self.actorView then
		local game = self:getView():getGame()
		local gameView = self:getView():getGameView()
		for actor in game:getStage():iterateActors() do
			if actor:getID() == state.actor then
				local actorView = gameView:getActor(actor)
				if actorView then
					self.peep:setRoot(actorView:getSceneNode())
					self.actorView = actorView
					self.actor = actor
				end
			end
		end
	end

	if self.actor then
		local min, max = self.actor:getBounds()
		local offset = (max.y - min.y) / 2 - 0.5
		local zoom = (max.z - min.z) + math.max((max.y - min.y), (max.x - min.x)) + 4

		-- Flip if facing left.
		if self.actor:getDirection().x < 0 then
			self.camera:setVerticalRotation(
				self.camera:getVerticalRotation() + math.pi)
		end

		local root = self.peep:getRoot()
		local transform = root:getTransform():getGlobalTransform()
		local x, y, z = transform:transformPoint(0, offset, 0)

		local w, h = self.peep:getSize()
		self.camera:setWidth(w)
		self.camera:setHeight(h)
		self.camera:setPosition(Vector(x, y, z))
		self.camera:setDistance(zoom)
	end
end

return SailorEquipment
