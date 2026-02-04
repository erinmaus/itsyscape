--------------------------------------------------------------------------------
-- Resources/Game/Props/GoredDragonIntestines/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Intestines = Class(PropView)

function Intestines:new(...)
	PropView.new(self, ...)

	self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/GoredDragonIntestines/Model.lstatic",
		GROUP = "organ"	,
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/GoredDragonOrgans",
			texture = "Resources/Game/Props/GoredDragonIntestines/Texture.png",

			uniforms = {
				scape_NumCurves = { "integer", 0 }
			}
		})
	})
end

return Intestines
