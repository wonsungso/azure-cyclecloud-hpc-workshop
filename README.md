# Azure CycleCloud + Slurm HPC Workshop (L200)

---

## 📘 Overview

이 워크샵은 Azure Portal 기준으로 **Azure CycleCloud와 Slurm 기반 HPC 환경**을 직접 구축하면서
Autoscale 기반 HPC 클러스터의 동작 방식을 이해하는 것을 목표로 합니다.

본 실습은 **HPC 또는 CycleCloud 경험이 없는 사용자(L200 수준)**를 대상으로 설계되었습니다.

학습을 통해 다음을 직접 경험할 수 있습니다.

* Azure CycleCloud Control Plane 이해
* Slurm Scheduler 기반 Job 실행 흐름
* Queue 기반 Compute Node Autoscale
* Azure HPC 아키텍처 구성 방식

---

## 🏗️ Architecture

본 워크샵에서 구성하는 구조:

* Azure CycleCloud (Cluster Control Plane)
* Slurm Login / Scheduler Node
* Dynamic Compute Nodes (Autoscale)
* Azure Files Shared Storage
* VNet 기반 내부 통신 구조

---

## 🧭 Workshop Steps

아래 순서대로 진행하시기 바랍니다.

### 🔹 Step00 – HPC & CycleCloud 개념 이해

HPC 기본 개념과 Azure CycleCloud의 역할을 이해합니다.

👉 `docs/Step00.md`

---

### 🔹 Step01 – Azure 기본 인프라 준비

Resource Group, VNet, Subnet, Shared Storage를 생성합니다.

👉 `docs/Step01.md`

---

### 🔹 Step02 – Azure CycleCloud 배포

Marketplace를 통해 CycleCloud Control Plane을 배포합니다.

👉 `docs/Step02.md`

---

### 🔹 Step03 – Slurm HPC Cluster 생성

CycleCloud Template을 사용하여 Slurm 클러스터를 생성합니다.

👉 `docs/Step03.md`

---

### 🔹 Step04 – Job 실행 & Scheduler 이해

SSH 접속 후 Slurm Job을 실행하며 Scheduler 동작을 확인합니다.

👉 `docs/Step04.md`

---

### 🔹 Step05 – Autoscale 체험 및 리소스 정리

Queue 증가에 따른 Compute Node Autoscale을 관찰하고 리소스를 정리합니다.

👉 `docs/Step05.md`

---

## ⚙️ Prerequisites

워크샵 시작 전에 다음을 확인하세요.

* Azure Subscription
* VM 생성 권한
* 최소 8~16 vCPU Quota 권장
* SSH 클라이언트 (Windows Terminal / WSL 등)

---

## 💡 Notes

* 본 워크샵은 학습 목적이며 Production 환경 설계를 포함하지 않습니다.
* 실제 운영 환경에서는 Private Access, Bastion, RBAC 최소 권한 구성을 권장합니다.
* GPU 노드 구성은 본 워크샵 범위에 포함되지 않습니다.

---

## 🧹 Cleanup

워크샵 종료 후 반드시 다음을 수행하십시오.

* Slurm Cluster Stop
* CycleCloud VM Stop
* Resource Group Delete

리소스를 삭제하지 않으면 비용이 발생할 수 있습니다.

---

## 📄 License

MIT License
