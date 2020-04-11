--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Channel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Channel = require "ItsyScape.Game.Animation.Channel"

local TargetChannel = Class(Channel)
function TargetChannel:new(t)
	Channel.new(self, t)
end

return TargetChannel
