

# RxSwift를 왜 사용할까? 🤔

RxSwift는 함수형 프로그래밍인 **Swift** 에 반응형 프로그래밍을 더해주는 라이브러리  <br>
<br>
✔️ 반응형 패러다임이 제공하는 명확함, 비동기를 동기화된 것처럼 작성이 가능 <br>
✔️ 일관성이 없는 비동기 코드를 하나의 비동기 코드로 개발이 가능  <br>


이렇게 Rx로 일관된 코드를 작성하면서, <br> 확장이 불가능한 아키텍쳐 패턴을 해결할 수 있고 서로 다르게 구현한 로직을 조합하기 쉬워짐 <br>
<br>
\
무엇보다도 !! <br>일단 **Thread 처리가 쉬워짐** <br>

만약 Rx를 사용하지 않는 다면 <br>
A라는 값을 받아와야 B라는 값을 받아올 수 있고, B라는 값을 받아와야 C라는 값을 받아올 수 있고 C를 받아와야 D라는 값을 받아올 수 있음 <br>

이런 상황을 바로 🔥콜백(callback) 지옥🔥  이라고 함  <br>

Rx를 사용한다면 서로 다르게 구현한 로직을 조합하기 쉬워지기 때문에 이 콜백 지옥에서 탈출🏃🏻‍♀️할 수 있게 됨  <br>
따라서 UI이벤트, 네트워크 처리 등의 데이터를 갱신했을 때의 처리가 쉬워짐   <br>

---

<br>

# Cocoa and UIkit asynchronous APIs 
애플에서 제공하는 많은 API 중에 비동기적인 코드를 구현할 수 있도록 도와주는  API가 많습니다.


* NotificationCenter

* The Delegate pattern

* Grand Central Dispatch (GCD)

* Closures 


하지만,,, 기본적으로 제공되는 API에는 한계점이 있습니다.
여러 외부 요인들로 인해서 코드가 다르게 실행된다는 것이죠... 

외부 요인들 중에는 사용자 input, network, 다른 OS event.. 등이 있음



<br>

--- 




# 비동기 관련 프로그래밍 용어

### 1. State, and specifically, shared mutable state
**💡  State <br>**

상태란 특별히 뭐라고 정의할 수 없지만... "상태"를 이해하기 위해 예를 들어봅시다. <br>
컴퓨터를 오랫동안 켜놓으면 꺼질 수 있지만 S/W와 H/W는 처음과 같은 상태죠!


상태(state)를 바뀌게 한 것은 "memory"인것이죠 ! 

<br>

### 2. 명령형 프로그래밍 (Imperative programming)
* 명령형 프로그래밍은 프로그램의 상태를 변화 시킴.
* 명시적 코드는 일반적으로 짰던 프로그램 방식 run(), getInstance()같은 컴퓨터에게 알려주는 프로그램
* 아래에 같은 경우 순서를 바꾸면 전혀 다른 메소드가 됨 -> 비동기적인 어려움 
```
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        setupUI()
        connectUIControls()
        createDataSource()
        listenForChanges()
    }
```
<br>

### 3. Side Effects를 통해 state 파악 <br>

Side Effects는 어떤 함수를 호출했을 때, <br> 
그 함수의 return 값 이외에
호출된 함수 밖에서 프로그램의 상태변화가 발생하는 것을 의미합니다. 


<br>

### 4. Declarative code (선언적 코드)
- 절차지향 프로그램과 함수형 프로그램의 균형성을 갖춘 형태가 RxSwift  <br> 
선언적 코드는 이벤트가 일어날 때 그 데이터에 대한 처리가 가능하며, <br> 
for loop와 같은작업도 역시나 가능함  <br> 
<br> 
 

---
<br>

# Rx Code의 3요소 
Rx Code의 3가지 building block(구성요소)인 <br>
observables(생산자), operators(연산자), schedulers(스케쥴러)를 알아보자. <br>
<br>

## 💡observables(생산자)

✔️ Observable은 RxSwift의 핵심적인 개념으로써, <br>
  이벤트를 시각적인 흐름에 따라 전달하는 전달자 역할을 함
  
✔️ 즉, Observable은 관찰 가능한 🌈 **데이터흐름**🌈 이라 볼 수있음 
  <br> 데이터가 흐를 때마다 해당 데이터를 캐치할 수 있으면 그 데이터에 맞는 행동을 함 
 
 
✔️ `Observables<T>` 클래스는 Rx코드의 기반임

✔ `T` 형 데이터 snapshot을 전달할 수 있는 일련의 이벤트를 비동기적으로 생성하는 기능

✔ 객체에 이벤트나 값 추가, 수정 등과 같은 것을 가능하게끔 해줌 

✔ Observables의 이벤트 종류에는 next, completed, error 가 있음

`next` : 최신(또는 다음)데이터를 **전달**하는 event 

`error` : Observable이 에러를 발생하였으며, 추가적으로 이벤트를 생성하지 않을 것임을 의미 (에러와 함께 완전종료) 

`completed` : 성공적으로 일련의 이벤트들을 종료시키는 이벤트.  <br>
즉, Observable이 성공적으로 자신의 생명주기를 완료했으며, <br> 추가적으로 이벤트를 생성하지 않을 것임을 의미 







<br>
<br>
 
 
 
## 💡operators(연산자)  
Observable을 생성하고 변형하고 합치는 등
다양하게 연산을 할 수 있도록 도와주는 `Operator`라는 것이 있음

<br>



가장 먼저 Observable을 생성하는 Operator를 알아보자 ‼️
### ✔️ create 
가장 기본으로 Observable 생성
```
    let observable = Observable<Int>.create{ (observer) -> Disposable in 
        observer.onNext(11)
        observer.onCompleted()
        return Disposable.create()
    }
```

### ✔ just
`just`를 사용하면 특정항목을 하나만 간단하고 쉽게 생성할 수 있음
```
    let justObservable = Observable.just(1)

```
<br>


### ✔ from
`from`은 `just`와 같이 간단하고 쉽게 생성할 수 있음

하지만 `just`는 한번에 모든 결과를 방출하는 반면 

`from`은 결과를 하나씩 방출
```
    let fromObservable = Observable.from([1,2,3,])
    // 1
    // 2 
    // 3

```

<br>


### ✔ of
`of`는 `just`처럼 [1,2,3] 배열을 한번에 방출할 수도 있고

`from`처럼 각각의 원소를 하나씩 방출할 수도 있음 

하지만 원소를 하나씩만 방출하려면 배열을 사용하면 안됨
```
    let ofObservable = Observable.from(1,2,3,).subscribe{print($0)}
    // 1
    // 2 
    // 3

```
```
    let ofObservable = Observable.from([1,2,3,]).subscribe{print($0)}
    // 1,2,3

```

<br>


예시)
showAlert와 같이 Observable에서 나온 결과를 Rx연산자를 사용하여 경고문(side effect) 발생
```
 UIDevice.rx.orientation
  .filter { value in
    return value != .landscape // 가로가 아닌 값만 통과 
  }
  .map { _ in
    return "Portrait is the best!" // 문자열을 리턴 
  }
  .subscribe(onNext: { string in
    showAlert(text: string) // 위에서 string 받아서 alert 실행 
  })
```


<br>
<br>

## 💡schedulers(스케쥴러)
기존에 사용하던 DispatchQueue와 기능이 동일함.
다만 훨씬 더 강력하고 쉽습니다.
RxSwift에는 여러가지의 스케쥴러가 이미 정의되어있으며, 99%정도 사용가능하므로 
개발자가 자신만의 스케쥴러를 생성할 일은 없을 것입니다.

RxSwift덕분에 동일한 subscribe 작업에 다른 스케쥴러에서 스케쥴링을 할 수 있습니다. 
RxSwift는 subscribe(왼쪽) 과 scheduler(오른쪽) 사이에서 전달하는 역할을 할 것입니다. 
![Scheduler](https://user-images.githubusercontent.com/94977962/145681307-f7005524-2570-4038-8964-c314832dfdee.png)

위에 다이어그램에서 보셔야할 것은
여러 스케쥴러에서 색칠된 작업 1,2,3,....을 순서대로 수행하시면 됩니다! <br>
- network subscription은 1로 표시된 Custom NSOperation Scheduler에서 구동됨
- 출력된 데이터는 다음 블록인 background Concurrent Scheduler의 2로 가게 됨
- 이후, UI작업은 Main Thread Serial Scheduler에서 처리됨


<br>

|RxSwift|	Normal|
|---------|--------------|
Main Thread Serial Scheduler|	Main thread scheduler|
Background Concurrent Scheduler|	concurrent Background GCD queue
Custom NSOperation SCheduler|	custom OperationQueue-based scheduler



---
# RxCocoa
RxCocoa란 UIKit 및 Cocoa개발을 지원하는 클래스를 보유하고 있는 RxSwift동반 라이브러리
- 다양한 UI구성요소에 대한 반응형 확장(reactive extensions)기능을 추가하여 UI이벤트를 추가 가능함


ex) UISwitch에서의 Rx
```
toggleSwitch.rx.isOn {
    .subscribe(onNext: { isOn in
        print(isOn ? "It's On" : "It's OFF")
    })
}
```
