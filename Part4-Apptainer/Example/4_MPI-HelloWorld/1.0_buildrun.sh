#!/usr/bin/bash
# --- first job - no dependencies ----------------------------
# --- Build the SIF File -------------------------------------
jid1=$(sbatch --parsable 2.1_build_MPI-hybrid.sbatch)

# --- second task of our pipeline ----------------------------
# --- use the previous variable from the SLURMJOBID here -----
# --- Run the SIF File ---------------------------------------
export NNODES=4
sbatch --dependency afterok:${jid1} 2.2_run_MPI-hybrid.sbatch

# second submission in case the first one fails
run2_id=$(sbatch --parsable --dependency afternotok:${jid1} 3.0_clean.sh)