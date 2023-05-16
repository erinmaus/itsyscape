return Sequence {
	Camera:target(Player),

	Player:walkTo("Anchor_FromCrawfish"),

	Player:playAnimation("Human_Jump_1"),
	Player:lerpPosition("Anchor_FromCrawfish_Cutscene_LeftToRight", 15 / 24, 'sineEaseOut'),

	Player:playAnimation("Human_Walk_1", 'main', 1),
	Player:lerpPosition("Anchor_ToCrawfish_Cutscene_LeftToRight", 2),

	Player:playAnimation("Human_Jump_1"),
	Player:lerpPosition("Anchor_ToCrawfish_Cutscene_LeftToRight_Jump", 15 / 24, 'sineEaseOut'),

	Player:playAnimation("Human_Idle_1", 'main', 1)
}
