#!/bin/bash
# =============================================================
# Script: 02_apache.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Instalação, inicialização e validação do servidor
#            Apache para o portal do Hospital DC.
# =============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/apache_$(date '+%Y-%m-%d').log"

mkdir -p "$LOG_DIR"

# -------------------------------------------------------------
# Função: registrar_log
# -------------------------------------------------------------
registrar_log() {
    local MENSAGEM="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MENSAGEM" | tee -a "$LOG_FILE"
}

# -------------------------------------------------------------
# Função: instalar_apache
# Instala o Apache2 via apt-get
# -------------------------------------------------------------
instalar_apache() {
    registrar_log "=========================================="
    registrar_log "INSTALAÇÃO DO APACHE - Hospital DC"
    registrar_log "=========================================="

    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║     HOSPITAL DC - INSTALAÇÃO DO APACHE    ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""

    echo "[INFO] Instalando Apache2..."
    apt-get install -y apache2 >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        registrar_log "[OK] Apache2 instalado com sucesso."
        echo "[OK] Apache2 instalado."
    else
        registrar_log "[ERRO] Falha na instalação do Apache2."
        echo "[ERRO] Falha na instalação do Apache2."
        exit 1
    fi

    # Inicia o serviço Apache (onde aplicável)
    echo "[INFO] Iniciando serviço Apache2..."
    service apache2 start >> "$LOG_FILE" 2>&1
    registrar_log "Tentativa de inicialização do Apache registrada."
}

# -------------------------------------------------------------
# Função: verificar_apache
# Valida se o Apache está instalado e em execução
# -------------------------------------------------------------
verificar_apache() {
    echo ""
    echo "[INFO] Verificando status do Apache2..."

    if command -v apache2 &> /dev/null; then
        registrar_log "[OK] Apache2 está instalado no sistema."
        echo "[OK] Apache2 encontrado no sistema."
    else
        registrar_log "[ERRO] Apache2 não encontrado no sistema."
        echo "[ERRO] Apache2 não está instalado."
        return 1
    fi

    # Verifica se o processo está rodando
    if pgrep -x "apache2" > /dev/null 2>&1; then
        registrar_log "[OK] Processo Apache2 em execução."
        echo "[OK] Apache2 está em execução."
    else
        registrar_log "[AVISO] Apache2 não está em execução. Tentando iniciar..."
        echo "[AVISO] Apache2 parado. Iniciando..."
        service apache2 start >> "$LOG_FILE" 2>&1
    fi
}

# -------------------------------------------------------------
# Função: versao_apache
# Exibe a versão do Apache instalado
# -------------------------------------------------------------
versao_apache() {
    echo ""
    echo "[INFO] Versão do Apache instalado:"
    apache2 -v 2>&1 | tee -a "$LOG_FILE"
    registrar_log "Consulta de versão do Apache realizada."
}

# -------------------------------------------------------------
# Execução principal
# -------------------------------------------------------------
instalar_apache
verificar_apache
versao_apache

echo ""
echo "[SUCESSO] Apache do Hospital DC configurado com sucesso!"
echo "[LOG] Registro salvo em: $LOG_FILE"
