--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/JoinParty.lua
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

local JoinParty = Class(Interface)
JoinParty.WIDTH = 640
JoinParty.HEIGHT = 480
JoinParty.PADDING = 8

JoinParty.BUTTON_HEIGHT = 48
JoinParty.BUTTON_WIDTH  = 128
JoinParty.BUTTON_SIZE   = 48

JoinParty.PLAYER_ROW_HEIGHT         = JoinParty.BUTTON_HEIGHT * 3
JoinParty.PLAYER_SCENE_SNIPPET_SIZE = JoinParty.BUTTON_HEIGHT * 3

function JoinParty:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(JoinParty.WIDTH, JoinParty.HEIGHT)
	self:setPosition(
		(w - JoinParty.WIDTH) / 2,
		(h - JoinParty.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.noPartiesLabel = Label()
	self.noPartiesLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = 32,
		textShadow = true,
		width = JoinParty.WIDTH,
		align = 'center',
		color = { 1, 1, 1, 1 }
	}, self:getView():getResources()))
	self.noPartiesLabel:setText("No parties found...\nWhy not create your own?")

	self.partyMembers = ScrollablePanel(GridLayout)
	self.partyMembers:setPosition(0, 0)
	self.partyMembers:setSize(JoinParty.WIDTH, JoinParty.HEIGHT - JoinParty.BUTTON_HEIGHT - JoinParty.PADDING * 3)
	self.partyMembers:getInnerPanel():setWrapContents(true)
	self.partyMembers:getInnerPanel():setUniformSize(
		true,
		JoinParty.WIDTH - JoinParty.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		JoinParty.PLAYER_ROW_HEIGHT)
	self.partyMembers:getInnerPanel():setPadding(0, JoinParty.PADDING)
	self:addChild(self.partyMembers)

	self.closeButton = Button()
	self.closeButton:setSize(JoinParty.BUTTON_SIZE, JoinParty.BUTTON_SIZE)
	self.closeButton:setPosition(JoinParty.WIDTH - JoinParty.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	local buttonsLayout = GridLayout()
	buttonsLayout:setPadding(JoinParty.PADDING, 0)
	buttonsLayout:setSize(JoinParty.WIDTH, JoinParty.BUTTON_HEIGHT)
	buttonsLayout:setPosition(0, JoinParty.HEIGHT - JoinParty.BUTTON_HEIGHT - JoinParty.PADDING)
	buttonsLayout:setUniformSize(true, JoinParty.BUTTON_WIDTH, JoinParty.BUTTON_HEIGHT)
	self:addChild(buttonsLayout)

	self.cancelButton = Button()
	self.cancelButton:setText("Cancel")
	self.cancelButton:setToolTip("If the raid has not yet started, you will leave the party.")
	self.cancelButton.onClick:register(function()
		self:sendPoke("cancel", nil, {})
	end)
	buttonsLayout:addChild(self.cancelButton)

	self.players = {}
end

function JoinParty:joinOrLeave(index)
	local state = self:getState()
	if state.partyID == state.players[index] then
		self:sendPoke("leave", nil, {})
	else
		self:sendPoke("join", nil, {
			id = state.players[index].id
		})
	end
end

function JoinParty:allocatePartyMembers(count)
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
			width = JoinParty.WIDTH - JoinParty.PADDING * 2,
			color = { 1, 1, 1, 1 }
		}, self:getView():getResources()))
		name:setPosition(JoinParty.PLAYER_SCENE_SNIPPET_SIZE + JoinParty.PADDING, JoinParty.PADDING)
		panel:addChild(name)

		local pronouns = Label()
		pronouns:setStyle(LabelStyle({
			color = { 1, 1, 1, 1 },
			textShadow = true,
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
			fontSize = 20
		}, self:getView():getResources()))
		pronouns:setPosition(
			JoinParty.PLAYER_SCENE_SNIPPET_SIZE + JoinParty.PADDING,
			JoinParty.PLAYER_ROW_HEIGHT - 20 - JoinParty.PADDING)
		panel:addChild(pronouns)
		
		local leaveOrJoinButton = Button()
		leaveOrJoinButton:setText("Kick")
		leaveOrJoinButton:setToolTip("Kick this player from the party.")
		leaveOrJoinButton:setSize(JoinParty.BUTTON_WIDTH / 2, JoinParty.BUTTON_HEIGHT)
		leaveOrJoinButton:setPosition(JoinParty.WIDTH - JoinParty.BUTTON_WIDTH / 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE - JoinParty.PADDING * 3, JoinParty.PADDING)
		leaveOrJoinButton.onClick:register(self.joinOrLeave, self, i)

		if i > 1 then
			panel:addChild(leaveOrJoinButton)
		end

		local camera = ThirdPersonCamera()
		camera:setDistance(5)
		camera:setUp(-Vector.UNIT_Y)
		camera:setVerticalRotation(-math.pi / 2)
		camera:setHorizontalRotation(-math.pi / 12)
		camera:setWidth(JoinParty.PLAYER_SCENE_SNIPPET_SIZE)
		camera:setHeight(JoinParty.PLAYER_SCENE_SNIPPET_SIZE)

		local sceneSnippet = SceneSnippet()
		sceneSnippet:setSize(JoinParty.PLAYER_SCENE_SNIPPET_SIZE, JoinParty.PLAYER_SCENE_SNIPPET_SIZE)
		sceneSnippet:setPosition(0, 0)
		sceneSnippet:setIsFullLit(true)
		sceneSnippet:setCamera(camera)
		panel:addChild(sceneSnippet)

		local player = {
			root = panel,
			playerSceneSnippet = sceneSnippet,
			name = name,
			pronouns = pronouns,
			leaveOrJoinButton = leaveOrJoinButton,
			camera = camera
		}

		table.insert(self.players, player)
	end

	self.partyMembers:setScrollSize(self.partyMembers:getInnerPanel():getSize())
	local scrollX, scrollY = self.partyMembers:getScroll()
	local scrollSizeX, scrollSizeY = self.partyMembers:getScrollSize()
	self.partyMembers:setScroll(scrollX, math.max(math.min(scrollSizeY - JoinParty.PLAYER_ROW_HEIGHT, scrollY), 0))
end

function JoinParty:updatePartyMembers()
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

		if state.partyID == playerInfo.id then
			playerWidgets.leaveOrJoinButton:setText("Leave")
			playerWidgets.leaveOrJoinButton:setToolTip("Leave this party.")
		else
			playerWidgets.leaveOrJoinButton:setText("Join")
			playerWidgets.leaveOrJoinButton:setToolTip("Join this party.")
		end
	end

	if #self.players == 0 then
		self:addChild(self.noPartiesLabel)
	elseif self.noPartiesLabel:getParent() then
		self.noPartiesLabel:getParent():removeChild(self.noPartiesLabel)
	end
end

function JoinParty:update(delta)
	Interface.update(self, delta)

	local state = self:getState()
	if #state.players ~= #self.players then
		self:allocatePartyMembers(#state.players)
	end
	self:updatePartyMembers(state.players)
end

return JoinParty
