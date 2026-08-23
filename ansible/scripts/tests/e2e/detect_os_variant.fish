#!/usr/bin/env fish
set refspec (ostree admin status 2>/dev/null | grep -oP 'ostree://\K[^: ]+' || echo "")
if echo "$refspec" | grep -q "silverblue"
  echo "silverblue"
else if echo "$refspec" | grep -q "kinoite"
  echo "kinoite"
else if echo "$refspec" | grep -q "cosmic-atomic"
  echo "cosmic-atomic"
else
  echo "silverblue"
end
