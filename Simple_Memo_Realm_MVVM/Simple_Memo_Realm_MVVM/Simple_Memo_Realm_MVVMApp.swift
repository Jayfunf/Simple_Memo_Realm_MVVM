//
//  Simple_Memo_Realm_MVVMApp.swift
//  Simple_Memo_Realm_MVVM
//
//  Created by Minhyun Cho on 2022/08/24.
//

import SwiftUI

@main
struct Simple_Memo_Realm_MVVMApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(memoVM: MemoViewModel())
        }
    }
}
