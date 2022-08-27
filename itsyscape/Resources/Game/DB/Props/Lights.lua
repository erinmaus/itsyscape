--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Lights.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

Meta "Fog" {
	ColorRed = Meta.TYPE_REAL,
	ColorGreen = Meta.TYPE_REAL,
	ColorBlue = Meta.TYPE_REAL,
	ColorNormalized = Meta.TYPE_INTEGER,
	NearDistance = Meta.TYPE_REAL,
	FarDistance = Meta.TYPE_REAL,
	FollowTarget = Meta.TYPE_INTEGER,
	FollowSelf = Meta.TYPE_INTEGER,
	Resource = Meta.TYPE_RESOURCE
}

Meta "Light" {
	ColorRed = Meta.TYPE_REAL,
	ColorGreen = Meta.TYPE_REAL,
	ColorBlue = Meta.TYPE_REAL,
	ColorNormalized = Meta.TYPE_INTEGER,
	Local = Meta.TYPE_INTEGER,
	Resource = Meta.TYPE_RESOURCE
}

Meta "PointLight" {
	Attenuation = Meta.TYPE_REAL,
	Resource = Meta.TYPE_RESOURCE
}

Meta "AmbientLight" {
	Ambience = Meta.TYPE_REAL,
	Resource = Meta.TYPE_RESOURCE
}

Meta "DirectionalLight" {
	DirectionX = Meta.TYPE_REAL,
	DirectionY = Meta.TYPE_REAL,
	DirectionZ = Meta.TYPE_REAL,
	Resource = Meta.TYPE_RESOURCE
}

local LIGHTS = {
	"Fog",
	"PointLight",
	"AmbientLight",
	"DirectionalLight"
}

for _, light in ipairs(LIGHTS) do
	local LightName = string.format("%s_Default", light)
	local Light = ItsyScape.Resource.Prop(LightName)

	ItsyScape.Meta.PeepID {
		Value = string.format("Resources.Game.Peeps.Props.Basic%s", light),
		Resource = Light
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0,
		SizeY = 0,
		SizeZ = 0,
		MapObject = Light
	}
end
