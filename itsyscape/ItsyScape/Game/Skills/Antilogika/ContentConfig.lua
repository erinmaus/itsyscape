--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/ContentConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ContentConfig = {
	{
		id = "Azathoth_Common",

		content = {
			["River"] = {
				constructor = "River",
				priority = 0,

				config = {
					min = 0,
					max = 1,

					rivers = {
						{
							resource = "None",
							weight = 500
						}
					}
				}
			},

			["SmallBuilding"] = {
				constructor = "Building",
				priority = 1,

				config = {
					min = 1,
					max = 2,

					buildings = {
						{
							resource = "Azathoth_Cabin",
							weight = 300,
							tier = 1
						}
					}
				}
			},

			["Weather"] = {
				constructor = "Weather",
				priority = 1,

				config = {
					min = 0,
					max = 1,

					weather = {
						{
							resource = "None",
							weight = 600
						},
						{
							resource = "Rain",
							props = {
								wind = { -15, 0, 0 },
								heaviness = 0.25,
								color = { 1, 0, 0, 0.7 },
							},
							weight = 200
						}
					}
				}
			},

			["Woodcutting"] = {
				constructor = "Prop",
				priority = 10,

				config = {
					min = 30,
					max = 50,
					props = {
						{
							resource = "ShadowTree_Default",
							weight = 1000,
							tier = 1
						},
						{
							resource = "AzathothianTree_Default",
							weight = 25,
							tier = 90
						}
					}
				}
			},

			["Combat"] = {
				constructor = "Creep",
				priority = 20,

				config = {
					min = 1,
					max = 5,
					actors = {
						{
							resource = "Yendorian_Ballista",
							weight = 100,
							tier = 50
						},
						{
							resource = "Yendorian_Swordfish",
							weight = 100,
							tier = 50
						},
						{
							resource = "Yendorian_Mast",
							weight = 100,
							tier = 50
						}
					}
				}
			},

			["AtmosphereProps"] = {
				constructor = "Prop",
				priority = 10,

				config = {
					min = 20,
					max = 30,
					props = {
						{
							resource = "CommonTree_Snowy",
							weight = 1000,
							tier = 1
						},
						{
							resource = "ShadowTree_Default",
							weight = 250,
							tier = 1
						},
						{
							resource = "Azathothian_Mushroom_Variant1",
							weight = 200,
							tier = 1
						},
						{
							resource = "Azathothian_Mushrooms_Variant1",
							weight = 200,
							tier = 1
						},
						{
							resource = "Azathothian_Egg",
							weight = 100,
							tier = 1
						}
					}
				}
			}
		}
	},
	{
		id = "Azathoth_Mountain",
		content = {
			["River"] = {
				config = {
					rivers = {
						{
							resource = "Azathoth_Mountain_River",
							weight = 200,
							props = {
								bridgeFlat = "stone",
								bridgeEdge = "stone_wall",
								waterTexture = "PurpleFoamyWater1"
							}
						}
					}
				}
			},

			["Mining"] = {
				constructor = "Prop",
				priority = 10,

				config = {
					min = 1,
					max = 5,

					props = {
						{
							resource = "CopperRock_Default",
							weight = 100,
							tier = 1
						},
						{
							resource = "TinRock_Default",
							weight = 100,
							tier = 1
						},
						{
							resource = "IronRock_Default",
							weight = 75,
							tier = 10
						}
					}
				}
			},

			["Combat"] = {
				constructor = "Creep",

				config = {
					actors = {
						{
							resource = "CopperSkelemental",
							weight = 200,
							tier = 50
						},
						{
							resource = "TinSkelemental",
							weight = 200,
							tier = 50
						},
						{
							resource = "IronSkelemental",
							weight = 200,
							tier = 50
						}
					}
				}
			}
		}
	},
	{
		id = "Azathoth_Glacier",
		content = {
			["River"] = {
				config = {
					rivers = {
						{
							resource = "Azathoth_Glacier_River",
							weight = 300,
							props = {
								bridgeFlat = "wood",
								bridgeEdge = "wood",
								waterTexture = "LightFoamyWater1",
								elevation = { min = 2, max = 3 }
							}
						}
					}
				}
			}
		}
	},
	{
		id = "Azathoth_IcySea",
		content = {
			["River"] = {
				config = {
					rivers = {
						{
							resource = "Azathoth_Glacier_River",
							weight = 300,
							props = {
								bridgeFlat = "wood",
								bridgeEdge = "wood",
								waterTexture = "LightFoamyWater1",
								elevation = { min = 2, max = 3 }
							}
						}
					}
				}
			}
		}
	},
	{
		id = "Azathoth_Icy",

		content = {
			["Woodcutting"] = {
				constructor = "Prop",

				config = {
					props = {
						{
							resource = "CommonTree_Snowy",
							weight = 1000,
							tier = 1
						},
						{
							resource = "ShadowTree_Default",
							weight = -750,
							tier = 1
						}
					}
				}
			},

			["Weather"] = {
				constructor = "Weather",

				config = {
					min = 0,
					max = 1,

					weather = {
						{
							resource = "Fungal",
							props = {
								gravity = { 0, -10, 0 },
								wind = { -6, 0, 0 },
								colors = {
									{ 1, 1, 1, 1 }
								},
								minHeight = 20,
								maxHeight = 25,
								heaviness = 0.25
							},
							weight = 200
						}
					}
				}
			}
		}
	}
}

return ContentConfig
