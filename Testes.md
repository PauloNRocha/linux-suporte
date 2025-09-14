# Checklist de Testes - Script Suporte Técnico v0.2

## 1. Usabilidade

- Menus estão claros e intuitivos.
- É possível voltar ao menu anterior sem travar.
- Mensagens de erro são compreensíveis.
- Saída é legível (sem excesso de informação).

## 2. Funcionalidade
**Testes de Rede**

- ping com domínio válido retorna resposta.
- ping com domínio inválido mostra erro esperado.
- traceroute mostra saltos corretamente.
- dig resolve domínio válido.
- dig retorna erro em domínio inexistente.

**Testes de Sistema**

- ifconfig ou ip addr mostra interfaces corretamente.
- ip route lista rotas padrão.
- ss ou netstat lista conexões ativas.
- Exibição de logs (dmesg, journalctl, tail -f) funciona.

## 3. Compatibilidade

- Testado no Debian/Ubuntu.
- Testado no CentOS/RHEL.
- Testado em outra shell (ex: zsh ou dash).
- Rodou em VM/bare-metal.
- Rodou em container Docker.

## 4. Resiliência

- Interrupção com Ctrl+C não quebra o script permanentemente.
- Executado como usuário comum mostra erros apropriados para funções que exigem root.
- Script lida com ausência de comandos (dig, net-tools, etc.) mostrando mensagem clara.

## 5. Performance

- Várias funções executadas em sequência não travam.
- tail -f sai corretamente ao encerrar com Ctrl+C.
- Não gera processos zumbis ou travados.

## 6. Logs e Auditoria

- Saída do script pode ser registrada em ~/.suporte.log.
- Log é legível (separado por data/hora).
- Log não cresce descontroladamente em execuções curtas.

## Sugestão de Cenário Ideal

- VM Debian/Ubuntu com snapshot.
- Outra VM ou container para simular rede.
- Executar como root e como usuário comum.
- Desinstalar pacotes (dig, net-tools) para testar falhas.
- Cortar conexão com a internet e repetir os testes.
