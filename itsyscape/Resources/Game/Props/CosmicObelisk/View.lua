--------------------------------------------------------------------------------
-- Resources/Game/Props/CosmicObelisk/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local CosmicObelisk = Class(SimpleStaticView)

function CosmicObelisk:getTextureFilename()
	return "Resources/Game/Props/CosmicObelisk/Texture.png"
end

function CosmicObelisk:getModelFilename()
	return "Resources/Game/Props/CosmicObelisk/Model.lmesh", "Obelisk"
end

return CosmicObelisk
