INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink
INCLUDE ../VizierRockKnight/Common.ink

EXTERNAL quest_tutorial_orlando_has_lit_fire()
EXTERNAL quest_tutorial_orlando_all_dummies_dead()
EXTERNAL quest_tutorial_orlando_has_dummies()

VAR quest_tutorial_main_starting_player_class = WEAPON_STYLE_NONE

// Initial conversation.
VAR quest_tutorial_main_started_got_up = false
VAR quest_tutorial_main_started_asked_what_happened = false
VAR quest_tutorial_main_started_asked_where_am_i = false
VAR quest_tutorial_main_started_asked_what_is_going_on = false
VAR quest_tutorial_main_equipped_items_thought = false

// Scout fight.
VAR quest_tutorial_main_player_talked_about_seeing_ser_commander = false
VAR quest_tutorial_main_player_is_scouting = false
VAR quest_tutorial_main_player_found_yendorian_scout = false
VAR quest_tutorial_main_talked_about_flare = false
VAR quest_tutorial_main_defused_scout_argument = false
VAR quest_tutorial_main_inflamed_scout_argument = false
VAR quest_tutorial_main_ignored_scout_argument = false

// Yenderhound stuff.
VAR quest_tutorial_main_player_found_yendorhounds = false

// Dummy stuff.
VAR quest_tutorial_main_did_place_dummy = false

// Keelhauler stuff.
VAR quest_tutorial_main_keelhauler_double_deflect = false

== function quest_tutorial_get_class_name() ==
{
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: ~ return "wizard"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: ~ return "archer"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: ~ return "warrior"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_SAILING: ~ return "sailor"
  - else: ~ return "loaf"
}

== function quest_tutorial_get_offensive_power_name() ==
{
  - player_get_stance() == STANCE_DEFENSIVE: ~ return "Bash"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: ~ return "Corrupt"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: ~ return "Snipe"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: ~ return "Tornado"
}

== function quest_tutorial_get_defensive_power_name() ==
{
  - player_get_stance() == STANCE_DEFENSIVE: ~ return "Bash"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: ~ return "Confuse"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: ~ return "Shockwave"
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: ~ return "Parry"
}

== function quest_tutorial_did_exhaust_options() ==
~ return quest_tutorial_main_started_asked_what_happened && quest_tutorial_main_started_asked_where_am_i && quest_tutorial_main_started_asked_what_is_going_on

== quest_tutorial_main_start_out_of_bounds ==
# speaker={C_ORLANDO}
# background=000000
Oi! Don't get ahead of yourself, {player_name}! Get back here.

# speaker={C_PLAYER}
# background=000000
Very well...

%empty()

~ player_move("Anchor_Spawn")

# speaker={C_ORLANDO}
Uh, so, let's see, where were we...

# background=none
%empty()

-> quest_tutorial_main.table_of_contents

== quest_tutorial_peak_out_of_bounds ==
# speaker={C_ORLANDO}
# background=000000
Oi! It's too dangerous to keep going! We gotta see how many Yendorians are out there! Get back here.

# speaker={C_PLAYER}
# background=000000
Okay...

%empty()

~ player_move("Anchor_PeakEntrance")

# background=none
%empty()

-> quest_tutorial_main.table_of_contents

== quest_tutorial_main ==

# speaker={C_PLAYER}
~ temp did_kill_yenderhounds = player_did_quest_step("Tutorial", "Tutorial_DefeatedYenderhounds")
~ temp in_fishing_area = player_is_in_passage("Passage_FishingArea") && did_kill_yenderhounds
* {in_fishing_area} [(Ask about fishing).] %person(Ser Orlando), I have a question about fishing...
  -> quest_tutorial_main_fish
* {in_fishing_area} [(Talk about something else.)]
  -> table_of_contents
* {in_fishing_area} [(Don't say anything.)]
  -> DONE
* -> table_of_contents

= table_of_contents
{
    - !player_has_started_quest("Tutorial"): -> quest_tutorial_main_started
    - player_is_next_quest_step("Tutorial", "Tutorial_GatheredItems"): -> quest_tutorial_main_gather_items
    - player_is_next_quest_step("Tutorial", "Tutorial_EquippedItems"): -> quest_tutorial_main_equipped_items
    - player_is_next_quest_step("Tutorial", "Tutorial_MetSerCommander") || player_is_next_quest_step("Tutorial", "Tutorial_FoundScout"): -> quest_tutorial_main_scout
    - player_is_next_quest_step("Tutorial", "Tutorial_DefeatedScout"): -> quest_tutorial_main_defeat_scout
    - player_is_next_quest_step("Tutorial", "Tutorial_FoundYenderhounds"): -> quest_tutorial_main_find_yenderhounds
    - player_is_next_quest_step("Tutorial", "Tutorial_DefeatedYenderhounds"): -> quest_tutorial_main_defeat_yenderhounds
    - player_is_next_quest_step("Tutorial", "Tutorial_FishedLightningStormfish"): -> quest_tutorial_main_fish
    - player_is_next_quest_step("Tutorial", "Tutorial_FoundPeak"): -> quest_tutorial_ascend_peak
    - player_is_next_quest_step("Tutorial", "Tutorial_FoundYendorians"): -> quest_tutorial_ascend_peak
    - player_is_next_quest_step("Tutorial", "Tutorial_DefeatedKeelhauler"): -> quest_tutorial_fight_keelhauler
    - else: Let's get going! #speaker={C_ORLANDO}
}

== quest_tutorial_main_started ==
~ player_finish_animation("Human_Die_1")
~ player_play_sound("SFX_LightningExplosion")

# speaker={C_ORLANDO}
# background=000000
AAAAAAAAH! WHAT WAS THAT?!

# speaker={C_ORLANDO}
# background=000000
OI! {yell(player_name)}! ARE YOU OK?! HELP! {yell(player_get_pronoun_uppercase(X_THEY))} {yell(player_get_english_be_uppercase(X_ARE))} IN TROUBLE!

# speaker={C_PLAYER}
# background=none
...

%empty()

~ player_play_animation("Human_Dazed")
~ play_animation(C_ORLANDO, "Human_ActionShake_1")

# speaker={C_ORLANDO}
{yell(player_name)}! TALK TO ME!

~ quest_tutorial_main_started_got_up = false

%empty()

~ player_poke_map("showDialogUIHint")

-> loop

= loop

+ {!quest_tutorial_main_started_got_up} [...]
  -> dot_dot_dot
* [What happened?]
  -> what_happened
* [Where am I?]
  -> where_am_i
* [What's going on?]
  -> what_is_going_on
* {quest_tutorial_main_started_got_up && !quest_tutorial_did_exhaust_options()} [Nevermind. Let's get going.]
  -> let_us_get_going
* -> let_us_get_going

= dot_dot_dot
~ player_play_animation("Human_Dazed")
~ play_animation(C_ORLANDO, "Human_ActionShake_1")

# speaker={C_ORLANDO}
{{player_name}! Get up!|Come on! Wake up! I can see you're breathing!|Are you in a coma?! Gods!}

-> loop

= what_happened
-> quest_tutorial_main_started_get_up ->
~ quest_tutorial_main_started_asked_what_happened = true

# speaker={C_PLAYER}
Ugh... So what in the Realm happened?

# speaker={C_ORLANDO}
I was on my way to get you when a freak lightning bolt hit the gunpowder barrels and then BOOM! 

# speaker={C_ORLANDO}
But gods! You survived! Though... You look like you were knocked into next year...

# speaker={C_ORLANDO}
We'd be fresh meat for Yendorians out here without your smarts and skills...

# speaker={C_ORLANDO}
You're the only %hint(engineer and {quest_tutorial_get_class_name()}) here!

# speaker={C_ORLANDO}
OH! And, um, I mean, actually, it would be worse for you, of course, because, like, y'know, you'd be... dead...

-> loop

= where_am_i
-> quest_tutorial_main_started_get_up ->
~ quest_tutorial_main_started_asked_where_am_i = true

# speaker={C_PLAYER}
Eh... Where am I?

# speaker={C_ORLANDO}
We're gonna need to get you checked out as soon as we get back to %location(Isabelle Island)...

# speaker={C_ORLANDO}
But... Right now we're pretty far from anywheres. We're at %location(Humanity's Edge). The last island of the %location(Realm) before %person(Yendor's) dead city, %location(R'lyeh)...

# speaker={C_PLAYER}
Uh... Who is %person(Yendor)? And what is %location(R'lyeh)?

# speaker={C_ORLANDO}
Have you lost your mind?! You're worse off than I thought!

# speaker={C_ORLANDO}
Well, everyone knows about %person(Yendor), She's... %hint(an Old One). The god of death. I'd rather not say much else this close to %location(R'lyeh)...

# speaker={C_PLAYER}
{quest_tutorial_main_started_asked_what_is_going_on: A god... So She could be killed by the hellfire harpoon?}

# speaker={C_ORLANDO}
{quest_tutorial_main_started_asked_what_is_going_on: Yes, exactly! You're getting it!}

# speaker={C_ORLANDO}
And R'lyeh, well, that's it. We don't what what R'lyeh is. No human has sailed further south than %location(Humanity's Edge) and survived.

# speaker={C_ORLANDO}
Not even the %hint(Black Tentacles) are that crazy.

# speaker={C_ORLANDO}
%person(Yendor's) loons say there's a big city under those waves... A city bigger than the Realm!

-> loop

= what_is_going_on
-> quest_tutorial_main_started_get_up ->

~ quest_tutorial_main_started_asked_what_is_going_on = true

# speaker={C_PLAYER}
Um... So what's going on?

# speaker={C_ORLANDO}
What the hells? Are you sure you don't got amnesia?

# speaker={C_ORLANDO}
We're building %hint(Hellfire harpoons)! And a harpoon launcher capable of shooting them!

# speaker={C_PLAYER}
That's right... The hellfire harpoon. The schematics... I know them by heart.

# speaker={C_ORLANDO}
Seems you're getting some sense of things back!

# speaker={C_PLAYER}
The hellfire harpoon... It can kill gods, right? {quest_tutorial_main_started_asked_where_am_i: Like %person(Yendor)?}

# speaker={C_ORLANDO}
Yes! Exactly! We're building it out here for secrecy, and, well, because if we mess up...

# speaker={C_ORLANDO}
According to my sis... Uh! I mean! %person(Lady Isabelle)! If the calculations are a little off, the results could be apocalyp-tickle!

# speaker={C_PLAYER}
"Apocalyp-tickle?" ... Do you mean "apocalyptical...?"

# speaker={C_ORLANDO}
Uh... Yes... I... do... That's what I meant!

# speaker={C_PLAYER}
But yes, you're right. We'll be ash in a mile-wide crater if the chain reaction isn't exactly as I calculated...

-> loop

= let_us_get_going

# speaker={C_PLAYER}
Eh, well, no time to waste. Let's get going!

~ player_give_key_item("Tutorial_Start")

{quest_tutorial_did_exhaust_options(): -> quest_tutorial_main_gather_items}

# speaker={C_ORLANDO}
Are you sure you're ready? You don't got any more questions?

# speaker={C_PLAYER}
* Yes, I'm absolutely sure.
  -> confirm_let_us_get_going
* Um, actually, no... Let me ask another question.
  -> loop

= confirm_let_us_get_going

# speaker={C_ORLANDO}
If you say so!

-> quest_tutorial_main

== quest_tutorial_main_started_get_up ==
{
    - !quest_tutorial_main_started_got_up: -> get_up
    - else: -> got_up
}

= get_up
~ quest_tutorial_main_started_got_up = true
~ player_play_animation("Human_Resurrect_1")

# speaker={C_PLAYER}
Ouch... My head...

# speaker={C_ORLANDO}
THANK THE GODS YOU'RE ALIVE, {yell(player_name)}!

-> got_up

= got_up

->->

== quest_tutorial_main_gather_items ==

~ player_give_key_item("Tutorial_Start")

# speaker={C_ORLANDO}
Looks like you dropped all your stuff to the ground when you got hit!

# speaker={C_ORLANDO}
Let's pick it at all up, %person({player_get_pronoun_uppercase(X_MX)}) {player_name}.

-> DONE

== quest_tutorial_main_equipped_items ==

{
  - quest_tutorial_main_equipped_items_thought: -> ask_for_help
  - else: -> have_thought
}

= have_thought

~ quest_tutorial_main_equipped_items_thought = true

# speaker={C_PLAYER}
Great, that's everything... Let me gear up and equip the armor and weapon.

# speaker={C_ORLANDO}
Eek! I'll look away!

~ face_away_from_peep(C_ORLANDO, C_PLAYER)
~ set_peep_mashina_state(C_ORLANDO, "tutorial-look-away-from-player")

%empty()

~ player_poke_map("showEquipItemsTutorial")

-> DONE

= ask_for_help

~ face_away_from_peep(C_ORLANDO, C_PLAYER)
~ set_peep_mashina_state(C_ORLANDO, "tutorial-look-away-from-player")

# speaker={C_PLAYER}
# background=none
* [(Ask %person(Ser Orlando) for help.)] Actually, %person(Ser Orlando), can you help me?
  -> get_help
* [(Equip the gear on your own.)] (I'll figure this out...)
  -> DONE

= get_help

# speaker={C_ORLANDO}
Um.... Sure, ok, I'll... uh.... try! This might be kinda difficult with me looking away and all...

%empty()

~ player_poke_map("showEquipItemsTutorial")

-> DONE

== quest_tutorial_main_scout ==

{
  - !quest_tutorial_main_player_talked_about_seeing_ser_commander: -> got_equipment
  - !get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_tagged_along"): -> meet_ser_commander
  - quest_tutorial_main_player_talked_about_seeing_ser_commander: -> scout
}

= got_equipment

# speaker={C_ORLANDO}
That's the %person({player_get_pronoun_uppercase(X_MX)}) {player_name} I know. You look terrifying!

# speaker={C_ORLANDO}
Now that you're all geared up, we can pick up where we left off.

# speaker={C_ORLANDO}
Let's go meet with the %person(Ser Commander) at the entrance of the camp and scout for pesky pirates... or worse, Yendorians!

~ quest_tutorial_main_player_talked_about_seeing_ser_commander = true

-> DONE

= meet_ser_commander
Let's go meet with the %person(Ser Commander) at the entrance of the camp!

-> DONE

= scout

# speaker={C_ORLANDO}
Let's look for foes! And let's pray we don't find any!

-> DONE

== quest_tutorial_main_defeat_scout ==

{quest_tutorial_main_player_found_yendorian_scout: -> defeat_scout_short}

# speaker={C_ORLANDO}
Look ahead! There's a scout! AND IT'S A YENDORIAN! Why couldn't it be a pirate?!

# speaker={C_VIZIER_ROCK_KNIGHT}
Silence, boy!

# speaker={C_ORLANDO}
...I'll let that slide. We'll need to take him out before he can signal the others.

# speaker={C_PLAYER}
And how do we do that?

# speaker={C_VIZIER_ROCK_KNIGHT}
You tell us, bookworm.

# speaker={C_PLAYER}
...

# speaker={C_VIZIER_ROCK_KNIGHT}
We have to slay him.

# speaker={C_ORLANDO}
Well, to put it... more nicer, we need to kill him before he alerts the others. Let's go!

~ quest_tutorial_main_player_found_yendorian_scout = true

-> DONE

= defeat_scout_short

# speaker={C_ORLANDO}
Let's kill that guy!

-> DONE

== quest_tutorial_main_scout_argument ==

# speaker={C_ORLANDO}
We're too slow! He sent up a flare!

# speaker={C_VIZIER_ROCK_KNIGHT}
Gods damn him... Hope he learns to love his %hint(afterlife of eternal drowning). Let us push forward and discover the Yendorians' numbers.

# speaker={C_ORLANDO}
%person(Ser Commander), do I need to remind you? Y'know, remind you that you're... not in charge?

# speaker={C_VIZIER_ROCK_KNIGHT}
...

# speaker={C_VIZIER_ROCK_KNIGHT}
Understood. Grant us your wisdom, Your Hungriness.

# speaker={C_ORLANDO}
Keep your jabs to yourself or I will have you reprimanded. %person(Lady Isabelle) won't take kindly to this abuse. She...

# speaker={C_PLAYER}
* [(Course-correct the banter.)] You're both being belligerent! Can we focus on the task at hand?
  -> course_correct
* [(Add fuel to the fire.)]
  -> shut_them_up
* [(Listen for the tea.)] (Let's see what happens...)
  -> listen

= course_correct

~ quest_tutorial_main_defused_scout_argument = true
{get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_defused_situation"): -> course_correct_two_in_a_row}

# speaker={C_ORLANDO}
...I agree, %person({player_get_pronoun_uppercase(X_MX)}) {player_name}.

# speaker={C_VIZIER_ROCK_KNIGHT}
Bah! {player_get_pronoun_uppercase(X_THEY)} {player_get_english_be_lowercase(X_ARE)} right.

-> continue

= course_correct_two_in_a_row

# speaker={C_ORLANDO}
...I agree. %person({player_get_pronoun_uppercase(X_MX)}) {player_name}, you're more diplomatic than I remembered.

# speaker={C_VIZIER_ROCK_KNIGHT}
Bah! {player_get_pronoun_uppercase(X_THEY)} are right. Maybe {player_get_pronoun_lowercase(X_THEY)} {player_get_english_be_lowercase(X_ARE)} more than just a bookworm...

-> continue

= shut_them_up

~ quest_tutorial_main_inflamed_scout_argument = true

# speaker={C_ORLANDO}
...controls more than...

# speaker={C_PLAYER}
You blabbering babies, if you want to fight with words then go write poetry!

# speaker={C_PLAYER}
Otherwise, settle this with swords!

{get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_inflamed_situation"): -> shut_them_up_two_in_a_row}

# speaker={C_VIZIER_ROCK_KNIGHT}
...

# speaker={C_ORLANDO}
...

# speaker={C_PLAYER}
Oh, now you're both speechless? Good! Let's focus on the task at hand.

-> continue

= shut_them_up_two_in_a_row

# speaker={C_VIZIER_ROCK_KNIGHT}
...feisty, are we? You've got a sharp wit about yourself.

# speaker={C_ORLANDO}
%person({player_get_pronoun_uppercase(X_MX)}) {player_name}, you're.... right, I s'pose. Sorry, %person(Ser Commander).

# speaker={C_VIZIER_ROCK_KNIGHT}
And... apologies for my conduct, %person(Ser Orlando).

# speaker={C_PLAYER}
Oh, wonderful! Now that you've both made up and hugged, let's focus on the task at hand.

-> continue

= listen

~ quest_tutorial_main_ignored_scout_argument = true

# speaker={C_ORLANDO}
...controls %hint(more than) %person(Vizier-King Yohn's) %hint(purse). Or do I got to remind you how much the Vizier-King owes her?

# speaker={C_ORLANDO}
Or how much the Realm owes her?

# speaker={C_VIZIER_ROCK_KNIGHT}
...

# speaker={C_ORLANDO}
Like I thought.

# speaker={C_PLAYER}
(Who is this %person(Lady Isabelle)..? Curses! Why can't I remember anything?!)

{get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_ignored_situation"): -> listen_two_in_a_row}

# speaker={C_VIZIER_ROCK_KNIGHT}
Very well. Unfortunately, with the threat of Yendorians, we will have to work together.

# speaker={C_VIZIER_ROCK_KNIGHT}
Let us keep the jests and jabs to ourselves and make peace for the time being.

# speaker={C_ORLANDO}
...yes. You're right. Let me see where I was... That's right!

-> continue

= listen_two_in_a_row

# speaker={C_ORLANDO}
...%person({player_get_pronoun_uppercase(X_MX)}) {player_name}, are you ok? You've been quiet.

# speaker={C_PLAYER}
In my professional opinion, you both should make amends and move on.

# speaker={C_ORLANDO}
Ugh... okay! I'm sorry, %person(Ser Commander). Let's just drop it.

# speaker={C_VIZIER_ROCK_KNIGHT}
Very well. I agree. Apologies for my conduct, as well, %person(Ser Orlando).

# speaker={C_PLAYER}
So... What was your plan, %person(Ser Orlando)?

-> continue

= continue

# speaker={C_ORLANDO}
So! There's a peak some ways ahead that'll give us a great vantage point.

# speaker={C_ORLANDO}
I doubt the Yendorians have reached it.

# speaker={C_ORLANDO}
The scout probably swam around the island and made landfall after hearing our camp.

# speaker={C_ORLANDO}
Probably half the ocean heard that gunpowder boom...

# speaker={C_VIZIER_ROCK_KNIGHT}
For once, you make a smidgen of sense, %person(Ser Orlando).

# speaker={C_VIZIER_ROCK_KNIGHT}
Yendorians are a sea folk by nature; they loathe land, and they hate heights more.

# speaker={C_ORLANDO}
Exactly! We should get to that peak. We'll be able to see for miles. Let's go!

-> DONE

== quest_tutorial_main_find_yenderhounds ==

# speaker={C_ORLANDO}
We need to climb the island's peak to learn how many Yendorians there are.

-> DONE

= spotted

# speaker={C_ORLANDO}
Look! Some Yenderhounds!

# speaker={C_VIZIER_ROCK_KNIGHT}
Gods... It's a pack of them. I hope you're all prepared.

# speaker={C_ORLANDO}
We must kill them now. If they make their way to the camp... I don't wanna think about it!

-> DONE

== quest_tutorial_main_defeat_yenderhounds ==

# speaker={C_ORLANDO}
It's no time to talk! Kill the Yenderhounds!

-> DONE

= worst_scenario

-> victory_intro ->

# speaker={C_PLAYER}
Huff... Huff... I... can see the light...

# speaker={C_VIZIER_ROCK_KNIGHT}
Gods, bookworm! You are just seeing the fireflies, I fear. Pull yourself together.

# speaker={C_ORLANDO}
You took a beating! And you don't have any food to heal yourself.

-> victory_outro

= needs_to_eat

-> victory_intro ->

# speaker={C_PLAYER}
Ugh... Ouch... I'm in so much pain!

# speaker={C_ORLANDO}
Those Yenderhounds were vicious! You need to heal up.

%empty()
~ player_poke_map("showEatHint")

-> DONE

= needs_to_eat_again

# speaker={C_ORLANDO}
You took a beating! You gotta heal!

%empty()
~ player_poke_map("showEatHint")

-> DONE

= did_eat 

# speaker={C_ORLANDO}
Foods cooked over a camp fire, like fish, only heal.

# speaker={C_ORLANDO}
But foods that need recipes and a cooking gear heal more and also buff your stats!

# speaker={C_ORLANDO}
Cooking is amazing! It turns boring old plants and animals into pieces of art!

-> victory_outro

= good_job

-> victory_intro ->

# speaker={C_PLAYER}
That was bad...

# speaker={C_ORLANDO}
It's amazing you weren't hurt at all!

-> victory_outro

= victory_intro

# speaker={C_ORLANDO}
Good job, everyone!

# speaker={C_VIZIER_ROCK_KNIGHT}
Verily. Those mutts spread us thin by attacking each of us individually.

->->

= victory_outro

# speaker={C_ORLANDO}
We should get going... But...

# speaker={C_VIZIER_ROCK_KNIGHT}
"...but?"

# speaker={C_ORLANDO}
I'm fresh out food...! We gotta re-supply. Thanks-fully there's a fishing spot nearby.

# speaker={C_VIZIER_ROCK_KNIGHT}
Seriously? %item(Lightning stormfish)? You expect me to eat some godsforsaken R'lyhen bottomfeeder?

# speaker={C_ORLANDO}
...

# speaker={C_ORLANDO}
I didn't say that. Me and %person({player_get_pronoun_uppercase(X_MX)}) {player_name} will resupply.

# speaker={C_ORLANDO}
You can just stand there and look stupid.

# speaker={C_VIZIER_ROCK_KNIGHT}
...

# speaker={C_PLAYER}
We don't have fishing gear though... And where can we even cook the fish out here?

# speaker={C_ORLANDO}
I got ya! A knight like me is always prepared!

%empty()

~ play_animation(C_ORLANDO, "Human_ActionGive_1")
~ player_poke_map("giveTutorialFishingGear")
~ set_peep_mashina_state(C_VIZIER_ROCK_KNIGHT, "tutorial-stand-guard")

# speaker={C_ORLANDO}
(Ser Orlando hands you an %item(adamant fishing) rod and some %item(water worms).)

# speaker={C_ORLANDO}
I will get the fire started! If you run out of %item(water worms), I'll give you more.

# speaker={C_VIZIER_ROCK_KNIGHT}
Going on a fishing trip when a Yendorian squad, or worse, could be marching on the camp as we speak?

# speaker={C_VIZIER_ROCK_KNIGHT}
Reckless!

# speaker={C_ORLANDO}
Let me make this clear, %person(Ser Commander). I'm in charge. You're not.

# speaker={C_ORLANDO}
You will stand guard. We will make this quick. I'd rather us take a minute to stock back up and not die in vain.

# speaker={C_VIZIER_ROCK_KNIGHT}
Hmmph!

# speaker={C_ORLANDO}
%person({player_get_pronoun_uppercase(X_MX)}) {player_name}, let me know when you've fished at least two stormfish.

# speaker={C_PLAYER}
Sure thing!

-> quest_tutorial_main_fish

== quest_tutorial_drop_items ==

# speaker={C_ORLANDO}
...but your bag is full! Do you need help making room?

# speaker={C_PLAYER}
* Yes[.], I have no idea what I'm doing!
  -> give_drop_item_tutorial
* No[.], I'll make room myself!
  -> do_not_give_drop_item_tutorial

= give_drop_item_tutorial

# speaker={C_ORLANDO}
Got you! First things first...

%empty()

~ player_poke_map("showDropItemTutorial")

-> DONE

= do_not_give_drop_item_tutorial

# speaker={C_ORLANDO}
Sure thing! Lemme know when you got some space in your bag.

->->

== quest_tutorial_main_fish ==

{
  - not player_has_item("WaterWorm", 50): -> give_bait
  - else: -> loop
}

= give_bait

# speaker={C_ORLANDO}
Looks like you're low on bait.

%empty()

{not player_give_item("WaterWorm", 150): -> quest_tutorial_drop_items ->}
~ play_animation(C_ORLANDO, "Human_ActionGive_1")

-> loop

= loop

~ temp can_light_fire = player_did_quest_step("Tutorial", "Tutorial_FishedLightningStormfish") && not quest_tutorial_orlando_has_lit_fire()

* [(Ask for help on how to fish.)]
  -> ask_for_help
* {!can_light_fire} [(Go fishing!)]
  -> go_fishing
* [(Ask for help dropping items.)] %person(Ser Orlando), I want to clear some junk out of my bag. Can you help me?
  -> quest_tutorial_drop_items.give_drop_item_tutorial
* {can_light_fire} [(Ask %person(Ser Orlando) to light a fire.)] %person(Ser Orlando), I need a fire to cook on. Can you help me?
  -> light_fire

= ask_for_help

# speaker={C_PLAYER}
I can't remember the last time I fished... Can you help me?

# speaker={C_ORLANDO}
Sure thing!

%empty()

~ set_peep_mashina_state(C_ORLANDO, "tutorial-fish")
~ player_poke_map("showFishTutorial")

-> DONE

= go_fishing
(Let me go fish up some %item(lightning stormfish)!)

-> DONE

= done_fishing

# speaker={C_ORLANDO}
Looks like you've fished up two %item(lightning stormfish)!

%empty()

~ play_animation(C_ORLANDO, "Human_ActionGive_1")
~ player_give_item("LightningStormfish", 3)

# speaker={C_ORLANDO}
Here's another few raw %item(lightning stormfish) I found... uh, somewhere.

# speaker={C_PLAYER}
I did, but... How do we cook them?

# speaker={C_ORLANDO}
Like I said, a knight like me is always prepared! I'll chop down a tree and light a fire.

# speaker={C_ORLANDO}
Then we can cook the %item(stormfish) easy-peasy. Fish isn't hard to cook. Some heat, some time, and... done!

-> DONE

= light_fire

# speaker={C_ORLANDO}
Sure thing! Lemme get on that.

%empty()

~ set_peep_mashina_state(C_ORLANDO, "tutorial-chop")

-> DONE

== quest_tutorial_cook_fish ==

= done_cooking

# speaker={C_ORLANDO}
If you want to keep fishing, go on ahead!

# speaker={C_ORLANDO}
But if you're comfy... uh, I mean, um,  confident... enough, we can get going.

# speaker={C_ORLANDO}
The peak isn't much further ahead. Let's go!

# speaker={C_VIZIER_ROCK_KNIGHT}
Finally. We're going again. Thank the gods.

# speaker={C_ORLANDO}
I'll just pretend I didn't hear that, %person(Ser Commander).

-> DONE

== quest_tutorial_combat ==

= can_use_rite

# speaker={C_ORLANDO}
Y'know, you can use rites, right?!

# speaker={C_ORLANDO}
Rites of malice deal more damage and rites of bulwark lower damage! They also got a bunch of other cool effects!

# speaker={C_ORLANDO}
You can dodge attacks, slow down your foe, get them stuck, lower their stats, and a ton of other stuff.

# speaker={C_ORLANDO}
Since rites are kinda, uh, emotional... they require a certain amount of zeal.

# speaker={C_ORLANDO}
You get zeal from fighting good. The better you're doing, the more zeal you'll get!

# speaker={C_ORLANDO}
And after you use a rite, it needs to recharge. So you can't use the same rite over'n'over again!

# speaker={C_ORLANDO}
The cooler, uh, ... I mean stronger the rite, the more zeal it takes and the longer it recharges!

# speaker={C_ORLANDO}
Lemme show you a cool rite...

{
  - player_get_stance() == STANCE_DEFENSIVE: -> use_bash
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: -> use_corrupt
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: -> use_snipe
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: -> use_tornado
}

= use_bash

# speaker={C_ORLANDO}
I'll show you how to use %hint(Bash) since you're using a %hint(defensive stance)! Bash flips the idea of defense on its head and deals damage.

-> DONE

= use_corrupt

# speaker={C_ORLANDO}
I'll show you how to use %hint(Corrupt) since you're a wizard, %person({player_get_pronoun_uppercase(X_MX)}) {player_name}! That one's pretty powerful, it deals lots of damage over time, not all at once!

-> DONE

= use_snipe

# speaker={C_ORLANDO}
I'll show you how to use %hint(Snipe)! It never misses and deals extra damage, but your next attack will be slower!

-> DONE

= use_tornado

# speaker={C_ORLANDO}
I'll show you how to use %hint(Tornado)! It's my fave!

# speaker={C_ORLANDO}
You spin in a big circle and hit everyone around you. Good if you got ganged up on!

-> DONE

= preemptively_used_rite

# speaker={C_ORLANDO}
Wow, awesome job using a rite!

# speaker={C_ORLANDO}
Lemme show you a really cool rite when you're ready!

-> DONE

= correct_rite

# speaker={C_ORLANDO}
Good job! You aced it!

# speaker={C_ORLANDO}
Go on and try some other rites, if ya want!

-> DONE

= incorrect_rite

# speaker={C_ORLANDO}
Wow! Improvising, huh?! That was SO COOL... But you need to use %hint({quest_tutorial_get_offensive_power_name()})!

# speaker={C_ORLANDO}
Try again!

-> DONE

= did_not_use_rite

# speaker={C_ORLANDO}
It's okay, take your time! Use %hint({quest_tutorial_get_offensive_power_name()}) when you're ready!

-> DONE

= can_deflect

# speaker={C_ORLANDO}
Look! The Yendorian is trying to use a rite! That's BAD!

# speaker={C_ORLANDO}
I'll slow him down, you gotta deflect it!

-> deflect_switch

= deflect_switch

# speaker={C_ORLANDO}

{
  - player_get_stance() == STANCE_DEFENSIVE: -> use_bash_again
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: -> use_confuse
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: -> use_shockwave
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: -> use_parry
}

= use_bash_again 

# speaker={C_ORLANDO}
Use %hint(Bash) again since you're using a %hint(defensive stance)!

# speaker={C_ORLANDO}
Do you want me to show you how to use %hint(Bash) again?

-> help_using_defensive_rite

= use_confuse

# speaker={C_ORLANDO}
This time, use %hint(Confuse)! This will stop your foe from using their next rite or special attack. It also lowers their accuracy!

# speaker={C_ORLANDO}
Do you want me to show you how to use %hint(Confuse)?

-> help_using_defensive_rite

= use_shockwave

# speaker={C_ORLANDO}
This time, use %hint(Shockwave)! This will stop your foe from using their next rite or special attack. It also stuns them!

# speaker={C_ORLANDO}
Do you want me to show you how to use %hint(Shockwave)?

-> help_using_defensive_rite

= use_parry

# speaker={C_ORLANDO}
This time, use %hint(Parry)! This one is SO COOL! It will stop your foe from using their next rite or special attack. It also prevents your foe's next attack from hurting you!

# speaker={C_ORLANDO}
Do you want me to show you how to use %hint(Parry)?

-> help_using_defensive_rite

= help_using_defensive_rite

# speaker={C_PLAYER}
* Yes![] I need help!
  -> show_how_to_use_defensive_rite
* No![] I got this!
  -> DONE

= show_how_to_use_defensive_rite

# speaker={C_ORLANDO}
Okay, great! First things first...

%empty()
~ player_poke_map("showDeflectHint")

-> DONE

= did_not_deflect

# speaker={C_ORLANDO}
C'mon, you need to use a rite to counter the Yendorian!

-> deflect_switch

= correct_deflect

# speaker={C_ORLANDO}
That... was... AWESOME! You aced it! 

-> DONE

= incorrect_deflect

# speaker={C_ORLANDO}
Uh, that was cool and all, but... That's not the right rite! You need to use %hint({quest_tutorial_get_defensive_power_name()})!

# speaker={C_ORLANDO}
Let's try again!

-> DONE

= attack_dummy_again

# speaker={C_ORLANDO}
Go on and attack the Yendorian!

-> DONE

== quest_tutorial_main_found_peak ==

# speaker={C_ORLANDO}
Looks like we found the peak!

# speaker={C_VIZIER_ROCK_KNIGHT}
Only took an eon after you lot getting distracted.

# speaker={C_ORLANDO}
...Huh, did I hear someone? Nah, must just be the ocean...

# speaker={C_VIZIER_ROCK_KNIGHT}
...

# speaker={C_ORLANDO}
Anyway, let's get going. We're almost there.

-> DONE

== quest_tutorial_reached_peak ==

# speaker={C_ORLANDO}
# background=000000
Looks like we reached the peak!

# background=none
%empty()

~ player_poke_map("tutorialReachPeak")

-> DONE

= found_pirates

# speaker={C_ORLANDO}
GODS! Yendorians AND the Black Tentacles?! This is CRAZY!

* [(Ask about the Black Tentacles.)] Uh... Who are the Black Tentacles?
  -> who_are_black_tentacles
* [(Keep listening.)]
  -> get_knights

= get_knights

# speaker={C_ORLANDO}
Let's go get the knights from the camp! We'll need 'em all.

# speaker={C_VIZIER_ROCK_KNIGHT}
On it.

-> DONE

= who_are_black_tentacles

# speaker={C_VIZIER_ROCK_KNIGHT}
You're joking. You've gotta be joking.

# speaker={C_ORLANDO}
Stop being mean to {player_get_pronoun_lowercase(X_THEM)}, %person(Ser Commander)!

# speaker={C_VIZIER_ROCK_KNIGHT}
...{player_get_pronoun_uppercase(X_THEY)} need to get {player_get_pronoun_lowercase(X_THEIR)} head looked at.

# speaker={C_PLAYER}
{
  - get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_defused_situation") && quest_tutorial_main_defused_scout_argument: -> stop_bickering
  - get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_inflamed_situation") && quest_tutorial_main_inflamed_scout_argument: -> argue
  - get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_ignored_situation") && quest_tutorial_main_ignored_scout_argument: -> stay_silent
  - else: Um... -> explain_black_tentacles
}

= stop_bickering

# speaker={C_PLAYER}
We know. Let's just stop bickering and move on.

# speaker={C_VIZIER_ROCK_KNIGHT}
...

# speaker={C_ORLANDO}
%person({player_get_pronoun_uppercase(X_MX)}) {player_name} is right.

-> explain_black_tentacles

= argue

# speaker={C_PLAYER}
Says the guy with more concussions than brain cells.

# speaker={C_VIZIER_ROCK_KNIGHT}
...

# speaker={C_ORLANDO}
C'mon %person(Ser Commander) and %person({player_get_pronoun_uppercase(X_MX)}) {player_name}! You're acting like some children! Anyway...

-> explain_black_tentacles

= stay_silent

# speaker={C_PLAYER}
...

# speaker={C_ORLANDO}
C'mon %person(Ser Commander), stop it! Anyway...

-> explain_black_tentacles

= explain_black_tentacles

# speaker={C_ORLANDO}
The Black Tentacles are the meanest pirates to sail the seas. Their captain, %person(Raven), is legendary... for being brutal to her enemies.

# speaker={C_ORLANDO}
She wants to become the legendary Pirate Queen... And there hasn't been a Pirate King or Queen in a thousand years!

# speaker={C_ORLANDO}
I've had to fight them in the past. They just HATE %person(Lady Isabelle)! They've never gotten one up on her fleet.

-> get_knights

== quest_tutorial_ascend_peak ==

{
  - player_is_in_passage("Passage_Peak"): -> is_at_peak
  - else: -> is_not_at_peak
}

= is_at_peak

# speaker={C_ORLANDO}
Looks like we made it!

-> DONE

= is_not_at_peak

# speaker={C_ORLANDO}
We gotta ascend the peak and see how many Yendorians there are!

-> DONE

== quest_tutorial_fight_keelhauler ==

# speaker={C_ORLANDO}
Uh, sorry! But, um... THERE'S NO TIME TO TALK! We gotta take out the goons!

-> DONE

= dodge_cannon

# speaker={C_ORLANDO}
Eeek! %hint(The gunners are aiming at us!) RUN!

-> DONE

= dodge_charge

# speaker={C_ORLANDO}
OI! Watch out, %person({player_get_pronoun_uppercase(X_MX)}) {player_name}! Looks like the %person(Keelhauler) is getting ready to charge at us!

-> DONE

= deflected_both_attacks

# speaker={C_ORLANDO}
OI! That was AWESOME! You stopped the %person(Keelhauler) from using its second special attack!

-> DONE

== quest_tutorial_main_finish_demo ==

# speaker={C_ORLANDO}
Let %person(Ser Commander) and the knights to take care of the pirates. We gotta get back to camp!

%empty()

~ player_poke_map("finishDemo")

-> DONE

== quest_tutorial_talk_with_robert ==

# speaker=SeafarerGuildMaster
You need back on the ship?

# speaker={C_ORLANDO}
Nope, not right now!

# speaker=SeafarerGuildMaster
Aye, whenever you change yer mind, lemme know.

-> DONE

== quest_tutorial_main_out_of_bounds ==

# speaker={C_ORLANDO}
# background=000000
Oi! We got stuff to do over here!

-> DONE
