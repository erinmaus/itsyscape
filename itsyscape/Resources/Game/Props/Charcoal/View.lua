--------------------------------------------------------------------------------
-- Resources/Game/Props/Charcoal/View.lua
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
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Charcoal = Class(SimpleStaticView)

function Charcoal:getTextureFilename()
	return "Resources/Game/Props/Charcoal/Texture.png"
end

function Charcoal:getModelFilename()
	return "Resources/Game/Props/Charcoal/Model.lstatic", "Charcoal"
end

function Charcoal:load()
	SimpleStaticView.load(self)

	local decoration = self:getModelNode()
	decoration:getMaterial():setColor(Color(0.2, 0.2, 0.2))
end

return Charcoal
