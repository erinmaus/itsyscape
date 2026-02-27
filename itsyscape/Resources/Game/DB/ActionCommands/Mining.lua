------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/Woodcutting.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Mining1 = ItsyScape.Resource.ActionCommand "Mine1"

	ItsyScape.Meta.ActionCommandMap {
		Map = ItsyScape.Resource.Map "Skilling_Woodcutting1",
		Resource = Mining1
	}
end