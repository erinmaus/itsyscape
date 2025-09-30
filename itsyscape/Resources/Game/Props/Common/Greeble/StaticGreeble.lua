--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Greeble/StaticGreeble.lua
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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local Greeble = require "Resources.Game.Props.Common.Greeble"

local StaticGreeble = Class(Greeble)

StaticGreeble.MESH = ""
StaticGreeble.GROUP = ""
StaticGreeble.MATERIAL = DecorationMaterial({})

function StaticGreeble:new(prop, gameView)
	Greeble.new(self, prop, gameView)
end

function StaticGreeble:load()
	Greeble.load(self)

	if self.MESH == "" or self.GROUP == "" then
		return
	end

	local resources = self:getResources()
	local root = self:getRoot()

	local mesh
	resources:queue(
		StaticMeshResource,
		self.MESH,
		function(m)
			mesh = m
		end)

	resources:queueEvent(function()
		local decoration = DecorationSceneNode()
		decoration:fromGroup(mesh:getResource(), self.GROUP)
		self.MATERIAL:apply(decoration, self:getResources())

		decoration:setParent(root)

		if self.decoration then
			self.decoration:setParent()
		end

		self.decoration = decoration
	end)
end

function StaticGreeble:regreebilize(t, ...)
	Greeble.regreebilize(self, t, ...)

	self:load()
end

return StaticGreeble
