# Step01 – Infra

---

## 학습 목표

이번 Step에서는 Azure CycleCloud와 Slurm HPC 클러스터를 배포하기 전에 필요한 **기본 Azure 인프라**를 준비합니다.

이 단계에서 구성하는 리소스는 이후 모든 HPC 노드가 배치될 기반이 됩니다.

학습 내용:

* Resource Group 생성 및 네이밍 전략 이해
* HPC 관점에서 VNet / Subnet 구조 이해
* Shared Storage 개념 및 Azure Files 준비
* Public 접근 최소화 설계 이해

---

# 1️⃣ 전체 아키텍처에서 Step01 위치

이번 Step은 아래 구조에서 **기초 인프라 레이어**를 만드는 과정입니다.

```
Azure Subscription
 └─ Resource Group
     ├─ VNet / Subnet
     ├─ Shared Storage
     └─ (다음 Step) CycleCloud VM
```

---

# 2️⃣ Resource Group 생성

## Resource Group이 중요한 이유

HPC 환경은 VM이 동적으로 생성/삭제되므로
모든 리소스를 하나의 RG에 배치하면 관리 및 삭제 효율이 향상됩니다.

특히 워크샵에서는:

마지막 Step에서 RG 삭제 = 전체 리소스 정리

---

## Azure Portal 생성 절차

1️⃣ Azure Portal 접속
2️⃣ 상단 검색창 → **Resource Groups**
3️⃣ **Create** 선택

설정 값:

| 항목                  | 값 (예시)                      |
| ------------------- | --------------------------- |
| Subscription        | 사용중인 구독                     |
| Resource Group Name | rg-cyclecloud-hpc-lab       |
| Region              | Korea Central (또는 사용 가능 리전) |

4️⃣ Review + Create → Create

---

## 완료 확인

Resource Group 목록에서 다음 확인:

* rg-cyclecloud-hpc-lab 생성 완료

---

# 3️⃣ Virtual Network 및 Subnet 구성

## HPC에서 Network가 중요한 이유

일반 VM과 달리 HPC는 노드 간 통신이 많습니다.

* Job 실행 시 Node 간 데이터 교환
* Shared Storage 접근
* Scheduler 통신

따라서 기본적으로 Subnet을 분리합니다.

---

## 이번 워크샵 네트워크 구조

| Subnet          | 역할                      |
| --------------- | ----------------------- |
| snet-management | CycleCloud / Login Node |
| snet-compute    | Compute Nodes           |

---

## VNet 생성 절차

1️⃣ Azure Portal 검색 → **Virtual Network**
2️⃣ Create 선택

### Basics

| 항목     | 값                  |
| ------ | ------------------ |
| Name   | vnet-hpc-lab       |
| Region | Resource Group과 동일 |

### IP Address

| 항목            | 값            |
| ------------- | ------------ |
| Address Space | 10.10.0.0/16 |

### Subnet 추가

#### 1️⃣ Management Subnet

```
Name: snet-management
Address range: 10.10.1.0/24
```

#### 2️⃣ Compute Subnet

```
Name: snet-compute
Address range: 10.10.2.0/24
```

Create 클릭

---

## 완료 확인

Virtual Network → Subnets 탭에서:

* snet-management
* snet-compute

두 개 존재 확인

---

# 4️⃣ NSG (Network Security Group) 개념

이번 워크샵에서는 최소 구성만 사용합니다.

## 왜 Public 접근을 최소화하는가?

HPC 환경은 보통 내부 네트워크 중심으로 동작합니다.

* Compute Node는 Public IP 불필요
* Login Node만 SSH 허용

이번 Step에서는 NSG 생성만 이해하고
실제 연결은 다음 Step에서 진행합니다.

---

# 5️⃣ Shared Storage 준비 (Azure Files)

## HPC에서 Shared Storage가 필요한 이유

모든 노드가 동일한 데이터를 보아야 합니다.

예:

* 사용자 Home 디렉터리
* Job Script
* Output 파일

대표 구조:

```
/home
/shared
```

---

## Storage Account 생성

1️⃣ Azure Portal → **Storage Accounts**
2️⃣ Create 선택

### Basics

| 항목                   | 값 (예시)      |
| -------------------- | ----------- |
| Storage Account Name | sthpclab001 |
| Region               | RG와 동일      |
| Performance          | Standard    |
| Redundancy           | LRS         |

Create 클릭

---

## File Share 생성

Storage Account 생성 후:

1️⃣ 좌측 메뉴 → **File shares**
2️⃣ * File share 선택

설정:

```
Name: shared
Quota: 100 GiB (워크샵 기준)
```

Create 클릭

---

## 완료 확인

File Share 목록에:

```
shared
```

존재 확인

---

# 6️⃣ HPC 관점에서 지금 만든 리소스 역할 정리

| 리소스               | HPC 역할                 |
| ----------------- | ---------------------- |
| Resource Group    | 전체 클러스터 컨테이너           |
| VNet              | HPC 네트워크               |
| Management Subnet | Login / CycleCloud 위치  |
| Compute Subnet    | Autoscale Compute Node |
| Azure Files       | Shared filesystem      |

---

# Step01 완료 체크리스트

다음 항목이 모두 준비되었는지 확인합니다.

* [ ] Resource Group 생성 완료
* [ ] Virtual Network 생성 완료
* [ ] snet-management 생성
* [ ] snet-compute 생성
* [ ] Storage Account 생성
* [ ] File Share(shared) 생성

---

# 다음 Step

Step02에서는 Azure Marketplace를 이용하여
**Azure CycleCloud VM을 배포**하고 Web UI에 접속합니다.

다음 단계에서 실제 HPC Control Plane 구축을 시작합니다.
