# Step03 – Slurm HPC Cluster 생성

---

## 🎯 학습 목표

이번 Step에서는 Azure CycleCloud를 이용하여
**Slurm 기반 HPC Cluster**를 실제로 생성합니다.

이 단계가 끝나면:

* Login Node (Head Node)
* Scheduler(Controller)
* Autoscale 가능한 Compute Node 구조

가 Azure 상에 구성됩니다.

학습 내용:

* CycleCloud Template 개념
* Slurm Cluster 구성 요소 이해
* Partition 및 Node Type 설정
* Autoscale 기본 구조 이해

---

# 1. Slurm Cluster 구조 다시 보기

이번 Step에서 만들 구조는 다음과 같습니다.

```id="o0r77h"
CycleCloud
   │
   ▼
+----------------------------+
|     Slurm HPC Cluster      |
+----------------------------+
| Login / Controller Node    |
|            │               |
|            ▼               |
|      Compute Nodes         |
|   (Autoscale 대상 VM)       |
+----------------------------+
```

---

# 2. CycleCloud UI에서 Cluster 생성 시작

1. CycleCloud Web Portal 접속
2. 상단 메뉴 → **Clusters**
3. **Create Cluster** 선택

---

# 3. Template 선택

Template 목록에서:

```id="qu4a3m"
Slurm
```

선택

설명:

* Slurm Template은 Scheduler + Node 구성을 자동 생성합니다.
* ARM/Bicep을 직접 작성하지 않아도 됩니다.

Next 클릭

---

# 4. Cluster 기본 설정

## 🧾 General Settings

| 항목             | 값 (예시)                |
| -------------- | --------------------- |
| Cluster Name   | slurm-hpc-lab         |
| Region         | Korea Central         |
| Resource Group | rg-cyclecloud-hpc-lab |

---

## 🌐 Network 설정

| 항목              | 값               |
| --------------- | --------------- |
| Virtual Network | vnet-hpc-lab    |
| Subnet          | snet-management |

Login/Controller Node는 Management Subnet에 위치합니다.

---

# 5. Node 구성 이해

Slurm Template에는 여러 Node Type이 존재합니다.

## 🔹 Scheduler / Login Node

역할:

* SSH 접속 위치
* Job 제출
* Queue 관리

권장 VM Size:

```id="oxcazr"
Standard_D2as_v5
```

---

## 🔹 Compute Node (가장 중요)

실제 계산을 수행하는 노드입니다.

설정 예시:

```id="r2tzkl"
VM Size: Standard_D4as_v5
Min Nodes: 0
Max Nodes: 4
```

📌 Min=0 설정 이유:

* Autoscale 동작을 눈으로 확인하기 위함
* Job이 있을 때만 VM 생성

---

# 6. Partition 개념 이해

Slurm에서는 Compute Node를 Partition으로 그룹화합니다.

예:

```id="k15i04"
partition = compute
```

역할:

* Job이 어느 노드에서 실행될지 결정
* 향후 GPU/CPU 분리 가능

이번 워크샵에서는:

```id="3m7d52"
compute partition 하나만 사용
```

---

# 7. Shared Storage 연결

Step01에서 만든 Azure Files가 자동 마운트될 수 있습니다.

CycleCloud Template 기본 설정:

```id="o3bgcf"
/shared
/home
```

모든 노드가 동일한 파일시스템을 보게 됩니다.

---

# 8. Cluster 생성 실행

설정 완료 후:

1. Save 클릭
2. Start 클릭

Cluster 상태가 다음 단계로 진행됩니다.

```id="eqzvfd"
Starting → Provisioning → Running
```

⏱️ 약 10~15분 소요

---

# 9. Azure Portal에서 확인되는 리소스

Cluster 생성이 시작되면 Azure Portal에서:

* Login Node VM 생성
* NIC / Disk 자동 생성

아직 Compute Node는 생성되지 않습니다.

왜냐하면:

```id="br93rm"
Min Nodes = 0
```

이기 때문입니다.

---

# 10. Cluster 상태 확인

CycleCloud UI → Clusters 화면에서:

확인 사항:

* slurm-hpc-lab 상태 = Running
* Login Node IP 표시

---

# ✔️ Step03 완료 체크리스트

* [ ] Slurm Template 선택
* [ ] Cluster Name 설정 완료
* [ ] Compute Node Min=0 설정
* [ ] Cluster 상태 Running 확인
* [ ] Login Node 생성 확인

---

# 🧠 지금까지의 흐름 요약

```id="1ycsci"
Step01: Azure 인프라 준비
Step02: CycleCloud 배포
Step03: Slurm Cluster 생성 완료
```

아직 Compute Node는 존재하지 않습니다.

다음 Step에서 Job을 제출하면
CycleCloud가 자동으로 VM을 생성하게 됩니다.

---

# ➡️ 다음 Step

Step04에서는 Login Node에 SSH 접속하여

* sinfo
* squeue
* srun
* sbatch

명령을 사용해 실제 HPC Job을 실행합니다.

이제 Scheduler가 실제로 동작하는 것을 확인하게 됩니다.
