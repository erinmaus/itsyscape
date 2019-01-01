speaker "Mimic"

message "Ssssss, buy minesss goodsss or getta outsss here."

do
	local BUY = option "Okay, okay!"
	local RUN = option "You freak me out!"

	local result = select {
		BUY,
		RUN
	}

	if result == BUY then
		speaker "_TARGET"
		message "Okay, okay! I give up!"

		speaker "Mimic"
		message "Yessss..."

		local mimic = _SPEAKERS["Mimic"]
		local mapObject = Utility.Peep.getMapObject(mimic)
		Utility.performAction(
			_DIRECTOR:getGameInstance(),
			"Shop",
			'world',
			_TARGET:getState(),
			_TARGET,
			mimic)
	elseif result == RUN then
		speaker "_TARGET"
		message "No, you freak me out!"

		speaker "Mimic"
		message "Getta outta here beforesss I bitesss you!"
	end
end
