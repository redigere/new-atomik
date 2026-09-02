if status is-interactive
    set -g fish_greeting ""
    set -g fish_history_max 10000
    alias ll="ls -l"
    alias la="ls -la"
    alias update="rpm-ostree upgrade"
    alias cleanup="rpm-ostree cleanup -mp --base --rollback"
    alias rebuild="rpm-ostree initramfs --enable && rpm-ostree upgrade"
end
