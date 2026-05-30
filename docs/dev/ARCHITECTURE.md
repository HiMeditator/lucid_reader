# Lucid Reader 技术架构规划

本文档记录 Lucid Reader 的工程架构、数据模型、平台适配和质量约束。产品功能见 [FEATURES.md](./FEATURES.md)，开发进度见 [PROGRESS.md](./PROGRESS.md)。

## 1. 总体架构

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

关键原则：

- UI 不直接调用模型接口、数据库或文件解析器。
- AI、TTS、Embedding、文档解析都通过接口调用，具体 Provider 放在基础设施层。
- 长任务放入任务队列，并尽量使用 isolate 或平台后台任务，避免阻塞 UI。
- 所有外部接口调用都要统一记录状态：pending、running、succeeded、failed、cancelled。

## 2. 建议目录结构

```text
lib/
  app/
    app.dart
    router.dart
    localization/
    theme/
  l10n/
  core/
    config/
    errors/
    logging/
    result/
    task_queue/
    utils/
  features/
    library/
      domain/
      application/
      infrastructure/
      presentation/
    reader/
      domain/
      application/
      infrastructure/
      presentation/
    ai/
      domain/
      application/
      infrastructure/
      presentation/
    tts/
      domain/
      application/
      infrastructure/
      presentation/
    search/
      domain/
      application/
      infrastructure/
      presentation/
    settings/
      domain/
      application/
      infrastructure/
      presentation/
```

说明：

- `library` 负责书籍导入、元数据、书库列表。
- `reader` 负责阅读器核心状态、渲染、选区、目录、进度。
- `ai` 负责聊天、提示词、Provider 配置、流式响应。
- `tts` 负责语音 Provider、朗读队列、音频播放。
- `search` 负责分块、Embedding、全文检索、RAG。
- `settings` 负责模型、界面语言、翻译目标语言、TTS 语言、隐私、外观等配置。
- `l10n` 保存 Flutter 本地化资源，初始包含英语、中文和日语，并为后续语言扩展保留一致的 key 结构。

国际化要求：

- UI 层不得直接写死用户可见文案，应通过本地化 key 获取界面文本。
- 界面 locale 与书籍语言、翻译目标语言、TTS 语言分离，避免切换 UI 语言时意外改变阅读或 AI 行为。
- Locale 状态应由应用级配置驱动，支持跟随系统语言和用户手动选择。
- 添加新语言时，原则上只新增本地化资源、注册 supported locale 和补齐验证，不修改 domain 或 application 层业务逻辑。

## 3. 数据模型草案

### 3.1 Book

- `id`
- `title`
- `subtitle`
- `authors`
- `language`
- `format`
- `source_path`
- `imported_path`
- `cover_path`
- `created_at`
- `updated_at`
- `last_opened_at`
- `reading_progress`
- `metadata_json`

### 3.2 DocumentSection

- `id`
- `book_id`
- `parent_id`
- `title`
- `order_index`
- `level`
- `href`
- `start_location`
- `end_location`

### 3.3 TextChunk

- `id`
- `book_id`
- `section_id`
- `chunk_index`
- `text`
- `language`
- `token_count`
- `location`
- `content_hash`

### 3.4 TranslationCache

- `id`
- `book_id`
- `chunk_id`
- `source_language`
- `target_language`
- `provider_id`
- `model`
- `prompt_hash`
- `source_hash`
- `translated_text`
- `created_at`

### 3.5 AiProviderConfig

- `id`
- `type`: `openai_compatible`、`ollama`、`anthropic_compatible`
- `name`
- `base_url`
- `api_key_ref`
- `default_chat_model`
- `default_embedding_model`
- `default_tts_model`
- `extra_json`
- `enabled`

### 3.6 VectorIndexRecord

- `id`
- `book_id`
- `chunk_id`
- `embedding_provider_id`
- `embedding_model`
- `dimension`
- `vector_ref`
- `content_hash`
- `created_at`

### 3.7 Note

- `id`
- `book_id`
- `section_id`
- `location`
- `selected_text`
- `note_text`
- `color`
- `created_at`
- `updated_at`

### 3.8 AppSettings

- `id`
- `interface_locale_mode`: `system` 或 `manual`
- `interface_locale`: BCP 47 locale tag，例如 `en`、`zh`、`ja`
- `translation_target_language`
- `tts_language`
- `theme_mode`
- `reader_appearance_json`
- `updated_at`

## 4. 本地存储

推荐存储类型：

- 关系型数据库：保存书籍、章节、进度、配置、任务、笔记、缓存元数据。
- 文件存储：保存导入后的原始文件、封面、解析资源、TTS 音频缓存。
- 向量存储：MVP 可从本地数据库或独立向量索引文件开始，后续再替换为更专业的本地向量库。

目录建议：

```text
app_data/
  library/
    originals/
    extracted/
    covers/
  cache/
    translations/
    tts/
    temp/
  indexes/
    vectors/
  database/
```

迁移要求：

- 数据库必须有 schema version。
- 配置表必须能保存界面语言偏好；新增 locale 不应要求迁移用户数据。
- 书籍解析产物和向量索引必须能重建。
- 应提供“重建索引”“清理缓存”“修复书库”入口。

## 5. 状态管理与任务系统

建议把长耗时操作统一纳入任务系统：

- 导入书籍。
- 解析文档。
- 生成封面。
- 分块。
- Embedding。
- 章节翻译。
- TTS 音频生成。

任务字段：

- `id`
- `type`
- `status`
- `progress`
- `book_id`
- `input_json`
- `output_json`
- `error_message`
- `created_at`
- `updated_at`

任务要求：

- 支持取消。
- 支持失败重试。
- 支持应用重启后恢复任务状态。
- UI 可展示任务队列和错误。

## 6. 平台适配

### 6.1 Android

重点：

- 文件选择与持久化访问权限。
- 后台任务限制。
- 安全存储 API Key。
- 系统 TTS。
- 大文件读取性能。
- 低内存设备上的 PDF 和 EPUB 渲染。
- 不同尺寸和方向的屏幕适配（比如大屏设备和横屏的页面适配）

### 6.2 Windows

重点：

- 文件路径与权限处理。
- 拖拽导入。
- 键盘快捷键。
- 多窗口或宽屏布局。
- 系统 TTS 或 SAPI 适配。
- 本地 Ollama 服务发现与连通性提示。

### 6.3 其他平台

保留工程兼容：

- iOS/macOS/Linux/Web 不作为早期验收目标。
- 不在共享层写死 Android 或 Windows 特有逻辑。
- 平台能力通过接口注入。

## 7. 隐私、安全与合规

- 首次启用云端 AI、云端 Embedding、云端 TTS 时，必须提示文本会发送到第三方服务。
- 用户可以选择仅使用本地模型。
- API Key 必须加密保存，日志中脱敏。
- 崩溃日志不能包含书籍正文、提示词全文或 API Key。
- 提供清理缓存、删除书籍、删除索引、删除对话历史的入口。
- 对外部模型返回内容不做事实保证，尤其是无引用回答。

## 8. 性能目标

MVP 建议目标：

- 打开普通 TXT 或 EPUB 的首屏时间小于 2 秒。
- 已解析书籍再次打开首屏时间小于 1 秒。
- 阅读滚动保持流畅，不因翻译或索引任务明显卡顿。
- 单本书索引任务可后台执行，并显示进度。
- AI 流式回答首 token 延迟应清晰展示加载状态。
- 大文件处理不得一次性把全部内容加载进 UI 状态。

## 9. 错误处理

需要标准化错误类型：

- 文件不存在或无权限。
- 文档格式不支持。
- 文档解析失败。
- 模型 Provider 未配置。
- 模型接口认证失败。
- 模型接口超时。
- 模型上下文长度不足。
- Embedding 维度不匹配。
- TTS 语音不可用。
- 本地索引损坏。

错误展示要求：

- 用户看到可理解的原因和下一步动作。
- 开发日志保留技术细节。
- 可重试错误提供重试按钮。
- 不可恢复错误提供导出日志或重建入口。

## 10. 测试策略

单元测试：

- 本地化资源 key 完整性。
- Locale 选择和回退逻辑。
- 文档分块。
- 阅读位置序列化。
- Provider 请求转换。
- 翻译缓存命中。
- RAG prompt 构造。
- 错误映射。

集成测试：

- 导入 TXT/EPUB/PDF 样例。
- 创建索引并检索。
- 模拟 AI Provider 流式返回。
- 模拟 TTS 生成。

端到端测试：

- 导入一本书。
- 打开阅读页。
- 切换英语、中文、日语界面语言。
- 选中文字翻译。
- 生成语义索引。
- 基于书籍提问并跳转引用。

测试资源：

- 准备小体积公开版权样例文件。
- 准备异常文件：空文件、损坏 PDF、超大 TXT、无文本层 PDF。
- Provider 测试使用 mock server，避免真实 API 成本。

## 11. 主要风险

- PDF 文本提取和选区能力可能受文件质量影响很大。
- MOBI 生态支持有限，早期只能作为实验功能。
- 本地 TTS 和本地 Embedding 模型可能导致安装包体积过大。
- AI 调用成本不可控，需要缓存、批处理、取消和用量提示。
- 翻译质量受模型影响，术语一致性需要额外设计。
- RAG 回答容易出现无依据推断，必须强调引用和上下文限制。
- Android 后台任务限制会影响长时间索引和章节预翻译。
