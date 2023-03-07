--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/StageProxy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local ActorProxy = require "ItsyScape.Game.Model.ActorProxy"
local PropProxy = require "ItsyScape.Game.Model.PropProxy"
local Proxy = require "ItsyScape.Game.RPC.Proxy"
local Event = require "ItsyScape.Game.RPC.Event"
local Property = require "ItsyScape.Game.RPC.Property"

local StageProxy = Proxy.Definition()

StageProxy.MAP = "map"
StageProxy.loadMap = Event.Set(
	StageProxy.MAP,
	Event.Argument("map"),
	Event.KeyArgument("layer", true),
	Event.Argument("tileSetID"),
	Event.Argument("mask"))
StageProxy.loadMap:link(
	"onLoadMap",
	Event.Argument("map"),
	Event.Argument("layer"),
	Event.Argument("tileSetID"),
	Event.Argument("mask"))
StageProxy.getMap = Event.Get(
	StageProxy.MAP,
	Event.Return("map"),
	Event.KeyArgument("layer", true))
StageProxy.unloadMap = Event.Unset(
	StageProxy.MAP,
	Event.Argument("map"),
	Event.KeyArgument("layer", true))
StageProxy.unloadMap:link(
	"onUnloadMap",
	Event.Argument("map"),
	Event.Argument("layer"))
StageProxy.modifyMap = Event.Set(
	StageProxy.MAP,
	Event.Argument("map"),
	Event.KeyArgument("layer", true))
StageProxy.modifyMap:link(
	"onMapModified",
	Event.Argument("map"),
	Event.Argument("layer"))

StageProxy.MAP_MOVE = "mapMove"
StageProxy.moveMap = Event.Set(
	StageProxy.MAP_MOVE,
	Event.KeyArgument("layer", true),
	Event.Argument("position"),
	Event.Argument("rotation"),
	Event.Argument("scale"),
	Event.Argument("offset"),
	Event.Argument("disabled"))
StageProxy.moveMap:link(
	"onMapMoved",
	Event.Argument("layer"),
	Event.Argument("position"),
	Event.Argument("rotation"),
	Event.Argument("scale"),
	Event.Argument("offset"),
	Event.Argument("disabled"))
StageProxy.stopMoveMap = Event.Unset(
	StageProxy.MAP_MOVE,
	Event.Argument("map"),
	Event.KeyArgument("layer", true))
StageProxy.stopMoveMap:link(
	"onUnloadMap",
	Event.Argument("map"),
	Event.Argument("layer"))

StageProxy.spawnActor = Event.Create(ActorProxy, function(event, gameManager, stage, id, actor, isMoving)
	if isMoving then
		Log.engine("Actor '%s' (%d) is moving between instances; not emitting create.", actor:getName(), actor:getID())
		return
	end

	local instance = gameManager:newInstance("ItsyScape.Game.Model.Actor", actor:getID(), actor)
	ActorProxy:wrapServer("ItsyScape.Game.Model.Actor", actor:getID(), actor, gameManager)
	gameManager:invokeCallback("ItsyScape.Game.Model.Stage", 0, event, stage, id, actor)
	instance:update(true)
end, Event.Argument("id"), Event.Argument("actor", true))
StageProxy.spawnActor:link("onActorSpawned")
StageProxy.killActor = Event.Destroy(ActorProxy, function(event, gameManager, stage, actor, isMoving, layer)
	if isMoving then
		Log.engine("Actor '%s' (%d) is moving between instances; not emitting destroy.", actor:getName(), actor:getID())
		return
	end

	gameManager:invokeCallback("ItsyScape.Game.Model.Stage", 0, event, stage, actor, layer)
	gameManager:destroyInstance("ItsyScape.Game.Model.Actor", actor:getID())
end, Event.Argument("actor", true), Event.Argument("layer", true))
StageProxy.killActor:link("onActorKilled")

StageProxy.placeProp = Event.Create(PropProxy,function(event, gameManager, stage, id, prop, isMoving)
	if isMoving then
		Log.engine("Prop '%s' (%d) is moving between instances; not emitting create.", prop:getName(), prop:getID())
		return
	end

	local instance = gameManager:newInstance("ItsyScape.Game.Model.Prop", prop:getID(), prop)
	PropProxy:wrapServer("ItsyScape.Game.Model.Prop", prop:getID(), prop, gameManager)
	gameManager:invokeCallback("ItsyScape.Game.Model.Stage", 0, event, stage, id, prop)
	instance:update(true)
end, Event.Argument("id"), Event.Argument("prop", true))
StageProxy.placeProp:link("onPropPlaced")
StageProxy.removeProp = Event.Destroy(PropProxy, function(event, gameManager, stage, prop, isMoving, layer)
	if isMoving then
		Log.engine("Prop '%s' (%d) is moving between instances; not emitting create.", prop:getName(), prop:getID())
		return
	end

	gameManager:invokeCallback("ItsyScape.Game.Model.Stage", 0, event, stage, prop, layer)
	gameManager:destroyInstance("ItsyScape.Game.Model.Prop", prop:getID())
end, Event.Argument("prop", true), Event.Argument("layer", true))
StageProxy.removeProp:link("onPropRemoved")

StageProxy.ITEM = "item"
StageProxy.dropItem = Event.Set(
	StageProxy.ITEM,
	Event.KeyArgument("ref"),
	Event.Argument("item"),
	Event.Argument("tile"),
	Event.Argument("position"),
	Event.KeyArgument("layer"))
StageProxy.dropItem:link(
	"onDropItem",
	Event.Argument("ref"),
	Event.Argument("item"),
	Event.Argument("tile"),
	Event.Argument("position"),
	Event.Argument("layer"))
StageProxy.takeItem = Event.Unset(
	StageProxy.ITEM,
	Event.KeyArgument("ref"),
	Event.Argument("item"),
	Event.KeyArgument("layer"))
StageProxy.takeItem:link(
	"onTakeItem",
	Event.Argument("ref"),
	Event.Argument("item"),
	Event.Argument("layer"))

StageProxy.DECORATION = "decoration"
StageProxy.decorate = Event.Set(
	StageProxy.DECORATION,
	Event.KeyArgument("group"),
	Event.Argument("decoration"),
	Event.KeyArgument("layer", true))
StageProxy.decorate:link(
	"onDecorate",
	Event.Argument("group"),
	Event.Argument("decoration"),
	Event.Argument("layer"))
StageProxy.undecorate = Event.Unset(
	StageProxy.DECORATION,
	Event.KeyArgument("group"),
	Event.KeyArgument("layer", true))
StageProxy.undecorate:link(
	"onUndecorate",
	Event.KeyArgument("group"),
	Event.KeyArgument("layer", true))

StageProxy.WEATHER = "weather"
StageProxy.forecast = Event.Set(
	StageProxy.WEATHER,
	Event.KeyArgument("layer", true),
	Event.KeyArgument("name"),
	Event.Argument("id"),
	Event.Argument("props"))
StageProxy.forecast:link(
	"onForecast",
	Event.Argument("key"),
	Event.Argument("water"),
	Event.Argument("layer"))
StageProxy.stopForecast = Event.Unset(
	StageProxy.WEATHER,
	Event.KeyArgument("layer", true),
	Event.KeyArgument("name"))
StageProxy.stopForecast:link(
	"onStopForecast",
	Event.Argument("layer"),
	Event.KeyArgument("name"))

StageProxy.WATER = "water"
StageProxy.flood = Event.Set(
	StageProxy.WATER,
	Event.KeyArgument("key"),
	Event.Argument("water"),
	Event.KeyArgument("layer", true))
StageProxy.flood:link(
	"onWaterFlood",
	Event.Argument("key"),
	Event.Argument("water"),
	Event.Argument("layer"))
StageProxy.drain = Event.Unset(
	StageProxy.WATER,
	Event.KeyArgument("key"),
	Event.KeyArgument("layer", true))
StageProxy.drain:link(
	"onWaterDrain",
	Event.Argument("key"),
	Event.Argument("water"))

StageProxy.projectile = Event.ServerToClientRPC(
	Event.Argument("projectileID"),
	Event.Argument("source", true),
	Event.Argument("destination", true),
	Event.Argument("time"))
StageProxy.projectile:link(
	"onProjectile",
	Event.Argument("projectileID"),
	Event.Argument("source"),
	Event.Argument("destination"),
	Event.Argument("time"))

StageProxy.MUSIC = "music"
StageProxy.playMusic = Event.Set(
	StageProxy.MUSIC,
	Event.KeyArgument("track"),
	Event.Argument("song"),
	Event.KeyArgument("layer"))
StageProxy.playMusic:link(
	"onPlayMusic",
	Event.Argument("track"),
	Event.Argument("song"),
	Event.Argument("layer"))
StageProxy.stopMusic = Event.Unset(
	StageProxy.MUSIC,
	Event.KeyArgument("track"),
	Event.Argument("song"),
	Event.KeyArgument("layer"))
StageProxy.stopMusic:link(
	"onStopMusic",
	Event.Argument("track"),
	Event.Argument("song"),
	Event.Argument("layer"))

return Proxy(StageProxy)
