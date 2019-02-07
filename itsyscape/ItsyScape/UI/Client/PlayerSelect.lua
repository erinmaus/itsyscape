--------------------------------------------------------------------------------
-- ItsyScape/UI/Client/PlayerSelect.lua
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
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local NullActor = require "ItsyScape.Game.Null.Actor"
local ActorView = require "ItsyScape.Graphics.ActorView"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local PlayerSelect = Class(Widget)
PlayerSelect.WIDTH = 480
PlayerSelect.BUTTON_HEIGHT = 240
PlayerSelect.PADDING = 8

PlayerSelect.NAME_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	width = PlayerSelect.WIDTH - PlayerSelect.BUTTON_HEIGHT - PlayerSelect.PADDING * 2
}

PlayerSelect.LOCATION_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 18,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	width = PlayerSelect.WIDTH - PlayerSelect.BUTTON_HEIGHT - PlayerSelect.PADDING * 2
}

function PlayerSelect.getPlayers()
	local files = love.filesystem.getDirectoryItems("Player/")

	local results = {}
	for i = 1, #files do
		local filename = "Player/" .. files[i]
		if files[i]:match("%.dat$") and love.filesystem.getInfo(filename).type == 'file' then
			local result = PlayerStorage()
			result:deserialize(love.filesystem.read(filename) or "{}")

			table.insert(results, result)
		end
	end

	return results
end

function PlayerSelect.loadPlayerView(actor, storage)
	local skin = storage:getRoot():getSection("Player"):getSection("Skin")
	for name, section in skin:iterateSections() do
		local priority = section:get('priority')
		local slot = section:get('slot')
		local skinType = section:get('type')
		local skinFilename = section:get('filename')

		actor:setSkin(slot, priority, CacheRef(skinType, skinFilename))
	end
end

function PlayerSelect:new(application)
	Widget.new(self)

	local width, height = love.window.getMode() 

	self.application = application

	self.layout = ScrollablePanel(GridLayout)
	self.layout:setSize(PlayerSelect.WIDTH, height)
	self.layout:getInnerPanel():setPadding(PlayerSelect.PADDING, PlayerSelect.PADDING)
	self.layout:getInnerPanel():setUniformSize(
		true,
		PlayerSelect.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		PlayerSelect.BUTTON_HEIGHT)
	self:addChild(self.layout)

	self.camera = ThirdPersonCamera()
	self.camera:setWidth(PlayerSelect.BUTTON_HEIGHT - PlayerSelect.PADDING * 2)
	self.camera:setHeight(PlayerSelect.BUTTON_HEIGHT - PlayerSelect.PADDING * 2)
	self.camera:setUp(-Vector.UNIT_Y)
	self.camera:setVerticalRotation(-math.pi / 2)
	self.camera:setHorizontalRotation(-math.pi / 12)
	self.camera:setDistance(5)
	self.camera:setPosition(Vector.UNIT_Y)

	self.buttons = {}
	self.players = {}
	local players = self:getPlayers()
	for i = 1, #players do
		self:addPlayer(players[i])
	end
end

function PlayerSelect:getOverflow()
	return true
end

function PlayerSelect:addPlayer(storage)
	local actor = NullActor()
	local view = ActorView(actor, "Player")
	view:attach(self.application:getGameView())

	actor:setBody(CacheRef("ItsyScape.Game.Body", "Resources/Game/Bodies/Human.lskel"))
	actor:playAnimation(
		1,
		math.huge,
		CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Idle_1/Script.lua"))
	PlayerSelect.loadPlayerView(actor, storage)

	table.insert(self.players, {
		actor = actor,
		view = view,
		storage = storage
	})

	self:addPlayerButton(self.players[#self.players])
end

function PlayerSelect:addPlayerButton(player)
	local button = Button()
	local snippet = SceneSnippet()
	snippet:setSize(
		PlayerSelect.BUTTON_HEIGHT - PlayerSelect.PADDING * 2,
		PlayerSelect.BUTTON_HEIGHT - PlayerSelect.PADDING * 2)
	snippet:setRoot(player.view:getSceneNode())
	snippet:setCamera(self.camera)
	snippet:setPosition(PlayerSelect.PADDING, PlayerSelect.PADDING)
	button:addChild(snippet)

	local nameLabel = Label()
	nameLabel:setPosition(
		PlayerSelect.BUTTON_HEIGHT / 2 + PlayerSelect.PADDING,
		PlayerSelect.PADDING)
	nameLabel:setStyle(
		LabelStyle(
			PlayerSelect.NAME_STYLE,
			self.application:getUIView():getResources()))
	nameLabel:setText(player.storage:getRoot():getSection("Player"):getSection("Info"):get("name"))
	button:addChild(nameLabel)

	local gameDB = self.application:getGameDB()
	local location = gameDB:getResource(
		player.storage:getRoot():getSection("Location"):get("name"),
		"Map")
	if location then
		local name = gameDB:getRecord("ResourceName", {
			Language = "en-US",
			Resource = location
		})

		local description = gameDB:getRecord("ResourceDescription", {
			Language = "en-US",
			Resource = location
		})

		local locationLabel = Label()
		if name then
			locationLabel:setText(name:get("Value"))
		else
			locationLabel:setText("*" .. location.name)
		end

		locationLabel:setPosition(
			PlayerSelect.BUTTON_HEIGHT / 2 + PlayerSelect.PADDING,
			PlayerSelect.BUTTON_HEIGHT - PlayerSelect.PADDING - PlayerSelect.LOCATION_STYLE.fontSize * 2.5)
		locationLabel:setStyle(
			LabelStyle(
				PlayerSelect.LOCATION_STYLE,
				self.application:getUIView():getResources()))
		button:addChild(locationLabel)

		if description then
			button:setToolTip(
				ToolTip.Header(nameLabel:getText()),
				ToolTip.Text(string.format("Last Location: %s.", locationLabel:getText())),
				ToolTip.Text(description:get("Value")))
		end
	end

	button.onClick:register(self.loadPlayer, self, player)

	self.layout:addChild(button)
end

function PlayerSelect:loadPlayer(player)
	local storage = love.filesystem.read(player.storage:getRoot():get("filename"))
	if storage then
		local game = self.application:getGame()
		game:getPlayer():poof()
		game:tick()
		game:getDirector():getPlayerStorage(1):deserialize(storage)
		game:getPlayer():spawn()
		game:tick()

		self.application:closeTitleScreen()
	end
end

function PlayerSelect:update(delta)
	Widget.update(self, delta)

	for i = 1, #self.players do
		self.players[i].view:update(delta)
		self.players[i].view:updateAnimations()
	end
end

return PlayerSelect
