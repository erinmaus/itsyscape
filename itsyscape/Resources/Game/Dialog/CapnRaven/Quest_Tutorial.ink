INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink
INCLUDE ../Orlando/Common.ink

VAR quest_tutorial_encountered_capn_raven = false

== quest_tutorial_initial_encounter ==

{
    - quest_tutorial_encountered_capn_raven: -> did_meet
    - else: -> did_not_meet
}

= did_not_meet

~ quest_tutorial_encountered_capn_raven = true

# speaker={C_CAPN_RAVEN}
TBD BANTER (FIRST TIME)

# speaker={C_ORLANDO}
TBD BANTER RESPONSE (FIRST TIME)

-> DONE

= did_meet

# speaker={C_CAPN_RAVEN}
TBD BANTER (MET)

# speaker={C_ORLANDO}
TBD BANTER RESPONSE (MET)

-> DONE