--------------------------------------------------------------------------------
-- Resources/Game/Props/Shelf_Isabelle/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BookshelfView = require "Resources.Game.Props.Common.BookshelfView"

local Bookshelf = Class(BookshelfView)

Bookshelf.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Shelf_Isabelle/Model.lstatic",
		group = "grain",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Shelf_Isabelle/Grain.png",

			properties = {
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Shelf_Isabelle/Model.lstatic",
		group = "solid",

		material = {
			shader = "Resources/Shaders/Solid",
			texture = false,

			properties = {
				color = "30231c",
				outlineThreshold = 0.5,
				isReflectiveOrRefractive = true
			},

			uniforms = {
				scape_Specular = { "float", 0.5 }
			}
		}
	}
}

return Bookshelf
