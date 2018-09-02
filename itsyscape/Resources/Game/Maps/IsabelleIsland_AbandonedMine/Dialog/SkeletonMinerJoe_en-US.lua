speaker "Joe"

message "Hey, I'm Skeleton Miner Joe."
message "I'm just mining my own business. He he he..."

if Utility.Item.spawnInPeepInventory(_TARGET, "CavePotato", 1) then
	message "Here's something you can use."
	message "It has lots of iron. He he he..."
end

do
	local INFO = option "Can you tell me about this place?"
	local BOSS = option "Can you tell me what's behind the scary door?"
	local result = select {
		INFO,
		BOSS
	}

	if result == INFO then
		message "An evil necromancer sought something secret in this mine."
		message {
			"He killed all us miners, and brought them back...",
			"I escaped his control, but the others didn't, and they changed."
		}
		message "They're dull and will ignore you if you disguise yourself."
		message "I heard tin cans are pretty fashionable here... He he he."
	elseif result == BOSS then
		message {
			"The miner foreman...",
			"His soul was bound by the Necromancer to protect the secret."
		}

		message "Just run away... You'll never defeat him."
	end

	message "Be safe... Leave this place."
end
