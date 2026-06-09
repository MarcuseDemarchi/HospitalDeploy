#!/bin/bash
# =============================================================
# Script: 05_deploy.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Realiza o deploy do site estático do Hospital DC
#            para o diretório do Apache /var/www/html.
# =============================================================

ORIGEM="/app/source"
DESTINO="/var/www/html"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/deploy_$(date '+%Y-%m-%d').log"

mkdir -p "$LOG_DIR"

# -------------------------------------------------------------
# Função: registrar_log
# -------------------------------------------------------------
registrar_log() {
    local MENSAGEM="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MENSAGEM" | tee -a "$LOG_FILE"
}

# -------------------------------------------------------------
# Função: limpar_destino
# Remove arquivos antigos do diretório do Apache
# -------------------------------------------------------------
limpar_destino() {
    echo ""
    echo "[INFO] Limpando diretório de destino: $DESTINO"
    rm -rf "$DESTINO"/*
    if [ $? -eq 0 ]; then
        registrar_log "[OK] Diretório $DESTINO limpo."
        echo "[OK] Diretório limpo."
    else
        registrar_log "[ERRO] Falha ao limpar $DESTINO."
        echo "[ERRO] Não foi possível limpar o diretório."
        exit 1
    fi
}

# -------------------------------------------------------------
# Função: copiar_arquivos
# Copia o site da pasta source para o Apache
# -------------------------------------------------------------
copiar_arquivos() {
    registrar_log "=========================================="
    registrar_log "INICIANDO DEPLOY - Hospital DC"
    registrar_log "=========================================="

    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║       HOSPITAL DC - DEPLOY DO PORTAL      ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""

    # Verifica se a pasta source existe
    if [ ! -d "$ORIGEM" ]; then
        registrar_log "[AVISO] Pasta source não encontrada em $ORIGEM. Usando /var/www/html da imagem."
        echo "[AVISO] Pasta source não encontrada. Arquivos da imagem Docker já estão no destino."
        return 0
    fi

    echo "[INFO] Copiando arquivos de $ORIGEM para $DESTINO..."
    cp -r "$ORIGEM"/. "$DESTINO/"

    if [ $? -eq 0 ]; then
        registrar_log "[OK] Arquivos copiados para $DESTINO."
        echo "[OK] Arquivos copiados com sucesso."
    else
        registrar_log "[ERRO] Falha ao copiar arquivos."
        echo "[ERRO] Falha no processo de cópia."
        exit 1
    fi
}

# -------------------------------------------------------------
# Função: validar_deploy
# Verifica se o index.html existe no destino
# -------------------------------------------------------------
validar_deploy() {
    echo ""
    echo "[INFO] Validando deploy..."

    if [ -f "$DESTINO/index.html" ]; then
        registrar_log "[OK] index.html encontrado em $DESTINO."
        echo "[OK] Deploy validado! index.html presente."
    else
        registrar_log "[ERRO] index.html não encontrado em $DESTINO."
        echo "[ERRO] index.html ausente. Deploy pode ter falhado."
        exit 1
    fi
}

# -------------------------------------------------------------
# Função: listar_publicados
# Lista os arquivos publicados no Apache
# -------------------------------------------------------------
listar_publicados() {
    echo ""
    echo "[INFO] Arquivos publicados no Portal do Hospital DC:"
    echo "-------------------------------------------"
    ls -lh "$DESTINO"
    echo "-------------------------------------------"
    registrar_log "Listagem de arquivos publicados realizada."
}

# -------------------------------------------------------------
# Função: reiniciar_apache
# Reinicia o Apache para garantir que as mudanças foram aplicadas
# -------------------------------------------------------------
reiniciar_apache() {
    echo ""
    echo "[INFO] Reiniciando Apache..."
    service apache2 restart >> "$LOG_FILE" 2>&1
    registrar_log "Apache reiniciado após deploy."
    echo "[OK] Apache reiniciado."
}

# -------------------------------------------------------------
# Execução principal
# -------------------------------------------------------------
limpar_destino
copiar_arquivos
validar_deploy
listar_publicados
reiniciar_apache

echo ""
echo "[SUCESSO] Deploy do Portal do Hospital DC concluído!"
echo "[INFO] Acesse: http://localhost:8080"
echo "[LOG] Registro salvo em: $LOG_FILE"
