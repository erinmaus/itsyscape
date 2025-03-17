INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink

VAR quest_tutorial_main_started_said_something = false
VAR quest_tutorial_main_started_got_up = false
VAR quest_tutorial_main_started_asked_where_am_i = false
VAR quest_tutorial_main_started_asked_what_is_going_on = false

== quest_tutorial_main ==
{
    - !player_has_started_quest("Tutorial"): -> quest_tutorial_main_started
}

== quest_tutorial_main_started ==
# speaker={C_ORLANDO}
OI! {yell(player_name)}! ARE YOU OK?!
HELP! {yell(player_get_pronoun_uppercase(X_THEY))} ARE IN TROUBLE!

# speaker={C_PLAYER}
...

# speaker={C_ORLANDO}
~ player_play_animation("Human_Dazed")
~ play_animation(C_ORLANDO, "Human_ActionShake_1")

{yell(player_name)}! TALK TO ME!

-> loop

= loop
# speaker={C_PLAYER}
+ {!quest_tutorial_main_started_said_something} [...] -> dot_dot_dot
+ [Where am I?] -> where_am_i
+ [What's going on?] -> what_is_going_on

= dot_dot_dot
~ player_play_animation("Human_Dazed")
~ play_animation(C_ORLANDO, "Human_ActionShake_1")

# speaker={C_ORLANDO}
{{player_name}! Get up!|Come on! Wake up! I can see you're breathing!|Are you in a coma?! Gods!}

-> loop

= where_am_i
-> quest_tutorial_main_started_get_up ->

~ quest_tutorial_main_started_asked_where_am_i = true

# speaker={C_PLAYER}
Eugh... Where am I?

# speaker={C_ORLANDO}
{Woah! You're definitely not with it!|Dang, you already asked that!|Woah, you must have amnesia!}

# speaker={C_ORLANDO}
We're at %location(Humanity's Edge), the last human outpost before %person(Yendor's) city-state, %location(R'lyeh)!

# speaker={C_PLAYER}
+ %person(Yendor?) %location(R'lyeh?)[] Who's %person(Yendor)? And what's %location(R'lyeh)? -> yendor_more_info
+ Got it[.] Humanity's Edge, eh... -> loop

= yendor_more_info

# speaker={C_ORLANDO}
%person(Yendor)... She's... Well, Yendor is an %hint(Old One). I'd... rather not say much about Her this close to R'lyeh...

# speaker={C_ORLANDO}
And what's %location(R'lyeh)... Not much is known. It's suicide to sail into those waters.

# speaker={C_ORLANDO}
All we know is there's a HUH-UGE city under those bloody waves. No human has ever survived to tell the tale.

-> loop

= what_is_going_on
-> quest_tutorial_main_started_get_up ->
~ quest_tutorial_main_started_asked_what_is_going_on = true

# speaker={C_PLAYER}
Ugh... What's going on?

# speaker={C_ORLANDO}
Woah, you're not with it! We're finishing that %hint(hellfire harpoon and launcher you designed)!

# speaker={C_PLAYER}
...Hellfire harpoon?

# speaker={C_ORLANDO}
Woah! Are you sure you don't got amnesia?!

# speaker={C_ORLANDO}
The hellfire harpoon is a way to kill %person(Cthulhu)! The science checks out! Well, so says %person(my sis and her friends)... and they're all pretty smart, too!

# speaker={C_ORLANDO}
And if it can kill Cthulhu... We can push into %location(R'lyeh) and show them Yendorians us humans aren't to be underestimated!

-> loop

== quest_tutorial_main_started_get_up ==
{
    - !quest_tutorial_main_started_got_up: -> get_up
    - else: -> got_up
}

= get_up
~ quest_tutorial_main_started_got_up = true
~ player_play_animation("Human_Resurrect_1")

# speaker={C_ORLANDO}
THANK THE GODS YOU'RE ALIVE, ${yell(player_name)}! Looks like that lightning strike knocked you right out!

-> got_up

= got_up

->->
