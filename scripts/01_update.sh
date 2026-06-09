#!/bin/bash
# =============================================================
# Script: 01_update.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Atualização do sistema operacional Ubuntu do
#            container, com registro de log detalhado.
# =============================================================

# Diretório de logs do projeto
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/update_$(date '+%Y-%m-%d').log"

# Garante que o diretório de logs existe
mkdir -p "$LOG_DIR"

# -------------------------------------------------------------
# Função: registrar_log
# Registra uma mensagem com data/hora no arquivo de log
# -------------------------------------------------------------
registrar_log() {
    local MENSAGEM="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MENSAGEM" | tee -a "$LOG_FILE"
}

# -------------------------------------------------------------
# Função: atualizar_sistema
# Executa apt update e apt upgrade no sistema
# -------------------------------------------------------------
atualizar_sistema() {
    registrar_log "=========================================="
    registrar_log "INICIANDO ATUALIZAÇÃO DO SISTEMA - Hospital DC"
    registrar_log "=========================================="

    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║     HOSPITAL DC - ATUALIZAÇÃO DO SISTEMA  ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""

    # Atualiza a lista de pacotes
    registrar_log "Executando: apt update..."
    echo "[INFO] Atualizando lista de pacotes..."
    apt update -y >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        registrar_log "[OK] apt update concluído com sucesso."
        echo "[OK] Lista de pacotes atualizada."
    else
        registrar_log "[ERRO] Falha ao executar apt update."
        echo "[ERRO] Falha ao atualizar lista de pacotes."
        exit 1
    fi

    # Atualiza os pacotes instalados
    registrar_log "Executando: apt upgrade..."
    echo "[INFO] Atualizando pacotes instalados..."
    apt upgrade -y >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        registrar_log "[OK] apt upgrade concluído com sucesso."
        echo "[OK] Pacotes atualizados com sucesso."
    else
        registrar_log "[ERRO] Falha ao executar apt upgrade."
        echo "[ERRO] Falha ao atualizar pacotes."
        exit 1
    fi

    registrar_log "Atualização do sistema finalizada com sucesso."
    echo ""
    echo "[SUCESSO] Sistema do Hospital DC atualizado com sucesso!"
    echo "[LOG] Registro salvo em: $LOG_FILE"
}

# -------------------------------------------------------------
# Execução principal
# -------------------------------------------------------------
atualizar_sistema
