#!/bin/bash
# =============================================================
# Script: 09_relatorio.sh
# Projeto: Hospital DC - Cloud Computing
# Autor: Marcuse Demarchi
# Instituição: Unidavi
# Descrição: Gera relatório operacional automatizado do ambiente
#            Hospital DC, salvando em logs/relatorio_execucao.txt
# =============================================================

LOG_DIR="/app/logs"
RELATORIO="$LOG_DIR/relatorio_execucao.txt"

mkdir -p "$LOG_DIR"

# -------------------------------------------------------------
# Função: gerar_relatorio
# Gera o relatório completo e salva em arquivo
# -------------------------------------------------------------
gerar_relatorio() {
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║    HOSPITAL DC - RELATÓRIO OPERACIONAL    ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "[INFO] Gerando relatório... Aguarde."

    # Inicia o arquivo de relatório
    cat > "$RELATORIO" <<EOF
=============================================================
  RELATÓRIO OPERACIONAL - HOSPITAL DC
  Projeto: Trabalho 03 - Linux, Shell Script e Cloud Computing
  Aluno: Marcuse Demarchi
  Tema: Hospital DC - Gerenciamento Hospitalar em Cloud
  Instituição: Unidavi
  Data/Hora de Geração: $(date '+%Y-%m-%d %H:%M:%S')
=============================================================

─────────────────────────────────────────────────────────────
 1. INFORMAÇÕES DO SISTEMA
─────────────────────────────────────────────────────────────
Hostname: $(hostname)
Sistema Operacional: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
Kernel: $(uname -r)
Uptime: $(uptime -p 2>/dev/null || uptime)
Data/Hora atual: $(date)

─────────────────────────────────────────────────────────────
 2. USO DE DISCO
─────────────────────────────────────────────────────────────
$(df -h)

─────────────────────────────────────────────────────────────
 3. USO DE MEMÓRIA
─────────────────────────────────────────────────────────────
$(free -h)

─────────────────────────────────────────────────────────────
 4. USO DOS DIRETÓRIOS DO HOSPITAL DC
─────────────────────────────────────────────────────────────
$(du -sh /app/hospital/* 2>/dev/null || echo "Estrutura de diretórios ainda não criada. Execute 03_estrutura.sh")

─────────────────────────────────────────────────────────────
 5. STATUS DO APACHE (Portal Hospital DC)
─────────────────────────────────────────────────────────────
$(if pgrep -x "apache2" > /dev/null 2>&1; then echo "[OK] Apache2 está em EXECUÇÃO."; echo "Portal disponível em: http://localhost:8080"; else echo "[ALERTA] Apache2 NÃO está em execução."; fi)

─────────────────────────────────────────────────────────────
 6. ÚLTIMOS BACKUPS
─────────────────────────────────────────────────────────────
$(ls -lht /app/backups/*.tar.gz 2>/dev/null | head -5 || echo "Nenhum backup encontrado. Execute 04_backup.sh")

─────────────────────────────────────────────────────────────
 7. ÚLTIMOS LOGS GERADOS
─────────────────────────────────────────────────────────────
$(ls -lht /app/logs/*.log 2>/dev/null | head -10 || echo "Nenhum log encontrado.")

─────────────────────────────────────────────────────────────
 8. ARQUIVOS PUBLICADOS NO APACHE
─────────────────────────────────────────────────────────────
$(ls -lh /var/www/html/ 2>/dev/null || echo "Diretório do Apache não encontrado.")

─────────────────────────────────────────────────────────────
 9. USUÁRIOS DO SISTEMA (Hospital DC)
─────────────────────────────────────────────────────────────
$(grep -E "medico_user|enfermeiro_user|recepcao_user|ti_user" /etc/passwd 2>/dev/null || echo "Usuários específicos do Hospital não criados ainda. Execute 08_usuarios_permissoes.sh")

─────────────────────────────────────────────────────────────
 10. GRUPOS DO SISTEMA (Hospital DC)
─────────────────────────────────────────────────────────────
$(grep -E "hospital_ops|medicos|enfermagem|recepcao|ti_hospital" /etc/group 2>/dev/null || echo "Grupos específicos do Hospital não criados ainda. Execute 08_usuarios_permissoes.sh")

─────────────────────────────────────────────────────────────
 11. PERMISSÕES NOS DIRETÓRIOS PRINCIPAIS
─────────────────────────────────────────────────────────────
$(ls -ld /app/hospital/* 2>/dev/null || echo "Estrutura de diretórios não encontrada.")

─────────────────────────────────────────────────────────────
 12. PROCESSOS ATIVOS (Top 10 por CPU)
─────────────────────────────────────────────────────────────
$(ps aux --sort=-%cpu | head -11)

=============================================================
  FIM DO RELATÓRIO - $(date '+%Y-%m-%d %H:%M:%S')
=============================================================
EOF

    echo "[OK] Relatório gerado com sucesso!"
    echo "[INFO] Arquivo: $RELATORIO"
}

# -------------------------------------------------------------
# Função: exibir_resumo_terminal
# Exibe um resumo do relatório no terminal
# -------------------------------------------------------------
exibir_resumo_terminal() {
    echo ""
    echo "=== RESUMO RÁPIDO ==="
    echo "Disco:"
    df -h / | awk 'NR==2{print "  Uso: "$5" | Disponível: "$4}'
    echo "Memória:"
    free -h | awk '/^Mem:/{print "  Total: "$2" | Usada: "$3}'
    echo "Apache:"
    pgrep -x "apache2" > /dev/null 2>&1 && echo "  [OK] Em execução" || echo "  [ALERTA] Parado"
    echo "Relatório salvo em: $RELATORIO"
}

# -------------------------------------------------------------
# Execução principal
# -------------------------------------------------------------
gerar_relatorio
exibir_resumo_terminal

echo ""
echo "[SUCESSO] Relatório operacional do Hospital DC concluído!"
