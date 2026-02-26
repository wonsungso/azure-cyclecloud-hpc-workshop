# Azure CycleCloud + Slurm HPC Workshop (L200–L300)

Azure Portal 기준으로 **Azure CycleCloud와 Slurm 기반 HPC 클러스터**를 구축하고,
Autoscale 동작부터 Template Customizing, Application Deployment까지 단계적으로 학습하는 Hands-on Workshop입니다.

이 저장소는 HPC 또는 CycleCloud 경험이 없는 사용자도 따라갈 수 있도록
**Concept → Infra → Cluster → Job → Autoscale → Advanced 확장** 흐름으로 구성되어 있습니다.

---

# Workshop 개요

## 목표

이 워크샵을 통해 다음을 직접 경험할 수 있습니다.

* Azure CycleCloud Control Plane 이해
* Slurm Scheduler 기반 HPC Job 흐름
* Queue 기반 Autoscale 동작
* Shared Storage 기반 Application 실행 구조
* Template Customizing (Advanced)

---

## Architecture (개념 구조)

본 워크샵에서는 다음과 같은 Azure HPC 구조를 구성합니다.

* Azure CycleCloud (Cluster Control Plane)
* Slurm Login / Controller Node
* Dynamic Compute Nodes (Autoscale)
* Azure Files Shared Storage
* VNet 기반 내부 통신

---

# Workshop Tracks

이 저장소는 세 가지 난이도로 구성됩니다.

---

## Core Workshop (L200 – Portal First)

Azure Portal 기준으로 HPC 환경을 처음부터 구축하며
Autoscale 흐름을 이해하는 기본 과정입니다.

### Steps

* Step00 – HPC 기본 개념 이해 & Azure CycleCloud 역할 구조
* Step01 – Azure Infra 구성 (Resource Group / Network / Storage)
* Step02 – Azure CycleCloud Deployment & 초기 설정
* Step03 – Slurm Cluster 생성 & 기본 노드 구성 확인
* Step04 – Job 실행 & Slurm Scheduler 동작 이해
* Step05 – Queue 기반 Autoscale 체험 & 리소스 정리

`docs/` 폴더에서 진행

```
docs/01-basic/
 Step00_Concept.md
 Step01_Infra.md
 Step02_CycleCloud.md
 Step03_SlurmCluster.md
 Step04_JobRun.md
 Step05_Autoscale.md
```

---

## Advanced Workshop (L250)

CycleCloud Tutorials 내용을 Portal 중심 워크샵에 맞게 재구성한 Advanced 과정입니다.

다음 개념을 다룹니다.

* Slurm Template 구조 이해
* Nodearray / Partition 심화
* Shared Storage 기반 Application Deployment

### Steps

* Step06 – Slurm Template 구조 이해 & Nodearray / Partition 심화
* Step07 – Shared Storage 기반 Application Deployment

`docs/02-advanced/` 폴더에서 진행

```
docs/02-advanced/
 Step06_Template.md
 Step07_AppDeploy.md
```

---

## GPU Extension (L300 – Optional)

GPU Container 워크로드 및 멀티노드 통신 검증까지 다루는 확장 과정입니다.

다음 개념을 다룹니다.

* NGC + Enroot/Pyxis 기반 Slurm 컨테이너 실행
* sbatch 기반 멀티노드 NCCL all-reduce 검증

### Steps

* Step08 – NGC + Enroot/Pyxis 기반 GPU Container Job

Step08 실습용 샘플 스크립트:

* `scripts/nccl-allreduce.sbatch` (sbatch 기반 멀티노드 GPU 통신 검증 예제)

`docs/02-advanced/` 폴더의 Optional 확장 단계

```
docs/02-advanced/
 Step08_NGC_Enroot.md
```

---

# Prerequisites

워크샵 시작 전에 다음을 준비해주세요.

* Azure Subscription
* VM 생성 권한 (Contributor 이상 권장)
* 최소 8~16 vCPU Compute Quota
* SSH Client (Windows Terminal / WSL / Mac Terminal)

권장 VM Size:

```
Standard_D2as_v5 (CycleCloud / Login Node)
Standard_D4as_v5 (Compute Node)
```

---

# Repository Structure

```
azure-cyclecloud-hpc-workshop/
│
├── docs/
│   ├── 01-basic/     # Core Workshop (L200)
│   ├── 02-advanced/  # Advanced (L250) + GPU Extension (L300)
│   └── 99-images/    # Architecture & Diagram
└── scripts/       # Sample Job Scripts
```

---

# Quick Start

1️⃣ `docs/01-basic/Step00_Concept.md`부터 순서대로 진행합니다.
2️⃣ Step05까지 완료하면 기본 HPC Autoscale 흐름을 이해하게 됩니다.
3️⃣ 심화 학습은 Step06~07(L250)로 진행하세요.
4️⃣ GPU 컨테이너 확장이 필요하면 Step08(L300 Optional)을 진행하세요.

---

# Notes

* 본 워크샵은 학습 목적이며 Production Best Practice를 모두 포함하지 않습니다.

* 실제 운영 환경에서는 다음 구성을 권장합니다.

  * Private Endpoint
  * Azure Bastion
  * RBAC 최소 권한
  * NAT Gateway

* GPU Cluster 및 Container HPC는 L300 Optional 확장 영역입니다.

---

# Cleanup (중요)

워크샵 종료 후 반드시 다음을 수행하세요.

1️⃣ Slurm Cluster Stop
2️⃣ CycleCloud VM Stop
3️⃣ Resource Group Delete

리소스를 삭제하지 않으면 비용이 발생할 수 있습니다.

---