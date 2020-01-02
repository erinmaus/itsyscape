--------------------------------------------------------------------------------
-- Resources/Game/Props/BathroomSink_Default/View.lua
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

local Sink = Class(SimpleStaticView)

function Sink:getTextureFilename()
	return "Resources/Game/Props/BathroomSink_Default/Texture.png"
end

function Sink:getModelFilename()
	return "Resources/Game/Props/BathroomSink_Default/Model.lstatic", "BathroomSink"
end

return Sink
