#!/usr/bin/env bash
# ==============================================================================
# Script: sync.sh
# Purpose: 一键将本仓库的 AGENTS.md 及 docs/* 细分规范应用至本机全局环境 (~/.codex, ~/.agents/docs)
# ==============================================================================

set -euo pipefail

# 颜色配置
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 路径定义
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_CODEX_DIR="$HOME/.codex"
GLOBAL_AGENTS_DOCS_DIR="$HOME/.agents/docs"

USE_SYMLINK=false

# 参数解析
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--link)
      USE_SYMLINK=true
      shift
      ;;
    -h|--help)
      echo "用法: ./sync.sh [选项]"
      echo ""
      echo "选项:"
      echo "  -l, --link    使用符号链接 (Symlink) 模式代替直接复制，源文件变更后全局实时生效"
      echo "  -h, --help    显示此帮助信息"
      exit 0
      ;;
    *)
      echo "未知参数: $1，使用 -h 查看帮助"
      exit 1
      ;;
  esac
done

echo -e "${BLUE}==> 开始应用规范到本机全局环境...${NC}"

# 1. 确保全局目录存在
mkdir -p "$GLOBAL_CODEX_DIR"
mkdir -p "$GLOBAL_AGENTS_DOCS_DIR"

# 2. 同步 AGENTS.md -> ~/.codex/AGENTS.md
SOURCE_AGENTS="$PROJECT_ROOT/AGENTS.md"
TARGET_AGENTS="$GLOBAL_CODEX_DIR/AGENTS.md"

if [[ -f "$SOURCE_AGENTS" ]]; then
  if [ "$USE_SYMLINK" = true ]; then
    ln -sf "$SOURCE_AGENTS" "$TARGET_AGENTS"
    echo -e "  [链接] $SOURCE_AGENTS -> ${YELLOW}$TARGET_AGENTS${NC}"
  else
    cp -f "$SOURCE_AGENTS" "$TARGET_AGENTS"
    echo -e "  [复制] AGENTS.md -> ${YELLOW}$TARGET_AGENTS${NC}"
  fi
else
  echo "错误: 未找到源文件 $SOURCE_AGENTS" >&2
  exit 1
fi

# 3. 同步 docs/*.md -> ~/.agents/docs/
SOURCE_DOCS_DIR="$PROJECT_ROOT/docs"

if [[ -d "$SOURCE_DOCS_DIR" ]]; then
  for doc in "$SOURCE_DOCS_DIR"/*.md; do
    if [[ -f "$doc" ]]; then
      filename="$(basename "$doc")"
      target_doc="$GLOBAL_AGENTS_DOCS_DIR/$filename"
      if [ "$USE_SYMLINK" = true ]; then
        ln -sf "$doc" "$target_doc"
        echo -e "  [链接] docs/$filename -> ${YELLOW}$target_doc${NC}"
      else
        cp -f "$doc" "$target_doc"
        echo -e "  [复制] docs/$filename -> ${YELLOW}$target_doc${NC}"
      fi
    fi
  done
fi

echo -e "${GREEN}✔ 规范应用完成！${NC}"
if [ "$USE_SYMLINK" = true ]; then
  echo -e "当前为 ${YELLOW}符号链接模式${NC}：本地修改将实时同步生效。"
else
  echo -e "当前为 ${YELLOW}直接复制模式${NC}：如需联动修改，可使用 ./sync.sh --link"
fi
