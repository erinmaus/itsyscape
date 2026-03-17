VAR player_name = "%person(Wren)"

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

EXTERNAL ir_state_has(resourceType, resource, count, flags)
EXTERNAL ir_state_count(resourceType, resource, flags)

== function player_has_key_item(keyItemID) ==
~ return ir_state_has(RESOURCE_KEY_ITEM, keyItemID, 1, ir_state_flags.none)

== function player_has_item(itemID, count) ==
~ return ir_state_has(RESOURCE_ITEM, itemID, count, ir_item_state_flags.item_inventory)

== function player_has_item_or_in_bank(itemID, count) ==
~ return ir_state_has(RESOURCE_ITEM, itemID, count, (ir_item_state_flags.item_inventory, ir_item_state_flags.item_bank))

EXTERNAL ir_has_started_quest(questName)
EXTERNAL ir_is_next_quest_step(questName, keyItemID)

== function player_has_started_quest(questName) ==
~ return ir_has_started_quest(questName)

== function player_did_quest_step(questName, keyItemID) ==
~ return player_has_key_item(keyItemID)

== function player_is_next_quest_step(questName, keyItemID) ==
~ return ir_is_next_quest_step(questName, keyItemID)

EXTERNAL ir_get_external_dialog_variable(characterName, variableName)

== function get_external_dialog_variable(characterName, variableName) ==
~ return ir_get_external_dialog_variable(characterName, variableName)

EXTERNAL ir_get_relative_date_from_start(dayOffset, monthOffset, yearOffset, format)
EXTERNAL ir_get_relative_date_from_now(dayOffset, monthOffset, yearOffset, format)
EXTERNAL ir_get_relative_date_from_birthday(dayOffset, monthOffset, yearOffset, format)
EXTERNAL ir_get_relative_date_from_time(dayOffset, monthOffset, yearOffset, format, currentTime)
EXTERNAL ir_format_date(format, currentTime)
EXTERNAL ir_get_start_time()
EXTERNAL ir_get_current_time()
EXTERNAL ir_get_birthday_time()
EXTERNAL ir_get_date_component(currentTime, component)
EXTERNAL ir_to_current_time(year, month, day)
EXTERNAL ir_offset_current_time(currentTime, dayOffset, monthOffset, yearOffset)
EXTERNAL ir_get_num_days_in_month(month)
EXTERNAL ir_get_month_name(month)
EXTERNAL ir_get_day_name(day)
EXTERNAL ir_calendar_get_day(day, currentTime, insideFormat, outsideFormat)
EXTERNAL ir_common_calendar_get_day(day, currentTime)
