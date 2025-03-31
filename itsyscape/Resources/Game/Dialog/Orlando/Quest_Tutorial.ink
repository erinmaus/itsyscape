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

== function quest_tutorial_get_class_name() ==
{
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: wizard
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: archer
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: warrior
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_SAILING: sailor
  - else: loaf
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

%empty()

# background=none

-> quest_tutorial_main.table_of_contents

== quest_tutorial_main ==

# speaker={C_PLAYER}
~ temp in_fishing_area = player_is_in_passage("Passage_FishingArea") 
* {in_fishing_area} [(Ask about fishing).] %person(Ser Orlando), I have a question about fishing...
  -> quest_tutorial_main_fish
* {in_fishing_area} [(Talk about something else.)] -> table_of_contents
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
~ quest_tutorial_main_started_asked_what_happened = true

# speaker={C_PLAYER}
Ugh... So what in the Realm happened?

-> quest_tutorial_main_started_get_up ->

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
~ quest_tutorial_main_started_asked_where_am_i = true

# speaker={C_PLAYER}
Eh... Where am I?

-> quest_tutorial_main_started_get_up ->

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
~ quest_tutorial_main_started_asked_what_is_going_on = true

# speaker={C_PLAYER}
Um... So what's going on?

-> quest_tutorial_main_started_get_up ->

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
Let's look for foes! Also, let's pray we don't find any!

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
...controls %hint(more than) %person(Vizier-King Yohn's) %hint(purse). Or do have to remind you how much the Vizier-King owes her?

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

== quest_tutorial_combat ==

# speaker={C_ORLANDO}
bla bla bla

# speaker={C_PLAYER}
* {not quest_tutorial_orlando_has_dropped_dummy()} can u drop a dummy pls
  -> drop_new_dummy
* -> DONE

= start

# speaker={C_ORLANDO}
TBD da start

%empty()

~ player_poke_map("placeTutorialDummy")

-> DONE

= drop_new_dummy

# speaker={C_ORLANDO}
sure bruh

%empty()

~ player_poke_map("placeTutorialDummy")

-> DONE

= attack_dummy

# speaker={C_ORLANDO}
attack the dummy, goober

-> DONE

= yield

# speaker={C_ORLANDO}
yield to the dummy ok???

-> DONE

= did_not_yield

# speaker={C_ORLANDO}
wtfbbq goober seriously yield to the gd dummy ok

-> DONE

= did_yield

# speaker={C_ORLANDO}
good job yielding bruh

-> DONE

= did_not_eat

{
  - not player_has_item("CookedLightningStormfish", 1): -> did_not_eat_needs_food
  - else: -> did_not_eat_has_food
}

= did_not_eat_needs_food

# speaker={C_ORLANDO}
why didn't you say you don't good food earlier bruh i gotchu

%empty()

~ play_animation(C_ORLANDO, "Human_ActionGive_1")

{not player_give_item("CookedLightningStormfish", 1): -> quest_tutorial_drop_items ->}

-> DONE

= eat

# speaker={C_ORLANDO}
go eat!!!

{not player_has_item("CookedLightningStormfish", 1): -> did_not_eat_needs_food}

-> DONE

= did_not_eat_has_food

# speaker={C_ORLANDO}
why are you not eating bruh

-> DONE

= did_eat

# speaker={C_ORLANDO}
good job eating bruh

-> DONE

= yield_during_eat

# speaker={C_ORLANDO}
bruh why'd you yield just try again ok bruh attack the dummy when u ready ok bruh

-> DONE