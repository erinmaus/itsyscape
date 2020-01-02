--------------------------------------------------------------------------------
-- Resources/Game/Props/Loo_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Loo = Class(SimpleStaticView)

function Loo:getTextureFilename()
	return "Resources/Game/Props/Loo_Default/Texture.png"
end

function Loo:getModelFilename()
	return "Resources/Game/Props/Loo_Default/Model.lstatic", "Loo"
end

return Loo
