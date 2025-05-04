INCLUDE ../Common/Equipment.ink

VAR player_name = "%person(Wren)"

CONST C_PLAYER = "_TARGET"

CONST PRONOUN_FORMAL = "formal"
CONST PRONOUN_GENDER = "gender"
CONST PRONOUN_OBJECT = "object"
CONST PRONOUN_POSSESSIVE = "possessive"
CONST PRONOUN_SUBJECT = "subject"

CONST X_MX = "formal"
CONST X_THEY = "subject"
CONST X_THEM = "object"
CONST X_THEIR = "possessive"

CONST X_ARE = "present"
CONST X_WAS = "past"
CONST X_WILL_BE = "future"

CONST TENSE_PRESENT = "present"
CONST TENSE_PAST = "past"
CONST TENSE_FUTURE = "will be"

CONST RESOURCE_KEY_ITEM = "KeyItem"
CONST RESOURCE_ITEM = "Item"

CONST STANCE_NONE = 0
CONST STANCE_AGGRESSIVE = 1
CONST STANCE_CONTROLLED = 2
CONST STANCE_DEFENSIVE = 3

LIST ir_state_flags = none
LIST ir_skill_state_flags = skill_unboosted, skill_as_level
LIST ir_item_state_flags = item_inventory, item_ignore, item_noted, item_drop, item_force_drop, item_bank, item_equipment, item_equipment_slot

EXTERNAL ir_state_has(characterName, resourceType, resource, count, flags)
EXTERNAL ir_state_count(characterName, resourceType, resource, flags)
EXTERNAL ir_state_give(characterName, resourceType, resource, count, flags)
EXTERNAL ir_state_take(characterName, resourceType, resource, count, flags)

== function player_has_key_item(keyItemID) ==
~ return ir_state_has(C_PLAYER, RESOURCE_KEY_ITEM, keyItemID, 1, ir_state_flags.none)

== function player_give_key_item(keyItemID) ==
~ return ir_state_give(C_PLAYER, RESOURCE_KEY_ITEM, keyItemID, 1, ir_state_flags.none)

== function player_take_item(itemID, count) ==
~ return ir_state_take(C_PLAYER, RESOURCE_ITEM, itemID, count, (ir_item_state_flags.item_inventory, ir_item_state_flags.item_bank))

== function player_give_item(itemID, count) ==
~ return ir_state_give(C_PLAYER, RESOURCE_ITEM, itemID, count, ir_item_state_flags.item_inventory)

== function player_give_or_drop_item(itemID, count) ==
~ return ir_state_give(C_PLAYER, RESOURCE_ITEM, itemID, count, (ir_item_state_flags.item_inventory, ir_item_state_flags.item_drop))

== function player_give_bank_item(itemID, count) ==
~ return ir_state_give(C_PLAYER, RESOURCE_ITEM, itemID, count, ir_item_state_flags.item_bank)

== function player_has_item(itemID, count) ==
~ return ir_state_has(C_PLAYER, RESOURCE_ITEM, itemID, count, ir_item_state_flags.item_inventory)

== function player_has_item_or_in_bank(itemID, count) ==
~ return ir_state_has(C_PLAYER, RESOURCE_ITEM, itemID, count, (ir_item_state_flags.item_inventory, ir_item_state_flags.item_bank))

EXTERNAL ir_has_started_quest(characterName, questName)
EXTERNAL ir_is_next_quest_step(characterName, questName, keyItemID)

== function player_has_started_quest(questName) ==
~ return ir_has_started_quest(C_PLAYER, questName)

== function player_did_quest_step(questName, keyItemID) ==
~ return player_has_key_item(keyItemID)

== function player_is_next_quest_step(questName, keyItemID) ==
~ return ir_is_next_quest_step(C_PLAYER, questName, keyItemID)

EXTERNAL ir_yell(phrase)

== function yell(phrase) ==
~ return ir_yell(phrase)

EXTERNAL ir_get_pronoun_lowercase(characterName, pronounType)
EXTERNAL ir_get_pronoun_uppercase(characterName, pronounType)
EXTERNAL ir_is_pronoun_plural(characterName)
EXTERNAL ir_get_english_be_lowercase(characterName, tense)
EXTERNAL ir_get_english_be_uppercase(characterName, tense)

== function player_get_pronoun_lowercase(pronounType) ==
~ return ir_get_pronoun_lowercase(C_PLAYER, pronounType)

== function player_get_pronoun_uppercase(pronounType) ==
~ return ir_get_pronoun_uppercase(C_PLAYER, pronounType)

== function player_is_pronoun_plural() ==
~ return ir_is_pronoun_plural(C_PLAYER)

== function player_get_english_be_lowercase(tense) ==
~ return ir_get_english_be_lowercase(C_PLAYER, tense)

== function player_get_english_be_uppercase(tense) ==
~ return ir_get_english_be_uppercase(C_PLAYER, tense)

EXTERNAL ir_get_infinite()
EXTERNAL ir_play_animation(characterName, animationSlot, animationPriority, animationName, animationForced, animationTime)

== function play_sound(characterName, animationName) ==
~ return ir_play_animation(characterName, "x-dialog-sfx", 100, animationName, true, 0)

== function play_animation(characterName, animationName) ==
~ return ir_play_animation(characterName, "x-dialog", 100, animationName, true, 0)

== function finish_animation(characterName, animationName) ==
~ return ir_play_animation(characterName, "x-dialog", 100, animationName, true, ir_get_infinite())

== function player_play_animation(animationName) ==
~ return play_animation(C_PLAYER, animationName)

== function player_play_sound(animationName) ==
~ return play_sound(C_PLAYER, animationName)

== function player_finish_animation(animationName) ==
~ return finish_animation(C_PLAYER, animationName)

EXTERNAL ir_poke_map(characterName, pokeName)
EXTERNAL ir_push_poke_map(characterName, pokeName, time)

EXTERNAL ir_poke_peep(characterName, pokeName)
EXTERNAL ir_push_poke_peep(characterName, pokeName, time)

== function poke_peep(characterName, pokeName) ==
~ return ir_poke_peep(characterName, pokeName)

== function player_poke_map(pokeName) ==
~ return ir_poke_map(C_PLAYER, pokeName)

== function player_poke(pokeName) ==
~ return ir_poke_peep(C_PLAYER, pokeName)

EXTERNAL ir_move_peep_to_anchor(characterName, anchorName)
EXTERNAL ir_orientate_peep_to_anchor(characterName, anchorName)
EXTERNAL ir_face(characterName, otherCharacterName)
EXTERNAL ir_face_away(characterName, otherCharacterName)

== function move_peep(characterName, anchorName) ==
~ return ir_move_peep_to_anchor(characterName, anchorName)

== function player_move(anchorName) ==
~ return ir_move_peep_to_anchor(C_PLAYER, anchorName)

== function orientate_peep(characterName, anchorName) ==
~ return ir_orientate_peep_to_anchor(characterName, anchorName)

== function player_orientate(anchorName) ==
~ return ir_orientate_peep_to_anchor(C_PLAYER, anchorName)

== function move_and_orientate_peep(characterName, anchorName) ==
~ temp moved = ir_move_peep_to_anchor(characterName, anchorName)
~ temp orientated = ir_orientate_peep_to_anchor(characterName, anchorName)
~ return moved && orientated

== function face_peep(characterName, otherCharacterName) ==
~ return ir_face(characterName, otherCharacterName)

== function face_away_from_peep(characterName, otherCharacterName) ==
~ return ir_face_away(characterName, otherCharacterName)

EXTERNAL ir_set_peep_mashina_state(characterName, state)

== function set_peep_mashina_state(characterName, state) ==
~ return ir_set_peep_mashina_state(characterName, state)

== function unset_peep_mashina_state(characterName) ==
~ return ir_set_peep_mashina_state(characterName, false)

EXTERNAL ir_set_external_dialog_variable(characterName, variableName, variableValue)
EXTERNAL ir_get_external_dialog_variable(characterName, variableName)

== function set_external_dialog_variable(characterName, variableName, variableValue) ==
~ return ir_set_external_dialog_variable(characterName, variableName, variableValue)

== function get_external_dialog_variable(characterName, variableName) ==
~ return ir_get_external_dialog_variable(characterName, variableName)

EXTERNAL ir_is_in_passage(characterName, passageName)

== function player_is_in_passage(passageName) ==
~ return ir_is_in_passage(C_PLAYER, passageName)

== function peep_is_in_passage(characterName, passageName) ==
~ return ir_is_in_passage(characterName, passageName)

EXTERNAL ir_get_stance(characterName)

== function player_get_stance() ==
~ return ir_get_stance(C_PLAYER)

== function get_peep_stance(characterName) ==
~ return ir_get_stance(characterName)
