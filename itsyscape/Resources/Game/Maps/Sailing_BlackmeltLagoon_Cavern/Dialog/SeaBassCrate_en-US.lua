speaker "_TARGET"

message "Woah, this crate stinks! It's full of %item{sea bass}."

local YES = option "Take some sea bass."
local NO  = option "Ew, gross! Leave it be."

local action = select {
	YES,
	NO
}

if action == YES then
	local FIRST_TRY_FLAGS = { ['item-inventory'] = true }
	local SECOND_TRY_FLAGS = { ['item-inventory'] = true, ['force-item-drop'] = true }

	AMOUNT = math.random(10, 20)
	local roll1 = math.random(1, 3)
	Log.info("Rolled a %d out of 3 when attempting to give '%s' sea bass directly to inventory (1 means failure).", roll1, _TARGET:getName())

	local firstTrySuccess
	if roll1 == 1 then
		firstTrySuccess = false
	else
		firstTrySuccess = _TARGET:getState():give("Item", "SeaBass", AMOUNT, FIRST_TRY_FLAGS)
	end

	if not firstTrySuccess then
		local secondTrySuccess
		local roll2 = math.random(1, 2)
		Log.info("Rolled a %d out of 2 when attempting to drop sea bass on ground (1 means failure).", roll2, _TARGET:getName())

		if math.random(1, 5) == 1 then
			secondTrySuccess = false
		else
			secondTrySuccess = _TARGET:getState():give("Item", "SeaBass", AMOUNT, SECOND_TRY_FLAGS)
		end

		if secondTrySuccess then
			speaker "_SELF"
			message "You take ${AMOUNT} %item{sea bass} in total, but they fall to your feet."
		else
			speaker "_SELF"
			message {
				"You're so incompetent, you dropped the %item{sea bass} into the water and a %hint{coelacanth ate them all}!",
				"Just pathetic!"
			}

			speaker "_TARGET"
			message "Did that crate just insult me?"

			speaker "_SELF"
			message "Uhh..."

			message "... ... ..."

			message "(The crate stopped talking.)"

			speaker "_TARGET"
			message "Did that crate just say it stopped talking? I'm outta here, this is freaking me out!"
		end
	else
		speaker "_SELF"
		message "You take ${AMOUNT} %hint{sea bass} and stuff them in your bag."

		speaker "_TARGET"
		message "Best not be greedy..."
	end
else
	message "There's no way I'm putting my hands in there!"
end
