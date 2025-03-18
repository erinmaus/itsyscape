INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink

VAR quest_tutorial_main_started_got_up = false
VAR quest_tutorial_main_started_asked_what_happened = false
VAR quest_tutorial_main_started_asked_where_am_i = false
VAR quest_tutorial_main_started_asked_what_is_going_on = false

== quest_tutorial_main ==
{
    - !player_has_started_quest("Tutorial"): -> quest_tutorial_main_started
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

-> END

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
