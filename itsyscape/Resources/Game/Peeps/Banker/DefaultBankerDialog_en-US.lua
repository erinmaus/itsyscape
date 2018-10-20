speaker "Banker"

TARGET_FORMAL_ADDRESS = Utility.Text.getPronoun(_TARGET, Utility.Text.FORMAL_ADDRESS)

message {
	"Welcome to the Bank of Vizier's Rock.",
	"I can help you deposit and withdraw items from your bank account.",
	"What would you like to do today, ${TARGET_FORMAL_ADDRESS}?"
}

do
	local ACCESS_BANK = option "I'd like to access my bank, please."
	local MORE_INFO   = option "What is the bank?"
	local GOOD_BYE    = option "Good-bye."

	local result = select {
		ACCESS_BANK,
		MORE_INFO,
		GOOD_BYE
	}

	if result == ACCESS_BANK then
		message "Certainly, ${TARGET_FORMAL_ADDRESS}."

		Utility.UI.openInterface(_TARGET, "Bank", true)
	elseif result == MORE_INFO then
		message {
			"The Bank of Vizier's Rock is the largest financial institute in the Realm.",
			"We wove intricate spells to protect your valuables and transport them across the Realm instantly."
		}

		message "Feel free to use our services at any time, ${TARGET_FORMAL_ADDRESS}."
	elseif result == GOOD_BYE then
		message "Have a good day, ${TARGET_FORMAL_ADDRESS}."
	end
end
