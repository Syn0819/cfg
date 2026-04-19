if status is-interactive
    # Commands to run in interactive sessions can go here
end

# === Claude Code 配置 ===
set -x ANTHROPIC_BASE_URL https://4sapi.com 
set -x ANTHROPIC_AUTH_TOKEN sk-NwrheAWvc5YdkhCVodSFhBZm2q7SjRsotjWqOIfZ4e9MgXYP
set -x API_TIMEOUT_MS 600000
set -x ANTHROPIC_MODEL claude-sonnet-4-6  
# 减少非必要流量
set -x CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC 1

alias cc='claude --dangerously-skip-permissions'

function reload
    source ~/.config/fish/config.fish
    echo "Fish configuration reloaded"
end

# yazi 文件管理
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    
    if set cwd (cat "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
        cd "$cwd"
    end
    
    rm -f "$tmp"
end

alias t task
abbr tb t burndown.weekly
abbr tc t calendar

abbr gs git status
abbr gd git diff
abbr gl git log
abbr glo git log --oneline
