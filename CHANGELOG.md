# Changelog

本文件依循 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.1.0/) 格式，
版號遵循 [Semantic Versioning](https://semver.org/lang/zh-TW/)。

---

## [Unreleased]

---

## [0.4.0] - 2026-03-19

### Added
- `mvn-local.sh`：本地開發 Maven wrapper，自動偵測 Nexus 可用性
  - Nexus 可用時走 `localhost:9190` proxy（`~/.m2/settings.xml`）
  - Nexus 不可用時直連 Maven Central（`~/.m2/settings-direct.xml`）
  - 偵測 timeout 2 秒，不阻塞開發流程

### Changed
- README.md 新增「本地開發 Maven 設定」章節，說明 `mvn-local.sh` 使用方式與設定前置條件
- README.md 更新 Nexus 狀態為完成

### Removed
- `compose.yaml`：內容為空（`services: {}`），無實際用途
- `config/.gitkeep`：目錄已有 `SecurityConfig.java`，佔位檔移除

---

## [0.3.0] - 2026-03-10

### Added
- Jenkinsfile 整合 jenkins-pipeline Shared Library（v1.2.3）
- CI Pipeline 流程：Checkout → Build → Test → Archive JAR → Docker Build

### Changed
- Jenkinsfile 精簡化，Pipeline 邏輯移至 Shared Library 統一管理
- Dockerfile 移至 Shared Library 集中維護，本專案移除

### Fixed
- Docker Build Stage 停用 BuildKit，修正 CI 環境相容性問題

---

## [0.2.0] - 2026-03-09

### Added
- Logback 日誌機制（`logback-spring.xml`）
  - 依年 / 月 / 日分層儲存至 `log/` 目錄
  - 透過 `application.properties` 控制開關與 log level

---

## [0.1.0] - 2026-03-01

### Added
- Spring Boot 4.0.3 專案初始化
- 基本依賴：Web MVC、Security、JPA、Actuator、Validation、DevTools
- 分層目錄結構：`config` / `controller` / `domain` / `dto` / `repository` / `service`
- Testcontainers 整合測試基礎設定

[Unreleased]: https://github.com/ShibaDev2026/claude-project/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/ShibaDev2026/claude-project/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/ShibaDev2026/claude-project/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/ShibaDev2026/claude-project/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/ShibaDev2026/claude-project/releases/tag/v0.1.0
