--------------------------------------------------------------------------------
-- Resources/Game/Props/Coffin_Plain /View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Coffin = Class(SimpleStaticView)

function Coffin:getTextureFilename()
	return "Resources/Game/Props/Coffin_Plain1/Texture.png"
end

function Coffin:getModelFilename()
	return "Resources/Game/Props/Coffin_Plain1/Model.lmesh", "Coffin"
end

return Coffin
