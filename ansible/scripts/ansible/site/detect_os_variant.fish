#!/usr/bin/env fish
set refspec (rpm-ostree status 2>/dev/null | head -20 | grep -oP 'fedora:[^ ]+' | head -1; or echo "")
if echo "$refspec" | grep -q "silverblue"
  echo "silverblue"
else if echo "$refspec" | grep -q "kinoite"
  echo "kinoite"
else if echo "$refspec" | grep -q "cosmic-atomic"
  echo "cosmic-atomic"
else
  echo "silverblue"
end
