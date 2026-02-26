# Step07 – HPC Application Deployment & Job 실행 (Advanced)

---

## 🎯 학습 목표

이번 Advanced Step에서는 Slurm HPC Cluster 위에 **실제 애플리케이션 형태의 워크로드**를 실행합니다.

기본 워크샵에서는 `hostname`, `sleep` 같은 단순 테스트를 실행했다면,
이번 Step에서는 **Shared Storage 기반 Application 실행 흐름**을 이해하는 것이 핵심입니다.

이 단계에서 배우게 되는 내용:

* HPC 환경에서 Application 배치 방식 이해
* Shared Storage(`/shared`) 활용 방법
* sbatch를 통한 실제 workload 실행 흐름
* Cluster Template과 Application Stack의 관계 이해

> ⚠️ Production용 HPC Application 설치가 아니라, 구조 이해를 위한 Lightweight 예제입니다.

---

# 1. HPC 환경에서 Application이 실행되는 방식

일반 VM과 HPC의 가장 큰 차이:

```id="m7bz6r"
Application은 개별 VM이 아니라
Cluster Shared Storage 위에 위치합니다.
```

흐름:

```id="e0cb1k"
Application 설치 (/shared/app)
        │
        ▼
User가 sbatch 실행
        │
        ▼
Scheduler가 Compute Node 할당
        │
        ▼
Compute Node가 Shared Storage에서 실행
```

즉,

👉 Compute Node는 Stateless하게 동작합니다.

---

# 2. Shared Storage 확인

먼저 Login Node에서 Shared Storage가 마운트되어 있는지 확인합니다.

```bash id="ra7n1q"
df -h
```

예상 출력:

```id="q0gj76"
/shared
```

경로가 보이면 정상입니다.

---

# 3. Sample HPC Application 준비

이번 실습에서는 Lightweight Application으로
**CPU 병렬 테스트 스크립트**를 사용합니다.

---

## 🔧 Application 디렉터리 생성

```bash id="wyx2tb"
mkdir -p /shared/apps/sample-app
cd /shared/apps/sample-app
```

---

## 🔧 실행 스크립트 생성

```bash id="yd5z7f"
nano run-app.sh
```

내용 입력:

```bash id="vt8v2v"
#!/bin/bash

echo "Running HPC Sample Application"
hostname
sleep 60
echo "Job Completed"
```

저장 후 종료

---

## 🔧 실행 권한 부여

```bash id="g3v7i4"
chmod +x run-app.sh
```

---

# 4. Slurm Job Script 작성

Application을 Scheduler에 제출하기 위한 sbatch 스크립트를 생성합니다.

```bash id="f0yz78"
nano app-job.sh
```

내용 입력:

```bash id="czp4fd"
#!/bin/bash
#SBATCH --job-name=app-test
#SBATCH --output=app-output.txt

/shared/apps/sample-app/run-app.sh
```

저장 후 종료

---

# 5. Application Job 실행

```bash id="j6h8cz"
sbatch app-job.sh
```

출력 예시:

```id="i3c42o"
Submitted batch job 2
```

---

## 🔎 Queue 상태 확인

```bash id="sm8snk"
squeue
```

예상 상태:

```id="g2fn3b"
JOBID PARTITION NAME USER ST TIME NODES NODELIST
2 compute app-test R 0:03 1 compute-1
```

---

# 6. Application 실행 결과 확인

Job 완료 후:

```bash id="x3v3kq"
cat app-output.txt
```

예상 출력:

```id="rbh8ui"
Running HPC Sample Application
compute-1
Job Completed
```

이 결과는:

👉 Application이 Compute Node에서 실행되었음을 의미합니다.

---

# 7. HPC Application Deployment 구조 이해 (Tutorials 기반)

이번 Step에서 사용한 구조는 실제 HPC 환경과 매우 유사합니다.

```id="l4nv1s"
/shared/apps/
        ├── lammps
        ├── mpi-test
        └── sample-app
```

특징:

* Login Node에서 한 번 설치
* 모든 Compute Node에서 동일하게 실행

즉,

👉 Template보다 Application Stack은 Storage에 위치합니다.

---

# 8. Container 기반 HPC (개념 소개 – Optional)

cyclecloud_tutorials에서는 Container 기반 Job도 소개됩니다.

예:

```id="b3kklk"
srun --container-image=<image>
```

이번 워크샵에서는 실행하지 않지만,
Production HPC에서는 다음 장점이 있습니다.

* Dependency 관리 단순화
* 동일 환경 재현
* AI/ML 워크로드에 적합

---

# 9. Advanced 흐름 정리

지금까지 Advanced Step에서 배운 내용:

```id="l8tsm6"
Step06 – Template 구조 이해
Step07 – Application Deployment 흐름 이해
```

즉,

👉 Cluster 구조 + 실제 Application 실행
두 가지를 모두 경험했습니다.

---

# ✔️ Step07 완료 체크리스트

* [ ] /shared/apps 디렉터리 생성
* [ ] run-app.sh 생성 및 실행 권한 부여
* [ ] app-job.sh 생성
* [ ] sbatch 실행 성공
* [ ] Compute Node에서 Application 실행 확인
* [ ] output 파일 확인

---

# 🎉 Advanced Workshop 완료

이제 다음 내용을 모두 경험했습니다.

```id="yruq8a"
Portal 기반 HPC Cluster 구축
Slurm Autoscale 이해
Template Customizing
Shared Storage 기반 Application 실행
```

이 단계까지 완료했다면 Azure CycleCloud + Slurm HPC 환경의
기본 구성부터 Advanced 개념까지 이해한 상태입니다.
