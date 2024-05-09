--------------------------------------------------------------------------------
-- ItsyScape/UI/CharacterCustomizationV2.lua
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
local NullActor = require "ItsyScape.Game.Null.Actor"
local ActorView = require "ItsyScape.Graphics.ActorView"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"
local Widget = require "ItsyScape.UI.Widget"
local DialogBox = require "ItsyScape.UI.Interfaces.DialogBox"

local CharacterCustomization = Class(Interface)

CharacterCustomization.INACTIVE_SKIN_BUTTON_STYLE = {
	inactive = Color(0, 0, 0, 0),
	hover = Color(0.7, 0.6, 0.5),
	active = Color(0.5, 0.4, 0.3)
}

CharacterCustomization.ACTIVE_SKIN_BUTTON_STYLE = {
	inactive = Color(0.7, 0.6, 0.5),
	hover = Color(0.7, 0.6, 0.5),
	active = Color(0.5, 0.4, 0.3)
}

CharacterCustomization.NUM_MAIN_COLUMNS = 3
CharacterCustomization.NUM_SKIN_COLUMNS = _MOBILE and 2 or 3

CharacterCustomization.PADDING = 8

CharacterCustomization.PLAYER_SKIN_TYPE_NAME = "ItsyScape.Game.Skin.ModelSkin"

function CharacterCustomization:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	local columnWidth = math.floor(w / self.NUM_MAIN_COLUMNS)
	self:setSize(w, h)

	self.skinOptionCamera = ThirdPersonCamera()
	self.skinOptionCamera:setUp(-Vector.UNIT_Y)
	self.skinOptionCamera:setVerticalRotation(-math.pi / 2)
	self.skinOptionCamera:setHorizontalRotation(-math.pi / 12)
	self.skinOptionCamera:setPosition(Vector(0, 1.5, 0))
	self.skinOptionCamera:setDistance(2.5)

	self.characterCamera = ThirdPersonCamera()
	self.characterCamera:setUp(-Vector.UNIT_Y)
	self.characterCamera:setDistance(7)
	self.characterCamera:setVerticalRotation(-math.pi / 2)
	self.characterCamera:setHorizontalRotation(-math.pi / 12)
	self.characterCamera:setPosition(Vector.UNIT_Y)
	self.characterCamera:setWidth(columnWidth)
	self.characterCamera:setHeight(h)

	local panel = Panel()
	panel:setSize(w, h)
	self:addChild(panel)

	self.characterSceneSnippet = SceneSnippet()
	self.characterSceneSnippet:setSize(columnWidth, h)
	self.characterSceneSnippet:setPosition(columnWidth, 0)
	self.characterSceneSnippet:setCamera(self.characterCamera)
	self:addChild(self.characterSceneSnippet)

	local skinButtonSize = math.floor((columnWidth - ScrollablePanel.DEFAULT_SCROLL_SIZE) / self.NUM_SKIN_COLUMNS) - self.PADDING * 2
	self.skinOptionLayout = ScrollablePanel(GridLayout)
	self.skinOptionLayout:setSize(columnWidth, h / 2)
	self.skinOptionLayout:setPosition(columnWidth * 2, 0)
	self.skinOptionLayout:getInnerPanel():setUniformSize(true, skinButtonSize, skinButtonSize)
	self.skinOptionLayout:getInnerPanel():setPadding(self.PADDING, self.PADDING)
	self.skinOptionLayout:getInnerPanel():setWrapContents(true)
	self:addChild(self.skinOptionLayout)

	self.colorConfig = {}
end

function CharacterCustomization:getIsFullscreen()
	return true
end

function CharacterCustomization:updateCurrentPlayer(sceneSnippet, playerSkinStorage, skinOverride)
	local actor = NullActor()
	actor:spawn(1)

	local actorView = ActorView(actor, "Player")
	actorView:attach(_APP:getGameView())

	actor:setBody(CacheRef("ItsyScape.Game.Body", "Resources/Game/Bodies/Human.lskel"))
	actor:playAnimation(
		"idle",
		0,
		CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Idle_1/Script.lua"))

	for _, skin in pairs(playerSkinStorage) do
		if skin.type then
			actor:setSkin(skin.slot, skin.priority, CacheRef(skin.type, skin.filename), skin.config)
		end
	end

	for _, skin in pairs(skinOverride or {}) do
		if skin.type then
			actor:setSkin(skin.slot, skin.priority, CacheRef(skin.type, skin.filename), skin.config)
		end
	end

	sceneSnippet:setChildNode(actorView:getSceneNode())

	local parentNode = SceneNode()
	parentNode:setParent(sceneSnippet:getRoot())

	local ambientLightSceneNode = AmbientLightSceneNode()
	ambientLightSceneNode:setAmbience(1)
	ambientLightSceneNode:setParent(parentNode)

	sceneSnippet:setParentNode(parentNode)

	return actor, actorView
end

function CharacterCustomization:populateSkinOptions(playerSkinStorage, skins, slot, priority, config)
	self.skinOptionLayout:clearChildren()

	local _, buttonWidth, buttonHeight = self.skinOptionLayout:getInnerPanel():getUniformSize()
	self.skinOptionCamera:setWidth(buttonWidth)
	self.skinOptionCamera:setHeight(buttonHeight)

	for _, skin in ipairs(skins) do
		local button = Button()
		button:setToolTip(skin.name)

		local isActive = false
		for _, otherSkin in pairs(playerSkinStorage) do
			if otherSkin.filename == skin.filename then
				isActive = true
				break
			end
		end

		if isActive then
			button:setStyle(ButtonStyle(self.ACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
		else
			button:setStyle(ButtonStyle(self.INACTIVE_SKIN_BUTTON_STYLE, self:getView():getResources()))
		end

		local sceneSnippet = SceneSnippet()
		sceneSnippet:setCamera(self.skinOptionCamera)
		sceneSnippet:setSize(buttonWidth, buttonHeight)
		sceneSnippet:setFPS(15)

		local actor, actorView = self:updateCurrentPlayer(sceneSnippet, playerSkinStorage, {
			{
				slot = slot,
				priority = priority,
				type = "ItsyScape.Game.Skin.ModelSkin",
				filename = skin.filename,
				config = config
			}
		})

		button:setData("actor", actor)
		button:setData("actorView", actorView)
		button:addChild(sceneSnippet)

		self.skinOptionLayout:addChild(button)
	end

	self.skinOptionLayout:setScroll(0, 0)
	self.skinOptionLayout:setScrollSize(self.skinOptionLayout:getInnerPanel():getSize())
end

function CharacterCustomization:update(delta)
	Widget.update(self, delta)

	if not self.currentPlayerActorView then
		self.currentPlayerActor, self.currentPlayerActorView = self:updateCurrentPlayer(self.characterSceneSnippet, self:getState().skins)
	end
	self.currentPlayerActorView:update(delta)

	for _, widget in self.skinOptionLayout:getInnerPanel():iterate() do
		local actorView = widget:getData("actorView")
		if actorView then
			actorView:update(delta)
		end
	end
end

return CharacterCustomization
