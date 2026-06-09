#!/bin/bash
# =============================================================
# Script: menu.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Tema: Gerenciamento Hospitalar em Cloud Computing
# Descrição: Menu principal interativo para execução de todas
#            as rotinas operacionais do Hospital DC.
# =============================================================

SCRIPTS_DIR="/app/scripts"

# -------------------------------------------------------------
# Função: exibir_cabecalho
# -------------------------------------------------------------
exibir_cabecalho() {
    clear
    echo ""
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║                                                      ║"
    echo "║           🏥  HOSPITAL DC - DEVOPS CLOUD  🏥         ║"
    echo "║                                                      ║"
    echo "║  Criado por: Marcuse Demarchi                        ║"
    echo "║  Instituição: Unidavi                                ║"
    echo "║  Tema: Gerenciamento Hospitalar em Cloud Computing   ║"
    echo "║                                                      ║"
    echo "╠══════════════════════════════════════════════════════╣"
    echo "║                 MENU DEVOPS CLOUD                    ║"
    echo "╠══════════════════════════════════════════════════════╣"
    echo "║                                                      ║"
    echo "║  1  -  Atualizar sistema                             ║"
    echo "║  2  -  Instalar e validar Apache                     ║"
    echo "║  3  -  Criar estrutura de diretórios                 ║"
    echo "║  4  -  Realizar backup                               ║"
    echo "║  5  -  Fazer deploy do portal                        ║"
    echo "║  6  -  Gerenciar processos                           ║"
    echo "║  7  -  Monitorar sistema                             ║"
    echo "║  8  -  Configurar usuários e permissões              ║"
    echo "║  9  -  Gerar relatório operacional                   ║"
    echo "║                                                      ║"
    echo "║  0  -  Sair                                          ║"
    echo "║                                                      ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo ""
}

# -------------------------------------------------------------
# Função: executar_script
# Executa um script e aguarda tecla para voltar ao menu
# -------------------------------------------------------------
executar_script() {
    local SCRIPT="$1"
    local TITULO="$2"

    echo ""
    echo "[ Executando: $TITULO ]"
    echo "-------------------------------------------"

    if [ -f "$SCRIPTS_DIR/$SCRIPT" ]; then
        bash "$SCRIPTS_DIR/$SCRIPT"
    else
        echo "[ERRO] Script não encontrado: $SCRIPTS_DIR/$SCRIPT"
    fi

    echo ""
    echo "-------------------------------------------"
    echo "Pressione ENTER para voltar ao menu..."
    read
}

# -------------------------------------------------------------
# Função: menu_processos
# Sub-menu para gerenciamento de processos
# -------------------------------------------------------------
menu_processos() {
    clear
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║    HOSPITAL DC - GERENCIAR PROCESSOS      ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "  1 - Listar processos ativos"
    echo "  2 - Buscar processo por nome"
    echo "  3 - Encerrar processo por PID"
    echo "  0 - Voltar ao menu principal"
    echo ""
    read -p "Escolha uma opção: " OPC_PROC

    case "$OPC_PROC" in
        1) bash "$SCRIPTS_DIR/06_processos.sh" listar ;;
        2)
            read -p "Nome do processo: " NOME_PROC
            bash "$SCRIPTS_DIR/06_processos.sh" buscar "$NOME_PROC"
            ;;
        3)
            read -p "PID do processo: " PID_PROC
            bash "$SCRIPTS_DIR/06_processos.sh" matar "$PID_PROC"
            ;;
        0) return ;;
        *) echo "[ERRO] Opção inválida." ;;
    esac

    echo ""
    echo "Pressione ENTER para voltar..."
    read
}

# -------------------------------------------------------------
# Loop principal do menu
# -------------------------------------------------------------
while true; do
    exibir_cabecalho
    read -p "  Escolha uma opção [0-9]: " OPCAO

    case "$OPCAO" in
        1) executar_script "01_update.sh" "Atualização do Sistema" ;;
        2) executar_script "02_apache.sh" "Instalação e Validação do Apache" ;;
        3) executar_script "03_estrutura.sh" "Criação da Estrutura de Diretórios" ;;
        4) executar_script "04_backup.sh" "Backup Automatizado" ;;
        5) executar_script "05_deploy.sh" "Deploy do Portal Hospital DC" ;;
        6) menu_processos ;;
        7) executar_script "07_monitoramento.sh" "Monitoramento do Sistema" ;;
        8) executar_script "08_usuarios_permissoes.sh" "Usuários e Permissões" ;;
        9) executar_script "09_relatorio.sh" "Relatório Operacional" ;;
        0)
            echo ""
            echo "╔══════════════════════════════════════════╗"
            echo "║   Hospital DC - Encerrando sistema...     ║"
            echo "║   Até logo!                               ║"
            echo "╚══════════════════════════════════════════╝"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo "[ERRO] Opção inválida. Escolha entre 0 e 9."
            echo "Pressione ENTER para continuar..."
            read
            ;;
    esac
done
