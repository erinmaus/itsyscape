--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/GenderBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the gender of a Peep.
local GenderBehavior = Behavior("Gender")
GenderBehavior.PRONOUN_SUBJECT    = 1
GenderBehavior.PRONOUN_OBJECT     = 2
GenderBehavior.PRONOUN_POSSESSIVE = 3
GenderBehavior.FORMAL_ADDRESS     = 4
GenderBehavior.GENDER_MALE        = 'male'
GenderBehavior.GENDER_FEMALE      = 'female'
GenderBehavior.GENDER_OTHER       = 'x'

-- Constructs a GenderBehavior.
--
-- * gender: Gender of the Peep. Defaults to 'x'.
-- * pronouns: Pronouns of a Peep. Defaults to they/them/theirs/mazer.
function GenderBehavior:new()
	Behavior.Type.new(self)

	self.gender = "x"
	self.pronouns = {
		"they",
		"them",
		"theirs",
		"mazer"
	}
end

return GenderBehavior
