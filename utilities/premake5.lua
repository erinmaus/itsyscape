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
	platforms { "x86", "x64", "ARM64" }

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

	project "nbunny"
		language "C++"
		kind "SharedLib"

		cppdialect "C++20"

		configuration "Debug"
			targetsuffix "_debug"
			objdir "obj/debug"
			targetdir "bin"
		configuration "Release"
			objdir "obj/release"
			targetdir "bin"
		configuration "windows"
			defines { "NBUNNY_BUILDING_WINDOWS" }
			links { "lua51", "discord_game_sdk", "love" }
		configuration {}
			runtime "release"

		files {
			"nbunny/include/**.hpp",
			"nbunny/include/**.h",
			"nbunny/source/**.cpp",
			"nbunny/source/**.c"
		}

		includedirs {
			"nbunny/include/",
			"nbunny/include/nbunny/deps",
			path.join(_OPTIONS["deps"] or _DEFAULTS["deps"], "include"),
			path.join(_OPTIONS["deps"] or _DEFAULTS["deps"], "include", "modules"),
		}

		libdirs {
			path.join(_OPTIONS["deps"] or _DEFAULTS["deps"], "lib")
		}
