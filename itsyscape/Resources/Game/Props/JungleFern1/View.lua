--------------------------------------------------------------------------------
-- Resources/Game/Props/JungleFern1/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FernView = require "Resources.Game.Props.Common.FernView"

local JungleFern = Class(FernView)

function JungleFern:getBaseFilename()
	return "Resources/Game/Props/JungleFern1"
end

return JungleFern
