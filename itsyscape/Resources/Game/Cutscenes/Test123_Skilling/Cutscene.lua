local DURATION = 2

return Sequence {
	Player:playAnimation("Human_ActionBury_1", "skilling", 1),
	Player:wait(DURATION),
	Player:playAnimation("Human_ActionCook_1", "skilling", 1),
	Player:wait(DURATION),
	Player:playAnimation("Human_ActionCraft_1", "skilling", 1),
	Player:wait(DURATION),
	Player:playAnimation("Human_ActionEnchant_1", "skilling", 1),
	Player:wait(DURATION),
	Player:playAnimation("Human_ActionFletch_1", "skilling", 1),
	Player:wait(DURATION),
	Player:playAnimation("Human_ActionShake_1", "skilling", 1),
	Player:wait(DURATION),
	Player:playAnimation("Human_ActionSmelt_1", "skilling", 1),
	Player:wait(DURATION),
	Player:playAnimation("Human_ActionSmith_1", "skilling", 1),
	Player:wait(DURATION)
}
