--------------------------------------------------------------------------------
-- ItsyScape/Analytics/Threads/PathNotesService.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

_LOG_SUFFIX = "patch-notes"
require "bootstrap"

local https = require "https"
local json = require "json"

local inputChannel, outputChannel = ...
local events = {}

local isRunning = true

local function shouldQuit()
	event = inputChannel:pop()
	if type(event) == "table" then
		if event.type == "quit" then
			isRunning = false
			return true
		else
			table.insert(events, event)
		end
	end

	return false
end

local function tryGetPatchNotes()
	local code, result = https.request("https://itsyrealm.com/api/download/build/version")

	if code == 200 then
		local success, patchNotes = pcall(json.decode, result)
		if success then
			local major, minor, build = patchNotes.version:match("(%d+)%.(%d+)%.(%d+).*")
			major, minor, build = tonumber(major) or 0, tonumber(minor) or 0, tonumber(build) or 0

			local nextVersion = string.format("%d.%d.%d", major, minor, build)
			local currentVersion = string.format("%d.%d.%d", _ITSYREALM_MAJOR, _ITSYREALM_MINOR, _ITSYREALM_BUILD)

			local hasNewVersion
			if (major > _ITSYREALM_MAJOR) or
			   (major == _ITSYREALM_MAJOR and minor > _ITSYREALM_MINOR) or
			   (major == _ITSYREALM_MAJOR and minor == _ITSYREALM_MINOR and build > _ITSYREALM_BUILD)
			then
				hasNewVersion = true
			else
				hasNewVersion = false
			end

			return true, hasNewVersion, nextVersion, patchNotes.patchNotes
		end
	end

	return false
end

local MODE_PREFETCH = "prefetch"
local MODE_THUMB    = "thumb"
local MODE_FULL     = "full"

local MODES = {
	MODE_PREFETCH,
	MODE_THUMB,
	MODE_FULL
}

local function tryGetImage(url, mode)
	local format, id = url:match("https://itsyrealm%.com/api/photo/view/(%w+)/(%d+)")

	if format and id then
		if format == "thumb" and mode == MODE_FULL then
			url = string.format("https://itsyrealm.com/api/photo/view/full/%d", tonumber(id))
		end
	end

	local code, result = https.request(url)
	if code == 200 then
		return love.data.newByteData(result)
	end

	return nil
end

function lines(s)
	if s:sub(-1) ~= "\n" then
		s = s .. "\n"
	end

	return s:gmatch("(.-)\n")
end

local function tryFormatPatchNotes(patchNotes, mode)
	local result = {}

	local currentBlock
	for line in lines(patchNotes) do
		if shouldQuit() then
			break
		end

		if line:match("^#") then
			currentBlock = {
				t = "header",
				line:match("^#+%s*(.*)%s*")
			}
		elseif line:match("^%*") then
			if not currentBlock or type(currentBlock) == "string" or currentBlock.t ~= "list" then
				currentBlock = { t = "list" }
			end

			table.insert(currentBlock, line:match("^%*+%s*(.*)%s*"))
		elseif line:match("^!") then
			local alt, image = line:match("^!(%b[])(%b())")
			alt = alt and image:match("%[(.*)%]")
			image = image and image:match("%((.*)%)")

			if mode == MODE_PREFETCH then
				table.insert(result, {
					t = "image",
					align = "center",
					resource = love.filesystem.newFileData("Resources/Game/UI/PatchNotesLoadingImage.png")
				})

				table.insert(result, "(Image loading... Enjoy this chest mimic!)")
			else
				local imageData = image and tryGetImage(image, mode)

				if imageData then
					table.insert(result, {
						t = "image",
						align = "center",
						resource = imageData
					})
				end
			end

			currentBlock = nil
		else
			currentBlock = line:match("%s*(.*)%s*") or ""
		end

		if currentBlock ~= result[#result] and currentBlock and currentBlock ~= "" then
			table.insert(result, currentBlock)
		end
	end

	return result
end

Log.info("Starting patch notes service...")

while isRunning do
	local event
	if #events > 0 then
		event = table.remove(events, 1)
	else
		event = inputChannel:demand()
	end

	if type(event) == "table" then
		if event.type == "quit" then
			isRunning = false
		elseif event.type == "update" then
			local success, hasNewVersion, version, patchNotes = tryGetPatchNotes()
			if success then
				for _, mode in ipairs(MODES) do
					local formattedPatchNotes = tryFormatPatchNotes(patchNotes, mode)
					outputChannel:push({
						type = "update",
						success = true,
						hasNewVersion = hasNewVersion,
						version = version,
						patchNotes = formattedPatchNotes
					})

					if not isRunning then
						break
					end
				end
			else
				outputChannel:push({
					type = "update",
					success = false
				})
			end
		end
	end
end

Log.info("Patch notes service terminated.")
Log.quit()
