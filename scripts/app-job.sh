#!/bin/bash
#SBATCH --job-name=app-test
#SBATCH --output=app-output.txt

/shared/apps/sample-app/run-app.sh
