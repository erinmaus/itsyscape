speaker "Chest"

local STATE_FLAGS = { ['item-inventory'] = true }
NUM_BARS = _SPEAKERS["Chest"]:getState():count("Item", "BronzeBar", STATE_FLAGS)

if NUM_BARS == 1 then
	message "There's ${NUM_BARS} bar in the chest."
else
	message "There's ${NUM_BARS} bars in the chest."
end

if NUM_BARS > 0 then
	local quantity
	while not quantity do
		local request = input "How many bars do want to withdraw?"
		if request == "" then
			quantity = 0
		else
			local s, q = Utility.Item.parseItemCountInput(request)
			if s then
				quantity = q
			else
				message "Please enter a valid value."
			end
		end
	end

	quantity = math.min(quantity, NUM_BARS)
	if _TARGET:getState():give("Item", "BronzeBar", quantity, STATE_FLAGS) then
		if not _SPEAKERS["Chest"]:getState():take("Item", "BronzeBar", quantity, STATE_FLAGS) then
			message "Bank error in your favor!"
		end
	end
end
