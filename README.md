# Suporte Linux

Ferramenta simples em Bash para auxiliar técnicos de suporte em sistemas Debian/Ubuntu.

- Versão atual: `v0.2.5`

## Funcionalidades (v0.2)
- Teste de conectividade (ping IPv4/IPv6, host customizado)
- Traceroute até um host
- Informações de hardware (CPU, RAM, Disco)
- Informações de rede (IP, Gateway, DNS)

## Requisitos
- Bash 4+
- Pacotes: `iproute2` (ip), `iputils-ping` (ping), `procps` (free), `coreutils`/`util-linux` (df), `traceroute` (opcional; com fallback para `tracepath` quando disponível)

## Instalação
Clone o repositório e torne o script executável:
```bash
git clone https://github.com/PauloNRocha/linux-suporte.git
cd linux-suporte
chmod +x suporte.sh
```

## Uso
Execute o script:
```bash
./suporte.sh
```

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
