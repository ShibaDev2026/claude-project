# =============================================================================
# Dockerfile — claude-project
#
# Application : claude-project
# Framework   : Spring Boot 4.0.3
# JDK         : Eclipse Temurin 21 (JRE, Alpine-based for minimal image size)
#
# Build prerequisite:
#   The JAR must already exist at target/claude-project-0.0.1-SNAPSHOT.jar
#   Run `mvn clean package -DskipTests` before building this image.
#
# Build:
#   docker build -t claude-project:latest .
#
# Run:
#   docker run -p 8080:8080 claude-project:latest
# =============================================================================

# ── Base image ────────────────────────────────────────────────────────────────
# eclipse-temurin:21-jre-alpine — JRE-only (no compiler) keeps the image lean
FROM eclipse-temurin:21-jre-alpine

# ── Timezone ──────────────────────────────────────────────────────────────────
ENV TZ=Asia/Taipei

# ── Non-root user ─────────────────────────────────────────────────────────────
# Running as a dedicated non-root user limits damage if the container is
# compromised (principle of least privilege)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# ── Working directory ─────────────────────────────────────────────────────────
WORKDIR /app

# ── Copy application JAR ──────────────────────────────────────────────────────
# Rename to app.jar so the ENTRYPOINT stays version-independent
COPY target/claude-project-0.0.1-SNAPSHOT.jar app.jar

# ── File ownership ────────────────────────────────────────────────────────────
# Ensure appuser can read the JAR (required after switching away from root)
RUN chown appuser:appgroup app.jar

# ── Switch to non-root user ───────────────────────────────────────────────────
USER appuser

# ── Exposed port ─────────────────────────────────────────────────────────────
# Spring Boot default HTTP port; override with -e SERVER_PORT=xxxx if needed
EXPOSE 8080

# ── Health check ──────────────────────────────────────────────────────────────
# Polls Spring Boot Actuator /actuator/health every 30 s
# Requires spring-boot-starter-actuator on the classpath (already in pom.xml)
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD wget -qO- http://localhost:8080/actuator/health || exit 1

# ── Entrypoint ────────────────────────────────────────────────────────────────
# JVM flags explained:
#   -Djava.security.egd  — faster SecureRandom on Linux (avoids /dev/random blocking)
#   -Dspring.profiles.active=prod — activate the production Spring profile
#   -XX:+UseG1GC         — G1 garbage collector, good balance for server workloads
#   -Xms256m / -Xmx512m  — initial / maximum heap size
ENTRYPOINT ["java", \
    "-Djava.security.egd=file:/dev/./urandom", \
    "-Dspring.profiles.active=prod", \
    "-XX:+UseG1GC", \
    "-Xms256m", \
    "-Xmx512m", \
    "-jar", "app.jar"]
