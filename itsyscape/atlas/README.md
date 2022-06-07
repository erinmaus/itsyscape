

# Runtime Texture Atlas (RTA)
A Love2D runtime texture atlas designed to be easy to use and memory optimized. Creates texture atlas when loading than having to use an external tool to create an atlas. Tested and written on **love 11.3 Android** and **love 11.4 Windows**.

There are two types of Texture atlas you have access to:

**Fixed Size**: *All images must have the same width and height*

  Uses home-brew algorithm to pack images. Estimates size of the canvas with ceil(sqrt(numOfImages)) for the number of columns, then optimizes number of rows. (e.g. ceil(sqrt(50))=8, instead of an 8x8= grid for the atlas, it'll use 8x7 grid to avoid wasting the extra row). If you are baking an awful lot of images, and the window is freezing: see advice to solve this issues below.

**Note, due to algorithm constraints if it cannot get the size it requires it will throw an error.** This is due to the algorithm having no wiggly room to rearrange itself. This will unlikely be an issue unless you're forcing it to fit within a rectangle.

**Dynamic Size**: *All images can be whatever size they want*
  Uses a home-brew algorithm to pack images together based on cells. Unit tests show it takes 40% longer to bake than fixed size (This is given due to it being more complex than filling a grid). Check out `packing.lua` to see how they are being packed together. 

  Originally RTA used binary tree packing which didn't produced good results. This new packing algorithm is not only (almost) twice as fast but much more better at packing images optimally than the binary tree solution.
 ### How to run RTA headless
 If you're looking to run RTA headless, it supports drawing to imageData that is returned from baking. You can find this implemented in the [ETA command line tool](https://github.com/EngineerSmith/Export-TextureAtlas).
### Advice: Window Freezing during baking

  If your game window is freezing, it is due to the baking process taking too long. Try to avoid baking until the end, and avoid baking over and over unless you need to keep changing the images within the atlas. (If you're doing this to say animate, add all frames and then select the different quads in the draw)
  
  Otherwise there is no way easy way around it. You can use another library such as [Lily](https://github.com/MikuAuahDark/lily) to multi-thread load image - this will increase performance a little for loading your images.

TLDR; bake once at the start of your game
## Examples
### Fixed Size
All images must be the same size
```lua
local textureAtlas = require("libs.TA")
local ta = textureAtlas.newFixedSize(16, 32)
ta:setFilter("nearest")

ta:add(love.graphics.newImage("duck.png"), "duck") -- throws error if images aren't 16x32
ta:add(love.graphics.newImage("cat.png"), "cat")
ta:add(love.graphics.newImage("dog.png"), "dog")
ta:add(love.graphics.newImage("rabbit.png"), "rabbit")

ta:bake()

ta:remove("dog")
ta:remove("rabbit", true) -- Remove rabbit and bake changes

ta:hardBake() -- Cannot add or remove images after call, and deletes all references to given images so they can be cleaned from memory
collectgarbage("collect")

local catDraw = ta:getDrawFuncForID("cat")

love.draw = function()
    ta:draw("duck", 50,50)
    catDraw(100,50, 0, 5,5)
end
```
### Dynamic Size
Images don't have to be the same size
```lua
local textureAtlas = require("libs.TA")
local ta = textureAtlas.newDynamicSize()
ta:setFilter("nearest")

ta:add(love.graphics.newImage("521x753.png"), "duck")
ta:add(love.graphics.newImage("25x1250.png"), "cat")
ta:add(love.graphics.newImage("duck.png"), "duck") -- Replace previous image at id without having to call ta:remove
ta:add(love.graphic.newImage("rabbit.png", "rabbit")

ta:bake("height") -- Sorting algorithm optimizes space use

ta:remove("rabbit") -- will need to bake again
ta:remove("cat", true, "area") -- remove graphic, bake with this sort

ta:hardBake() -- Cannot add or remove images, and deletes all references to given images so they can be cleaned from memory
collectgarbage("collect")

local duckDraw = ta:getDrawFuncForID("duck")

love.draw = function()
    ta:draw("banner", 50,50)
    duckDraw(100,50, 0, 5,5)
    love.graphics.print(("x%d:y%d\nw%d:h%d"):format(ta:getViewport("duck")))
end
```
## Docs
Clone into your lib/include file for your love2d project.

E.g. `git clone https://github.com/EngineerSmith/Runtime-TextureAtlas libs/TA`
### require
Require the library using the init.lua
```lua
local textureAtlas = require("libs.TA") -- the location where it has been cloned to
```
### textureAtlas.new
Create an atlas to add images too:

- Fixed Size atlas require all added images to have the same width and height
- Dynamic Size atlas allows for any size of image

Variables explained:
* Padding: allows you to add a border around each image
* Extrude: allows you to extend the image using the clamp warp mode (or that which you've set for the image) See [here](https://love2d.org/wiki/WrapMode) for an example of clamp.
* Spacing: allows you to add space between each image, different from padding as it doesn't add space between atlas edge and the images.
Padding Vs Spacing: 1 pixel of spacing would leave a 1 pixel gap between images, whilst 1 pixel of padding would leave a 2 pixel gap between each image. Spacing would allow the texture to go up to the edges of the atlas, whilst padding will not.
```lua
local fs = textureAtlas.newFixedSize(width, height = width, padding = 1, extrude = 0, spacing = 0)
local ds = textureAtlas.newDynamicSize(padding = 1, extrude = 0, spacing = 0)

textureAtlas.newFixedSize(16) -- 16x16 only, padding 1 pixel
textureAtlas.newFixedSize(32,64, 5) -- 32x64 only, padding 5 pixel
textureAtlas.newFixedSize(64,64, 5, 3) -- 64x64 only, padding 5 pixels, extrude 3 pixels
textureAtlas.newFixedSize(64,64, 2, 2, 2) -- 64x64 only, padding 2 pixels, extrude 2 pixels, space 2 pixels

textureAtlas.newDynamicSize(1) -- padding 1 pixel
textureAtlas.newDynamicSize(5) -- padding 5 pixels
textureAtlas.newDynamicSize(3, 3) -- padding 3 pixels, extrude 3 pixels
textureAtlas.newDynamicSize(2, 2, 2) -- padding 2 pixels, extrude 2 pixels, space 2 pixels
```
### textureAtlas:setFilter(min, mag = min)
Similar to `image:setFilter`; however, will always override default filter even if not changed. E.g. if `love.graphics.setDefaultFilter("nearest", "nearest")` is called, textureAtlas will continue to bake in `"linear"`
```lua
ta:setFilter(min, mag = min)
ta:setFilter("nearest")
```
### textureAtlas:useImageData(boolean = false)
Change mode for the texture atlas to use `ImageData` instead of `love.graphics`. By default if `love.graphics` isn't loaded when `textureAtlas.new` is called, it will use `imageData` mode automatically.

**You cannot change this setting after adding images to the texture atlas!**
### textureAtlas:setBakeAsPow2(boolean = false)
Will round the atlas width and height to their nearest power of 2 value. Do note that the packing algorithms are not optimized for spacing towards the closest power of 2, and you may be left with a lot of empty space. This function doesn't re-bake the atlas, and can be called after hard bake function has been ran, but it will not do anything. This function is useful for those who want to export an atlas as an external resource as some old graphics cards and old smartphones requires textures to be power of 2 and can (in some cases) increase performance minimally. 
```lua
ta:setBakeAsPow2(true)
ta:setBakeAsPow2(false)
```
### textureAtlas:setPadding(padding)
Sets padding around each image, this will push the image away from the edge of the atlas.
```lua
ta:setPadding(1)
ta:setPadding(4)
```
### textureAtlas:setExtrude(extrude)
Sets how much an image should be extruded by. It allows you to extend the image using the clamp warp mode (or that which you've set for the image) See [here](https://love2d.org/wiki/WrapMode) for an example of clamp. This can help with bleeding in some cases. This function will use the individual warp mode of each image, be default this is "clamp". You can change this by setting the warp mode of each image you give to the texture atlas.
```lua
ta:setExtrude(1)
ta:setExtrude(2)
```
### textureAtlas:setSpacing(spacing)
Sets spacing between each image, doesn't add spacing between images and the edge of the atlas.
```lua
ta:setSpacing(1)
ta:setSpacing(3)
```
### textureAtlas:setMaxSize(width=systemMax, height=systemMax)
Set the maximum size for the texture atlas. Default is system limits, unless `love.graphics` isn't available (i.e. headless mode) then the default limit is 16,384.

Due to constraints of `fixedSize`'s packing algorithm, if it cannot have the size it wants, it will throw an error. It cannot rearrange itself to fit in a restricted area.
```lua
ta:setMaxSize(1000, 1000)
ta:setMaxSize(100) -- height will default to baseAtlas._maxCanvasSize
ta:setMaxSize(nil, 100) -- width will default to baseAtlas._maxCanvasSize
```
### textureAtlas:add(image, id, bake = false, ...)
Add or replace an image to your atlas. Use the 3rd argument to bake the addition. Recommended to only bake once all changes have been made - useful for updating one image. 4th argument is passed to `textureAtlas.bake`

**Note, id can be any normal table index variable type - not limited to strings**
```lua
ta:add(image, id, bake = false, ...)
ta:add(love.graphics.newImage("duck.png"), "duck")

fixed:add(love.graphics.newImage("duck.png"), "duck", true)
dynamic:add(love.graphics.newImage("duck.png"), "duck", true, "height") -- option to add in sorting algorithm
```
### textureAtlas:remove(id, bake = false, ...)
Remove an image added to the atlas. Use the 2nd argument to bake the removal. Recommended to only bake once all changes have been made or if you're only making a single change. 4th argument is passed to `textureAtlas.bake`
```lua
ta:remove(id, bake = false, ...)
ta:remove("duck")

fixed:remove("duck", true)
dynamic:remove("duck", true, "area")
```
### textureAtlas:getViewport(id)
Get viewport for given id. Returns position, width and height for it's location on the texture atlas. Will throw an error if a quad doesn't exist for given id.
```lua
local x, y, w, h = ta:getViewport(id)
local x, y, w, h = ta:getViewport("duck")
```
### textureAtlas:bake
Baking takes all added images and stitches them together onto a single image. Basic check in place to ensure it only bakes when changes have been made via `add` or `remove` to avoid needless baking

**Note, it's recommended to use `textureAtlas:hardBake` once all changes have been made.**
```lua
fixed:bake()
dynamic:bake(sortby)
dynamic:bake("area") 
-- _sortBy options: "area" (default), "height", "width", "none"
-- "height" and "area" are best from unit testing - but do your own tests to see what works best for your images
-- use dynamic.image to grab the baked image
```
### textureAtlas:hardBake
Hard baking bakes the image(if changes have been made since last bake) and removes all references to all added images. Once called, you cannot add(throws error), remove(throws error) or bake again(no error). This function is designed to free up unused memory.

**Note, any references to images that still exist outside of textureAtlas will keep the image alive (`image:release` is not called)**

Call `collectgarbage("collect")` after `textureAtlas:hardBake` if you want to see instant results of cleaning out unused memory, otherwise let lua handle when it wants to collect garbage.
```lua
fixed:hardBake()
dynamic:hardBake(sortBy) -- See textureAtlas:bake for sortBy options
```
### textureAtlas:draw(id, ...)
Draw the given id, with the given variables. Varargs passed to `love.graphics.draw`
```lua
ta:draw("cat")
ta:draw("bird", 50,50, 0, 5,5) -- draw id "bird" at 50,50 at scale 5
```
### textureAtlas:getDrawFuncForID(id)
Get a draw function to avoid passing given texture atlas and id around
```lua
local draw = ta:getDrawFuncForID("duck")
-- draw(...) -- values are sent as arguments to love.graphics.draw, similar to textureAtlas:draw(id, ...)
draw(50,50, 0, 5,5) -- draws id "duck" at 50,50 at scale 5
```
