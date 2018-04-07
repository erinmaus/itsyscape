--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Camera.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Camera = Class()

-- Constructs the camera.
function Camera:new()
	-- Nothing.
end

-- Applies the camera.
function Camera:apply()
	Class.ABSTRACT()
end

return Camera
