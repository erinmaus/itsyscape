--------------------------------------------------------------------------------
-- Resources/Game/Peeps/PreTutorial/ZombiButler.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local BaseZombi = require "Resources.Game.Peeps.Zombi.BaseZombi"

local ZombiButler = Class(BaseZombi)
ZombiButler.AREAS = {
	['kitchen'] = {
		f = 1,
		{ i1 = 15, j1 = 4, i2 = 21, j2 = 8 }
	},
	['dining-room'] = {
		f = 1,
		{ i1 = 7, j1 = 4, i2 = 13, j2 = 11 }
	},
	['boys-room'] = {
		f = 1,
		{ i1 = 7, j1 = 13, i2 = 15, j2 = 17 }
	},
	['girls-room'] = {
		f = 1,
		{ i1 = 7, j1 = 22, i2 = 15, j2 = 26 }
	},
	['courtyard'] = {
		f = 1,
		{ i1 = 19, j1 = 12, i2 = 26, j2 = 19 }
	},
	['shed'] = {
		f = 1,
		{ i1 = 29, j1 = 11, i2 = 32, j2 = 16 }
	},
	['bathroom'] = {
		f = 1,
		{ i1 = 23, j1 = 4, i2 = 26, j2 = 8 },
	},
	['butler-quarters'] = {
		f = 2,
		{ i1 = 7, j1 = 23, i2 = 16, j2 = 26 },
	},
	['study'] = {
		f = 2,
		{ i1 = 7, j1 = 12, i2 = 15, j2 = 17 },
	},
	['library'] = {
		f = 2,
		{ i1 = 7, j1 = 4, i2 = 15, j2 = 10 }
	},
	['ballroom'] = {
		f = 2,
		{ i1 = 17, j1 = 4, i2 = 26, j2 = 10 }
	},
	['ocean'] = {
		f = -1,
		{ i1 = 1, j1 = 1, i2 = 32, j2 = 32 }
	}
}

function ZombiButler:new(resource, name, ...)
	BaseZombi.new(self, resource, name or 'ZombiButler', ...)

	self.floor = 1
end

function ZombiButler:ready(director, game)
	BaseZombi.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.stoppingForce = 0.5
	movement.maxSpeed = 7
	movement.maxAcceleration = 7
	movement.stoppingForce = 4

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/BankerSuit.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/FancyShoes1.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, 0, feet)
end

function ZombiButler:onFloorChange(floor)
	self.floor = floor
end

function ZombiButler:isIn(peep, areaName)
	local area = ZombiButler.AREAS[areaName]

	if not area or area.f ~= self.floor then
		return false
	end

	local tileI, tileJ = Utility.Peep.getTile(peep)
	for i = 1, #area do
		if tileI >= area[i].i1 and tileJ >= area[i].j1 and
		   tileI <= area[i].i2 and tileJ <= area[i].j2
		then
			return true
		end
	end

	return false
end

function ZombiButler:getCurrentTarget()
	return self.target
end

function ZombiButler:onFollowPlayer(player)
	self.target = player
	if player then
		self.targetLastI, self.targetLastJ = Utility.Peep.getTile(player)
		self.targetLastI = self.targetLastI - 1
		self.lastI, self.lastJ = Utility.Peep.getTile(self)
	end
end

function ZombiButler:giveHint(hint)
	Utility.Peep.talk(self, hint)
end

function ZombiButler:updateLocation(currentI, currentJ)
	if self:isIn(self, 'kitchen') and self.lastArea ~= 'kitchen' then
		self:giveHint("If you had something to cook, you could do so on the ranges in the corner.")
		self.lastArea = 'kitchen' 
	elseif self:isIn(self, 'dining-room') and self.lastArea ~= 'dining-room' then
		self:giveHint("Unfortunately, I cannot let you eat the food here.")
		self.lastArea = 'dining-room'
	elseif self:isIn(self, 'boys-room') and self.lastArea ~= 'boys-room' then
		self:giveHint("This is Edward's room. He seems awfully frightened.")
		self.lastArea = 'boys-room'
	elseif self:isIn(self, 'girls-room') and self.lastArea ~= 'girls-room' then
		self:giveHint("This is Elizabeth's room. Her ghostly stomach is rumbling.")
		self.lastArea = 'girls-room'
	elseif self:isIn(self, 'courtyard') and self.lastArea ~= 'courtyard' then
		self:giveHint("Such a friendly goldfish.")
		self.lastArea = 'courtyard'
	elseif self:isIn(self, 'shed') and self.lastArea ~= 'shed' then
		self:giveHint("Feel free to take the tools from the crate.")
		self.lastArea = 'shed'
	elseif self:isIn(self, 'butler-quarters') and self.lastArea ~= 'butler-quarters' then
		self:giveHint("I could use some sleep!")
		self.lastArea = 'butler-quarters'
	elseif self:isIn(self, 'study') and self.lastArea ~= 'study' then
		self:giveHint("The book on the table is probably useful, but my eyes are too gone to read it.")
		self.lastArea = 'study'
	elseif self:isIn(self, 'library') and self.lastArea ~= 'library' then
		self:giveHint("I don't think any of these books will help you.")
		self.lastArea = 'library'
	elseif self:isIn(self, 'ballroom') and self.lastArea ~= 'ballroom' then
		self:giveHint("The ballroom hasn't been used in more than a century.")
		self.lastArea = 'ballroom'
	end

	self.currentI = currentI
	self.currentJ = currentJ
end

function ZombiButler:update(director, game)
	BaseZombi.update(self, director, game)

	if self.target then
		local targetCurrentI, targetCurrentJ, k = Utility.Peep.getTile(self.target)
		if targetCurrentI ~= self.targetLastI or targetCurrentJ ~= self.targetLastJ then
			local isInBathroom = self:isIn(self.target, 'bathroom')
			if isInBathroom and self.lastArea ~= 'bathroom' then
				self.lastArea = 'bathroom'
				self:giveHint("Oh goodness me, I'll give you your privacy!")
			elseif not isInBathroom then
				Utility.Peep.walk(self, self.targetLastI, self.targetLastJ, k, math.huge, { asCloseAsPossible = true })
			end

			self.targetLastI = targetCurrentI
			self.targetLastJ = targetCurrentJ
		end

		local currentI, currentJ = Utility.Peep.getTile(self.target)
		if currentI ~= self.lastI or currentJ ~= self.lastJ then
			self:updateLocation(currentI, currentJ)
		end
	end
end

return ZombiButler
