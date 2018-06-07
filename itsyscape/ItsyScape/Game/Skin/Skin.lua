--------------------------------------------------------------------------------
-- ItsyScape/Game/Skin/Skin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Skin = Class()

function Skin:new()
	-- Nothing.
end

-- Whether or not the skin is blocking or not.
--
-- A blocking skin hides all other skins.
--
-- Imagine a full helmet and a cliche wizard hat. The full helmet blocks the
-- underlying head skin, while a wizard hat adds to it.
function Skin:getIsBlocking()
	return true
end

return Skin
