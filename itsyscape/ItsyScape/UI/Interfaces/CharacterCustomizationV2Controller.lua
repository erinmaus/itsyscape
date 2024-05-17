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
local Color = require "ItsyScape.Graphics.Color"
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
		{ name = "Enby", filename = "Resources/Game/Skins/PlayerKit2/Hair/Enby.lua" },
		{ name = "Fade", filename = "Resources/Game/Skins/PlayerKit2/Hair/Fade.lua" },
		{ name = "Afro", filename = "Resources/Game/Skins/PlayerKit2/Hair/Afro.lua" },
		{ name = "Emo", filename = "Resources/Game/Skins/PlayerKit2/Hair/Emo.lua" },
		{ name = "Bedhead", filename = "Resources/Game/Skins/PlayerKit2/Hair/Messy1.lua" },
		{ name = "Messy (mad scientist)", filename = "Resources/Game/Skins/PlayerKit2/Hair/Messy2.lua" },
		{ name = "Mid-life crisis messy", filename = "Resources/Game/Skins/PlayerKit2/Hair/MiddleAgeMessy.lua" },
		{ name = "Pixie", filename = "Resources/Game/Skins/PlayerKit2/Hair/Pixie.lua" },
		{ name = "Long curve", filename = "Resources/Game/Skins/PlayerKit2/Hair/LongCurve.lua" },
		{ name = "Bow", filename = "Resources/Game/Skins/PlayerKit2/Hair/Bow.lua" },
		{ name = "Fancy old", filename = "Resources/Game/Skins/PlayerKit2/Hair/FancyOld.lua" },
		{ name = "Zombi punk", filename = "Resources/Game/Skins/PlayerKit2/Hair/ZombiPunk.lua" },
		{ name = "Forward swirl", filename = "Resources/Game/Skins/PlayerKit2/Hair/ForwardSwirl.lua" },
		{ name = "Forward spike", filename = "Resources/Game/Skins/PlayerKit2/Hair/ForwardSpike.lua" },
		{ name = "Slick pokey", filename = "Resources/Game/Skins/PlayerKit2/Hair/SlickPokey.lua" },
		{ name = "Braid", filename = "Resources/Game/Skins/PlayerKit2/Hair/Braid.lua" },
		{ name = "Curly", filename = "Resources/Game/Skins/PlayerKit2/Hair/Curly.lua" },
		{ name = "Grrl punk", filename = "Resources/Game/Skins/PlayerKit2/Hair/GrrlPunk.lua" },
		{ name = "Horns", filename = "Resources/Game/Skins/PlayerKit2/Hair/Horns.lua" },
		{ name = "Bald", filename = "Resources/Game/Skins/PlayerKit1/Hair/Bald.lua" },

		palette = {
			{ Color.fromHexString("6c4527"):get() },
			{ Color.fromHexString("3e3e3e"):get() },
			{ Color.fromHexString("8358c3"):get() },
			{ Color.fromHexString("d45500"):get() },
			{ Color.fromHexString("8dd35f"):get() }
		}
	},

	eyes = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = math.huge,
		{ name = "Eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/Eyes.lua" },
		{ name = "Draconic/demonic eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/SnakeEyes.lua" },
		{ name = "Heterochromic eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/Eyes_Heterochromia.lua" },
		{ name = "Heterochromic draconic/demonic eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/SnakeEyes_Heterochromia.lua" },
		{ name = "Robot eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/RobotEyes.lua" },
		{ name = "Skull holes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/Holes.lua" },
		{ name = "No eyes", filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyeless.lua" },

		palette = {
			{ Color.fromHexString("6c4527"):get() },
			{ Color.fromHexString("3e3e3e"):get() },
			{ Color.fromHexString("8358c3"):get() },
			{ Color.fromHexString("d45500"):get() },
			{ Color.fromHexString("8dd35f"):get() },
			{ Color.fromHexString("000000"):get() },
			{ Color.fromHexString("ffffff"):get() }
		},

		defaultColorConfig = {
			{ index = 1, Color.fromHexString("8358c3"):get() },
			{ Color.fromHexString("ffffff"):get() },
			{ Color.fromHexString("000000"):get() },
			{ index = 1, Color.fromHexString("8358c3"):get() },
			{ Color.fromHexString("000000"):get() },
			{ Color.fromHexString("ffffff"):get() }
		}
	},

	head = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_BASE,

		{ name = "Human/humanlike head", filename = "Resources/Game/Skins/PlayerKit2/Head/Humanlike.lua" },
		{ name = "Demonic/draconic head", filename = "Resources/Game/Skins/PlayerKit2/Head/SnakeLike.lua" },
		{ name = "Zombi head", filename = "Resources/Game/Skins/PlayerKit2/Head/Zombi.lua" },
		{ name = "Mummy head", filename = "Resources/Game/Skins/PlayerKit2/Head/Mummy.lua" },
		{ name = "Partially digested adventurer head", filename = "Resources/Game/Skins/PlayerKit2/Head/PartiallyDigested.lua" },
		{ name = "Skeleton head", filename = "Resources/Game/Skins/Skeleton/Head.lua" },
		{ name = "Dummy head", filename = "Resources/Game/Skins/PlayerKit2/Head/Dummy.lua" },
		{ name = "Robot head", filename = "Resources/Game/Skins/PlayerKit2/Head/Robot.lua" },
		{ name = "Eye", filename = "Resources/Game/Skins/PlayerKit2/Head/Eye.lua" },

		palette = {
			{ Color.fromHexString("efe3a9"):get() },
			{ Color.fromHexString("c5995f"):get() },
			{ Color.fromHexString("a4693c"):get() },
			{ Color.fromHexString("ffcc00"):get() },
			{ Color.fromHexString("bf50d9"):get() },
			{ Color.fromHexString("535d6c"):get() },
		},

		defaultColorConfig = {
			{ index = 1, Color.fromHexString("efe3a9"):get() },
			{ index = 2, Color.fromHexString("535d6c"):get() },
		}
	},

	body = {
		slot = Equipment.PLAYER_SLOT_BODY,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Alchemist", filename = "Resources/Game/Skins/PlayerKit2/Shirts/Alchemist.lua" },
		{ name = "Suit", filename = "Resources/Game/Skins/PlayerKit2/Shirts/BankerSuit.lua" },
		{ name = "Cannoneer", filename = "Resources/Game/Skins/PlayerKit2/Shirts/Cannoneer.lua" },
		{ name = "Chef", filename = "Resources/Game/Skins/PlayerKit2/Shirts/Chef.lua" },
		{ name = "Cross stitch", filename = "Resources/Game/Skins/PlayerKit2/Shirts/CrossStitch.lua" },
		{ name = "Dress", filename = "Resources/Game/Skins/PlayerKit2/Shirts/Dress.lua" },
		{ name = "Dummy", filename = "Resources/Game/Skins/PlayerKit2/Shirts/Dummy.lua" },
		{ name = "Fancy pirate garb", filename = "Resources/Game/Skins/PlayerKit2/Shirts/FancyPirateGarb.lua" },
		{ name = "Witch (huntress)", filename = "Resources/Game/Skins/PlayerKit2/Shirts/Hunter.lua" },
		{ name = "Lab coat", filename = "Resources/Game/Skins/PlayerKit2/Shirts/LabCoat.lua" },
	},

	hands = {
		slot = Equipment.PLAYER_SLOT_HANDS,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Human/humanlike hands", filename = "Resources/Game/Skins/PlayerKit2/Hands/Humanlike.lua" },
		{ name = "Gloves", filename = "Resources/Game/Skins/PlayerKit2/Hands/Gloves.lua" },
		{ name = "Draconic/demonic hands", filename = "Resources/Game/Skins/PlayerKit2/Hands/SnakeLike.lua" },
		{ name = "Split human/humanlike", filename = "Resources/Game/Skins/PlayerKit2/Hands/SplitHumanlike.lua" },
		{ name = "Split gloves", filename = "Resources/Game/Skins/PlayerKit2/Hands/SplitGloves.lua" },
		{ name = "Split draconic/demonic hands", filename = "Resources/Game/Skins/PlayerKit2/Hands/SplitSnakeLike.lua" },
		{ name = "Striped gloves", filename = "Resources/Game/Skins/PlayerKit2/Hands/StripedGloves.lua" },
		{ name = "Striped gloves with medallion", filename = "Resources/Game/Skins/PlayerKit2/Hands/StripedMedallionGloves.lua" },
		{ name = "Robot hands", filename = "Resources/Game/Skins/PlayerKit2/Hands/Robot.lua" },
		{ name = "Dummy hands", filename = "Resources/Game/Skins/PlayerKit2/Hands/Dummy.lua" },
		{ name = "Skeleton hands", filename = "Resources/Game/Skins/Skeleton/Hands.lua" },
		{ name = "Partially digested adventurer hands", filename = "Resources/Game/Skins/PlayerKit2/Hands/PartiallyDigested.lua" },

		palette = {
			{ Color.fromHexString("efe3a9"):get() },
			{ Color.fromHexString("c5995f"):get() },
			{ Color.fromHexString("a4693c"):get() },
			{ Color.fromHexString("ffcc00"):get() },
			{ Color.fromHexString("bf50d9"):get() },
			{ Color.fromHexString("535d6c"):get() },
		},

		defaultColorConfig = {
			{ index = 1, Color.fromHexString("efe3a9"):get() },
			{ index = 2, Color.fromHexString("ffcc00"):get() },
			{ index = 1, Color.fromHexString("efe3a9"):get() },
			{ index = 2, Color.fromHexString("ffcc00"):get() },
		}
	},

	feet = {
		slot = Equipment.PLAYER_SLOT_FEET,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Rugged boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua" },
		{ name = "Worn boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua" },
		{ name = "Fancy shoes", filename = "Resources/Game/Skins/PlayerKit1/Shoes/FancyShoes1.lua" },
		{ name = "Sailor's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua" },
		{ name = "Red sailor's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3_Red.lua" },
		{ name = "Seafarer's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots_Seafarer1.lua" },
		{ name = "Navy-blue seafarer's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots_Seafarer2.lua" },
		{ name = "Hunter's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/HunterBoots.lua" },
		{ name = "Mummy feet", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Feet_Mummy.lua" },
		{ name = "Partially digested feet", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Feet_PartiallyDigested.lua" },
		{ name = "Skeleton", filename = "Resources/Game/Skins/Skeleton/Feet.lua" },
		{ name = "Ancient skeleton", filename = "Resources/Game/Skins/AncientSkeleton/Feet.lua" },
		{ name = "Dummy", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Dummy.lua" },
		{ name = "Robot Mk II", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Robot_MkII.lua" },
	}
}

function CharacterCustomizationController:new(peep, director, closeCallback, isNewGame)
	Controller.new(self, peep, director)

	self.closeCallback = closeCallback
	self.isNewGame = isNewGame or false
end

function CharacterCustomizationController:poke(actionID, actionIndex, e)
	if actionID == "changeSlot" then
		self:changeSlot(e)
	elseif actionID == "submit" then
		self:submit(e)
	elseif actionID == "close" then
		if self.closeCallback then
			self.closeCallback()
		else
			self:getGame():getUI():closeInstance(self)
		end
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

function CharacterCustomizationController:changeSlot(e)
	assert(type(e.slot) == "string", "expected string for slot")
	assert(SKINS[e.slot], "slot not found")

	local skinStorage = self:getSkinStorage():get()
	local slot = SKINS[e.slot]

	local defaultColorConfig = {}
	for _, color in ipairs(slot.defaultColorConfig or {}) do
		local result
		if color.index then
			result = skinStorage[e.slot].config[color.index]

			if not result then
				result = { unpack(color) }
			end
		else
			result = color
		end

		table.insert(defaultColorConfig, result)
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"populateSkinOptions",
		nil,
		{
			skinStorage,
			slot,
			slot.slot,
			slot.priority,
			e.slot,
			slot.palette,
			defaultColorConfig
		})
end

function CharacterCustomizationController:submit(e)
	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		gender.gender = e.description.gender
		gender.description = e.description.description
		gender.pronounsPlural = e.description.pronouns.plural
		gender.pronouns = {
			e.description.pronouns.subject or Utility.Text.DEFAULT_PRONOUNS[gender.gender][1],
			e.description.pronouns.object or Utility.Text.DEFAULT_PRONOUNS[gender.gender][2],
			e.description.pronouns.possessive or Utility.Text.DEFAULT_PRONOUNS[gender.gender][3],
			e.description.pronouns.formal or Utility.Text.DEFAULT_PRONOUNS[gender.gender][4],
		}

		gender:save(peep)
	end

	self:getPeep():poke("rename", { name = e.description.name })

	for slotName, skin in pairs(e.skins) do
		self:getPeep():poke("changeWardrobe", {
			slot = skin.slot,
			slotName = slotName,
			priority = skin.priority,
			type = MODEL_SKIN,
			filename = skin.filename,
			name = skin.name,
			config = skin.config
		})
	end


	if self.closeCallback then
		self.closeCallback()
	else
		self:getGame():getUI():closeInstance(self)
	end
end

function CharacterCustomizationController:pull()
	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)

	local storage = self:getDirector():getPlayerStorage(peep)

	local state = {
		isNewGame = self.isNewGame,
		skins = storage:getRoot():getSection("Player"):getSection("Skin"):get(),
		name = storage:getRoot():getSection("Player"):getSection("Info"):get("name") or "Player",
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

	return state
end

return CharacterCustomizationController
