# 지금 할 일 (아주 짧게)

## 1) 데이터 받기
- 건축물대장(세움터): https://www.eais.go.kr
- 숙박업 등록(지방행정 인허가): https://www.localdata.go.kr
- 용도지역/토지이용: https://www.eum.go.kr
- 주택가격지수: https://www.reb.or.kr/r-one/main.do
- 거래량: https://rt.molit.go.kr
- 인구/가구: https://www.kosis.kr
- 철도/지하철 역 좌표: https://www.data.go.kr

## 2) 파일 넣기
- 받은 파일을 아래 폴더에 넣기:
- `data/raw/building_register/`
- `data/raw/lodging_registration/`
- `data/raw/zoning/`
- `data/raw/market/`
- `data/raw/demographic/`
- `data/raw/transit/`

## 3) 점검 실행
```powershell
./scripts/10_data_download_checklist.ps1
```
- 결과 확인: `outputs/tables/data_coverage_audit.csv`

## 4) 나에게 알려주기
- "파일 넣었어"라고 말하면, 내가 바로 패널 골격(`sigungu-month`, `building-month`) 생성으로 진행함.
