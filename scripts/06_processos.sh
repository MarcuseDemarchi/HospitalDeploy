#!/bin/bash
# =============================================================
# Script: 06_processos.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Gerenciamento de processos do sistema do Hospital DC.
#            Permite listar, buscar e encerrar processos.
# Uso:
#   ./06_processos.sh listar
#   ./06_processos.sh buscar apache
#   ./06_processos.sh matar 1234
# =============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/processos_$(date '+%Y-%m-%d').log"

mkdir -p "$LOG_DIR"

# -------------------------------------------------------------
# Função: registrar_log
# -------------------------------------------------------------
registrar_log() {
    local MENSAGEM="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MENSAGEM" >> "$LOG_FILE"
}

# -------------------------------------------------------------
# Função: listar_processos
# Lista todos os processos ativos no sistema
# -------------------------------------------------------------
listar_processos() {
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║    HOSPITAL DC - PROCESSOS ATIVOS         ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "[INFO] Listando processos ativos..."
    echo "-------------------------------------------"
    ps aux --sort=-%cpu | head -20
    echo "-------------------------------------------"
    registrar_log "Listagem de processos executada."
}

# -------------------------------------------------------------
# Função: buscar_processo
# Busca processo por nome
# -------------------------------------------------------------
buscar_processo() {
    local NOME_PROCESSO="$1"

    if [ -z "$NOME_PROCESSO" ]; then
        echo "[ERRO] Informe o nome do processo para buscar."
        echo "Uso: ./06_processos.sh buscar <nome>"
        exit 1
    fi

    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║    HOSPITAL DC - BUSCA DE PROCESSO        ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "[INFO] Buscando processo: $NOME_PROCESSO"
    echo "-------------------------------------------"
    RESULTADO=$(ps aux | grep -i "$NOME_PROCESSO" | grep -v grep)

    if [ -z "$RESULTADO" ]; then
        echo "[AVISO] Nenhum processo encontrado com o nome: $NOME_PROCESSO"
        registrar_log "[AVISO] Processo não encontrado: $NOME_PROCESSO"
    else
        echo "$RESULTADO"
        registrar_log "[OK] Busca por '$NOME_PROCESSO' realizada."
    fi
    echo "-------------------------------------------"
}

# -------------------------------------------------------------
# Função: matar_processo
# Encerra processo por PID informado
# -------------------------------------------------------------
matar_processo() {
    local PID="$1"

    # Validação: PID deve ser informado
    if [ -z "$PID" ]; then
        echo ""
        echo "[SEGURANÇA] Operação bloqueada!"
        echo "[ERRO] Nenhum PID informado. Informe o PID do processo a encerrar."
        echo "Uso: ./06_processos.sh matar <PID>"
        echo ""
        registrar_log "[SEGURANÇA] Tentativa de matar processo sem PID bloqueada."
        exit 1
    fi

    # Validação: PID deve ser numérico
    if ! [[ "$PID" =~ ^[0-9]+$ ]]; then
        echo "[ERRO] PID inválido: '$PID'. O PID deve ser um número inteiro."
        registrar_log "[ERRO] PID inválido informado: $PID"
        exit 1
    fi

    # Verifica se o processo existe
    if ! kill -0 "$PID" 2>/dev/null; then
        echo "[AVISO] Processo com PID $PID não encontrado ou já encerrado."
        registrar_log "[AVISO] Processo PID $PID não encontrado."
        exit 1
    fi

    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║    HOSPITAL DC - ENCERRAR PROCESSO        ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "[AVISO] Encerrando processo PID: $PID"

    kill "$PID" 2>/dev/null

    if [ $? -eq 0 ]; then
        registrar_log "[OK] Processo PID $PID encerrado."
        echo "[OK] Processo $PID encerrado com sucesso."
    else
        registrar_log "[ERRO] Falha ao encerrar PID $PID."
        echo "[ERRO] Não foi possível encerrar o processo $PID."
        exit 1
    fi
}

# -------------------------------------------------------------
# Função: exibir_ajuda
# -------------------------------------------------------------
exibir_ajuda() {
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║    HOSPITAL DC - GERENCIADOR DE PROCESSOS ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "Uso: ./06_processos.sh [ação] [parâmetro]"
    echo ""
    echo "  listar              - Lista todos os processos ativos"
    echo "  buscar <nome>       - Busca processo pelo nome"
    echo "  matar <PID>         - Encerra processo pelo PID"
    echo ""
    echo "Exemplos:"
    echo "  ./06_processos.sh listar"
    echo "  ./06_processos.sh buscar apache2"
    echo "  ./06_processos.sh matar 1234"
    echo ""
}

# -------------------------------------------------------------
# Execução principal - baseada em parâmetro
# -------------------------------------------------------------
ACAO="$1"
PARAMETRO="$2"

case "$ACAO" in
    listar)
        listar_processos
        ;;
    buscar)
        buscar_processo "$PARAMETRO"
        ;;
    matar)
        matar_processo "$PARAMETRO"
        ;;
    *)
        exibir_ajuda
        ;;
esac
