--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/SimpleStaticView2.lua
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
local PropView = require "ItsyScape.Graphics.PropView"
local Resource = require "ItsyScape.Graphics.Resource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local SimpleStaticView = Class(PropView)

SimpleStaticView.DESCRIPTION = {}

SimpleStaticView.GREEBLE = {}

function SimpleStaticView:new(...)
	PropView.new(self, ...)

	for _, greeble in ipairs(self.GREEBLE) do
		local g = self:addGreeble(greeble.type, greeble.config)
		if greeble.transform then
			if greeble.transform.translation then
				g:getRoot():getTransform():setLocalTranslation(greeble.transform.translation)
			end

			if greeble.transform.offset then
				g:getRoot():getTransform():setLocalOffset(greeble.transform.offset)
			end

			if greeble.transform.rotation then
				g:getRoot():getTransform():setLocalRotation(greeble.transform.rotation)
			end

			if greeble.transform.scale then
				g:getRoot():getTransform():setLocalOffset(greeble.transform.scale)
			end
		end
	end
end

function SimpleStaticView:getDescription()
	return self.DESCRIPTION
end

function SimpleStaticView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local description = self:getDescription()

	for _, d in ipairs(description) do
		local mesh
		resources:queue(
			StaticMeshResource,
			d.mesh,
			function(m)
				mesh = m
			end)

		local material
		resources:queueEvent(function()
			if Class.isCompatibleType(d.material, DecorationMaterial) then
				material = d.material
			elseif type(d.material) == "string" then
				local m = Resource.readLua(material)
				material = DecorationMaterial(m)
			else
				material = DecorationMaterial(d.material or {})
			end
		end)

		resources:queueEvent(function()
			local decoration = DecorationSceneNode()
			decoration:fromGroup(mesh:getResource(), d.group)
			material:apply(decoration, self:getResources())

			decoration:setParent(root)
		end)
	end
end

return SimpleStaticView
