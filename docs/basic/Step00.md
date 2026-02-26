# Step00 – HPC & Azure CycleCloud 개념 이해

---

## 🎯 학습 목표

이 Step에서는 Azure에서 HPC 환경을 구축하기 전에 반드시 이해해야 하는 기본 개념을 학습합니다.

* HPC(High Performance Computing)의 구조 이해
* Scheduler(Slurm)의 역할 이해
* Azure CycleCloud가 어떤 문제를 해결하는지 이해
* Login Node / Scheduler Node / Compute Node 차이 이해

> 이 Step은 실습보다는 **이후 Step을 이해하기 위한 개념 기반 오리엔테이션**입니다.

---

# 1. HPC란 무엇인가?

HPC는 많은 CPU 또는 GPU를 동시에 사용하여 대규모 계산을 수행하는 환경을 의미합니다.

대표적인 HPC 워크로드:

* AI Training
* CFD / 시뮬레이션
* Rendering
* Monte Carlo 분석
* Genomics

일반 VM과 HPC의 가장 큰 차이:

| 일반 VM     | HPC              |
| --------- | ---------------- |
| 사람이 직접 실행 | Scheduler가 자원 할당 |
| 단일 서버 중심  | 클러스터 기반          |
| 수동 확장     | Job 기반 자동 확장     |

---

# 2. HPC에서 Scheduler가 필요한 이유

여러 사용자가 동시에 작업(Job)을 제출하면, 어떤 작업을 먼저 실행할지 결정해야 합니다.

Scheduler는 다음을 수행합니다.

* Job Queue 관리
* 사용 가능한 노드 할당
* 공정한 자원 분배
* 노드 상태 관리

이번 워크샵에서는 **Slurm**을 사용합니다.

---

## Slurm 핵심 용어

| 용어         | 설명           |
| ---------- | ------------ |
| Job        | 실행할 작업       |
| Node       | 계산용 VM       |
| Partition  | 노드 그룹        |
| Queue      | 대기열          |
| Controller | Scheduler 역할 |

대표 명령어 (Step04에서 사용):

```
sinfo   # 노드 상태
squeue  # Job 상태
srun    # 인터랙티브 실행
sbatch  # 배치 실행
```

---

# 3. Azure CycleCloud는 무엇인가?

Azure CycleCloud는 **HPC 클러스터 생성 및 관리 자동화 플랫폼**입니다.

많은 분들이 CycleCloud를 "HPC VM"으로 오해하지만 실제 역할은 다릅니다.

✔️ CycleCloud 역할:

* HPC 클러스터 템플릿 관리
* Slurm / PBS 등 Scheduler 통합
* Autoscale 트리거
* Azure 리소스 생성 자동화

❌ CycleCloud는:

* Compute Node가 아닙니다
* Scheduler 자체가 아닙니다

---

## CycleCloud 위치 (개념)

```
User Job 제출
      │
      ▼
+-------------------+
|   Slurm Scheduler |
+-------------------+
      │
      ▼
+-------------------+
|  Azure CycleCloud |
| (Cluster Manager) |
+-------------------+
      │
      ▼
Azure VM Compute Nodes
```

---

# 4. Azure HPC 아키텍처 구조

이번 워크샵에서 만들 구조는 아래와 같습니다.

```
                +----------------------+
                |   Azure CycleCloud   |
                |  (관리용 Control VM) |
                +----------+-----------+
                           |
                           |
                           v
        +---------------------------------------+
        |          Slurm HPC Cluster            |
        +---------------------------------------+
        |                                       |
        |  Login Node / Controller Node         |
        |          (Scheduler 역할)             |
        |                   │                   |
        |                   │ Job Queue         |
        |                   ▼                   |
        |        Dynamic Compute Nodes          |
        |       (Autoscale로 생성/삭제)          |
        +---------------------------------------+
                           |
                           v
                    Shared Storage
                   (Azure Files 등)
```

---

# 5. 노드 역할 이해 (매우 중요)

## 🔹 CycleCloud VM

* 클러스터 관리 서버
* Azure 리소스 생성 담당
* Scheduler 아님

## 🔹 Login Node (또는 Head Node)

* 사용자가 SSH 접속하는 VM
* Job 제출 위치

## 🔹 Scheduler Node (Controller)

* Job Queue 관리
* 노드 할당

※ 워크샵에서는 Login + Scheduler가 같은 VM일 수 있습니다.

## 🔹 Compute Node

* 실제 계산 수행
* Job이 있을 때만 생성될 수 있음 (Autoscale)

---

# 6. HPC vs HTC 차이

| 구분   | HPC              | HTC             |
| ---- | ---------------- | --------------- |
| 목적   | 빠른 계산            | 많은 작업           |
| 네트워크 | Low latency 중요   | 덜 중요            |
| 예시   | CFD, AI Training | Batch Rendering |

CycleCloud는 두 환경 모두 지원합니다.

---

# 7. 이번 워크샵에서 배우게 될 핵심 흐름

이후 Step에서 다음 흐름을 직접 확인하게 됩니다.

```
1) Job 제출
2) Scheduler가 Queue 확인
3) CycleCloud가 VM 생성 요청
4) Azure에서 Compute Node 생성
5) Job 실행
6) Idle 상태 → Node 자동 삭제
```

👉 이것이 Azure HPC의 가장 중요한 개념입니다.

---

# ✔️ Step00 완료 체크

다음 질문에 답할 수 있다면 준비 완료입니다.

* CycleCloud는 Scheduler인가?
* Login Node와 Compute Node 차이는?
* Job Queue가 필요한 이유는?
* Autoscale은 누가 트리거하는가?

---

# ➡️ 다음 Step

Step01에서는 실제 Azure Portal에서 다음을 준비합니다.

* Resource Group
* VNet / Subnet
* Shared Storage

이제부터 실제 HPC 환경을 Azure에 구축하기 시작합니다.