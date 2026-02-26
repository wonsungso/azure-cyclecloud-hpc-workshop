# Step04 – JobRun

---

## 학습 목표

이번 Step에서는 Slurm HPC Cluster에 실제 Job을 제출하고
Scheduler가 어떻게 동작하는지 직접 확인합니다.

이 단계가 끝나면:

* Login Node SSH 접속 가능
* Slurm 기본 명령어 이해
* Job Queue → Resource Allocation 흐름 이해
* Autoscale이 언제 트리거되는지 확인 준비 완료

---

# 1. HPC Job 흐름 다시 이해하기

지금까지 만든 구조에서 Job 실행 흐름은 다음과 같습니다.

```text
User SSH 접속
      │
      ▼
Login Node
      │
      ▼
Slurm Scheduler
      │
      ▼
Compute Node (필요 시 생성)
```

현재 상태:

```text
Compute Node = 0
```

아직 VM이 생성되지 않은 상태입니다.

---

# 2. Login Node SSH 접속

## Azure Portal에서 IP 확인

1. CycleCloud UI → Cluster → Login Node 확인
   또는
2. Azure Portal → VM 목록 → Login Node 선택

Public IP 확인 후 접속:

```bash
ssh <username>@<LoginNodePublicIP>
```

---

## 접속 확인

로그인 후 다음 프롬프트 확인:

```text
[azureuser@login-node ~]$
```

---

# 3. Slurm 상태 확인

먼저 Scheduler 상태를 확인합니다.

---

## 노드 상태 확인

```bash
sinfo
```

예상 결과:

```text
PARTITION AVAIL  TIMELIMIT  NODES  STATE
compute   up     infinite      0   idle
```

설명:

* 아직 Compute Node가 없기 때문에 0으로 표시됩니다.

---

## Job Queue 확인

```bash
squeue
```

현재는 비어 있는 상태가 예상 결과입니다.

---

# 4. 첫 번째 테스트 Job 실행 (srun)

간단한 테스트로 CPU Job을 실행합니다.

```bash
srun hostname
```

### 예상 동작

1. Scheduler가 실행 요청 감지
2. Compute Node 필요 판단
3. CycleCloud가 Azure VM 생성 요청
4. Compute Node 부팅 후 Job 실행

---

# 5. Azure Portal에서 Autoscale 확인

Job 실행 후 몇 분 내:

Azure Portal → Virtual Machines 이동

다음 VM이 생성되는 것을 확인할 수 있습니다.

```text
compute-xxxx
```

이것이 CycleCloud Autoscale입니다.

---

# 6. Job 실행 결과 확인

Job 완료 후 콘솔 출력 예시:

```text
compute-0
```

이는 Job이 Compute Node에서 실행되었다는 의미입니다.

---

# 7. 배치 Job 실행 (sbatch)

이번에는 Batch 방식으로 실행합니다.

---

## 샘플 Job Script 생성

복사/붙여넣기 대신 저장소의 샘플 스크립트를 그대로 사용하려면(권장), **로컬 저장소 루트**에서 아래 명령으로 업로드할 수 있습니다.

```bash
scp scripts/test-job.sh <username>@<LoginNodePublicIP>:~/
```

Login Node에서 확인:

```bash
ls -l ~/test-job.sh
```

또는 아래처럼 직접 생성해도 됩니다.

```bash
nano test-job.sh
```

내용 입력:

```bash
#!/bin/bash
#SBATCH --job-name=test
#SBATCH --output=output.txt

hostname
sleep 30
```

저장 후 종료

---

## Job 제출

```bash
sbatch test-job.sh
```

출력 예시:

```text
Submitted batch job 1
```

---

## Queue 상태 확인

```bash
squeue
```

상태 예시:

```text
JOBID PARTITION NAME USER ST TIME NODES NODELIST
1 compute test azureuser R 0:02 1 compute-0
```

---

# 8. HPC Scheduler 동작 정리

지금까지 발생한 일:

```text
1) User가 Job 제출
2) Slurm Scheduler가 Queue 생성
3) Compute Node 부족 감지
4) CycleCloud가 Azure VM 생성
5) Job 실행
```

즉,

Scheduler가 Autoscale을 간접적으로 트리거합니다.

---

# Step04 완료 체크리스트

* [ ] Login Node SSH 접속 성공
* [ ] sinfo 명령 실행 확인
* [ ] srun hostname 실행
* [ ] Compute Node 생성 확인
* [ ] sbatch Job 실행 성공
* [ ] squeue 상태 확인

---

# 다음 Step

Step05에서는:

* Compute Node 최소값 0 유지
* 여러 Job 제출
* Idle 상태 관찰

을 통해 Azure HPC Autoscale 동작을 완전히 이해합니다.

그리고 마지막에 Resource Group 정리를 진행합니다.
