INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink

VAR quest_tutorial_main_starting_player_class = WEAPON_STYLE_NONE
VAR quest_tutorial_main_player_has_no_idea_what_to_do = false
VAR quest_tutorial_main_player_is_scouting = false
VAR quest_tutorial_main_started_got_up = false
VAR quest_tutorial_main_started_asked_what_happened = false
VAR quest_tutorial_main_started_asked_where_am_i = false
VAR quest_tutorial_main_started_asked_what_is_going_on = false
VAR quest_tutorial_main_equipped_items_thought = false

== function quest_tutorial_get_class_name() ==
{
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MAGIC: wizard
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_ARCHERY: archer
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_MELEE: warrior
  - quest_tutorial_main_starting_player_class == WEAPON_STYLE_SAILING: sailor
  - else: loaf
}

== quest_tutorial_main ==
{
    - !player_has_started_quest("Tutorial"): -> quest_tutorial_main_started
    - player_is_next_quest_step("Tutorial", "Tutorial_GatheredItems"): -> quest_tutorial_main_gather_items
    - player_is_next_quest_step("Tutorial", "Tutorial_EquippedItems"): -> quest_tutorial_main_equipped_items
    - player_is_next_quest_step("Tutorial", "Tutorial_FindScout"): -> quest_tutorial_main_scout
    - player_is_next_quest_step("Tutorial", "Tutorial_DefeatedScout"): -> quest_tutorial_main_defeat_scout
}

== quest_tutorial_main_started ==
~ player_finish_animation("Human_Die_1")
~ player_play_sound("SFX_LightningExplosion")

# speaker={C_ORLANDO}
# background=000000
WHAT WAS THAT?!

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
* {quest_tutorial_main_started_asked_what_happened && quest_tutorial_main_started_asked_where_am_i && quest_tutorial_main_started_asked_what_is_going_on} [Let's get going.]
  -> let_us_get_going

= dot_dot_dot
~ player_play_animation("Human_Dazed")
~ play_animation(C_ORLANDO, "Human_ActionShake_1")

# speaker={C_ORLANDO}
{{player_name}! Get up!|Come on! Wake up! I can see you're breathing!|Are you in a coma?! Gods!}

-> loop

= what_happened
~ quest_tutorial_main_started_asked_what_happened = true

# speaker={C_PLAYER}
Oof... What happened?

-> quest_tutorial_main_started_get_up ->

# speaker={C_ORLANDO}
I was coming to grab to you when a lightning strike hit a crate of gunpowder and caused an explosion! You were knocked into tomorrow.

# speaker={C_ORLANDO}
But you survived! We'd be toast without your smarts and skills! After all, %hint(you're the only engineer AND {quest_tutorial_get_class_name()}) on the team!

# speaker={C_ORLANDO}
Um, and, uh, I mean, it would be worse for you, though, because, you know, you'd be dead...!

+ [I have more questions.]
  -> loop
+ [Let's get going.]
  -> let_us_get_going

= where_am_i
~ quest_tutorial_main_started_asked_where_am_i = true

# speaker={C_PLAYER}
Eugh... Where am I?

-> quest_tutorial_main_started_get_up ->

# speaker={C_ORLANDO}
{Woah! You're definitely not with it!|Dang, you already asked that!|Woah, you must have amnesia!}

# speaker={C_ORLANDO}
We're at %location(Humanity's Edge), the last human outpost before %person(Yendor's) city-state, %location(R'lyeh)!

* [%person(Yendor?) %location(R'lyeh?)] Who's %person(Yendor)? And what's %location(R'lyeh)?
  -> yendor_more_info
* Got it[.] Humanity's Edge, eh...
  -> loop

= yendor_more_info

# speaker={C_ORLANDO}
How do you... not know this?

# speaker={C_ORLANDO}
%person(Yendor)... She's... Well, Yendor is an %hint(Old One). I'd... rather not say much about Her this close to %location(R'lyeh)...

# speaker={C_ORLANDO}
And what's %location(R'lyeh)... Not much is known. It's suicide to sail those waters.

# speaker={C_ORLANDO}
All we know is there's a HUH-UGE city under those bloody waves. No human has ever survived to tell the tale.

-> loop

= what_is_going_on
~ quest_tutorial_main_started_asked_what_is_going_on = true

# speaker={C_PLAYER}
Ugh... What's going on?

-> quest_tutorial_main_started_get_up ->

# speaker={C_ORLANDO}
Woah, you're not with it, are you?! We're finishing that %hint(hellfire harpoon and launcher you designed)!

# speaker={C_PLAYER}
...Hellfire harpoon?

# speaker={C_ORLANDO}
Are you sure you don't got amnesia?!

# speaker={C_ORLANDO}
The hellfire harpoon is a way to kill %person(Cthulhu)! The science checks out! Well, so says %person(my sis and her friends)... and they're all pretty smart, too!

# speaker={C_ORLANDO}
And if it can kill %person(Cthulhu)... We can push into %location(R'lyeh) and show them Yendorians us humans aren't to be underestimated!

-> loop

= let_us_get_going

# speaker={C_PLAYER}
Let's get going, then!

~ player_give_key_item("Tutorial_Start")
-> quest_tutorial_main

== quest_tutorial_main_started_get_up ==
{
    - !quest_tutorial_main_started_got_up: -> get_up
    - else: -> got_up
}

= get_up
~ quest_tutorial_main_started_got_up = true
~ player_play_animation("Human_Resurrect_1")

# speaker={C_ORLANDO}
THANK THE GODS YOU'RE ALIVE, {yell(player_name)}! Looks like that lightning strike knocked you right out!

-> got_up

= got_up

->->

== quest_tutorial_main_gather_items ==

# speaker={C_ORLANDO}
The explosion knocked your inventory on to the ground! Let's pick it all up!

-> DONE

== quest_tutorial_main_equipped_items ==

{
  - quest_tutorial_main_equipped_items_thought: -> ask_for_help
  - else: -> have_thought
}

= have_thought

~ quest_tutorial_main_equipped_items_thought = true

# speaker={C_PLAYER}
Great, now that I have picked everything up, I should probably equip the amor and weapons...

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
* [Ask %person(Orlando) for help.] Hey, %person(Orlando), can... you help me?
  -> get_help
* [Equip the items on your own.] (I'll figure this out...)
  -> DONE

= get_help

# speaker={C_ORLANDO}
Gotcha!

%empty()

~ player_poke_map("showEquipItemsTutorial")

-> DONE

== quest_tutorial_main_scout ==

{quest_tutorial_main_player_is_scouting: -> scout}

# speaker={C_ORLANDO}
You look terrifying! Now that you're all geared up, we can pick up where we left off!

# speaker={C_PLAYER}

* Uhhhh...[] And that was?
  -> and_that_was
* [I know exactly what you're talking about!] Yep, let's, uh, go, um, do the thing!
  -> player_knows_exactly

= and_that_was

# speaker={C_ORLANDO}
"Uhhhh...?" We're definitely gonna need to check your head when we get back to %location(Isabelle Island)!

# speaker={C_ORLANDO}
Anyway... We were supposed to %hint(scout ahead and keep an eye out for any threats), like pirates... or Yendorians!

-> follow

= player_knows_exactly

~ quest_tutorial_main_player_has_no_idea_what_to_do = true

# speaker={C_ORLANDO}
"Do the thing?!" You're a laugh! Glad you're with it now though!

# speaker={C_PLAYER}
Yes... I'm totally with, er, "it" now!

-> follow

= follow

# speaker={C_ORLANDO}
I'll follow you! Let's go!

%empty()

~ quest_tutorial_main_player_is_scouting = true
~ set_peep_mashina_state(C_ORLANDO, "tutorial-follow-player")

-> DONE

= give_player_a_second_chance

# speaker={C_ORLANDO}
Don't be so dramatic, you're good! We're scouting for any intrusions from Yendorians or pirates.

# speaker={C_ORLANDO}
Let's head further into the island!

~ quest_tutorial_main_player_has_no_idea_what_to_do = false

-> DONE

= scout

# speaker={C_ORLANDO}
{
  - quest_tutorial_main_player_has_no_idea_what_to_do: Come on! I'll follow you.
  - else: Let's scout for Yendorians and pirates! I'll follow you.
}

~ set_peep_mashina_state(C_ORLANDO, "tutorial-follow-player")

# speaker={C_PLAYER}
+ {quest_tutorial_main_player_has_no_idea_what_to_do} I actually have no idea what we're doing![] I lied! Please help me!
  -> give_player_a_second_chance
+ {quest_tutorial_main_player_has_no_idea_what_to_do} [(Keep acting like you know what you're doing.)] (I hope I can figure out what I'm supposed to be doing...)

-> DONE

== quest_tutorial_main_defeat_scout ==
# speaker={C_ORLANDO}
Look ahead! There's a Yendorian scout! %hint(He's not seen us yet...)

# speaker={C_PLAYER}
* What should we do?[] He looks pretty strong...
  -> what_to_do
* Let's deal with him![] We can't let him alert the others!
  -> deal_with_him

= what_to_do
#speaker={C_ORLANDO}
Don't let his high combat level fool you! He's just scout. Let's kill this guy!

= deal_with_him
#speaker={C_ORLANDO}
I agree!

-> DONE
