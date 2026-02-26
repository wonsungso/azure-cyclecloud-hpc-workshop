# Step08 – NGC + Enroot/Pyxis 기반 GPU Container Job (Optional)

모듈 설명: CycleCloud + Slurm 환경에서 NGC 컨테이너 워크로드를 실행하는 **Optional 확장 실습**입니다.

---

## 학습 목표

이 Step에서는 다음을 이해하고 검증합니다.

* CycleCloud + Slurm 환경에서 GPU 컨테이너 워크로드 실행 흐름
* Enroot/Pyxis를 통한 Slurm 컨테이너 실행 방식
* NGC 컨테이너 이미지 import/create/run 기본 절차
* 운영 전 버전/호환성 점검 포인트

> 이 문서는 워크샵 실습 목적에 맞춘 최소 구성 절차를 제공합니다.

---

## 1️⃣ 실습 범위

이번 Step의 핵심은 다음 세 축입니다.

1. GPU VM + Slurm 클러스터
2. Enroot/Pyxis 설치 및 Slurm 연동
3. NGC 컨테이너를 이용한 분산 ML 실행 기반

이 Step에서는 위 세 축을 기준으로 Optional 실습을 진행합니다.

---

## 2️⃣ 사전 점검 (권장)

Login/Scheduler 노드에서 아래 항목을 먼저 확인합니다.

```bash
sinfo
scontrol --version
nvidia-smi
```

점검 포인트:

* Slurm 버전 확인
* GPU 드라이버 인식 여부
* 실행 노드(Partition/Node 상태) 정상 여부

---

## 3️⃣ Enroot/Pyxis 준비 전략

버전 고정보다 **호환성 기준**으로 맞추는 것을 권장합니다.

* Enroot: 배포판/커널/드라이버와 호환되는 최신 안정 버전
* Pyxis: 현재 Slurm 버전과 호환되는 버전
* NVIDIA Container Tools: 드라이버 및 런타임 호환 확인

실습 운영 원칙:

* 먼저 테스트 클러스터(비운영)에서 적용
* Cluster-init 또는 이미지 커스터마이징 중 한 방식으로 일관 적용
* 드라이버/런타임/Slurm 플러그인 버전 조합을 기록

---

## 4️⃣ NGC 인증 및 컨테이너 준비

NGC Private 이미지 접근이 필요하면 API Key를 설정합니다.

```bash
mkdir -p $HOME/.config/enroot
vi $HOME/.config/enroot/.credentials
```

예시 형식:

```text
machine nvcr.io login $oauthtoken password <NGC_API_KEY>
```

컨테이너 이미지 준비(예시):

```bash
enroot import docker://nvcr.io/nvidia/pytorch:20.12-py3
enroot create -n fun-pytorch nvidia/pytorch:20.12-py3.sqsh
enroot list
```

> 태그(`20.12-py3`)는 예시입니다. 실제 실습에서는 워크로드 요구사항에 맞는 최신 검증 태그를 사용하세요.

---

## 5️⃣ Slurm에서 Container Job 실행 (예시)

Pyxis가 활성화되어 있다면 아래와 같은 형태로 실행할 수 있습니다.

```bash
srun --container-image=docker://nvcr.io/nvidia/pytorch:20.12-py3 \
     --gpus=1 \
     bash -lc "python -c 'import torch; print(torch.cuda.is_available())'"
```

성공 기준:

* Job이 정상 할당/시작됨
* 컨테이너 내부에서 GPU 인식 결과가 `True`

---

## 6️⃣ sbatch 기반 멀티노드 NCCL all-reduce 검증

이제 실제로 멀티노드 GPU 통신이 동작하는지 `sbatch`로 검증합니다.

먼저 로컬 저장소에서 샘플 스크립트를 Login Node로 복사합니다.

```bash
scp scripts/nccl-allreduce.sbatch <username>@<LoginNodePublicIP>:~/
```

Login Node에서 제출:

```bash
sbatch ~/nccl-allreduce.sbatch
squeue
```

완료 후 결과 확인:

```bash
cat nccl-allreduce-<jobid>.out
```

정상 예시:

```text
rank=0 world=2 reduced=3.0 expected=3.0
rank=1 world=2 reduced=3.0 expected=3.0
rank=0 validation=PASS
rank=1 validation=PASS
```

위 결과가 나오면, 2개 노드(또는 2개 task) 간 NCCL collective가 정상 동작한 것입니다.

---

## 7️⃣ 운영 전 업데이트 체크리스트

다음 항목은 반드시 최신 기준으로 재검토하세요.

* [ ] VM SKU 세대 변경 여부 (예: NDv4/NDv5 계열)
* [ ] OS 버전(18.04 기준 문서 여부)
* [ ] Nvidia Driver / CUDA / NCCL 상호 호환성
* [ ] Slurm / Pyxis / Enroot 버전 호환성
* [ ] CycleCloud Project/Template 문법 변경 사항

---

## 8️⃣ 정리

이 Step을 통해 기존 워크샵에 없던 다음 영역을 확장할 수 있습니다.

* GPU 컨테이너 기반 HPC/ML 실행 패턴
* Slurm + Enroot/Pyxis 연동 실습
* 운영 환경 반영 전 호환성 검증 방법

---

# 완료 기준

* [ ] NGC 이미지 import/create 성공
* [ ] Slurm container job 실행 성공
* [ ] GPU 인식 확인 (`torch.cuda.is_available()` 등)
* [ ] `nccl-allreduce.sbatch` 실행 성공
* [ ] all-reduce 결과 검증값 일치 (`reduced == expected`)
* [ ] 버전 호환성 체크리스트 기록
