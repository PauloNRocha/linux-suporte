# Objetivo

Esta é uma ferramenta prática para suporte técnico em sistemas Linux. O objetivo é ajudar profissionais de TI a diagnosticar e resolver problemas de forma eficiente — útil tanto para técnicos de campo em provedores de internet quanto para usuários e administradores de sistemas.

A ideia é reunir em um único script testes úteis e informações relevantes, sem complicação e sem precisar decorar comandos complexos. A ferramenta é simples, direta e prática, ajudando a economizar tempo na resolução de problemas comuns.

## Princípios

- Simplicidade: fácil de rodar, até para quem não é avançado.
- Clareza: mostrar resultados limpos e objetivos, sem poluição visual.
- Compatibilidade: funcionar no máximo de distribuições possível.
- Evolução aberta: o código é colaborativo e aberto a contribuições.

## Quem pode se beneficiar

- Técnicos de suporte e de campo em provedores de internet.
- Administradores de sistemas iniciantes ou avançados.
- Profissionais de TI que precisam de diagnósticos rápidos e eficientes.
- Usuários Linux que querem uma "caixa de ferramentas" pronta para diagnósticos.
- Quem precisa coletar informações rápidas para abrir um chamado.

## Funcionalidades atuais (v0.2)

- Testes de conectividade: ping IPv4 e IPv6.
- Teste de rotas: traceroute.
- Exibição de informações do sistema: CPU, memória e disco.
- Informações de rede: IP, gateway, DNS.
- Interface interativa no terminal com menus simples.
- Saídas claras e objetivas para facilitar suporte remoto.

## Planejamento (roadmap)

- Testes de DNS e HTTP/HTTPS.
- Verificação de portas abertas e conectividade em serviços comuns.
- Exportação de relatórios em .txt ou .html.
- Integração com logs e coleta de erros frequentes.
- Automação de correções simples (ex.: renovar DHCP, reiniciar rede).
- Melhorias na interface interativa com navegação por menus.

## Como contribuir

- Manter o código simples e bem comentado.
- Garantir compatibilidade com múltiplas distros.
- Sugerir melhorias com valor real para o dia a dia.

## Padrões de codificação

- Código simples e bem comentado para facilitar contribuições.
- Evitar dependências externas desnecessárias.
- Seguir boas práticas de compatibilidade entre distribuições.
- Mensagens claras e consistentes no output.

## Bibliotecas e Ferramentas

- Shell script (Bash).
- Dependências externas mínimas:
  - ip, ping
  - traceroute (ou tracepath)
  - df, free

## Diretrizes de interface do usuário

- Interface baseada em menus no terminal.
- Saídas limpas, sem poluição visual.
- Destaques visuais (sucesso/erro/alerta) para facilitar leitura.
- Compatibilidade com terminais padrão (sem exigir recursos gráficos).
