# evething-skill

Everything (voidtools) 一键安装 + Claude Code 自然语言搜索 skill。

## 项目结构

```
├── install_evething.bat        # 一键安装脚本（检测架构、解压、启动）
├── source/                     # Everything + ES 安装包
│   ├── Everything-1.4.1.1032.{x86,x64,ARM64}.zip
│   ├── ES-1.1.0.30.{x86,x64,ARM64}.zip
│   └── Everything.lng.zip
└── SKILL.md
```

## 安装后路径

```
%USERPROFILE%\Evething\
├── Everything.exe
├── es.exe
├── Everything.lng
└── result\           # 搜索结果导出目录
```

## Skill

skill 名 `esearch`，位于 `~/.claude/skills/esearch/SKILL.md`。

支持自然语言调用 Everything 进行文件搜索、导出、统计等。es.exe 依赖 Everything.exe 常驻后台，skill 会自动检测并启动。

## 注意事项

- Everything.exe 和 es.exe 版权归 voidtools.com 所有
- 本仓库仅提供安装脚本和 skill，不包含一切从 voidtools 下载的二进制文件的源代码
