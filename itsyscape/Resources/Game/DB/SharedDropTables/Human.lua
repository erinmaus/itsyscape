--------------------------------------------------------------------------------
-- Resources/Game/DB/SharedDropTables/Human.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local SecondaryDropTable = ItsyScape.Resource.DropTable "Human_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}
end