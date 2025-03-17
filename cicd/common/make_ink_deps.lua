local input, output = ...

local baseFolder = input:gsub("(/[^/]+)$", "")
local baseFilename = input:match("/([^/]+)$")
local pendingFiles = { baseFilename }
local visitedFiles = {}
local dependencies = {}

while #pendingFiles > 0 do
	local pendingBaseFilename = table.remove(pendingFiles, 1)
	local pendingFilename = string.format("%s/%s", baseFolder,pendingBaseFilename)
	pendingFilename = pendingFilename:gsub("([^/]+)/%.%./", "")
	pendingFilename = pendingFilename:gsub("/%./", "/")

	if not visitedFiles[pendingFilename] then
		table.insert(dependencies, string.format("./%s", pendingFilename))
		visitedFiles[pendingFilename] = true

		local inputFile = io.open(pendingFilename, "r")
		for line in inputFile:lines() do
			local filename = line:match("^%s*INCLUDE%s+(.+)%s*$")
			table.insert(pendingFiles, filename)
		end

		inputFile:close()
	end
end

table.remove(dependencies, 1)

local outputFile = io.open(output, "w+")
outputFile:write(string.format("./%s: %s\n", input, table.concat(dependencies, " ")))
outputFile:close()
