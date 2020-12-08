# ItsyRealm, a tiny RPG game

![Image of gear](https://itsyrealm.com/static/images/equipment.png)

ItsyRealm is a small RPG built on a slightly modified version of [LÖVE](http://love2d.org), an \*awesome\* framework to make games in Lua. The game is very much a work in progress.

In ItsyRealm, you're on an awesome quest to discover the secrets of a necromancer god only known as the Empty King.

* Along your way, you'll have to think on your feet using staff, sword, and bow to fight mythical monsters and eldritch abominations!
* Use 21 skills to gather and craft powerful equipment from dangerous dungeons, teeming forests, ancient ruins, the open sea, and more!
* And help a bunch of like-minded adventurers achieve their own victories!

Should you fail, the four Old Ones will succeed to tear the very fabric of reality apart...

# How to Play

![Image of adventurers](https://itsyrealm.com/static/images/heroes.png)

You can download the latest release from [ItsyRealm website](https://itsyrealm.com/). The game will automatically be updated by the [ItsyRealm launcher](https://github.com/erinmaus/itsyrealm-launcher).

## Build Instructions

To build ItsyRealm, you will need to:

1. Build a custom version of [LÖVE](https://github.com/erinmaus/love2d)
2. Build [BMASHINA](https://github.com/bkdoormaus/bmashina)
3. Build [nbunny](https://github.com/erinmaus/itsyscape/tree/master/utilities)
4. Build [Discworld](https://github.com/erinmaus/Discworld)
5. Move BMASHINA, nbunny, Discworld shared libraries to ext/

To run the game, execute `love itsyscape`.

Alternatively, on Windows, you can replace `%APPDATA%/ItsyRealmLauncher/game/itsyrealm.love` with a zip archive of the itsyscape folder contents to get the latest build of the game. However, if an updated binary blob is needed, it will have to be built.

# License & Copyright

![Image of mobs](https://itsyrealm.com/static/images/creeps.png)

Copyright (c) Erin Maus

This project is licensed under the MPL. View LICENSE in the root directory or
visit http://mozilla.org/MPL/2.0/ for the terms.
