//
//  FunctionExtensionTests.swift
//  FunctionExtensionTests
//
//  Created by akrio on 2017/5/5.
//  Copyright © 2017年 akrio. All rights reserved.
//

import XCTest
@testable import FunctionExtension

class FunctionExtensionTests: XCTestCase {
    
    func testReduceRight() {
        let arr = [1,2,3]
        let result = arr.reduceRight([]){$0+[$1]}
        print(result)
    }
    func testExample() {
        let arr = [1,2,3]
        print(arr.at([1]))
        print(arr.at(1))
        print(arr.at{[1]})
    }
    func testExample1() {
        let arr = [1,2,3]
        print(arr.every{$0>1})
    }
    func testExampleDiffent() {
        let arr = [1,2,3,5]
        print(arr.difference([4,1,2,5,7]))
        print(arr.difference([4,1,2,5,7],transform:==))
    }
    func testExampleReject() {
        let arr = [1,2,3,5]
        print(arr.reject{$0>3})
    }
    func testGroupBy() {
        let arr = [1,2,3,5]
        print(arr.groupBy{
            return $0
        })
    }
    func testIndexBy() {
        let arr = [1,2,3,5]
        print(arr.indexBy{
            return $0
        })
    }
    func testShuffle(){
        let arr = [1,2,3,5]
        print(arr.shuffle())
        print(arr.shuffle())
        print(arr.shuffle())
        print(arr.shuffle())
        print(arr.shuffle())
        print(arr.shuffle())
    }
    func testSample(){
        let arr = [1,2,3,5]
        print(arr.sample(2))
        print(arr.sample(2))
        print(arr.sample(2))
        print(arr.sample(2))
        print(arr.sample(2))
        print(arr.sample(2))
    }
    func testPartition(){
        let arr = [1,2,3,5]
        print(arr.partition{$0>3})
    }
    func testInitial(){
        let arr = [1,2,3,5]
        print(arr.initial())
    }
    func testFlatten() {
        let arr:[Any] = [1, [2], [3,6, [[4,5]]]]
        print(arr.flatten())
        print(arr.flatten(true))
    }
    func testWithout() {
        let arr = [1,2,3,5]
        print(arr.without(1,2))
    }
    func testUnion() {
        let arr = [1,2,3,3,5,9,1]
        print(arr.union([1],[6,9]))
    }
    func testIntersection() {
        let arr = [1,2,3,3,5,9,1]
        print(arr.intersection([1,45,34],[1,6,9]))
    }
    func testZip() {
        let arr = ["moe", "larry", "curly"] as [Any]
        let zipArr1 = [30, 40, 50]
        let zipArr2 = [true,false,true]
        let result = arr.zip(zipArr1,zipArr2)
        print(result)
    }
    func testObject() {
        let arr = ["moe", "larry", "curly"]
        let zipArr1 = [30, 40, 50]
        let result = arr.object(zipArr1)
        arr.index(of: "1")
        print(result)
    }
    func testLastIndexOf() {
        let arr = ["moe", "larry", "curly"]
        let result = arr.lastIndexOf("moe")
        print(result)
    }
}
