# Step05 – Autoscale 체험 및 리소스 정리

---

## 🎯 학습 목표

이번 Step에서는 Azure CycleCloud와 Slurm Scheduler가 함께 동작하면서
**Compute Node가 자동으로 생성되고 삭제되는 Autoscale 과정**을 확인합니다.

이 단계가 끝나면:

* Queue 기반 Autoscale 동작 원리 이해
* Idle 상태에서 Scale-in 확인
* Azure HPC 비용 구조 감각 이해
* 워크샵 리소스 안전하게 정리

---

# 1. Autoscale 개념 다시 이해하기

Azure HPC에서 Autoscale은 다음 흐름으로 동작합니다.

```id="l9w5hx"
Job Queue 증가
      │
      ▼
Slurm Scheduler 판단
      │
      ▼
CycleCloud Autoscale Trigger
      │
      ▼
Azure VM Compute Node 생성
```

반대로 Job이 끝나면:

```id="flbexh"
Idle Node 발생
      │
      ▼
Idle Timeout 도달
      │
      ▼
Compute Node 자동 삭제
```

---

# 2. 현재 상태 확인

Login Node에서 먼저 상태를 확인합니다.

```bash id="x3z0pi"
sinfo
```

현재 최소 1개의 Compute Node가 존재할 수 있습니다.

---

# 3. Autoscale 테스트 준비

이번 실습에서는 동시에 여러 Job을 제출하여
추가 Compute Node가 생성되는 것을 관찰합니다.

---

## 🔧 테스트용 Job Script 생성

```bash id="z0rc8r"
nano autoscale-test.sh
```

내용 입력:

```bash id="u4c2po"
#!/bin/bash
#SBATCH --job-name=scale-test
#SBATCH --output=scale-output.txt

hostname
sleep 120
```

저장 후 종료

---

# 4. 여러 Job 제출

다음 명령을 반복 실행합니다.

```bash id="jwlf8j"
sbatch autoscale-test.sh
sbatch autoscale-test.sh
sbatch autoscale-test.sh
sbatch autoscale-test.sh
```

---

## 🔎 Queue 상태 확인

```bash id="duoyy4"
squeue
```

예상 상태:

```id="kk6q6q"
JOBID PARTITION NAME USER ST
1 compute scale-test R
2 compute scale-test R
3 compute scale-test PD
4 compute scale-test PD
```

설명:

* R = Running
* PD = Pending (노드 부족 상태)

---

# 5. Azure Portal에서 Autoscale 관찰

Azure Portal → Virtual Machines 이동

몇 분 후:

```id="o0ax7k"
compute-0
compute-1
compute-2
...
```

와 같이 새로운 VM이 생성되는 것을 확인할 수 있습니다.

📌 이것이 CycleCloud Autoscale입니다.

---

# 6. Job 완료 후 Scale-in 관찰

약 2~3분 후 Job이 종료되면:

```bash id="rf8zz0"
squeue
```

결과:

```id="x0evux"
(no jobs)
```

이후 Idle 시간이 지나면:

Azure Portal에서 Compute Node VM이 자동 삭제됩니다.

⏱️ Idle timeout은 Template 설정에 따라 다릅니다.

---

# 7. Autoscale 동작 핵심 요약

이번 실습에서 확인한 흐름:

```id="u92p7r"
1) Job 제출 증가
2) Queue 대기 발생
3) CycleCloud가 Compute VM 생성
4) Job 실행
5) Idle 상태
6) Compute VM 자동 삭제
```

즉,

👉 Azure HPC는 "필요할 때만 VM을 생성"합니다.

---

# 8. Azure HPC 비용 관점 이해

비용이 발생하는 주요 리소스:

| 리소스             | 설명             |
| --------------- | -------------- |
| Compute Node VM | Job 실행 중 비용 발생 |
| Login Node VM   | 항상 실행 중        |
| CycleCloud VM   | Control Plane  |
| Disk / Storage  | 지속 과금          |

Autoscale을 사용하면:

✔️ Job이 없을 때 Compute 비용 최소화 가능

---

# 9. 워크샵 리소스 정리 (매우 중요)

워크샵 종료 시 반드시 리소스를 정리합니다.

---

## 🔧 Step 1 – Slurm Cluster Stop

CycleCloud UI → Clusters

```id="y5q8t4"
slurm-hpc-lab → Stop
```

---

## 🔧 Step 2 – CycleCloud VM Stop

Azure Portal → Virtual Machines

```id="k8vlx4"
cc-hpc-lab → Stop
```

---

## 🔧 Step 3 – Resource Group 삭제

Azure Portal → Resource Groups

```id="5o0d1g"
rg-cyclecloud-hpc-lab → Delete
```

이 작업으로:

* Login Node
* Compute Node
* CycleCloud
* Storage
* Network

모든 리소스가 삭제됩니다.

---

# ✔️ Step05 완료 체크리스트

* [ ] 여러 Job 제출 성공
* [ ] Compute Node 자동 생성 확인
* [ ] Job 종료 후 Scale-in 확인
* [ ] Slurm Cluster Stop
* [ ] CycleCloud Stop
* [ ] Resource Group 삭제

---

# 🎉 Workshop 완료

지금까지 다음 내용을 경험했습니다.

```id="7hmcl2"
Azure Portal 기반 HPC 환경 구축
CycleCloud Control Plane 이해
Slurm Scheduler 동작 이해
Queue 기반 Autoscale 체험
```

이제 Azure CycleCloud와 HPC 기본 흐름을 직접 구성하고
Autoscale 동작까지 확인할 수 있는 상태입니다.
