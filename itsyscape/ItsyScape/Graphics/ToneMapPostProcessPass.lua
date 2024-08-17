--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ToneMapPostProcessPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local PostProcessPass = require "ItsyScape.Graphics.PostProcessPass"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local NGBuffer = require "nbunny.optimaus.gbuffer"

local ToneMapPostProcessPass = Class(PostProcessPass)
ToneMapPostProcessPass.ID = PostProcessPass.newID()

ToneMapPostProcessPass.HSLCurve = Class()
function ToneMapPostProcessPass.HSLCurve:new(min, max, curveStart, curveMiddle, curveEnd)
	self.min = min
	self.max = max
	self.curveStart = curveStart
	self.curveMiddle = curveMiddle
	self.curveEnd = curveEnd
end

function ToneMapPostProcessPass.HSLCurve:toShader(index)
	return
		string.format("scape_HSLCurves[%d].min", index), { self.min:get() },
		string.format("scape_HSLCurves[%d].max", index), { self.max:get() },
		string.format("scape_HSLCurves[%d].start", index), { self.curveStart:get() },
		string.format("scape_HSLCurves[%d].middle", index), { self.curveMiddle:get() },
		string.format("scape_HSLCurves[%d].end", index), { self.curveEnd:get() }
end

ToneMapPostProcessPass.RGBCurve = Class()
function ToneMapPostProcessPass.RGBCurve:new(curveStart, curveMiddle, curveEnd)
	self.curveStart = curveStart
	self.curveMiddle = curveMiddle
	self.curveEnd = curveEnd
end

function ToneMapPostProcessPass.RGBCurve:toShader(index)
	return
		string.format("scape_RGBCurves[%d].start", index), { self.curveStart:get() },
		string.format("scape_RGBCurves[%d].middle", index), { self.curveMiddle:get() },
		string.format("scape_RGBCurves[%d].end", index), { self.curveEnd:get() }
end

function ToneMapPostProcessPass:new(...)
	PostProcessPass.new(self, ...)

	self:setRGBCurves()
	self:setHSLCurves()
end

function ToneMapPostProcessPass:setRGBCurves(...)
	self.rgbCurves = { ... }
end

function ToneMapPostProcessPass:setHSLCurves(...)
	self.hslCurves = { ... }
end

function ToneMapPostProcessPass:load(resources)
	PostProcessPass.load(self, resources)

	self.toneMapShader = self:loadPostProcessShader("ToneMap")
	self.toneMapBuffer = NGBuffer("rgba32f", "rgba32f")
end

function ToneMapPostProcessPass:draw(width, height)
	PostProcessPass.draw(self, width, height)

	self.toneMapBuffer:resize(width, height)
	love.graphics.setCanvas(self.toneMapBuffer:getCanvas(1))
	love.graphics.draw(self:getRenderer():getOutputBuffer():getColor())

	for index, rgbCurve in ipairs(self.rgbCurves) do
		self:bindShader(self.toneMapShader, rgbCurve:toShader(index - 1))
	end
	self:bindShader(self.toneMapShader, "scape_RGBCurveCount", #self.rgbCurves)

	for index, hslCurve in ipairs(self.hslCurves) do
		self:bindShader(self.toneMapShader, hslCurve:toShader(index - 1))
	end
	self:bindShader(self.toneMapShader, "scape_HSLCurveCount", #self.hslCurves)

	love.graphics.setCanvas(self.toneMapBuffer:getCanvas(2))
	love.graphics.draw(self.toneMapBuffer:getCanvas(1))

	love.graphics.setCanvas(self:getRenderer():getOutputBuffer():getColor())
	love.graphics.setShader()
	love.graphics.draw(self.toneMapBuffer:getCanvas(2))
end

return ToneMapPostProcessPass
