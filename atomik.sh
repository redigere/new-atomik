#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ANSIBLE_CONFIG="${SCRIPT_DIR}/ansible/ansible.cfg"
INVENTORY="${SCRIPT_DIR}/ansible/inventories/localhost/hosts.yml"

ANSIBLE_BIN="$(command -v ansible-playbook || echo "${HOME}/.local/bin/ansible-playbook")"
if [[ ! -x "$ANSIBLE_BIN" ]]; then
    echo "Error: ansible-playbook not found in PATH or ~/.local/bin." >&2
    exit 1
fi

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

in_flatpak() {
    [[ -f /.flatpak-info ]] || [[ -n "${FLATPAK_ID:-}" ]] || [[ -f /run/.toolboxenv ]]
}

host_cmd() {
    if in_flatpak; then
        flatpak-spawn --host "$@"
    else
        "$@"
    fi
}

run_root() {
    local cmd=("$@")
    if [[ $EUID -eq 0 ]]; then
        "${cmd[@]}"
    elif in_flatpak; then
        flatpak-spawn --host pkexec env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" "${cmd[@]}"
    elif command -v pkexec >/dev/null 2>&1 && [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
        pkexec env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" "${cmd[@]}"
    else
        sudo env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" "${cmd[@]}"
    fi
}

run_user() {
    local cmd=("$@")
    if in_flatpak; then
        flatpak-spawn --host "${cmd[@]}"
    else
        "${cmd[@]}"
    fi
}

usage() {
    echo -e "${BLUE}Atomik Management CLI (Bash)${NC}"
    echo -e "Usage: ./atomik.sh <command> [ansible-playbook options...]"
    echo ""
    echo -e "${GREEN}Core & System (richiede elevazione privilegi via pkexec/sudo):${NC}"
    echo "  core             Applica la configurazione di sistema (ansible/site.yml)"
    echo "  all              Applica core + tutti i moduli extra"
    echo "  security         Applica sicurezza, tuning GPU, thermald, udev e kernel"
    echo "  repos            Configura i repository di sistema"
    echo "  packages         Applica i pacchetti rpm-ostree"
    echo "  install-deps     Installa ansible-core e le collezioni via rpm-ostree"
    echo ""
    echo -e "${GREEN}Desktop & Ambiente Utente (nessun root/password richiesto):${NC}"
    echo "  desktop          Configura il desktop environment (COSMIC/GNOME/KDE)"
    echo "  cosmic           Configura COSMIC desktop, idle (no spegnimento) e temi"
    echo "  extra            Applica tutti i moduli extra (flatpak, gaming, devtools, ecc.)"
    echo "  flatpak          Installa e configura i Flatpak base"
    echo "  gaming           Installa i Flatpak da gaming (Discord, Heroic) con Wayland"
    echo "  business         Installa i Flatpak da lavoro (Slack) con Wayland"
    echo "  devtools         Installa i tool di sviluppo (rustup, pnpm)"
    echo "  codium           Installa e ottimizza VSCodium"
    echo ""
    echo -e "${GREEN}Verifica & Qualità:${NC}"
    echo "  lint             Controlla la sintassi di tutti i playbook"
    echo "  test             Esegue la suite di test end-to-end"
    echo "  clean            Rimuove file temporanei e file .retry"
    echo ""
    echo -e "${YELLOW}Esempi d'uso:${NC}"
    echo "  ./atomik.sh cosmic"
    echo "  ./atomik.sh security"
    echo "  ./atomik.sh flatpak"
    echo "  ./atomik.sh core --check"
}

CMD="${1:-help}"
shift || true

case "$CMD" in
    core)
        echo -e "${BLUE}==>${NC} Applicazione configurazione core di sistema..."
        run_root "$ANSIBLE_BIN" "${SCRIPT_DIR}/ansible/site.yml" -i "$INVENTORY" "$@"
        ;;
    all)
        echo -e "${BLUE}==>${NC} Applicazione configurazione core..."
        run_root "$ANSIBLE_BIN" "${SCRIPT_DIR}/ansible/site.yml" -i "$INVENTORY" "$@"
        echo -e "${BLUE}==>${NC} Applicazione moduli extra..."
        for extra in flatpak gaming business devtools codium; do
            if [[ -f "${SCRIPT_DIR}/extra/${extra}/site.yml" ]]; then
                echo -e "${BLUE}==>${NC} Applicazione extra/${extra}..."
                run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/extra/${extra}/site.yml" -i "$INVENTORY" "$@"
            fi
        done
        ;;
    security)
        echo -e "${BLUE}==>${NC} Applicazione sicurezza e tuning hardware..."
        run_root "$ANSIBLE_BIN" "${SCRIPT_DIR}/ansible/site.yml" -i "$INVENTORY" --tags security "$@"
        ;;
    repos)
        echo -e "${BLUE}==>${NC} Applicazione configurazione repository..."
        run_root "$ANSIBLE_BIN" "${SCRIPT_DIR}/ansible/site.yml" -i "$INVENTORY" --tags repos "$@"
        ;;
    packages)
        echo -e "${BLUE}==>${NC} Applicazione pacchetti rpm-ostree..."
        run_root "$ANSIBLE_BIN" "${SCRIPT_DIR}/ansible/site.yml" -i "$INVENTORY" --tags packages "$@"
        ;;
    desktop)
        echo -e "${BLUE}==>${NC} Applicazione configurazione desktop..."
        run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/ansible/site.yml" -i "$INVENTORY" --tags desktop "$@"
        ;;
    cosmic)
        echo -e "${BLUE}==>${NC} Applicazione configurazione COSMIC (idle, temi, scorciatoie)..."
        run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/ansible/site.yml" -i "$INVENTORY" --tags cosmic "$@"
        ;;
    extra)
        echo -e "${BLUE}==>${NC} Applicazione di tutti i moduli extra..."
        for extra in flatpak gaming business devtools codium; do
            if [[ -f "${SCRIPT_DIR}/extra/${extra}/site.yml" ]]; then
                echo -e "${BLUE}==>${NC} Applicazione extra/${extra}..."
                run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/extra/${extra}/site.yml" -i "$INVENTORY" "$@"
            fi
        done
        ;;
    flatpak)
        echo -e "${BLUE}==>${NC} Applicazione Flatpak base..."
        run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/extra/flatpak/site.yml" -i "$INVENTORY" "$@"
        ;;
    gaming)
        echo -e "${BLUE}==>${NC} Applicazione Flatpak gaming..."
        run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/extra/gaming/site.yml" -i "$INVENTORY" "$@"
        ;;
    business)
        echo -e "${BLUE}==>${NC} Applicazione Flatpak business..."
        run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/extra/business/site.yml" -i "$INVENTORY" "$@"
        ;;
    devtools)
        echo -e "${BLUE}==>${NC} Applicazione tool di sviluppo..."
        run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/extra/devtools/site.yml" -i "$INVENTORY" "$@"
        ;;
    codium)
        echo -e "${BLUE}==>${NC} Applicazione VSCodium..."
        run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/extra/codium/site.yml" -i "$INVENTORY" "$@"
        ;;
    lint)
        echo -e "${BLUE}==>${NC} Verifica sintassi dei playbook..."
        for pb in "${SCRIPT_DIR}"/ansible/site.yml "${SCRIPT_DIR}"/tests/e2e.yml "${SCRIPT_DIR}"/extra/*/site.yml; do
            if [[ -f "$pb" ]]; then
                "$ANSIBLE_BIN" --syntax-check "$pb" -i "$INVENTORY"
            fi
        done
        ;;
    test)
        echo -e "${BLUE}==>${NC} Esecuzione suite di test e2e..."
        run_user "$ANSIBLE_BIN" "${SCRIPT_DIR}/tests/e2e.yml" -i "$INVENTORY" -c local "$@"
        ;;
    install-deps)
        echo -e "${BLUE}==>${NC} Installazione ansible-core e collezioni..."
        run_root rpm-ostree install -y --idempotent --apply-live ansible-core python3-ansible-lint
        run_user ansible-galaxy collection install ansible.posix community.general
        ;;
    clean)
        echo -e "${BLUE}==>${NC} Pulizia file temporanei..."
        rm -f "${SCRIPT_DIR}"/ansible/*.retry "${SCRIPT_DIR}"/tests/*.retry
        echo "Pulizia completata."
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        echo -e "${RED}Errore: Comando sconosciuto '$CMD'${NC}" >&2
        echo ""
        usage
        exit 1
        ;;
esac
