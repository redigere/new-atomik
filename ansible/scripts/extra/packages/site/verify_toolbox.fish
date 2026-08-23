#!/usr/bin/env fish
set SAVED $TOOLBOX_BEFORE
if test -z "$SAVED"
    echo "no_toolbox_containers"
    exit 0
end
set CURRENT (podman ps -a --filter label=com.github.containers.toolbox=true --format '{{.Names}}' 2>/dev/null | sort | tr '\n' ' ')
for name in $SAVED
    set FOUND 0
    for cname in $CURRENT
        if test "$name" = "$cname"
            set FOUND 1
            break
        end
    end
    if test "$FOUND" = 0
        echo "MISSING: $name"
    end
end
