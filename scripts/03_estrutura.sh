#!/bin/bash
# =============================================================
# Script: 03_estrutura.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Cria a estrutura de diretórios temática do
#            Hospital DC, simulando organização de um
#            sistema hospitalar em ambiente cloud.
# =============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/estrutura_$(date '+%Y-%m-%d').log"

mkdir -p "$LOG_DIR"

# -------------------------------------------------------------
# Função: registrar_log
# -------------------------------------------------------------
registrar_log() {
    local MENSAGEM="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MENSAGEM" | tee -a "$LOG_FILE"
}

# -------------------------------------------------------------
# Função: remover_estrutura_antiga
# Remove estrutura anterior com segurança
# -------------------------------------------------------------
remover_estrutura_antiga() {
    echo "[INFO] Verificando estrutura antiga..."
    if [ -d "/app/hospital" ]; then
        registrar_log "Estrutura antiga encontrada. Removendo..."
        rm -rf /app/hospital
        registrar_log "[OK] Estrutura antiga removida."
        echo "[OK] Estrutura antiga removida."
    else
        echo "[INFO] Nenhuma estrutura antiga encontrada."
    fi
}

# -------------------------------------------------------------
# Função: criar_estrutura_hospital
# Cria os diretórios temáticos do Hospital DC
# -------------------------------------------------------------
criar_estrutura_hospital() {
    registrar_log "=========================================="
    registrar_log "CRIANDO ESTRUTURA DE DIRETÓRIOS - Hospital DC"
    registrar_log "=========================================="

    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║   HOSPITAL DC - ESTRUTURA DE DIRETÓRIOS   ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""

    # Array de diretórios do Hospital DC
    DIRETORIOS=(
        "/app/hospital/pacientes"
        "/app/hospital/consultas"
        "/app/hospital/prontuarios"
        "/app/hospital/exames"
        "/app/hospital/internacoes"
        "/app/hospital/cirurgias"
        "/app/hospital/medicamentos"
        "/app/hospital/funcionarios"
        "/app/hospital/financeiro"
        "/app/hospital/logs"
        "/app/hospital/backups"
        "/app/hospital/relatorios"
        "/app/hospital/emergencia"
    )

    for DIR in "${DIRETORIOS[@]}"; do
        mkdir -p "$DIR"
        if [ $? -eq 0 ]; then
            registrar_log "[OK] Diretório criado: $DIR"
            echo "[OK] Criado: $DIR"
        else
            registrar_log "[ERRO] Falha ao criar: $DIR"
            echo "[ERRO] Falha ao criar: $DIR"
        fi
    done
}

# -------------------------------------------------------------
# Função: criar_arquivos_iniciais
# Cria arquivos de inicialização em cada setor
# -------------------------------------------------------------
criar_arquivos_iniciais() {
    echo ""
    echo "[INFO] Criando arquivos iniciais nos setores..."

    # Arquivo de controle de pacientes
    cat > /app/hospital/pacientes/README.txt <<EOF
SETOR: PACIENTES - Hospital DC
Data de criação: $(date '+%Y-%m-%d %H:%M:%S')
Responsável: Administração de TI
Descrição: Diretório para armazenamento de dados de pacientes cadastrados.
EOF

    # Arquivo de controle de consultas
    cat > /app/hospital/consultas/README.txt <<EOF
SETOR: CONSULTAS - Hospital DC
Data de criação: $(date '+%Y-%m-%d %H:%M:%S')
Responsável: Administração de TI
Descrição: Diretório para agendamentos e registros de consultas.
EOF

    # Arquivo de prontuários
    cat > /app/hospital/prontuarios/README.txt <<EOF
SETOR: PRONTUÁRIOS - Hospital DC
Data de criação: $(date '+%Y-%m-%d %H:%M:%S')
Responsável: Administração de TI
Descrição: Diretório para prontuários eletrônicos dos pacientes.
ACESSO RESTRITO - Somente médicos autorizados.
EOF

    # Arquivo de exames
    cat > /app/hospital/exames/README.txt <<EOF
SETOR: EXAMES - Hospital DC
Data de criação: $(date '+%Y-%m-%d %H:%M:%S')
Responsável: Administração de TI
Descrição: Resultados de exames laboratoriais e de imagem.
EOF

    registrar_log "[OK] Arquivos iniciais criados nos setores."
    echo "[OK] Arquivos iniciais criados."
}

# -------------------------------------------------------------
# Função: exibir_estrutura
# Lista a estrutura criada
# -------------------------------------------------------------
exibir_estrutura() {
    echo ""
    echo "[INFO] Estrutura de diretórios do Hospital DC:"
    echo "-------------------------------------------"
    find /app/hospital -type d | sort
    echo "-------------------------------------------"
    registrar_log "Estrutura de diretórios exibida com sucesso."
}

# -------------------------------------------------------------
# Execução principal
# -------------------------------------------------------------
remover_estrutura_antiga
criar_estrutura_hospital
criar_arquivos_iniciais
exibir_estrutura

echo ""
echo "[SUCESSO] Estrutura do Hospital DC criada com sucesso!"
echo "[LOG] Registro salvo em: $LOG_FILE"
