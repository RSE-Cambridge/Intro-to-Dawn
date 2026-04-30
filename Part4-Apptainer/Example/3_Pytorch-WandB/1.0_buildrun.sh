#!/bin/bash
# --- first job - no dependencies ----------------------------
# --- Build the SIF File -------------------------------------
jid1=$(sbatch --parsable 2.1_build_INTEL-WandB.sbatch)

# --- second task of our pipeline ----------------------------
# --- use the previous variable from the SLURMJOBID here -----
# --- Run the SIF File ---------------------------------------
sbatch --dependency afterok:${jid1} 2.2_run_INTEL-WandB.sbatch
# second submission in case the first one fails
run2_id=$(sbatch --parsable --dependency afternotok:${jid1} 3.0_clean.sh)