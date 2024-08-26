# 푸디랜드 Read Me

![ded0cf63-bbfa-48af-9aaf-4c95f0f62ba6](https://github.com/user-attachments/assets/ef72075d-a9d6-4297-8760-03a4f5a7776e)

## 앱의 기능

- 위치 조회 (지도를 통해서 내가 저장한 장소및 주변 장소를 볼 수 있습니다.)
- 장소 검색 (서치바를 통해서 원하는 장소를 검색할 수 있습니다)
- 장소의 URL을 눌러 보다 상세한 정보를 확인할 수 있습니다.
- 지역 정보 저장

### 기술 스택

- UIKit, MapKit
- SnapKit, compositional Layout
- Toast, FSCalendar, FloatingPanel, Cosmos
- Realm
- Alamofire
- MVVM

# 기술설명
### Compositional Layout 
> 유저가 기존 검색에서 다른 검색으로 변경 사항이 있을 경우 애니메이션이 적용되어 UI가 자연스럽게 업데이트되므로 <br> 
사용자 경험을 해치지 않은다는 것에 사용하였습니다.

### Realm 
> 해당 프로젝트에서는 복잡한 데이터 관계, 연산이 필요없으며 간단한 데이터 저장 및 읽기를 원하여 사용하였습니다.<br>
이때 UserDefault를 사용할 수도 있겠지만 앱의 초기 설정, 사용자의 간단한 설정을 저장할때만 사용해야된다고 생각하여 Realm을 사용하였습니다.

### MVVM 
> MVC 패턴에서는 ViewController에 비즈니스 로직이 과도하게 포함되어 코드 재사용성과 가독성이 떨어졌습니다.<br>
반면, MVVM 패턴을 사용하면 비즈니스 로직을 ViewModel로 분리하여 ViewController의 부담을 줄이고,<br>
코드 가독성과 유지보수성을 높일 수 있어 사용하였습니다.


## 알게된, 새로 쓴 기술


| `Observable` 클래스는 MVVM 패턴에서 데이터 바인딩을 구현하기 위한 방식입니다.
```swift
class Observable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping ((T) -> Void)) {
        closure(value)
        self.listener = closure
    }
    
}

```

## 인터페이스화
> 공통적으로 사용되는 코드들을 일관되게 사용할 수 있으며 재사용이 좋게 쓸 수 있습니다.

```swift
protocol ConfigureUIProtocol {
    func configureUI() 
    func configureHierarchy()
    func configureLayout()
}
```

## 트러블 슈팅

### IQKeyboardManager 사용 시 발생한 문제와 해결 방법

### 문제 상황

| IQKeyboardManager는 키보드가 나타날 때 뷰의 레이아웃을 자동으로 조정해 줍니다. 이 과정에서 네비게이션 바의 배경이 투명해지는 현상이 발생하여 사용자 경험에 좋지 않은 상황이 발생했습니다.

### 해결 방법
> iOS 13부터 사용 가능한 `UINavigationBarAppearance` 객체를 활용하여<br>
> 네비게이션 바의 `standardAppearance`(스크롤 하기 전 상태)와 `scrollEdgeAppearance`<br>
> (스크롤 하는 중인 상태)의 BackgroundColor를 변경하여 문제를 해결했습니다.<br>
> 이를 통해 네비게이션 바가 항상 불투명하게 유지되도록 설정했습니다.

| 적용후 | 적용전 |
|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/38696b97-65dc-4329-b1d7-b07f8bccb430" width = "240"> | <img src = "https://github.com/user-attachments/assets/387752f1-c8df-4f9f-af4f-a2c8bde8ddac" width = "240"> |

```swift
func setupNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground 
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}
```

## FloatingPanel 메모리 누수

### 문제 상황

| CustomDetailViewController에서 달력을 눌렀을때 FloatingPanel로 올라오도록 설계를 하고 내렸을때 FloatingPanel의 Panel의 View가 deinit이 되지않고 메모리를 차지하고 있는 이슈입니다.
 
### 해결 방법

> 패널이 특정 위치에서 특정 속도로 스크롤될 때 패널을 제거할지 여부를 결정하는 메소드에서 현재 플로팅 패널을 애니메이션과 함께 부모 뷰 컨트롤러에서 제거하는 방식으로 메모리가 쌓이는 것을 방지하였습니다.

| 달력을 누르기 전 | 달력을 누른 후  | 
|:---:|:---:|
|<img width="270" src="https://github.com/user-attachments/assets/70785c18-2ba0-451d-a935-eddb235b0f3f"> | <img width ="270" src="https://github.com/user-attachments/assets/92d0b8ea-db31-4a9c-ab2b-9cbc7d1f9da3"> |

### 달력을 누르고 제거후에도 메모리를 차지하고 있습니다
<img alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-04-01_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_1 42 22" src="https://github.com/user-attachments/assets/67c06c2d-f2b5-4fc1-9a1f-ce17540752b0">

```swift
///  수정 전
func floatingPanel(_ fpc: FloatingPanelController, shouldRemoveAt location: CGPoint, with velocity: CGVector) -> Bool {
     return true
}
/// 수정 후
func floatingPanel(_ fpc: FloatingPanelController, shouldRemoveAt location: CGPoint, with velocity: CGVector) -> Bool {
        fpc.removePanelFromParent(animated: true)
        return true
 }
```

> FloatingPanel의 연결을 끊으면서 연결해뒀던 view도 nil값을 주면서 확실하게 deinit을 시켜 해결하였습니다.

| 달력을 누르기 전 | 달력을 누른 후  | 달력을 내린 후 |
|:---:|:---:|:---:|
|<img width="266" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-04-01_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_1 42 40" src="https://github.com/user-attachments/assets/5d5c47e4-75d7-4454-ac21-9a0522875d8d"> | <img width="265" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-04-01_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_1 42 31" src="https://github.com/user-attachments/assets/dcfa1488-b9e4-48fe-a5f1-a64037adfb73"> | <img width="266" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-04-01_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_1 42 40" src="https://github.com/user-attachments/assets/e50e1347-8799-4be6-ba56-37309b91eb0f"> |
