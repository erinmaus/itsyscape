--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_Tower.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Meta.BossCategory {
		Category = "IsabelleIsland",
		Name = "Isabelle Island",
		Description = "The toughest foes the lurk in the oceans, in the trees, and underground at Isabelle Island.",
		Language = "en-US"
	}

	do
		local Isabelle = ItsyScape.Resource.Boss "Isabelle_Kursed"

		ItsyScape.Meta.ResourceName {
			Value = "Isabelle (kursed)",
			Language = "en-US",
			Resource = Isabelle
		}

		ItsyScape.Meta.ResourceDescription {
			Value = "Turns out Isabelle isn't a helpless merchant but a master of all three combat styles. However, she is kursed by the Amulet of Yendor and her brute strength has been sapped away.",
			Language = "en-US",
			Resource = Isabelle
		}

		ItsyScape.Meta.Boss {
			Boss = Isabelle,
			Target = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean",
			Category = "IsabelleIsland",
			RequireKill = 1
		}

		ItsyScape.Meta.BossDropTable {
			Boss = Isabelle,
			DropTable = ItsyScape.Resource.DropTable "Isabelle_Primary"
		}

		ItsyScape.Meta.BossDropTable {
			Boss = Isabelle,
			DropTable = ItsyScape.Resource.DropTable "Isabelle_Secondary"
		}
	end

	do
		local Parasite = ItsyScape.Resource.Boss "CthulhianParasiteTrio"

		ItsyScape.Meta.ResourceName {
			Value = "Cthulhian parasite trio",
			Language = "en-US",
			Resource = Parasite
		}

		ItsyScape.Meta.ResourceDescription {
			Value = "A trio of wizards recently turned by Cthulhu to protect the High Chambers of Yendor.",
			Language = "en-US",
			Resource = Parasite
		}

		ItsyScape.Meta.Boss {
			Boss = Parasite,
			Target = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite",
			Category = "IsabelleIsland",
		}

		ItsyScape.Meta.BossDropTable {
			Boss = Parasite,
			DropTable = ItsyScape.Resource.DropTable "HighChambersYendor_MassiveBeatingHeart_Rewards"
		}
	end

	do
		local Squid = ItsyScape.Resource.Boss "UndeadSquid"

		ItsyScape.Meta.ResourceName {
			Value = "Mn'thrw",
			Language = "en-US",
			Resource = Squid
		}

		ItsyScape.Meta.ResourceDescription {
			Value = "Once raised to serve Yendor, Mn'thrw has been overcome by The Empty King to keep folks away.",
			Language = "en-US",
			Resource = Squid
		}

		ItsyScape.Meta.Boss {
			Boss = Squid,
			Target = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid",
			Category = "IsabelleIsland"
		}

		ItsyScape.Meta.BossDropTable {
			Boss = Squid,
			DropTable = ItsyScape.Resource.DropTable "IsabelleIsland_Port_UndeadSquid_Rewards"
		}

		ItsyScape.Meta.BossDropTable {
			Boss = Squid,
			DropTable = ItsyScape.Resource.DropTable "IsabelleIsland_Port_UndeadSquid_Rewards_Skull"
		}
	end

	do
		local Foreman = ItsyScape.Resource.Boss "GhostlyMinerForeman"

		ItsyScape.Meta.ResourceName {
			Value = "Ghostly miner foreman",
			Language = "en-US",
			Resource = Foreman
		}

		ItsyScape.Meta.ResourceDescription {
			Value = "Slain when The Empty King took over Isabelle Island, he was raised to protect the mines.",
			Language = "en-US",
			Resource = Foreman
		}

		ItsyScape.Meta.Boss {
			Boss = Foreman,
			Target = ItsyScape.Resource.Peep "GhostlyMinerForeman",
			Category = "IsabelleIsland"
		}

		ItsyScape.Meta.BossDropTable {
			Boss = Foreman,
			DropTable = ItsyScape.Resource.DropTable "GhostlyMinerForeman_TenseTin"
		}

		ItsyScape.Meta.BossDropTable {
			Boss = Foreman,
			DropTable = ItsyScape.Resource.DropTable "GhostlyMinerForeman_CrawlingCopper"
		}
	end

	do
		local BoundNymph = ItsyScape.Resource.Boss "BoundNymph"

		ItsyScape.Meta.ResourceName {
			Value = "Bound wood nymph",
			Language = "en-US",
			Resource = BoundNymph
		}

		ItsyScape.Meta.ResourceDescription {
			Value = "A strong wood nymph kursed by a mask made by the ancient driftwood, she keeps the peace in the Foggy Forest.",
			Language = "en-US",
			Resource = BoundNymph
		}

		ItsyScape.Meta.Boss {
			Boss = BoundNymph,
			Target = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph",
			Category = "IsabelleIsland"
		}

		ItsyScape.Meta.BossDropTable {
			Boss = BoundNymph,
			DropTable = ItsyScape.Resource.DropTable "IsabelleIsland_FoggyForest_BossyNymph_Mask"
		}

		ItsyScape.Meta.BossDropTable {
			Boss = BoundNymph,
			DropTable = ItsyScape.Resource.DropTable "Nymph_Base_Primary"
		}

		ItsyScape.Meta.BossDropTable {
			Boss = BoundNymph,
			DropTable = ItsyScape.Resource.DropTable "Nymph_Base_Secondary"
		}
	end
end
