local gaveItem = false

local ITEMS = {
	{
		item = "WimpyFishingRod",
		text = "A wimpy fishing rod! I can use this to catch fish."
	},
	{
		item = "BronzePickaxe",
		text = "A bronze pickaxe! I can mine ores with this."
	},
	{
		item = "BronzeHatchet",
		text = "A bronze hatchet! I can cut down trees with this."
	},
	{
		item = "Hammer",
		text = "With this hammer, I can smith weapons, armor, and other equipment."
	},
	{
		item = "Knife",
		text = "Using a knife, I can fletch and craft items from wood."
	},
	{
		item = "Tinderbox",
		text = "Oh, a tinderbox. I can light fires with this."
	}
}

speaker "_TARGET"
message "Let's see what we have here..."

local state = _TARGET:getState()
local flags = { ['item-inventory'] = true, ['item-equipment'] = true }
for i = 1, #ITEMS do
	local current = ITEMS[i]

	if not state:has('Item', current.item, 1, flags) then
		local success = state:give('Item', current.item, 1, { ['item-inventory'] = true })
		if success then
			message(current.text)
			gaveItem = true
		else
			message "I need to make more room to get the rest of the stuff from here."
			return
		end
	end
end

if not gaveItem then
	message "There's nothing else in here."
end
