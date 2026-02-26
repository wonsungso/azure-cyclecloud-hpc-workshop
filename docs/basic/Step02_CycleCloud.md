# Step02 – Azure CycleCloud Deployment & 초기 설정

모듈 설명: Azure CycleCloud를 배포하고 초기 접속 및 기본 설정을 확인합니다.

---

## 학습 목표

이번 Step에서는 Azure HPC 환경의 핵심 관리 컴포넌트인 **Azure CycleCloud**를 배포합니다.

이 단계가 끝나면:

* CycleCloud Web Portal 접속 가능
* Azure 리소스를 생성할 권한을 가진 Control Plane 준비 완료

학습 내용:

* Azure CycleCloud 역할 이해
* Marketplace 기반 배포
* 네트워크 연결 구조 이해
* CycleCloud VM과 Login Node의 차이 이해

---

# 1️⃣ Azure CycleCloud 역할 다시 이해하기

혼동이 발생하기 쉬운 영역이므로 다시 정리합니다.

CycleCloud는:

* HPC 클러스터 생성 관리자
* Scheduler와 Azure 사이 orchestration 수행
* Autoscale 트리거

CycleCloud는 다음 역할이 아닙니다:

* Compute Node 아님
* Slurm Scheduler 아님
* Job 실행 서버 아님

---

## 이번 워크샵에서의 위치

```text
User
 │
 ▼
CycleCloud (관리 서버)
 │
 ▼
Slurm Cluster (다음 Step에서 생성)
```

---

# 2️⃣ Azure CycleCloud 배포 (Portal)

## Marketplace에서 생성

1️⃣ Azure Portal 상단 검색창
2️⃣ **CycleCloud** 검색
3️⃣ **Azure CycleCloud** 선택
4️⃣ Create 클릭

---

## Basics 설정

| 항목             | 값 (예시)                |
| -------------- | --------------------- |
| Resource Group | rg-cyclecloud-hpc-lab |
| VM Name        | cc-hpc-lab            |
| Region         | Korea Central         |
| Authentication | Password 또는 SSH Key   |

> 워크샵에서는 실습 진행 효율을 위해 Password 방식 사용을 권장합니다.

---

## VM Size 선택

추천 (CPU 기반 워크샵):

```text
Standard_D2as_v5
```

CycleCloud는 Control Plane이므로
고성능 VM이 필요하지 않습니다.

---

# 3️⃣ Networking 설정

## 매우 중요

Step01에서 만든 VNet을 사용합니다.

| 항목              | 값               |
| --------------- | --------------- |
| Virtual Network | vnet-hpc-lab    |
| Subnet          | snet-management |

---

## Public IP 설정

워크샵에서는 접속 편의를 위해:

```text
Public IP: Enabled
```

실제 운영 환경에서는 Bastion 또는 Private 접근을 권장합니다.

---

# 4️⃣ Identity (권한) 개념

CycleCloud는 Azure VM을 대신 생성해야 합니다.

따라서:

Managed Identity 또는 Service Principal 권한 필요

워크샵에서는:

```text
System Assigned Managed Identity 사용
```

생성 후 다음 Step에서 Slurm 클러스터 생성 시
Azure 리소스 생성 권한을 사용하게 됩니다.

---

# 5️⃣ Review + Create

설정 확인 후:

* Review + Create
* Create 클릭

배포 시간:

약 5~8분

---

# 6️⃣ CycleCloud Web Portal 접속

배포 완료 후:

1️⃣ 생성된 VM 리소스 이동
2️⃣ Public IP 확인
3️⃣ 브라우저에서 접속

```text
https://<Public-IP>
```

---

## 첫 로그인

VM 생성 시 설정한:

* Username
* Password

입력

처음 접속 시:

* Self-signed 인증서 경고가 나타날 수 있음
* Continue 진행

---

# 7️⃣ CycleCloud 초기 화면 이해

접속 후 확인할 수 있는 주요 메뉴:

| 메뉴        | 설명             |
| --------- | -------------- |
| Clusters  | HPC Cluster 관리 |
| Templates | Slurm/PBS 템플릿  |
| Settings  | Azure 연동 설정    |
| Nodes     | 현재 생성된 VM 상태   |

현재 상태:

```text
아직 Cluster 없음 (정상)
```

다음 Step에서 Slurm Cluster를 생성합니다.

---

# 8️⃣ 네트워크 구조 현재 상태

지금까지 구성된 Azure 리소스 흐름:

```text
Resource Group
 ├─ VNet (vnet-hpc-lab)
 │   ├─ snet-management
 │   │   └─ CycleCloud VM
 │   └─ snet-compute (비어있음)
 └─ Storage Account (Shared Files)
```

Compute Node는 아직 존재하지 않습니다.

---

# Step02 완료 체크리스트

* [v] CycleCloud VM 배포 완료
* [v] Public IP 확인
* [v] 브라우저 접속 성공
* [v] CycleCloud UI 확인
* [v] Cluster 목록이 비어있는 상태 확인

---

# 다음 Step

Step03에서는 CycleCloud UI를 이용하여
**Slurm 기반 HPC Cluster**를 실제로 생성합니다.

다음 단계부터 Scheduler와 Compute Node가 포함된 구성을 다룹니다.
