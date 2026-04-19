#!/bin/bash

# 获取当前脚本所在目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 用法：./install.sh [tmux|nvim|ghostty|fish|yazi|all] 不传参数则安装全部

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

install_ghostty() {
    echo "========== 安装 Ghostty 配置 =========="
    GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
    GHOSTTY_TARGET="$GHOSTTY_DIR/config.ghostty"
    mkdir -p "$GHOSTTY_DIR"

    if [ ! -f "$DIR/ghostty/config.ghostty" ]; then
        echo "未找到仓库内配置文件：$DIR/ghostty/config.ghostty"
        echo "请先参考：cp \"$GHOSTTY_TARGET\" \"$DIR/ghostty/config.ghostty\""
        return 1
    fi

    # 备份旧配置（如果存在且不是软链接）
    if [ -f "$GHOSTTY_TARGET" ] && [ ! -L "$GHOSTTY_TARGET" ]; then
        echo "发现旧的 config.ghostty，正在备份到 config.ghostty.bak..."
        mv "$GHOSTTY_TARGET" "$GHOSTTY_TARGET.bak"
    fi

    echo "正在创建 config.ghostty 软链接..."
    ln -sf "$DIR/ghostty/config.ghostty" "$GHOSTTY_TARGET"

    echo "✅ Ghostty 配置安装完成！"
}

install_fish() {
    echo "========== 安装 Fish 配置 =========="
    FISH_TARGET="$HOME/.config/fish"
    mkdir -p "$FISH_TARGET"

    # 检查源目录是否存在
    if [ ! -d "$DIR/fish" ]; then
        echo "错误：未找到 $DIR/fish 目录"
        return 1
    fi

    # 备份旧配置（如果存在且不是软链接）
    if [ -e "$FISH_TARGET" ] && [ ! -L "$FISH_TARGET" ]; then
        echo "发现旧的 fish 配置，正在备份到 fish.bak..."
        mv "$FISH_TARGET" "${FISH_TARGET}.bak"
    fi

    # 创建软链接
    echo "正在创建 ~/.config/fish 软链接..."
    ln -sf "$DIR/fish" "$FISH_TARGET"

    echo "✅ Fish 配置安装完成！"
    echo "⚠️  注意：Fish 配置需要在新的 Fish Shell 会话中生效"
    echo "   可以运行 'fish' 重新进入 Fish，或执行 'exec fish' 重启当前会话"
}

install_yazi() {
    echo "========== 安装 Yazi 配置 =========="
    YAZI_TARGET="$HOME/.config/yazi"
    mkdir -p "$YAZI_TARGET"

    # 检查源目录是否存在
    if [ ! -d "$DIR/yazi" ]; then
        echo "错误：未找到 $DIR/yazi 目录"
        return 1
    fi

    # 备份旧配置（如果存在且不是软链接）
    if [ -e "$YAZI_TARGET" ] && [ ! -L "$YAZI_TARGET" ]; then
        echo "发现旧的 yazi 配置，正在备份到 yazi.bak..."
        mv "$YAZI_TARGET" "${YAZI_TARGET}.bak"
    fi

    # 创建软链接
    echo "正在创建 ~/.config/yazi 软链接..."
    ln -sf "$DIR/yazi" "$YAZI_TARGET"

    echo "✅ Yazi 配置安装完成！"
    echo "⚠️  注意：Yazi 配置需要在新的 Yazi 会话中生效"
}

# 解析参数并执行
case "${1:-all}" in
    tmux)
        install_tmux
        ;;
    nvim)
        install_nvim
        ;;
    ghostty)
        install_ghostty
        ;;
    fish)
        install_fish
        ;;
    yazi)
        install_yazi
        ;;
    all)
        install_tmux
        echo ""
        install_nvim
        echo ""
        install_ghostty
        echo ""
        install_fish
        echo ""
        install_yazi
        ;;
    -h|--help)
        echo "用法: $0 [tmux|nvim|ghostty|fish|yazi|all]"
        echo "  tmux    - 仅安装 tmux 配置"
        echo "  nvim    - 仅安装 Neovim 配置"
        echo "  ghostty - 仅安装 Ghostty 配置"
        echo "  fish    - 仅安装 Fish 配置"
        echo "  yazi    - 仅安装 Yazi 配置"
        echo "  all     - 安装全部配置（默认）"
        ;;
    *)
        echo "未知选项: $1"
        echo "使用 $0 --help 查看用法"
        exit 1
        ;;
esac
