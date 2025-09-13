--------------------------------------------------------------------------------
-- Resources/Game/Props/CraftedItem/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local ItemGreeble = require "Resources.Game.Props.Common.Greeble.ItemGreeble"
local ParticleGreeble = require "Resources.Game.Props.Common.Greeble.ParticleGreeble"

local CraftedItem = Class(PropView)

CraftedItem.DURATION_SHOW_INPUT_ITEMS_SECONDS  = 2.5
CraftedItem.DURATION_SHOW_OUTPUT_ITEMS_SECONDS = 2.5

CraftedItem.DUST_INTERVAL          = 0.05
CraftedItem.INITIAL_DUST_PARTICLES = 25
CraftedItem.MIN_DUST_PARTICLES     = 5
CraftedItem.MAX_DUST_PARTICLES     = 10

CraftedItem.MAX_ITEMS_PER_ROW = 4

CraftedItem.ITEM_RADIUS = 1.25
CraftedItem.ITEM_SCALE  = Vector(0.5):keep()

local STATE_NONE    = "none"
local STATE_INPUTS  = "input"
local STATE_OUTPUTS = "outputs"

function CraftedItem:_loadItemGreebles(items)
	local size = math.max(self.ITEM_SCALE.x, self.ITEM_SCALE.z)

	local particleConfig = {
		PARTICLES = {
			texture = "Resources/Game/Props/CraftedItem/Dust.png",
			numParticles = 100,
			columns = 2,
			rows = 2,

			emitters = {
				{
					type = "RadialEmitter",
					radius = { 0, size },
					speed = { 0, size }
				},
				{
					type = "RandomColorEmitter",
					colors = {
						{ 1, 1, 1, 0 } 
					}
				},
				{
					type = "RandomLifetimeEmitter",
					lifetime = { 0.1, 0.2 }
				},
				{
					type = "RandomScaleEmitter",
					scale = { size * 2, size * 2 + 0.5 }
				},
				{
					type = "RandomRotationEmitter",
					rotation = { 0, 360 },
					velocity = { 360, 720 },
				},
				{
					type = "RandomTextureIndexEmitter",
					textures = { 1, 4 }
				}
			},

			paths = {
				{
					type = "FadeInOutPath",
					fadeInPercent = { 0.1 },
					fadeOutPercent = { 0.9 },
					tween = { 'sineEaseOut' }
				},
				{
					type = "GravityPath",
					gravity = { 0, -2, 0 }
				},
			},

			emissionStrategy = {
				type = "RandomDelayEmissionStrategy",
				count = { 10, 20 },
				delay = { 0 },
				duration = { 0 }
			}
		}
	}

	for i = 1, #items do
		local currentRow = math.floor((i - 1) / self.MAX_ITEMS_PER_ROW) + 1
		local numItemsInRow = math.min(#items - ((currentRow - 1) * self.MAX_ITEMS_PER_ROW), self.MAX_ITEMS_PER_ROW)
		local offsetWithinRow = ((i - 1) % self.MAX_ITEMS_PER_ROW) + 1

		local radius
		if numItemsInRow == 1 then
			radius = 0
		else
			radius = self.ITEM_RADIUS
		end

		local angle = (offsetWithinRow - 1) / numItemsInRow * math.pi * 2

		local x = math.cos(angle) * radius
		local y = (currentRow - 1) * 2
		local z = math.sin(angle) * radius

		local itemGreeble = self:addGreeble(ItemGreeble, {
			ID = items[i]
		}, {
			translation = Vector(x, y, z) * self.ITEM_SCALE,
			scale = self.ITEM_SCALE
		})
		table.insert(self.itemGreebles, itemGreeble)

		local particleGreeble = self:addGreeble(ParticleGreeble, particleConfig, {
			translation = Vector(x, y, z) * self.ITEM_SCALE
		})
		table.insert(self.particleGreebles, particleGreeble)
	end
end

function CraftedItem:load()
	PropView.load(self)

	self.itemGreebles = {}
	self.particleGreebles = {}

	self.isDespawning = false
	self.currentState = STATE_NONE

	self.inputState = {}
	self.outputState = {}
end

function CraftedItem:_updateLoad()
	local isDespawning = self:getProp():getState().despawning
	if self.isDespawning ~= isDespawning then
		self.isDespawning = isDespawning

		if self.isDespawning then
			local inputIDs = self:getProp():getState().inputs or { "GoldBar", "GoldBar", "GoldBar", "Goldbar", "Ruby" }
			self:_loadItemGreebles(inputIDs, true)

			self:getResources():queueEvent(function()
				self:getResources():queueEvent(function()
					self.currentState = STATE_INPUTS
				end)
			end)
		end
	end
end

function CraftedItem:_updateState(s, delta, duration)
	local halfDuration = duration / 2
	local previousInputTime = s.time

	s.time = math.max((s.time or duration) - delta, 0)

	if s.time <= 0 then
		return true
	elseif s.time <= halfDuration then
		if previousInputTime > halfDuration then
			for _, greeble in ipairs(self.particleGreebles) do
				self:getResources():queueEvent(function()
					greeble:getParticles():emit(self.INITIAL_DUST_PARTICLES)
				end)
			end
		end

		self.dustInterval = math.max((self.dustInterval or self.DUST_INTERVAL) - delta, 0)
		if self.dustInterval <= 0 then
			self.dustInterval = self.DUST_INTERVAL
			for _, greeble in ipairs(self.particleGreebles) do
				self:getResources():queueEvent(function()
					greeble:getParticles():emit(love.math.random(self.MIN_DUST_PARTICLES, self.MAX_DUST_PARTICLES))
				end)
			end
		end
	end

	return false
end

function CraftedItem:update(delta)
	PropView.update(self, delta)

	self:_updateLoad()

	if self.currentState == STATE_INPUTS then
		if self:_updateState(self.inputState, delta, self.DURATION_SHOW_INPUT_ITEMS_SECONDS) then
			for _, greeble in ipairs(self.itemGreebles) do
				self:removeGreeble(greeble)
			end

			table.clear(self.itemGreebles)
			table.clear(self.particleGreebles)

			local outputIDs = self:getProp():getState().outputs or { "AmuletOfYendor" }
			self:_loadItemGreebles(outputIDs)

			self.currentState = STATE_OUTPUTS
		end
	elseif self.currentState == STATE_OUTPUTS then
		if self:_updateState(self.outputState, delta, self.DURATION_SHOW_OUTPUT_ITEMS_SECONDS) then
			self:clearGreebles()

			if (_DEBUG or self:getIsEditor()) and not self:getProp():getState().despawning then
				self.isDespawning = false
				self:_updateLoad()
			end
		end
	end
end

return CraftedItem
