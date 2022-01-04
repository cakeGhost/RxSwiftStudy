# Filtering Operators in Practice

구독을 공유하는 주체 : Observable

1) 공유해서 사용하지 않은 경우의 문제점 

여러 곳에서 `subscribe()`를 사용한다면 동기화에 문제 발생

<br>

## 공유해서 사용할 함수와 변수 정의
```
var start = 0
func getStartNumber() -> Int {
    start += 1
    return start
} 
```

<br>

## Observable 객체 생성 
```
let numbers = Observable<Int>.create { observer in
    let start = self.getStartNumber()
    observer.onNext(start)
    observer.onNext(start+1)
    observer.onNext(start+2)
    observer.onCompleted()
    return Disposables.create()
}
```

<br>

<br>

## Subscribe

numbers라는 Observable객체가 

heap영역에 할당된 변수(start)에 변형을 주는 함수에 2번 접근하므로 값이 다르게 출력됨

```
numbers
  .subscribe(
    onNext: { el in
      print(el)
    },
    onCompleted: {
      print("Completed")
    }
  )
// print : 1, 2, 3, Completed

numbers
  .subscribe(
    onNext: { el in
      print(el)
    },
    onCompleted: {
      print("Completed")
    }
  )
// print : 2, 3, 4, Completed
```

<br>

<br>

## 함수와 변수 그대로 유지하면서, subscribe시에 결과값을 변하지 않게 subscribe를 공유하는 방법은?

→ `share()`연산자 사용하는 것이 가장 좋은 방법

![share](https://user-images.githubusercontent.com/94977962/148051412-b8b231d8-ee56-43c3-ada7-dca1d92d44d6.png)


`share()`를 사용하면 Observable하나로 처리 가능!



<br>

<br>

## Ignoring certain elements

좌측 navigation icon에 추가하는 함수

<img width="422" alt="elements" src="https://user-images.githubusercontent.com/94977962/148051502-bb29823e-3a0b-41c2-a38c-9bc91d2e0108.png">

```
//MainViewController.swift

private func updateNavigationIcon() {
  let icon = imagePreview.image?
    .scaled(CGSize(width: 22, height: 22))
    .withRenderingMode(.alwaysOriginal)
    
  navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon,
    style: .done, target: nil, action: nil)
}
```

```
// MainViewController.swift, viewDidLoad()
newPhotos
  .ignoreElements()
  .subscribe(onCompleted: { [weak self] in
    self?.updateNavigationIcon()
  })
  .disposed(by: bag)
```

<br>

<br>

## 세로보다 너비가 큰 이미지만 표시하도록 하기

→ `filter` 사용

<img width="532" alt="filterwidth" src="https://user-images.githubusercontent.com/94977962/148051600-2c821452-fec8-49d6-90e8-59ca6e6d397c.png">

```
newPhotos
  .filter { newImage in
    return newImage.size.width > newImage.size.height
  }
  [existing code .subscribe(...)]
```


<br>

<br>

## 사진이 6개 이상일 때 +버튼 비활성화시키기

→ `takewhile` 사용

(`takewhile` : 조건 검사를 통과한 이벤트만 전달함)


```
newPhotos
  .takeWhile { [weak self] image in
    let count = self?.images.value.count ?? 0
    return count < 6
  }
  [existing code: filter {...}]
```


<br>

<br>

## 사진 접근 허용 권한설정이 안되어있다면 requestAccess를 호출하는 코드 넣기
![requestAccess](https://user-images.githubusercontent.com/94977962/148051896-bdb89e03-460b-4fd7-8082-e8fcae65e49a.png)

```
import Foundation
import Photos
import RxSwift
extension PHPhotoLibrary {
      static var authorized: Observable<Bool> {
          return Observable.create { observer in

	            return Disposables.create()
          }
 }
```

```
DispatchQueue.main.async {
 if authorizationStatus() == .authorized {
 observer.onNext(true)
 observer.onCompleted()
 } else {
	 observer.onNext(false)
	 requestAuthorization { newStatus in
	 observer.onNext(newStatus == .authorized)
	 observer.onCompleted()
	 }
 }
}
```


<br>

<br>

## access권한이 허용되었을 때 사진 reload하기

✔️ 최초 앱이 실행시, 사용자는 접근 허용 alert창에서 OK를 선택함

<img width="368" alt="alertOK" src="https://user-images.githubusercontent.com/94977962/148051972-b495c345-e7c5-4ac7-9c37-0d00a8a1bbd0.png">


✔️  액세스 권한 허용하고 난 이후, 앱 실행시 

<img width="351" alt="completed" src="https://user-images.githubusercontent.com/94977962/148052060-e8209541-4ca6-4208-bffe-b3ca9c0a8932.png">

`skipWhile`로 `true`만 오게끔 설정하고 한번만 업데이트 하면 되므로 `take(1)`로 설정 

```swift
authorized
  .skipWhile { $0 == false }
  .take(1)
  .subscribe(onNext: { [weak self] _ in
    self?.photos = PhotosViewController.loadPhotos()
    DispatchQueue.main.async {
      self?.collectionView?.reloadData()
    }
  })
  .disposed(by: bag)
```


<br>

<br>

## 사용자가 앨범 접근에 비동의 한 경우 처리

→ 비동의한 곳에 접근할 경우 error 메시지 출력

```
authorized
 .skip(1)
 .takeLast(1)
 .filter { $0 == false }
 .subscribe(onNext: { [weak self] _ in
 guard let errorMessage = self?.errorMessage else { return }
 DispatchQueue.main.async(execute: errorMessage)
 })
 .disposed(by: bag)
```
