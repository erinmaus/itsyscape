--------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/FishAncientKaradon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Fish1 = require "Resources.Game.ActionCommands.Fish1"

FishAncientKaradon = Class(Fish1)
FishAncientKaradon.MAP = "Skilling_FishingAncientKaradon"
FishAncientKaradon.FISH_OVERRIDE = "AncientKaradonGoldfish"

return FishAncientKaradon
