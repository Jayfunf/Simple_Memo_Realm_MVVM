//
//  MemoDetailView.swift
//  Simple_Memo_Realm_MVVM
//
//  Created by Minhyun Cho on 2022/08/24.
//

import SwiftUI

struct MemoDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var delCheck:Bool = false
    
    var prdTitle: String = ""
    var prdText: String = ""
    
    var prdData: Memo
    
    init(_ prdData: Memo){
        self.prdData = prdData
        self.prdTitle = prdData.title
        self.prdText = prdData.text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(prdTitle)
                .font(.system(size: 35))
                .bold()
            Divider()
            ScrollView {
                Text(prdText)
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
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 ) {
//                    Memo.delMemo(prdData)
//                }
                Memo.delMemo(prdData)
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
