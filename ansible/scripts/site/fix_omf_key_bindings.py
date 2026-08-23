#!/usr/bin/env python3
"""Fix OMF recursive key bindings bug.

OMF init.fish copies fish_user_key_bindings to __original_fish_user_key_bindings,
then the new function calls __original_fish_user_key_bindings — infinite recursion.
This removes the backup/restore logic.
"""
import pathlib

omf_init = pathlib.Path.home() / ".local/share/omf/init.fish"
if not omf_init.exists():
    print("OMF init.fish not found, skipping")
    raise SystemExit(0)

text = omf_init.read_text()
if "__original_fish_user_key_bindings" not in text:
    print("Already fixed")
    raise SystemExit(0)

text = text.replace(
    "# Backup key bindings\n"
    "functions -q fish_user_key_bindings\n"
    "  and not functions -q __original_fish_user_key_bindings\n"
    "  and functions -c fish_user_key_bindings __original_fish_user_key_bindings\n",
    "",
)
text = text.replace(
    "  # Call original key bindings if existent\n"
    "  functions -q __original_fish_user_key_bindings\n"
    "    and __original_fish_user_key_bindings\n",
    "",
)
omf_init.write_text(text)
print("Fixed OMF init.fish")
