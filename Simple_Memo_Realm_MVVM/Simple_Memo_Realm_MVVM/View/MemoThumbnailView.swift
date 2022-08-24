//
//  MemoThumbnailView.swift
//  Simple_Memo_Realm_MVVM
//
//  Created by Minhyun Cho on 2022/08/24.
//

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
//            Text(prdData.text)
//                .lineLimit(<#T##number: Int?##Int?#>)
            Text(prdData.postedDate, style: .date)
        }
    }
}

struct MemoThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        MemoThumbnailView(Memo())
    }
}

