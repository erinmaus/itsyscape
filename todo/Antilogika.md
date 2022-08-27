# Antilogika portal generation

## What is Antilogika?

Antilogika is a skill about "anti-logic" - a.k.a., things that don't make sense. The results of actions performed via Antilogika aren't predictable or make may not make sense - it takes trial, error, and exploration to make the most use of the skill. Common things that you can do using the skill are creating enchantments for weapons and opening portals to other dimensions.

## Portals

A portal is a gateway to another dimension. Portals are constructed near "veils", or faint cracks in the fabric of reality. Veils are found through-out the realm in all kinds of places. For example, there is a veil in Hex's lab that she is studying.

A portal is powered by "flux" - basic, elemental constructs crafted with an almaglabinationinator (agab for short).

### Critical veils

Critical veils will generate critical portals. Critical veils are used in quests, such as "Escape the Nightmare". See below about the `algorithm` how that specifically looks.

## Almaglabinatinator (agab)

The agab is built with Hex's help by reverse-engineering Old One's tech (specifically Prisium's Fine Laser Soul Schism, an ancient, defunct device discovered near Rumbridge). Completing the quest "Mysterious Machinations" will result in the player possessing an agab that they built themselves.

The agab is built from low-level resources:

* Copper wire spool (made from smelting thin copper veins obtained via mining copper or tin)
* Silicon chips (made from cooking silicon apples obtained via foraging)
* Melted plastic blob (made from burning old boots obtained via fishing)
* Gross lil bug boy (obtained from woodcutting most things or foraging most things)
* Cut amber quartz (made from amber, obtained by woodcutting, and a quartz, obtained via mining)

It requires level 10 engineering and a mad scientist workbench (available in Hex's lab) to build.

## Creating flux

Flux is made from secondary resources obtained mostly via gathering skills (much like the agab is built from these secondaries).

For example, "booming flux" may require purple salt peter, charcoal, crumbly sulfur, and flint. Some of these are from mining, others are from firemaking.

### What does flux do?

Flux changes what kind of things will appear in a map. For example, booming flux may spawn more enemies with gunpowder weaponry.

### How does flux work?

Flux works by increasing (or decreasing) weights for tons of properties that determine what may spawn in the dimension. To continue with the booming flux, it may decrease the spawn rate for timid wild animals and increase the weights for gunpowder weaponry and gunpowder weaponry drops.

Generally there is an "initial set of weights" that determines the baseline for a portal made with no flux. Some weights may be zero or below zero. Others will be high or low.

The `algorithm` (discussed later) will roll random numbers based on the coordinates, and compare these numbers to the weights. Anything with a weight at or below zero will never spawn.

## The algorithm

So how does the world get generated?

### Initializating the algorithm

1. The player may (optionally) enter up to four coordinates, representing four dimensions. These coordinates go through a simple formula to become a big number - a "seed". If the player does not enter coordinates, they will be randomly generated. The player can favorite certain coordinates and see the last coordinates they used.

2. There are hidden "interdimensional time" values that affects cosmetic things. Essentially, they will translate the noise function used to determine cosmetic features like building styles, ground textures / ground decorations, weather, etc. These values move slowly - if the player visits the same coordinates in a row, with only minutes between each attempt, there may be little to no changes. However, if they wait a while (e.g., a day or two), there might be significant changes to the look of the world.

3. The player will combine flux. There is an upper limit to flux, based on the player's antilogika level. The higher their antilogika level, the more flux they can use. Each piece of flux increases the instability of the portal. Lower-level flux affects instability less than higher-level flux. If instability is too high (E.g., > 100%), the portal will fail to open and Something Bad (tm) will happen. Different portals have different instability thesholds; more remote portals have much higher stability (and therefore can take more higher-level flux) than portals in more accessible locations. This is by design.

### Generation

* Time-aware noise (coordinate + interdimensional time value) will determine all things cosmetic; e.g., the skins of monsters (if applicable), the building styles, tile selection on the ground, etc.
* Timeless noise (just coordinate) will determine biomes within the "theme" of the dimension.
* The theme is the first thing generated from the coordinates; it is affected by weights, but in short will resolve to things like Azathoth (Yendor's home), CENTRUS (Prisium's home), Daemon Realm (Bastiel's home), etc. The theme will affect what biomes are used by timeless noise, as well as what monsters are available.

Higher instability will create bigger maps and increase the difficulty of the encounter. The same instability value with the same coordinates and same flux will result in very similar encounters.

### Critical portals

A critical portal will save the results of the dimension to the save file and will not be affected by time-aware noise. A critical portal is generally **VERY BIG**. We are talking multiple cities, size of the mainland Realm **BIG**. If the algorithm changes, the dimension will be re-generated after confirmation from the user.

Generating critical portals may take a while. 😡 Sucks to suck.