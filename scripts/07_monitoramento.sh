#!/bin/bash
# =============================================================
# Script: 07_monitoramento.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Monitora recursos do sistema (CPU, RAM, disco)
#            e status do Apache. Emite alertas quando necessário.
# =============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/monitoramento_$(date '+%Y-%m-%d').log"

# Limites de alerta (%)
LIMITE_CPU=80
LIMITE_MEM=80
LIMITE_DISCO=90

mkdir -p "$LOG_DIR"

# -------------------------------------------------------------
# Função: registrar_log
# -------------------------------------------------------------
registrar_log() {
    local MENSAGEM="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MENSAGEM" | tee -a "$LOG_FILE"
}

# -------------------------------------------------------------
# Função: monitorar_cpu
# Exibe e avalia uso de CPU
# -------------------------------------------------------------
monitorar_cpu() {
    # Captura uso de CPU (idle = inativo, subtrai de 100)
    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | tr -d '%,')
    CPU_USO=$(echo "100 - ${CPU_IDLE:-0}" | bc 2>/dev/null || echo "N/A")

    echo ""
    echo "📊 CPU:"
    echo "   Uso atual: ${CPU_USO}%"

    if [ "$CPU_USO" != "N/A" ] && [ "$(echo "$CPU_USO >= $LIMITE_CPU" | bc 2>/dev/null)" = "1" ]; then
        registrar_log "[ALERTA] Uso de CPU acima de $LIMITE_CPU%: ${CPU_USO}%"
        echo "   [ALERTA] Uso de CPU acima de $LIMITE_CPU%!"
    else
        registrar_log "[OK] CPU em nível normal: ${CPU_USO}%"
        echo "   [OK] CPU em nível normal."
    fi
}

# -------------------------------------------------------------
# Função: monitorar_memoria
# Exibe e avalia uso de memória RAM
# -------------------------------------------------------------
monitorar_memoria() {
    MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
    MEM_USADA=$(free -m | awk '/^Mem:/{print $3}')

    if [ -n "$MEM_TOTAL" ] && [ "$MEM_TOTAL" -gt 0 ]; then
        MEM_PORCENTO=$(( MEM_USADA * 100 / MEM_TOTAL ))
    else
        MEM_PORCENTO=0
    fi

    echo ""
    echo "🧠 MEMÓRIA RAM:"
    echo "   Total: ${MEM_TOTAL} MB"
    echo "   Usada: ${MEM_USADA} MB (${MEM_PORCENTO}%)"

    if [ "$MEM_PORCENTO" -ge "$LIMITE_MEM" ]; then
        registrar_log "[ALERTA] Uso de memória acima de $LIMITE_MEM%: ${MEM_PORCENTO}%"
        echo "   [ALERTA] Uso de memória acima de $LIMITE_MEM%!"
    else
        registrar_log "[OK] Memória em nível normal: ${MEM_PORCENTO}%"
        echo "   [OK] Memória em nível normal."
    fi
}

# -------------------------------------------------------------
# Função: monitorar_disco
# Exibe e avalia uso de disco
# -------------------------------------------------------------
monitorar_disco() {
    DISCO_USO=$(df / | awk 'NR==2{print $5}' | tr -d '%')
    DISCO_INFO=$(df -h / | awk 'NR==2{print "Total: "$2" | Usado: "$3" | Disponível: "$4}')

    echo ""
    echo "💾 DISCO:"
    echo "   $DISCO_INFO"
    echo "   Uso: ${DISCO_USO}%"

    if [ "$DISCO_USO" -ge "$LIMITE_DISCO" ]; then
        registrar_log "[ALERTA] Uso de disco acima de $LIMITE_DISCO%: ${DISCO_USO}%"
        echo "   [ALERTA] Uso de disco acima de $LIMITE_DISCO%!"
    else
        registrar_log "[OK] Disco em nível normal: ${DISCO_USO}%"
        echo "   [OK] Disco em nível normal."
    fi
}

# -------------------------------------------------------------
# Função: monitorar_apache
# Verifica se o Apache está em execução
# -------------------------------------------------------------
monitorar_apache() {
    echo ""
    echo "🌐 APACHE (Portal Hospital DC):"

    if pgrep -x "apache2" > /dev/null 2>&1; then
        registrar_log "[OK] Apache em execução."
        echo "   [OK] Apache em execução."
        echo "   Portal disponível em: http://localhost:8080"
    else
        registrar_log "[ALERTA] Apache não está em execução!"
        echo "   [ALERTA] Apache NÃO está em execução!"
        echo "   Execute: service apache2 start"
    fi
}

# -------------------------------------------------------------
# Execução principal
# -------------------------------------------------------------
registrar_log "=========================================="
registrar_log "MONITORAMENTO DO SISTEMA - Hospital DC"
registrar_log "Data/Hora da coleta: $(date '+%Y-%m-%d %H:%M:%S')"
registrar_log "=========================================="

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║    HOSPITAL DC - MONITORAMENTO DO SISTEMA  ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Data/Hora: $(date '+%Y-%m-%d %H:%M:%S')"

monitorar_cpu
monitorar_memoria
monitorar_disco
monitorar_apache

echo ""
echo "-------------------------------------------"
echo "[LOG] Registro salvo em: $LOG_FILE"
echo "-------------------------------------------"
