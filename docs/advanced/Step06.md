# Step06 – Slurm Template Customizing (Advanced)

---

## 🎯 학습 목표

이번 Advanced Step에서는 Azure CycleCloud의 핵심 기능 중 하나인
**Cluster Template 구조**를 이해하고, Slurm Cluster 구성을 조금 더 깊이 있게 살펴봅니다.

이 Step은 기본 워크샵(L200)을 완료한 이후 진행하는 **선택 Advanced 모듈(L250 수준)**입니다.

이 단계에서 배우게 되는 내용:

* CycleCloud Template 구조 이해
* Nodearray 및 Partition 개념 심화
* Template 수정 후 Cluster 재적용 흐름 이해
* Autoscale 구조가 Template와 어떻게 연결되는지 이해

> ⚠️ Production 환경을 위한 Template 설계가 아닌, 학습 목적의 구조 이해에 초점을 둡니다.

---

# 1. 왜 Template Customizing이 필요한가?

기본 워크샵에서는 Slurm Template을 그대로 사용했습니다.

하지만 실제 HPC 환경에서는 다음 요구가 자주 발생합니다.

* CPU Partition과 GPU Partition 분리
* 특정 VM Size만 사용하는 Node 그룹 구성
* Idle Timeout 또는 Autoscale 정책 변경
* Custom Mount 또는 Application 추가

이러한 설정은 대부분 **Cluster Template**에서 정의됩니다.

---

## 🔎 Template과 Autoscale의 관계

Autoscale은 Template에 정의된 Nodearray를 기준으로 동작합니다.

```id="u3sofp"
Template
 └─ Nodearray 정의
       └─ VM Size
       └─ Min/Max Node
       └─ Partition
```

즉,

👉 Scheduler가 Job을 받으면
👉 Template 정의를 참고하여 Compute Node를 생성합니다.

---

# 2. CycleCloud UI에서 Template 확인

## 🔧 Template 화면 이동

1. CycleCloud Web Portal 접속
2. 상단 메뉴 → **Templates**
3. 현재 사용 중인 Slurm Template 선택

예시:

```id="n9gpl6"
slurm
```

---

## ✔️ Template 구성 요소

Template 화면에서는 다음과 같은 요소를 확인할 수 있습니다.

| 항목         | 설명                     |
| ---------- | ---------------------- |
| Nodearrays | Compute Node 그룹        |
| Head Node  | Login / Scheduler Node |
| Partition  | Slurm Queue 그룹         |
| VM Size    | Azure Compute SKU      |

---

# 3. Nodearray 개념 이해 (중요)

Nodearray는 Compute Node의 정의 단위입니다.

예:

```id="1r7l4z"
compute-hb
compute-cpu
compute-gpu
```

각 Nodearray는 다음을 포함합니다.

* VM Size
* Subnet
* Autoscale 설정
* Partition 연결

---

## 🔎 현재 Cluster Nodearray 확인

CycleCloud UI:

```id="c98dxt"
Clusters → slurm-hpc-lab → Edit
```

여기서 Compute Node 설정을 확인할 수 있습니다.

---

# 4. Template Customizing 예제 (학습용)

이번 실습에서는 실제로 Cluster를 크게 변경하지 않고
Nodearray 설정을 관찰하고 일부 값을 수정하는 흐름을 이해합니다.

---

## 🎯 목표

기존 compute nodearray에서:

```id="1twipk"
Max Node 수 변경
```

을 수행해봅니다.

---

## 🔧 Template 수정

1. Templates 메뉴 이동
2. Slurm Template 선택
3. Nodearray 영역 찾기

예시 설정:

```id="7h6dvt"
Max Count: 4 → 6
```

Save 클릭

---

## 📌 중요한 개념

Template을 수정했다고 해서 즉시 VM이 생성되지는 않습니다.

Template은:

```id="zz9f83"
Cluster의 "설계도"
```

입니다.

실제 반영은 Cluster Update가 필요합니다.

---

# 5. Cluster Update 수행

Template 변경 후:

1. Clusters 메뉴 이동
2. slurm-hpc-lab 선택
3. **Update** 또는 **Apply Changes** 클릭

Cluster 상태:

```id="0hyu5e"
Updating → Running
```

---

# 6. Autoscale과 Template의 연결 이해

이제 Scheduler는 다음 정보를 기반으로 Node를 생성합니다.

```id="sj8npe"
Partition → Nodearray → VM Size → Max Node
```

즉,

Template Customizing은 Autoscale 동작 자체를 바꾸는 작업입니다.

---

# 7. Dynamic Partition 개념 (Tutorials 기반)

cyclecloud_tutorials에서 중요한 개념 중 하나는 Dynamic Partition입니다.

Dynamic Partition 특징:

* STATE=CLOUD
* 필요할 때만 Node 생성
* Idle 시 자동 제거

기본 워크샵에서 이미 경험한 Autoscale이
사실상 Dynamic Partition 기반 동작입니다.

---

# 8. Template 변경 시 주의사항 (실무 팁)

* Head Node VM Size 변경은 재배포 필요 가능
* Subnet 변경 시 네트워크 충돌 발생 가능
* Storage Mount는 Nodearray마다 다르게 설정 가능

워크샵에서는 구조 이해가 목적이므로
큰 변경은 권장하지 않습니다.

---

# ✔️ Step06 완료 체크리스트

* [ ] Templates 메뉴 접근 성공
* [ ] Slurm Template 구조 확인
* [ ] Nodearray 개념 이해
* [ ] Max Node 값 변경 후 Save
* [ ] Cluster Update 수행

---

# 🧠 이번 Step 핵심 요약

```id="rglhzl"
CycleCloud Template = HPC Cluster 설계도
Nodearray = Autoscale 단위
Partition = Scheduler Queue
Template 변경 → Autoscale 동작 변경
```

---

# ➡️ 다음 Step (Advanced)

Step07에서는 tutorials 내용을 이어 받아

* HPC Application 설치
* sbatch로 실제 Application 실행
* Shared Storage 기반 실행 흐름

을 실습합니다.

이제 HPC Cluster를 실제 워크로드 환경에 가깝게 확장하게 됩니다.
