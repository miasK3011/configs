#!/bin/bash
# Uso: bash setup-zsh.sh

set -e

echo '
/$$      /$$ /$$                                               /$$
| $$$    /$$$|__/                                              | $$
| $$$$  /$$$$ /$$  /$$$$$$   /$$$$$$$       /$$$$$$$$  /$$$$$$$| $$$$$$$
| $$ $$/$$ $$| $$ |____  $$ /$$_____/      |____ /$$/ /$$_____/| $$__  $$
| $$  $$$| $$| $$  /$$$$$$$|  $$$$$$          /$$$$/ |  $$$$$$ | $$  \ $$
| $$\  $ | $$| $$ /$$__  $$ \____  $$        /$$__/   \____  $$| $$  | $$
| $$ \/  | $$| $$|  $$$$$$$ /$$$$$$$/       /$$$$$$$$ /$$$$$$$/| $$  | $$ /$$ /$$
|__/     |__/|__/ \_______/|_______/       |________/|_______/ |__/  |__/|__/|__/

Configuração das configurações do Zsh, Oh My Zsh, Powerlevel10k e plugins úteis que uso

'
echo '____________________________________________________________________________________________'
echo "🚀 Iniciando configuração do Zsh..."

# Configurações do repositório
GITHUB_USER="miasK3011"  # Altere para seu usuário do GitHub
GITHUB_REPO="configs"  # Altere para o nome do seu repositório
GITHUB_BRANCH="main"  # Altere para 'master' se necessário

REPO_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}"

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if ! command -v zsh &> /dev/null; then
    echo -e "${YELLOW}Zsh não encontrado. Instalando...${NC}"
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y zsh
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm zsh
    else
        echo "Por favor, instale o Zsh manualmente"
        exit 1
    fi
fi

# Instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}Instalando Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${YELLOW}Oh My Zsh já está instalado${NC}"
fi

# Instalar Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo -e "${GREEN}Instalando Powerlevel10k...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo -e "${YELLOW}Powerlevel10k já está instalado${NC}"
fi

# Instalar zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo -e "${GREEN}Instalando zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo -e "${YELLOW}zsh-autosuggestions já está instalado${NC}"
fi

# Instalar zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo -e "${GREEN}Instalando zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo -e "${YELLOW}zsh-syntax-highlighting já está instalado${NC}"
fi

# Instalar zsh-history-substring-search
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" ]; then
    echo -e "${GREEN}Instalando zsh-history-substring-search...${NC}"
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
else
    echo -e "${YELLOW}zsh-history-substring-search já está instalado${NC}"
fi

# Backup do .zshrc existente
if [ -f "$HOME/.zshrc" ]; then
    echo -e "${YELLOW}Fazendo backup do .zshrc existente...${NC}"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Baixar .zshrc do repositório
echo -e "${GREEN}Baixando .zshrc do repositório...${NC}"
if curl -fsSL "${REPO_URL}/.zshrc" -o "$HOME/.zshrc"; then
    echo -e "${GREEN}✅ .zshrc baixado com sucesso${NC}"
else
    echo -e "${YELLOW}⚠️  Erro ao baixar .zshrc. Usando configuração padrão...${NC}"
    cat > "$HOME/.zshrc" << 'EOF'
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    dirhistory
    zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
export PATH="$HOME/.local/bin:$PATH"
EOF
fi

# Backup do .p10k.zsh existente
if [ -f "$HOME/.p10k.zsh" ]; then
    echo -e "${YELLOW}Fazendo backup do .p10k.zsh existente...${NC}"
    cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Baixar .p10k.zsh do repositório
echo -e "${GREEN}Baixando .p10k.zsh do repositório...${NC}"
if curl -fsSL "${REPO_URL}/.p10k.zsh" -o "$HOME/.p10k.zsh"; then
    echo -e "${GREEN}✅ .p10k.zsh baixado com sucesso${NC}"
else
    echo -e "${YELLOW}⚠️  Erro ao baixar .p10k.zsh${NC}"
    echo -e "${YELLOW}Execute 'p10k configure' para configurar o Powerlevel10k${NC}"
fi

# Definir Zsh como shell padrão
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${GREEN}Definindo Zsh como shell padrão...${NC}"
    chsh -s $(which zsh)
    echo -e "${YELLOW}Você precisará fazer logout e login novamente para aplicar a mudança${NC}"
fi

echo ""
echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo -e "${YELLOW}Para aplicar as mudanças, execute: source ~/.zshrc${NC}"
echo -e "${YELLOW}Ou abra um novo terminal${NC}"
