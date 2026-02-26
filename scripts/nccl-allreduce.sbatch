#!/bin/bash
#SBATCH --job-name=nccl-allreduce
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-task=1
#SBATCH --cpus-per-task=8
#SBATCH --partition=compute
#SBATCH --time=00:20:00
#SBATCH --output=nccl-allreduce-%j.out

IMAGE="docker://nvcr.io/nvidia/pytorch:24.01-py3"
MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
MASTER_PORT=29500

export MASTER_ADDR MASTER_PORT

echo "MASTER_ADDR=$MASTER_ADDR"
echo "SLURM_NTASKS=$SLURM_NTASKS"

srun --container-image="${IMAGE}" --container-mounts=/shared:/shared \
  bash -lc 'python - <<"PY"
import os
import torch
import torch.distributed as dist

rank = int(os.environ["SLURM_PROCID"])
world_size = int(os.environ["SLURM_NTASKS"])
local_rank = int(os.environ.get("SLURM_LOCALID", "0"))

if torch.cuda.device_count() == 0:
    raise RuntimeError("CUDA device is not available")

torch.cuda.set_device(local_rank)

dist.init_process_group(
    backend="nccl",
    init_method=f"tcp://{os.environ['"'"'MASTER_ADDR'"'"']}:{os.environ['"'"'MASTER_PORT'"'"']}",
    rank=rank,
    world_size=world_size,
)

x = torch.tensor([rank + 1.0], device="cuda")
dist.all_reduce(x, op=dist.ReduceOp.SUM)
expected = world_size * (world_size + 1) / 2

print(
    f"rank={rank} world={world_size} reduced={x.item():.1f} expected={expected:.1f}",
    flush=True,
)

if abs(x.item() - expected) > 1e-5:
    raise RuntimeError(f"all_reduce verification failed: {x.item()} != {expected}")

dist.barrier()
dist.destroy_process_group()
print(f"rank={rank} validation=PASS", flush=True)
PY'