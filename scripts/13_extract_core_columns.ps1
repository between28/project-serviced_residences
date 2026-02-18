# Extract core columns from large raw permit/register files.
#
# Usage examples:
#   powershell -ExecutionPolicy Bypass -File scripts/13_extract_core_columns.ps1
#   powershell -ExecutionPolicy Bypass -File scripts/13_extract_core_columns.ps1 -MaxRowsPerFile 100000

param(
  [int]$MaxRowsPerFile = 0
)

$ErrorActionPreference = "Stop"

$cmd = @(
  "python",
  "src/00_ingest/extract_core_columns.py",
  "--datasets", "building_register", "building_permit", "housing_permit",
  "--output-dir", "data/interim/core_columns",
  "--summary-out", "outputs/tables/core_extraction_summary.csv",
  "--max-rows-per-file", "$MaxRowsPerFile"
)

Write-Host ("Running: " + ($cmd -join " "))
& $cmd[0] $cmd[1..($cmd.Length-1)]

if ($LASTEXITCODE -ne 0) {
  throw "Core extraction failed with exit code $LASTEXITCODE"
}

Write-Host "Done: outputs/tables/core_extraction_summary.csv"
