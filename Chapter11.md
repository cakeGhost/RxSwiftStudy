<br>

# 1. Buffering Operators

### 1) share(replay:), share(replay: scope:)

과거의 이벤트들을 subscriber에게 Emit

- replay 파라미터 : 버퍼 사이즈 (얼마만큼의 element를 새로운 subscriber에게 emit할 건지)
- scope 파라미터 : subscriber의 수가 1에서 0으로 될 때 동작
- .whileConnected : 공유되고 있던 stream의 cache 삭제
- .forever : stream의 cache를 삭제하지 않음

# 2. Time-shifting operators

이벤트 emit에 delay를 시킬 수 있는 연산자

### 1) delaySubscription(_: scheduler:)

딜레이 동안 

```swift
_ = sourceObservable
			.delaySubscription(delayInSeconds, scheduler: MainScheduler.instance)
			.subscribe(delayedTimeline)
```

<img width="300" alt="delay" src="https://user-images.githubusercontent.com/94977962/147925096-ab9991b0-3150-4b08-85ac-79043ff2df78.png">


<br>

<br>


### 2) delay(:scheduler:)

```swift
_ = sourceObservable
			.delay(delayInSeconds, scheduler: MainScheduler.instance)
			.subscribe(delayedTimeline)
```


<br>

<br>


# 3. Timer operators

emit되는 시간 간격을 설정할 수 있음

<br>

### 1) interval(:scheduler:)

interval은 .dispose()를 사용해서 멈추게 할 수 있음

```swift
let sourceObservable = Observable<Int>
			.interval(RxTimeInterval(1.0 / Double(elementsPersecond)), scheduler: MainScheduler.instance)
			.replay(replayedElements)
```

<br>


### 2) .timer(:scheduler:)

emit 시점을 정할 수 있음

```swift
_ = Observable<Int>
	.timer(3, scheduler: MainScheduler.instance) .flatMap { _ in
	sourceObservable.delay(RxTimeInterval(delayInSeconds), scheduler: MainScheduler.instance)
	} .subscribe(delayedTimeline)
```

<br>

### **3) .timeouts(:other:scheduler:), timeout(:other:scheduler)**

제한시간을 걸어두는 것

(5초 안에 버튼을 누르면 특정 기능 실행)

```swift
let _ = button .rx.tap
	.map { _ in "•" }
	.timeout(5, scheduler: MainScheduler.instance) 
    .subscribe(tapsTimeline)
```

에러처리는 `do(onError: { error in ...})`에서 RxError.timeout케이스인 경우로 처리


```swift
let _ = button .rx.tap
	.map { _ in "•" }
	.timeout(5, scheduler: MainScheduler.instance) 
    .do(onError: { error in 
      if case .timeout = error as? RxError {
        // 타임아웃 에러 처리
      }
      print(error)
    })
    .subscribe(tapsTimeline)
```

(제한 시간이 다 되었을 때 error말고 다른 이벤트를 삽입하려면 other파라미터에 추가)

```swift
.timeout(5, other: Observable.just("X"), scheduler: MainScheduler.instance)
```
