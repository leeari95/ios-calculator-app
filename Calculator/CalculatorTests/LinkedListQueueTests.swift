//
//  LinkedListQueueTests.swift
//  CalculatorTests
//
//  Created by Ari on 2021/11/08.
//

import XCTest


class LinkedListQueueTests: XCTestCase {
    
    func test_enqueue() {
        let queue = LinkedListQueue<Int>()
        
        queue.enqueue(123)
        XCTAssertEqual(queue.count, 1)
        
        queue.enqueue(456)
        XCTAssertEqual(queue.count, 2)
        
        queue.enqueue(789)
        XCTAssertEqual(queue.count, 3)
    }
    
    func test_dequeue() {
        let queue = LinkedListQueue<Int>()
        
        queue.enqueue(123)
        XCTAssertEqual(queue.count, 1)
        
        let node1 = queue.dequeue()
        XCTAssertNotNil(node1)
        XCTAssertEqual(node1, 123)
        
        
        let node2 = queue.dequeue()
        XCTAssertNil(node2)
        XCTAssertEqual(node2, nil)
        
        let node3 = queue.dequeue()
        XCTAssertNil(node3)
        XCTAssertEqual(queue.count, 0)
    }
    
    func test_첫번째요소() {
        let queue = LinkedListQueue<Int>()
        
        queue.enqueue(123)
        queue.enqueue(456)
        let node1 = queue.front
        let node2 = queue.dequeue()
        
        XCTAssertTrue(node1 == node2)
    }
    
    func test_count() {
        let queue = LinkedListQueue<Int>()
        
        queue.enqueue(123)
        queue.enqueue(456)
        
        XCTAssertEqual(queue.count, 2)

        queue.dequeue()
        XCTAssertEqual(queue.count, 1)
        
        queue.dequeue()
        XCTAssertEqual(queue.count, 0)
    }
    
    func test_isEmpty() {
        let queue = LinkedListQueue<Int>()
        
        XCTAssertTrue(queue.isEmpty)
        
        queue.enqueue(123)
        queue.enqueue(456)
        
        queue.dequeue()
        XCTAssertFalse(queue.isEmpty)

        queue.dequeue()
        XCTAssertTrue(queue.isEmpty)
        
        queue.enqueue(123)
        XCTAssertFalse(queue.isEmpty)
        
        queue.clear()
        XCTAssertTrue(queue.isEmpty)
    }
    
    func test_요소가한개일때() {
        let queue = LinkedListQueue<Int>()
        
        queue.enqueue(123)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.front, 123)
        
        let result = queue.dequeue()
        XCTAssertEqual(result, 123)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
    }
    
    func test_요소가두개일때() {
        let queue = LinkedListQueue<Int>()
        
        queue.enqueue(123)
        queue.enqueue(456)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.front, 123)
        
        let result1 = queue.dequeue()
        XCTAssertEqual(result1, 123)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.front, 456)
        
        let result2 = queue.dequeue()
        XCTAssertEqual(result2, 456)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
    }
    
    func test_요소가두개일때_clear호출() {
        let queue = LinkedListQueue<Int>()
        
        queue.enqueue(123)
        queue.enqueue(456)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.front, 123)
        
        queue.clear()
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
    }
    
}
