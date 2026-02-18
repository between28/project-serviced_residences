#!/usr/bin/env python3
"""
Extract core columns from large, headerless raw permit/register files.

Input files are pipe-delimited (`|`) rows without headers.
Column positions are inferred from source column markdown files.
"""

from __future__ import annotations

import argparse
import csv
import gzip
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Tuple


CORE_COLUMNS = {
    "관리_건축물대장_PK",
    "관리_허가대장_PK",
    "관리_주택대장_PK",
    "관리_공동주택대장_PK",
    "관리_동별_개요_PK",
    "관리_형별_개요_PK",
    "관리_호별_명세_PK",
    "시군구_코드",
    "법정동_코드",
    "대지_위치",
    "대지_구분_코드",
    "번",
    "지",
    "생성_일자",
    "건물_명",
    "동_명",
    "동명",
    "허가_일",
    "건축_허가_일",
    "실제_착공_일",
    "착공_일",
    "착공_예정_일",
    "사용승인_일",
    "사용_검사_일",
    "사용_검사_예정_일",
    "승인_일",
    "사업_승인_일",
    "기준_일자",
    "주_용도_코드",
    "주_용도_코드_명",
    "용도_코드",
    "용도_코드_명",
    "주택유형_구분_코드",
    "주택유형_구분_코드_명",
    "주택_유형_구분_코드",
    "주택_유형_구분_코드_명",
    "연면적(㎡)",
    "건축_면적(㎡)",
    "대지_면적(㎡)",
    "세대_수(세대)",
    "호_수(호)",
    "지상_층_수",
    "지하_층_수",
    "층_번호",
    "주택가격",
    "지역지구구역_구분_코드",
    "지역지구구역_구분_코드_명",
    "지역지구구역_코드",
    "지역지구구역_코드_명",
    "지역지구구역_명",
    "대표_여부",
}


@dataclass(frozen=True)
class DatasetConfig:
    dataset_id: str
    schema_path: Path
    raw_base: Path


DATASETS = {
    "building_register": DatasetConfig(
        dataset_id="building_register",
        schema_path=Path("docs/dissertation/data/source_columns/building_register_columns.md"),
        raw_base=Path("data/raw/building_register"),
    ),
    "building_permit": DatasetConfig(
        dataset_id="building_permit",
        schema_path=Path("docs/dissertation/data/source_columns/building_permit_columns.md"),
        raw_base=Path("data/raw/building_permit"),
    ),
    "housing_permit": DatasetConfig(
        dataset_id="housing_permit",
        schema_path=Path("docs/dissertation/data/source_columns/housing_permit_columns.md"),
        raw_base=Path("data/raw/housing_permit"),
    ),
}


BUILDING_REGISTER_SECTION_BY_SUBDIR = {
    "title": "건축물대장 표제부",
    "summary_title": "건축물대장 총괄표제부",
    "private_unit": "건축물대장 전유부",
    "jijigu": "건축물대장 지역지구구역",
    "housing_price": "건축물대장 공동주택가격",
}


def parse_schema_sections(path: Path) -> Dict[str, List[str]]:
    sections: Dict[str, List[str]] = {}
    current = ""
    in_code = False
    skip_header_row = False

    lines = path.read_text(encoding="utf-8").splitlines()
    for line in lines:
        if line.startswith("## "):
            current = line[3:].strip()
            current = current.replace(" (TODO)", "")
            if current not in sections:
                sections[current] = []
            continue

        if line.startswith("```"):
            in_code = not in_code
            if in_code and current:
                skip_header_row = True
            continue

        if not in_code or not current:
            continue
        if not line.strip():
            continue
        if skip_header_row:
            skip_header_row = False
            continue

        col = line.split("\t", 1)[0].strip()
        if col:
            sections[current].append(col)

    # keep only sections with parsed columns
    return {k: v for k, v in sections.items() if v}


def infer_files_and_sections(
    dataset_id: str,
    raw_base: Path,
) -> List[Tuple[Path, str]]:
    results: List[Tuple[Path, str]] = []

    if dataset_id == "building_register":
        for subdir, section in BUILDING_REGISTER_SECTION_BY_SUBDIR.items():
            d = raw_base / subdir
            if not d.exists():
                continue
            for f in sorted(p for p in d.iterdir() if p.is_file() and p.name != ".gitkeep"):
                results.append((f, section))
        return results

    if dataset_id == "building_permit":
        keyword_to_section = {
            "주택유형": "건축인허가 주택유형",
            "대지위치": "건축인허가 대지위치",
            "지역지구구역": "건축인허가 지역지구구역",
            "동별개요": "건축인허가 동별개요",
            "기본개요": "건축인허가 기본개요",
        }
    elif dataset_id == "housing_permit":
        keyword_to_section = {
            "관리공동형별개요": "주택인허가 관리공동형별개요",
            "기본개요": "주택인허가 기본개요",
            "대지위치": "주택인허가 대지위치",
            "동별개요": "주택인허가 동별개요",
            "지역지구구역": "주택인허가 지역지구구역",
            "행위개요": "주택인허가 행위개요",
        }
    else:
        return results

    files = sorted(p for p in raw_base.iterdir() if p.is_file() and p.name != ".gitkeep")
    for f in files:
        section = ""
        for kw, sec in keyword_to_section.items():
            if kw in f.name:
                section = sec
                break
        if section:
            results.append((f, section))
    return results


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def extract_file(
    dataset_id: str,
    src_file: Path,
    section: str,
    section_columns: Sequence[str],
    out_path: Path,
    max_rows: int,
) -> Dict[str, object]:
    selected = [c for c in section_columns if c in CORE_COLUMNS]
    index = {c: i for i, c in enumerate(section_columns)}
    selected_idx = [(c, index[c]) for c in selected]

    ensure_parent(out_path)
    rows_in = 0
    rows_out = 0
    bad_field_rows = 0

    with src_file.open("r", encoding="utf-8", errors="replace", newline="") as rf, gzip.open(
        out_path, "wt", encoding="utf-8", newline=""
    ) as wf:
        writer = csv.writer(wf)
        header = ["source_dataset", "source_section", "source_file", "source_row"] + selected
        writer.writerow(header)

        for line_no, raw in enumerate(rf, start=1):
            if max_rows > 0 and rows_in >= max_rows:
                break
            rows_in += 1
            line = raw.rstrip("\n\r")
            if not line:
                continue
            parts = line.split("|")
            if len(parts) < len(section_columns):
                bad_field_rows += 1

            row = [dataset_id, section, src_file.name, str(line_no)]
            for col, i in selected_idx:
                row.append(parts[i].strip() if i < len(parts) else "")
            writer.writerow(row)
            rows_out += 1

    return {
        "dataset_id": dataset_id,
        "section": section,
        "source_file": str(src_file),
        "output_file": str(out_path),
        "selected_core_columns": len(selected),
        "rows_in": rows_in,
        "rows_out": rows_out,
        "bad_field_rows": bad_field_rows,
    }


def run(
    datasets: Sequence[str],
    output_dir: Path,
    max_rows_per_file: int,
    summary_out: Path,
) -> None:
    summary: List[Dict[str, object]] = []

    for ds in datasets:
        if ds not in DATASETS:
            raise ValueError(f"Unknown dataset: {ds}")
        cfg = DATASETS[ds]
        if not cfg.schema_path.exists():
            raise FileNotFoundError(f"Missing schema markdown: {cfg.schema_path}")
        if not cfg.raw_base.exists():
            raise FileNotFoundError(f"Missing raw directory: {cfg.raw_base}")

        sections = parse_schema_sections(cfg.schema_path)
        targets = infer_files_and_sections(ds, cfg.raw_base)

        for src_file, section in targets:
            if section not in sections:
                summary.append(
                    {
                        "dataset_id": ds,
                        "section": section,
                        "source_file": str(src_file),
                        "output_file": "",
                        "selected_core_columns": 0,
                        "rows_in": 0,
                        "rows_out": 0,
                        "bad_field_rows": 0,
                        "error": "section_not_found_in_schema",
                    }
                )
                continue

            safe_section = (
                section.replace(" ", "_")
                .replace("/", "_")
                .replace("(", "")
                .replace(")", "")
            )
            out_file = output_dir / ds / f"{safe_section}.csv.gz"
            info = extract_file(
                dataset_id=ds,
                src_file=src_file,
                section=section,
                section_columns=sections[section],
                out_path=out_file,
                max_rows=max_rows_per_file,
            )
            info["error"] = ""
            summary.append(info)

    ensure_parent(summary_out)
    with summary_out.open("w", encoding="utf-8", newline="") as sf:
        fields = [
            "dataset_id",
            "section",
            "source_file",
            "output_file",
            "selected_core_columns",
            "rows_in",
            "rows_out",
            "bad_field_rows",
            "error",
        ]
        writer = csv.DictWriter(sf, fieldnames=fields)
        writer.writeheader()
        for row in summary:
            writer.writerow(row)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--datasets",
        nargs="+",
        default=["building_register", "building_permit", "housing_permit"],
        help="Datasets to process.",
    )
    parser.add_argument(
        "--output-dir",
        default="data/interim/core_columns",
        help="Directory for extracted core-column files.",
    )
    parser.add_argument(
        "--summary-out",
        default="outputs/tables/core_extraction_summary.csv",
        help="CSV summary output path.",
    )
    parser.add_argument(
        "--max-rows-per-file",
        type=int,
        default=0,
        help="Optional cap per file for quick validation. 0 = all rows.",
    )
    args = parser.parse_args()

    run(
        datasets=args.datasets,
        output_dir=Path(args.output_dir),
        max_rows_per_file=args.max_rows_per_file,
        summary_out=Path(args.summary_out),
    )


if __name__ == "__main__":
    main()
