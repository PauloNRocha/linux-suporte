#!/bin/bash
# ==========================================================
# SUPORTE LINUX - Ferramenta de diagnóstico (MVP v0.1)
# Autor: Paulo Rocha
# Licença: MIT
# ==========================================================

# Funções ---------------------------------------------

teste_ping() {
    read -p "Digite o host para testar: " host
    echo ">>> Testando conectividade com $host..."
    ping -c 4 "$host"
    echo
    echo ">>> Testando conectividade com DNS do Google IPv4..."
    ping -c 4 8.8.8.8
    echo
    echo ">>> Testando conectividade com DNS do Google IPv6..."
    ping6 -c 4 2001:4860:4860::8888
}

teste_traceroute() {
    read -p "Digite o host para traceroute: " host
    echo ">>> Rastreando rota até $host..."
    traceroute "$host"
}

info_sistema() {
    echo ">>> Informações de Hardware"
    echo "CPU: $(lscpu | grep 'Model name' | sed 's/Model name:\s*//')"
    echo "Memória RAM:"
    free -h
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
    echo "     SUPORTE LINUX - Ferramenta v0.1"
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
