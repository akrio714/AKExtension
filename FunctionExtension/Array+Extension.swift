//
//  Array+Extension.swift
//  FunctionExtension
//
//  Created by akrio on 2017/5/5.
//  Copyright © 2017年 akrio. All rights reserved.
//

import Foundation

public extension Array{
    
    /// reducRight是从右侧开始组合的元素的reduce函数
    ///
    /// - Parameters:
    ///   - initialResult: 初始值
    ///   - nextPartialResult: 规则
    /// - Returns: 处理后的值
    public func reduceRight<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> Result{
        return self.reversed().reduce(initialResult){nextPartialResult($0,$1)}
    }
    
    /// 获取指定位置元素并拼接成数组(可变参数版)
    ///
    /// - Parameter indexes: 获取元素的位置
    /// - Returns: 拼接后的数组
    public func at(_ indexes: Int...) -> [Element] {
        return self.at(indexes)
    }
    /// 获取指定位置元素并拼接成数组(一般数组版)
    ///
    /// - Parameter indexes: 获取元素的位置
    /// - Returns: 拼接后的数组
    public func at(_ indexes:[Int])-> [Element] {
        return self.at{indexes}
    }
    
    /// 获取指定位置元素并拼接成数组(函数式版)
    ///
    /// - Parameter indexes: 获取元素的位置
    /// - Returns: 拼接后的数组
    public func at(_ transform:()->[Int])-> [Element] {
        return transform().map{self[$0]}
    }
    
    /// 判断是否数组中的每项都符合条件
    ///
    /// - Parameter transform: 条件
    /// - Returns: 是否符合条件
    public func every(_ transform: (Element) -> Bool)-> Bool {
        for elem in self {
            guard transform(elem) else {
                return false
            }
        }
        return true
    }
    
    /// 比较2个数组的不同项(比较数组普通版)
    ///
    /// - Parameters:
    ///   - compare: 比较的数组
    ///   - transform: 比较规则
    /// - Returns: 不同项
    public func difference(_ compare:[Element],transform:(Element,Element)->Bool) -> [Element] {
        return self.filter { v1 in !compare.contains{v2 in transform(v1,v2)} } + compare.filter {v1 in !self.contains{v2 in transform(v1,v2)} }
    }
    /// 比较2个数组的不同项(比较数组函数式版)
    ///
    /// - Parameters:
    ///   - compare: 比较的数组
    ///   - transform: 比较规则
    /// - Returns: 不同项
    public func difference(_ compare:()->[Element],transform:(Element,Element)->Bool) -> [Element] {
        return self.difference(compare(), transform: transform)
    }
    
    /// 返回list中没有通过transform真值检测的元素集合，与filter相反。
    ///
    /// - Parameter transform: 过滤条件
    /// - Returns: 过滤后结果
    public func reject(_ transform: (Element) -> Bool)-> [Element] {
        return self.filter{ !transform($0)}
    }
    /// 把一个集合分组为多个集合，通过 iterator 返回的结果进行分组. 如果 iterator 是一个字符串而不是函数, 那么将使用 iterator 作为各元素的属性名来对比进行分组.
    ///
    /// - Parameter iterator: 过滤规则
    /// - Returns: 分组后集合
    func groupBy<U: Hashable>( iterator: (Element) -> U) -> [U: [Element]] {
        var grouped = [U: [Element]]()
        for element in self {
            let key = iterator(element)
            if var arr = grouped[key] {
                arr.append(element)
                grouped[key] = arr
            } else {
                grouped[key] = [element]
            }
        }
        return grouped
    }
    
    /// 给定一个list，和 一个用来返回一个在列表中的每个元素键 的iterator 函数（或属性名）， 返回一个每一项索引的对象。和groupBy非常像，但是当你知道你的键是唯一的时候可以使用indexBy
    ///
    /// - Parameter iterator: 过滤规则
    /// - Returns: 分组后集合
    func indexBy<U: Hashable>( iterator: (Element) -> U) -> [U: Element] {
        var grouped = [U: Element]()
        for element in self {
            let key = iterator(element)
            grouped[key] = element
            
        }
        return grouped
    }
    /// 排序一个列表组成一个组，并且返回各组中的对象的数量的计数。类似groupBy，但是不是返回列表的值，而是返回在该组中值的数目。
    ///
    /// - Parameter iterator: 过滤规则
    /// - Returns: 分组后集合
    func countBy<U: Hashable>(iterator: (Element) -> U) -> [U: Int] {
        let group = self.groupBy{iterator($0)}
        var grouped = [U: Int]()
        for element in group {
            grouped[element.key] = element.value.count
            
        }
        return grouped
    }
    /// 返回一个随机乱序的 list 副本, 使用 Fisher-Yates shuffle 来进行随机乱序
    ///
    /// - Returns: 打乱顺序后的副本
    func shuffle() -> [Element] {
        return self.sorted{_,_ in
            arc4random_uniform(2) == 0 ? true : false
        }
    }
    
    /// 从 list中产生一个随机样本。传递一个数字表示从list中返回n个随机元素。否则将返回一个单一的随机项
    ///
    /// - Parameter length: 返回个数
    /// - Returns: 随机样本
    func sample(_ length:Int = 1) -> [Element] {
        var result:[Element] = []
        var copy = self
        for _ in 0..<length {
            let removeIndex = Int(arc4random_uniform(UInt32(copy.count)))
            let removeElement = copy.remove(at: removeIndex)
            result.append(removeElement)
        }
        return result
    }
    /// 从 list中产生一个随机样本。传递一个数字表示从list中返回n个随机元素。否则将返回一个单一的随机项(函数式版)
    ///
    /// - Parameter length: 返回个数
    /// - Returns: 随机样本
    func sample(_ length:()->Int) -> [Element] {
        return self.sample(length())
    }
    /// 拆分一个数组（array）为两个数组：  第一个数组其元素都满足predicate迭代函数， 而第二个的所有元素均不能满足predicate迭代函数。
    ///
    /// - Parameter predicate: 分组条件
    /// - Returns: 分组后数组
    func partition(predicate:(Element)->Bool) -> [[Element]]{
        return self.reduce([[Element](),[Element]()]){
            guard predicate($1) else {
                return [$0[0],$0[1]+[$1]]
            }
            return [$0[0]+[$1],$0[1]]
        }
    }
    /// 返回数组中除了最后n个元素外的其他全部元素
    ///
    /// - Parameter lastIndex: 将从结果中排除从最后一个开始的lastIndex个元素
    func initial(_ lastIndex:Int = 1) -> [Element] {
        return self[0..<self.count  - lastIndex].map{$0}
    }
    /// 返回数组中除了第n个元素外的其他全部元素
    ///
    /// - Parameter startIndex: 将返回从startIndex开始的剩余所有元素
    func rest(_ startIndex:Int = 1) -> [Element] {
        return self[startIndex-1..<self.count].map{$0}
    }
    /// 将一个嵌套多层的数组 array（数组） (嵌套可以是任何层数)转换为只有一层的数组
    ///
    /// - Parameter shallow: 如果你传递 shallow = true，数组将只减少一维的嵌套
    /// - Returns: 转换后的数组
    func flatten(_ shallow:Bool = false) -> [Element]{
        return self.reduce([]){
            guard let arr = $1 as? [Element] else {
                return $0 + [$1]
            }
            guard !shallow else {
                return $0 + arr
            }
            return $0 + arr.flatten()
        }
    }
    /// 将 每个arrays中相应位置的值合并在一起。
    ///
    /// - Parameter arrays: 需要组合的数组
    /// - Returns: 组合后的数组
    func zip(_ arrays:[Any]...) -> [Any] {
        var result = [Any]()
        for (index,element) in self.enumerated() {
            //单条数组
            var item = [element] as [Any]
            arrays.forEach{ item += [$0[index]] }
            result += [item]
        }
        return result
    }
    /// - Parameters:
    ///   - value: 寻找的元素
    ///   - predicate: 判等规则
    /// - Returns: 倒序索引
    func lastIndexOf(_ value:Element,predicate:(Element,Element) -> Bool) -> Int? {
        for index in 0 ..< self.count {
            guard !predicate(value,self[self.count - index - 1 ]) else {
                return index
            }
        }
        return nil
    }
}

extension Array where Element:Equatable {
    /// 比较2个数组的不同项
    ///
    /// - Parameter compare: 比较的数组
    /// - Returns: 不同项
    public func difference(_ compare:[Element]) -> [Element] {
        return self.difference{compare}
    }
    /// 比较2个数组的不同项(函数式版)
    ///
    /// - Parameter compare: 比较的数组
    /// - Returns: 不同项
    public func difference(_ compare:()->[Element]) -> [Element] {
        return self.difference(compare(), transform: ==)
    }
    /// 返回一个删除所有values值后的 array副本
    ///
    /// - Parameter values: 删除的元素
    /// - Returns: 过滤后副本
    func without(_ values:Element...) -> [Element] {
        return self.filter{element in !values.reduce(false){$0||(element == $1)}}
    }
    /// 去重
    ///
    /// - Returns: 排重后的数据
    func uniq() -> [Element] {
        return self.reduce([Element]()){
            guard $0.contains($1) else{
                return $0 + [$1]
            }
            return $0
        }
    }
    /// 返回value在该 array 中的从最后开始的索引值。如果没有找则返回nil
    ///
    /// - Parameter value: 寻找的元素
    /// - Returns: 倒序索引
    func lastIndexOf(_ value:Element) -> Int? {
        for index in 0 ..< self.count {
            guard value != self[self.count - index - 1 ] else {
                return index
            }
        }
        return nil
    }
    
}
extension Array where Element:Hashable {
    /// 返回传入的 arrays（数组）并集：按顺序返回，返回数组的元素是唯一的，可以传入一个或多个 arrays（数组）
    ///
    /// - Parameter arrays: 取并集的数组
    /// - Returns: 并集后数据
    func intersection(_ arrays:[Element]...) -> [Element] {
        return arrays.reduce(self.uniq()){ all , elements in
            all.filter{elements.contains($0)}
        }
    }
    /// 返回传入的 arrays（数组）交集：按顺序返回，返回数组的元素是唯一的，可以传入一个或多个 arrays（数组）
    ///
    /// - Parameter arrays: 取交集的数组
    /// - Returns: 交集后数据
    func union(_ arrays:[Element]...) -> [Element] {
        return arrays.reduce([]){ all , elements in
            let newArr = elements.reduce([Element]()){
                guard all.contains($1) else{
                    return $0 + [$1]
                }
                return $0
            }
            return all + newArr
        }
    }
    /// 将数组转换为对象(字典)。
    ///
    /// - Parameter array: 作为字典value的值
    /// - Returns: 处理后的字典
    func object(_ array:[Any]) -> [Element:Any] {
        var result = [Element:Any]()
        for (index,element) in self.enumerated() {
            result[element] = array[index]
        }
        return result
    }
}
