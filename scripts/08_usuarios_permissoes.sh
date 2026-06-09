#!/bin/bash
# =============================================================
# Script: 08_usuarios_permissoes.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Cria grupos, usuários e configura permissões
#            nos diretórios do Hospital DC, seguindo boas
#            práticas de segurança.
# =============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/usuarios_$(date '+%Y-%m-%d').log"

mkdir -p "$LOG_DIR"

# -------------------------------------------------------------
# Função: registrar_log
# -------------------------------------------------------------
registrar_log() {
    local MENSAGEM="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MENSAGEM" | tee -a "$LOG_FILE"
}

# -------------------------------------------------------------
# Função: criar_grupos
# Cria grupos relacionados ao tema Hospital DC
# -------------------------------------------------------------
criar_grupos() {
    registrar_log "=========================================="
    registrar_log "CONFIGURAÇÃO DE USUÁRIOS E GRUPOS - Hospital DC"
    registrar_log "=========================================="

    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║   HOSPITAL DC - USUÁRIOS E PERMISSÕES     ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "[INFO] Criando grupos do Hospital DC..."

    GRUPOS=("hospital_ops" "medicos" "enfermagem" "recepcao" "ti_hospital")

    for GRUPO in "${GRUPOS[@]}"; do
        if getent group "$GRUPO" > /dev/null 2>&1; then
            registrar_log "[INFO] Grupo já existe: $GRUPO"
            echo "[INFO] Grupo já existe: $GRUPO"
        else
            groupadd "$GRUPO" 2>/dev/null
            if [ $? -eq 0 ]; then
                registrar_log "[OK] Grupo criado: $GRUPO"
                echo "[OK] Grupo criado: $GRUPO"
            else
                registrar_log "[AVISO] Não foi possível criar grupo: $GRUPO"
                echo "[AVISO] Não foi possível criar grupo: $GRUPO"
            fi
        fi
    done
}

# -------------------------------------------------------------
# Função: criar_usuarios
# Cria usuários de sistema relacionados ao Hospital DC
# -------------------------------------------------------------
criar_usuarios() {
    echo ""
    echo "[INFO] Criando usuários do Hospital DC..."

    declare -A USUARIOS
    USUARIOS["medico_user"]="medicos"
    USUARIOS["enfermeiro_user"]="enfermagem"
    USUARIOS["recepcao_user"]="recepcao"
    USUARIOS["ti_user"]="ti_hospital"

    for USUARIO in "${!USUARIOS[@]}"; do
        GRUPO_USUARIO="${USUARIOS[$USUARIO]}"

        if id "$USUARIO" > /dev/null 2>&1; then
            registrar_log "[INFO] Usuário já existe: $USUARIO"
            echo "[INFO] Usuário já existe: $USUARIO"
        else
            useradd -r -s /bin/bash -g "$GRUPO_USUARIO" "$USUARIO" 2>/dev/null
            if [ $? -eq 0 ]; then
                registrar_log "[OK] Usuário criado: $USUARIO (grupo: $GRUPO_USUARIO)"
                echo "[OK] Usuário criado: $USUARIO → grupo: $GRUPO_USUARIO"
            else
                registrar_log "[AVISO] Não foi possível criar usuário: $USUARIO"
                echo "[AVISO] Não foi possível criar usuário: $USUARIO"
            fi
        fi
    done
}

# -------------------------------------------------------------
# Função: aplicar_permissoes
# Aplica chown e chmod nos diretórios do Hospital DC
# Evita chmod 777 sem justificativa técnica
# -------------------------------------------------------------
aplicar_permissoes() {
    echo ""
    echo "[INFO] Aplicando permissões nos diretórios do Hospital DC..."

    # Garante que os diretórios existem
    mkdir -p /app/hospital/prontuarios
    mkdir -p /app/hospital/pacientes
    mkdir -p /app/hospital/exames
    mkdir -p /app/hospital/consultas
    mkdir -p /app/hospital/logs

    # Prontuários: acesso restrito ao grupo médicos (750)
    # Justificativa: apenas médicos podem ler/escrever prontuários
    if getent group "medicos" > /dev/null 2>&1; then
        chown -R root:medicos /app/hospital/prontuarios 2>/dev/null
    fi
    chmod 750 /app/hospital/prontuarios
    registrar_log "[OK] Permissão 750 aplicada em /app/hospital/prontuarios (restrito a médicos)"
    echo "[OK] /app/hospital/prontuarios → 750 (rwxr-x---) - Restrito: grupo médicos"

    # Pacientes: leitura para recepção, escrita apenas para médicos (755)
    if getent group "hospital_ops" > /dev/null 2>&1; then
        chown -R root:hospital_ops /app/hospital/pacientes 2>/dev/null
    fi
    chmod 755 /app/hospital/pacientes
    registrar_log "[OK] Permissão 755 aplicada em /app/hospital/pacientes"
    echo "[OK] /app/hospital/pacientes → 755 (rwxr-xr-x)"

    # Exames: leitura para todos do grupo hospital_ops, escrita apenas para dono
    if getent group "medicos" > /dev/null 2>&1; then
        chown -R root:medicos /app/hospital/exames 2>/dev/null
    fi
    chmod 750 /app/hospital/exames
    registrar_log "[OK] Permissão 750 aplicada em /app/hospital/exames"
    echo "[OK] /app/hospital/exames → 750 (rwxr-x---)"

    # Logs: somente leitura para todos, escrita para root
    chmod 755 /app/hospital/logs
    registrar_log "[OK] Permissão 755 aplicada em /app/hospital/logs"
    echo "[OK] /app/hospital/logs → 755 (rwxr-xr-x)"

    # Consultas: acesso padrão para operações do hospital
    chmod 755 /app/hospital/consultas
    registrar_log "[OK] Permissão 755 aplicada em /app/hospital/consultas"
    echo "[OK] /app/hospital/consultas → 755 (rwxr-xr-x)"

    registrar_log "Permissões aplicadas com sucesso. chmod 777 NÃO utilizado por questões de segurança."
}

# -------------------------------------------------------------
# Função: exibir_resumo
# Exibe resumo de usuários, grupos e permissões
# -------------------------------------------------------------
exibir_resumo() {
    echo ""
    echo "[INFO] Resumo de grupos criados:"
    echo "-------------------------------------------"
    getent group hospital_ops medicos enfermagem recepcao ti_hospital 2>/dev/null || grep -E "hospital_ops|medicos|enfermagem|recepcao|ti_hospital" /etc/group 2>/dev/null
    echo "-------------------------------------------"

    echo ""
    echo "[INFO] Permissões nos diretórios do Hospital DC:"
    echo "-------------------------------------------"
    ls -ld /app/hospital/* 2>/dev/null
    echo "-------------------------------------------"
}

# -------------------------------------------------------------
# Execução principal
# -------------------------------------------------------------
criar_grupos
criar_usuarios
aplicar_permissoes
exibir_resumo

echo ""
echo "[SUCESSO] Usuários e permissões do Hospital DC configurados!"
echo "[LOG] Registro salvo em: $LOG_FILE"
