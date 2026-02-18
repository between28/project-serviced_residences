# Validate intake readiness for building_permit and housing_permit files.
# - Section matching: by expected field count from source-column markdown
# - Date check: auto-detect date-like columns (YYYYMMDD) from sampled rows
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts/12_permit_intake_validate.ps1

$ErrorActionPreference = "Stop"

$schemaFiles = @(
  [PSCustomObject]@{
    dataset_id = "building_permit"
    schema_path = "docs/dissertation/data/source_columns/building_permit_columns.md"
    data_glob = "data/raw/building_permit/*"
  },
  [PSCustomObject]@{
    dataset_id = "housing_permit"
    schema_path = "docs/dissertation/data/source_columns/housing_permit_columns.md"
    data_glob = "data/raw/housing_permit/*"
  }
)

$outIntake = "outputs/tables/permit_file_intake.csv"
$outDate = "outputs/tables/permit_date_like_columns.csv"

function Parse-SchemaSections {
  param([string]$Path)

  $lines = Get-Content -Path $Path -Encoding UTF8
  $sections = @{}
  $current = ""
  $inCode = $false
  $skipHeaderRow = $false

  foreach ($line in $lines) {
    if ($line -match '^##\s+(.+)$') {
      $heading = $Matches[1].Trim()
      $heading = $heading -replace '\s+\(TODO\)$', ''
      $current = $heading
      if (-not $sections.ContainsKey($current)) {
        $sections[$current] = New-Object System.Collections.Generic.List[string]
      }
      continue
    }

    if ($line -match '^```') {
      $inCode = -not $inCode
      if ($inCode -and -not [string]::IsNullOrWhiteSpace($current)) {
        $skipHeaderRow = $true
      }
      continue
    }

    if (-not $inCode -or [string]::IsNullOrWhiteSpace($current)) {
      continue
    }

    if ([string]::IsNullOrWhiteSpace($line)) {
      continue
    }

    if ($skipHeaderRow) {
      $skipHeaderRow = $false
      continue
    }

    $parts = $line -split "`t"
    $col = $parts[0].Trim()
    if ($col.Length -gt 0) {
      $sections[$current].Add($col)
    }
  }

  # Keep only parsed sections that have at least one column
  $clean = @{}
  foreach ($k in $sections.Keys) {
    if ($sections[$k].Count -gt 0) {
      $clean[$k] = $sections[$k]
    }
  }
  return $clean
}

function Is-ValidDateYmd {
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

$intakeRows = @()
$dateRows = @()

foreach ($spec in $schemaFiles) {
  if (-not (Test-Path $spec.schema_path)) {
    throw "Schema not found: $($spec.schema_path)"
  }

  $sections = Parse-SchemaSections -Path $spec.schema_path

  $expectedCountToSections = @{}
  foreach ($s in $sections.Keys) {
    $count = $sections[$s].Count
    if (-not $expectedCountToSections.ContainsKey($count)) {
      $expectedCountToSections[$count] = New-Object System.Collections.Generic.List[string]
    }
    $expectedCountToSections[$count].Add($s)
  }

  $files = @(Get-ChildItem -Path $spec.data_glob -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".gitkeep" })
  foreach ($f in $files) {
    $firstLine = Get-Content -Path $f.FullName -Encoding UTF8 -TotalCount 1
    $fieldCount = ($firstLine -split '\|').Count

    $matchedSections = @()
    if ($expectedCountToSections.ContainsKey($fieldCount)) {
      $matchedSections = @($expectedCountToSections[$fieldCount])
    }

    $matchStatus = "no"
    if ($matchedSections.Count -eq 1) { $matchStatus = "yes" }
    elseif ($matchedSections.Count -gt 1) { $matchStatus = "ambiguous" }

    $matchedSection = ""
    if ($matchedSections.Count -gt 0) {
      $matchedSection = $matchedSections[0]
    }

    # Resolve ambiguous field-count matches using filename tokens.
    if ($matchedSections.Count -gt 1) {
      $fileName = $f.Name
      $bestSection = ""
      $bestScore = -1
      $tie = $false

      foreach ($cand in $matchedSections) {
        $tokens = @($cand -split '[\s\(\)_\-]+' | Where-Object { $_.Length -ge 2 })
        $score = 0
        $tail = ($cand -split '\s+')[-1]
        if ($tail.Length -ge 2 -and $fileName -like "*$tail*") {
          $score += 10
        }
        foreach ($tk in $tokens) {
          if ($fileName -like "*$tk*") {
            $score += 1
          }
        }
        if ($score -gt $bestScore) {
          $bestScore = $score
          $bestSection = $cand
          $tie = $false
        } elseif ($score -eq $bestScore) {
          $tie = $true
        }
      }

      if ($bestScore -gt 0 -and -not $tie) {
        $matchedSection = $bestSection
        $matchStatus = "resolved_by_filename"
      }
    }

    $intakeRows += [PSCustomObject]@{
      dataset_id = $spec.dataset_id
      file_name = $f.Name
      file_size_gb = [math]::Round($f.Length / 1GB, 3)
      delimiter = "|"
      sample_field_count = $fieldCount
      matched_section = $matchedSection
      matched_section_candidates = ($matchedSections -join "; ")
      field_count_match = $matchStatus
      notes = "section inferred from schema field count"
    }

    # Date-like column discovery (sample based)
    $sampleRows = 5000
    $stats = @{}
    $rowCount = 0
    foreach ($line in (Get-Content -Path $f.FullName -Encoding UTF8 -TotalCount $sampleRows)) {
      if ([string]::IsNullOrWhiteSpace($line)) { continue }
      $rowCount += 1
      $parts = $line -split '\|'
      for ($i = 0; $i -lt $parts.Count; $i++) {
        if (-not $stats.ContainsKey($i)) {
          $stats[$i] = [PSCustomObject]@{
            non_empty = 0
            valid_ymd = 0
            invalid = 0
            min_date = $null
            max_date = $null
          }
        }
        $v = $parts[$i].Trim()
        if ([string]::IsNullOrWhiteSpace($v)) { continue }
        $stats[$i].non_empty += 1
        if (Is-ValidDateYmd -Value $v) {
          $stats[$i].valid_ymd += 1
          $d = [datetime]::ParseExact($v, "yyyyMMdd", $null)
          if (-not $stats[$i].min_date -or $d -lt $stats[$i].min_date) { $stats[$i].min_date = $d }
          if (-not $stats[$i].max_date -or $d -gt $stats[$i].max_date) { $stats[$i].max_date = $d }
        } else {
          $stats[$i].invalid += 1
        }
      }
    }

    $dateLike = @()
    foreach ($k in $stats.Keys) {
      $s = $stats[$k]
      if ($s.valid_ymd -ge 100) {
        $dateLike += [PSCustomObject]@{
          col_idx_1based = ($k + 1)
          non_empty = $s.non_empty
          valid_ymd = $s.valid_ymd
          invalid = $s.invalid
          min_date = if ($s.min_date) { $s.min_date.ToString("yyyy-MM-dd") } else { "" }
          max_date = if ($s.max_date) { $s.max_date.ToString("yyyy-MM-dd") } else { "" }
        }
      }
    }

    $top = $dateLike | Sort-Object valid_ymd -Descending | Select-Object -First 8
    foreach ($d in $top) {
      $dateRows += [PSCustomObject]@{
        dataset_id = $spec.dataset_id
        file_name = $f.Name
        matched_section = $matchedSection
        sample_rows = $rowCount
        column_index_1based = $d.col_idx_1based
        non_empty = $d.non_empty
        valid_yyyymmdd = $d.valid_ymd
        invalid = $d.invalid
        min_valid_date = $d.min_date
        max_valid_date = $d.max_date
      }
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
