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
	platforms { "x86", "x64" }

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

		cppdialect "C++17"

		configuration "Debug"
			targetsuffix "_debug"
			objdir "obj/debug"
			targetdir "bin"
		configuration "Release"
			objdir "obj/release"
			targetdir "bin"
		configuration {}
			runtime "release"
		configuration "windows"
			defines { "NBUNNY_BUILDING_WINDOWS" }

		links { "lua51" }

		files {
			"nbunny/include/**.hpp",
			"nbunny/source/**.cpp"
		}

		includedirs {
			"nbunny/include/",
			path.join(_OPTIONS["deps"] or _DEFAULTS["deps"], "include"),
		}

		libdirs {
			path.join(_OPTIONS["deps"] or _DEFAULTS["deps"], "lib")
		}
