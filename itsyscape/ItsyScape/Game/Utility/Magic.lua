--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Magic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Magic = {}
function Magic.newSpell(id, game)
	local TypeName = string.format("Resources.Game.Spells.%s.Spell", id)
	local Type = require(TypeName)

	return Type(id, game)
end

return Magic
