--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SpriteSkinRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local SkinRenderer = require "ItsyScape.Graphics.SkinRenderer"
local SpriteSkin = require "ItsyScape.Game.SpriteSkin"

local SpriteSkinRenderer = SkinRenderer.Definition(SpriteSkin)

function SpriteSkinRenderer:new(skin)
	SkinRenderer.new(self, skin)

	self.quad = 
end