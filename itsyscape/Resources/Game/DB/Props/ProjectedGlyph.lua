--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/ProjectedGlyph.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local ProjectedGlyph = ItsyScape.Resource.Prop "ProjectedGlyph"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.ProjectedGlyph",
		Resource = ProjectedGlyph
	}
end

do
	local Glyph = ItsyScape.Resource.Prop "Glyph"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.ProjectedGlyph",
		Resource = Glyph
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1,
		SizeY = 1,
		SizeZ = 0,
		MapObject = Glyph
	}
end
