--------------------------------------------------------------------------------
-- Resources/Game/Props/Rug_Isabelle/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"

local Rug = Class(SimpleStaticView)

Rug.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Rug_Isabelle/Model.lstatic",
		group = "rug",

		material = {
			shader = "Resources/Shaders/SpecularStaticModel",
			texture = "Resources/Game/Props/Rug_Isabelle/Texture.png",

			properties = {
				outlineThreshold = 0.5
			}
		}
	}
}

return Rug
