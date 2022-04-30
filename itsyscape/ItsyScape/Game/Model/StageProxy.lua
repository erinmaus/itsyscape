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

local StageProxy = {}

StageProxy.MAP = "map"
StageProxy.loadMap = Event.Set(
	StageProxy.MAP,
	Event.Argument("map"),
	Event.KeyArgument("layer"),
	Event.Argument("tileSetID"))
StageProxy.loadMap:link(
	"onLoadMap",
	Event.Argument("map"),
	Event.Argument("layer"),
	Event.Argument("tileSetID"))
StageProxy.unloadMap = Event.Unset(
	StageProxy.MAP,
	Event.Argument("map"),
	Event.KeyArgument("layer"))
StageProxy.unloadMap:link(
	"onUnloadMap",
	Event.Argument("map"),
	Event.Argument("layer"))
StageProxy.modifyMap = Event.Set(
	StageProxy.MAP,
	Event.Argument("map"),
	Event.KeyArgument("layer"))
StageProxy.modifyMap:link(
	"onMapModified",
	Event.Argument("map"),
	Event.Argument("layer"))

StageProxy.MAP_MOVE = "mapMove"
StageProxy.moveMap = Event.Set(
	StageProxy.MAP_MOVE,
	Event.KeyArgument("layer"),
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
	Event.KeyArgument("layer"))
StageProxy.stopMoveMap:link(
	"onUnloadMap",
	Event.Argument("map"),
	Event.Argument("layer"))

StageProxy.spawnActor = Event.Create(ActorProxy, function(event, gameManager, stage, id, actor)
	gameManager:newInstance("ItsyScape.Game.Model.Actor", actor:getID(), actor)
	ActorProxy:wrapServer("ItsyScape.Game.Model.Actor", actor:getID(), actor, gameManager)
	gameManager:invokeCallback("ItsyScape.Game.Model.Stage", 0, event, stage, id, actor)
end)
StageProxy.spawnActor:link("onActorSpawned")
StageProxy.killActor = Event.Destroy(ActorProxy, function(event, gameManager, stage, actor)
	gameManager:invokeCallback("ItsyScape.Game.Model.Stage", 0, event, stage, actor)
	gameManager:destroyInstance("ItsyScape.Game.Model.Actor", actor:getID())
end)
StageProxy.killActor:link("onActorKilled")

StageProxy.placeProp = Event.Create(PropProxy,function(event, gameManager, stage, id, prop)
	gameManager:newInstance("ItsyScape.Game.Model.Prop", prop:getID(), prop)
	PropProxy:wrapServer("ItsyScape.Game.Model.Prop", prop:getID(), prop, gameManager)
	gameManager:invokeCallback("ItsyScape.Game.Model.Stage", 0, event, stage, id, prop)
end)
StageProxy.placeProp:link("onPropPlaced")
StageProxy.removeProp = Event.Destroy(PropProxy, function(event, gameManager, stage, prop)
	gameManager:invokeCallback("ItsyScape.Game.Model.Stage", 0, event, stage, prop)
	gameManager:destroyInstance("ItsyScape.Game.Model.Prop", prop:getID())
end)
StageProxy.removeProp:link("onPropRemoved")

StageProxy.ITEM = "item"
StageProxy.dropItem = Event.Set(
	Event.KeyArgument("item"),
	Event.Argument("tile"),
	Event.Argument("position"))
StageProxy.dropItem:link(
	"onDropItem",
	Event.Argument("key"),
	Event.Argument("tile"),
	Event.Argument("position"))
StageProxy.takeItem = Event.Unset(
	Event.KeyArgument("item"),
	Event.Argument("tile"),
	Event.Argument("position"))
StageProxy.takeItem:link(
	"onTakeItem",
	Event.Argument("key"),
	Event.Argument("tile"),
	Event.Argument("position"))

StageProxy.DECORATION = "decoration"
StageProxy.decorate = Event.Set(
	StageProxy.DECORATION,
	Event.KeyArgument("group"),
	Event.Argument("decoration"),
	Event.KeyArgument("layer"))
StageProxy.decorate:link(
	"onDecorate",
	Event.Argument("group"),
	Event.Argument("decoration"),
	Event.Argument("layer"))
StageProxy.undecorate = Event.Unset(
	StageProxy.DECORATION,
	Event.KeyArgument("group"),
	Event.KeyArgument("layer"))
StageProxy.undecorate:link(
	"onUndecorate",
	Event.KeyArgument("group"),
	Event.KeyArgument("layer"))

StageProxy.WEATHER = "weather"
StageProxy.forecast = Event.Set(
	StageProxy.WEATHER,
	Event.Argument("layer"),
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
	Event.Argument("layer"),
	Event.KeyArgument("name"))
StageProxy.stopForecast:link(
	"onStopForecast",
	Event.Argument("layer"),
	Event.KeyArgument("name"))

StageProxy.WATER = "water"
StageProxy.flood = Event.Set(
	Event.KeyArgument("key"),
	Event.Argument("water"),
	Event.Argument("layer"))
StageProxy.flood:link(
	"onWaterFlood",
	Event.Argument("key"),
	Event.Argument("water"),
	Event.Argument("layer"))
StageProxy.drain = Event.Unset(
	Event.KeyArgument("key"),
	Event.Argument("water"))
StageProxy.drain:link(
	"onWaterDrain",
	Event.Argument("key"),
	Event.Argument("water"))

StageProxy.projectile = Event.ServerToClientRPC(
	Event.Argument("projectileID"),
	Event.Argument("source"),
	Event.Argument("destination"),
	Event.Argument("time"))
StageProxy.projectile:link(
	"onProjectile",
	Event.Argument("projectileID"),
	Event.Argument("source"),
	Event.Argument("destination"),
	Event.Argument("time"))

StageProxy.MUSIC = "music"
StageProxy.playMusic = Event.Set(
	Event.KeyArgument("track"),
	Event.Argument("song"))
StageProxy.playMusic:link(
	"onPlayMusic",
	Event.Argument("track"),
	Event.Argument("song"))
StageProxy.stopMusic = Event.Unset(
	Event.KeyArgument("track"),
	Event.Argument("song"))
StageProxy.stopMusic:link(
	"onStopMusic",
	Event.Argument("track"),
	Event.Argument("song"))

return Proxy(StageProxy)
