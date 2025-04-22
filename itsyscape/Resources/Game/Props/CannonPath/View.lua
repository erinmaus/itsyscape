--------------------------------------------------------------------------------
-- Resources/Game/Props/CannonPath/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"

local CannonPathView = Class(PropView)

function CannonPathView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.lightBeamSceneNode = LightBeamSceneNode()
	self.lightBeamSceneNode:setBeamSize(0.5)
	self.lightBeamSceneNode:getMaterial():setColor(Color.fromHexString("ffcc00"))
	self.lightBeamSceneNode:getMaterial():setIsFullLit(true)
	self.lightBeamSceneNode:getMaterial():setIsShadowCaster(false)
end

function CannonPathView:remove()
	PropView.remove(self)

	self.lightBeamSceneNode:setParent(nil)
end

function CannonPathView:load()
	PropView.load(self)
end

function CannonPathView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	self.lightBeamSceneNode:buildSeamless(state.path or {})
	self.lightBeamSceneNode:setParent(self:getGameView():getScene())
end

return CannonPathView
