INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink
INCLUDE ../Orlando/Common.ink

VAR quest_tutorial_main_knight_commander_tagged_along = false
VAR quest_tutorial_main_knight_commander_defused_situation = false
VAR quest_tutorial_main_knight_commander_inflamed_situation = false
VAR quest_tutorial_main_knight_commander_ignored_situation = false

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
Halt! %person(Ser Orlando) and %person({player_get_pronoun_lowercase(X_MX)}) {player_name}, what on Bastiel's Realm took you so long?

# speaker={C_VIZIER_ROCK_KNIGHT}
Did you get lost dreaming of your next meal, %person(Ser Orlando)? Or did %hint(the bookworm) get lost in the pages of {player_get_pronoun_lowercase(X_THEIR)} journal, hmm, {player_name}?

# speaker={C_ORLANDO}
That lightning strike hit {player_name} and knocked {player_get_pronoun_lowercase(X_THEM)} right out!

# speaker={C_ORLANDO}
If you weren't so busy being a pretentious donkey, then maybe you would've noticed.

# speaker={C_VIZIER_ROCK_KNIGHT}
How dare you! You're nothing compared to %person(Vizier-King Yohn's) personal guard, you dainty girl!

# speaker={C_ORLANDO}
OH! Bold of you to say that...

# speaker={C_PLAYER}
* [Defuse situation] Break it up! We need to get going. This is not the time to measure your swords.
  -> break_it_up
* [Antagonize Knight Commander] Why wear a helmet when there's nothing worth protecting in that empty skull of yours?
  -> insult_knight_commander
* [Stay silent] (Let me see how this goes...)
  -> stay_quiet

= break_it_up

# speaker={C_ORLANDO}
...ugh, {player_name} is right. We best get going.

# speaker={C_VIZIER_ROCK_KNIGHT}
...very well. Let's hold our tongues until there's reason to talk, then.

~ quest_tutorial_main_knight_commander_defused_situation = true
-> tag_long

= insult_knight_commander

%empty()
~ play_animation(C_VIZIER_ROCK_KNIGHT, "Human_AttackLongswordSlash_1")

# speaker={C_VIZIER_ROCK_KNIGHT}
How DARE you talk to a KNIGHT COMMANDER like that, you worthless--

%empty()
~ play_animation(C_ORLANDO, "Human_AttackZweihanderSlash_1")

# speaker={C_ORLANDO}
BOTH OF YOU! JUST SHUT UP! Let the slights slide off our armor and let us get going.

# speaker={C_VIZIER_ROCK_KNIGHT}
...very well.

# speaker={C_PLAYER}
...if we must.

~ quest_tutorial_main_knight_commander_inflamed_situation = true
-> tag_long

= stay_quiet

# speaker={C_ORLANDO}
...but let's not waste our breathe on this petty fight. We have shared enemies we should channel our anger towards.

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
