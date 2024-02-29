speaker "Rosalind"

if not _TARGET:getState():has("KeyItem", "PreTutorial_ChoppedTree") then
	message "Looks like there's plenty of trees to chop for wood."
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_Fished") then
	message "We should find some fish."
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_CookedFish") then
	message "We should cook the fish."
end
