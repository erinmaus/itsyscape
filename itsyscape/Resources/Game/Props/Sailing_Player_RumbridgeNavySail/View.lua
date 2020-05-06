--------------------------------------------------------------------------------
-- Resources/Game/Props/Sailing_Player_RumbridgeNavySail/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local NavySail = Class(SimpleStaticView)

function NavySail:getTextureFilename()
	return "Resources/Game/Props/Sailing_Player_RumbridgeNavySail/Texture.png"
end

function NavySail:getModelFilename()
	return "Resources/Game/Props/Sailing_Player_RumbridgeNavySail/Model.lstatic", "Sail"
end

return NavySail
