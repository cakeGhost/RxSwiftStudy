
public enum Event<Element> {
  
    // next는 다음 element인스턴스를 갖고있음 
    case next(Element)
  
    // error는 Swift.Error 인스턴스를 갖고있음 
    case error(Swift.Error)
  
    // 아무런 인스턴스를 가지지 않고 이벤트 종료 
    case completed
}



API.download(file: "http://www...")
   .subscribe(
     onNext: { data in
      // Append data to temporary file
     },
     onError: { error in
       // Display error to user
     },
     onCompleted: {
       // Use downloaded file
     }
   )
