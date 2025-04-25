INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink
INCLUDE ../VizierRockKnight/Common.ink

EXTERNAL quest_tutorial_orlando_has_lit_coconut_fire()
EXTERNAL quest_tutorial_orlando_has_dropped_dummy()

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
<>
{
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: wizard
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: archer
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: warrior
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_SAILING: sailor
  - else: loaf
}

== function quest_tutorial_get_offensive_power_name() ==
<>
{
  - player_get_stance() == STANCE_DEFENSIVE: Bash
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: Corrupt
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: Snipe
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: Tornado
}

== function quest_tutorial_get_defensive_power_name() ==
{
  - player_get_stance() == STANCE_DEFENSIVE: Bash
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: Confuse
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: Shockwave
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: Parry
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
~ temp in_fishing_area = player_is_in_passage("Passage_FishingArea") 
~ temp did_duel = player_did_quest_step("Tutorial", "Tutorial_Combat")
* {in_fishing_area} [(Ask about fishing).] %person(Ser Orlando), I have a question about fishing...
  -> quest_tutorial_main_fish
* {in_fishing_area && did_duel} [(Ask about dueling).] %person(Ser Orlando), I have a question about dueling...
  -> quest_tutorial_main_duel
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
    - player_is_next_quest_step("Tutorial", "Tutorial_FoundScout"): -> quest_tutorial_main_scout
    - player_is_next_quest_step("Tutorial", "Tutorial_DefeatedScout"): -> quest_tutorial_main_defeat_scout
    - player_is_next_quest_step("Tutorial", "Tutorial_FoundYenderhounds"): -> quest_tutorial_main_find_yenderhounds
    - player_is_next_quest_step("Tutorial", "Tutorial_DefeatedYenderhounds"): -> quest_tutorial_main_defeat_yenderhounds
    - player_is_next_quest_step("Tutorial", "Tutorial_FishedLightningStormfish"): -> quest_tutorial_main_fish
    - player_is_next_quest_step("Tutorial", "Tutorial_Combat"): -> quest_tutorial_combat
    - player_is_next_quest_step("Tutorial", "Tutorial_DefeatedKeelhauler"): -> quest_tutorial_fight_keelhauler
    - else: Good job, bub! #speaker={C_ORLANDO}
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
We'd be fresh meat for Yendorians out here with your smarts and skills! You're the only %hint(engineer and {quest_tutorial_get_class_name()}) here!

# speaker={C_ORLANDO}
OH! And, um, I mean, actually, it would be worse for you, of course, because, like, y'know, you'd be... dead...

-> loop

= where_am_i
-> quest_tutorial_main_started_get_up ->
~ quest_tutorial_main_started_asked_where_am_i = true

# speaker={C_PLAYER}
Eh... Where am I?

# speaker={C_ORLANDO}
We're gonna need to get you checked out as asoon as we get back to %location(Isabelle Island)...

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
%person(Yendor's) zealots say there's a huge city under those bloody waves... Larger than the Realm itself.

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
The hellfire harpoon... It can kill gods right? {quest_tutorial_main_started_asked_where_am_i: Like %person(Yendor)}?

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
  - !get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_tagged_along"): -> see_ser_commander
  - quest_tutorial_main_player_talked_about_seeing_ser_commander: -> scout
}

# speaker={C_ORLANDO}
That's the %person({player_get_pronoun_uppercase(X_MX)}) {player_name}. You look terrifying!

# speaker={C_ORLANDO}
Now that you're all geared up, we can pick up where we left off.

# speaker={C_ORLANDO}
Let's go meet with the %person(Ser Commander) at the entrance of the camp and scout for pesky pirates... or worse, Yendorians!

~ quest_tutorial_main_player_talked_about_seeing_ser_commander = true

-> DONE

= see_ser_commander
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
Keep your jabs to yourself I will have you reprimanded. %person(Lady Isabelle) won't take kindly to this abuse. She...

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
Bah! {player_get_pronoun_uppercase(X_THEY)} are right.

= course_correct_two_in_a_row

# speaker={C_ORLANDO}
...I agree. %person({player_get_pronoun_uppercase(X_MX)}) {player_name}, you're more diplomatic than I remembered.

# speaker={C_VIZIER_ROCK_KNIGHT}
Bah! {player_get_pronoun_uppercase(X_THEY)} are right. Maybe they're more than just a bookworm...

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

= bad_scenario

-> victory_intro ->

# speaker={C_PLAYER}
Ugh... Ouch... I'm in so much pain!

# speaker={C_ORLANDO}
Those Yenderhounds were vicious! You need to heal up.

-> victory_outro

= good_scenario

-> victory_intro ->

# speaker={C_PLAYER}
That was bad...

# speaker={C_ORLANDO}
It's amazing you weren't hurt that badly!

-> victory_outro

= victory_intro

# speaker={C_ORLANDO}
Good job, everyone!

# speaker={C_VIZIER_ROCK_KNIGHT}
Verily. Those mutts spread us thin by attacking each of us individually.

->->

= victory_outro

# speaker={C_ORLANDO}
I'm fresh out food...! We gotta re-supply. Thanks-fully there's a fishing spot nearby.

# speaker={C_VIZIER_ROCK_KNIGHT}
%item(Lightning stormfish)? You expect me to eat some godsforsaken R'lyhen bottomfeeder?

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
%person({player_get_pronoun_uppercase(X_MX)}) {player_name}, let me know when you've fished at least five stormfish.

# speaker={C_PLAYER}
Sure thing!

-> quest_tutorial_main_fish

== quest_tutorial_drop_items ==

# speaker={C_ORLANDO}
...but it your bag is full! Do you need help making room?

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

~ temp can_light_fire = player_did_quest_step("Tutorial", "Tutorial_FishedLightningStormfish") && not quest_tutorial_orlando_has_lit_coconut_fire()

* [(Ask for help on how to fish.)]
  -> ask_for_help
* {!can_light_fire} [(Go fishing!)]
  -> go_fishing
* [(Ask for help dropping items.)] %person(Ser Orlando), I want to clear some junk out of my bag. Can you help me?
  -> quest_tutorial_drop_items
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
Looks like you've fished up five %item(lightning stormfish)!

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

== quest_tutorial_main_duel ==

= loop

~ temp can_place_dummy = not quest_tutorial_orlando_has_dropped_dummy()

# speaker={C_PLAYER}

* [(Ask to duel again.)] %person(Ser Orlando), would you like to duel again?
  -> ask_to_duel
* {!can_place_dummy} [(Ask for practice with the dummy.)] %person(Ser Orlando), can I practice with the dummy?
  -> ask_to_practice

= ask_to_duel

# speaker={C_ORLANDO}
Sure thing! %person(Ser Commander)!

# speaker={C_VIZIER_ROCK_KNIGHT}
...oh my gods. Are you serious?

# speaker={C_ORLANDO}
Yep! I am!

%empty()
~ player_poke_map("prepareDuel")

-> DONE

= ask_to_practice

# speaker={C_ORLANDO}
I got you, %person({player_get_pronoun_uppercase(X_MX)}) {player_name}!

%empty()
~ player_poke_map("placeTutorialDummy")

# speaker={C_VIZIER_ROCK_KNIGHT}
...oh my gods. Are you serious?

# speaker={C_ORLANDO}
Yep! I am!

%empty()
~ player_poke_map("prepareDuel")

-> DONE

== quest_tutorial_duel ==

# speaker={C_ORLANDO}
The rules are simple! We fight honorably until the other peep yields.

# speaker={C_ORLANDO}
When the other peep yields, you gotta yield too. Don't keep fighting!

# speaker={C_ORLANDO}
%person(Ser Commander) will judge the fight.

# speaker={C_VIZIER_ROCK_KNIGHT}
Very well. If any of you break the rules, I will step in. And you do not want me to step in, given how... annoyed I am.

# speaker={C_ORLANDO}
Heard loud and clear!

# speaker={C_ORLANDO}
%person({player_get_pronoun_uppercase(X_MX)}) {player_name}, you can deal the first strike since I challenged you.

# speaker={C_VIZIER_ROCK_KNIGHT}
To your places!

%empty()
~ player_poke_map("prepareDuel")

-> DONE

= begin

# speaker={C_VIZIER_ROCK_KNIGHT}
May %person(Bastiel) watch over this fight and grant the most heroic and chivalrous of you victory.

# speaker={C_VIZIER_ROCK_KNIGHT}
Ready...

# speaker={C_VIZIER_ROCK_KNIGHT}
DUEL!

-> DONE

= orlando_yielded

# speaker={C_ORLANDO}
I yield, %person({player_get_pronoun_uppercase(X_MX)}) {player_name}!

# speaker={C_VIZIER_ROCK_KNIGHT}
%person({player_get_pronoun_uppercase(X_MX)}) {player_name} defeats %person(Ser Orlando) handedly!

-> DONE

= player_yielded

# speaker={C_PLAYER}
I yield, %person(Ser Orlando)!

# speaker={C_VIZIER_ROCK_KNIGHT}
%person(Ser Orlando) defeats %person({player_get_pronoun_uppercase(X_MX)}) {player_name} handedly! Hmmph...

# speaker={C_ORLANDO}
Wow! That was a good fight! I didn't expect to beat you...

%empty()

~ player_poke_map("playerFinishDuel")

-> DONE

= player_yielded_after_orlando

# speaker={C_PLAYER}
Good fight, %person(Ser Orlando)!

# speaker={C_ORLANDO}
Wow! That was good! Guess I need more practice... Another day!

%empty()
~ player_poke_map("playerFinishDuel")

-> DONE

= player_should_yield

# speaker={C_ORLANDO}
Not to sound arrogant, but I think you should yield %person({player_get_pronoun_uppercase(X_MX)}) {player_name}...!

# speaker={C_ORLANDO}
You don't wanna die, do you?!

-> DONE

= finished

# speaker={C_ORLANDO}
If you want to duel again, just talk to me.

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

# speaker={C_ORLANDO}
bla bla bla

# speaker={C_PLAYER}
* {not quest_tutorial_orlando_has_dropped_dummy()} can u drop a dummy pls
  -> drop_new_dummy
* -> DONE

= start

# speaker={C_ORLANDO}
%person({player_get_pronoun_uppercase(X_MX)}) {player_name}, I'm a li'l worried about you.

# speaker={C_ORLANDO}
You're not fighting like the {quest_tutorial_get_class_name()} I knew...

# speaker={C_ORLANDO}
...are you okay?

# speaker={C_PLAYER}
* I'm still a bit out of it...[] Can you help me get back up to speed?
  -> start_still_out_of_it
* No, I'm totally fine!
  -> start_totally_fine

= start_still_out_of_it

# speaker={C_ORLANDO}
EEEEEEEEEEEEEEEEEEEEEEE!

# speaker={C_ORLANDO}
I thought you'd never ask!

# speaker={C_ORLANDO}
Like I said, I'm always prepared!

%empty()
~ player_poke_map("placeTutorialDummy")

-> DONE

= start_totally_fine

# speaker={C_ORLANDO}
Okay... You sure? So... If we had a mock duel you'd be able to beat me?

# speaker={C_PLAYER}
* Yes![] Definitely! You stand no chance!
  -> totally_fine_let_us_duel
* No![] You're right, I need help.
  -> start_still_out_of_it

= totally_fine_let_us_duel

# speaker={C_ORLANDO}
EEEEEEEEEEEEEEEEEEEEEEE!

# speaker={C_ORLANDO}
Confident! Just like the %person({player_get_pronoun_uppercase(X_MX)}) {player_name} I know!

-> quest_tutorial_duel

= place_dummy

{
  - not quest_tutorial_main_did_place_dummy: -> drop_first_dummy
  - else: -> drop_n_dummy
}

= drop_first_dummy

# speaker={C_ORLANDO}
There we go!

# speaker={C_VIZIER_ROCK_KNIGHT}
I cannot stay silent any longer... You have a dummy on you?!

# speaker={C_ORLANDO}
I... have my reasons.

# speaker={C_VIZIER_ROCK_KNIGHT}
Of course you do. Of course.

# speaker={C_ORLANDO}
Anyway... I'll remind you how to fight like a real hero again!

# speaker={C_ORLANDO}
So whenever you're ready, attack the dummy!

# speaker={C_ORLANDO}
The dummy can't kill you... Uh, I think it can't, at least... So... you (...probably...) don't gotta worry about that!

%empty()
~ quest_tutorial_main_did_place_dummy = true

-> DONE

= drop_n_dummy

# speaker={C_ORLANDO}
Whenever you're ready, attack the dummy!

# speaker={C_ORLANDO}
The dummy can't kill you! So you don't gotta worry about that!

-> DONE

= drop_new_dummy

# speaker={C_ORLANDO}
Lemme go drop another dummy!

%empty()
~ player_poke_map("placeTutorialDummy")

-> DONE

= yield

# speaker={C_ORLANDO}
Ok, first up, yielding!

# speaker={C_ORLANDO}
To stop fighting your foe, yield! Then you can just run away!

# speaker={C_ORLANDO}
The dummy will hold back. Now yield!

-> DONE

= did_not_yield

# speaker={C_ORLANDO}
C'mon, stop attacking the dummy and yield!

-> DONE

= did_yield

# speaker={C_ORLANDO}
Great! If you're ever confused and need help, yield and I'll jump in and help.

# speaker={C_ORLANDO}
Next up, let's focus on healing... This might hurt a bit!

-> DONE

= did_not_eat

{
  - not player_has_item("CookedLightningStormfish", 1): -> did_not_eat_needs_food
  - else: -> did_not_eat_has_food
}

= did_not_eat_needs_food

# speaker={C_ORLANDO}
Woah, how'd you run out of food already?!

# speaker={C_ORLANDO}
I gotchu! Here's a %item(cooked lightning stormfish).

%empty()

~ play_animation(C_ORLANDO, "Human_ActionGive_1")
{not player_give_item("CookedLightningStormfish", 1): -> quest_tutorial_drop_items ->}

-> DONE

= eat

# speaker={C_ORLANDO}
Dummy, yield!

# speaker={C_ORLANDO}
Looks like you've taken a beating! Time to heal!

{not player_has_item("CookedLightningStormfish", 1): -> did_not_eat_needs_food}

-> DONE

= did_not_eat_has_food

# speaker={C_ORLANDO}
You need to heal! You've taken a beating...

# speaker={C_ORLANDO}
Let's try again...

-> DONE

= did_eat

# speaker={C_ORLANDO}
Good job eating! Easy foods like fish heal, while foods that need recipes can heal and also buff your stats!

# speaker={C_ORLANDO}
Cooking is amazing! It turns boring old plants and animals into pieces of art!

# speaker={C_ORLANDO}
Next up, we'll look at rites!

-> DONE

= incorrect_yield

# speaker={C_ORLANDO}
Are you okay? Take a break and attack the dummy when you're ready!

-> DONE

= can_use_rite

# speaker={C_ORLANDO}
Wow! Did you see that? The dummy used a rite of malice!

# speaker={C_ORLANDO}
Rites of malice deal more damage and rites of bulwark lower damage! They also got a bunch of other cool effects!

# speaker={C_ORLANDO}
You can dodge attacks, slow down your foe, get them stuck, lower their stats, and a ton of other stuff.

# speaker={C_ORLANDO}
Since rites are kinda, uh, emotional... they require a certain amount of zeal.

-> can_use_rite_loop

= can_use_rite_loop

# speaker={C_PLAYER}

* Uh, what is zeal?
  -> what_is_zeal
* Rites are emotional?
  -> what_are_rites
* [(Continue listening to %person(Ser Orlando).)]
  -> can_use_rite_post_loop

= can_use_rite_post_loop

# speaker={C_ORLANDO}
You get zeal from fighting good. The better you're doing, the more zeal you'll get!

# speaker={C_ORLANDO}
And after you use a rite, it needs to recharge. So you can't use the same rite back-to-back!

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
I'll show you how to use %hint(Tornado)! It's my fave! You spin in a big circle and hit everyone around you. Good if you got ganged up on!

-> DONE

# speaker={C_ORLANDO}
= what_is_zeal

# speaker={C_ORLANDO}
Zeal means something different for everyone! For me, it's my braveness level. The braver I'm being, the faster I get zeal!

# speaker={C_ORLANDO}
For you, it might be how smitey you're feeling if you're religious. Or hecks, maybe you're a hippy and it's how peaceful you're feeling.

# speaker={C_ORLANDO}
Think about what zeal is to you... You might not know right now and that's okay! Some peeps take forever to figure it out.

-> can_use_rite_loop

= what_are_rites

# speaker={C_ORLANDO}
Rites require a certain connection with your inside self. Like one of those voices in your head!

# speaker={C_VIZIER_ROCK_KNIGHT}
"One of those voices"? Hmm...

# speaker={C_ORLANDO}
Oh, sorry %person(Ser Commander), I forgot, you probably only got one inner voice and it's a squealing donkey!

# speaker={C_VIZIER_ROCK_KNIGHT}
... and your inner voices are what, a drove of squealing pigs?

# speaker={C_PLAYER}
{
  - get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_defused_situation") && quest_tutorial_main_defused_scout_argument: Let's put a cork in it.
  - get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_inflamed_situation") && quest_tutorial_main_inflamed_scout_argument: How about you both stop acting like a couple of farm animals and get back on topic?
  - get_external_dialog_variable(C_VIZIER_ROCK_KNIGHT, "quest_tutorial_main_knight_commander_ignored_situation") && quest_tutorial_main_ignored_scout_argument: ...
  - else: Ahem?
}

# speaker={C_ORLANDO}
Um... sorries.

# speaker={C_VIZIER_ROCK_KNIGHT}
Apologies, %person({player_get_pronoun_uppercase(X_MX)}).

# speaker={C_ORLANDO}
Anyways, increasing your combat skills isn't just about how tough you are. You gotta connect with your inside self!

-> can_use_rite_loop

= correct_rite

# speaker={C_ORLANDO}
Good job! You aced it!

# speaker={C_ORLANDO}
Now let's try and dodge the dummy's rite...

-> DONE

= incorrect_rite

# speaker={C_ORLANDO}
Wow! Improvising, huh?! That was SO COOL... But you need to use %hint{quest_tutorial_get_offensive_power_name()}!

# speaker={C_ORLANDO}
Try again!

-> DONE

= did_not_use_rite

# speaker={C_ORLANDO}
It's okay, take your time! Use %hint{quest_tutorial_get_offensive_power_name()} when you're ready!

-> DONE

= can_deflect

# speaker={C_ORLANDO}
Look! The dummy is preparing to use a rite!

# speaker={C_ORLANDO}
But don't worry, it won't actually use the rite until I tell it to!

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
You gotta use %hint(Bash) again since you're using a %hint(defensive stance)!

# speaker={C_ORLANDO}
Do you want me to show you how to use %hint(Bash) again?

-> help_using_defensive_rite

= use_confuse

# speaker={C_ORLANDO}
This time, you need to use %hint(Confuse)! This will stop your foe from using their next rite or special attack. It also lowers their accuracy!

# speaker={C_ORLANDO}
Do you want me to show you how to use %hint(Confuse)?

-> help_using_defensive_rite

= use_shockwave

# speaker={C_ORLANDO}
This time, you need to use %hint(Shockwave)! This will stop your foe from using their next rite or special attack. It also stuns them!

# speaker={C_ORLANDO}
Do you want me to show you how to use %hint(Shockwave)?

-> help_using_defensive_rite

= use_parry

# speaker={C_ORLANDO}
This time, you need to use %hint(Parry)! This one is SO COOL! It will stop your foe from using their next rite or special attack. It also prevents your foe's next attack from hurting you!

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
C'mon, you need to use a rite to counter the dummy!

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
Go on and attack the dummy!

-> DONE

== quest_tutorial_main_found_peak ==

# speaker={C_ORLANDO}
TBD FOUND PEAK

-> DONE

== quest_tutorial_reached_peak ==

# speaker={C_ORLANDO}
# background=000000
TBD REACHED PEAK

# background=none
%empty()

~ player_poke_map("tutorialReachPeak")

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
