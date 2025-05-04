INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink
INCLUDE ../Orlando/Common.ink

EXTERNAL quest_tutorial_capn_raven_has_summoned_keelhauler()

VAR quest_tutorial_encountered_capn_raven = false

== quest_tutorial_main ==
{
    - player_is_next_quest_step("Tutorial", "Tutorial_DefeatedKeelhauler"): -> quest_tutorial_fight_keelhauler
}

== quest_tutorial_initial_encounter ==

# speaker={C_CAPN_RAVEN}
Aye, me mates, look what the slugs dragged in! Har!

# speaker={C_ORLANDO}
Uh! Um! Uh! You better leave the island! Or, or, or... Else!

{
    - quest_tutorial_encountered_capn_raven: -> deja_vu
    - else: -> banter
}

= deja_vu

# speaker={C_CAPN_RAVEN}
Uh, wait, er... what? Weird...

# speaker=X_Pirate
Cap'n, ye all right?

# speaker={C_CAPN_RAVEN}
Aye, just... deja vu, 'tis all. Where were we?

-> banter

= banter

~ quest_tutorial_encountered_capn_raven = true

# speaker={C_CAPN_RAVEN}
Har, har, har! Standin' up to us, mate? %hint(The fiercest pirates t'er sail the seas in a thousand years?) Sure you ain't wet yerself? Wanna cry to yer sis?

# speaker={C_ORLANDO}
Leave %person(Lady Isabelle) out of this!

# speaker={C_CAPN_RAVEN}
I seen 'er flag ship just to the south. Whatever yer up to out here, don't care. But I will have yer goods!

# speaker={C_ORLANDO}
%person({player_get_pronoun_uppercase(X_MX)}) {player_name}! Let's take these goons out! Or die trying!

-> DONE

= reach_peak

# speaker={C_CAPN_RAVEN}
Oi! Some landlubbers! Take 'em out, boys!

-> DONE

= fire_cannon

# speaker=X_Pirate
AYE, AYE, CAP'N!

-> DONE

== quest_tutorial_summon_keelhauler ==

# speaker={C_CAPN_RAVEN}
AAH! HOW DARE YE! Those were fine mates!

# speaker={C_ORLANDO}
You're next!

# speaker={C_CAPN_RAVEN}
Har, har, har! Yer sure 'bout that?

-> DONE

== quest_tutorial_fight_keelhauler ==

# speaker={C_CAPN_RAVEN}
Stop yer jabberin' and fight, landlubber!

-> DONE

= enter_phase_4

# speaker={C_CAPN_RAVEN}
Yer gonna regret not givin' up, ye fools!

# speaker={C_CAPN_RAVEN}
OI! GUNNERS! TAKE 'EM OUT! Fire at them landlubbers! NOW!

# speaker=X_Pirate
AYE, AYE, CAP'N!

-> DONE

== quest_tutorial_main_defeat_keelhauler ==

= intro

# speaker={C_ORLANDO}
Looks like your magical, uh, mech... thing didn't stand a chance!

# speaker={C_CAPN_RAVEN}
Aye, that might be true, but ye are outnumbered. By me count, four to one.

# speaker={C_CAPN_RAVEN}
These mates took out Yendorians... Think ye can fare much better?

# speaker={C_ORLANDO}
Uh, %person({player_get_pronoun_uppercase(X_MX)}) {player_name}, I think we're in... itsy... uh, bit of trouble.

# speaker={C_ORLANDO}
There's no way we can defend against an entire crew by ourselves!

# speaker={C_CAPN_RAVEN}
MATES! Take 'em out! NO SURRENDER!

-> DONE

= vs_knights

# speaker={C_CAPN_RAVEN}
ARGH! Mates! WATCH YERSELVES! They got the king's knights!

# speaker={C_ORLANDO}
THANK THE GODS THEY MADE IT IN TIME!

-> DONE
