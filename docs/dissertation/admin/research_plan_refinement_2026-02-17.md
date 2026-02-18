# Research Plan Refinement and Immediate Action List (2026-02-17)

## A. Proposal Refinements Needed Before Supervisor Review

1. **Outcome definitions must be fully operationalized**
- `permit_count_sr`: 분자/분모(share 포함)와 집계 규칙을 명시
- `start_event`, `completion_event`: 위험집합 진입/이탈 규칙을 월 기준으로 명문화
- 권장: `docs/dissertation/data/variable_definitions.md`에 산식과 예외처리 규칙 추가

2. **Policy exposure coding should be explicit and reproducible**
- LTV/DTI/규제지역 지정 이벤트별 `effective_date`, `scope`, `direction` 규칙을 확정
- 시군구 매핑 규칙(전국/일부지역/광역권)을 코드북에 명시
- 권장: `docs/dissertation/policy/policy_codebook.md`에 이벤트 코딩 예시 3개 이상 추가

3. **Identification assumptions should be written as testable statements**
- Parallel trends는 "검증 가능한 사전추세" 형태로 기술
- 정책 선반영(anticipation) 가능성: 리드 구간 정의와 해석 규칙 명시
- 정책 중첩시 식별전략: 정책군 분리 추정 + exclusion window

4. **Estimator choice for staggered treatment must be pinned down**
- 메인: event-study with robust staggered DID estimator
- 강건성: Sun-Abraham / Callaway-Sant'Anna / Borusyak-Jaravel-Spiess 교차검증
- 권장: 방법론 섹션에 "왜 TWFE 단독이 아닌지"를 3-4문장으로 명시

5. **Inference and standard errors**
- 기본 클러스터 단위를 `sigungu`로 둘지, `sigungu` + time two-way clustering 할지 결정 필요
- 희소 이벤트(착공/준공)에서 small-sample 보정 여부 명시 필요

6. **Linkage quality and sample selection risk need quantified thresholds**
- 매칭률 하한(예: 85% 등)과 하회 시 대체전략(보수적 바운드) 정의
- 누락/불일치 건의 공간적 편중을 진단하는 체크리스트 추가

7. **RQ4 substitution definition should be sharpened**
- 대체 카테고리(오피스텔, 기타 소형주거)의 코드 목록 고정
- `permit_share_sr`와 `adjacent_permit_share`를 함께 보고, 합계 기준 분모를 통일

## B. Immediate Actions (Do Now)

1. **Data audit first (priority 1)**
- 확보 데이터의 기간/공간 커버리지 요약표 생성
- 산출물: `outputs/tables/data_coverage_audit.csv`

2. **Policy calendar freeze v1 (priority 1)**
- LTV/DTI/규제지역 + 생숙 직접규제 이벤트를 절대날짜로 입력
- 산출물: `docs/dissertation/policy/housing_policy_timeline.csv` 초안 완성

3. **Panel skeleton build (priority 1)**
- `sigungu-month` 템플릿(기간 x 시군구) 생성
- `building-month` 위험집합 템플릿(permit→start, start→completion) 생성
- 산출물: `data/processed/panel_sigungu_month.parquet`, `data/processed/panel_building_month.parquet`

4. **Variable construction spec freeze (priority 2)**
- coverage, residentialisation, market pressure 변수 산식/윈도우를 확정
- 산출물: `docs/dissertation/data/variable_definitions.md` 업데이트

5. **Pre-analysis checklist draft (priority 2)**
- 메인 사양, 강건성 사양, placebo, 제외규칙, 시각화 리스트 고정
- 산출물: `docs/dissertation/admin/preanalysis_checklist.md`

6. **Supervisor-ready brief (priority 2)**
- 2쪽 요약: 질문-데이터-식별-리스크-다음 4주 일정
- 산출물: `docs/dissertation/admin/supervisor_brief_v1.md`

## C. 30-minute Quick Wins (while away)

- 참고문헌 자동 수집 폴더(`references/auto_added`)와 요약 문서 점검
- 이벤트 코딩 누락 변수 목록 작성(정책ID, 효력일, 적용범위, 방향)
- 다음 미팅용 핵심 결정사항 5개(클러스터링, 이벤트 윈도우, 대체카테고리 정의 등) 정리