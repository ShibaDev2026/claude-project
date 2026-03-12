# 後端技能提升學習歷程
> Backend Engineering Upskill — Personal Roadmap
 
---
 
## 📋 目錄
 
- [專案目的](#-專案目的)
- [整體進度總覽](#-整體進度總覽)
- [JDK 現代化](#-jdk-現代化)
- [Mockito 測試策略](#-mockito-測試策略)
- [框架強化](#-框架強化)
- [容器化與基礎設施](#-容器化與基礎設施)
- [AI 整合](#-ai-整合)
- [自架 MCP Server 專案](#-自架-mcp-server-專案)
- [版本與依賴清單](#-版本與依賴清單)
- [相關連結](#-相關連結)
 
---
 
## 🎯 專案目的
 
本專案旨在系統性地提升後端工程能力，涵蓋 JDK 現代化、測試策略、容器化部署、AI 整合，以及自架 MCP Server 平台建置。每個模組均附有預期產出與可驗證的學習成果。
 
---
 
## 📊 整體進度總覽
 
| 模組 | 狀態 | 備註 |
|------|------|------|
| JDK 現代化 | 🔵 進行中 | 1.8 → 11 / 17 / 21 / 24 |
| Mockito 測試策略 | 🔵 進行中 | 含 WireMock、ArchUnit、Testcontainers |
| 框架強化 | ⚪ 待開始 | Spring Boot 4.x / Security / Batch |
| 容器化與基礎設施 | 🔵 進行中 | Jenkins CI 已完成，Harbor / Nexus / K8S 進行中 |
| AI 整合 | ⚪ 待開始 | Spring AI、RAG |
| 自架 MCP Server | 🟠 規劃中 | 後台控管平台 |
 
> 🔵 進行中　⚪ 待開始　🟠 規劃中　✅ 完成
 
---
 
## ☕ JDK 現代化
 
### 目標
從 JDK 1.8 逐步升級，掌握各版本新特性，並在既有專案中驗證相容性。
 
### 升級路線
 
| 版本 | 類型 | 重點特性 |
|------|------|----------|
| JDK 11 | LTS | 模組系統、`var` 關鍵字、新 String / HTTP Client API |
| JDK 17 | LTS | Sealed Classes、Pattern Matching、Record |
| JDK 21 | LTS | Virtual Thread (Project Loom)、Structured Concurrency |
| JDK 24 / 25 | 預覽 | 斷言 API（JEP）、Value Types 預覽、Valhalla 持續追蹤 |
 
### Virtual Thread 重點
Virtual Thread 能大幅降低 I/O 密集型服務的執行緒開銷。
 
**預期產出：** 壓測報告，比較傳統執行緒 vs Virtual Thread 的吞吐量與延遲。
 
### 預期產出
- [ ] 各版本 Feature Demo 分支
- [ ] 遷移注意事項文件（Breaking Changes 清單）
 
---
 
## 🧪 Mockito 測試策略
 
目標：建立完整的單元 / 整合測試層，提高程式碼可維護性，並防止架構耦合。
 
### 4.1 核心測試框架 — Mockito 5 + AssertJ + Instancio
 
- **Mockito 5**：Strict Stubbing 預設開啟，減少測試噪音
- **AssertJ**：Fluent API 提升斷言可讀性
- **Instancio**：自動產生測試資料，降低 Fixture 維護成本
 
### 4.2 外部 HTTP 服務隔離 — WireMock
 
- 模擬第三方 REST API，確保測試不依賴外部服務可用性
- 驗證 retry、timeout、error handling 邏輯
 
### 4.3 架構測試 — ArchUnit
 
- 強制 Controller 不得直接依賴 Repository
- 定義 Package 分層規則並在 CI 中自動檢查
 
**預期產出：** ArchUnit 規則集，並整合至 CI Pipeline
 
### 4.4 整合測試容器化 — Testcontainers
 
- 啟動真實 PostgreSQL / Redis / Kafka 容器替代 H2
- 確保測試環境與生產環境一致
 
**預期產出：** 整合測試執行時間基準報告
 
---
 
## 🔧 框架強化
 
> 待補充，預計涵蓋以下主題：
 
- [ ] Spring Boot 4.x 升級 + Jakarta EE 遷移要點
- [ ] Spring Security 6 Lambda DSL 改寫
- [ ] Spring Batch Partitioned Step 大資料處理
- [ ] Spring Data 進階應用
 
---
 
## 🐳 容器化與基礎設施
 
### CI/CD Pipeline
 
#### 工具清單
 
| 工具 | 用途 | 狀態 |
|------|------|------|
| Jenkins | 多分支 Pipeline，自動化建置 / 測試 / 部署 | 🔵 進行中 |
| Harbor | 私有 Docker Registry，支援映像掃描 | ⚪ 待建置 |
| Nexus | Maven 私有 Repository，依賴快取加速 build | ⚪ 待建置 |
| Kubernetes | 藍綠部署、HPA 自動擴縮容 | ⚪ 待建置 |
 
#### Jenkins 已完成項目 ✅
 
- Jenkins LTS（JDK 17）+ 動態 Agent（Alpine JDK 21）架設完成
- Docker Socket Binding，Agent 可執行 Docker build
- Role-based Authorization，多專案帳號權限隔離
- JCaC（Configuration as Code）設定版控
- GitHub Credentials 整合，Polling 自動觸發
- `claude-project` CI Pipeline 全段通過
 
```
Checkout → Build (mvn) → Test (JUnit) → Docker Build → Verify Image
```
 
#### Jenkins 進行中 🔵
 
- [ ] Jenkinsfile 改善（移除重複 Checkout、Archive JAR、修正 Token 安全警告）
- [ ] Jenkins Folder 多專案隔離（各專案帳號只能存取自己的 job 與 log）
- [ ] Artifact 版本管理（jar 多版本保管，支援回滾指定版本）
- [ ] Jenkins 操作手冊（架構圖、流程圖、排查 Runbook）
 
#### CI/CD 完整流程（目標）
 
```
GitHub (develop)
      ↓  Polling / Webhook
   Jenkins
      ├── Build (mvn)
      ├── Test (JUnit + ArchUnit)
      ├── Archive JAR (多版本保管)
      ├── Docker Build
      └── Push to Harbor
            ↓
        Kubernetes
            ├── 藍綠部署
            └── HPA 自動擴縮容
```
 
**預期產出：**
- [x] Jenkinsfile（CI 階段）
- [x] 應用程式 Dockerfile（eclipse-temurin:21-jre-alpine）
- [ ] Harbor push stage
- [ ] K8S Manifest + Helm Chart
 
---
 
### Message Queue
 
- **技術選型**：RabbitMQ / Kafka（比較評估中）
- **目標**：實作 Dead Letter Queue、消息冪等性、順序消費
 
---
 
### ELK Stack
 
- Elasticsearch + Logstash + Kibana
- **目標**：
  - 統一日誌收集，涵蓋 Jenkins build log 多專案集中查詢
  - 建立效能分析 Dashboard
  - 加速問題排查，支援專案間 log 隔離檢索
 
---
 
## 🤖 AI 整合
 
### Spring AI
- 整合 OpenAI / Ollama 作為 LLM Backend
- 實作 Chat、Embedding、Function Calling
 
### RAG（Retrieval-Augmented Generation）
- **向量資料庫選型**：PGVector / Weaviate / Chroma
- 建立文件切割、Embedding 儲存、語意檢索流程
 
**預期產出：** 可查詢內部文件的 RAG Demo 服務
 
---
 
## 🖥️ 自架 MCP Server 專案
 
核心目標：建立一套可管理多個 LLM Agent 的後台控管平台，具備熱拔插、熔斷、監控能力。
 
### 後台控管平台
- 統一管理 MCP Server 的啟停、版本與路由
- 提供 Token 使用量統計與 Prompt 記錄查詢介面
 
### 組態與可靠性
 
| 功能 | 技術方案 |
|------|----------|
| Config 集中管理 | Spring Cloud Config / Apollo |
| 熱拔插 | 不停機更新模型設定 |
| 熔斷機制 | Resilience4j，防止 LLM 呼叫雪崩 |
| 本地 LLM 微調 | Ollama + LoRA Fine-tuning |
 
### 通訊協定
- **HTTPS / mTLS**：服務間加密通訊
- **gRPC**：高效能模型呼叫協定（Protobuf Schema 版控）
- **WebSocket**：串流輸出（Streaming Response）
 
### 資料儲存
- **RDMS（PostgreSQL）**：結構化設定與稽核日誌
- **NoSQL（Redis / MongoDB）**：對話紀錄、快取、向量儲存
- **RAG**：PGVector 整合，支援語意搜尋
 
### 部署
- **Docker Compose**：本地開發一鍵啟動，與 Jenkins 同一 subnet（172.20.0.0/24）
- **Kubernetes**：生產環境部署，含 ConfigMap / Secret 管理
 
**預期產出：** 完整的 `docker-compose.yml` + K8S Helm Chart
 
---
 
## 📦 版本與依賴清單
 
| 工具 / 框架 | 版本 | 用途 |
|-------------|------|------|
| Java / JDK | 21 (LTS) | 主要開發環境 |
| Spring Boot | 4.0.3 | 核心框架 |
| Mockito | 5.x | 單元測試 Mock |
| AssertJ | 3.x | Fluent 斷言 |
| Instancio | 3.x | 測試資料生成 |
| WireMock | 3.x | 外部 HTTP 模擬 |
| ArchUnit | 1.x | 架構測試 |
| Testcontainers | 1.x | 整合測試容器 |
| Docker / Compose | latest | 本地容器化 |
| Jenkins | LTS (JDK 17) | CI/CD Controller |
| Harbor | latest | 私有 Docker Registry |
| Nexus | 3.x | Maven 私有 Repository |
| Kubernetes | 1.29+ | 生產部署 |
| Spring AI | 1.x | AI 整合 |
 
---
 
## 🔗 相關連結
 
- 📁 GitHub Repository：[https://github.com/ShibaDev2026/claude-project/]
- 📝 學習筆記（Notion / Confluence）：（填入連結）
- 🚀 CI Pipeline Dashboard：（填入連結）
- 🌐 Demo 服務網址：（填入連結）
 
---
<div align="center">
 
*Last updated：2026-03-12 &nbsp;|&nbsp; Maintained by：ShibaDev2026 [ryan.shiba.developer@gmail.com]
 
</div>
