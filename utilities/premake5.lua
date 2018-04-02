_DEFAULTS = {
	["deps"] = "."
}

newoption {
	trigger     = "deps",
	value       = "DIR",
	description = "Root directory containing dependencies."
}

solution "ItsyScape.Utilities"
	configurations { "Debug", "Release" }
	platforms { "x86" }

	configuration "Debug"
		defines { "DEBUG" }
		symbols "On"

	configuration "Release"
		defines { "NDEBUG" }
		optimize "On"

	project "Goober"
		language "C++"
		kind "ConsoleApp"

		configuration "Debug"
			targetsuffix "_debug"
			objdir "obj/debug"
			targetdir "bin"
		configuration "Release"
			objdir "obj/release"
			targetdir "bin"
		configuration {}
			runtime "release"

		links { "assimp" }

		files {
			"goober/main.cpp"
		}

		includedirs {
			path.join(_OPTIONS["deps"] or _DEFAULTS["deps"], "include"),
		}

		libdirs {
			path.join(_OPTIONS["deps"] or _DEFAULTS["deps"], "lib")
		}
