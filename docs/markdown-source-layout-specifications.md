# Markdown Source Layout Specifications (Markdown 源码排版规范)

> **文档定位**：本文是 Markdown 源码排版的**唯一详尽来源 (Single Source of Truth)**。[AGENTS.md](../AGENTS.md) 中仅保留摘要级指针，核心规则、豁免边界、机器门禁与检测判据以本文为准；行内字符级排版（盘古之白、专有名词大小写、行内代码）以 [Terminology Specifications](./terminology-specifications.md)「中英文混排与排版规范」节为唯一事实源，本文不重述、只引用。

---

## 🎯 适用范围 (Scope)

治理对象为**一切按 Markdown 渲染消费的正文源码**：`.md` 文件正文（README、docs/、规约与方案文档）、引用块（blockquote）内的段落、列表项内容，以及写入 GitHub PR / Issue / Discussion 正文与评论的 Markdown 文本。

不在辖域：commit message 纯文本（Git/平台原生的变更叙事载体，措辞由 [Plain Language Specifications](./plain-language-specifications.md) 治理）；代码注释（由 [AGENTS.md](../AGENTS.md)「Comments」条目治理）；非 Markdown 的图源与图产物文件（A 档 candidate JSON、B 档 `.mmd`、SVG/PNG/HTML，见「与其他规范的分工」）；命中「豁免清单」的块级结构与逐字节消费载体。

## 📏 核心规则：一段一行 (One Paragraph, One Line)

1. **一段一行**：一个段落（含引用段、列表项内的段落）只占一个物理行；同段的多个句子同住一行，句内与句间都不另起物理行；
2. **两种折行形态一并禁止**：按列宽折行（72/80/100 列）与一句一行（Semantic Line Breaks 式）同为段内手动换行，均判违规；
3. **显示行宽交给 Renderer**：源码不承载显示行宽，阅读行长由编辑器软折行与渲染端负责；
4. **有意的分隔用结构承载**：分段用空行，并列要点用列表项，引用块内分段用空 `>` 行；
5. **语义级换行用显式语法**：确需渲染为换行的位置（地址块、签名档等）用 Hard Line Break 显式语法——行尾 `\` 或 `<br>`；行尾双空格同样合法但不可见、易被编辑器与 linter 剥除，不作首选。

**判定口径**：逐行扫描，一行既非块级结构（「豁免清单」所列形态、空行（含空 `>` 行）、标题行（ATX `#` 与 setext 下划线 `===`/`---`）、thematic break、列表标记行、表格行、GitHub alert 标记行（`> [!NOTE]` 等）、独立 badge/图片行、链接引用与脚注定义行），又紧跟另一非块级结构行、中间无空行分隔、上一行未以显式 Hard Line Break（行尾 `\`、行尾双空格、`<br>`）收尾、且该行引用深度不高于上一行，则该行是上一行的**续行**，判违规；检测输出续行号 N，表示应把第 N 行并回第 N-1 行。

## ✅ 豁免清单 (Exemptions)

| 载体 | 边界 |
| :--- | :--- |
| fenced code block | code fence（三反引号或三波浪号）内换行原样保留：命令与输出、ASCII 图表、文档正文内嵌的 mermaid 决策图与 Markdown 源码示例 |
| 表格 | GFM 表格一行一条记录，行本身即结构；单元格内需分行用 `<br>` |
| front matter | 文件头 YAML（`---`）/ TOML（`+++`）元数据块 |
| HTML 块 | 原生 HTML 块（如 `<details>`）标签行的换行；其内嵌的 Markdown 段落仍按本文执行 |
| 链接引用定义 / 脚注定义 | `[id]: url` 与 `[^1]: text` 定义行 |
| 数学块 | `$$…$$` display math 多行公式 |
| 逐字节消费载体 | 会原样进入模型输入或测试断言的运行时 Prompt 模板与测试 fixture，折行即改变字面字节，存量保持原换行不重排；普通文档正文不得借此豁免（判例：linuxarena/control-tower PR #950 一次性移除 33 篇文档约 2,450 处 72–80 列折行，Prompt 模板与测试 fixture 保留原样） |

## 📐 为什么禁止手动折行 (Rationale)

1. **中文句中被插空格**：Markdown 把段内单换行解析为 Soft Line Break，渲染为空格还是换行由实现决定<sup>[[1]](#ref1)</sup>；两个汉字之间的 Soft Line Break，截至 2026-11 wpt.fyi stable 跑测中 Chrome 156 与 Safari 27.2 在「应移除」用例上全部 FAIL（渲染出可见空格），Firefox 159 全部 PASS（Gecko 52 起移除，但复制粘贴仍带出空格）；对应缺陷单 Chromium issue 40069685、WebKit bug 260857 未修复，CommonMark 规范自身 "The result will be the same in browsers" 的断言已被 commonmark-spec issue #744 证伪；Prettier 3.4 因此停止在中日文字之间自动折行<sup>[[4]](#ref4)</sup>。中文行文不以空格分词<sup>[[5]](#ref5)</sup>，多出来的空格就是排版错误，而 CSS 规范把这一行为明确留给浏览器自行定义，作者侧等不到渲染端统一修复<sup>[[2]](#ref2)</sup>。折点落在中文与拉丁字符之间时，各浏览器（含 Firefox）统一渲染为一个空格、形似盘古之白，危害较小，但结果同样依赖 UA 启发式——本规范不分折点类型，一律禁止；
2. **换行敏感语境两头出错**：同一份手工折行的文本，`.md` 文件里相邻行合并为一段、Chrome/Safari 在汉字边界渲染出多余空格，贴进 GitHub PR / Issue / Discussion 正文与评论则每个单换行渲染为换行、句子被硬断开<sup>[[3]](#ref3)</sup>——没有一处渲染正确；
3. **重排噪声**：按列宽折行的段落，任何一处增删都会连带重排整段后续各行，Diff 被无关行淹没；一段一行时，同一句的修改恒定落在同一物理行；
4. **可检索性与 Agent 精确编辑失效**：跨行句子按整句 grep 命中为 0，规约体系的 grep 判据与 Agent 的精确匹配编辑（`old_str` 须逐字含空白匹配）都会失效。

**边界说明**：纯英文段落折行在浏览器渲染上无差异（Soft Line Break 一律渲染为空格<sup>[[1]](#ref1)</sup>），对英文禁折行依据的是理由 2–4 的跨语境一致性与可维护性，不是渲染缺陷。

## ⚖️ 对「按列宽折行」惯性的回应 (Counter-arguments)

- **「折行的 diff 更干净，改一句只动一行」**：这个收益由 `git diff --word-diff` 提供，不必改源文件；中文是多字节文本，默认按空白切词时整段算一个词，须加 `--word-diff-regex=.` 逐字定位<sup>[[8]](#ref8)</sup>；折行引入的重排噪声见理由 3，两项相抵后折行净亏；
- **「超长行在源文件里没法读」**：编辑器软折行解决——VS Code 内置 Markdown 扩展默认对 Markdown 文件开启 `editor.wordWrap: on`，按视口宽度折行显示，显示层折行不落源码；
- **「一句一行是语义折行，不算硬折」**：SemBr 自己的前置条件是折行不得改变最终渲染结果<sup>[[9]](#ref9)</sup>；中文场景的一句一行在 Chrome/Safari 渲染出句间空格、在 GitHub 评论语境渲染出硬断行，恰好违反该前置条件，按核心规则第 2 条一并禁止。

## 🔧 机器门禁与工具 (Machine Gate)

- **格式化**：Prettier `proseWrap: "never"`（语义为 "Put each prose block on a single line"）可自动并拢存量折行段落，适合已引入 Node 工具链的仓库<sup>[[6]](#ref6)</sup>；默认值 `"preserve"` 只保留现状不修复，`"always"` 按 `printWidth` 折行、与本规范相反，不得使用；
- **Lint**：markdownlint MD013（行长上限）与本规范方向相反，其修复建议就是拆行；启用 markdownlint 的仓库必须关闭 MD013（配置 `"line-length": false`）或至少豁免正文，防 lint 报错反向诱导折行<sup>[[7]](#ref7)</sup>；
- **CI / pre-commit**：下方 awk 检测器零依赖，有命中即 exit 1，可直接作仓库门禁。

## 🔍 可判定性与检测器 (Detectability)

检测器按上方「判定口径」实现：跳过全部豁免形态后，报告同段落内被手动折出的续行。脚本仅用 POSIX awk 特性，已在 macOS 自带 awk 上验证；输出 `<file>:<N>: <line>`，N 为应并回上一行的续行号，有命中时 exit 1：

```bash
awk '{ sub(/\r$/, "") }
FNR==1 { f=""; m=h=p=y=0; if ($0 ~ /^(---|\+\+\+)[ \t]*$/) { y=1; next } }
y { if ($0 ~ /^(---|\.\.\.|\+\+\+)[ \t]*$/) y=0; next }
{ s=$0; q=0; while (sub(/^[ \t]*>[ \t]?/, "", s)) q++
  t=s; sub(/^[ \t]+/, "", t)
  if (f!="") { if (index(t,f)==1 && t ~ /^[`~]+[ \t]*$/) f=""; p=0; next }
  if (m) { if (t ~ /\$\$/) m=0; p=0; next }
  if (h==2) { if (t ~ /-->/) h=0; p=0; next }
  l=sub(/^([-*+]|[0-9]+[.)])([ \t]+|$)/, "", t)
  if (t=="") { if (!l) h=0; p=0; next }
  if (h) { p=0; next }
  if (match(t, /^(```+|~~~+)/)) { f=substr(t,1,RLENGTH); p=0; next }
  if (t ~ /^\$\$/) { m=gsub(/\$\$/, "&", t)%2; p=0; next }
  if (t ~ /^<!--/) { h=(t ~ /-->/)?0:2; p=0; next }
  if (t ~ /^<\/?[A-Za-z][A-Za-z0-9-]*([ \t\/][^>]*)?>/ && t ~ />[ \t]*$/) { h=1; p=0; next }
  if (t ~ /^(#+([ \t]|$)|\||\[[^]]+\]:|\[![A-Za-z]+\]|[-*_=][-*_= \t]*$)/ || t ~ /^\[?!\[.*\)[ \t]*$/) { p=0; next }
  if (p && !l && q<=pq) { print FILENAME ":" FNR ": " $0; n++ }
  p=($0 !~ /(\\|  |<br *\/?>)$/); pq=q }
END { exit (n>0) }' "$@"

# 用法：作为 shell 函数体（md_hardwrap file...）调用，或把 "$@" 换成 $(git ls-files '*.md')。
# 有命中时 exit 1，可直接当 CI / pre-commit 门禁。
```

已知误报与前置约定：4 空格缩进的 indented code block、行首无 `|` 的 GFM 表格、未先进入 HTML 块状态的跨多行 HTML 开标签（首行标签未以 `>` 闭合时被判正文，属性续行报折行）、`<pre>`/`<script>`/`<style>`/`<textarea>` 块内空行之后相邻的原样内容行（块状态在空行处提前关闭）会被误报，本规约体系统一用 fenced code、行首带 `|` 的表格、单行完整标签（原样内容用 fenced code 承载）即可规避；先列表后引用（`- > a`）的嵌套、已进入 HTML 块后的跨多行开标签与行首 `$$` 带尾随正文的行（被整行按数学块跳过，其续行不检出）属保守漏报，不构成门禁障碍。

## ✍️ 正负例 (Before/After)

**负例 A（按列宽折行，判例样本）**：

```markdown
**全环境连接矩阵、配置中心 Key 映射、环境变量契约与已登记偏离** 见
[配置与外部依赖连接手册](./docs/concepts/configuration.md)。
非 local 环境连通前需先完成 [配置中心开通清单](docs/ops/config-center.md)。
```

**负例 B（一句一行，同为违规）**：

```markdown
本规范治理 Markdown 源码的物理行布局，行内排版由术语规范负责。
两句同属一个段落时，句号后不另起物理行。
```

**正例（合规：同段两句并回一个物理行）**：

```markdown
**全环境连接矩阵、配置中心 Key 映射、环境变量契约与已登记偏离**见[配置与外部依赖连接手册](./docs/concepts/configuration.md)。非 local 环境连通前需先完成[配置中心开通清单](docs/ops/config-center.md)。
```

**判定说明**：负例 A 的两处折点分别落在「见」与「配」之间、「。」与「非」之间，两个边界两侧都是汉字，在 Chrome/Safari 中各渲染出一个多余空格；负例 B 按句号折行，同样改变渲染结果；正例把同段两句并回一个物理行——若两句确需各自成段，两行之间加空行成两段。并线修复已折行的文本时，折点两侧均为汉字则直接相接，折点落在中文与英文单词、数字之间时按盘古之白处理——空格的量化与例外以 [Terminology Specifications](./terminology-specifications.md)「中英文混排与排版规范 (Typography)」节为唯一事实源，本文不重述；正例同时清理了样本中折点之外既有的行内空格（加粗边界与链接括号前各一处），防清理不彻底或反向注入多余空格。

## References (IEEE)

<a id="ref1"></a>[1] J. MacFarlane, "CommonMark Spec 0.31.2, §6.8 Soft line breaks," *CommonMark*, 2024. [Online]. Available: https://spec.commonmark.org/0.31.2/#soft-line-breaks.

<a id="ref2"></a>[2] E. J. Etemad, K. Ishii, and F. Rivoal, "CSS Text Module Level 3, §4.1.3 Segment break transformation rules," *W3C*, 2026. [Online]. Available: https://www.w3.org/TR/css-text-3/#line-break-transform.

<a id="ref3"></a>[3] GitHub, Inc., "Basic writing and formatting syntax — Line breaks," *GitHub Docs*. [Online]. Available: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#line-breaks.

<a id="ref4"></a>[4] Prettier team, "Prettier 3.4: a lot of bug fixes," *Prettier Blog*, Nov. 2024. [Online]. Available: https://prettier.io/blog/2024/11/26/3.4.0.

<a id="ref5"></a>[5] W3C Chinese Layout Task Force, "Requirements for Chinese Text Layout (中文排版需求), §4.2.2 Words and word boundaries," *W3C*, 2026. [Online]. Available: https://www.w3.org/TR/clreq/#h_word_boundaries.

<a id="ref6"></a>[6] Prettier, "Options — Prose wrap," *Prettier Docs*. [Online]. Available: https://prettier.io/docs/options#prose-wrap.

<a id="ref7"></a>[7] D. Anson, "MD013 — Line length," *markdownlint Docs*. [Online]. Available: https://github.com/DavidAnson/markdownlint/blob/main/doc/md013.md.

<a id="ref8"></a>[8] Git project, "git-diff(1) — --word-diff-regex," *Git Documentation*. [Online]. Available: https://git-scm.com/docs/git-diff.

<a id="ref9"></a>[9] M. Thompson, "Semantic Line Breaks (The SemBr Specification)," *sembr.org*. [Online]. Available: https://sembr.org/.

## 🤝 与其他规范的分工

- **与 [Terminology Specifications](./terminology-specifications.md)**：该规范「中英文混排与排版规范 (Typography)」节治理行内字符级排版（盘古之白、专有名词大小写、行内代码），本规范治理物理行级布局（一段一行）；同一行内的字符与间距问题归彼，行的切分归此；
- **与 [Plain Language Specifications](./plain-language-specifications.md)**：该规范治叙述性产出的措辞质感，本规范治正文的物理行切分，对象正交；同一段落措辞与行布局分别命中两规范时互不豁免；
- **与 [Content Currency Specifications](./content-currency-specifications.md)**：该规范治正文的内容时态，本规范治正文的行布局；句内折行会让按整句检索的 grep 判据零命中，本规范的检测器是该规范判据可靠性的前置条件；
- **与 [AGENTS.md](../AGENTS.md)「Visual Documentation」条目**：图源与图产物文件（A 档 candidate JSON / SVG / HTML、B 档 `.mmd`）非 Markdown 正文，不在本规范辖域；文档正文内嵌的 mermaid 决策图与 ASCII 图属 fenced code 豁免，图产物的嵌入方式仍以该条目为准。
