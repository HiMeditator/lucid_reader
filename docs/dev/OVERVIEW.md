# Lucid Reader 开发总览

Lucid Reader 是一款与大语言模型紧密结合的跨平台阅读器。它首先要成为一个可靠、流畅、可离线使用的本地阅读器，然后在此基础上提供翻译、朗读、语义检索、基于书籍的问答等 AI 增强能力。

## 文档索引

- [FEATURES.md](./FEATURES.md)：功能范围、阅读体验、AI、双语阅读、TTS、语义检索和 UI 信息架构。
- [ARCHITECTURE.md](./ARCHITECTURE.md)：技术架构、数据模型、本地存储、任务系统、平台适配、隐私、安全、性能和测试策略。
- [PROGRESS.md](./PROGRESS.md)：开发路线图、近期 TODO、技术验证 TODO、MVP 完成定义。

## 1. 项目定位

核心判断：

- 阅读体验是主功能，AI 是增强能力，不能让 AI 调用失败影响基础阅读。
- Android 与 Windows 是首批重点平台；iOS、macOS、Linux、Web 保留工程兼容性，但暂不投入完整适配。
- 用户的书籍、笔记、索引、模型配置应优先保存在本地；云端 AI 与云端 TTS 只在用户明确配置后使用。
- 大模型、Embedding、TTS 都要以可替换 Provider 的方式接入，避免业务代码绑定单一供应商。

## 2. 目标用户

- 听书用户。
- 一般的文档/书籍阅读用户。
- 阅读外文书籍、论文、技术文档的个人用户。
- 希望边读边翻译、摘要、提问、查找上下文的深度阅读用户。
- 使用本地模型或私有模型网关，重视隐私和离线能力的用户。

## 3. 核心场景

- 用户导入一本 EPUB、PDF、MOBI 或 TXT，应用完成解析、入库、生成目录与阅读进度。
- 用户阅读外文内容时，可以按段落、页面或章节进行双语对照翻译。
- 用户在阅读过程中选中一段文字，要求模型解释、总结、翻译或结合上下文回答。
- 用户输入自然语言问题，应用从当前书籍或整个书库检索相关片段，再交给大模型回答。
- 用户使用本地或云端 TTS 朗读书籍，并能切换语音、语速和语言。
- 用户在 Windows 上管理书库、批量导入和生成索引，在 Android 上继续阅读和查询。

## 4. 产品原则

- 本地优先：书籍文件、阅读进度、笔记、缓存翻译、向量索引默认存储在本机。
- 渐进增强：没有模型配置时仍是可用阅读器；配置模型后逐步开放 AI 功能。
- 可追溯：AI 问答必须展示引用片段和来源位置，避免只给出不可验证答案。
- 可控成本：翻译、Embedding、TTS 都要有缓存、批量策略、用量提示和取消机制。
- 可中断恢复：解析、索引、翻译、朗读等长任务必须可暂停、取消、重试。
- 跨平台一致：领域层与服务层尽量复用，平台差异封装在适配层。

## 5. 功能边界摘要

MVP 需要覆盖：

- 书库管理、文件导入、阅读进度保存。
- TXT、EPUB、PDF 阅读，MOBI 作为实验格式。
- OpenAI 兼容接口、Ollama 接口、Anthropic 兼容接口。
- 选中文本翻译、总结、解释和自定义提示词。
- 段落级双语阅读和翻译缓存。
- 单书语义检索与基于书籍的 RAG 问答。
- 至少一种 TTS 朗读方式。

详细功能拆分见 [FEATURES.md](./FEATURES.md)。

## 6. 非目标

早期版本明确不做：

- 不处理受 DRM 保护的电子书解密。
- 不承诺扫描版 PDF 的完整 OCR 体验。
- 不实现复杂排版编辑器。
- 不内置特定商业模型密钥。
- 不把云同步作为 MVP 依赖。
- 不优先优化 Web 平台体验。

## 7. 工程方向摘要

建议采用 Flutter 分层架构：

```text
UI Layer
  Screens / Widgets / State Notifiers

Application Layer
  Use Cases / Task Orchestration / View Models

Domain Layer
  Entities / Repository Interfaces / Service Interfaces

Infrastructure Layer
  Local Database / File Storage / Document Parsers / AI Providers / TTS Providers

Platform Layer
  Android / Windows / File Picker / System TTS / Native PDF or FFI Adapters
```

关键工程原则：

- UI 不直接调用模型接口、数据库或文件解析器。
- AI、TTS、Embedding、文档解析都通过接口调用，具体 Provider 放在基础设施层。
- 导入、解析、索引、翻译、朗读等长任务统一纳入任务系统。
- Android 与 Windows 的差异能力通过平台适配层封装。

详细架构拆分见 [ARCHITECTURE.md](./ARCHITECTURE.md)。

## 8. 下一步

当前项目仍处于规划与工程基础阶段。后续开发工作以 [PROGRESS.md](./PROGRESS.md) 的 TODO 为准，完成一个阶段后再更新对应任务状态。
