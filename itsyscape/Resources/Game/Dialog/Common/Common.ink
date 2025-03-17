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

EXTERNAL ir_play_animation(characterName, animationSlot, animationPriority, animationName, animationForced, animationTime)

== function play_animation(characterName, animationName) ==
~ return ir_play_animation(characterName, "x-dialog", 100, animationName, true, 0)

== function player_play_animation(animationName) ==
~ return play_animation(C_PLAYER, animationName)
