local FLAGS = { ['item-inventory'] = true }

local MAX = 5
local count = _TARGET:getState():count("Item", "IronCannonball", FLAGS)
count = math.max(MAX - count, 0)

if count > 0 then
	if _TARGET:getState():give("Item", "IronCannonball", count, FLAGS) then
		speaker "_TARGET"
		message "Let me take some cannonballs..."

		speaker "IronCannonballPile"
		message "(You take a few cannonballs and stuff them in your inventory.)"
	else
		speaker "_TARGET"
		message {
			"Seems I can't carry any more cannonballs.",
			"Better make some room in my inventory!"
		}
	end
else
	speaker "Jenkins"
	message "'Ey, don't ye be taking more than yer be needing, mate!"
end
