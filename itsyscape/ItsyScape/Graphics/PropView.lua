--------------------------------------------------------------------------------
-- ItsyScape/Graphics/PropView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local DebugCubeSceneNode = require "ItsyScape.Graphics.DebugCubeSceneNode"
local MapCurve = require "ItsyScape.World.MapCurve"

local PropView = Class()

function PropView:new(prop, gameView)
	self.prop = prop
	self.gameView = gameView

	self.sceneNode = SceneNode()
	self.ready = false
	self.didLoad = false

	self.greeble = {}
end

function PropView:updateGreebles(greebles, t)
	for _, greeble in ipairs(greebles or self.greeble) do
		greeble:regreebilize(t)
	end
end

function PropView:addGreeble(GreebleType, t, transform, ...)
	local greeble = GreebleType(self.prop, self.gameView)
	greeble:greebilize(self, t, ...)
	greeble:attach()

	if self.didLoad then
		greeble:load()
	end

	if self.ready then
		greeble:update(0)
	end

	table.insert(self.greeble, greeble)

	if transform then
		if transform.translation then
			greeble:getRoot():getTransform():setLocalTranslation(transform.translation)
		end

		if transform.offset then
			greeble:getRoot():getTransform():setLocalOffset(transform.offset)
		end

		if transform.rotation then
			greeble:getRoot():getTransform():setLocalRotation(transform.rotation)
		end

		if transform.scale then
			greeble:getRoot():getTransform():setLocalOffset(transform.scale)
		end
	end

	return greeble
end

function PropView:removeGreeble(greeble)
	local didRemove = false
	for i = #self.greeble, 1, -1 do
		if self.greeble[i] == greeble then
			local g = table.remove(self.greeble, i)
			g:remove()

			didRemove = true
		end
	end

	return didRemove
end

function PropView:clearGreebles()
	for _, greeble in ipairs(self.greeble) do
		greeble:remove()
	end

	table.clear(self.greeble)
end


function PropView:getIsEditor()
	return Class.isCompatibleType(_APP, require "ItsyScape.Editor.EditorApplication")
end

function PropView:getProp()
	return self.prop
end

function PropView:getGameView()
	return self.gameView
end

function PropView:getResources()
	if not self.resourceView or not self.resourceView:getIsPending() then
		local resourceManager = self.gameView:getResourceManager()
		self.resourceView = resourceManager:newView()
	end

	return self.resourceView
end

function PropView:getRoot()
	return self.sceneNode
end

function PropView:getIsStatic()
	return true
end

function PropView:load()
	self.didLoad = true

	for _, greeble in ipairs(self.greeble) do
		greeble:load()
	end
end

function PropView:attach()
	self.sceneNode:setParent(self.gameView:getScene())
	self:updateTransform()

	if _DEBUG == "plus" then
		local _cube = DebugCubeSceneNode()
		_cube:onWillRender(function()
			local min, max = self:getProp():getBounds()
			local size = max - min
			size = size / 2

			_cube:getTransform():setLocalScale(size)
		end)

		_cube:setParent(self.sceneNode)
	end
end

function PropView:updateTransform()
	local position, layer = self.prop:getPosition()
	local rotation = self.prop:getRotation()
	local scale = self.prop:getScale()

	local curves = self.gameView:getMapCurves(layer)
	if curves then
		position, rotation = MapCurve.transformAll(position, rotation, curves)
	end

	local transform = self.sceneNode:getTransform()
	transform:setLocalTranslation(position)
	transform:setLocalRotation(rotation)
	transform:setLocalScale(scale)

	if self:getIsStatic() and (not self.ready or not curves) then
		self:getRoot():tick()
	end

	local mapSceneNode = self.gameView:getMapSceneNode(layer)
	if mapSceneNode ~= self.sceneNode:getParent() then
		if mapSceneNode then
			self.sceneNode:setParent(mapSceneNode)
		else
			self.sceneNode:setParent(false)
		end
	end
end

function PropView:remove()
	self.sceneNode:setParent(nil)

	for _, greeble in ipairs(self.greeble) do
		greeble:remove()
	end
end

function PropView:update(delta)
	if not self.ready then
		self:updateTransform()

		for _, greeble in ipairs(self.greeble) do
			greeble:updateTransform()
		end

		self.ready = true
	end

	for _, greeble in ipairs(self.greeble) do
		greeble:update(delta)
	end
end

function PropView:tick()
	self:updateTransform()

	for _, greeble in ipairs(self.greeble) do
		greeble:tick()
	end
end

return PropView
