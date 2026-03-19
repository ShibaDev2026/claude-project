#!/usr/bin/env bash
# mvn-local.sh：本地開發用 Maven wrapper
# 自動偵測 Nexus 是否可用，決定走 Nexus proxy 或直連 Maven Central

set -euo pipefail

NEXUS_STATUS_URL="http://localhost:9190/service/rest/v1/status"
SETTINGS_NEXUS="$HOME/.m2/settings.xml"
SETTINGS_DIRECT="$HOME/.m2/settings-direct.xml"

if curl -sf --max-time 2 "$NEXUS_STATUS_URL" > /dev/null 2>&1; then
  echo "[mvn-local] Nexus 可用 → 走 localhost:9190 proxy"
  ./mvnw -s "$SETTINGS_NEXUS" "$@"
else
  echo "[mvn-local] Nexus 不可用 → 直連 Maven Central"
  ./mvnw -s "$SETTINGS_DIRECT" "$@"
fi
