
# ✔️  Ch3: Subjects
Subject는 Observable이 될 수도 있고 Observer가 될 수도 있음

즉, Subject는 observable과 observer의 역할을

모두 할 수 있는 bridge/proxy Observable이라 생각하면 됨

그렇기 때문에 Observable이나 Subject 모두 Subscribe를 할 수 있음

하지만 ‼️

Subscribe하는 방식이 다름

💡 Subject는 여러개의 Observer를 subscribe할 수 있는 multicast 방식

💡 observable은 observer 하나만을 subscribe할 수 있는 unicast 방식

Types of Subjects
Subject에는 종류가 4가지가 있음

Publish Subject : Element가 없는 아무것도 없는 빈 상태로 subscribe를 시작 subscriber는 subscribe한 시점 이후에 발생되는 이벤트만 전달받음

Behavior Subject : Publish Subject와 유사하지만, 초기화 값을 가진 상태로 시작하는 것이 차이점 초기값을 방출하거나, 가장 최신의 (가장 늦은) element들을 새 subscribers에게 방출

   subscribe가 발생하면,

   발생한 시점 이전에 발생한 이벤트 중 가장 최신의 이벤트를 전달받는다.
Replay Subject : BufferSize와 함께 생성 BehaviorSubject와 유사하지만, BufferSize만큼의 최신 이벤트를 전달받음

Variable : BehaviorSubject의 Wrapper라고 보면 된다. BehaviorSubject처럼 작동하며, 더 쉽게 사용하기 위해 만들어짐

# Publish Subject
PublishSubject는 Subscriber가 새로운 이벤트만 전달받으면 되는 경우에 사용하기 좋음

( 즉, Subscribe 이전에 발생했던 이벤트는 전혀 몰라도 되는 경우 )

![publishSubject](https://user-images.githubusercontent.com/94977962/147181815-e349e29e-ab61-43ee-b17f-f0c00e5c069e.png)


✔️ 1번 시퀀스에서 (1)이벤트를 발생하지만 subscriber가 없으므로 이벤트는 emit되지 않음

✔️ 2번 시퀀스가 1번 시퀀스를 subscribe한다. 그리고 (2)이벤트가 발생하고 2번 시퀀스는 이벤트를 전달 받는다.

✔️ 3번 시퀀스가 1번 시퀀스를 subscribe함. 그리고 (3)이벤트가 발생하고 2번 시퀀스와 3번 시퀀스는 이벤트를 전달 받는다.

신문사처럼 subject는 정보를 받고 이걸 subscribers에게 발행하는 역할을 함

example(of: "PublishSubject") {
    let subject = PublishSubject<String>() // 타입을 받고, publish하는 subject를 생
}
subject.onNext("누구 듣고 계신분 있나요..?") // 새로운 element 를 subject에 추가
여기까지 실행했을 시 아무 것도 출력되지 않음

이유는 observers가 없기 때문 !

// subject에 대한 subscription을 생성
let subscriptionOne = subject.subscribe(onNext: { string in print(string)})
여기까지 실행했을 시에도

아무것도 출력되지 않음 ! !

PublishSubject 는 현재의 subscribers에게만 emit하기 때문!!

위에 코드에는 아직 subscriber가 없음..

// subject는 subscriber가 생긴거
subject.on(.next("1"))
이렇게 추가해주니 드디어 subscriber가 생긴거!

당연히 print문도 실행이 된다 그리고 PublishSubject 이므로 타입만 값을 넣어줄 수 있음

# Behavior Subjects
  
Publish Subject과 비슷하지만 차이점은 딱 한개

🔥 PublishSubject : subscribe 이전 이벤트는 전달 받을 수 없음

🔥 BehaviorSubject : subscribe하면 가장 최신 next이벤트를 하나 전달받을 수 있음
  
  
![behaviorSubject](https://user-images.githubusercontent.com/94977962/147181904-a5e80cb8-694f-4dd9-9b2e-9f43a80b3110.png)v

Subscriber가 발생하는 즉시, 가장 최근에 발생한 이벤트 하나를 emit하고 있음

BehaviorSubject는 subscription이 생성됨과 동시에 반드시 최신 이벤트를 emit해야 함

그래서 이벤트가 없는 Subject를 생성할 수 없음

반드시 초기 값을 설정해야만 한다!

# Replay Subjects
Replay Subject는 최신 이벤트를 여러개 캐싱하고 있다가,

새로운 Subscriber에게 한 번에 전달함

→ 몇 개의 이벤트를 캐싱할 것인지는 직접 설정할 수 있음

![replaySubject](https://user-images.githubusercontent.com/94977962/147181952-deca416f-82c4-40d0-8759-fccd9daa4c16.png)

Working with variables
Variable은 BehaviorSubject를 랩핑하는 클래스이며, value라는 프로퍼티를 갖음

value를 통해서 subject의 현재 값을 얻을 수 있고,

value를 통해 새로운 값을 추가할 수 있음

→ onNext()메소드를 사용하지 않음 !

BehaviorSubject는 항상 초기값이있어야한다고 했지?
근데 Variable은 BehaviorSubject를 랩핑하니까 그 법을 따라야함 ㅋㅋ

Variable을 생성할 때는 항상 초기 값이 있어야함

Variable에 asObservable()을 사용하면 Subject에 접근할 수 있음
내가 생각하는.. 나만의.. 정리
fshSubject : 이전데이터 볼 수 없고 새로운 이벤트만 전달받으면 되는 경우 사용

BehaviorSubject : 가장 최신 이벤트 하나만 보고 싶은 경우

ReplaySubejct : 인스타그램 피드를 생각해봄
