INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink

VAR quest_tutorial_main_starting_player_class = WEAPON_STYLE_NONE
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

~ player_play_animation("Human_Dazed")
~ play_animation(C_ORLANDO, "Human_ActionShake_1")

# speaker={C_ORLANDO}
{yell(player_name)}! TALK TO ME!

-> loop

= loop
+ {!quest_tutorial_main_started_got_up} [...]
  -> dot_dot_dot
+ [What happened?]
  -> what_happened
+ [Where am I?]
  -> where_am_i
+ [What's going on?]
  -> what_is_going_on
+ {quest_tutorial_main_started_asked_what_happened && quest_tutorial_main_started_asked_where_am_i && quest_tutorial_main_started_asked_what_is_going_on} [Let's get going.]
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
But thank the gods you survived! We'd be toast without your smarts and skills!

# speaker={C_ORLANDO}
After all, %hint(you're the only engineer AND {quest_tutorial_get_class_name()}) on the team!

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

+ [%person(Yendor?) %location(R'lyeh?)] Who's %person(Yendor)? And what's %location(R'lyeh)?
  -> yendor_more_info
+ Got it[.] Humanity's Edge, eh...
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

# speaker={C_PLAYER}
Um, actually, %person(Orlando), can you help me?

# speaker={C_ORLANDO}
Gotcha!

-> DONE
