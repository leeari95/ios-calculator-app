//
//  LinkedListQueue.swift
//  Calculator
//
//  Created by Ari on 2021/11/08.
//

import Foundation

struct LinkedListQueue<Element> {
    private var list = LinkedList<Element>()
    
    var count: Int {
        return list.count
    }
    
    var isEmpty: Bool {
        return list.isEmpty
    }
    
    var front: Element? {
        return list.first?.value
    }
    
    func enqueue(_ element: Element) {
        list.append(element)
    }
    
    @discardableResult
    func dequeue() -> Element? {
        if list.isEmpty {
            return nil
        }
        return list.removeFirst()
    }
    
    func clear() {
        list.removeAll()
    }
}
