# Build a quick intake audit from the dataset manifest.
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts/10_data_download_checklist.ps1

$manifestPath = "docs/dissertation/data/data_download_manifest.csv"
$outPath = "outputs/tables/data_coverage_audit.csv"

if (-not (Test-Path $manifestPath)) {
  Write-Error "Manifest not found: $manifestPath"
  exit 1
}

$rows = Import-Csv $manifestPath
$audit = @()

foreach ($row in $rows) {
  $glob = $row.target_glob
  $files = @()
  if ($glob -and $glob.Trim().Length -gt 0) {
    $files = @(Get-ChildItem -Path $glob -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".gitkeep" })
  }

  $matchedCount = $files.Count
  $totalBytes = 0
  $latestWrite = ""
  $usableFileCount = 0
  $csvDataRowCount = 0
  if ($matchedCount -gt 0) {
    $totalBytes = ($files | Measure-Object -Property Length -Sum).Sum
    $latestWrite = ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")

    foreach ($f in $files) {
      if ($f.Extension -ieq ".csv") {
        $lineCount = (Get-Content -Path $f.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
        if ($lineCount -gt 1) {
          $usableFileCount += 1
          $csvDataRowCount += ($lineCount - 1)
        }
      } elseif ($f.Length -gt 0) {
        $usableFileCount += 1
      }
    }
  }

  $audit += [PSCustomObject]@{
    dataset_id = $row.dataset_id
    status_in_manifest = $row.status
    target_glob = $glob
    matched_file_count = $matchedCount
    usable_file_count = $usableFileCount
    csv_data_row_count = $csvDataRowCount
    total_bytes = $totalBytes
    latest_file_write_time = $latestWrite
    ready_for_analysis = if ($usableFileCount -gt 0) { "yes" } else { "no" }
    notes = $row.notes
  }
}

$outDir = Split-Path -Parent $outPath
if (-not (Test-Path $outDir)) {
  New-Item -ItemType Directory -Force $outDir | Out-Null
}

$audit | Export-Csv -Path $outPath -NoTypeInformation -Encoding utf8
Write-Host "Data intake audit written to $outPath"
