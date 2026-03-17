--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Drakkenson.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Tank = ItsyScape.Resource.Prop "LifeSupportTank"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.FurnitureProp",
		Resource = Tank
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2.5,
		SizeY = 3.5,
		SizeZ = 2.5,
		MapObject = Tank
	}

	ItsyScape.Meta.ResourceName {
		Value = "Life support tank",
		Language = "en-US",
		Resource = Tank
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "From experimenting with blackmelt, the Drakkenson discovered how to created life at a great cost. These... experiments must be supported by this tank until they are strong enough to leave.",
		Language = "en-US",
		Resource = Tank
	}
end

do
	local Processor = ItsyScape.Resource.Prop "LifeSupportProcessor"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.FurnitureProp",
		Resource = Processor
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1.5,
		SizeZ = 1.5,
		MapObject = Processor
	}

	ItsyScape.Meta.ResourceName {
		Value = "Life support processor",
		Language = "en-US",
		Resource = Processor
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Paradoxically, blackmelt is highly toxic to life, and must be constantly processed to prevent the death of the experiments.",
		Language = "en-US",
		Resource = Processor
	}
end

do
	local Computer = ItsyScape.Resource.Prop "DrakkensonComputer"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.FurnitureProp",
		Resource = Computer
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 1.5,
		SizeZ = 0.5,
		OffsetY = 1,
		MapObject = Computer
	}

	ItsyScape.Meta.ResourceName {
		Value = "Computation device",
		Language = "en-US",
		Resource = Computer
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A monitor and computation device, all-in-one. Technology that humans will not develop for at least another thousand years.",
		Language = "en-US",
		Resource = Computer
	}
end
