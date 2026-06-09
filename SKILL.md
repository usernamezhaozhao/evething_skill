---
name: esearch
description: 通过自然语言调用 Everything (voidtools) 进行极速文件搜索
---

# evething-search

## 路径

```
EVERYTHING = %USERPROFILE%\Evething\Everything.exe
ES         = %USERPROFILE%\Evething\es.exe
RESULT     = %USERPROFILE%\Evething\result\
```

导出结果统一存到 `%USERPROFILE%\Evething\result\`，目录不存在时先 `mkdir`。

## 启动检查

es.exe 依赖 Everything.exe 后台运行。每次使用前先检测，没跑则启动：

```bat
tasklist /fi "imagename eq Everything.exe" 2>nul | find /i "Everything.exe" >nul
if errorlevel 1 start "" "%USERPROFILE%\Evething\Everything.exe"
```

---

## 1. 搜索 (es.exe)

```
es.exe [搜索词] [选项]
```

### 自然语言 → 命令

| 用户说 | 命令 |
|--------|------|
| "找 xxx" | `es.exe "xxx"` |
| "找 xxx，只要 N 条" | `es.exe "xxx" -n N` |
| "C 盘下的 xxx" | `es.exe "xxx" -path "C:\"` |
| "最近 N 天的 xxx" | `es.exe "xxx dm:last<N>days"` |
| "今天的 xxx" | `es.exe "xxx dm:today"` |
| "大于 X MB 的 xxx" | `es.exe "xxx size:>Xmb"` |
| "所有的 PDF" | `es.exe "ext:pdf"` |
| "包含 xxx 的文件夹" | `es.exe "folder:xxx"` |
| "排除 xxx" | `es.exe "!xxx"` |
| "xxx 或 yyy" | `es.exe "xxx | yyy"` |
| "路径中包含 xxx" | `es.exe "xxx" -match-path` |
| "最大的 N 个文件" | `es.exe -sort size-descending -n N` |
| "最近修改的 N 个文件" | `es.exe -sort dm-descending -n N` |
| "正则搜 xxx" | `es.exe -regex "xxx"` |
| "大小写敏感搜 xxx" | `es.exe -case "xxx"` |

### 搜索语法

| 语法 | 含义 | 示例 |
|------|------|------|
| `a b` | AND | `report 2024` |
| `a \| b` | OR | `.jpg \| .png` |
| `!a` | NOT | `*.txt !backup` |
| `<a \| b> c` | 分组 | `<report \| summary> 2024` |
| `ext:` | 扩展名 | `ext:mp3` |
| `folder:` / `file:` | 类型过滤 | `folder:project` |
| `size:>1gb` / `size:100kb..1mb` | 大小 | `size:>10mb` |
| `dm:today` / `dm:thisweek` / `dm:last7days` | 修改日期 | `dm:2024-01-01..2024-06-30` |
| `dc:` | 创建日期 | `dc:lastyear` |
| `da:` | 访问日期 | `da:today` |
| `rc:` | 最近修改 | `rc:last5minutes` |
| `attributes:` | 属性 | `attributes:H`（隐藏） `attributes:A`（存档） |
| `run-count:` | 运行次数 | `run-count:>5` |

日期常量: `today` `yesterday` `thismonth` `thisweek` `last7days` `last<N>days`
大小常量: `kb` `mb` `gb` `tb`

### 常用选项

| 选项 | 说明 |
|------|------|
| `-n N` | 最多 N 条结果 |
| `-path <path>` | 限定搜索目录（递归子目录） |
| `-parent-path <path>` | 仅搜索该目录下的内容 |
| `-parent <path>` | 仅搜索直接子文件，不含子文件夹 |
| `-sort name\|size\|dm-descending` | 排序（大小/修改时间默认降序，其余默认升序） |
| `-match-path` | 全文路径匹配 |
| `-regex` | 正则表达式 |
| `-case` | 区分大小写 |
| `-whole-word` | 全字匹配 |
| `-highlight` | 高亮匹配的文字 |

---

## 2. 导出 (es.exe)

导出结果统一存到 `%USERPROFILE%\Evething\result\`。执行前确保该目录存在：

```bat
mkdir "%USERPROFILE%\Evething\result" 2>nul
```

| 用户说 | 命令 |
|--------|------|
| "导出所有 xxx 为 CSV" | `es.exe "xxx" -export-csv "%USERPROFILE%\Evething\result\结果.csv"` |
| "导出所有 xxx 为 TXT" | `es.exe "xxx" -export-txt "%USERPROFILE%\Evething\result\结果.txt"` |
| "导出所有 xxx 为 EFU" | `es.exe "xxx" -export-efu "%USERPROFILE%\Evething\result\结果.efu"` |

导出后屏幕不显示内容。也可以用 `-csv` / `-txt` 输出到屏幕再重定向。完成后告知用户文件路径。

```bat
es.exe "ext:mp3" -csv > "%USERPROFILE%\Evething\result\music.csv"
```

---

## 3. 统计 (es.exe)

| 用户说 | 命令 |
|--------|------|
| "有多少个 xxx" | `es.exe "xxx" -get-result-count` |
| "xxx 总共占多大" | `es.exe "xxx" -get-total-size` |

`-get-result-count` 只输出数字，不列文件。`-get-total-size` 输出字节数，可配合 `-size-format 3` 显示为 MB。

---

## 4. 运行次数 (es.exe)

| 用户说 | 命令 |
|--------|------|
| "xxx 运行过多少次" | `es.exe -get-run-count "xxx"` |
| "把 xxx 运行次数设为 N" | `es.exe -set-run-count "xxx" N` |
| "把 xxx 运行次数加 1" | `es.exe -inc-run-count "xxx"` |

---

## 5. 设置持久化 (es.exe)

```
es.exe -size -dm -size-format 2 -save-settings
```

将常用选项写入 `es.exe` 同目录的 `es.ini`，之后每次自动生效。`-clear-settings` 恢复默认。

---

## 6. Everything.exe 操作

es.exe 干不了的，用 Everything.exe：

| 用户说 | 命令 |
|--------|------|
| "创建 D:\Music 的文件列表" | `Everything.exe -create-file-list music.efu D:\Music` |
| "编辑 music.efu" | `Everything.exe -edit music.efu` |
| "打开 music.efu" | `Everything.exe -filelist music.efu` |
| "重建索引" | `Everything.exe -reindex` |
| "打开书签 xxx" | `Everything.exe -bookmark "xxx"` |
| "用筛选器 xxx" | `Everything.exe -filter "xxx" -s "搜索词"` |
| "打开新窗口搜 xxx" | `Everything.exe -newwindow -s "xxx"` |
| "显示/隐藏 Everything" | `Everything.exe -toggle-window` |
| "关闭 Everything" | `Everything.exe -exit` |

批量重命名（弹出 GUI）：

| "重命名这些文件" | `Everything.exe -rename file1 file2 file3` |
| "复制/移动这些文件" | `Everything.exe -copyto file1 file2` / `-moveto file1 file2` |

---

## 7. DIR 风格快捷方式 (es.exe)

兼容 Windows DIR 命令习惯：

| 快捷方式 | 等价 | 说明 |
|----------|------|------|
| `/ad` | `folder:` | 仅目录 |
| `/a-d` | `file:` | 仅文件 |
| `/aR` | `attributes:R` | 只读 |
| `/aH` | `attributes:H` | 隐藏 |
| `/aS` | `attributes:S` | 系统 |
| `/oN` | `-sort name-ascending` | 按名称升序 |
| `/o-S` | `-sort size-descending` | 按大小降序 |
| `/oD` | `-sort dm-ascending` | 按修改时间升序 |

---

## 8. 错误码

| 错误码 | 说明 |
|--------|------|
| 0 | 成功 |
| 5 | 导出文件失败 |
| 6 | 未知参数 |
| 8 | Everything.exe 未运行（需先启动） |

---

## 注意事项

- 含空格的路径/值用双引号包裹
- `|` `&` `>` `<` `^` 在 cmd 中需用 `^` 转义
- 参数名中 `-` 可省略，如 `-noww` = `-no-ww`
- `-sort size` 默认降序（大→小），`-sort name` 默认升序
- `-create-file-list` 执行完会自动退出，不弹 GUI
