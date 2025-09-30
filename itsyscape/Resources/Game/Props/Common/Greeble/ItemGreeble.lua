--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Greeble/ItemGreeble.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local Greeble = require "Resources.Game.Props.Common.Greeble"

local ItemGreeble = Class(Greeble)

ItemGreeble.ID = "Null"

ItemGreeble.BAG_COLOR = Color.fromHexString("76492b")

ItemGreeble.DROP_IN_DURATION_SECONDS = 0.25
ItemGreeble.DROP_IN_OFFSET           = Vector(0, 0.5, 0):keep()

ItemGreeble.BAG_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/SpecularTriplanar",
	texture = "Resources/Game/Items/ItemBagTexture.png",

	uniforms = {
		scape_TriplanarScale = { "float", 0 },
		scape_TriplanarExponent = { "float", 0 },
		scape_TriplanarOffset = { "float", 0 },
		scape_SpecularWeight = { "float", 0 },
	},

	properties = {
		outlineThreshold = -0.01,
		color = "76492b"
	}
})

ItemGreeble.STRING_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/Decoration",
	texture = "Resources/Game/Items/ItemBagStringTexture.png",

	properties = {
		outlineThreshold = 0.5
	}
})

ItemGreeble.ICON_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/Decoration",
	texture = false,

	properties = {
		outlineThreshold = 0.5
	}
})

function ItemGreeble:load()
	Greeble.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local item = SceneNode()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Items/ItemBag.lstatic",
		function(mesh)
			self.mesh = mesh
		end)

	resources:queueEvent(function()
		local lootBag = DecorationSceneNode()
		lootBag:fromGroup(self.mesh, "bag")

		self.BAG_MATERIAL:replace(DecorationMaterial({
			properties = {
				color = { self.BAG_COLOR:get() }
			}
		})):apply(lootBag, self:getResources())
		lootBag:setParent(item)

		if self.lootBag then
			self.lootBag:setParent()
		end

		self.lootBag = lootBag
		self.lootBag:getMaterial():setAlpha(0)
	end)

	resources:queueEvent(function()
		local lootString = DecorationSceneNode()
		lootString:fromGroup(self.mesh, "string")

		self.STRING_MATERIAL:apply(lootString, self:getResources())
		lootString:setParent(item)

		if self.lootString then
			self.lootString:setParent()
		end

		self.lootString = lootString
		self.lootString:getMaterial():setAlpha(0)
	end)

	resources:queueEvent(function()
		local lootIcon = DecorationSceneNode()
		lootIcon:fromGroup(self.mesh, "icon")

		local iconFilename = string.format("Resources/Game/Items/%s/Icon.png", self.ID)
		if not love.filesystem.getInfo(iconFilename) then
			iconFilename = "Resources/Game/Items/Null/Icon.png"
		end

		self.ICON_MATERIAL:replace(DecorationMaterial({
			texture = iconFilename
		})):apply(lootIcon, self:getResources())
		lootIcon:setParent(item)

		if self.lootIcon then
			self.lootIcon:setParent()
		end

		self.lootIcon = lootIcon
		self.lootIcon:getMaterial():setAlpha(0)
	end)

	resources:queueEvent(function()
		self:getResources():queueEvent(function()
			if self.item then
				self.item:setParent()
			end

			item:setParent(root)
			self.item = item

			self.dropInDuration = self.DROP_IN_DURATION_SECONDS
			self:_updateDrop(0)
		end)
	end)
end


function ItemGreeble:regreebilize(t, ...)
	Greeble.regreebilize(self, t, ...)

	self:load()
end

function ItemGreeble:_updateDrop(delta)
	self.dropInDuration = math.max((self.dropInDuration or 0) - delta, 0)

	local alpha
	if self.DROP_IN_DURATION_SECONDS <= 0 then
		alpha = 1
	else
		alpha = Tween.sineEaseOut(1 - math.clamp(self.dropInDuration / self.DROP_IN_DURATION_SECONDS))
	end

	if self.lootBag then
		self.lootBag:getMaterial():setAlpha(alpha)
	end

	if self.lootString then
		self.lootString:getMaterial():setAlpha(alpha)
	end

	if self.lootIcon then
		self.lootIcon:getMaterial():setAlpha(alpha)
	end

	if self.item then
		self.item:getTransform():setLocalTranslation(self.DROP_IN_OFFSET:lerp(Vector.ZERO, alpha))
		self.item:tick()
	end
end

function ItemGreeble:update(delta)
	Greeble.update(self, delta)

	self:_updateDrop(delta)
end

return ItemGreeble
