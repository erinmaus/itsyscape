--------------------------------------------------------------------------------
-- Resources/Game/Props/Coelacanth_Dead/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Coelacanth = Class(SimpleStaticView)

function Coelacanth:getTextureFilename()
	return "Resources/Game/Props/Coelacanth_Dead/Texture.png"
end

function Coelacanth:getModelFilename()
	return "Resources/Game/Props/Coelacanth_Dead/Model.lstatic", "DeadFish"
end

return Coelacanth
