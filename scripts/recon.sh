#!/usr/bin/env bash
# recon.sh — Reconhecimento do alvo no laboratório (rede host-only)
# Uso: ./recon.sh <IP_DO_ALVO>
# Exemplo: ./recon.sh 192.168.56.102
#
# AVISO: executar SOMENTE contra VMs do seu próprio laboratório isolado.

set -euo pipefail

ALVO="${1:?Informe o IP do alvo. Ex.: ./recon.sh 192.168.56.102}"
SAIDA="recon_${ALVO//./_}"

echo "[*] Varredura rápida de portas em ${ALVO}..."
nmap -Pn -sV -p 21,139,445,80 "${ALVO}" -oN "${SAIDA}_servicos.txt"

echo "[*] Enumeração SMB (usuários/compartilhamentos)..."
nmap -Pn -p 139,445 --script smb-enum-users,smb-enum-shares,smb-os-discovery \
  "${ALVO}" -oN "${SAIDA}_smb.txt"

echo "[*] Concluído. Resultados salvos em ${SAIDA}_*.txt"
