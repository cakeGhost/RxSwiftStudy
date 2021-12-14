# Observable
observable이 대체 뭘까...? 

우리는 observable, observable sequence, sequence ... 등을 들어 봤을 거예요.. <br>

하지만 이것들 모두 observable 입니다.. 

> observable is just a sequence, with some special powers.  <br>
observable은 하나의 seqeunce이고, 여러가지 강점을 갖고 있습니다.

 <br>
 
특별한 능력 중 하나는, 바로 **async 하다는 것** ~!~!~!  <br>

그리고, Observable이 이벤트를 발생시키는 것을 **emit** 한다고 표현합니다.   <br>

(이벤트들은 사용자의 tap, gesture 또는 숫자, 인스턴스 등을 포함합니다)


<br>
<br>
  
그림을 한번 보자 👀  <br>
이 그림은 하나의 sequence를 의미합니다.  <br>

<img width="320" alt="sequence" src="https://user-images.githubusercontent.com/94977962/145962615-a8621627-7ceb-441c-9176-eef81a38cf7d.png">  <br>

가로로 긴 화살표 :  시간의 흐름 

동그라미 숫자 1,2,3 : 발생하는 이벤트 
<br>

‼️ sequence의 lifetime동안 이벤트는 언제라도 발생할 수 있습니다. 

(참고로 여기서 발생한 1,2,3은 next이벤트에 해당됨)
<br>

<br>

# Emitting

observable은 순서에 따라 emit되는 구조를 가집니다.
> emit : 분출하다, 방출하다

말 그대로 observable에서 

이벤트1, 이벤트2, 이벤트3이 순서대로 생성되는 것을
emit이라고 합니다.

<br>

# Lifecycle of an observable
또 다른 그림을 살펴보자 👀

sequence의 라이프 사이클동안 3개의 tap이벤트가 발생했고 
오른쪽에 | 표시가 있습니다.

<img width="320" alt="completed" src="https://user-images.githubusercontent.com/94977962/145963116-e5cc8471-912d-4513-a7ca-a764a41eb390.png">


| 표시는 completed 이벤트에 해당합니다.



즉, 이 그림은  <br>
어떤 view를 사용자가 3번 tap한 뒤,
view가 dismiss 되었을 때를 가정해볼 수 있겠죠?

completed이벤트가 발생하면 sequence가 종료되고, <br>
더 이상 어떤 이벤트도 발생하지 않습니다.



<br>
하지만!!!! 

가끔 sequence에서 에러가 발생할 수 있습니다.

또 다른 그림을 살펴보자 👀


<img width="320" alt="errorEvent" src="https://user-images.githubusercontent.com/94977962/145963960-e27e3cea-1c9f-4af1-bf1e-10e41ea269ae.png">

위 그림과 달리 X표시가 있습니닷 !! 


이는 sequence에서 error 이벤트가 발생했다는 의미입니다.


error 이벤트도 completed이벤트와 마찬가지로 sequence가 종료되고,


이 sequence에서는 더 이상 이벤트가 발생하지 않습니다.

<br>

<br>


# 🌈 정리
* Observable은 라이프 타임에 걸쳐 값을 포함하는 next 이벤트를 발생시킴
* 라이프 타임 중, 오류가 발생하면 error 이벤트를 발생시킴
* 라이프 사이클이 정상적으로 완료되면, completed 이벤트를 발생시킴
* 한번 종료된 sequence에서는 더 이상 이벤트가 발생하지 않는다. 



<br>

코드를 통해 살펴보쟈
```
public enum Event<Element> {
    case next(Element)
    
    case error(Swift.Error)
    
    case completed
    
}
```

enum Event는 3가지의 case를 갖고있고,

그 중에 next에는 Element에 해당하는 값이 동반되고,

error에는 Swift의 에러 타입 인스턴스를 갖고 있는 것을 확인할 수 있습니다.


<br>

