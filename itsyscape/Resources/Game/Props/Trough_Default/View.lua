--------------------------------------------------------------------------------
-- Resources/Game/Props/Trough_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Trough = Class(SimpleStaticView)

function Trough:getTextureFilename()
	return "Resources/Game/Props/Trough_Default/Texture.png"
end

function Trough:getModelFilename()
	return "Resources/Game/Props/Trough_Default/Model.lstatic", "Trough"
end

return Trough
