//
//  WeekNum.swift
//  Pods
//
//  Created by Anton Siliuk on 07.03.17.
//

import Foundation

public struct WeekNum : OptionSet {
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let first  = WeekNum(rawValue: 1 << 0)
    static let second = WeekNum(rawValue: 1 << 1)
    static let third  = WeekNum(rawValue: 1 << 2)
    static let forth  = WeekNum(rawValue: 1 << 3)
    
    static let oddWeeks:  WeekNum = [first, third]
    static let evenWeeks: WeekNum = [second, forth]
    static let always:    WeekNum = [oddWeeks, evenWeeks]
}

extension WeekNum {

    init?(weekNum: Int) {
        switch weekNum {
        case 0: self = WeekNum.always
        case 1: self = WeekNum.first
        case 2: self = WeekNum.second
        case 3: self = WeekNum.third
        case 4: self = WeekNum.forth
        default: return nil
        }
    }
    
    init(weekNums: [Int]) {
       self = weekNums
            .compactMap(WeekNum.init(weekNum:))
            .reduce([], { $0.union($1) })
    }
}

extension WeekNum : Codable {

    public enum Error : Swift.Error {
        case invalidValue(Int)
    }
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        if let values = try? container.decode([Int].self) {
            self = WeekNum(weekNums: values)
        } else {
            let number = try container.decode(Int.self)
            guard let weekNum = WeekNum(weekNum: number) else { throw Error.invalidValue(number) }
            self = weekNum
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        guard self != .always else {
            try container.encode([0])
            return
        }

        let weekValues: [WeekNum] = [.first, .second, .third, .forth]
        let values = weekValues.flatMap { self.contains($0) ? [$0.rawValue] : [] }
        try container.encode(values)
    }
}
