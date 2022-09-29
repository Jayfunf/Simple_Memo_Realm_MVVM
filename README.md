# Realm을 사용한 간단한 메모장 만들기

pod파일의 크기가 매우 큰 관계로 pod파일은 레포에 포함되어 있지 않습니다.

아래 작성한 블로그 링크에 따라 pod 설정을 진행해 주세요.

https://velog.io/@simh3077/realm%EC%9C%BC%EB%A1%9C-%EA%B0%84%EB%8B%A8%ED%95%9C-%EB%A9%94%EB%AA%A8%EC%9E%A5-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0

Realm을 이용해서 메모장을 구현해보쟈🙌

# 🚀 Before we start
이번에 진행한 간단한 메모장 만들기는 아래 언급할 Tech Stack으로 개발하였다.

모두 이 포스팅을 따라하면 간단하게 RealmDB를 사용한 메모장을 구현해볼 수 있을 것이다.

**미리보기**

![](https://user-images.githubusercontent.com/60823527/193020677-7d31e32e-bee6-40da-b960-65363174e60f.gif)


## 💻 Tech Stack
- Swift
- SwiftUI
- Realm
- MVVM

## 📱 Device
- M1 MacBook Air
- iOS 15.0 iPhone 12 mini Simulator

# 👀 Realm?
Realm은 오픈 소스 DBMS로 모바일을 주 타깃으로 하는 데이터베이스이다.
현재 NoSQL의 대표주자인 MongoDB에 인수되었다.

## Realm의 특징?
MongoDB에 인수된 기술답게 NoSQL 데이터베이스를 지향하며, 데이터 모델 구조가 객체 컨테이너로 구성되어 있다.
![출처: MongoDB 홈페이지](https://velog.velcdn.com/images/simh3077/post/402d6a59-fda0-4020-b086-fc74ef44e8ce/image.png)

이렇게 다른 DB에 비해서 빠른 처리 속도를 자랑하며 이에 모바일에 적용하기 적합한 DB라고 할 수 있다.

# 🛫 프로젝트 시작
## 🎯 프로젝트 목표 및 설계
Realm을 공부하고 사용해볼겸 간단한 메모장을 만드는 것이 목표이다. 즉, 크게 심화적인 기능을 넣지 않고 간단한 기능만 Working하면 OK라는 말씀.

구현하고자 하는 기능은 아래와 같다.
- 작성
- 저장
- 수정
- 삭제

## ⚙️ 프로젝트 초기 설정
먼저 프로젝트를 생성하고 Realm을 추가한다.
프로젝트 생성은 모두 안다고 가정하고 넘어간다.

**이미 프로젝트를 만들어 예시로 진행하여 이후 나오는 사진의 파일명이 다를 수 있다.**

터미널을 열어 만들어둔 프로젝트 파일에 접근한다.
![](https://velog.velcdn.com/images/simh3077/post/80f0754b-8492-4968-bf7e-6e79b44e5419/image.png)

그 후 `pod init`명령어로 pod을 초기화 해준다.
![](https://velog.velcdn.com/images/simh3077/post/6ff1c584-0299-46ca-8f07-18903e96d2b2/image.png)

명령어를 실행하면 새롭게 `Podfile`이 생긴것을 확인할 수 있다. 이 파일을 텍스트 편집기로 열어주자.
![](https://velog.velcdn.com/images/simh3077/post/db4ab746-f6e4-4159-b5b6-242fc9534364/image.png)

대충 이렇게 생겨있는데 이것을 아래의 사진처럼 변경해준다.

![](https://velog.velcdn.com/images/simh3077/post/57ced051-5a78-4171-abed-8d4ae9e729f0/image.png)

이런식으로 ios버전을 13으로, `pod 'RealmSwift', '~>10'` 을 작성한 후 저장한다.

다시 터미널로 돌아가 `pod install` 명령어를 실행해준다.
![](https://velog.velcdn.com/images/simh3077/post/8a5623f0-06ed-48eb-81fb-1a0e2bd0eafc/image.png)

이렇게 정상적으로 Realm이 설치된 것을 확인할 수 있다. 
pod install 후 프로젝트 폴더를 보면 기존에 사용하던 [프로젝트이름].xcodeproj가 아닌 [프로젝트이름].xcworkspace라는 파일이 새로 추가된 것을 확인할 수 있따.

![](https://velog.velcdn.com/images/simh3077/post/15d9100b-a49f-4f00-9894-6acb20473ee3/image.png)

우린 이제 요래 생긴 친구를 열어 개발을 진행하면 된다.
Realm 뿐만 아니라 카카오API를 사용해도, Alamofire를 사용해도 이렇게 pods로 추가한 친구들을 사용하기 위해서는 저 xcworkspace파일에서 개발을 진행해야 한다.

이제 개발을 시작해보자.


## 👨‍💻 Dev
### MVVM
이번 메모장 만들기에 사용할 디자인 패턴은 MVVM(Model-View-ViewModel) 패턴이다. 이 패턴에 대해 따로 포스팅할 생각이라 여기서는 짧게 소개하고 넘어간다.

![](https://velog.velcdn.com/images/simh3077/post/73c975df-4cab-44c3-ab20-e150049c5a85/image.png)


프로젝트에 들어가 folder를 생성한다. 각각 Model, View, ViewModel로 이름 지어준다. (꼭 이리 할 필요는 없다.)


MVVM패턴의 구성요소는 패턴이름 그대로 Model, View, ViewModel로 구성되어 있다. 차근차근 알아보자.

- Model
   - 데이터, 네트워크 로직, 비즈니스 로직등을 담는다. 데이터를 캡슐화하는 역할을 한다.
   - View와 완전히 독립적이며, Model은 데이터를 어떻게 품을지만 생각하지 가지고 있는 데이터가 View에서 어떻게 보일지 생각하지 않는다.
- View
   - User와 직접적인 상호작용을 담당한다. 상호작용으로 받은 데이터를 ViewModel에게 처리하도록 한다.
   - Model에 담긴 데이터를 ViewModel로부터 받아 User에게 표현하는 역할을 한다.
- ViewModel
   - View로부터 전달받은 요청을 처리하는 기능을 담당한다. Model의 변화를 View에게 바인딩하여 User에게 보여질 수 있도록 한다.
   
대략적인 MVVM패턴의 Model, View, ViewModel의 역할을 알아보았다.

### Model 구현
#### Data(Realm)
앞서 설명을 했듯 Model에는 데이터를 담는다. 우리는 여기서 Realm에 저장할 데이터 객체를 정의한다.
Model 폴더에 적당한 이름의 Swift파일을 추가한다(cmd + N). 나는 `Data`로 이름지어 주었다.

![](https://velog.velcdn.com/images/simh3077/post/a2ecc444-c287-4a23-a356-c756668ac511/image.png)

**전체코드**
```swift
import Foundation
import RealmSwift

// 데이터 클래스 정의
class Memo: Object {
    @Persisted var title: String = ""
    @Persisted var text: String = ""
    @Persisted var postedDate: Date = Date.now
}

extension Memo {
    // static을 사용해 타입 프로퍼티로 선언
    // 여기서 선언한 realm을 사용해 저장, 삭제등을 진행한다.
    private static var realm = try! Realm()
    
    // realm객체가 타입 프로퍼티이기에 메서드도 타입 메서드로 선언
    // realm객체에 담긴 모든 값을 Results<Memo>의 형태로 조회
    static func findAll() -> Results<Memo> {
        realm.objects(Memo.self)
    }
    
    // realm객체에 값을 추가
    static func addMemo(_ memo: Memo) {
        try! realm.write {
            realm.add(memo)
        }
    }
    
    // realm객체의 값을 삭제
    static func delMemo(_ memo: Memo) {
        try! realm.write {
            realm.delete(memo)
        }
    }
    
    // realm객체의 값을 업데이트
    static func editMemo(memo: Memo, title: String, text: String) {
        try! realm.write {
            memo.title = title
            memo.text = text
            memo.postedDate = Date.now
        }
    }
}
```
Realm을 사용하기 위해 CocoaPods로 Realm을 추가했으니 이를 import해준다.

코드를 설명하기에 앞서 미리 설명하지면, Realm은 Write Transaction내에서 CRUD(Create, Retrieve, Update, Delete)를 처리해야 한다.
```swift
// Write Transaction
try! realm.write {
	Code...
}
```
이렇게 쓰기 트랜젝션안에 코드를 작성한다.

맨 위에서부터 Object를 상속받는 Memo 클래스를 생성한다. 안에는 @Persisted를 붙혀 사용할 Property를 정의한다.
나는 간단한 메모장을 만들기 때문에 복잡한 프로퍼티 없이 제목을 저장하는 `title`, 메모 내용을 저장하는 `text` 그리고 작성한 날짜와 시간을 저장하는 `postedDate`를 정의했다. postedDate로 메모를 작성한 시간에 따라 Sort할 생각이다.

Memo 클래스를 extension을 통해 사용할 메서드를 정의한다.

Realm의 인스턴스 realm을 static을 사용한 타입 프로퍼티로 선언한다. extension에는 저장 프로퍼티를 선언할 수 없어 이렇게 타입 프로퍼티로 선언한다. 다른 방법도 존재한다. 이 방법은 여기서 설명하지 않는다. 따로 프로퍼티를 공부하는 것을 추천한다.

이후 조회를 담당하는 findAll(), 추가를 담당하는 addMemo(), 삭제를 담당하는 delMemo() 그리고 업데이트를 담당하는 editMemo()를 선언한다. realm이 타입 프로퍼티기에 메서드들도 타입 메서드로 static을 사용해 선언한다.

앞서 설명한대로 realm은 Write Transaction block안에서 동작을 해야하기에 CRUD에 해당하는 메서드들 모두 Write Transaction안에서 코드가 동작하는 모습을 확인할 수 있다.

이렇게 하면 메모장을 위한 realm Model을 정의하는 것이 끝이 난다.

### View 구현
![](https://velog.velcdn.com/images/simh3077/post/014cf079-05c2-41ed-8669-9527e9856e7a/image.png)


나는 이렇게 총 4개의 뷰를 만들어 사용했다. 차근차근 알아보자.

#### ContenView
프로젝트를 만들면 기본으로 생성된다. ContentView에서 전체적인 메모를 볼 수 있도록 구현한다.

![](https://velog.velcdn.com/images/simh3077/post/d1a9381c-e5c1-4298-bcf0-3f462a93118f/image.png)

대략 이런 뷰가 완성된다. 코드를 보자.

**전체코드**
```swift
import SwiftUI

struct ContentView: View {
    @ObservedObject var memoVM: MemoViewModel
    
    var body: some View {
        // postedDate를 기준으로 최신 메모가 가장 위에 오도록 정렬한다.
        var memos = memoVM.memos.sorted { $0.postedDate > $1.postedDate }
        
        NavigationView {
            VStack {
                List(memos, id: \.self) { memo in
                    // NavigationLink로 리스트에 쀼려진 각각의 메모를 누르면 MemoDetailView와 연결하여 보여준다.
                    NavigationLink(destination: {
                        // 각각의 메모를 MemoDetailView에 넘겨준다.
                        MemoDetailView(memo)
                    }, label: {
                        // 각각의 메모를 MemoThumbnailView로 이쁘게(?) 포장하여 보여줄 수 있게 한다.
                        MemoThumbnailView(memo)
                    })
                }
                // iOS 15부터 동작하는 기능이다. 흔히 사용하는 끌어당겨 새로고침을 편하게 구현할 수 있도록 해준다.
                .refreshable {
                    // ViewModel에 정의한 새로고침 기능인 refreshMemo메서드를 실행한다.
                    memoVM.refreshMemo()
                }
                // 아래 .background와 onAppear속 코드 두 줄은 배경화면의 색을 하얀색으로 변경하기 위해 작성. 필수X.
                .background(Color.white)
                .onAppear(perform: {
                    UITableView.appearance().backgroundColor = UIColor.clear
                    UITableViewCell.appearance().backgroundColor = UIColor.clear
                })
            }
            // navigationTitle을 "Memo"로 지정한다.
            .navigationTitle("Memo")
            // 툴바를 사용하여 플러스 버튼을 navigationBar의 상단에 위치시킨다.
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink(destination: {
                        // 버튼을 누를 경우 MemoEditor로 이동하여 메모를 새로 작성할 수 있게 한다.
                        MemoEditor(Memo())
                            .navigationBarTitleDisplayMode(.inline)
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // ViewModel을 뷰에서 소유하여 사용하기에 해당 뷰의 매개변수로 ViewModel을 넣어 연결.
        ContentView(memoVM: MemoViewModel())
    }
}
```

간단한 주석을 달아두었으니 따로 자세히 설명하지는 않겠다. 

#### MemoEditor
다음은 메모 작성 및 편집 기능을 위한 `MemoEditor`이다.
![](https://velog.velcdn.com/images/simh3077/post/10f77e15-36c3-4aed-b9db-fe2d959d7472/image.png)

대략 이런 뷰가 완성된다. 코드를 보자.

**전체코드**
```swift
import SwiftUI

struct MemoEditor: View {
    // 작성 혹은 편집한 메모의 저장 버튼을 누를 시 자동으로 창을 닫기 위해 선언
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // @ObservedObject로 ViewModel을 소유
    @ObservedObject var memoVM: MemoViewModel
    // TextEditor는 placehold를 자체적으로 표시할 수 없어 이 기능을 개발하기 위해 선언
    @State var placeholderText: String = "클릭해서 메모를 입력"
    
    // 제목과 내용을 저장하기 위해 사용, 바인딩을 위해 @State속성
    @State private var text: String = ""
    @State private var title: String = ""
    
    // 메모 인스턴스 생성
    var prdData: Memo
    init(_ prdData: Memo){
        self.prdData = prdData
        self.memoVM = MemoViewModel()
    }
    
    // TextEditor의 Done버튼 해결, TextEditor는 Done버튼이 포함된 키보드로 변경할 수 없어 이 기능을 개발하기 위해 선언
    @FocusState private var focusedField: Field?
    private enum Field: Int, CaseIterable {
        case text
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("제목")
                    .bold()
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                        + Text("*")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20))
                ){
                    TextField("클릭해서 제목을 입력", text: $title)
                        .submitLabel(.done)
                        .disableAutocorrection(true)
                        .onAppear {
                            title = prdData.title
                        }
                }
                Section(header: Text("내용")
                    .bold()
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                        + Text("*")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20))
                ){
                    ZStack {
                        if self.text.isEmpty {
                            TextEditor(text: $placeholderText)
                                .font(.body)
                                .foregroundColor(.gray)
                                .opacity(0.5)
                                .disabled(true)
                        }
                        TextEditor(text: $text)
                            .font(.body)
                            .opacity(self.text.isEmpty ? 0.25 : 1)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .text)
                            .submitLabel(.done)
                            .frame(width: .infinity,height: 500)
                            .onAppear {
                                text = prdData.text
                            }
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    Button("Done") {
                                        focusedField = nil
                                    }
                                }
                            }
                    }
                }
            }
            .frame(width: .infinity)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if prdData.title == "" {
                        // title이 비어있다면 새로운 메모로 판단
                        Button {
                            memoVM.add(text: text, title: title)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("저장하기")
                        }
                    } else {
                        Button {
                            memoVM.editMemo(old: prdData, title: title, text: text)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("편집완료")
                        }
                    }
                }
            }
            .background(Color.white)
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = UIColor.clear
                UITableViewCell.appearance().backgroundColor = UIColor.clear
            })
        }
    }
}

struct MemoEditor_Previews: PreviewProvider {
    static var previews: some View {
        MemoEditor(Memo())
    }
}
```
대부분 UI 디자인을 위한 코드가 많아 핵심적인 부분만 따로 설명하겠다.
```swift
@State var placeholderText: String = "클릭해서 메모를 입력"
...
ZStack {
    if self.text.isEmpty {
        TextEditor(text: $placeholderText)
            .font(.body)
            .foregroundColor(.gray)
            .opacity(0.5)
            .disabled(true)
    }
    TextEditor(text: $text)
        .font(.body)
        .opacity(self.text.isEmpty ? 0.25 : 1)
        .disableAutocorrection(true)
        .focused($focusedField, equals: .text)
        .submitLabel(.done)
        .frame(width: .infinity,height: 500)
        .onAppear {
            text = prdData.text
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    focusedField = nil
                }
            }
        }
}
```
위의 코드는 TextEditor의 placehold Text를 위해 사용했다. 제목을 위해 사용한 TextField는 매개변수로 아무 값이 없을 때 표시할 수 있는 (해당 프로젝트에서는 "클릭해서 제목을 입력") String 값을 받아 이를 보여준다.

하지만 장문의 메모 내용을 받기 적합한 TextEditor는 해당 기능이 없다. 이 기능을 위해 존재한다. text.isEmpty로 값이 없다면 바인딩한 `placeholderText`를 표시하며, 값이 있다면 해당 텍스트를 보이지 않게 하고 값을 입력 받는다.

```swift
// 제목과 내용을 저장하기 위해 사용, 바인딩을 위해 @State속성
@State private var text: String = ""
@State private var title: String = ""
...
TextField("클릭해서 제목을 입력", text: $title)
	// 키보드를 return이 아닌 done으로 표시되는 키보드로 변경
	.submitLabel(.done)
    // 자동완성 끄기 true
    .disableAutocorrection(true)
    // 편집으로 열면 이미 저장된 값을 불러오기 위해 사용. 뒤에 자세히 설명
    .onAppear {
        title = prdData.title
    }
...
TextEditor(text: $text)
    ...
    // 편집으로 열면 이미 저장된 값을 불러오기 위해 사용. 뒤에 자세히 설명
    .onAppear {
        text = prdData.text
    }
    // TextEditor는 done버튼을 포함한 키보드로 변경할 수 없어 따로 done버튼 추가
    .toolbar {
        ToolbarItem(placement: .keyboard) {
            Button("Done") {
                focusedField = nil
            }
        }
    }
```
위 코드는 바인딩한 `text` 와 `title` 값을 어떻게 `TextField` , `TextEditor` 와 연결하는지 확인할 수 있다.

`TextField` , `TextEditor` 모두 $ <- (달러사인)이 붙은 `$title` , `$text` 로 값을 전달하는 것을 확인할 수 있다.

위 로직을 이해한다면 값을 어떻게 불러오고 저장하는지 이해하고 이를 사용할 수 있다.

또, 각각 onAppear를 달고 있는 것을 확인할 수 있다. 이는 View가 나타날 때 실행할 Action을 추가할 수 있게 한다.

이는 편집을 위한 것으로, 나는 TextField와 TextEditor가 나타날 때 `MenoEditor` 뷰가 매개변수로 받는 편집할 memo의 값을 불러오기 위해 사용한다. 

만약 위의 코드를 작성하지 않으면 편집을 하기 위해서 편집 버튼을 누른, 이미 저장되어 있던 메모의 제목과 내용이 화면에 불러와지지 않을 것이다.

마지막으로 TextEditor의 toolbar는 키보드 done버튼을 위해 존재한다. ToolbarItem의 placement 속성을 .keyboard로 두어 키보드가 활성화되면 자동으로 생성된다. 사진으로 보자면, 

![](https://velog.velcdn.com/images/simh3077/post/77b48093-64a4-40c5-a93d-1c74df33c349/image.png)

이렇게 제목을 작성하는 TextField의 경우 `완료` 버튼인 것을 확인할 수 있다. 어차파 제목은 한 줄로 작게 표시하기에 return 버튼이 필요 없다.

![](https://velog.velcdn.com/images/simh3077/post/9302c086-e4d8-4693-b249-7d8e04fc4581/image.png)

하지만 내용을 작성하는 TextEditor의 경우 `return(엔터)` 버튼인 것을 확인할 수 있다. 따라서 키보드 위에 달린 `Done` 버튼을 누르면 자동으로 키보드가 내려가도록 한다.

![](https://velog.velcdn.com/images/simh3077/post/77b9a323-90aa-49fa-99ad-ea4826ada4d0/image.gif)


#### MemoDetailView
다음은 메모 리스트에서 메모를 클릭했을 때 메모의 상세 페이지를 보여주는 `MemoDetailView` 이다.

![](https://velog.velcdn.com/images/simh3077/post/98aa961a-0c46-4adc-8e9d-712de85d5aba/image.png)

**전체코드**
```swift
import SwiftUI

struct MemoDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var delCheck:Bool = false
    var prdData: Memo
    
    init(_ prdData: Memo){
        self.prdData = prdData
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(prdData.title)
                .font(.system(size: 35))
                .bold()
            Divider()
            ScrollView {
                Text(prdData.text)
                    .frame(width: 330, height: .infinity, alignment: .leading)
            }
        }
        .frame(width: 330, height: .infinity, alignment: .topTrailing)
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    self.delCheck = true
                } label: {
                    Image(systemName: "trash")
                }
                
                NavigationLink {
                    MemoEditor(prdData)
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .alert("정말 삭제 하시겠습니까?",isPresented: $delCheck) {
            Button("확인", role: .destructive){
                self.presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 ) {
                    Memo.delMemo(prdData)
                }
            }
            Button("아니요", role: .cancel) {}
        }
    }
}

struct MemoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemoDetailView(Memo())
    }
}
```
여기서 설명할 부분으로는,
```swift
.toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    self.delCheck = true
                } label: {
                    Image(systemName: "trash")
                }
                
                NavigationLink {
                    MemoEditor(prdData)
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .alert("정말 삭제 하시겠습니까?",isPresented: $delCheck) {
            Button("확인", role: .destructive){
                self.presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 ) {
                    Memo.delMemo(prdData)
                }
            }
            Button("아니요", role: .cancel) {}
        }
```
요정도 부분으로 압축할 수 있다. 먼저 toolbar로 삭제 버튼과 편집 버튼을 만들어준다.

![](https://velog.velcdn.com/images/simh3077/post/ad0da4e0-4045-4d3d-89aa-2bfd88bf220e/image.png)

쓰레기통 버튼을 누르면 삭제 상태를 저장하는 `delCheck`이 `true`로 변경되며 이를 통해 alert가 동작한다.

alert에서 `isPresented`속성에 $delCheck를 넣어 해당 버튼 상태가 true면 동작하게 한다. 버튼을 누르면,

![](https://velog.velcdn.com/images/simh3077/post/2374ed9e-5feb-4b3a-a1cf-5a60131044da/image.png)

이렇게 삭제 하겠냐는 메세지가 등장하여 삭제를 확인한다. 확인을 누르면 자동으로 해당 DetailView가 닫히며, DispatchQueue를 통해 0.5초 이후 삭제 동작을 진행한다. 딜레이를 주지 않는다면 애플리케이션이 충돌한다.

애플리케이션이 충돌하는 이유를 생각해 보았을 때 MemoDetailView는 매개변수로 Memo들을 담은 인스턴스 memos의 각 원소인 memo를 받아 이를 보여준다.

그럼 View는 계속해서 이 memo(해당 뷰에서는 이를 prdData로 받아 사용)를 뿌려주고 있는데 여기서 삭제를 해버리면 더이상 뿌려줄 memo가 DB에 없기에 오류가 발생한다.

따라서 self.presentationMode.wrappedValue.dismiss()로 뷰를 닫음과 동시에 DispatchQueue의 asyncAfter로 0.5초의 시간 뒤 해당 memo를 삭제하면 crash를 방지할 수 있다.

진짜 위의 이유로 에러가 발생하는지 알아보기 위해 테스트를 해보자.

```swift
var prdTitle: String = ""
var prdText: String = ""
...
init(_ prdData: Memo){
    self.prdData = prdData
    self.prdTitle = prdData.title
    self.prdText = prdData.text
}
...
VStack(alignment: .leading) {
    Text(prdTitle) // <- 여기
        .font(.system(size: 35))
        .bold()
    Divider()
    ScrollView {
        Text(prdText) // <- 여기
            .frame(width: 330, height: .infinity, alignment: .leading)
    }
}
...
.alert("정말 삭제 하시겠습니까?",isPresented: $delCheck) {
    Button("확인", role: .destructive){
        self.presentationMode.wrappedValue.dismiss()
//      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 ) {
//      	Memo.delMemo(prdData)
//      }
        Memo.delMemo(prdData)
    }
    Button("아니요", role: .cancel) {}
}
```
이렇게 prdData의 title과 text를 받을 변수를 선언해주고(여기서는 `prdTitle`, `prdText`) 초기화 시점에서 prdData의 title과 text를 할당해준다.

그리고 해당 title과 text를 보여주는 VStack의 두 Text영역에 직접적으로 prdData.title과 prdData.text를 뿌리지 않고 따로 선언한 변수의 값을 보여준다. 그리고 오류가 나던 alert의 코드로 변경한 후 확인해보면,

![](https://velog.velcdn.com/images/simh3077/post/cb0e3399-631e-4c62-a9ce-96c0099802c6/image.gif)

이렇게 crash없이 동작한다!

하지만 asyncAfter를 사용하면 메모 편집시 편집된 값이 바로 DetailView에 보여지지만 위처럼 변수를 만들어 사용하면 변경된 값이 바로 반영되지 않는다. 그래서 나는 0.5초의 딜레이를 주겠다.

#### MemoThumbnailView
View의 마지막 `MemoThumbnailView`이다. 메인 화면(ContentView)에서 작성한 메모를 간략하게 제목과 작성 날짜로 보여주는데, 이렇게 메모를 간단하게 보여지는 역할을 해준다. 아래 사진처럼 말이다.

![](https://velog.velcdn.com/images/simh3077/post/0ab2d443-97b3-47b2-8eae-72789de1a997/image.png)

**전체코드**
```swift
import SwiftUI

struct MemoThumbnailView: View {
    
    var prdData: Memo
    
    init(_ prdData: Memo){
        self.prdData = prdData
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(prdData.title)
                .bold()
            Text(prdData.postedDate, style: .date)
        }
    }
}

struct MemoThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        MemoThumbnailView(Memo())
    }
}
```

가장 간단한 코드로 이루어져있다. 다른 View들과 마찬가지로 memos의 원소인 memo를 prdData로 받아 이를 통해 뷰를 구성한다.

만약 간략한 메모도 보여지고 싶으면 아래처럼 수정하면 된다.

```swift
var body: some View {
        VStack(alignment: .leading){
            Text(prdData.title)
                .bold()
            Text(prdData.text)
                .lineLimit(1)
            Text(prdData.postedDate, style: .date)
        }
    }
```
이렇게 Text(prdData.text)로 텍스트 내용을 불러와주고, .lineLimit(number: Int)로 원하는 줄만큼 숫자를 넣어주면 동작한다. 나는 1줄만 표시되도록 1을 넣어 주었다. 결과를 확인하면,

![](https://velog.velcdn.com/images/simh3077/post/c14e6001-a4cc-47f6-a0c2-9ef7c7de7e8b/image.png)

이렇게 작성한 텍스트도 간략하게 보여줄 수 있다.

### ViewModel 구현
#### MemoViewModel

MVVM의 마지막 ViewModel이다. ViewModel은 View와 Model사이의 중개자 역할을 하기에 View에서 User와의 인터렉션을 통해 받은 데이터를 Model에게 전달하는 메서드와, 변경된 Model의 값을 View에게 알리는 역할을 한다.

**전체코드**
```swift
import Foundation

class MemoViewModel: ObservableObject {
    @Published var memos: [Memo] = Array(Memo.findAll())
    
    func add(text: String, title: String) -> Void {
        guard !text.isEmpty else { return }
        guard !title.isEmpty else { return }
        let memo = Memo()
        memo.text = text
        memo.title = title
        self.memos.append(memo)
        Memo.addMemo(memo)
    }
    
    func refreshMemo() -> Void {
        self.memos = Array(Memo.findAll())
    }
    
    func editMemo(old: Memo, title: String, text: String) -> Void {
        guard !text.isEmpty else { return }
        guard !title.isEmpty else { return }
        Memo.editMemo(memo: old, title: title, text: text)
    }
}
```

ViewModel은 모든 코드가 중요하여 하나하나 설명한다.

- 먼저 ViewModel 클래스를 생성한다. 이 클래스는 [ObservableObject](https://developer.apple.com/documentation/combine/observableobject) 프로토콜을 채택한다. 이래야 앞서 설명한 View들이 ObservedObject로 이 ViewModel을 소유할 수 있다.
정리하자면, ViewModel은 View에 의해 `Observed` 되며 ViewModel의 `@Published`(여기서는 memos) 프로퍼티에 변화가 생기면 해당 데이터 변화에 영향을 받는 View들이 다시 그려진다.

- @Published 프로퍼티인 memos는 array로 Model에 정의한 Memo의 findAll 메서드를 실행하여 DB에 저장된 값을 가져온다.

- `add` 메서드는 매개변수로 title과 text를 받으며, text와 title의 값이 없으면 동작하지 않는다.
이게 중요한 이유는 MemoEditor View의 저장, 편집 조건에 `if prdData.title == ""`가 있었다.
만약 title이 빈 상태로 저장을 눌러도 저장이 되지 않아 위의 if문이 정상적으로 동작한다. 나는 하나의 MemoEditor로 새 메모 저장과 편집 두 기능 모두 동작하게 하기 위해 필요했다.
물론 저장을 위한 MemoEditor와 편집을 위한 또 다른 뷰를 만들어도 괜찮지만, 매우 비슷한 코드로 이루어 질 것이며, **재사용성에서 마이너스**이다.
이어서 `add` 메서드를 설명하자면 memo 인스턴스를 만들고 매개변수로 받은 text와 title을 해당 인스턴스에 저장한다. 그 후 위에 @Published 프로퍼티인 memos에 append를 해서 메모를 넣어주고 Model의 Memo의 addMemo메서드를 수행하여 해당 인스턴스를 던져준다. 
이렇게 하면 View에서 받은 데이터를 Model로 전달할 수 있다.

- `refreshMemo` 메서드는 memos의 값을 Memo의 findAll메서드로 다시 불러온다. 그럼 add나 del로 추가, 삭제한 메모값을 다시 로드해 View들이 다시 그려질 수 있게 한다.

- `editMemo` 메서드는 편집을 담당한다. 매개변수로는 편집할 메모 `old`, 바꿀 제목 `title`, 바꿀 내용 `text`이렇게 받아준다.
add와 똑같이 text와 title이 비어있다면 실행되지 않으며, 받은 매개변수를 Model의 Memo의 editMemo 메서드에 넘겨 Model을 변경할 수 있게 한다.

이렇게 모든 코드를 확인해 보았다.

## 🔨 Testing

사실 매 테스트를 진행하며 개발을 해서 딱히 개발이 끝난 후 테스트할 부분이 없다. 기능을 하나하나 사용해보자.

**메모 추가**

![](https://user-images.githubusercontent.com/60823527/193020850-ce59572e-2cb2-47f0-8aed-dee299e98026.gif)

**메모 삭제**

![](https://velog.velcdn.com/images/simh3077/post/84ffc720-f07c-4ae8-a4ec-7cb9d89f21aa/image.gif)

**메모 편집**

![](https://user-images.githubusercontent.com/60823527/193020990-a6f5b8cb-4865-458c-a9a5-295e058993b6.gif)

**메모 편집시 맨 위로 sort**

![sort](https://user-images.githubusercontent.com/60823527/193020998-bc5dd09e-e16d-41d5-9e40-b8b28a110b01.gif)

**제목이 비어있는 메모 저장**

![](https://velog.velcdn.com/images/simh3077/post/c6089521-04a7-453d-80a0-3dacb11ce81b/image.gif)

**내용이 비어있는 메모 저장**

![](https://velog.velcdn.com/images/simh3077/post/8bfe72b4-e42c-45db-aba6-f4726ccb953e/image.gif)

iOS의 기본 메모장처럼 제목만 있으면 저장하게 할까 싶다. 만약 그렇게 구현하고 싶다면, `MemoViewModel`의 add, editMemo 메서드의 

guard !text.isEmpty else { return }를 삭제해주면 된다. 이를 테스트 해보면,

![](https://velog.velcdn.com/images/simh3077/post/70ee11e0-e021-490c-b49b-ab9ae4c41742/image.gif)

이렇게 정상적으로 작동한다.

# 🛬 프로젝트 완료

이렇게 Realm을 사용한 간단한 메모장 만들기 프로젝트를 완료했다. 

Realm을 처음 사용해보는데 직접 써보며 공부하는 느낌이 매우 좋았고,

선배 개발자분들이 보시기엔 분명 부족한 프로젝트일 것이다. 스스로도 부족하다 생각하니.. ~~점점 발전하는 프로젝트를 보여드리죠 후후.~~

Unit Test도 사용할겸 프로젝트를 만들 때 Test파일들도 include해서 만들었는데 결국 사용하지 못했다... 

간단하고 쉽다고 생각하니 테스트없이 후다닥 만들어 버렸는데 다음 토이는 TDD로 개발을 해봐야겠다.

![](https://velog.velcdn.com/images/simh3077/post/920fb80c-8f41-4545-a880-1e0c3543a4fb/image.jpeg)

~~Swift 사랑해~~

> 포스팅에 틀린 부분이나 보완이 필요한 부분이 있다면 댓글 부탁드립니다. 아직 한참 부족한 스린이에게 도움을...

## 프로젝트 깃허브
https://github.com/Jayfunf/Simple_Memo_Realm_MVVM


# References(Thx🤙)
[[ObservableObject] - Apple Documents](https://developer.apple.com/documentation/combine/observableobject)
[[Did you know? How to hide keyboard in SwiftUI?] - Ashish Kakkad](https://ashishkakkad.com/2022/03/did-you-know-how-to-hide-keyboard-in-swiftui/)
