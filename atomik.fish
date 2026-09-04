#!/usr/bin/env fish

set -l script_dir (cd (dirname (status filename)); and pwd)
set -gx ANSIBLE_CONFIG "$script_dir/ansible/ansible.cfg"
set -l inventory "$script_dir/ansible/inventories/localhost/hosts.yml"

set -l ansible_bin (command -v ansible-playbook; or echo "$HOME/.local/bin/ansible-playbook")
if not test -x "$ansible_bin"
    echo (set_color red)"Errore: ansible-playbook non trovato in PATH o ~/.local/bin."(set_color normal) >&2
    exit 1
end

function in_flatpak
    test -f /.flatpak-info; or test -n "$FLATPAK_ID"; or test -f /run/.toolboxenv
end

function host_cmd
    if in_flatpak
        flatpak-spawn --host $argv
    else
        $argv
    end
end

function run_root -V script_dir -V ANSIBLE_CONFIG
    if test (id -u) -eq 0
        $argv
    else if in_flatpak
        flatpak-spawn --host pkexec env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" $argv
    else if command -v pkexec >/dev/null 2>&1; and test -n "$DISPLAY" -o -n "$WAYLAND_DISPLAY"
        pkexec env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" $argv
    else
        sudo env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" $argv
    end
end

function run_user -V script_dir
    if in_flatpak
        flatpak-spawn --host $argv
    else
        $argv
    end
end

function show_usage
    echo (set_color blue)"Atomik Management CLI (Fish)"(set_color normal)
    echo "Uso: ./atomik.fish <comando> [opzioni ansible-playbook...]"
    echo ""
    echo (set_color green)"Core & Sistema (richiede elevazione privilegi via pkexec/sudo):"(set_color normal)
    echo "  core             Applica la configurazione di sistema (ansible/site.yml)"
    echo "  all              Applica core + tutti i moduli extra"
    echo "  security         Applica sicurezza, tuning GPU, thermald, udev e kernel"
    echo "  repos            Configura i repository di sistema"
    echo "  packages         Applica i pacchetti rpm-ostree"
    echo "  install-deps     Installa ansible-core e le collezioni via rpm-ostree"
    echo ""
    echo (set_color green)"Desktop & Ambiente Utente (nessun root/password richiesto):"(set_color normal)
    echo "  desktop          Configura il desktop environment (COSMIC/GNOME/KDE)"
    echo "  cosmic           Configura COSMIC desktop, idle (no spegnimento) e temi"
    echo "  extra            Applica tutti i moduli extra (flatpak, gaming, devtools, ecc.)"
    echo "  flatpak          Installa e configura i Flatpak base"
    echo "  gaming           Installa i Flatpak da gaming (Discord, Heroic) con Wayland"
    echo "  business         Installa i Flatpak da lavoro (Slack) con Wayland"
    echo "  devtools         Installa i tool di sviluppo (rustup, pnpm)"
    echo "  codium           Installa e ottimizza VSCodium"
    echo ""
    echo (set_color green)"Verifica & Qualità:"(set_color normal)
    echo "  lint             Controlla la sintassi di tutti i playbook"
    echo "  test             Esegue la suite di test end-to-end"
    echo "  clean            Rimuove file temporanei e file .retry"
    echo ""
    echo (set_color yellow)"Esempi d'uso:"(set_color normal)
    echo "  ./atomik.fish cosmic"
    echo "  ./atomik.fish security"
    echo "  ./atomik.fish flatpak"
    echo "  ./atomik.fish core --check"
end

set -l cmd $argv[1]
set -l extra_args $argv[2..-1]

switch "$cmd"
    case core
        echo (set_color blue)"==>"(set_color normal) "Applicazione configurazione core di sistema..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory $extra_args

    case all
        echo (set_color blue)"==>"(set_color normal) "Applicazione configurazione core..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory $extra_args
        for extra in flatpak gaming business devtools codium
            if test -f "$script_dir/extra/$extra/site.yml"
                echo (set_color blue)"==>"(set_color normal) "Applicazione extra/$extra..."
                run_user $ansible_bin $script_dir/extra/$extra/site.yml -i $inventory $extra_args
            end
        end

    case security
        echo (set_color blue)"==>"(set_color normal) "Applicazione sicurezza e tuning hardware..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags security $extra_args

    case repos
        echo (set_color blue)"==>"(set_color normal) "Applicazione configurazione repository..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags repos $extra_args

    case packages
        echo (set_color blue)"==>"(set_color normal) "Applicazione pacchetti rpm-ostree..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags packages $extra_args

    case desktop
        echo (set_color blue)"==>"(set_color normal) "Applicazione configurazione desktop..."
        run_user $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags desktop $extra_args

    case cosmic
        echo (set_color blue)"==>"(set_color normal) "Applicazione configurazione COSMIC (idle, temi, scorciatoie)..."
        run_user $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags cosmic $extra_args

    case extra
        echo (set_color blue)"==>"(set_color normal) "Applicazione di tutti i moduli extra..."
        for extra in flatpak gaming business devtools codium
            if test -f "$script_dir/extra/$extra/site.yml"
                echo (set_color blue)"==>"(set_color normal) "Applicazione extra/$extra..."
                run_user $ansible_bin $script_dir/extra/$extra/site.yml -i $inventory $extra_args
            end
        end

    case flatpak
        echo (set_color blue)"==>"(set_color normal) "Applicazione Flatpak base..."
        run_user $ansible_bin $script_dir/extra/flatpak/site.yml -i $inventory $extra_args

    case gaming
        echo (set_color blue)"==>"(set_color normal) "Applicazione Flatpak gaming..."
        run_user $ansible_bin $script_dir/extra/gaming/site.yml -i $inventory $extra_args

    case business
        echo (set_color blue)"==>"(set_color normal) "Applicazione Flatpak business..."
        run_user $ansible_bin $script_dir/extra/business/site.yml -i $inventory $extra_args

    case devtools
        echo (set_color blue)"==>"(set_color normal) "Applicazione tool di sviluppo..."
        run_user $ansible_bin $script_dir/extra/devtools/site.yml -i $inventory $extra_args

    case codium
        echo (set_color blue)"==>"(set_color normal) "Applicazione VSCodium..."
        run_user $ansible_bin $script_dir/extra/codium/site.yml -i $inventory $extra_args

    case lint
        echo (set_color blue)"==>"(set_color normal) "Verifica sintassi dei playbook..."
        for pb in $script_dir/ansible/site.yml $script_dir/tests/e2e.yml $script_dir/extra/*/site.yml
            if test -f "$pb"
                $ansible_bin --syntax-check "$pb" -i $inventory
            end
        end

    case test
        echo (set_color blue)"==>"(set_color normal) "Esecuzione suite di test e2e..."
        run_user $ansible_bin $script_dir/tests/e2e.yml -i $inventory -c local $extra_args

    case install-deps
        echo (set_color blue)"==>"(set_color normal) "Installazione ansible-core e collezioni..."
        run_root rpm-ostree install -y --idempotent --apply-live ansible-core python3-ansible-lint
        run_user ansible-galaxy collection install ansible.posix community.general

    case clean
        echo (set_color blue)"==>"(set_color normal) "Pulizia file temporanei..."
        rm -f $script_dir/ansible/*.retry $script_dir/tests/*.retry
        echo "Pulizia completata."

    case help --help -h ""
        show_usage

    case '*'
        echo (set_color red)"Errore: Comando sconosciuto '$cmd'"(set_color normal) >&2
        echo ""
        show_usage
        exit 1
end
