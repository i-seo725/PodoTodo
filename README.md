# PODOTODO - 쉽고 편한 할 일 관리
<img width="1018" alt="스크린샷 2023-11-12 오전 10 55 52" src="https://github.com/i-seo725/PodoTodo/assets/140357379/901e9bd8-1d6f-4dd6-bd61-eb324756a777">



# 앱 소개
 * 매일 그날의 할 일을 모두 완료하면 포도알 스티커를 하나씩 채워 성취감을 느낄 수 있도록 도와주는 앱
 * 테이블뷰 셀을 좌우로 스와이프하여 완료/취소, 삭제, 미루기 기능 동작
 * 그룹 기능을 통한 체계적인 일정 관리 지원
 * 매일 채우는 포도알 스티커와 포도를 통해 추가 컨텐츠 즐기기(업데이트 예정)




# 개발 기간
 * 2023.09.25. ~ 2023.10.24.(약 1달)




# 개발환경
  * Xcode 14.3.1
  * Supported Destinations : iPhone
  * Minimum Deployments : 15.0
  * Orientation : Portrait




# 사용기술 및 라이브러리
 * UIKit, Codable, Realm, FSCalendar
 * MVVM, Repository, Localization
 * Firebase Analytics, Firebase Crashlytics, Firebase Cloud messaging

 <br/><br/><br/><br/><br/>
 
# 트러블 슈팅
 * Todo가 등록된 날짜와 캘린더 날짜 비교의 어려움
   * DatePicker를 통해 Todo 날짜 선택 시 초 단위로 날짜가 저장되는데, FSCalendar에서 선택한 날짜는 15:00로 고정됨
   * 이로 인해 Realm에서 filter를 통해 데이터를 불려올 때 시간이 정확히 일치하지 않아 불러오기에 실패
   * 따라서 다음과 같은 코드를 통해 테이블에 날짜 저장 시 Date -> String -> Date 타입 변환을 통해 동일하게 15:00로 고정되도록 함

   ```swift
   class MainList: Object {
       convenience init(date: Date = Date()) {
        self.date = date.dateToString().stringToDate() ?? Date()
    }
   }
   ```
 * 포도알 채우는 로직 구현 시 생각보다 많은 고려 사항
   * 


# 회고
