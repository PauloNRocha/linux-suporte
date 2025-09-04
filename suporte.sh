#!/bin/bash
# ==========================================================
# SUPORTE LINUX - Ferramenta de diagnóstico (v0.2.2)
# Autor: Paulo Rocha
# Licença: MIT
# ==========================================================

# Funções ---------------------------------------------

extrair_host() {
    entrada="$1"

    # Se for URL (http ou https), extrai apenas o domínio
    if [[ "$entrada" =~ ^https?:// ]]; then
        host=$(echo "$entrada" | sed -E 's#https?://([^/]+).*#\1#')
    else
        # Remove caminho (/algo) e fragmentos (#algo)
        host=$(echo "$entrada" | sed -E 's#[/|#].*##')
    fi

    # Verifica se sobrou algo válido
    if [[ -z "$host" ]]; then
        echo ""
    else
        echo "$host"
    fi
}

teste_ping() {
    read -p "Digite o host para testar: " entrada
    host=$(extrair_host "$entrada")

    if [[ -z "$host" ]]; then
        echo "Entrada inválida. Digite apenas domínio ou IP."
        return
    fi

    echo "Escolha o protocolo para o teste de ping:"
    echo "1) IPv4"
    echo "2) IPv6"
    echo "3) Ambos"
    read -p "Opção: " proto

    case $proto in
        1)
            echo ">>> Testando conectividade IPv4 com $host..."
            ping -4 -c 4 "$host" || echo "Falha no ping IPv4 para $host"
            ;;
        2)
            echo ">>> Testando conectividade IPv6 com $host..."
            ping -6 -c 4 "$host" || echo "Falha no ping IPv6 para $host"
            ;;
        3)
            echo ">>> Testando conectividade IPv4 com $host..."
            ping -4 -c 4 "$host" || echo "Falha no ping IPv4 para $host"
            echo
            echo ">>> Testando conectividade IPv6 com $host..."
            ping -6 -c 4 "$host" || echo "Falha no ping IPv6 para $host"
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac

    echo
    echo ">>> Testando conectividade com DNS do Google IPv4..."
    ping -4 -c 4 8.8.8.8
    echo
    echo ">>> Testando conectividade com DNS do Google IPv6..."
    ping -6 -c 4 2001:4860:4860::8888
}

teste_traceroute() {
    read -p "Digite o host para traceroute: " entrada
    host=$(extrair_host "$entrada")

    if [[ -z "$host" ]]; then
        echo "Entrada inválida. Digite apenas domínio ou IP."
        return
    fi

    if ! command -v traceroute &>/dev/null; then
        echo ">>> O comando 'traceroute' não está instalado."
        echo ">>> Instale com: sudo apt install traceroute"
        return
    fi

    echo "Escolha o protocolo para o traceroute:"
    echo "1) IPv4"
    echo "2) IPv6"
    echo "3) Ambos"
    read -p "Opção: " proto

    case $proto in
        1)
            echo ">>> Rastreando rota IPv4 até $host..."
            traceroute -4 "$host"
            ;;
        2)
            echo ">>> Rastreando rota IPv6 até $host..."
            traceroute -6 "$host"
            ;;
        3)
            echo ">>> Rastreando rota IPv4 até $host..."
            traceroute -4 "$host"
            echo
            echo ">>> Rastreando rota IPv6 até $host..."
            traceroute -6 "$host"
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac
}

info_sistema() {
    echo ">>> Informações de Hardware"
    cpu=$(lscpu | grep -E 'Model name|Nome do modelo' | sed 's/.*:\s*//')
    echo "CPU: ${cpu:-Não foi possível detectar}"
    echo
    echo "Memória RAM:"
    free -h
    echo
    echo "Disco rígido:"
    df -h --total | grep total
}

info_rede() {
    echo ">>> Informações de Rede"
    ip addr show | grep "inet "
    echo "Gateway: $(ip route | grep default | awk '{print $3}')"
    echo "DNS: $(grep nameserver /etc/resolv.conf | awk '{print $2}')"
}

# Menu principal --------------------------------------

while true; do
    clear
    echo "======================================"
    echo "   SUPORTE LINUX - Ferramenta v0.2.2"
    echo "======================================"
    echo "Escolha uma opção:"
    echo "1) Teste de Ping"
    echo "2) Teste de Traceroute"
    echo "3) Informações do Sistema"
    echo "4) Informações de Rede"
    echo "0) Sair"
    echo "--------------------------------------"
    read -p "Opção: " opt

    case $opt in
        1) teste_ping ;;
        2) teste_traceroute ;;
        3) info_sistema ;;
        4) info_rede ;;
        0) echo "Saindo..."; exit ;;
        *) echo "Opção inválida!" ;;
    esac

    echo
    read -p "Pressione ENTER para voltar ao menu..."
done
