@Library('jenkins-pipeline@main') _

ciPipeline(
    githubCredentials: 'github-credentials',
    harborCredentials: 'harbor-robot-claude-project',
    // k3d dev/prod namespace 專屬固定 NodePort（跨專案不得重複，2026-07-16 已用
    // `kubectl get svc -A` 確認：30090 為本專案現用、30091 未被占用；改動前請重新確認）
    // 註：30090/30091 為 k3d cluster 唯一對外映射的兩個 port（見 k8s/setup/.env
    //     K3D_DEV_PORT / K3D_PROD_PORT），故本專案沿用之
    devNodePort: 30090,
    prodNodePort: 30091
)
