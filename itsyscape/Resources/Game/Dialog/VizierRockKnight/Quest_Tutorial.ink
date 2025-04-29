INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink
INCLUDE ../Orlando/Common.ink

VAR quest_tutorial_main_knight_commander_tagged_along = false
VAR quest_tutorial_main_knight_commander_defused_situation = false
VAR quest_tutorial_main_knight_commander_inflamed_situation = false
VAR quest_tutorial_main_knight_commander_ignored_situation = false
VAR quest_tutorial_main_knight_commander_did_not_yield = false

== quest_tutorial_main ==
{
    - !quest_tutorial_main_knight_commander_tagged_along: -> quest_tutorial_main_knight_commander_intro
    - else: -> quest_tutorial_main_fallback
}

== quest_tutorial_main_fallback ==
# speaker={C_VIZIER_ROCK_KNIGHT}
...

# speaker={C_ORLANDO}
...

# speaker={C_PLAYER}
...

# speaker={C_PLAYER}
(The silence is deafening...)

-> DONE

== quest_tutorial_main_knight_commander_intro ==

# speaker={C_VIZIER_ROCK_KNIGHT}
Halt! %person(Ser Orlando) and %person({player_get_pronoun_uppercase(X_MX)}) {player_name}, what on %person(Bastiel's) Realm took you so long?

# speaker={C_VIZIER_ROCK_KNIGHT}
Did you get lost dreaming of your next meal, %person(Ser Orlando)? Or did %hint(the bookworm) get lost in the pages of {player_get_pronoun_lowercase(X_THEIR)} journal, hmm, {player_name}?

# speaker={C_PLAYER}
(Wait... That lightning strike destroyed the journal, didn't it... I didn't see it on the ground.)

# speaker={C_ORLANDO}
That lightning strike hit %person({player_get_pronoun_uppercase(X_MX)}) {player_name} and knocked {player_get_pronoun_lowercase(X_THEM)} right out!

# speaker={C_ORLANDO}
If you weren't so busy being a stuck-up donkey, then maybe you would've noticed.

# speaker={C_VIZIER_ROCK_KNIGHT}
How dare you! You're nothing compared to %person(Vizier-King Yohn's) personal guard, you dainty little boy!

# speaker={C_ORLANDO}
OH! YOU WENT THERE! Funny you say that...

# speaker={C_PLAYER}
* [(Defuse situation.)] Break it up! We need to get going. This is not the time to measure your swords.
  -> break_it_up
* [(Antagonize Knight Commander.)] No wonder you don't wear a helmet when there's nothing worth protecting in that empty skull of yours?
  -> insult_knight_commander
* [(Stay silent.)] (Let me see how this goes...)
  -> stay_quiet

= break_it_up

# speaker={C_ORLANDO}
...ugh, %person({player_get_pronoun_uppercase(X_MX)}) {player_name} is right. We best get going.

# speaker={C_VIZIER_ROCK_KNIGHT}
...very well. Let's hold our tongues until there's reason to talk, then.

~ quest_tutorial_main_knight_commander_defused_situation = true
-> tag_long

= insult_knight_commander

%empty()
~ play_animation(C_VIZIER_ROCK_KNIGHT, "Human_AttackLongswordSlash_1")

# speaker={C_VIZIER_ROCK_KNIGHT}
How DARE you talk to the %person(SER COMMANDER) like that, you worthless...

%empty()
~ play_animation(C_ORLANDO, "Human_AttackZweihanderSlash_1")

# speaker={C_ORLANDO}
BOTH OF YOU! JUST SHUT UP! Let the jabs bounce off your armor and let's get going.

# speaker={C_VIZIER_ROCK_KNIGHT}
...very well.

# speaker={C_PLAYER}
...if we must.

~ quest_tutorial_main_knight_commander_inflamed_situation = true
-> tag_long

= stay_quiet

# speaker={C_ORLANDO}
...but let's not waste our breath on this silly fight. We shouldn't be fighting each other when Yendorians or pirates could be near.

# speaker={C_PLAYER}
(Well, that was anti-dramatic.)

# speaker={C_VIZIER_ROCK_KNIGHT}
I loathe to speak it, but you're right, %person(Ser Orlando). Very well. Let us go in silence.

~ quest_tutorial_main_knight_commander_ignored_situation = true
-> tag_long

= tag_long
~ quest_tutorial_main_knight_commander_tagged_along = true
~ player_poke_map("tutorialKnightCommanderTagAlong")
~ set_peep_mashina_state(C_VIZIER_ROCK_KNIGHT, "tutorial-follow-player")

-> DONE

== quest_tutorial_duel ==

= punish_player
~ quest_tutorial_main_knight_commander_did_not_yield = true
~ play_animation(C_VIZIER_ROCK_KNIGHT, "Human_AttackZweihanderSlash_Tornado")
~ player_play_animation("Human_Trip_1")

# speaker={C_VIZIER_ROCK_KNIGHT}
VILLIAN {player_name}! %person(SER ORLANDO) YIELDED, SO YIELD YOURSELF!

# speaker={C_PLAYER}
...whoops.

# speaker={C_ORLANDO}
%person({player_get_pronoun_uppercase(X_MX)}) {player_name}, that... wasn't like you.

# speaker={C_ORLANDO}
I guess you got caught up in the heat of the fight...

# speaker={C_ORLANDO}
We can talk about this later. We need to get going.

~ player_poke_map("playerFinishDuel")

-> DONE

== quest_tutorial_mining_knight ==

{ shuffle:
  - -> option_a
  - -> option_b
  - -> option_c
  - -> option_d
}

= option_a

# speaker={C_VIZIER_ROCK_KNIGHT}
Hmmph! We should've brought some prisoners to mine this.

# speaker={C_ORLANDO}
Prisoners talk. You should be honored to be on a mission this important. 

# speaker={C_VIZIER_ROCK_KNIGHT}
Ugh... If you say so.

-> DONE

= option_b

# speaker={C_VIZIER_ROCK_KNIGHT}
This is gonna take a lifetime to mine...

# speaker={C_ORLANDO}
But you've almost got to the core!

# speaker={C_VIZIER_ROCK_KNIGHT}
Exactly. The surface of a meteor is the easy part. The core is the hard part.

# speaker={C_ORLANDO}
You're in luck. %person({player_get_pronoun_uppercase(X_MX)}) {player_name} is gonna mine the core.

# speaker={C_VIZIER_ROCK_KNIGHT}
Thank the gods...

-> DONE

= option_c

# speaker={C_VIZIER_ROCK_KNIGHT}
Wish more of us leveled our mining skills...

-> DONE

= option_d

# speaker={C_VIZIER_ROCK_KNIGHT}
Ugh. Wish mining this wasn't so dangerous. I'm swimming in sweat in this armor.

# speaker={C_ORLANDO}
It'll be worth it.

# speaker={C_VIZIER_ROCK_KNIGHT}
I hope so... A god-killing weapon? Sounds ridiculous. Heretical, even.

# speaker={C_ORLANDO}
Hear-a-tickle or not, not every god is easy-going like %person(Bastiel).

# speaker={C_ORLANDO}
What about %person(Yendor)? Or %person(Gammon)? We gotta be able to defend ourselves.

# speaker={C_VIZIER_ROCK_KNIGHT}
I pray the weapon doesn't fall into the wrong hands then.

# speaker={C_ORLANDO}
There's no place safer than with %person(Lady Isabelle)!

-> DONE

== quest_tutorial_random_knight ==

{ RANDOM(1, 4):
  - 1: -> option_a
  - 2: -> option_b
  - 3: -> option_c
  - 4: -> option_d
}

= option_a

# speaker={C_VIZIER_ROCK_KNIGHT}
You look rough.

# speaker={C_ORLANDO}
{player_get_pronoun_uppercase(X_THEY)} took a beating from that gunpowder 'splosion.

# speaker={C_VIZIER_ROCK_KNIGHT}
Then thank the gods {player_get_pronoun_lowercase(X_THEY)} {player_get_english_be_lowercase(X_ARE)} alive. This place is kursed.

-> DONE

= option_b

# speaker={C_VIZIER_ROCK_KNIGHT}
We've gotten lucky so far. I'm surprised the Yendorians haven't intervened.

# speaker={C_ORLANDO}
Don't jinx it. We will be scouting ahead to make sure there's no surprises.

# speaker={C_VIZIER_ROCK_KNIGHT}
Good luck dealing with %person(Ser Commander). He's been quick to snap and discipline us. Seems he's unhappy about not being in charge.

# speaker={C_ORLANDO}
We'll be able to handle him.

-> DONE

= option_c

# speaker={C_VIZIER_ROCK_KNIGHT}
The weather can't get much worse, can it?

# speaker={C_ORLANDO}
This is like a warm spring day on %location(Isabelle Island). Things could be A LOT worse out here.

# speaker={C_VIZIER_ROCK_KNIGHT}
Ugh... I'm not sure if that makes me feel better or worse.

-> DONE

= option_d

# speaker={C_VIZIER_ROCK_KNIGHT}
I feel like an errand boy. This is a waste of my talents.

# speaker={C_ORLANDO}
Just 'cause you're a knight doesn't mean you're above hard work.

# speaker={C_ORLANDO}
Remember the Knight's Code: "I am a servant of the people."

# speaker={C_ORLANDO}
You're not better than anyone else. Sometimes we gotta do things we don't wanna.

# speaker={C_VIZIER_ROCK_KNIGHT}
...sorry, Ser... You're... right.

-> DONE