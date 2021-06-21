--------------------------------------------------------------------------------
-- Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Pillar/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local TransitionView = require "Resources.Game.Props.Common.TransitionView"
local InactiveView = require "Resources.Game.Props.MysteriousMachinations_MysteriousRuins_Pillar.View_Inactive"
local ActiveView = require "Resources.Game.Props.MysteriousMachinations_MysteriousRuins_Pillar.View_Active"

local Pillar = Class(TransitionView)
Pillar.TIME = 1.5

function Pillar:instantiateInactiveView(prop, gameView)
	return InactiveView(prop, gameView)
end

function Pillar:instantiateActiveView(prop, gameView)
	return ActiveView(prop, gameView)
end

function Pillar:getIsActive()
	local state = self:getProp():getState()
	return state.isActive == true
end

function TransitionView:updateActiveAlpha(propView, alpha)
	propView:getModelNode():getMaterial():setColor(Color(1, 1, 1, alpha))
end

function TransitionView:updateInactiveAlpha(propView, alpha)
	propView:getModelNode():getMaterial():setColor(Color(1, 1, 1, alpha))
end

return Pillar
