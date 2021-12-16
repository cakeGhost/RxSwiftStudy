### 💡 ch 2,3,4 (12/13 ~ 12/19)


# ✔️ Chapter 2: Observable

###  **Observable**

observable이 대체 뭘까...?

우리는 observable, observable sequence, sequence ... 등을 들어 봤을 건데 

하지만 이것들 모두 observable 

> observable is just a sequence, with some special powers.
> 

observable은 하나의 seqeunce이고, 여러가지 강점을 갖고 있습니다.

특별한 능력 중 하나는, 바로 **async 하다는 것** ~~!~~!~!

그리고, Observable이 이벤트를 발생시키는 것을 **emit** 한다고 표현

(이벤트들은 사용자의 tap, gesture 또는 숫자, 인스턴스 등을 포함)

그림을 한번 보자 👀이 그림은 하나의 sequence를 의미한다.

![https://user-images.githubusercontent.com/94977962/145962615-a8621627-7ceb-441c-9176-eef81a38cf7d.png](https://user-images.githubusercontent.com/94977962/145962615-a8621627-7ceb-441c-9176-eef81a38cf7d.png)

- 가로로 긴 화살표 : 시간의 흐름
- 동그라미 숫자 1,2,3 : 발생하는 이벤트

‼️ sequence의 lifetime동안 이벤트는 언제라도 발생할 수 있음

(참고로 여기서 발생한 1,2,3은 next이벤트에 해당됨)

## **Emitting**

observable은 순서에 따라 emit되는 구조를 가짐

> emit : 분출하다, 방출하다
> 

말 그대로 observable에서

이벤트1, 이벤트2, 이벤트3이 순서대로 생성되는 것을 emit이라고 함

## **Lifecycle of an observable**

sequence의 라이프 사이클동안 3개의 tap이벤트가 발생했고 오른쪽에 | 표시가 있음

![https://user-images.githubusercontent.com/94977962/145963116-e5cc8471-912d-4513-a7ca-a764a41eb390.png](https://user-images.githubusercontent.com/94977962/145963116-e5cc8471-912d-4513-a7ca-a764a41eb390.png)

| 표시는 completed 이벤트에 해당

즉, 이 그림은어떤 view를 사용자가 3번 tap한 뒤, view가 dismiss 되었을 때를 가정해볼 수 있음 

completed이벤트가 발생하면 sequence가 종료되고,더 이상 어떤 이벤트도 발생하지 않음

하지만!!!!

가끔 sequence에서 에러가 발생할 수 있음

또 다른 그림을 살펴보면  👀

![https://user-images.githubusercontent.com/94977962/145963960-e27e3cea-1c9f-4af1-bf1e-10e41ea269ae.png](https://user-images.githubusercontent.com/94977962/145963960-e27e3cea-1c9f-4af1-bf1e-10e41ea269ae.png)

위 그림과 달리 X표시는 sequence에서 error 이벤트가 발생했다는 의미

error 이벤트도 completed이벤트와 마찬가지로 sequence가 종료되고,

이 sequence에서는 더 이상 이벤트가 발생하지 않음 

## **🌈 정리**

- Observable은 라이프 타임에 걸쳐 값을 포함하는 next 이벤트를 발생시킴
- 라이프 타임 중, 오류가 발생하면 error 이벤트를 발생시킴
- 라이프 사이클이 정상적으로 완료되면, completed 이벤트를 발생시킴
- 한번 종료된 sequence에서는 더 이상 이벤트가 발생하지 않는다.
- 

`next` : 구성요소를 계속해서 방출시킬 수 있는 기능 (= observable 구독자에게 데이터 전달)

`completed` : 이벤트를 종료시킬 수 있는 기능 (= observable 구독자에게 완료되었음을 알림)

`error` : 이벤트에 오류가 있음을 알고 중간에 종료시킬 수 있는 기능 (= observable 구독자에게 오류를 알림

코드를 통해 살펴보면 

```swift
public enum Event<Element> {
    case next(Element)
    
    case error(Swift.Error)
    
    case completed
    
}
```

enum Event는 3가지의 case를 갖고있고,

그 중에 next에는 Element에 해당하는 값이 동반되고,

error에는 Swift의 에러 타입 인스턴스를 갖고 있는 것을 확인할 수 있음!!!! 

## Creating observables

코드를 통해 알아보자...

### .just()

```swift
// 3개의 Int타입의 프로퍼티를 생성 
let one = 1
let two = 2
let three = 3

// Int 타입 sequence를 나타내는 observable이 하나 생성됨
let observable: Observable<Int> = Observable<Int>.just(one)
```

- just메소드는 하나의 파라미터를 받아, 한개의 이벤트를 발생시킴
- just메소드는  Observable의 클래스 메소드이고,

딱 한개의 인자만 받아서 1개의 요소를 갖는 Observable을 생성함

```swift
let observable1 = Observable.just(1)

observable1.subscribe { event in
    print(event)
}

// next(1)
// completed
```

observable1을 구독(subscribe)하니 1이 나오고 완료 메시지가 나옴 

### .of()

```swift
let observable2 = Observable.of(one, two, three)
```

of 메소드는 Int타입을 명시하지 않음. Swift의 타입추론이 됨

🚨 **주의**

```swift
let observable2 = Observable.of(1,2,3)
observable2.subscribe { event in
    print(event)
}

// next(1)
// next(2)
// next(3) 
// completed
```

```swift
let observable2 = Observable.of([1,2,3])
observable2.subscribe { event in
    print(event)
}

// next([1,2,3]
// completed
```

### .from()

```swift
let observable3 = Observable.from([one, two, three])
```

from 메소드는 array타입을 전달받아, array안에 요소들을 꺼내서 sequence를 생성함

즉, observable3은 Observable<Int>타입에 3개 이벤트를 발생시키는 Sequence

```swift
let observable3 = Observable.from([1,2,3,4,5])
observable3.subscribe { event in 
    print(event)
}

// next(1)
// next(2)
// next(3)
// next(4)
// next(5)
// completed
```

```swift
observable3.subscribe { event in
	if let element = event.element {
     print(element)
  }
}

// 1
// 2
// 3
// 4
// 5
```

from은 배열의 요소를 방출함.

위에코드를 더 간단하게 만들어보자

```swift
observable3.subscribe(onNext: { element in 
    print(element)
})
```

이 코드는 next이벤트에만 핸들링하고 있음

next이벤트가 발생하면 그 안에 있는 element를 출력함

—> `onNext` 클로져에서 element를 전달해주기 때문에 
      따로 element를 꺼내 바인딩하는 작업이 필요없음 ! 굳 👍🏼

## Disposing and Terminating
Observable은 subscribe가 있기 전까지 아무일도 하지 않는다..
Subscription이 있어야 비로소 Observable은 이벤트를 발생시키고
complete 또는 error이벤트가 발생하기 전까지 
계속 next 이벤트를 발생시킴 ! 


🚨  **완전 주의** 

```swift
let subscription = obsrvable3.subscribe(onNext: { element in
    print(element)
})

subscription.dispose()

// 1
// 2
// 3
// 4
// 5
```

observable은 옵저버가 계속 구독하기 때문에 **메모리 누수**가 생길 수 있음 

따라서 완료 후에는 dispose를 해줘야함 

subscription을 명시적으로 중단하기 위해 .dispose()를 호출함

→ subscription이 중단되면, Observable은 더 이상 이벤트를 발생시키지 않음.

## DisposeBag

생성하는 subscription마다 계속 dispose를 관리해줘야함?;;;

너무.. 귀찮고 리스크가 있음...

그래서 `DisposeBag`이란 타입이 있음 

말 그대로 `Disposable` 타입을 담을 수 있는 클래스임 

subscribe()의 리턴타입인 Disposable에서 disposed(by:)메서드를 호출하면 사용할 수 있음

DisposeBag에 담긴 Disposable들은 DisposeBag이 dealloc될 때, 같이 dealloc됨 

```swift
example(of: "DisposeBag") {
    // dispose 생성
    let disposeBag = DisposeBag()

    // Observable 생성
    Observable.of("A", "B", "C") 
        .subscribe {    // 생성한 Observable을 subscribe
           print($0)
    }
    .disposed(by: disposeBag) // subscribe 리턴 값을 disposeBag에 담음 
}
```

## Dispose 사용하는 이유

dispose() 호출 하거나

disposeBag에 담는것을 깜빡하거나

Observable이 어디선가 의도치않게 종료되면 

→ Memory Leak 발생 할 수 있음 

## 갑자기 Create 연산자

Observable next이벤트를 만들 때 

`Observable.of(1,2,3)` 이렇게 생성함 

근데 create연산자를 이용할 수 있음 

```swift
Observable<String>.create { observer in

    observer.onNext("1")   // Observer에게 next이벤트를 발생시킴 (전달되는 element는 1)

    observer.onCompleted()  // Obsrver에게 completed 이벤트를 발생시킴 

    observer.onNext("?")    // 다시한번 next이벤트 발생시킴 

    return Disposables.create()  // disposable 리턴 

}
