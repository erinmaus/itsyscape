--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CreateParty.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"

local CreateParty = Class(Interface)
CreateParty.WIDTH = 480
CreateParty.HEIGHT = 320
CreateParty.PADDING = 8

CreateParty.BUTTON_HEIGHT = 48
CreateParty.BUTTON_WIDTH  = 128
CreateParty.BUTTON_SIZE   = 48

CreateParty.PLAYER_ROW_HEIGHT         = CreateParty.BUTTON_HEIGHT * 3
CreateParty.PLAYER_SCENE_SNIPPET_SIZE = CreateParty.BUTTON_HEIGHT * 3

function CreateParty:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(CreateParty.WIDTH, CreateParty.HEIGHT)
	self:setPosition(
		(w - CreateParty.WIDTH) / 2,
		(h - CreateParty.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.partyMembers = ScrollablePanel(GridLayout)
	self.partyMembers:setPosition(0, 0)
	self.partyMembers:setSize(CreateParty.WIDTH, CreateParty.HEIGHT - CreateParty.BUTTON_HEIGHT - CreateParty.PADDING * 3)
	self.partyMembers:getInnerPanel():setWrapContents(true)
	self.partyMembers:getInnerPanel():setUniformSize(
		true,
		CreateParty.WIDTH - CreateParty.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		CreateParty.PLAYER_ROW_HEIGHT)
	self.partyMembers:getInnerPanel():setPadding(0, CreateParty.PADDING)
	self:addChild(self.partyMembers)

	self.closeButton = Button()
	self.closeButton:setSize(CreateParty.BUTTON_SIZE, CreateParty.BUTTON_SIZE)
	self.closeButton:setPosition(CreateParty.WIDTH - CreateParty.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	local buttonsLayout = GridLayout()
	buttonsLayout:setPadding(CreateParty.PADDING, 0)
	buttonsLayout:setSize(CreateParty.WIDTH, CreateParty.BUTTON_HEIGHT)
	buttonsLayout:setPosition(0, CreateParty.HEIGHT - CreateParty.BUTTON_HEIGHT - CreateParty.PADDING)
	buttonsLayout:setUniformSize(true, CreateParty.BUTTON_WIDTH, CreateParty.BUTTON_HEIGHT)
	self:addChild(buttonsLayout)

	local state = self:getState()
	self.toggleLockButton = Button()
	self.toggleLockButton.onClick:register(function()
		self:sendPoke("toggleLock", nil, {})
	end)
	self:updateToggleLockButton()
	buttonsLayout:addChild(self.toggleLockButton)

	self.cancelButton = Button()
	self.cancelButton:setText("Cancel")
	self.cancelButton:setToolTip("Close this window. If the raid has not yet started, the party will be disbanded.")
	self.cancelButton.onClick:register(function()
		self:sendPoke("cancel", nil, {})
	end)
	buttonsLayout:addChild(self.cancelButton)

	self.startButton = Button()
	self.startButton:setText("Start Raid")
	self.startButton:setToolTip("Start the raid. Any players in the same area will come with you.")
	self.startButton.onClick:register(function()
		self:sendPoke("start", nil, {})
	end)
	buttonsLayout:addChild(self.startButton)

	self.players = {}
end

function CreateParty:updateToggleLockButton()
	local state = self:getState()
	local isButtonLocked = self.toggleLockButton:getData('isLocked')
	if isButtonLocked ~= state.isLocked then
		self.toggleLockButton:setText((state.isLocked and "Unlock") or "Lock")
		self.toggleLockButton:setToolTip((state.isLocked and "Allow other players to join. Currently, no players can join.") or "Prevent other players from joining. Currently, any players may join.")
		self.toggleLockButton:setData('isLocked', isButtonLocked)
	end
end

function CreateParty:kickPlayer(index)
	local state = self:getState()
	self:sendPoke("kick", nil, {
		id = state.players[index].id
	})
end

function CreateParty:allocatePartyMembers(count)
	for i = 1, #self.players do
		self.partyMembers:removeChild(self.players[i].root)
	end
	self.players = {}

	for i = 1, count do
		local panel = Panel()
		panel:setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, self:getView():getResources()))

		self.partyMembers:addChild(panel)

		local name = Label()
		name:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
			fontSize = 24,
			textShadow = true,
			width = CreateParty.WIDTH - CreateParty.PADDING * 2,
			color = { 1, 1, 1, 1 }
		}, self:getView():getResources()))
		name:setPosition(CreateParty.PLAYER_SCENE_SNIPPET_SIZE + CreateParty.PADDING, CreateParty.PADDING)
		panel:addChild(name)

		local pronouns = Label()
		pronouns:setStyle(LabelStyle({
			color = { 1, 1, 1, 1 },
			textShadow = true,
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
			fontSize = 20
		}, self:getView():getResources()))
		pronouns:setPosition(
			CreateParty.PLAYER_SCENE_SNIPPET_SIZE + CreateParty.PADDING,
			CreateParty.PLAYER_ROW_HEIGHT - 20 - CreateParty.PADDING)
		panel:addChild(pronouns)
		
		local kickButton = Button()
		kickButton:setText("Kick")
		kickButton:setToolTip("Kick this player from the party.")
		kickButton:setSize(CreateParty.BUTTON_WIDTH / 2, CreateParty.BUTTON_HEIGHT)
		kickButton:setPosition(CreateParty.WIDTH - CreateParty.BUTTON_WIDTH / 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE - CreateParty.PADDING * 3, CreateParty.PADDING)
		kickButton.onClick:register(self.kickPlayer, self, i)

		if i > 1 then
			panel:addChild(kickButton)
		end

		local camera = ThirdPersonCamera()
		camera:setDistance(5)
		camera:setUp(-Vector.UNIT_Y)
		camera:setVerticalRotation(-math.pi / 2)
		camera:setHorizontalRotation(-math.pi / 12)
		camera:setWidth(CreateParty.PLAYER_SCENE_SNIPPET_SIZE)
		camera:setHeight(CreateParty.PLAYER_SCENE_SNIPPET_SIZE)

		local sceneSnippet = SceneSnippet()
		sceneSnippet:setSize(CreateParty.PLAYER_SCENE_SNIPPET_SIZE, CreateParty.PLAYER_SCENE_SNIPPET_SIZE)
		sceneSnippet:setPosition(0, 0)
		sceneSnippet:setIsFullLit(true)
		sceneSnippet:setCamera(camera)
		panel:addChild(sceneSnippet)

		local player = {
			root = panel,
			playerSceneSnippet = sceneSnippet,
			name = name,
			pronouns = pronouns,
			kickButton = kickButton,
			camera = camera
		}

		table.insert(self.players, player)
	end

	self.partyMembers:setScrollSize(self.partyMembers:getInnerPanel():getSize())
	local scrollX, scrollY = self.partyMembers:getScroll()
	local scrollSizeX, scrollSizeY = self.partyMembers:getScrollSize()
	self.partyMembers:setScroll(scrollX, math.max(math.min(scrollSizeY - CreateParty.PLAYER_ROW_HEIGHT, scrollY), 0))
end

function CreateParty:updatePartyMembers()
	local state = self:getState()
	local gameView = self:getView():getGameView()

	for i = 1, #self.players do
		local playerInfo = state.players[i]
		local playerWidgets = self.players[i]

		playerWidgets.name:setText(playerInfo.name)
		playerWidgets.pronouns:setText(table.concat(playerInfo.pronouns, "/"))

		playerWidgets.playerSceneSnippet:setRoot(nil)
		if playerInfo.actorID then
			local actorView = gameView:getActor(gameView:getActorByID(playerInfo.actorID))
			if actorView then
				playerWidgets.playerSceneSnippet:setRoot(actorView:getSceneNode())

				local transform = actorView:getSceneNode():getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
				playerWidgets.camera:setPosition(Vector(transform:transformPoint(0, 1, 0)))
			end
		end
	end
end

function CreateParty:update(delta)
	Interface.update(self, delta)

	local state = self:getState()
	if #state.players ~= #self.players then
		self:allocatePartyMembers(#state.players)
	end
	self:updatePartyMembers(state.players)
end

return CreateParty
