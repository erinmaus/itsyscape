--------------------------------------------------------------------------------
-- ItsyScape/UI/CharacterCustomizationController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"

local CharacterCustomizationController = Class(Controller)
local MODEL_SKIN = "ItsyScape.Game.Skin.ModelSkin"
local PRONOUN_INDEX = {
	subject = GenderBehavior.PRONOUN_SUBJECT,
	object = GenderBehavior.PRONOUN_OBJECT,
	possessive = GenderBehavior.PRONOUN_POSSESSIVE,
	formal = GenderBehavior.FORMAL_ADDRESS
}
local SKINS = {
	hair = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_ACCENT,
		{ name = "NB", t = MODEL_SKIN, filename = "PlayerKit1/Hair/Enby.lua" },
		{ name = "Fade", t = MODEL_SKIN, filename = "PlayerKit1/Hair/Fade.lua" },
		{ name = "Afro", t = MODEL_SKIN, filename = "PlayerKit1/Hair/Afro.lua" },
		{ name = "Emo", t = MODEL_SKIN, filename = "PlayerKit1/Hair/Emo.lua" },
		{ name = "Pixie", t = MODEL_SKIN, filename = "PlayerKit1/Hair/Pixie.lua" },
		{ name = "Long curve", t = MODEL_SKIN, filename = "PlayerKit1/Hair/LongCurve.lua" },
		{ name = "Red bow", t = MODEL_SKIN, filename = "PlayerKit1/Hair/RedBow.lua" },
		{ name = "Zombi punk", t = MODEL_SKIN, filename = "PlayerKit1/Hair/ZombiPunk.lua" },
		{ name = "Forward swirl", t = MODEL_SKIN, filename = "PlayerKit1/Hair/ForwardSwirl.lua" },
		{ name = "Forward spike", t = MODEL_SKIN, filename = "PlayerKit1/Hair/ForwardSpike.lua" },
		{ name = "Slick pokey", t = MODEL_SKIN, filename = "PlayerKit1/Hair/SlickPokey.lua" },
		{ name = "Black braid", t = MODEL_SKIN, filename = "PlayerKit1/Hair/BlackBraid.lua" },
		{ name = "Dark red braid", t = MODEL_SKIN, filename = "PlayerKit1/Hair/DarkRedBraid.lua" },
		{ name = "Curly", t = MODEL_SKIN, filename = "PlayerKit1/Hair/Curly.lua" },
		{ name = "Bald", t = false, filename = "PlayerKit1/Hair/Bald.lua" },
		{ name = "Dragon horns (black)", t = MODEL_SKIN, filename = "PlayerKit1/Hair/Haru.lua", player = "Haru" }
	},

	eyes = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = math.huge,
		{ name = "Runic", t = MODEL_SKIN, filename = "PlayerKit1/Eyes/Eyes.lua" },
		{ name = "Grey", t = MODEL_SKIN, filename = "PlayerKit1/Eyes/Eyes_Grey.lua" },
		{ name = "Red", t = MODEL_SKIN, filename = "PlayerKit1/Eyes/Eyes_Red.lua" },
		{ name = "Dark Red", t = MODEL_SKIN, filename = "PlayerKit1/Eyes/Eyes_DarkRed.lua" },
		{ name = "Green", t = MODEL_SKIN, filename = "PlayerKit1/Eyes/Eyes_Green.lua" },
		{ name = "Brown", t = MODEL_SKIN, filename = "PlayerKit1/Eyes/Eyes_Brown.lua" },
		{ name = "Undead", t = MODEL_SKIN, filename = "PlayerKit1/Eyes/WhiteEyes_Green.lua" },
		{ name = "Undead (Pink)", t = MODEL_SKIN, filename = "PlayerKit1/Eyes/WhiteEyes_Pink.lua" }
	},

	head = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Light", t = MODEL_SKIN, filename = "PlayerKit1/Head/Light.lua" },
		{ name = "Medium", t = MODEL_SKIN, filename = "PlayerKit1/Head/Medium.lua" },
		{ name = "Dark", t = MODEL_SKIN, filename = "PlayerKit1/Head/Dark.lua" },
		{ name = "Fig", t = MODEL_SKIN, filename = "PlayerKit1/Head/Minifig.lua" },
		{ name = "Undead", t = MODEL_SKIN, filename = "PlayerKit1/Head/Zombi.lua" },
		{ name = "Undead (Fungal)", t = MODEL_SKIN, filename = "PlayerKit1/Head/Fungal.lua" },
		{ name = "Undead (Nymph)", t = MODEL_SKIN, filename = "PlayerKit1/Head/Nymph.lua" },
		{ name = "Unreal", t = MODEL_SKIN, filename = "PlayerKit1/Head/Unreal.lua" }
	},

	body = {
		slot = Equipment.PLAYER_SLOT_BODY,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Red", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Red.lua" },
		{ name = "Green", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Green.lua" },
		{ name = "Blue", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Blue.lua" },
		{ name = "Yellow", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Yellow.lua" },
		{ name = "White", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/White.lua" },
		{ name = "Pale brown", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/PaleBrown.lua" },
		{ name = "Red dress", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/RedDress.lua" },
		{ name = "Green dress", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/GreenDress.lua" },
		{ name = "Blue dress", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/BlueDress.lua" },
		{ name = "Yellow dress", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/YellowDress.lua" },
		{ name = "Brown cross stitch", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/BrownCrossStitch.lua" },
		{ name = "Grey suit", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/BankerSuit.lua" },
		{ name = "Lumberjack Red plaid", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/RedPlaid.lua" },
		{ name = "Fisherman green plaid", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/GreenPlaid.lua" },
		{ name = "Farmer green plaid", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/BluePlaid.lua" },
		{ name = "Seafarer's garb", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/SeafarerGarb.lua" },
		{ name = "Prestigious sailor's dress", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/PrestigiousSailorsDress.lua" },
		{ name = "Scallywag (yellow)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Scallywag_Yellow.lua" },
		{ name = "Scallywag (blue)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Scallywag_Blue.lua" },
		{ name = "Scallywag (pink)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Scallywag_Pink.lua" },
		{ name = "Scallywag (purple)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Scallywag_Purple.lua" },
		{ name = "Cannoneer (blue)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Cannoneer_Blue.lua" },
		{ name = "Cannoneer (green)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Cannoneer_Green.lua" },
		{ name = "Cannoneer (orange)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Cannoneer_Orange.lua" },
		{ name = "Cannoneer (purple)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Cannoneer_Purple.lua" },
		{ name = "Navigator (blue)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Navigator_Blue.lua" },
		{ name = "Navigator (green)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Navigator_Green.lua" },
		{ name = "Navigator (purple)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Navigator_Purple.lua" },
		{ name = "Navigator (red)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Navigator_Red.lua" },
		{ name = "Lab coat", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/LabCoat.lua" },
		{ name = "Dragon wings (black)", t = MODEL_SKIN, filename = "PlayerKit1/Shirts/Haru.lua", player = "Haru" },
	},

	hands = {
		slot = Equipment.PLAYER_SLOT_HANDS,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Red gloves", t = MODEL_SKIN, filename = "PlayerKit1/Hands/RedGloves.lua" },
		{ name = "Green gloves", t = MODEL_SKIN, filename = "PlayerKit1/Hands/GreenGloves.lua" },
		{ name = "Blue gloves", t = MODEL_SKIN, filename = "PlayerKit1/Hands/BlueGloves.lua" },
		{ name = "Gold gloves", t = MODEL_SKIN, filename = "PlayerKit1/Hands/GoldGloves.lua" },
		{ name = "Purple gloves", t = MODEL_SKIN, filename = "PlayerKit1/Hands/PurpleGloves.lua" },
		{ name = "Black gloves", t = MODEL_SKIN, filename = "PlayerKit1/Hands/BlackGloves.lua" },
		{ name = "Pink rose gloves", t = MODEL_SKIN, filename = "PlayerKit1/Hands/PinkRoseGloves.lua" },
		{ name = "Seafarer's gloves", t = MODEL_SKIN, filename = "PlayerKit1/Hands/SeafarerGloves.lua" },
		{ name = "Light", t = MODEL_SKIN, filename = "PlayerKit1/Hands/Light.lua" },
		{ name = "Medium", t = MODEL_SKIN, filename = "PlayerKit1/Hands/Medium.lua" },
		{ name = "Dark", t = MODEL_SKIN, filename = "PlayerKit1/Hands/Dark.lua" },
		{ name = "Fig", t = MODEL_SKIN, filename = "PlayerKit1/Hands/Minifig.lua" },
		{ name = "Undead", t = MODEL_SKIN, filename = "PlayerKit1/Hands/Zombi.lua" },
		{ name = "Undead (Fungal)", t = MODEL_SKIN, filename = "PlayerKit1/Hands/Fungal.lua" },
		{ name = "Unreal", t = MODEL_SKIN, filename = "PlayerKit1/Hands/Unreal.lua" }
	},

	feet = {
		slot = Equipment.PLAYER_SLOT_FEET,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Rugged boots", t = MODEL_SKIN, filename = "PlayerKit1/Shoes/Boots1.lua" },
		{ name = "Worn boots", t = MODEL_SKIN, filename = "PlayerKit1/Shoes/Boots2.lua" },
		{ name = "Fancy shoes", t = MODEL_SKIN, filename = "PlayerKit1/Shoes/FancyShoes1.lua" },
		{ name = "Sailor's boots", t = MODEL_SKIN, filename = "PlayerKit1/Shoes/Boots3.lua" },
		{ name = "Red sailor's boots", t = MODEL_SKIN, filename = "PlayerKit1/Shoes/Boots3_Red.lua" },
		{ name = "Seafarer's boots", t = MODEL_SKIN, filename = "PlayerKit1/Shoes/Boots_Seafarer1.lua" },
		{ name = "Navy-blue seafarer's boots", t = MODEL_SKIN, filename = "PlayerKit1/Shoes/Boots_Seafarer2.lua" }
	}
}

function CharacterCustomizationController:new(peep, director)
	Controller.new(self, peep, director)
end

function CharacterCustomizationController:poke(actionID, actionIndex, e)
	if actionID == "previousWardrobe" then
		self:previousWardrobe(e)
	elseif actionID == "nextWardrobe" then
		self:nextWardrobe(e)
	elseif actionID == "changeGender" then
		self:changeGender(e)
	elseif actionID == "changeGenderDescription" then
		self:changeGenderDescription(e)
	elseif actionID == "changePronoun" then
		self:changePronoun(e)
	elseif actionID == "changePronounPlurality" then
		self:changePronounPlurality(e)
	elseif actionID == "changeName" then
		self:changeName(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CharacterCustomizationController:getSkinStorage()
	local director = self:getDirector()
	local storage = director:getPlayerStorage(self:getPeep())
	local skin = storage:getRoot():getSection("Player"):getSection("Skin")
	return skin
end

function CharacterCustomizationController:getIndex(slot)
	local skin = self:getSkinStorage()
	local slotSection = skin:getSection(slot)
	if not slotSection:get("filename") then
		return 0
	end

	local filename = slotSection:get("filename")
	for i = 1, #SKINS[slot] do
		local f = "Resources/Game/Skins/" .. SKINS[slot][i].filename
		if f == filename then
			return i
		end
	end

	return 0
end

function CharacterCustomizationController:changeWardrobe(slot, index)
	s = SKINS[slot]

	local filename
	if s[index].filename then
		filename = "Resources/Game/Skins/" .. s[index].filename
	else
		filename = false
	end

	self.peep:poke('changeWardrobe', {
		slot = s.slot,
		slotName = slot,
		priority = s.priority,
		name = s[index].name,
		type = s[index].t,
		filename = filename
	})

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"changeSlot",
		nil,
		{ slot, s[index].name })
end

function CharacterCustomizationController:previousWardrobe(e)
	local skin = self:getSkinStorage():getSection(e.slot)
	local index = self:getIndex(e.slot) - 1
	if index < 0 then
		index = #SKINS[e.slot]
	end

	index = (index - 1) % #SKINS[e.slot] + 1
	self:changeWardrobe(e.slot, index)

	local playerName = self:pull().name or "Player"
	local slotName = SKINS[e.slot][index].player
	if slotName and slotName:lower() ~= playerName:lower() then
		self:previousWardrobe(e)
	end
end

function CharacterCustomizationController:nextWardrobe(e)
	local skin = self:getSkinStorage():getSection(e.slot)
	local index = self:getIndex(e.slot) + 1
	if index > #SKINS[e.slot] then
		index = 1
	end

	self:changeWardrobe(e.slot, index)

	local playerName = self:pull().name or "Player"
	local slotName = SKINS[e.slot][index].player
	if slotName and slotName:lower() ~= playerName:lower() then
		self:nextWardrobe(e)
	end
end

function CharacterCustomizationController:changeName(e)
	self:getPeep():poke('rename', { name = e.name })
end

function CharacterCustomizationController:changeGender(e)
	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		if e.gender == GenderBehavior.GENDER_MALE or
		   e.gender == GenderBehavior.GENDER_FEMALE or
		   e.gender == GenderBehavior.GENDER_OTHER
		then
			gender.gender = e.gender

			if e.gender == GenderBehavior.GENDER_MALE then
				gender.pronouns = {
					'he',
					'him',
					'his',
					'ser'
				}
				gender.description = 'Male'
				gender.pronounsPlural = false
			elseif e.gender == GenderBehavior.GENDER_FEMALE then
				gender.pronouns = {
					'she',
					'her',
					'hers',
					'misse'
				}
				gender.description = 'Female'
				gender.pronounsPlural = false
			elseif e.gender == GenderBehavior.GENDER_OTHER then
				gender.pronouns = {
					'they',
					'them',
					'their',
					'mazer'
				}
				gender.description = 'Non-Binary'
				gender.pronounsPlural = true
			end
		end

		gender:unload(peep)
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateGender",
		nil,
		{ self:pull() })
end

function CharacterCustomizationController:changeGenderDescription(e)
	assert(type(e.description) == 'string', "description must be string")

	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		gender.description = e.description

		gender:unload(peep)
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateGender",
		nil,
		{ self:pull() })
end

function CharacterCustomizationController:changePronoun(e)
	assert(type(e.index) == 'string', "index must be string")
	assert(type(e.value) == 'string', "value must be string")

	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		local pronounIndex = PRONOUN_INDEX[e.index]
		assert(pronounIndex ~= nil, "pronoun index must be valid")

		gender.pronouns[pronounIndex] = e.value

		gender:unload(peep)
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateGender",
		nil,
		{ self:pull() })
end

function CharacterCustomizationController:changePronounPlurality(e)
	assert(type(e.value) == 'boolean', "value must be boolean")

	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		gender.pronounsPlural = e.value
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateGender",
		nil,
		{ self:pull() })
end

function CharacterCustomizationController:pull()
	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)

	local storage = self:getDirector():getPlayerStorage(peep)

	return {
		name = storage:getRoot():getSection("Player"):getSection("Info"):get("name"),
		gender = gender.gender,
		description = gender.description or "Non-Binary",
		pronouns = {
			subject = gender.pronouns[GenderBehavior.PRONOUN_SUBJECT],
			object = gender.pronouns[GenderBehavior.PRONOUN_OBJECT],
			possessive = gender.pronouns[GenderBehavior.PRONOUN_POSSESSIVE],
			formal = gender.pronouns[GenderBehavior.FORMAL_ADDRESS],
			plural = gender.pronounsPlural
		}
	}
end

return CharacterCustomizationController
