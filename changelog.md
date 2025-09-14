# Changelog

Todas as mudanças notáveis deste projeto serão documentadas aqui.

## v0.2.3

Versão focada em robustez, mensagens claras e compatibilidade de ambiente (UTF-8/LF), além de pequenas melhorias de diagnóstico e usabilidade.

### Adicionado
- Banner com versão interna `v0.2.3`.
- Tratamento de interrupção com `trap` (Ctrl+C) e mensagens padronizadas.
- Helpers de saída com cores e níveis (`ok`, `warn`, `err`) quando em TTY.
- Fallback de rota: usa `tracepath` quando `traceroute` não está disponível.
- Detecção de DNS via `resolvectl dns` (quando disponível), com fallback para `/etc/resolv.conf`.

### Alterado
- `extrair_host` mais resiliente: remove esquema (`http(s)://`), caminho, query, fragmento, `usuario@host`, colchetes em IPv6 e porta quando aplicável.
- Testes de ping exibem avisos claros em falhas (sem quebrar o fluxo).
- Informações de rede agora mostram IPv4 e IPv6 por interface, além de gateways v4/v6 separados.
- Informações de sistema com fallback para `/proc/cpuinfo` quando `lscpu` não existe.
- Normalização de codificação e EOL: todos os arquivos em UTF-8 e LF; `.gitattributes` força LF em `.sh` e `.md`.
- `.gitignore` não ignora mais `Testes.md`; `README` atualizado com requisitos e instruções corrigidas.

### Corrigido
- Acentuação corrompida (UTF-8) em vários arquivos.
- Inconsistência no diretório de instalação do README (`cd linux-suporte`).
- Mensagens de erro/entrada inválida padronizadas e mais legíveis.

## v0.2.2

### Adicionado
- Opção para escolher protocolo (IPv4, IPv6 ou ambos) nos testes de Ping e Traceroute.
- Melhoria na função `extrair_host` para lidar com URLs contendo caminhos ou fragmentos.

## v0.2.1

### Corrigido
- Bug ao inserir URLs com caminho (ex: `uol.com.br/games`) ou com `https://`, que antes quebrava o ping/traceroute.
- Agora o script extrai corretamente apenas o domínio para os testes.

## v0.2

### Alterado
- Correção da detecção de CPU:
  - Agora funciona em sistemas em português e inglês.
  - Exibe "Não foi possível detectar" caso o comando falhe.
- Ping e Traceroute mais confiáveis:
  - Entrada do usuário agora remove automaticamente `http://` ou `https://`.
  - Evita erro de "nome desconhecido" ao digitar URLs.
- Verificação de dependências:
  - Se o comando `traceroute` não estiver instalado, o script avisa e sugere o comando para instalar.
  - Reduz erros durante a execução.
- Pequenas melhorias visuais e de estabilidade do menu interativo.

## v0.1

### Adicionado
- Teste de conectividade (ping IPv4/IPv6).
- Traceroute.
- Informações do sistema (CPU, RAM, disco).
- Informações de rede (IP, gateway, DNS).

