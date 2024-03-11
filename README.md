## PODOTODO - 쉽고 편한 할 일 관리
<img width="1018" alt="스크린샷 2023-11-12 오전 10 55 52" src="https://github.com/i-seo725/PodoTodo/assets/140357379/901e9bd8-1d6f-4dd6-bd61-eb324756a777">


## 앱 소개
 * 매일 그날의 할 일을 모두 완료하면 포도알 스티커를 하나씩 채워 성취감을 느낄 수 있도록 도와주는 앱
 * 테이블뷰 셀을 좌우로 스와이프하여 완료/취소, 삭제, 미루기 기능 동작
 * 그룹 기능을 통한 체계적인 일정 관리 지원
 * 매일 채우는 포도알 스티커와 포도를 통해 추가 컨텐츠 즐기기(업데이트 예정)
<br/>


## 주요 기능
 * FSCalendar 라이브러리를 활용하여 컨셉에 맞는 커스텀 캘린더 표현
 * Realm DB를 Repository Pattern을 통해 추상화하여 사용자가 등록한 할 일, 그룹 및 포도알 관리
 * string catalog 기반의 localization 기능으로 한국어 및 영어 언어 지원
 * Firebase 라이브러리를 활용한 사용자 패턴 분석
 <br/>

## 개발 기간
 * 2023.09.25. ~ 2023.10.24.
<br/>


## 개발환경
  * Xcode 14.3.1
  * Supported Destinations : iPhone
  * Minimum Deployments : 15.0
  * Orientation : Portrait
<br/>


## 사용기술 및 라이브러리
 * UIKit, Snapkit, Realm, FSCalendar
 * MVVM, Repository Pattern, Localization
 * Firebase Analytics, Firebase Crashlytics, Firebase Cloud messaging
 <br/>
 
## 트러블 슈팅     
 ### 1. 날짜 변화에 따른 FSCalendar UI 업데이트 이슈
   * 오후 11시 59분에서 자정으로 넘어갈 때 오늘 날짜로 표시되는 UI가 변경되지 않는 이슈 발생
   * `viewWillAppear` 메서드에 캘린더 업데이트 구문을 작성하였으나 다른 탭을 선택했다 돌아와도 변경되지 않음
   * NotificationCenter를 통해 날짜 변화 시점을 관찰하여 자정이 될 때 캘린더 UI가 업데이트 되도록 반영

     ```swift
     override func viewDidLoad() {
          super.viewDidLoad()
          NotificationCenter.default.addObserver(self, selector: #selector(updateToday), name: NSNotification.Name.NSCalendarDayChanged, object: nil)
      }
  
       @objc func updateToday() {
          DispatchQueue.main.async {
              self.todoCalendar.today = Date()
              self.todoCalendar.reloadData()
          }
      }
      
       override func viewDidDisappear(_ animated: Bool) {
          super.viewDidDisappear(animated)
          NotificationCenter.default.removeObserver(self)
      }
     ```
   
 ### 2. 포도알 채우는 로직 구현 시 예상보다 많은 고려 사항
   * 화면이 나타날 때 로직 계산을 위해 `viewWillAppear`에 메서드를 작성하였는데, Todo를 모두 완료한 경우 화면을 볼 때마다 포도알이 늘어나는 버그 발생
   * 오늘의 Todo를 모두 완료처리 했다가 사용자가 새로운 할 일을 추가하거나 완료 처리를 취소할 때 채웠던 포도알 스티커를 하나 회수해야 하는 상황 발생
   * 다음과 같은 코드를 통한 예외 처리 구현

     ```swift
      func setNewPodo() {
        guard let todayTodo else { return }
        let validateIsDone = todayTodo.filter { $0.isDone == false }
        let date = Date().addingTimeInterval(-86400).dateToString().stringToDate()
        if currentPodoCount() == 10 && (todayTodo.count == 0 || validateIsDone.isEmpty) {
            if let currentPodo {
                podoRepo.update(id: currentPodo._id, isCurrent: false, fillCount: 10, completeDate: date, plusDate: date, deleteDate: nil)
                podoRepo.create(GrapeList(isCurrent: true, completeDate: nil, plusDate: nil, deleteDate: nil))
            }
            currentPodo = podoRepo.fetchCurrent().first
            podoList = podoRepo.fetch()
         }
       }

     func updatePodo() {
        guard let todayTodo else { return }
        let count = currentPodoCount()
        var changeCount = count
        let today = Date().dateToString().stringToDate()
        let validateIsDone = todayTodo.filter { $0.isDone == false }
        
        guard let currentPodo else {
            return
        }
        
        if validateIsDone.isEmpty && todayTodo.count != 0 {
            if currentPodo.plusDate != today {
                changeCount += 1
                if changeCount > 10 || changeCount > count + 1 {
                    return
                }
                podoRepo.update(id: currentPodo._id, isCurrent: true, fillCount: changeCount, completeDate: nil, plusDate: today, deleteDate: nil)
            }
        } else {
            if currentPodo.deleteDate != today && currentPodo.plusDate == today {
                changeCount -= 1
                if changeCount < 0 || changeCount < count - 1 {
                    return
                }
                podoRepo.update(id: currentPodo._id, isCurrent: true, fillCount: changeCount, completeDate: nil, plusDate: nil, deleteDate: today)
            }
        }
    
     ```

<br/>

## 회고
 * 효율적인 메모리 관리를 위해 Realm을 Singleton 패턴으로 구성하였으나 충돌이 발생할 수 있다는 사실을 추후에 알게되어 출시 후 업데이트에 반영하게 됨
   테스트 시에는 충돌이 발생하지 않았으나 출시 후 Firebase Crashlytics에서 관찰된 충돌 로그의 원인으로 추측됨
 * 학습 시에는 열거형의 편의성을 크게 이해하지 못하였으나 앱 출시 후 유지보수 측면에서 매우 편리함을 이해하여 적극 활용하게 됨
 * 포도알 채우기 로직의 경우 do try catch 문을 활용할 수도 있었을 것 같았는데 if else문만 사용한 점에 아쉬움이 남아 코드 개선 및 추가 학습 예정
