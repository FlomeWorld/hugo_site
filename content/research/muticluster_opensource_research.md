---
title: "K8S多集群开源项目选型研究"
date: 2022-07-12
tags: [k8s]
draft: true
---


目前主流的四个开源项目：**Karmada**、**Open Cluster Management (OCM)**、**KubeAdmiral** 以及 **Liqo** 进行了深度对比研究。

---

## 核心项目多维度对比表 

| 维度 | **Karmada** (CNCF Incubating) | **OCM** (CNCF Sandbox) | **KubeAdmiral** (ByteDance) | **Liqo** (Liquid Computing) |
| --- | --- | --- | --- | --- |
| **设计理念** | K8s API 零侵入，无限接近原生 | 模块化治理，侧重策略与合规 | 超大规模调度，极致性能优化 | 集群对等联邦，资源透明借用 |
| **核心优势** | **调度策略极丰富** (Failover/Weight) | **Hub-Spoke 架构极稳**，扩展性强 | 适配 **AI/GPU** 异构资源调度 | 真正的**跨集群 Pod 无感漂移** |
| **网络集成** | 深度集成 Submariner | 依赖外部 Mesh 或网关 | 自带高性能网络插件 | 内建虚拟网络隧道 |
| **上手难度** | 中等（类似 K8s API） | 较高（CRD 较多，配置细碎） | 高（适合超大规模集群管理） | 低（快速打通两个集群） |
| **适用场景** | 混合云/多云业务分发 | 金融级治理、强合规审计 | 万级节点、海量微服务调度 | 临时扩容、边缘云弹性扩容 |

---

## 深度解析：选型背后的逻辑

### 1. Karmada：多云调度

Karmada 是目前最符合 K8s 用户习惯的项目。它最大的杀手锏是其**调度器（Scheduler）**。

* **Propagated Resource**: 你只需要把原生的 Deployment 发给 Karmada，它能根据 `PropagationPolicy` 自动拆分。
* **Override 机制**: 能够针对不同集群修改特定字段（如镜像仓库、资源配额），这对于处理中外多云环境（如 AWS vs 阿里云）非常有效。

### 2. OCM：大厂的“治理基座”

OCM 的设计非常克制。它不强求接管所有 API，而是通过 **ManifestWork** 来定义“工作内容”。

* **安全性**: OCM 对 Spoke 集群的控制是**拉模式（Pull Mode）**，这在安全性要求极高的金融场景中是必须的。
* **策略引擎**: 配合治理策略（Policy），可以强制所有集群必须安装特定版本的安全组件。

### 3. Liqo：打破集群边界的“黑科技”

Liqo 的思路最激进，它通过 **Virtual Node** 模式，让集群 A 看起来像是集群 B 的一个节点。

* **无感扩展**: 当本地集群资源不足时，Pod 可以直接调度到“远端集群”的虚拟节点上。
* **网络穿透**: 自动建立 VPN 隧道，Pod IP 跨集群互通。

---

## 生产环境实战：YAML 配置对比

### Karmada 的分发逻辑（策略驱动）

```yaml
# Karmada PropagationPolicy
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: dynamic-web-policy
spec:
  resourceSelectors:
    - apiVersion: apps/v1
      kind: Deployment
      name: my-web-app
  placement:
    # 动态调度：优先选择 CPU 负载低的集群
    replicaScheduling:
      replicaDivisionStrategy: Weighted
      replicaSchedulingType: Divided
      weightPreference:
        staticWeightList:
          - targetCluster: {clusterNames: ["ali-hangzhou"]}
            weight: 70
          - targetCluster: {clusterNames: ["aws-tokyo"]}
            weight: 30

```

### OCM 的分发逻辑（显式分发）

```yaml
# OCM ManifestWork
apiVersion: work.open-cluster-management.io/v1
kind: ManifestWork
metadata:
  name: web-app-work
  namespace: cluster-region-1 # 对应特定子集群的 NS
spec:
  workload:
    manifests:
      - apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: my-web-app
        spec:
          replicas: 3
          # ... 原生定义

```

---

## 总结

1. **如果你追求极致的 K8s 原生体验**：首选 **Karmada**。它的架构最符合云原生趋势，且对于应用层面的调度支持最为精细。
2. **如果你在构建企业级 PaaS 平台**：建议以 **OCM** 作为底层组件，其模块化设计允许你像搭积木一样叠加监控、日志和安全插件。
3. **如果你面临 AI/大数据的大规模集群压测**：**KubeAdmiral** 在处理海量更新和 GPU 调度优化上，由于有字节跳动的背书，其性能上限更高。
4. **如果你只是想快速临时“借用”另一个集群的计算力**：用 **Liqo**。它不需要复杂的控制面初始化，两行命令即可打通。

