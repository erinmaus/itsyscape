--------------------------------------------------------------------------------
-- ItsyScape/Game/Body.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Skeleton = require "ItsyScape.Graphics.Skeleton"

-- Represents the constant physical characteristics of an NPC, player, etc.
local Body = Class()

function Body:new()
	self.skeleton = Skeleton.EMPTY
end

-- TODO actually load a Body instead of a Skeleton (lskel) but ok
function Body.loadFromFile(filename)
	local body = Body()
	body.skeleton = Skeleton(filename)

	return body
end

-- Gets the skeleton, or an empty skeleton if none loaded.
function Body:getSkeleton()
	return self.skeleton
end

return Body
