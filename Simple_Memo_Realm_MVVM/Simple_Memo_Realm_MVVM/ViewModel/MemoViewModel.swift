//
//  MemoViewModel.swift
//  Simple_Memo_Realm_MVVM
//
//  Created by Minhyun Cho on 2022/08/24.
//

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memos: [Memo] = Array(Memo.findAll())
    
    func add(text: String, title: String) -> Void {
        //guard !text.isEmpty else { return }
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
        //guard !text.isEmpty else { return }
        guard !title.isEmpty else { return }
        Memo.editMemo(memo: old, title: title, text: text)
    }
}
