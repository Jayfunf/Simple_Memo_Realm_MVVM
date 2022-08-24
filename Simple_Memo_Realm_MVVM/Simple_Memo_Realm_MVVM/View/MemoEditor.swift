//
//  MemoEditor.swift
//  Simple_Memo_Realm_MVVM
//
//  Created by Minhyun Cho on 2022/08/24.
//

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
