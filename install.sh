#!/bin/bash

# 获取当前脚本所在目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 用法：./install.sh [tmux|nvim|all]
# 不传参数则安装全部
install_tmux() {
    echo "========== 安装 Tmux 配置 =========="
    # 1. 备份旧配置（如果存在且不是软链接）
    if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
        echo "发现旧的 .tmux.conf，正在备份到 .tmux.conf.bak..."
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
    fi

    # 2. 创建软链接（tmux 配置在 tmux/ 子目录下）
    echo "正在创建 .tmux.conf 软链接..."
    ln -sf "$DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

    # 3. 安装 TPM (Tmux Plugin Manager)
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "正在安装 Tmux Plugin Manager (TPM)..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi

    # 4. 重新加载 tmux 环境（如果 tmux 正在运行）
    if command -v tmux &> /dev/null && tmux info &> /dev/null 2>&1; then
        tmux source-file ~/.tmux.conf
        echo "正在安装 tmux 插件..."
        ~/.tmux/plugins/tpm/bin/install_plugins
    fi

    echo "✅ Tmux 配置安装完成！"
}

install_nvim() {
    echo "========== 安装 Neovim 配置 =========="
    NVIM_TARGET="$HOME/.config/nvim"
    mkdir -p "$HOME/.config"

    # 1. 备份旧配置（如果存在且不是软链接）
    if [ -e "$NVIM_TARGET" ] && [ ! -L "$NVIM_TARGET" ]; then
        echo "发现旧的 nvim 配置，正在备份到 nvim.bak..."
        mv "$NVIM_TARGET" "${NVIM_TARGET}.bak"
    fi

    # 2. 创建软链接
    echo "正在创建 ~/.config/nvim 软链接..."
    ln -sf "$DIR/nvim" "$NVIM_TARGET"

    echo "✅ Neovim 配置安装完成！"
}

# 解析参数并执行
case "${1:-all}" in
    tmux)
        install_tmux
        ;;
    nvim)
        install_nvim
        ;;
    all)
        install_tmux
        echo ""
        install_nvim
        ;;
    -h|--help)
        echo "用法: $0 [tmux|nvim|all]"
        echo "  tmux  - 仅安装 tmux 配置"
        echo "  nvim  - 仅安装 Neovim 配置"
        echo "  all   - 安装全部配置（默认）"
        ;;
    *)
        echo "未知选项: $1"
        echo "使用 $0 --help 查看用法"
        exit 1
        ;;
esac
