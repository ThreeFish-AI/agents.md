# Terminology Specifications (专业术语与本地化规范)

> **核心哲学**：**Semantic Fidelity (语义保真)** 与 **Entropy Reduction (认知熵减)**。技术文档与人机协同以消除歧义、降低解码成本为首要准则。

---

## 🎯 核心原则与判定准则 (Decision Framework)

技术词汇的翻译与否直接决定了系统的信噪比。面对专业词汇时，强制推行以下三级判定法则：

```
                    ┌──────────────────────────────────────────────┐
                    │               遇到专业技术词汇               │
                    └──────────────────────┬───────────────────────┘
                                           ▼
            ┌─────────────────────────────────────────────────────────────┐
            │ 是否属于架构实体 / 行业公认专有名词 / 直译存在严重语义损耗？│
            └──────────────┬───────────────────────────────┬──────────────┘
                           │ 是 (YES)                      │ 否 (NO)
                           ▼                               ▼
       ┌───────────────────────────────────────┐ ┌───────────────────────────────────┐
       │     强制保留标准英文 (Native Form)    │ │ 已有成熟、准确且无歧义的中文译法？│
       │ (例: Harness, Agent, Runtime, Prompt) │ └─────────┬───────────────────┬───┘
       └───────────────────────────────────────┘           │ 是                │ 否
                                                           ▼                   ▼
                                                ┌─────────────────────┐ ┌───────────────────┐
                                                │    采用规范中文     │ │ 首次采用中英对照: │
                                                │ (例: 仓库, 内存泄漏)│ │   Term (中文解释) │
                                                └─────────────────────┘ └───────────────────┘
```

1. **第一级：架构实体与核心概念 (Native Preservation - 强制英文)**
   - 凡涉及软件工程、AI Agent 基础设施、运行时环境的核心机制与实体名词，**一律直接使用行业公认的英文原词**。
   - 严禁生搬硬套非通用的中文翻译，防止引入不必要的认知噪声。
2. **第二级：高歧义与严重语义损耗词 (Anti-Distortion - 严禁直译)**
   - 直译会导致语义偏离或产生违和感/非专业感的词汇（如将 `Harness` 译为“马具/线束”，将 `Runtime` 译为“运行时间”），**绝对禁止直译**。
3. **第三级：成熟通用技术词 (Established Localized Terms - 允许规范中文)**
   - 仅在业界已有广泛共识且绝无歧义的技术词（如 `Repository` $\rightarrow$ 仓库、`Memory Leak` $\rightarrow$ 内存泄漏、`Deadlock` $\rightarrow$ 死锁）允许使用规范中文。
   - 若特定受众需要理解门槛较低的材料，**首次出现时可采用 `英文原词 (中文注解)` 形式**（如 `Agent Harness (智能体评测与运行套件)`），后续正文一律回归英文原词。

---

## 📋 核心术语正负清单 (Terminology Reference Table)

在方案规划、任务汇报、文档沉淀与代码评审中，严格遵循下述用词约束：

| 术语 (Canonical Term) | 规范用法 (Preferred) | 严禁/避免用法 (Anti-patterns) | 语义说明与使用约束 |
| :--- | :--- | :--- | :--- |
| **Harness** | `Harness` / `Test Harness` / `Agent Harness` | ❌ 马具、线束、吊带、安全带、驾驭器 | 专指用于测试、评测、托管 Agent 运行的标准化支撑测试夹具/框架。 |
| **Agent / Subagent** | `Agent` / `Subagent` | ❌ 代理人、智能体（在架构专有术语语境下） | 在框架架构（如 Agent Loop、Subagent 并发）中统一保留英文，指代协同主体时可称“智能体”。 |
| **Runtime** | `Runtime` | ❌ 运行时间、运行期 | 专指程序/模型运行时的底层执行环境或支撑系统。 |
| **Benchmark** | `Benchmark` / `Baseline` | ❌ 基准点（机械式直译）、打分标准 | 专指系统性能/能力的标准化评测基准。 |
| **Prompt / System Prompt**| `Prompt` / `System Prompt` | ❌ 催促、提示符（除非专指终端 PS1） | 工程语境中指代给大模型的指令时统一使用 Prompt，避免“提示词”带来的语义弱化。 |
| **Token / Token Budget** | `Token` / `Token Budget` | ❌ 代币、令牌 | 模型输入输出的基本离散单元及预算控制。 |
| **Context Window** | `Context Window` / `Context` | ❌ 语境窗口、上下文窗户 | 模型上下文承载窗口与上限。 |
| **Pipeline** | `Pipeline` | ❌ 管道（易与 Unix Pipe 混淆） | 业务与数据处理流水线；在宏观执行流时可称“流水线”，涉及架构系统实体优先用 `Pipeline`。 |
| **Sandbox** | `Sandbox` | ❌ 沙盒（指代隔离环境时允许，但实体名词优先英文） | 隔离运行环境。 |
| **Hook / Lifecycle Hook** | `Hook` / `Lifecycle Hook` | ❌ 钩子、生命周期钩子 | 框架扩展与拦截注入点。 |
| **Payload** | `Payload` | ❌ 有效载荷（偏航天术语） | 传输协议或事件中所承载的业务数据体。 |
| **Embedding / RAG** | `Embedding` / `RAG` | ❌ 嵌入、检索增强生成（过度啰嗦） | 向量化与检索增强生成，行业统一称谓。 |
| **Fine-tuning** | `Fine-tuning` | ❌ 微调（工程配置与系统设计场景建议使用原词） | 模型参数微调。 |

---

## ✍️ 中英文混排与排版规范 (Typography)

1. **盘古之白 (Spacing Between CJK and Western Characters)**:
   - 中文与英文单词、阿拉伯数字之间必须保留**恰好一个半角空格**。
   - *正确*：`在构建 Agent Harness 时，需要确保 Runtime 环境隔离。`
   - *错误*：`在构建Agent Harness时，需要确保Runtime环境隔离。`
   - *例外*：中文全角标点与英文字符之间不留空格（如 `调用 Agent，获取结果。`）。
2. **专有名词大小写规范 (Strict Capitalization)**:
   - 严格遵循官方大小写标准，杜绝全小写或随意缩写。
   - 例如：`GitHub`（非 `Github`）、`TypeScript`（非 `typescript`）、`JavaScript`、`Python`、`API`、`JSON`、`OAuth`、`Markdown`。
3. **行内代码与标识符引用 (Inline Code Marking)**:
   - 涉及文件名、命令、配置字段、代码类名或函数时，统一使用 Markdown 行内代码（反引号）包裹：
   - 例如：`` `sync.sh` ``、`` `uv run` ``、`` `ContextWindow` ``。
