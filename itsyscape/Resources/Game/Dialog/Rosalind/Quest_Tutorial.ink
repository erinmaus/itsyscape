INCLUDE ./Common.ink
INCLUDE ../Common/Common.ink
INCLUDE ../Orlando/Common.ink

// Initial conversation.
VAR quest_tutorial_main_spoke_to_rosalind = false
VAR quest_tutorial_main_need_to_catch_up_after_weapon = false

== quest_tutorial_main ==

{
    - not quest_tutorial_main_spoke_to_rosalind: -> initial_conversation
    - else: -> table_of_contents
}

= initial_conversation

# speaker={C_ROSALIND}
'Ello, {player_name}. %person(Ser Orlando) dashed over to you faster than I've ever seen him run!

# speaker={C_ORLANDO}
Well, y'know, I... was, uh, worried about {player_get_pronoun_lowercase(X_THEM)}! %person({player_get_pronoun_uppercase(X_MX)}) {player_name} could've died!

# speaker={C_ROSALIND}
Look at you, always the knight!

# speaker={C_ORLANDO}
Uh, yeah, um, thanks! I try... try and live by the Knight's Code, y'know!

# speaker={C_ROSALIND}
So how are ya holding up, {player_name}?

* I'm not doing so well...
  -> not_doing_well
* I'm doing GREAT! Never been better!
  -> doing_great

= not_doing_well

# speaker={C_ROSALIND}
Let me see...

%empty()
~ play_animation(C_ROSALIND, "Human_ActionEnchant_1")

# speaker={C_ROSALIND}
Well, I, um... Uh...

# speaker={C_PLAYER}
Uh, I don't think that's good, is it?

# speaker={C_ORLANDO}
%person(Rosalind), is everything ok? I've never seen you tongue-tied before.

# speaker={C_ROSALIND}
It's... it's fine. {player_name}, when we finish this weapon, I want to talk to you... alone.

# speaker={C_ORLANDO}
Wh-what! Why can't you talk now?!

# speaker={C_ROSALIND}
It's... it'll be... It'll be up to {player_name}, of course. But for now, we need to focus on the weapon.

# speaker={C_ROSALIND}
I see... a storm coming. And we need to be prepared.

# speaker={C_ORLANDO}
Uh, do you... do you mean a literal storm? 'Cause, like, there's a storm. Overhead. Right now.

# speaker={C_ROSALIND}
Gosh! Of course I don't mean, literally, a storm...! I mean metaphorically!

# speaker={C_ORLANDO}
Oh, well, that makes more sense...

%empty()
~ quest_tutorial_main_need_to_catch_up_after_weapon =  true
~ quest_tutorial_main_spoke_to_rosalind = true

-> DONE

= doing_great

# speaker={C_ROSALIND}
Well, that's great to hear!

# speaker={C_ORLANDO}
I think {player_get_pronoun_lowercase(X_THEY)} {player_get_english_be_lowercase(X_ARE)} are downplaying it... but I like the happy thoughts!

-> DONE

%empty()
~ quest_tutorial_main_spoke_to_rosalind = true

-> DONE

= table_of_contents

# speaker={C_ROSALIND}
I'd love to chat, but I need to prepare some enchantments for the weapon.

# speaker={C_ORLANDO}
Oh... ok...

# speaker={C_ORLANDO}
Hear her, %person({player_get_pronoun_uppercase(X_MX)})? Let's get going!

-> DONE
