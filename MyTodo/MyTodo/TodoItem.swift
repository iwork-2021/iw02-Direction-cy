//
//  TodoItem.swift
//  MyTodo
//
//  Created by nju on 2021/10/22.
//

import UIKit

class TodoItem: NSObject,Encodable,Decodable {
    var title:String
    var isChecked:Bool
    var priority:Int
    
    init(title:String, isChecked:Bool, priority:Int){
        self.title = title
        self.isChecked = isChecked
        self.priority = priority
    }
}
