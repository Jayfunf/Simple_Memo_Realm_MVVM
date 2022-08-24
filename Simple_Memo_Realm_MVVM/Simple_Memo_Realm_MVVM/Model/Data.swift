//
//  Data.swift
//  Simple_Memo_Realm_MVVM
//
//  Created by Minhyun Cho on 2022/08/24.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted var title: String = ""
    @Persisted var text: String = ""
    @Persisted var postedDate: Date = Date.now
}

// 데이터 클래스 정의
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
