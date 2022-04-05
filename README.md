
# 🧮 계산기 프로젝트

* 개인 프로젝트
* 프로젝트 기간: 2021.11.08 ~ 2021.11.19

# 목차

- [키워드](#키워드)
- [프로젝트 소개](#%EF%B8%8F-프로젝트-소개)
- [프로젝트 주요기능](#-프로젝트-주요기능)
- [UML](#uml)
- [Trouble Shooting](#-trouble-shooting)
    + ["스크롤이 먹히는 문제"](#스크롤이-먹히는-문제)
    + ["깊은 계층에 위치해있는 뷰의 요소를 깔끔하게 꺼내오려면?"](#깊은-계층에-위치해있는-뷰의-요소를-깔끔하게-꺼내오려면)
    + ["스크롤 바로 인해 내부 Label의 Text가 가려지는 문제"](#스크롤-바로-인해-내부-label의-text가-가려지는-문제)
    + ["버튼의 모양을 둥글게 다듬어보기"](#버튼의-모양을-둥글게-다듬어보기)
- [새롭게 알게된 것](#-새롭게-알게된-것)
    + ["Array에 제네릭 타입이 Element가 기재되어있는 경우"](#array에-제네릭-타입이-element가-기재되어있는-경우)
    + ["removeAll vs 빈 배열 할당하기"](#removeall-vs-빈-배열-할당하기)
    + ["빈 프로토콜의 존재 의미"](#빈-프로토콜의-존재-의미)
    + ["split vs components"](#split-vs-components)
    + ["`viewWillLayoutSubviews()`는 무슨 역할을 할까?"](#viewwilllayoutsubviews는-무슨-역할을-할까)

</br>

# 키워드

### `Swift`

- `Generic` `Element`
- `map` `filter` `split` `compactMap`
- `FloatingPoint` `Numeric`
- `protocol` `extension`
- `attribute`
- `replacingOccurrences`
- `split vs components`

### `iOS`

- `Delegation pattern` 
- `TDD` `Unit Test`
- `UIStackView` `UIScrollView`
- `NumberFormatter`
- `Auto Layout`
- `layoutIfNeeded()` `setNeedsLayout()`
- `Main Run Loop` `Update Cycle`
- `viewDidLoad` `viewWillLayoutSubviews`
- `IBInspectable`

### `etc`

- `UML`
- `Array` `LinkedList`
- `Queue` `Stack`

</br>

## ⭐️ 프로젝트 소개

아이폰의 기본 앱인 계산기 앱과 흡사한 기능을 가진 앱이에요. 🤓

심플한 UI 및 간단한 기능을 통해 계산을 할 수 있어요! 💪🏻

</br>

## ✨ 프로젝트 주요기능

> 🧮 덧셈, 뺄셈, 곱셈, 나눗셈을 할 수 있습니다! 

<img src="https://i.imgur.com/T5a0loL.gif"> <img src="https://i.imgur.com/a6VCYO6.gif"> <img src="https://i.imgur.com/Q9tqGIN.gif">

> 🛠 모두 초기화, 부분 초기화, 토글 버튼을 통해 현재 계산상태를 변경할 수 있어요.

<img src="https://i.imgur.com/XUcUiip.gif"> <img src="https://i.imgur.com/JA0Qm6O.gif"> <img src="https://i.imgur.com/wkZ9NGe.gif">

> ✍🏻 계산이 끝나고, 이어서 계산할 수 있어요

<img src="https://i.imgur.com/c6oBGvZ.gif">

</br>

## UML

![](https://i.imgur.com/XBotKoP.png)

</br>

## 🛠 Trouble Shooting

### "스크롤이 먹히는 문제"

- `상황`
    - 스크롤 뷰의 콘텐츠 뷰 원점을 설정하는 메소드를 활용해보았다.
    
    ```swift
    let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
    scrollView.setContentOffset(bottomOffset, animated: false)
    ```
    
    - 그러나 스크롤 바가 생길때 약간 움직이면서 스크롤이 안되는... 이상해보이는 애니메이션을 취하는 문제가 발생했다.

    <img src="https://i.imgur.com/v4OYFOe.gif" width=30%>
    
    - 이 문제를 해결해보기 위해서 1차적으로 구글링을 통해 찾아보았고, 찾는데 어려움이 있어 3기 캠퍼 선배분들에게도 질문해보았지만 해결방법을 찾지 못했다.
- `이유`
    - 3기 캠퍼 `수박`의 도움으로 LLDB를 활용하여 처음 y좌표가 어떤 값으로 찍히는지 확인해보았으나, StackView가 추가되고 난 후 업데이트 되어 y값 좌표가 계산이 되어야 하는데, 버튼을 누르기 이전의 y좌표가 찍히는 것이 확인되었다.
    - 타이머나 비동기적으로 해당 부분을 해결해보려고 해보았으나 발만 담궈봤지 제대로 배워보지 않은 지식이라 해결하는데 많은 어려움이 있었다.
    - 이후 서포터즈 `Wody`에게 질문해보았고 얼마 지나지 않아 해결을 할 수 있게 되었다.
- 정상적으로 하단으로 자동 스크롤이 되는 모습

    <img src="https://i.imgur.com/uUW8GWB.gif" width=30%>

- `layoutIfNeeded()`라는 메소드를 활용하여 해결하게 되었다. 이 메소드는 `setNeedsLayout()`과 같이 수동으로 layoutSubviews를 예약하는 행위이지만 해당 예약을 바로 실행시키는 동기적으로 작동하는 메소드다. update cycle이 올 때 까지 기다려 layoutSubviews를 호출시키는 것이 아니라 그 즉시 layoutSubviews를 발동시키는 메소드다.
- 만일 main run loop에서 하나의 View가 setNeedsLayout을 호출하고 그 다음 layoutIfNeeded를 호출한다면 layoutIfNeeded는 그 즉시 View의 값이 재계산되고 화면에 반영하기 때문에 setNeedsLayout이 예약한 layoutSubviews 메소드는 update cycle에서 반영해야할 변경된 값이 존재하지 않기 때문에 호출되지 않는다.
- 이러한 동작 원리로 `layoutIfNeeded()`는 그 즉시 값이 변경되어야 하는 애니메이션에서 많이 사용된다고 한다.
- `해결`
    - 따라서 스크롤뷰의 원점에 대한 콘텐츠뷰의 오프셋 설정을 해주기 전에 `layoutIfNeeded()` 메소드를 호출하여 layout을 업데이트 하고 setContentOffset을 설정해주었더니 해당 문제에 대해서 해결되었다.
    
 ### "깊은 계층에 위치해있는 뷰의 요소를 깔끔하게 꺼내오려면?"

- `상황` **스택뷰 > 스택뷰 > 레이블** 계층을 가진 부분에서 레이블의 텍스트를 꺼내려면 `arrangedSubviews`를 `이중 for문`을 돌면서 가져와야 하는 상황이 마음에 안들었다.
    
    ```swift
    extension UIStackView {
        var toString: String {
            var inputValues = [String]()
                    self.arrangedSubviews.forEach{ view in
                let subview = view as? UIStackView
                subview?.arrangedSubviews.forEach{ view in
                    let label = view as? UILabel
                    guard let input = label?.text else {
                        return
                    }
                    inputValues.append(input.replacingOccurrences(of: ",", with: ""))
                }
            }
            return inputValues.joined(separator: " ")
        }
    }
    ```
    
- `해결방향` 리뷰어 엘림에게 조언을 구해서 `스택뷰 > 커스텀뷰` 계층을 가질 수 있도록 커스텀뷰 만들기에 도전해보았다.
- `결과`
    
    ```swift
    extension UIStackView {
        var toString: String {
            var inputValues = [String]()
            self.arrangedSubviews.forEach { view in
                guard let formualStackView = view as? FormulaStackView else {
                    return
                }
                inputValues.append(contentsOf: formualStackView.element)
            }
            return inputValues.joined(separator: " ")
        }
    }
    ```
    
- `FormulaStackView`라는 커스텀 뷰를 만들어 줌으로써 이중 for문을 돌던 문제도 해결이 되었고, ViewController에서 스택뷰 내부에 `Label을 추가`해주는 부분도 커스텀뷰 내부에서 해결할 수 있게되었다.

### "스크롤 바로 인해 내부 Label의 Text가 가려지는 문제"

<img src="https://user-images.githubusercontent.com/49546979/142418073-e9de7219-2754-482e-9f7d-ad3f77633c48.png" width=30%>

- `상황` 계산내역이 쌓여서 스크롤바가 생기는 문제로 스크롤을 진행할 시 글씨가 가려지는 문제가 있었다.
- `해결방향` 스크롤바를 가릴 수 있는 방법이 없는지 구글링을 통해서 찾아보았다.
- `결과`
- 찾아보니 인터페이스 빌더에서도 설정을 해줄 수도 있고 코드로도 해당 문제를 해결할 수 있었다.
    - 코드로 설정하기
        
        ```swift
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        ```
        
        - 인터페이스 빌더에서 없애기
        
        ![https://i.imgur.com/rOkoBw3.png](https://i.imgur.com/rOkoBw3.png)
        
        위 사진에서 체크를 풀어주면 된다.
        

### "버튼의 모양을 둥글게 다듬어보기"

`상황` 엘림에게 버튼을 둥글게 만들어보는 도전과제를 받게되어 해결해보기로 하였다.

`시도-1`  처음에는 버튼 자체가 코드가 아닌 스토리보드에서 생성된 버튼이라서 인터페이스 빌더로 해결해보고자 하였다.

```swift
    extension UIView {
        @IBInspectable var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
    }
```

- 그러나 이 방법으로는 버튼의 cornerRadius를 직접 대입해주는 방식(하드코딩)이기 때문에 디바이스가 다를 경우 내가 원하는 결과를 얻기에는 힘들다고 판단되었다. 그래서 코드로 해볼 수 있는 방법을 찾아 해결해보았다.

`시도-2` 

```swift
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calculatorButtons.forEach { button in
            button.layer.cornerRadius = button.layer.frame.size.width / 2
        }
    }
```

- 버튼의 너비 / 2를 해서 cornerRadius를 설정해준 코드다. 이때 `viewWillLayoutSubviews` 메소드를 써준다.

`시도-3, 그리고 해결` 

- 버튼의 IBOutlet에 didSet을 줄 수도 있었지만 아래와 같은 문제 때문에 해당 방법은 불가능 했다.
    
   ![](https://i.imgur.com/TGNgcJQ.png)
    
- 디버깅을 해보니 `viewWillLayoutSubviews` 메소드가 호출되는 시점에 레이아웃이 갱신되어 버튼의 너비가 바뀌고 있었다.
(디바이스는 아이폰 SE 기준이다. SE 이상 디바이스에서는 없던 문제였다.)
IBOutlet의 didSet은 `viewDidLoad가 호출되기 전`에 호출되므로 적절하지 못한 방법이였다.
- 따라서 최소한으로 적게 호출되는 `updateViewConstraints`메소드를 활용하여 해당 문제를 해결하였다.
    
    ```swift
    func setupButtons() {
        calculatorButtons.forEach { button in
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.layer.bounds.width / 2
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setupButtons()
    }
    ```
    
- updateViewConstraints에 버튼셋팅 메소드를 호출하고있고, for문 내부에서 버튼마다 `layoutIfNeeded`를 호출하여 레이아웃을 갱신하고 이후 cornerRadius 값을 대입해주고있다.
- 레이아웃을 갱신하는 이유는 갱신하지 않으면 위 디버깅시 발견하였던 최종 레이아웃이 아니라 임의로 잡혀있던 frame값으로 계산을 하기 때문에 아래처럼 찌그러진 원이 나온다.
    
   ![](https://i.imgur.com/7Qr05cE.png)
    
`결론`

- viewDidLoad에서 frame사이즈가 정확하지 않을 수 있다. 해당 함수는 뷰는 로드됐다고 확인할 수 있지만, 배치가 됐다고 할수는 없다. 따라서 위와 같은 현상은 viewDidLoad에서 임의로 잡혔던 frame값이 `viewWillLayoutSubviews`가 호출하면서 하위 뷰가 배치되고 이후 값이 변했다고 볼 수 있겠다. 따라서 하위뷰가 배치가 되고나서 버튼의 레이아웃을 잡아줘야 해결이 가능했던 것이다.

### 여기서 의문점이 드는 것은 다른 디바이스들은 상관없는데 왜 SE에서만 버튼의 크기가 줄어드는 것일까?

- 3기 캠퍼 `수박` 의 도움으로 해당 의문점을 풀 수 있었다.

![https://i.imgur.com/MiyseWl.png](https://i.imgur.com/MiyseWl.png)

- HIG에서 장치들의 치수를 확인해서 세로를 보면 200~300정도 차이가 나는 것을 확인할 수 있다.
사진에서도 볼 수 있듯이 세로 크기가 엄청 차이난다.
따라서 작아진 디바이스에 오토 레이아웃을 충족하기 위해 버튼의 크기를 줄일 수 밖에 없다는 추측이 가능해졌다.
- 이러한 사실을 증명해낼 수도 있다. 직접 레이아웃을 다 계산하여 치수와 맞는지 확인할 수도 있지만... 나중에 시도해봐야겠다. 😇

</br>

## 🔥 새롭게 알게된 것

### "Array에 제네릭 타입이 Element가 기재되어있는 경우"
- `상황` 자료구조를 공부하다가 제네릭을 사용한 예제 코드들을 살펴보니 `<T>`로 작성되어있는 경우가 있고, `<Element>`를 사용한 경우가 있는데 둘의 차이가 궁금해졌다. 
    
![](https://i.imgur.com/POuRbFM.png)
    
- `이유` 공식문서 Generic 부분에서 `Naming Type Parameters` 부분을 살펴보니 이름이 없는 것과 이름이 있는 Element는 차이가 없지만 파라미터와 타입 사이의 관계를 가지고 있을때 명확함을 주기 위해 사용한다고 한다. 그러나 관계가 없는 상황에서는 `T`, `U`, `V` 를 주로 사용한다고 한다. 
- `해결` Array와 마찬가지로 Queue나 LinkedList도 요소들이 서로 관계가 있다고 생각하여, 타입 내부에 제네릭 타입`<T>`을 Element라고 명시해주었다. 

### "removeAll vs 빈 배열 할당하기"

- `상황` 리뷰어 엘림에게 removeAll과 빈배열을 할당하는 것이 어떤 차이가 있냐고 질문을 받았는데 어떤 차이가 있는지 모르겠다.
- `이유` Swift github를 통해 removeAll 동작 방식을 한번 살펴보게 되었다.

![image](https://user-images.githubusercontent.com/75905803/141038635-c62fdf49-0118-4eaa-a035-9386a55d165c.png)

![image](https://user-images.githubusercontent.com/75905803/141038660-bc3d1d3f-388d-445d-bca2-1561e2aa3333.png)

- `해결` 살펴보니 파라미터 기본값을 따로 ture로 설정해주지 않는다면 빈 Array를 초기화해주는 동작을 하고 있었다. 따라서 빈 배열과 removeAll는 큰차이가 없는 것으로 결론이 났다.

### "빈 프로토콜의 존재 의미"

* `상황` STEP 1을 진행할 때 빈 프로토콜을 구현해두라는 부분에서 잘 이해가 가지 않았다.
* `이유` 알고보니 CalculateItem은 `Queue에서 다루는 요소`가 준수해야했던 프로토콜이였다.
* `해결` STEP 2를 진행하게 되면서 해당 프로토콜의 역할을 잘 이해할 수 있었고, 덕분에 빈 프로토콜의 용도에 대해서 알게되었다.

### "split vs components"

- `상황` 엘림에게 질문을 받았는데 내가 알고있던 차이점은 반환타입 뿐이였다.
- `이유` 반환타입 말고도 다른 차이점도 있었던게 생각나서 정리해보았다.
- `해결`
- `import 여부`
    - split은 swift 표준 라이브러리에 속해있다.
    - components는 Foundation 프레임워크에 속해있어 import하여 사용할 수 있다.
- `파라미터`
    - split(separator: Character, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true)
    - components(separatedBy separator: String)
- `공백으로 처리할 때의 다른 결과`
    ```swift
    let str = "My name is Sudhir " // trailing space
    
        str.split(separator: " ")
        // ["My", "name", "is", "Sudhir"]
    
        str.components(separatedBy: " ")
        // ["My", "name", "is", "Sudhir", ""] ← Additional empty string
    ```
    둘다 동일한 결과가 나오게 하려면 split의 파라미터 `omittingEmptySubsequences`를 false로 옵션을 따로 줘야 가능하다.
    ```swift
    str.split(separator: " ", omittingEmptySubsequences: false)
        // ["My", "name", "is", "Sudhir", ""]
    ```
- `반환타입의 차이`
    - split -> [Substring]
    - components -> [String]
- `성능 차이` 
    반환타입에서 볼 수 있듯 `split`은 원본 문자열을 참조(SubString)하고 있기 때문에, 새 문자열을 할당하지 않는다.따라서 split이 components보다 성능측면에서 빠르다고 볼 수 있다.
    
    > Substring이란?원본 문자열의 메모리를 공유한다.값을 읽기만 할 때는 원본메모리를 공유하고, 값을 변경하는 시점에만 새로운 메모리가 생성된다.
    
    Substring은 주로 문자열을 처리할 때 메모리를 절약하기 위해서 쓰이는 타입으로 알고있다!

### "`viewWillLayoutSubviews()`는 무슨 역할을 할까?"

- 뷰의 바운드가 최종적으로 결정되는 최초 시점
- 제약이나 오토레이아웃을 사용하지 않았다면, 서브뷰의 레이아웃을 업데이트하기 적합한 시점이다.
- 여러번 중복으로 호출될 수 있다.
    - ex) 메인뷰의 서브뷰가 로드되는 경우
- 메소드를 알아보고 엘림의 피드백을 받고 다시 디버깅을 해보니 `버튼이 클릭이 되는 시점`마다 해당 메소드가 호출이 되고있었다.  cornerRadius를 잡아주는 for문이 버튼이 누를때마다 실행되고 있었던 것이다. 즉 SubView의 레이아웃을 잡아주기에는 적절치 못한 메소드였다.

</br>

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#-계산기-프로젝트)

<details>
<summary>[학습 기록 흔적]</summary>
<div markdown="1">

# 목차
- [STEP 1 : Queue **타입 구현**](#step-1--queue-타입-구현)
    + [고민했던 것](#1-1-고민했던-것)
    + [의문점](#1-2-의문점)
    + [Trouble Shooting](#1-3-trouble-shooting)
    + [배운 개념](#1-4-배운-개념)
    + [PR 후 개선사항](#1-5-pr-후-개선사항)
- [STEP 2 : 계산 타입 및 주변 타입 구현](#step-2--계산-타입-및-주변-타입-구현)
    + [고민했던 것](#2-1-고민했던-것)
    + [의문점](#2-2-의문점)
    + [Trouble Shooting](#2-3-trouble-shooting)
    + [배운 개념](#2-4-배운-개념)
    + [PR 후 개선사항](#2-5-pr-후-개선사항)
- [STEP 3 : 계산기 UI 연동](#step-3--계산기-ui-연동)
    + [고민했던 것](#3-1-고민했던-것)
    + [의문점](#3-2-의문점)
    + [Trouble Shooting](#3-3-trouble-shooting)
    + [배운 개념](#3-4-배운-개념)
    + [PR 후 개선사항](#3-5-pr-후-개선사항)

# STEP 1 : **Queue 타입 구현**
- 자료구조 Queue 타입을 구현합니다.

# UML

![](https://i.imgur.com/pwLcl0n.jpg)

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#목차-1)

## 1-1 고민했던 것
- Queue를 DoubleStack과 LinkedList를 이용하여 두가지를 구현해보았다. 배열로도 구현할 수 있지만 enqueue 작업이 시간복잡도가 O(1)이 걸려서 비효율적이다. 
- Generic타입을 사용할 때 Element로 명시해주었다. 이유는 T로 명시해줄 수도 있지만 어떤 타입이 들어갈지 명확하지 않기 때문에 좀더 직관적으로 보일 수 있도록 요소라는 뜻을 담은 Element를 명시했다. 

## 1-2 의문점
- Queue를 배열로 구현해도 괜찮을까? 
- Array에 제네릭 타입은 어째서 Element일까? 
- removeAll과 빈 배열을 할당하는 것과 차이점이 뭘까?

## 1-3 Trouble Shooting

### 1. Array에 제네릭 타입이 Element가 기재되어있는 경우
- `상황` 자료구조를 공부하다가 제네릭을 사용한 예제 코드들을 살펴보니 `<T>`로 작성되어있는 경우가 있고, `<Element>`를 사용한 경우가 있는데 둘의 차이가 궁금해졌다. 
    
![](https://i.imgur.com/POuRbFM.png)
    
- `이유` 공식문서 Generic 부분에서 `Naming Type Parameters` 부분을 살펴보니 이름이 없는 것과 이름이 있는 Element는 차이가 없지만 파라미터와 타입 사이의 관계를 가지고 있을때 명확함을 주기 위해 사용한다고 한다. 그러나 관계가 없는 상황에서는 `T`, `U`, `V` 를 주로 사용한다고 한다. 
- `해결` Array와 마찬가지로 Queue나 LinkedList도 요소들이 서로 관계가 있다고 생각하여, 타입 내부에 제네릭 타입`<T>`을 Element라고 명시해주었다. 
### 2. removeAll vs 빈 배열 할당하기

- `상황` 엘림에게 removeAll과 빈배열을 할당하는 것이 어떤 차이가 있냐고 질문을 받았는데 어떤 차이가 있는지 모르겠다.
- `이유` Swift github를 통해 removeAll 동작 방식을 한번 살펴보게 되었다.

![image](https://user-images.githubusercontent.com/75905803/141038635-c62fdf49-0118-4eaa-a035-9386a55d165c.png)

![image](https://user-images.githubusercontent.com/75905803/141038660-bc3d1d3f-388d-445d-bca2-1561e2aa3333.png)

- `해결` 살펴보니 파라미터 기본값을 따로 ture로 설정해주지 않는다면 빈 Array를 초기화해주는 동작을 하고 있었다. 따라서 빈 배열과 removeAll는 큰차이가 없는 것으로 결론이 났다.

## 1-4 배운 개념
- Element의 용도
- 자료구조 (`Array`, `LinkedList`, `Queue`, `Stack`)
- 알고리즘의 시간도와 Big-O
- removeAll과 빈 배열을 할당하는 것은 큰 차이가 없다.

## 1-5 PR 후 개선사항

- 불필요한 import 제거
- 추가적으로 attribute에 대해서 공부해보기.
- 짧은 return문이라도 줄바꿈 해주는 것이 디버깅 시 유용하다.
- 메서드 탈출하는 부분은 보통 if보다는 guard를 주로 사용하는 것이 적절한 것 같다.

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#목차-1)

# STEP 2 : 계산 타입 및 주변 타입 구현

- 계산 타입을 구현합니다.

## 2-1 고민했던 것

이번 스텝 진행을 위해 저와 고민을 나눠주셨던 캠퍼분들에게 감사의 인사를 드립니다.

---

- 주어진 UML을 보며 타입이 어떤 역할을 하는지 유추하면서 정리해보았다.

### ExpressionParser

- 사용자의 입력값을 검사해서 연산자와 피연산자를 담는 Formula를 만드는 타입
    - `componentsByOperators`
        - input을 받아서 숫자만 뽑아오는 메소드
    - `parse`
        - 사용자 입력을 받아서 Formula를 반환하는 메소드

### extension String

- `split(with:)`
    - target을 기준으로 문자열을 잘라 배열로 반환하는 메소드
    예시) "12 + 3.1" → ["12", "+", "3.1"]

### Formula

- 연산자큐와 피연산자큐를 담고, 결과(`result()`)를 내는 타입

### Operator

- 연산자와 계산 메소드가 있는 타입

---

### split의 로직에 관한 다양한 고민

- 첫번째는 split을 확장한다는 의미 자체가 `기존 split과의 기능이 다르다고 생각`이 들었다. 그래서 `target과 함께 자르는 것`인가? 라는 생각이 들었다. 연산자와 Double 타입으로 변환할 수 있는 숫자가 함께 배열로 반환되어 Formula를 반환해주는 로직을 생각해보았다.
- 위에서 생각한 로직으로 먼저 돌아가게끔 구현을 해보았더니 **target을 안쓰게 되었다**. 먼저 고려했던 것은 숫자, 연산자가 여러개가 들어온다는 가정하에 구현했기 때문이다. target이 안쓰이는 것이 너무 찝찝하여 여러 캠퍼분들과 같이 고민을 나누어보았다.
- 많은 고민들 끝에 버튼을 누를 때 숫자와 연산자를 구분할 수 있는 `특정 문자열을 임의로 넣어 문자열을 만들 수 있겠다는 생각`을 **공유**받았다. (chacha 고맙습니다...😭) 그래서 연산자를 누를 때 마다 `앞 뒤로 공백이 추가되는 로직`이 떠올라서 그대로 옮겨서 작성해보았다.
- 그러나 Operator 타입이 `Character`인 부분과 `CaseIterable 프로토콜`을 채택한 것을 보았을 때 이것을 split을 할 때 사용하지 않을까? 라는 의문이 또 생겼다. 사실 공백을 추가해서 잘라줄 수도 있겠지만 `하드코딩`이라는 생각이 먼저 들었다. 이후 Operator의 rawValue를 이용하여 split을 구현해볼까 고민해보았지만.. 일단 target의 타입이 배열이 아닌 부분과 allcases를 사용해서 rawValue를 뽑아올 수 없는 점 때문에 해당 의문점은 해결하지 못하였다.

### dequeue할 때 옵셔널바인딩을 할 것인지? 에러처리를 할 것인지?

- 원래는 dequeue를 할 때 nil이 반환 되게끔 구현을 하였었는데, 일일히 옵셔널 바인딩 처리 해주면 지저분해지겠다는 생각이 들어서 해당 로직을 에러를 던지는 로직으로 바꾸어주었다. 이후에도 계속 코드가 더럽다고 느껴져서 다시 고민해보다가... `nil이 반환하게끔 재수정`을 해주고 `result` 부분을 새로 작성해보았다.

### parse에서 Double배열과 Operator배열을 nil 체크 후 반환해주기

- 처음에는 compactMap의 로직을 참고하여 `filter`와 `map`을 이용하여 nil 체크를 하여 변환해주었었는데, 그럴 필요 없이 `compactMap`을 사용하면 될 것 같네? 라는 생각이 들어서 수정해주었다.

### 기존에 구현해주었던 Model의 이니셜라이저 추가

- STEP 1에서 구현해줄 때에는 이니셜라이저를 구현해주지 않았었는데, STEP 2를 구현하다보니 이니셜라이저를 통한 초기화를 해주어야 하는 순간이 오게되어 이니셜라이저를 모두 구현해주었다.

## 2-2 의문점

- split(with:) 메소드의 역할이 정확히 뭘까?
- dequeue시 옵셔널바인딩 vs 에러핸들링
- NaN은 어떤 시점에 발생하는 걸까?
- `componentsByOperators` 메서드명이 동사가 없는 것 같다. 적절한 걸까?

## 2-3 Trouble Shooting

### 1. 빈 프로토콜의 존재 의미가 뭘까?

- `상황`  STEP 1을 진행할 때 빈 프로토콜을 구현해두라는 부분에서 잘 이해가 가지 않았다.
- `이유` 알고보니 CalculateItem은 `Queue에서 다루는 요소`가 준수해야했던 프로토콜이였다.
- `해결`  STEP 2를 진행하게 되면서 해당 프로토콜의 역할을 잘 이해할 수 있었고, 덕분에 빈 프로토콜의 용도에 대해서 알게되었다.

### 2. UML 클래스 다이어그램 화살표에 대해서

- `상황` STEP 2에서 주어졌던 UML에 대한 의문이 생겼다. 왜 내부적으로 연결되어있는 타입끼리는 화살표 표시가 없을까?
- `이유` 이러한 궁금점을 오동나무에게 직접 질문해보았다.
- `해결` 클래스 다이어그램은 표면적으로 드러난 관계만 나타내기 때문에 내부 구현에 대해서는 화살표가 없을 수도 있다.

### 3. 메소드명은 동사로 지어야하는 것이 아닌가?

- `상황` 리뷰어 엘림에게 받은 피드백을 고민해보다가 메소드명이 이상하다는 의문점이 생겨 UML을 작성했던 오동나무에게 질문해보았다.
- `이유` 캠퍼들과 이야기를 나누어봤는데, 메소드명에 동사가 포함되어있지 않았다. 유추한 기능으로는 split과 같은 동작을 하는 메소드 같은데, Int.random 같은 맥락으로 get을 생략한 경우인걸까?
- `해결` 해당 부분을 오동나무에게 직접 물어보았고, 위 내용과 같은 맥락으로 동사가 아닌 네이밍을 한 것이 맞다고 답변받았다. Swift는 사이드 이펙트 없이 값을 리턴하는 메서드에 get을 붙이는 것을 지양하는 편이다. 대표적으로 코코아터치 프레임워크에서 get, fetch, request로 시작하는 메서드는 전부 completion handler를 받는 비동기 작업 뿐이다.

### 4. split vs components

- `상황` 엘림에게 질문을 받았는데 내가 알고있던 차이점은 반환타입 뿐이였다.
- `이유` 반환타입 말고도 다른 차이점도 있었던게 생각나서 정리해보았다.
- `해결`
    
    ### **import 여부**
    
    - split은 swift 표준 라이브러리에 속해있다.
    - components는 Foundation 프레임워크에 속해있어 import하여 사용할 수 있다.
    
    ### **파라미터**
    
    - split(separator: Character, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true)
    - components(separatedBy separator: String)
    
    ### **공백으로 처리할 때의 다른 결과**
    
    ```swift
    let str = "My name is Sudhir " // trailing space
    
        str.split(separator: " ")
        // ["My", "name", "is", "Sudhir"]
    
        str.components(separatedBy: " ")
        // ["My", "name", "is", "Sudhir", ""] ← Additional empty string
    ```
    
    둘다 동일한 결과가 나오게 하려면 split의 파라미터 `omittingEmptySubsequences`를 false로 옵션을 따로 줘야 가능하다.
    
    ```swift
    str.split(separator: " ", omittingEmptySubsequences: false)
        // ["My", "name", "is", "Sudhir", ""]
    ```
    
    ### **반환타입의 차이**
    
    - split -> [Substring]
    - components -> [String]
    
    ### **성능 차이**
    
    반환타입에서 볼 수 있듯 `split`은 원본 문자열을 참조(SubString)하고 있기 때문에, 새 문자열을 할당하지 않는다.따라서 split이 components보다 성능측면에서 빠르다고 볼 수 있다.
    
    > Substring이란?원본 문자열의 메모리를 공유한다.값을 읽기만 할 때는 원본메모리를 공유하고, 값을 변경하는 시점에만 새로운 메모리가 생성된다.
    > 
    
    Substring은 주로 문자열을 처리할 때 메모리를 절약하기 위해서 쓰이는 타입으로 알고있다!
    

## 2-4 배운 개념

- 빈 프로토콜을 활용하는 방법
- 고차함수의 동작 방식
- UML 클래스 다이어그램
- NaN
- 메소드명에 get 사용을 올바른 상황에 하는 방법
- split과 components의 차이점

## 2-5 PR 후 개선사항

- 놓쳤던 모호한 부분을 에러를 던지도록 개선하였다.
- split과 components의 차이점을 알 수 있었다.
- 메소드명에 get은 언제 사용할 수 있는지 알게 되었다.

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#목차-1)

# STEP 3 : **계산기 UI 연동**

- 앞서 구현한 Model을 UI와 연동합니다.

## 3-1 고민했던 것

- 스크롤 뷰의 콘텐츠 오프셋 설정시 레이아웃을 바로 업데이트 할 수 있도록 하였다. 이유는 레이아웃 업데이트가 예약이 되어있는 상태에서 y값 좌표를 계산하여 오프셋설정을 하게된다면 업데이트 이전의 레이아웃으로 y값으로 계산하기 때문에 `layoutIfNeeded()` 메소드를 호출하여 레이아웃 업데이트가 필요하였다.
- 계산식을 스택뷰에 추가할 때 속성값을 어떻게 설정해줘야하는지 고민해보았다. 기존 스토리보드에 설정되어있는 스택뷰의 속성값과 동일하도록 구현해보았다.
- 프로젝트 요구사항 외 추가 설계한 부분
    - 계산이 끝나고 난 후의 상황
        - 스택뷰에 새롭게 업데이트하여 이어서 계산할 수 있도록 추가 설계
    - NaN이 발생하고 난 후의 상황
        - AC, CE 버튼을 누른 후 계산을 할 수 있도록 설계
    - 첫번째 계산식이 올라갈 때의 상황
        - 피연산자만 올라갈 수 있도록 설계
- 계산이 끝나고나서 추가적으로 발생할 수 있는 예외 핸들링
    - '=' 연산자를 클릭 시 `연산자버튼` 혹은 `AC, CE 버튼`을 제외하고 나머지 버튼들은 **동작하지 않도록** 구성
    - NumberFormatter로 인해 쉼표가 추가되어있는 문자열을 `replacingOccurrences`를 이용하여 제거하는 메소드를 구현
    - 계산이 되었는지 안되었는지 상태를 나타내는 프로퍼티(`hasCalculated`)를 추가하여 다양하게 활용.
- 코드 내부 가독성을 위해 고민했던 것
    - ViewController를 extension을 활용하여 분리해보았다. 주석예약어 `// MARK:` 도 같이 활용해보았다.
    - 계속 옵셔널 바인딩 처리가 필요한 `Label.text`는 연산프로퍼티를 활용하여 코드 내부를 개선해보았다.
    - 가독성을 위해 `+=` 연산자 사용을 하지않았다. 풀어서 쓰는게 좀더 가독성이 좋을 때가 있다는 생각이 들었다.
    - StackView 내부에 있는 UILabel의 text를 joined하는 메서드를 UIStackView를 extension하여 프로퍼티(toString)로 만들어주었다.
    사용하면 `stackView.toString` 와 같은 결과가 되서 좀더 직관적일 수 있도록 구현해주었다.
    - 중복, 반복되는 부분은 메소드로 분리해주는 리팩토링을 진행했다.
    - 조건문을 변수로 만들어주어 메소드 내부 가독성을 향상시켰다.

## 3-2 의문점

- Stack View의 subview들을 꺼내서 사용할 때 방법은 반복문 밖에 없는걸까?
- NumberFormatter에는 string으로 변환해주는 메소드도 있지만 NSNumber로 변환해주는 메소드도 있는데.. 꼭 사용해야할까?

## 3-3 Trouble Shooting
### 1. 자동 스크롤 구현해보기

- `상황`
    - 스크롤 뷰의 콘텐츠 뷰 원점을 설정하는 메소드를 활용해보았다.
    
    ```swift
    let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
    scrollView.setContentOffset(bottomOffset, animated: false)
    ```
    
    - 그러나 스크롤 바가 생길때 약간 움직이면서 스크롤이 안되는... 이상해보이는 애니메이션을 취하는 문제가 발생했다.
    
    ![https://i.imgur.com/v4OYFOe.gif](https://i.imgur.com/v4OYFOe.gif)
    
    - 이 문제를 해결해보기 위해서 1차적으로 구글링을 통해 찾아보았고, 찾는데 어려움이 있어 3기 캠퍼 선배분들에게도 질문해보았지만 해결방법을 찾지 못했다.
- `이유`
    - 3기 캠퍼 `수박`의 도움으로 LLDB를 활용하여 처음 y좌표가 어떤 값으로 찍히는지 확인해보았으나, StackView가 추가되고 난 후 업데이트 되어 y값 좌표가 계산이 되어야 하는데, 버튼을 누르기 이전의 y좌표가 찍히는 것이 확인되었다.
    - 타이머나 비동기적으로 해당 부분을 해결해보려고 해보았으나 발만 담궈봤지 제대로 배워보지 않은 지식이라 해결하는데 많은 어려움이 있었다.
    - 이후 서포터즈 `Wody`에게 질문해보았고 얼마 지나지 않아 해결을 할 수 있게 되었다.
- 정상적으로 하단으로 자동 스크롤이 되는 모습

![https://i.imgur.com/uUW8GWB.gif](https://i.imgur.com/uUW8GWB.gif)

- `layoutIfNeeded()`라는 메소드를 활용하여 해결하게 되었다. (`도움을 주신 갓wody에게 감사의 인사를 드립니다.`) 이 메소드는 `setNeedsLayout()`과 같이 수동으로 layoutSubviews를 예약하는 행위이지만 해당 예약을 바로 실행시키는 동기적으로 작동하는 메소드다. update cycle이 올 때 까지 기다려 layoutSubviews를 호출시키는 것이 아니라 그 즉시 layoutSubviews를 발동시키는 메소드다.
- 만일 main run loop에서 하나의 View가 setNeedsLayout을 호출하고 그 다음 layoutIfNeeded를 호출한다면 layoutIfNeeded는 그 즉시 View의 값이 재계산되고 화면에 반영하기 때문에 setNeedsLayout이 예약한 layoutSubviews 메소드는 update cycle에서 반영해야할 변경된 값이 존재하지 않기 때문에 호출되지 않는다.
- 이러한 동작 원리로 `layoutIfNeeded()`는 그 즉시 값이 변경되어야 하는 애니메이션에서 많이 사용된다고 한다.
- `해결`
    - 따라서 스크롤뷰의 원점에 대한 콘텐츠뷰의 오프셋 설정을 해주기 전에 `layoutIfNeeded()` 메소드를 호출하여 layout을 업데이트 하고 setContentOffset을 설정해주었더니 해당 문제에 대해서 해결되었다.
    
 ### 2. 커스텀 뷰를 만들어보기

- `상황` **스택뷰 > 스택뷰 > 레이블** 계층을 가진 부분에서 레이블의 텍스트를 꺼내려면 `arrangedSubviews`를 `이중 for문`을 돌면서 가져와야 하는 상황이 마음에 안들었다.
    
    ```swift
    extension UIStackView {
        var toString: String {
            var inputValues = [String]()
                    self.arrangedSubviews.forEach{ view in
                let subview = view as? UIStackView
                subview?.arrangedSubviews.forEach{ view in
                    let label = view as? UILabel
                    guard let input = label?.text else {
                        return
                    }
                    inputValues.append(input.replacingOccurrences(of: ",", with: ""))
                }
            }
            return inputValues.joined(separator: " ")
        }
    }
    ```
    
- `해결방향` 리뷰어인 엘림에게 조언을 구해서 `스택뷰 > 커스텀뷰` 계층을 가질 수 있도록 커스텀뷰 만들기에 도전해보았다.
- `결과`
    
    ```swift
    extension UIStackView {
        var toString: String {
            var inputValues = [String]()
            self.arrangedSubviews.forEach { view in
                guard let formualStackView = view as? FormulaStackView else {
                    return
                }
                inputValues.append(contentsOf: formualStackView.element)
            }
            return inputValues.joined(separator: " ")
        }
    }
    ```
    
- `FormulaStackView`라는 커스텀 뷰를 만들어 줌으로써 이중 for문을 돌던 문제도 해결이 되었고, ViewController에서 스택뷰 내부에 `Label을 추가`해주는 부분도 커스텀뷰 내부에서 해결할 수 있게되었다.

### 3.  스크롤 바로 인해 내부 Label의 Text가 가려지는 문제

![Untitled](https://user-images.githubusercontent.com/49546979/142418073-e9de7219-2754-482e-9f7d-ad3f77633c48.png)

- `상황` 계산내역이 쌓여서 스크롤바가 생기는 문제로 스크롤을 진행할 시 글씨가 가려지는 문제가 있었다.
- `해결방향` 스크롤바를 가릴 수 있는 방법이 없는지 구글링을 통해서 찾아보았다.
- `결과`
- 찾아보니 인터페이스 빌더에서도 설정을 해줄 수도 있고 코드로도 해당 문제를 해결할 수 있었다.
    - 코드로 설정하기
        
        ```swift
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        ```
        
        - 인터페이스 빌더에서 없애기
        
        ![https://i.imgur.com/rOkoBw3.png](https://i.imgur.com/rOkoBw3.png)
        
        위 사진에서 체크를 풀어주면 된다.
        

### 4. 버튼의 모양을 둥글게 만들기

`상황` 엘림에게 버튼을 둥글게 만들어보는 도전과제를 받게되어 해결해보기로 하였다.

`시도-1`  처음에는 버튼 자체가 코드가 아닌 스토리보드에서 생성된 버튼이라서 인터페이스 빌더로 해결해보고자 하였다.

```swift
    extension UIView {
        @IBInspectable var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
    }
```

- 그러나 이 방법으로는 버튼의 cornerRadius를 직접 대입해주는 방식이기 때문에 디바이스가 다를 경우 내가 원하는 결과를 얻기에는 힘들다고 판단되었다. 그래서 코드로 해볼 수 있는 방법을 찾아 해결해보았다.

`시도-2` 

```swift
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calculatorButtons.forEach { button in
            button.layer.cornerRadius = button.layer.frame.size.width / 2
        }
    }
```

- 버튼의 너비 / 2를 해서 cornerRadius를 설정해준 코드다. 이때 `viewWillLayoutSubviews` 메소드를 써준다.

### `viewWillLayoutSubviews()`

- 뷰의 바운드가 최종적으로 결정되는 최초 시점
- 제약이나 오토레이아웃을 사용하지 않았다면, 서브뷰의 레이아웃을 업데이트하기 적합한 시점이다.
- 여러번 중복으로 호출될 수 있다.
    - 메인뷰의 서브뷰가 로드되는 경우
- 메소드를 알아보고 엘림의 피드백을 받고 다시 디버깅을 해보니 `버튼이 클릭이 되는 시점`마다 해당 메소드가 호출이 되고있었다.  cornerRadius를 잡아주는 for문이 버튼이 누를때마다 실행되고 있었던 것이다. 즉 SubView의 레이아웃을 잡아주기에는 적절치 못한 메소드였다.

`시도-3, 그리고 해결` 

- 버튼의 IBOutlet에 didSet을 줄 수도 있었지만 아래와 같은 문제 때문에 해당 방법은 불가능 했다.
    
   ![](https://i.imgur.com/TGNgcJQ.png)
    
- 디버깅을 해보니 `viewWillLayoutSubviews` 메소드가 호출되는 시점에 레이아웃이 갱신되어 버튼의 너비가 바뀌고 있었다.
(디바이스는 아이폰 SE 기준이다. SE 이상 디바이스에서는 없던 문제였다.)
IBOutlet의 didSet은 `viewDidLoad가 호출되기 전`에 호출되므로 적절하지 못한 방법이였다.
- 따라서 최소한으로 적게 호출되는 `updateViewConstraints`메소드를 활용하여 해당 문제를 해결하였다.
    
    ```swift
    func setupButtons() {
        calculatorButtons.forEach { button in
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.layer.bounds.width / 2
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setupButtons()
    }
    ```
    
- updateViewConstraints에 버튼셋팅 메소드를 호출하고있고, for문 내부에서 버튼마다 `layoutIfNeeded`를 호출하여 레이아웃을 갱신하고 이후 cornerRadius 값을 대입해주고있다.
- 레이아웃을 갱신하는 이유는 갱신하지 않으면 위 디버깅시 발견하였던 최종 레이아웃이 아니라 임의로 잡혀있던 frame값으로 계산을 하기 때문에 아래처럼 찌그러진 원이 나온다.
    
   ![](https://i.imgur.com/7Qr05cE.png)
    
`결론`

- viewDidLoad에서 frame사이즈가 정확하지 않을 수 있다. 해당 함수는 뷰는 로드됐다고 확인할 수 있지만, 배치가 됐다고 할수는 없다. 따라서 위와 같은 현상은 viewDidLoad에서 임의로 잡혔던 frame값이 `viewWillLayoutSubviews`가 호출하면서 하위 뷰가 배치되고 이후 값이 변했다고 볼 수 있겠다. 따라서 하위뷰가 배치가 되고나서 버튼의 레이아웃을 잡아줘야 해결이 가능했던 것이다.

### 여기서 의문점이 드는 것은 다른 디바이스들은 상관없는데 왜 SE에서만 버튼의 크기가 줄어드는 것일까?

- 3기 캠퍼 `수박` 의 도움으로 해당 의문점을 풀 수 있었다.

![https://i.imgur.com/MiyseWl.png](https://i.imgur.com/MiyseWl.png)

- HIG에서 장치들의 치수를 확인해서 세로를 보면 200~300정도 차이가 나는 것을 확인할 수 있다.
사진에서도 볼 수 있듯이 세로 크기가 엄청 차이난다.
따라서 작아진 디바이스에 오토 레이아웃을 충족하기 위해 버튼의 크기를 줄일 수 밖에 없다는 추측이 가능해졌다.
- 이러한 사실을 증명해낼 수도 있다. 직접 레이아웃을 다 계산하여 치수와 맞는지 확인할 수도 있지만... 나중에 시도해봐야겠다. 😇

### 🤩 `수박`에게 답변받는 와중에 받았던 조언

- didSet으로 UI 요소들의 레이아웃을 잡아주는건 부자연스럽다. 오히려 지금처럼 view가 배치된 후 레이아웃을 잡아준 것이 자연스럽고 좋은 방법이다.
- 그리고 UI 인스턴스를 생성할때 클로저로 선언하는 방법이 있고, 인스턴스로 선언 이후 값을 변경해줄 수도 있다.
- 선언 이후 값을 변경해주는 방법은 문맥상 부자연스러울 수 있으므로 지양하는게 좋은 것 같다는 의견.
    - let으로 선언후 값을 변경해주는 거니까 부자연스럽다는 늬앙스!
    - 애초에 클로저로 선언하여 요소의 속성들을 설정해주고 그대로 쭉 사용하는게 더 자연스럽다!

## 3-4 배운 개념

- 코드로 UI를 그려보는 방법
- `Stack View`
    - 코드로 Stack View의 layout을 잡는 방법
- `Scroll View`
    - 스크롤 바 없애는 방법
- `layoutIfNeeded()`활용
- `NumberFormatter`
- `LLDB`
- `super.viewDidLoad()`
- `protocol LocalizedError` 용도
- `@IBInspectable`
- `viewWillLayoutSubviews()`
- 커스텀뷰를 만드는 방법 (only Code)
    - `init(frame:)`와 `init(coder:)`의 차이점
- `View Life Cycle`의 대한 깊은 이해
- `frame`과 `bounds`의 차이점
- `IBOutlet`의 `didSet`은 언제 `trigger`되는지?

## 3-5 PR 후 개선사항

- 동일한 return을 하는 guard문을 합쳐서 개선
- 스크롤바 때문에 가려지는 문제 해결
- 주석위치와 줄바꿈으로 코드 내부 가독성 개선
- 중복되는 부분 메소드로 분리하여 개선
- toggle 사용으로 가독성이 떨어지는 부분을 직접 대입해주는 방식으로 개선
- LocalizedError 프로토콜을 활용하여 description을 좀 더 직관적으로 확인할 수 있게 개선
- 커스텀 뷰를 만들어서 ViewController 내부 코드 개선

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#목차-1)


</div>
</details>
