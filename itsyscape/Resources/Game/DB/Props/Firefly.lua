--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Anvil.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Firefly = ItsyScape.Resource.Prop "Firefly_Default"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = Firefly
	}
end
