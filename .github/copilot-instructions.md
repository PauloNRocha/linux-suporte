applyTo
suporte.sh, modules/**/*.sh, docs/**/*.md, .github/**/*.md

# Project Overview

O **linux-suporte** é uma ferramenta em shell script voltada para **diagnóstico, manutenção e suporte técnico** em sistemas Linux.  
Seu objetivo é fornecer um **conjunto padronizado de utilitários** para administradores de sistemas, equipes de suporte e provedores de internet, simplificando tarefas comuns de troubleshooting e coleta de informações.

A ideia é ser um **"canivete suíço de suporte Linux"**, prático para uso em campo ou remotamente, chamando atenção pela simplicidade e utilidade.

# Features (planejadas e futuras)

- Coleta de informações do sistema (uptime, kernel, memória, CPU, disco).
- Verificação de conectividade (ping, traceroute, DNS lookup, testes IPv6/IPv4).
- Diagnóstico de rede (interfaces, rotas, portas abertas, conexões ativas).
- Logs e monitoramento (últimas mensagens do syslog, journald, falhas recentes).
- Testes rápidos de performance (velocidade de rede, benchmark de disco/memória).
- Ferramentas de suporte remoto (empacotar logs e configs para envio).
- Menu interativo para facilitar o uso (modo TUI com `dialog` ou `whiptail`).
- Exportar relatórios em **.txt ou .json** para anexar em chamados.
- Sistema de versão interna (mostra versão do script).
- Todas as funcionalidades ficam centralizadas em um único script (suporte.sh).

# Folder Structure

- `suporte.sh`: Script principal o "canivete suíço".
- `.github/`: Instruções para contribuidores, CI/CD (futuro).
- `docs`: Documentação

# Libraries and Standards

- Escrita 100% em **Bash (POSIX compatível)**.
- Uso de comandos padrão disponíveis em qualquer distribuição Linux (`ip`, `ping`, `free`, `df`, etc).
- Comentários e mensagens sempre em **português claro**.
- Seguir boas práticas de shell script: `set -euo pipefail`.

# UI Guidelines

- Saída organizada, com separadores e ícones (✓, ✗, ➜).
- Menu interativo opcional para iniciantes.
- Suporte a **cores ANSI** (verde para sucesso, vermelho para erro, amarelo para alerta).
- Logs exportáveis para análise posterior.

# Roadmap

- **v0.2** → comandos básicos já organizados dentro de um único script.
- **v0.3** → Relatórios exportáveis + empacotamento de logs.
- **v0.4** → Menu interativo (dialog/whiptail).
- **v0.5** → Suporte remoto (ex: enviar pacotes de diagnóstico).
- **...**
- **v1.0** → Versão estável com documentação completa e testes.

