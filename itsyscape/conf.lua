local serpent = require "serpent"

function love.conf(t)
	local s
	do
		love.filesystem.setIdentity("ItsyRealm")
		local file = love.filesystem.read("settings.cfg")
		if file then
			local r, e = loadstring('return ' .. file)
			if not r then
				io.stderr:write(string.format("Failed to parse settings: '%s'\n", e))
			else
				r, e = pcall(r)
				if not r then
					io.stderr:write(string.format("Failed to load settings: '%s'\n", e))
				else
					s = e
				end
			end
		end

		s = s or {}
	end

	t.identity = "ItsyRealm"
	t.title = "ItsyRealm"	
	t.window.width = s.width or 1280
	t.window.height = s.height or 720
	t.window.depth = 24
	t.window.fullscreen = s.fullscreen or false
	t.window.vsync = s.vsync or 0
	t.window.display = s.display or t.window.display
end
