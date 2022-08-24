//
//  ContentView.swift
//  Simple_Memo_Realm_MVVM
//
//  Created by Minhyun Cho on 2022/08/24.
//

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
