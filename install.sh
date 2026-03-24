#!/bin/bash

set -e

# ============================================================
# get os version
# ============================================================
OS_ID=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
OS_VERSION_ID=$(grep "^VERSION_ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
echo "Detected OS: $OS_ID $OS_VERSION_ID"


# ============================================================
# 1. configure mirrors source (yum / apt)
# [DISABLED] 暂时禁用，待测试验证后再启用
# ============================================================
echo "[1/6] Skipping mirrors source configuration (disabled)."

# if [[ "$OS_ID" == "centos" ]]; then
#     if [[ "$OS_VERSION_ID" == "7" ]]; then
#         sudo cp yum/centos7/kubernetes.repo /etc/yum.repos.d/kubernetes.repo
#         echo "CentOS 7 yum source configured."
#     elif [[ "$OS_VERSION_ID" == "8" ]]; then
#         sudo cp yum/centos8/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
#         echo "CentOS 8 yum source configured."
#     else
#         echo "Unsupported CentOS version: $OS_VERSION_ID"
#     fi
# elif [[ "$OS_ID" == "ubuntu" ]]; then
#     sudo cp apt/ubuntu22.04/sources.list /etc/apt/sources.list
#     sudo apt update
#     echo "Ubuntu apt source configured."
# elif [[ "$OS_ID" == "debian" ]]; then
#     sudo cp apt/debian12/sources.list /etc/apt/sources.list
#     sudo apt update
#     echo "Debian apt source configured."
# else
#     echo "Unsupported OS: $OS_ID, skipping mirrors configuration."
# fi


# ============================================================
# 2. install zsh & oh-my-zsh
# ============================================================
echo "[2/6] Installing zsh and oh-my-zsh..."

# 2.1 install zsh (oh-my-zsh 依赖 zsh，必须先装)
if [[ "$OS_ID" == "centos" ]]; then
    sudo yum install -y zsh git
elif [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    sudo apt install -y zsh git
fi

# 2.2 install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "oh-my-zsh already installed, skipping."
fi

# 2.3 set theme to bira
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="bira"/' "$ZSHRC"
    echo "oh-my-zsh theme set to bira."
fi

# 2.4 install zsh-autosuggestions plugin
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    echo "zsh-autosuggestions installed."
else
    echo "zsh-autosuggestions already exists, skipping."
fi

# 2.5 install zsh-syntax-highlighting plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    echo "zsh-syntax-highlighting installed."
else
    echo "zsh-syntax-highlighting already exists, skipping."
fi

# 2.6 enable plugins in .zshrc
if [ -f "$ZSHRC" ]; then
    sed -i 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"
    echo "oh-my-zsh plugins configured."
fi

# 2.7 change default shell to zsh
if [ "$(basename "$SHELL")" != "zsh" ]; then
    ZSH_PATH=$(which zsh)
    sudo chsh -s "$ZSH_PATH" "$USER"
    echo "Default shell changed to zsh ($ZSH_PATH)."
fi


# ============================================================
# 3. copy config files & configure alias
# (oh-my-zsh 安装完成后再处理 alias，确保 .zshrc 已存在)
# ============================================================
echo "[3/6] Copying config files and configuring alias..."

cp config/my_alias ~/.my_alias
cp config/vimrc ~/.vimrc
cp config/gitconfig ~/.gitconfig

mkdir -p ~/.ssh
cp config/ssh_config ~/.ssh/config
chmod 600 ~/.ssh/config

# append alias and locale to .bashrc
if ! grep -q "\.my_alias" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo ". ~/.my_alias" >> ~/.bashrc
    echo "export LANG=\"zh_CN.UTF-8\"" >> ~/.bashrc
    echo "export LC_ALL=\"zh_CN.UTF-8\"" >> ~/.bashrc
fi

# append alias and locale to .zshrc (oh-my-zsh 已安装，.zshrc 已存在)
if ! grep -q "\.my_alias" "$ZSHRC" 2>/dev/null; then
    echo "" >> "$ZSHRC"
    echo ". ~/.my_alias" >> "$ZSHRC"
    echo "export LANG=\"zh_CN.UTF-8\"" >> "$ZSHRC"
    echo "export LC_ALL=\"zh_CN.UTF-8\"" >> "$ZSHRC"
fi


# ============================================================
# 4. install tmux
# ============================================================
echo "[4/6] Installing tmux..."

if [[ "$OS_ID" == "centos" ]]; then
    sudo yum install -y tmux
elif [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    sudo apt install -y tmux
fi


# ============================================================
# 5. install ccat
# ============================================================
echo "[5/6] Installing ccat..."
sudo cp bin/ccat /usr/local/bin/ccat
sudo chmod +x /usr/local/bin/ccat


# ============================================================
# 6. done
# ============================================================
echo ""
echo "[6/6] All done! Please restart your terminal or run: exec zsh"
