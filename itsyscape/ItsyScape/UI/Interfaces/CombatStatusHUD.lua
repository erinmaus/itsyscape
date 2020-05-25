--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CombatStatusHUD.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Drawable = require "ItsyScape.UI.Drawable"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Icon = require "ItsyScape.UI.Icon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local CombatStatusHUD = Class(Interface)
CombatStatusHUD.HUD_WIDTH = 288
CombatStatusHUD.HUD_HEIGHT = 96
CombatStatusHUD.HUD_PEEP_WIDTH = 78
CombatStatusHUD.HUD_PEEP_HEIGHT = 78
CombatStatusHUD.EFFECT_SIZE = 48
CombatStatusHUD.PADDING = 4
CombatStatusHUD.MISC_ICON_SIZE = 48
CombatStatusHUD.FLEE_BUTTON_SIZE = 48
CombatStatusHUD.WIDTH = (CombatStatusHUD.EFFECT_SIZE + CombatStatusHUD.PADDING * 2) * 4
CombatStatusHUD.PEEP_HEAD_BUTTON_STYLE = {
	inactive = 'Resources/Renderers/Widget/Button/CombatPeepBorder-Inactive.9.png',
	hover = 'Resources/Renderers/Widget/Button/CombatPeepBorder-Hover.9.png',
	pressed = 'Resources/Renderers/Widget/Button/CombatPeepBorder-Pressed.9.png'
}
CombatStatusHUD.PEEP_HEAD_PANEL = {
	image = 'Resources/Renderers/Widget/Panel/CombatStatusPeep.9.png'
}
CombatStatusHUD.PEEP_STAT_PANEL = {
	image = 'Resources/Renderers/Widget/Panel/CombatStatusBar.9.png'
}
CombatStatusHUD.PEEP_STAT_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 28,
	textShadow = true
}

CombatStatusHUD.EffectBorder = Class(Drawable)
CombatStatusHUD.EffectBorder.BORDER_THICKNESS = 1
function CombatStatusHUD.EffectBorder:new()
	Drawable.new(self)

	self.current = 0
	self.max = 1
	self.color = Color(1, 1, 1, 0)
end

function CombatStatusHUD.EffectBorder:getColor()
	return self.color
end

function CombatStatusHUD.EffectBorder:setColor(value)
	self.color = value or self.color
end

function CombatStatusHUD.EffectBorder:draw(resources, state)
	local w, h = self:getSize()

	love.graphics.setColor(self.color:get())
	love.graphics.setLineWidth(2)
	love.graphics.rectangle('line', 0, 0, w, h)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end


function CombatStatusHUD:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local resources = self:getView():getResources()

	self.effectsPanel = GridLayout()
	self.effectsPanel:setUniformSize(true, CombatStatusHUD.EFFECT_SIZE, CombatStatusHUD.EFFECT_SIZE)
	self.effectsPanel:setPadding(CombatStatusHUD.PADDING, CombatStatusHUD.PADDING)
	self.effectsPanel:setWrapContents(true)
	self.effectsPanel:setSize(CombatStatusHUD.WIDTH, 0)
	self:addChild(self.effectsPanel)

	local hitpointsPanel = Panel()
	hitpointsPanel:setStyle(PanelStyle(CombatStatusHUD.PEEP_STAT_PANEL, resources))
	hitpointsPanel:setSize(
		CombatStatusHUD.HUD_WIDTH - CombatStatusHUD.PADDING,
		CombatStatusHUD.HUD_HEIGHT / 2)
	hitpointsPanel:setPosition(
		CombatStatusHUD.PADDING,
		0)
	self:addChild(hitpointsPanel)

	self.hitpointsText = Label()
	self.hitpointsText:setStyle(LabelStyle(CombatStatusHUD.PEEP_STAT_LABEL_STYLE, resources))
	self.hitpointsText:setText("0/0")
	self.hitpointsText:setPosition(CombatStatusHUD.HUD_HEIGHT + CombatStatusHUD.MISC_ICON_SIZE, CombatStatusHUD.PADDING)
	hitpointsPanel:addChild(self.hitpointsText)

	local constitutionIcon = Icon()
	constitutionIcon:setIcon("Resources/Game/UI/Icons/Skills/Constitution.png")
	constitutionIcon:setSize(CombatStatusHUD.MISC_ICON_SIZE, CombatStatusHUD.MISC_ICON_SIZE)
	constitutionIcon:setPosition(CombatStatusHUD.HUD_HEIGHT, 0)
	hitpointsPanel:addChild(constitutionIcon)

	local miscPanel = Panel()
	miscPanel:setStyle(PanelStyle(CombatStatusHUD.PEEP_STAT_PANEL, resources))
	miscPanel:setSize(
		CombatStatusHUD.HUD_WIDTH - CombatStatusHUD.PADDING,
		CombatStatusHUD.HUD_HEIGHT / 2)
	miscPanel:setPosition(
		CombatStatusHUD.PADDING,
		CombatStatusHUD.HUD_HEIGHT / 2)
	self:addChild(miscPanel)

	self.prayerText = Label()
	self.prayerText:setStyle(LabelStyle(CombatStatusHUD.PEEP_STAT_LABEL_STYLE, resources))
	self.prayerText:setText("0/0")
	self.prayerText:setPosition(CombatStatusHUD.HUD_HEIGHT + CombatStatusHUD.MISC_ICON_SIZE, CombatStatusHUD.PADDING)
	miscPanel:addChild(self.prayerText)

	local prayerIcon = Icon()
	prayerIcon:setIcon("Resources/Game/UI/Icons/Skills/Faith.png")
	prayerIcon:setSize(CombatStatusHUD.MISC_ICON_SIZE, CombatStatusHUD.MISC_ICON_SIZE)
	prayerIcon:setPosition(CombatStatusHUD.HUD_HEIGHT, 0)
	miscPanel:addChild(prayerIcon)

	self.hudPanel = Panel()
	self.hudPanel:setStyle(PanelStyle({ image = false }, resources))
	self.hudPanel:setSize(CombatStatusHUD.HUD_WIDTH, CombatStatusHUD.HUD_HEIGHT)
	self:addChild(self.hudPanel)

	local peepIconPanel = Panel()
	peepIconPanel:setStyle(PanelStyle(CombatStatusHUD.PEEP_HEAD_PANEL, resources))
	peepIconPanel:setSize(CombatStatusHUD.HUD_HEIGHT, CombatStatusHUD.HUD_HEIGHT)
	self.hudPanel:addChild(peepIconPanel)

	self.peepIcon = SceneSnippet()
	self.peepIcon:setSize(
		CombatStatusHUD.HUD_PEEP_WIDTH,
		CombatStatusHUD.HUD_PEEP_HEIGHT)
	self.peepIcon:setPosition(
		CombatStatusHUD.HUD_HEIGHT / 2 - CombatStatusHUD.HUD_PEEP_WIDTH / 2,
		CombatStatusHUD.HUD_HEIGHT / 2 - CombatStatusHUD.HUD_PEEP_HEIGHT / 2)
	self.hudPanel:addChild(self.peepIcon)

	self.fleeButton = Button()
	self.fleeButton:setPosition(
		CombatStatusHUD.HUD_WIDTH - CombatStatusHUD.FLEE_BUTTON_SIZE,
		CombatStatusHUD.HUD_HEIGHT - CombatStatusHUD.FLEE_BUTTON_SIZE)
	self.fleeButton:setSize(CombatStatusHUD.FLEE_BUTTON_SIZE, CombatStatusHUD.FLEE_BUTTON_SIZE)
	self.fleeButton:setStyle(ButtonStyle({
		hover = "Resources/Renderers/Widget/Button/SelectedAttackStyle-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/SelectedAttackStyle-Pressed.9.png",
		icon = { filename = "Resources/Game/UI/Icons/Concepts/Flee.png", x = 0.5, y = 0.5 }
	}, self:getView():getResources()))
	self.fleeButton.onClick:register(function()
		local game = self:getView():getGame()
		local player = game:getPlayer()
		player:flee()
	end)
	self.fleeButton:setToolTip(ToolTip.Text("Flee from combat."))

	self.toggleButton = Button()
	self.toggleButton:setStyle(ButtonStyle(CombatStatusHUD.PEEP_HEAD_BUTTON_STYLE, resources))
	self.toggleButton:setSize(self.peepIcon:getSize())
	self.toggleButton:setPosition(self.peepIcon:getPosition())
	self.toggleButton.onClick:register(self.toggle, self)
	self.hudPanel:addChild(self.toggleButton)

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(2.5)
	self.camera:setUp(Vector(0, -1, 0))
	self.peepIcon:setCamera(self.camera)

	self.effects = {}

	self:setSize(self.hudPanel:getSize())
end

function CombatStatusHUD:getOverflow()
	return true
end

function CombatStatusHUD:toggle()
	self:sendPoke("toggle", nil, {})
end

function CombatStatusHUD:updateStats()
	local state = self:getState()

	self.hitpointsText:setText(string.format("%d/%d", state.stats.hitpoints.current, state.stats.hitpoints.max))
	self.prayerText:setText(string.format("%d/%d", state.stats.prayer.current, state.stats.prayer.max))
end

function CombatStatusHUD:updatePeepIcon()
	local state = self:getState()

	local gameCamera = self:getView():getGameView():getRenderer():getCamera()
	self.camera:setHorizontalRotation(gameCamera:getHorizontalRotation())
	self.camera:setVerticalRotation(gameCamera:getVerticalRotation())

	local actor
	if state.actor then
		local game = self:getView():getGame()
		local gameView = self:getView():getGameView()
		for a in game:getStage():iterateActors() do
			if a:getID() == state.actor then
				local actorView = gameView:getActor(a)
				if actorView then
					self.peepIcon:setRoot(actorView:getSceneNode())
					actor = a
					break
				end
			end
		end
	end

	local offset
	local zoom
	if actor then
		local min, max = actor:getBounds()
		offset = (max.y - min.y) / 2
		zoom = (max.z - min.z) + math.max((max.y - min.y), (max.x - min.x)) + 1

		-- Flip if facing left.
		if actor:getDirection().x < 0 then
			self.camera:setVerticalRotation(
				self.camera:getVerticalRotation() + math.pi)
		end
	else
		offset = 0
		zoom = 1
	end

	local root = self.peepIcon:getRoot()
	local transform = root:getTransform():getGlobalTransform()

	local x, y, z = transform:transformPoint(0, offset, 0)

	local w, h = self.peepIcon:getSize()
	self.camera:setWidth(w)
	self.camera:setHeight(h)
	self.camera:setPosition(Vector(x, y, z))
	self.camera:setDistance(zoom)
end

function CombatStatusHUD:update(...)
	Interface.update(self, ...)

	for i = 1, #self.effects do
		self.effectsPanel:removeChild(self.effects[i])
	end

	local state = self:getState()
	for i = 1, #state.effects do
		local icon = self.effects[i]
		if not icon then
			icon = Icon()
			local label = Label()
			label:setPosition(CombatStatusHUD.PADDING, CombatStatusHUD.EFFECT_SIZE - 22 - CombatStatusHUD.PADDING)
			icon:setData('label', label)
			icon:addChild(icon:getData('label'))

			border = CombatStatusHUD.EffectBorder()
			border:setSize(CombatStatusHUD.EFFECT_SIZE, CombatStatusHUD.EFFECT_SIZE)
			icon:setData('border', border)
			icon:addChild(border)
		end

		icon:setIcon(string.format("Resources/Game/Effects/%s/Icon.png", state.effects[i].id))
		icon:setSize(CombatStatusHUD.EFFECT_SIZE, CombatStatusHUD.EFFECT_SIZE)

		self.effectsPanel:addChild(icon)
		self.effects[i] = icon

		local duration = state.effects[i].duration
		if duration ~= math.huge then
			local HOUR = 60 * 60
			local MINUTE = 60

			local time, suffix
			if duration > HOUR then
				time = math.floor(duration / HOUR)
				suffix = 'h'
			elseif duration > MINUTE then
				time = math.floor(duration / MINUTE)
				suffix = 'm'
			else
				time = math.floor(duration)
				suffix = 's'
			end

			local label = icon:getData('label')
			label:setText(string.format("%d%s", time, suffix))
			label:setStyle(LabelStyle({
				font = "Resources/Renderers/Widget/Common/TinySansSerif/Regular.ttf",
				fontSize = 22,
				textShadow = true
			}, self:getView():getResources()))
		else
			icon:getData('label'):setText("")
		end

		do
			if state.effects[i].buff then
				icon:getData('border'):setColor(Color(0, 1, 0, 1))
			elseif state.effects[i].debuff then
				icon:getData('border'):setColor(Color(1, 0, 0, 1))
			else
				icon:getData('border'):setColor(Color(1, 1, 1, 0))
			end
		end

		icon:setToolTip(
			ToolTip.Header(state.effects[i].name),
			ToolTip.Text(state.effects[i].description))
	end

	local screenWidth, screenHeight = love.graphics.getScaledMode()
	local width, height = self.effectsPanel:getSize()
	self.effectsPanel:setPosition(
		CombatStatusHUD.PADDING,
		-(CombatStatusHUD.PADDING + height))
	self:setPosition(
		CombatStatusHUD.PADDING,
		screenHeight - CombatStatusHUD.HUD_HEIGHT - CombatStatusHUD.PADDING)

	local game = self:getView():getGame()
	local player = game:getPlayer()
	if self.isPlayerEngaged ~= player:getIsEngaged() then
		self.isPlayerEngaged = player:getIsEngaged()
		if self.isPlayerEngaged then
			self:addChild(self.fleeButton)
		else
			self:removeChild(self.fleeButton)
		end
	end

	self:updatePeepIcon()
	self:updateStats()
end

return CombatStatusHUD
