# Validate intake readiness for raw building-register files.
# The source files are headerless row data, so this check uses field counts
# and known column positions for key date fields.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts/11_building_register_intake_validate.ps1

$ErrorActionPreference = "Stop"

$baseDir = "data/raw/building_register"
$outIntake = "outputs/tables/building_register_file_intake.csv"
$outDate = "outputs/tables/building_register_date_parse_check.csv"

if (-not (Test-Path $baseDir)) {
  throw "Directory not found: $baseDir"
}

function Get-FirstLineUtf8 {
  param([string]$Path)
  Get-Content -Path $Path -Encoding UTF8 -TotalCount 1
}

function Split-FieldsPipe {
  param([string]$Line)
  if ([string]::IsNullOrWhiteSpace($Line)) {
    return @()
  }
  return @($Line -split '\|')
}

function Is-ValidYyyyMmDd {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
  if ($Value -notmatch '^\d{8}$') { return $false }
  try {
    [void][datetime]::ParseExact($Value, "yyyyMMdd", $null)
    return $true
  } catch {
    return $false
  }
}

# section_id is ASCII for script stability.
$specs = @(
  [PSCustomObject]@{
    section_id = "private_unit"
    folder = "private_unit"
    expected_fields = 27
    permit_idx = 0
    start_idx = 0
    approval_idx = 0
  },
  [PSCustomObject]@{
    section_id = "jijigu"
    folder = "jijigu"
    expected_fields = 18
    permit_idx = 0
    start_idx = 0
    approval_idx = 0
  },
  [PSCustomObject]@{
    section_id = "housing_price"
    folder = "housing_price"
    expected_fields = 25
    permit_idx = 0
    start_idx = 0
    approval_idx = 0
  },
  [PSCustomObject]@{
    section_id = "title"
    folder = "title"
    expected_fields = 77
    permit_idx = 59
    start_idx = 60
    approval_idx = 61
  },
  [PSCustomObject]@{
    section_id = "summary_title"
    folder = "summary_title"
    expected_fields = 64
    permit_idx = 48
    start_idx = 49
    approval_idx = 50
  }
)

$intakeRows = @()
$dateRows = @()
$sampleRows = 50000

foreach ($spec in $specs) {
  $folderPath = Join-Path $baseDir $spec.folder
  $files = @()
  if (Test-Path $folderPath) {
    $files = @(Get-ChildItem -Path $folderPath -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".gitkeep" })
  }

  if ($files.Count -eq 0) {
    $intakeRows += [PSCustomObject]@{
      section_id = $spec.section_id
      folder = $spec.folder
      file_name = ""
      file_size_gb = 0
      delimiter = ""
      sample_field_count = 0
      expected_field_count = $spec.expected_fields
      field_count_match = "no"
      encoding_read = "n/a"
      notes = "file missing"
    }
    continue
  }

  foreach ($f in $files) {
    $firstLine = Get-FirstLineUtf8 -Path $f.FullName
    $fields = Split-FieldsPipe -Line $firstLine
    $sampleFieldCount = $fields.Count

    $intakeRows += [PSCustomObject]@{
      section_id = $spec.section_id
      folder = $spec.folder
      file_name = $f.Name
      file_size_gb = [math]::Round($f.Length / 1GB, 3)
      delimiter = "|"
      sample_field_count = $sampleFieldCount
      expected_field_count = $spec.expected_fields
      field_count_match = if ($sampleFieldCount -eq $spec.expected_fields) { "yes" } else { "no" }
      encoding_read = "UTF-8"
      notes = "headerless raw rows; field-count check"
    }
  }

  if ($spec.permit_idx -le 0) {
    continue
  }

  $mainFile = $files | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  $dateTargets = @(
    [PSCustomObject]@{ name = "permit_date"; idx1 = $spec.permit_idx },
    [PSCustomObject]@{ name = "start_date"; idx1 = $spec.start_idx },
    [PSCustomObject]@{ name = "approval_date"; idx1 = $spec.approval_idx }
  )

  foreach ($dt in $dateTargets) {
    $idx0 = $dt.idx1 - 1
    $rowCount = 0
    $nonEmpty = 0
    $valid = 0
    $invalid = 0
    $minDate = $null
    $maxDate = $null

    foreach ($line in (Get-Content -Path $mainFile.FullName -Encoding UTF8 -TotalCount $sampleRows)) {
      if ([string]::IsNullOrWhiteSpace($line)) {
        continue
      }
      $rowCount += 1
      $parts = Split-FieldsPipe -Line $line
      if ($parts.Count -le $idx0) {
        continue
      }
      $v = $parts[$idx0].Trim()
      if ([string]::IsNullOrWhiteSpace($v)) {
        continue
      }

      $nonEmpty += 1
      if (Is-ValidYyyyMmDd -Value $v) {
        $valid += 1
        $d = [datetime]::ParseExact($v, "yyyyMMdd", $null)
        if (-not $minDate -or $d -lt $minDate) { $minDate = $d }
        if (-not $maxDate -or $d -gt $maxDate) { $maxDate = $d }
      } else {
        $invalid += 1
      }
    }

    $dateRows += [PSCustomObject]@{
      section_id = $spec.section_id
      file_name = $mainFile.Name
      date_field = $dt.name
      column_index_1based = $dt.idx1
      sample_rows = $rowCount
      non_empty = $nonEmpty
      valid_yyyymmdd = $valid
      invalid = $invalid
      min_valid_date = if ($minDate) { $minDate.ToString("yyyy-MM-dd") } else { "" }
      max_valid_date = if ($maxDate) { $maxDate.ToString("yyyy-MM-dd") } else { "" }
      parse_ready = if ($invalid -eq 0) { "yes" } else { "check" }
      notes = "sample-based check"
    }
  }
}

$outDir = Split-Path -Parent $outIntake
if (-not (Test-Path $outDir)) {
  New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$intakeRows | Export-Csv -Path $outIntake -NoTypeInformation -Encoding UTF8
$dateRows | Export-Csv -Path $outDate -NoTypeInformation -Encoding UTF8

Write-Host "Wrote: $outIntake"
Write-Host "Wrote: $outDate"
