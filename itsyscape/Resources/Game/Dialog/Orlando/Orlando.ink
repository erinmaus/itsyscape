INCLUDE ../Common/Common.ink

== quest_tutorial_main ==
{
    - !player_has_started_quest("Tutorial"): -> quest_tutorial_main_started
}

== quest_tutorial_main_started ==
# speaker=Orlando
OI! {yell(player_name)}! ARE YOU OK?!
HELP! {yell(player_get_pronoun_uppercase(X_THEY))} ARE IN TROUBLE!

~ player_play_animation("Human_Dazed")
~ play_animation("Orlando", "Human_ActionShake_1")

-> END