speaker "Rosalind"

--if not _TARGET:getState():has("KeyItem", "PreTutorial_FoundTrees") then
if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_FoundTrees", _TARGET) and
   Utility.Peep.isInPassage(_TARGET, "Passage_Trees")
then
	defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Trees_en-US.lua"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_CraftedWeapon", _TARGET) then
	defer 
else
	message "Let's explore!"
end
