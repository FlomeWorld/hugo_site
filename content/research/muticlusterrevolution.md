---
title: "对k8s多集群的理解"
date: 2022-11-12
tags: [k8s]
draft: true
---


在 Kubernetes（K8S）的演进历程中，**“单集群规模化”**与**“多集群联邦化”**始终是一场博弈。

我曾目睹过太多团队因为单集群 **API Server** 响应延迟（P99 飙升至秒级）或一次错误的 **Global Resource** 变更导致全站宕机。在生产环境下，**Blast Radius（爆炸半径）** 控制永远是第一优先级。多集群架构不再是“选修课”，而是高可用架构的“必修课”。

---

## 核心技术选型：三种主流架构范式

多集群管理不是简单的“1+1”，它涉及到配置一致性、跨集群通信以及全局可观测性。

| 维度 | 方案 A：GitOps 控制平面 (ArgoCD/Flux) | 方案 B：开放多集群架构 (OCM/Karmada) | 方案 C：服务网格连接 (Istio Multi-Primary) |
| --- | --- | --- | --- |
| **控制力** | 中等（声明式最终一致性） | **极强（命令+声明混合）** | 弱（侧重于网络治理） |
| **复杂度** | 低（上手快，标准化程度高） | 高（需要学习新的 CRD 抽象） | 极高（证书与网络打通复杂） |
| **性能损耗** | 极低（仅 Agent 消耗） | 中等（中心控制面压力） | 高（Sidecar 资源占用） |
| **适用场景** | 生产环境标准化、大规模分发 | **复杂调度、多云资源抽象** | 微服务跨集群同步调用 |

---

## 基于 Karmada 的资源调度演进

如果需要跨云（如 AWS + Azure）进行精细化的资源分发，**Karmada** 是目前的顶流选择。它保留了原生 K8s API 的语义，降低了开发者的认知负担。

### 1. 架构拓扑 (Architecture Topology)

* **Karmada Control Plane**：负责监听资源请求，通过 `PropagationPolicy` 决定分发策略。
* **Execution Space**：为每个成员集群建立隔离的命名空间。

### 2. 生产级分发策略示例

以下代码展示了如何根据**成本**或**可用区**，将 Workload 自动调度到不同的集群：

```yaml
# 生产级分发策略：按权重在不同云厂商间分配实例
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: web-app-propagation
spec:
  resourceSelectors:
    - apiVersion: apps/v1
      kind: Deployment
      name: web-app
  placement:
    clusterAffinity:
      clusterNames:
        - aws-us-east-1
        - azure-west-eu
    # 权重调度：60% 流量在 AWS（成本优化），40% 在 Azure（容灾）
    replicaScheduling:
      replicaDivisionStrategy: Weighted
      replicaSchedulingType: Divided
      weightPreference:
        staticWeightList:
          - targetCluster:
              clusterNames: ["aws-us-east-1"]
            weight: 60
          - targetCluster:
              clusterNames: ["azure-west-eu"]
            weight: 40

```

---

## 如何权衡

### 1. 跨集群服务发现：南北 vs 东西

* **南北流量（Global LB）**：通过云厂商的全局负载均衡（如 AWS Route53 或 GCP GLB）实现，简单稳定，但延迟受 DNS TTL 影响。
* **东西流量（MCS API）**：使用 K8s 社区的 **Multi-Cluster Services (MCS)** 标准。
> [!TIP]
> **避坑指南**：除非你的业务对跨集群调用有极高的 **mTLS** 强加密需求，否则不要轻易尝试 Istio 的跨集群直接连接。其证书管理和 Pod IP 冲突排查会成为运维的噩梦。



### 2. 可观测性：从分散到聚合

多集群最怕“盲人摸象”。

* **指标方案**：采用 **Thanos** 或 **VictoriaMetrics**。通过 `Remote Write` 将各集群数据汇聚，实现 **Global View**。
* **日志方案**：使用 Vector 或 Fluent Bit 采集，统一推送到中心化的 Elasticsearch 或 ClickHouse。

---

## 

多集群管理没有“银弹”，只有最适合业务阶段的方案：

1. **初创阶段（< 5 个集群）**：直接上 **ArgoCD + Helm Chart**。通过 Git 仓库的不同目录管理不同集群的配置，简单、透明、易回滚。
2. **平台化阶段（10-50 个集群）**：引入 **Karmada** 或 **OCM**。你需要跨集群的资源抽象和自动化的故障漂移（Failover）能力。
3. **成本优化期**：必须开启 **Topology Aware Hints**。优先在本集群/本可用区闭环流量，减少昂贵的跨地域流量费。

> [!CAUTION]
> **警告**：不要尝试在多集群间进行“实时数据库同步”。K8s 解决了无状态服务的漂移，但数据的物理定律（延迟与一致性）依然是不可逾越的红线。

