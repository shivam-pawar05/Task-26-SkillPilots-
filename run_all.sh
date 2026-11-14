#!/usr/bin/env bash
# Usage: ./run_all.sh <database_name> [user]
DB="${1:?give database name}"; USER="${2:-$(whoami)}"
P="psql -U $USER -d $DB -v ON_ERROR_STOP=1"
mkdir -p results
$P -f sql/01_setup_data.sql
$P -f sql/02_before_index.sql | tee results/before.txt
$P -f sql/03_create_index.sql
$P -f sql/04_after_index.sql  | tee results/after.txt
echo "Plans saved in results/before.txt and results/after.txt - copy the numbers into REPORT.md"
