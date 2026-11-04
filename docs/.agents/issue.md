# Issue Log

> Issue 索引与详情按 [AGENTS.md](../../AGENTS.md)「Operational Excellence → Issue」维护：头部索引表 + 主体详情块。

| ID | 标题 | 完成状态 | 完成时间 | 详情 |
| :- | :--- | :--- | :--- | :--- |
| I-001 | Markdown 段落手动折行致中文句中空格与 PR 语境硬断行，规约层禁止并落地检测门禁 | ✅ 已完成 | 2026-11-04 | [详情](#I-001) |

<a id="I-001"></a>
## I-001：Markdown 段落手动折行致中文句中空格与 PR 语境硬断行，规约层禁止并落地检测门禁

- **问题描述**：Markdown 正文中完整语句被手动折行（含 blockquote 与普通段落，按列宽折行与一句一行两种形态）。段内换行被解析为 Soft Line Break，Chrome/Safari 在两个汉字间渲染出多余空格；GitHub Issue/PR/Discussion 语境直接渲染为句中硬断行；跨行句子导致整句 grep 与 Agent 精确匹配编辑（`old_str` 逐字匹配）失效。
- **表因根因**：规约层缺约束——AI Agent 生成 Markdown 时默认按 ~80 列折行（anthropics/claude-code#33666），仓内无对应规约条目与机器门禁拦截。
- **处理方式**：AGENTS.md「Documentation Standards」第 9 条（Markdown Source Layout）落地核心规则与指针；新建唯一详尽来源 `docs/markdown-source-layout-specifications.md`（核心规则、豁免清单、判定口径、Rationale、反方回应、Prettier/markdownlint 工具门、内嵌 awk 检测器、正负例）；README 索引与 content-currency、plain-language「与其他规范的分工」同步交叉引用。
- **后续防范**：新增/修改文档后运行规约内嵌的 `md_hardwrap` 检测器（有命中 exit 1，可作 CI / pre-commit 门禁）；启用 markdownlint 的仓库关闭 MD013，不为消 lint 告警而折行。
- **同类问题影响**：一切按 Markdown 渲染消费的正文（`.md` 文件、PR/Issue/Discussion 正文与评论）。
- **注意事项**：逐字节消费载体（Runtime Prompt 模板、测试 fixture）保留原有换行不重排；并线修复存量折行时中文|中文直接相接、中文|英文按盘古之白补一个空格，防反向注入空格。
