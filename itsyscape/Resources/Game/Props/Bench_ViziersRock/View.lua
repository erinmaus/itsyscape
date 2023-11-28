--------------------------------------------------------------------------------
-- Resources/Game/Props/Bench_ViziersRock/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Bench = Class(SimpleStaticView)

function Bench:getTextureFilename()
	return "Resources/Game/Props/Bench_ViziersRock/Texture.png"
end

function Bench:getModelFilename()
	return "Resources/Game/Props/Bench_ViziersRock/Model.lstatic", "Pew"
end

return Bench
