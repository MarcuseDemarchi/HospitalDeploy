#!/bin/bash
# =============================================================
# Script: 04_backup.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Realiza backup automatizado dos dados do Hospital DC,
#            gerando arquivo .tar.gz com data/hora no nome.
# =============================================================

# Variáveis de diretório
ORIGEM="/app/hospital"
DESTINO="/app/backups"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/backup_$(date '+%Y-%m-%d').log"
DATA_HORA=$(date '+%Y-%m-%d_%H-%M')
NOME_BACKUP="backup_hospital_$DATA_HORA.tar.gz"

mkdir -p "$DESTINO" "$LOG_DIR"

# -------------------------------------------------------------
# Função: registrar_log
# -------------------------------------------------------------
registrar_log() {
    local MENSAGEM="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MENSAGEM" | tee -a "$LOG_FILE"
}

# -------------------------------------------------------------
# Função: verificar_origem
# Verifica se o diretório de origem existe
# -------------------------------------------------------------
verificar_origem() {
    if [ ! -d "$ORIGEM" ]; then
        registrar_log "[AVISO] Diretório de origem não encontrado: $ORIGEM"
        echo "[AVISO] Criando estrutura base para backup..."
        mkdir -p "$ORIGEM"
        echo "arquivo_teste_backup.txt criado em: $(date)" > "$ORIGEM/teste.txt"
    fi
}

# -------------------------------------------------------------
# Função: realizar_backup
# Cria o arquivo .tar.gz com data/hora no nome
# -------------------------------------------------------------
realizar_backup() {
    registrar_log "=========================================="
    registrar_log "INICIANDO BACKUP - Hospital DC"
    registrar_log "=========================================="
    registrar_log "Origem: $ORIGEM"
    registrar_log "Destino: $DESTINO/$NOME_BACKUP"

    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║      HOSPITAL DC - BACKUP AUTOMATIZADO    ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "[INFO] Iniciando backup..."
    echo "[INFO] Arquivo de destino: $NOME_BACKUP"

    tar -czf "$DESTINO/$NOME_BACKUP" "$ORIGEM" 2>> "$LOG_FILE"

    if [ $? -eq 0 ]; then
        registrar_log "[OK] Backup criado: $NOME_BACKUP"
        echo "[OK] Backup criado com sucesso: $NOME_BACKUP"
    else
        registrar_log "[ERRO] Falha ao criar backup."
        echo "[ERRO] Falha ao criar o backup."
        exit 1
    fi
}

# -------------------------------------------------------------
# Função: validar_backup
# Verifica se o arquivo de backup foi criado corretamente
# -------------------------------------------------------------
validar_backup() {
    echo ""
    echo "[INFO] Validando backup..."

    if [ -f "$DESTINO/$NOME_BACKUP" ]; then
        TAMANHO=$(du -sh "$DESTINO/$NOME_BACKUP" | cut -f1)
        registrar_log "[OK] Backup validado. Arquivo: $NOME_BACKUP | Tamanho: $TAMANHO"
        echo "[OK] Backup validado com sucesso!"
        echo "[INFO] Arquivo: $DESTINO/$NOME_BACKUP"
        echo "[INFO] Tamanho: $TAMANHO"
    else
        registrar_log "[ERRO] Arquivo de backup não encontrado após criação."
        echo "[ERRO] Backup não encontrado. Verifique os logs."
        exit 1
    fi
}

# -------------------------------------------------------------
# Função: listar_backups
# Lista todos os backups existentes
# -------------------------------------------------------------
listar_backups() {
    echo ""
    echo "[INFO] Backups disponíveis em $DESTINO:"
    echo "-------------------------------------------"
    ls -lh "$DESTINO"/*.tar.gz 2>/dev/null || echo "Nenhum backup anterior encontrado."
    echo "-------------------------------------------"
}

# -------------------------------------------------------------
# Execução principal
# -------------------------------------------------------------
verificar_origem
realizar_backup
validar_backup
listar_backups

echo ""
echo "[SUCESSO] Processo de backup do Hospital DC concluído!"
echo "[LOG] Registro salvo em: $LOG_FILE"
