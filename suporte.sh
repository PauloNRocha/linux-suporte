#!/usr/bin/env bash
# ==========================================================
# SUPORTE LINUX - Ferramenta de diagnóstico (v0.2.3)
# Autor: Paulo Rocha
# Licença: MIT
# ==========================================================

set -Eeuo pipefail
VERSION="0.2.3"

trap 'echo; echo "[!] Interrompido"; exit 130' INT TERM

# Cores (se saída é um terminal)
if [[ -t 1 ]]; then
  C_GREEN="\033[32m"; C_YELLOW="\033[33m"; C_RED="\033[31m"; C_BLUE="\033[34m"; C_RESET="\033[0m"
else
  C_GREEN=""; C_YELLOW=""; C_RED=""; C_BLUE=""; C_RESET=""
fi

ok()   { echo -e "${C_GREEN}[OK]${C_RESET} $*"; }
warn() { echo -e "${C_YELLOW}[!]${C_RESET} $*"; }
err()  { echo -e "${C_RED}[X]${C_RESET} $*" 1>&2; }

has_cmd() { command -v "$1" >/dev/null 2>&1; }

require_cmd() {
  local missing=()
  for c in "$@"; do
    if ! has_cmd "$c"; then missing+=("$c"); fi
  done
  if ((${#missing[@]})); then
    err "Comandos ausentes: ${missing[*]}"
    err "Instale os pacotes necessários e tente novamente."
    return 127
  fi
}

# ---------------------------------------------------------
# Funções utilitárias
# ---------------------------------------------------------

extrair_host() {
  # Extrai host de entradas como: url, domínio, IPv4, [IPv6], host:porta, url/caminho
  local entrada="$1"
  local host="$entrada"

  # Remove esquema (ex.: http://, https://, tcp://)
  if [[ "$host" == *"://"* ]]; then
    host="${host#*://}"
  fi

  # Remove caminho, query e fragmento
  host="${host%%/*}"
  host="${host%%\?*}"
  host="${host%%#*}"

  # Remove usuário@ (caso URL de credenciais)
  if [[ "$host" == *"@"* ]]; then
    host="${host##*@}"
  fi

  # Remove colchetes de IPv6
  host="${host#[}"
  host="${host%]}"

  # Remover :porta quando não for IPv6 puro
  if [[ "$host" == *:* ]]; then
    # Conta o número de ':'
    local colons="${host//[^:]}"
    if ((${#colons} == 1)); then
      host="${host%%:*}"
    fi
  else
    host="${host%%:*}"
  fi

  # Sanitiza espaços
  host="${host## }"; host="${host%% }"

  [[ -n "$host" ]] && echo "$host" || echo ""
}

teste_ping() {
  read -r -p "Digite o host para testar: " entrada
  local host
  host=$(extrair_host "$entrada")

  if [[ -z "$host" ]]; then
    err "Entrada inválida. Digite apenas domínio ou IP."
    return 1
  fi

  echo "Escolha o protocolo para o teste de ping:"
  echo "1) IPv4"
  echo "2) IPv6"
  echo "3) Ambos"
  read -r -p "Opção: " proto

  case $proto in
    1)
      echo ">>> Testando conectividade IPv4 com $host..."
      if ! ping -4 -c 4 "$host"; then warn "Falha no ping IPv4 para $host"; fi
      ;;
    2)
      echo ">>> Testando conectividade IPv6 com $host..."
      if ! ping -6 -c 4 "$host"; then warn "Falha no ping IPv6 para $host"; fi
      ;;
    3)
      echo ">>> Testando conectividade IPv4 com $host..."; ping -4 -c 4 "$host" || warn "Falha no ping IPv4 para $host"
      echo
      echo ">>> Testando conectividade IPv6 com $host..."; ping -6 -c 4 "$host" || warn "Falha no ping IPv6 para $host"
      ;;
    *)
      err "Opção inválida!"; return 1
      ;;
  esac

  echo
  echo ">>> Testando conectividade com DNS do Google IPv4..."
  ping -4 -c 4 8.8.8.8 || warn "Falha no ping IPv4 para 8.8.8.8"
  echo
  echo ">>> Testando conectividade com DNS do Google IPv6..."
  ping -6 -c 4 2001:4860:4860::8888 || warn "Falha no ping IPv6 para 2001:4860:4860::8888"
}

_run_trace() {
  local ipver="$1" host="$2"
  if has_cmd traceroute; then
    traceroute "$ipver" "$host"
  elif has_cmd tracepath; then
    # tracepath aceita -4/-6
    tracepath "$ipver" "$host"
  else
    err "Nem 'traceroute' nem 'tracepath' estão instalados."
    echo ">>> Instale com: sudo apt install traceroute";
    return 127
  fi
}

teste_traceroute() {
  read -r -p "Digite o host para traceroute: " entrada
  local host
  host=$(extrair_host "$entrada")

  if [[ -z "$host" ]]; then
    err "Entrada inválida. Digite apenas domínio ou IP."
    return 1
  fi

  echo "Escolha o protocolo para o traceroute:"
  echo "1) IPv4"
  echo "2) IPv6"
  echo "3) Ambos"
  read -r -p "Opção: " proto

  case $proto in
    1)
      echo ">>> Rastreando rota IPv4 até $host..."
      _run_trace -4 "$host"
      ;;
    2)
      echo ">>> Rastreando rota IPv6 até $host..."
      _run_trace -6 "$host"
      ;;
    3)
      echo ">>> Rastreando rota IPv4 até $host..."; _run_trace -4 "$host"
      echo
      echo ">>> Rastreando rota IPv6 até $host..."; _run_trace -6 "$host"
      ;;
    *)
      err "Opção inválida!"; return 1
      ;;
  esac
}

info_sistema() {
  echo ">>> Informações de Hardware"
  local cpu=""
  if has_cmd lscpu; then
    cpu=$(lscpu | awk -F: '/Model name|Nome do modelo/ {gsub(/^ +| +$/, "", $2); print $2; exit}')
  fi
  if [[ -z "$cpu" && -r /proc/cpuinfo ]]; then
    cpu=$(awk -F: '/model name/ {gsub(/^ +| +$/, "", $2); print $2; exit}' /proc/cpuinfo || true)
  fi
  echo "CPU: ${cpu:-Não foi possível detectar}"
  echo
  echo "Memória RAM:"
  if has_cmd free; then free -h; else warn "'free' não encontrado"; fi
  echo
  echo "Disco rígido:"
  if has_cmd df; then df -h --total | awk 'END{print}'; else warn "'df' não encontrado"; fi
}

info_rede() {
  echo ">>> Informações de Rede"
  if has_cmd ip; then
    echo "Endereços IPv4:"
    ip -o -4 addr show | awk '{print $2 ": " $4}'
    echo
    echo "Endereços IPv6:"
    ip -o -6 addr show | awk '{print $2 ": " $4}'
    echo
    local gw4 gw6
    gw4=$(ip -4 route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++){if($i=="via"){print $(i+1)}}}' | head -n1)
    gw6=$(ip -6 route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++){if($i=="via"){print $(i+1)}}}' | head -n1)
    echo "Gateway IPv4: ${gw4:-N/D}"
    echo "Gateway IPv6: ${gw6:-N/D}"
  else
    warn "'ip' não encontrado"
  fi

  echo
  echo "DNS:" 
  if has_cmd resolvectl; then
    resolvectl dns || true
  elif [[ -r /etc/resolv.conf ]]; then
    grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}' || true
  else
    warn "Não foi possível determinar DNS"
  fi
}

# ---------------------------------------------------------
# Menu principal
# ---------------------------------------------------------

while true; do
  clear || true
  echo "======================================"
  echo "   SUPORTE LINUX - Ferramenta v$VERSION"
  echo "======================================"
  echo "Escolha uma opção:"
  echo "1) Teste de Ping"
  echo "2) Teste de Traceroute"
  echo "3) Informações do Sistema"
  echo "4) Informações de Rede"
  echo "0) Sair"
  echo "--------------------------------------"
  read -r -p "Opção: " opt || { echo; exit 0; }

  case $opt in
    1) teste_ping ;;
    2) teste_traceroute ;;
    3) info_sistema ;;
    4) info_rede ;;
    0) echo "Saindo..."; exit 0 ;;
    *) err "Opção inválida!" ;;
  esac

  echo
  read -r -p "Pressione ENTER para voltar ao menu..." _pause || true
done

