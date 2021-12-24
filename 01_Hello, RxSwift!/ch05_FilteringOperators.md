이번 챕터에서는 Filtering Operator를 사용하여 `.next` 이벤트에 조건을 추가할 것임 

조건을 추가하면, 발생하는 모든 이벤트가 아니라

원하는 이벤트만 받을 수 있음 

<br>
<br>


## **Ignoring operators**

이름에서 유추할 수 있듯이 모든 `.next` 이벤트를 무시한다.

다만, 종료 이벤트는 전달함! (complete 나 error)

결론적으로 시퀀스가 종료되는 시점만 알 수 있게 되는 것 

![ignoreElements](https://user-images.githubusercontent.com/94977962/147309666-518c4d7c-5a51-4968-8029-73be3a4e21db.png)


그림에서 위에 있는 화살표에서 1,2,3 이벤트가 발생하고 있음

근데 이 이벤트는 ignoreElemenets()에 걸려서 통과하지 못하고 있음

결국, subscribe하고 있는 아래 라인에서는 어떤,,이벤트도 받지 못함,,, 

하지만 점선 화살표를 보았을 때 sequence가 종료되는 이벤트는 전달이 되고 있음을 알 수 있음

코드를 통해서 알아보자 

<img width="398" alt="ignore_code" src="https://user-images.githubusercontent.com/94977962/147309676-b42faa78-e2c0-42fc-b4ac-4238b2ba1fa3.png">


strikes 라는 Sequence에 ignoreElements()가 호출되고 이를 subscribe하고 있음

“X” next 이벤트가 3번이나 발생하지만, print문은 실행되 지 않음..

completed 이벤트가 발생해야 비로소 print문이 수행되는 것을 확인함 

<br>
<br>


## elementAt

Observable에서 발생하는 이벤트 중 n번째 이벤트만 받고 싶을때 사용

코드를 보면

<img width="229" alt="strike" src="https://user-images.githubusercontent.com/94977962/147309714-2a119444-92b0-4b48-b97d-f7437228a496.png">


strikes를 subscrieb했지만 2번째 이벤트에만 반응

0번째, 1번째 이벤트는ellement가 걸러주기 때문에  !!

<br>
<br>


## Filter

filter는 Bool을 return하는 클로저를 받아서 모든 Observable 이벤트를 검사함

클로저를 true로 만족시키는 이벤트만 filter를 통과하게 됨 

<img width="412" alt="filter" src="https://user-images.githubusercontent.com/94977962/147309733-32e368e7-10a9-4c50-8345-2f35379e5bc9.png">


위 sequence에서 1,2,3에 해당하는 이벤트가 발생하고 있음 

이 시퀀스에 { $0 < 3 }이라는 filter를 걸었음

즉, emit할 값에 대한 조건을 명시적으로 설정

코드를 통해 알아보자 

<img width="285" alt="filter_Code" src="https://user-images.githubusercontent.com/94977962/147309780-920e446b-d746-45b9-b3a3-2b7a37df33cb.png">


1. 6개의 Int타입 이벤트를 발생시킴
2. filter를 걸고, filter로 전달된 클로져에서 이벤트의 Element가 짝수 인지 검사
3. filter된 이벤트들을 subscribe하여 출력해주고 있음  

---

<br>
<br>


## Skipping operators

특정 수의 요소를 건너뛰어야 할 때 사용

skip 연산자를 사용하면 첫번째부터 매개변수로 전달된 숫자까지 무시할 수 있음 

skip(2)를 사용하는 경우, 처음에 발생한 2개의 이벤트가 무시되고 3만 전달됨 

<img width="437" alt="skipOperator" src="https://user-images.githubusercontent.com/94977962/147309795-3e7aad55-39c0-4220-b8d2-0e9030f1e4f1.png">


코드를 통해 살펴 보자 
<img width="341" alt="sip" src="https://user-images.githubusercontent.com/94977962/147309810-0ed35153-e234-4c09-82ed-cab4371e66e2.png">


1. A B C D E 이벤트가 발생하고 있음
2. skip(3)을 사용하여 첫 3개 이벤트는 무시함 

---

<br>
<br>


## skipWhile

filter와 비슷하지만 

**가장 큰 차이점은 filter은 클로져 검사를 통과하는 Element만 전달되는 반면**,

skipWhile은 **검사를 통과하지 못한 Element를 전달하게 됨** 

코드를 보면 조건은 5보다 작은애들인데, 

skipWhile은 조건을 통과하지 못한애들을 전달하므로

1,2,3,4 가 아닌 5,6,7을 전달한다. 


![스크린샷 2021-12-23 오전 11.57.18.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/81025459-3eda-47eb-9d19-eaaef1f8abab/스크린샷_2021-12-23_오전_11.57.18.png)

---

<br>
<br>


## skipUntil(_:)

지금까지는 static하게 skip하는 경우만 살펴보았음

(static하다는 것은 build 타임에 정의한 클로져를 통한 검사!

예를 들어, 짝수인 경우에 skip한다라는 조건이 있으면 “처음에 발생한 2개의 이벤트는 skip한다”라는 static한 조건)

Dynamic하게 제어하고 싶다면?

Dynamic한 filtering을 제공하는 몇가지 Operator가 있음

그 중 한개가 바로 `skipUtil`이다. 

아래의 그림을 보면 두개의 sequence(화살표)가 있음

하나의 sequence에서 이벤트가 계속 발생하고 있음 (1,2,3 이벤트)

이 sequence에 `skipUtil`을 걸고, 다른 sequence에 전달해주면 어떻게 될까?

→ 결과는 **Trigger sequence의 이벤트가 발생할 때 까지, 원래 시퀀스의 모든 이벤트가 skip 됨** 
<img width="416" alt="skipUntil" src="https://user-images.githubusercontent.com/94977962/147309840-f58ecfea-dafa-4ad5-993a-359b22a2985e.png">


위의 그림을 보면 1,2,3이 발생하고 있는 것을 볼 수 있음

하지만 Trigger의 .next 이벤트가 발생할 때 까지는 skip 해달라는 `skipUtil` 이 걸려있음

따라서 보라색 이벤트(Trigger)가 발생하기 전의 모든 이벤트가 무시됨.

즉, 1이 무시되고 2,3이 전달되고 있음 

```swift
// 이벤트를 발생시킬 PublishSubject 생성
let subject = PublishSubject<String>()

// Trigger역할을 해줄 PublishSubject 생성
let trigger = PublishSubject<String>()

// subject를 subscribe 
subject
    .skip(until: trigger)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

subject.onNext("A")
subject.onNext("B")
trigger.onNext("X")
subject.onNext("C")
```


결과는 trigger 이후의 이벤트

<img width="134" alt="result" src="https://user-images.githubusercontent.com/94977962/147309871-03a36330-f714-4782-91ad-e01ddea8c356.png">



<br>
<br>


# Taking operators

`take`는 skip의 정반대 개념

skip은 처음 발생하는 n개의 이벤트를 무시하는 기능이였다면,

take는 **처음 발생하는 n개의 이벤트만 받고 나머지는 무시함** 

<img width="420" alt="Taking" src="https://user-images.githubusercontent.com/94977962/147309885-09e1a694-a278-4621-ae70-867b45635439.png">



<br>
<br>


## takeWhile(_ :)

~~takeWhile은 skipWhile과 유사함~~

takeWhile에는 클로져가 전달 되고, 

이 클로져는 이벤트의 Element를 검사함

검사를 통과한 이벤트는 전달됨 

만약 검사를 통과하지 못한 이벤트가 있다면, 그 이벤트 포함해서 그 이후의 모든 이벤트가 무시됨 

 

![스크린샷 2021-12-23 오후 2.27.24.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/944014d6-23ce-48c9-9aff-24746846c550/스크린샷_2021-12-23_오후_2.27.24.png)

```swift
Observable<Int>
            .of(1,2,3,4,5,6,7,8,9,10)
            .take(while: {
                $0 < 5
            })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        /*
         1
         2
         3
         4
         */
```

takeuntil은 skipUntil과 유사하다

takeUntil Operator에는 2개의 sequence가 등장한다.

✔️ 데이터 스트림을 발생시키는 sequence와

✔️ trigger의 역할을 하는 시퀀스가 있음 

그림을 살펴보자

![스크린샷 2021-12-23 오후 2.34.30.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/65f3b63e-9a0c-42fc-95b3-ff39e48607c3/스크린샷_2021-12-23_오후_2.34.30.png)

맨 위에 있는 sequence에서 1,2,3 이벤트가 발생하고 있고 takeUntil이 걸려있음

그 아래에 있는 sequence는 Trigger역할을 하는 sequence임.

두번째 이벤트(초록색)가 발생한뒤 Trigger sequence에 .next 이벤트가 발생함

그 이후에 발생하는 모든 이벤트는 무시됨 → 그래서 노란색 3이벤트도 무시됨 

```swift
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject
    .take(until: trigger)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

subject.onNext("1")
subject.onNext("2")
trigger.onNext("X")
subject.onNext("3")
```

![trigger 발생하기 전 ](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/4744bc40-c6c1-4705-91f4-ae885494ec50/스크린샷_2021-12-23_오후_2.40.46.png)

trigger 발생하기 전 

![trigger 발생하고 난 후 ](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f1345e75-494d-4e75-aa90-a8e319067786/스크린샷_2021-12-23_오후_2.40.09.png)

trigger 발생하고 난 후 

**takeUntil은 실전에서 아래  처럼 사용할 수 있음**

```swift
someObservable
    .takeUntil(self.rx.deallocated)
    .subscribe(onNext: {
        print($0)
    })
```

viewController가 deallocated되면 더 이상 이벤트를 받지 않는다는 뜻

(사실 dispose하는게 가장 깔끔한 방법)

<br>
<br>


## distinctUntilChanged

동일한 이벤트가 반복되서 발생할 수 있음

예를 들어 1, 2, 2, 2, 1, 2, 1, 1 이런 이벤트가 발생한다면 

`distinctUntilChanged` Operator를 사용하면 이벤트가 반복되는 것을 방어해줌 

위의 이벤트에 `distinctUntilChanged`를 적용하면 1,2,1,2,1 이벤트가 통과됨 

![스크린샷 2021-12-23 오후 2.47.33.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ff071049-6cba-4a05-a907-41b10df7c55d/스크린샷_2021-12-23_오후_2.47.33.png)

```swift
Observable.of("A", "A", "B", "B", "A")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
        
    })
    .disposed(by: disposeBag)
```

![스크린샷 2021-12-23 오후 2.52.40.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/8db39cac-15e4-4ae8-99ca-a67092cfa9d7/스크린샷_2021-12-23_오후_2.52.40.png)

distinctUntilChanged(_:) Operator에 클로져를 전달하면, 커스텀한 비교 로직을 세울 수 있음

즉, Equatable을 따르지 않는 타입도 비교가 가능

그림을 살펴보자

![스크린샷 2021-12-23 오후 2.55.47.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d7f065ce-fb6a-427e-a50d-cccd358ced33/스크린샷_2021-12-23_오후_2.55.47.png)

위에 있는 sequence 에서 발생하는 이벤트에는 value값이 있음

distnctUntilChanged에 value를 비교하는 로직을 전달하고 있음

```swift
// 1. 숫자를 영어 스펠로 바꿔주는 NumberFormatter 생성
let formatter = NumberFormatter()
formatter.numberStyle = .spellOut

// 2. 10, 110, 20, 200 , 210, 310 이벤트 발생
Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
    // 3. distinctUntilChagned에 클로저 하나 전달
    .distinctUntilChanged { a, b in
        guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
              let bWords = formatter.string(from: b)?.components(separatedBy: " ")
        else {
            return false
        }
        
        var containsMatch = false
        
        // 5. 중복된 단어가 등장하는지 검사
        for aWord in aWords {
            for bWord in bWords {
                if aWord == bWord {
                    containsMatch = true
                    break
                }
            }
        }
        return containsMatch
    }
    // 4. 전달된 이벤트 2개의 스펠을 가져옴 (ten, onehundredten)
    .subscribe(onNext: {
            print($0)
            
    })
    .disposed(by: disposeBag)
```

![스크린샷 2021-12-23 오후 3.04.25.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5695b18b-3321-46e8-8541-c874c5086e59/스크린샷_2021-12-23_오후_3.04.25.png)


---

---

---

<br>
<br>


## Filtering Operators in Practice

검색창에 텍스트를 입력 받음.

텍스트가 입력될 때 마다 

검색어 자동완성을 보여주기 위해 API요청을 해야함

예를 들어, apple을 입력한다고 해봅시다

a를 입력헐 때 , API

b를 입력할 때 API

....총 5번 호출됨 

apple을 입력한다면 apple이 모두 입력된 뒤에 한번만 호출되었으면 좋겠다

할 때 이런 경우에 throttle 사용
