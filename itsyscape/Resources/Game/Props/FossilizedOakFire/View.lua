--------------------------------------------------------------------------------
-- Resources/Game/Props/FossilizedOakFire/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FireView = require "Resources.Game.Props.Common.FireView"

local FossilizedOak = Class(FireView)

function FossilizedOak:getTextureFilename()
	return "Resources/Game/Props/FossilizedOakFire/Texture.png"
end

return FossilizedOak
