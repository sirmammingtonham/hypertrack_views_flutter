//
//  ToJSON.swift
//  Swift3Project
//
//  Created by Yilei He on 9/1/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import Foundation
import CoreGraphics


public protocol JSONConvertible {
    func toJSON() -> JSONCompatible
}

public protocol JSONCompatible: JSONConvertible {}


extension JSONCompatible {
    public func toJSON() -> JSONCompatible {
        return self
    }
}

extension ObjCBool: JSONCompatible {}
extension Bool: JSONCompatible {}
extension CGFloat: JSONCompatible {}

extension String: JSONCompatible {}
extension NSString: JSONCompatible {}

extension Int: JSONCompatible {}
extension Int8: JSONCompatible {}
extension Int16: JSONCompatible {}
extension Int32: JSONCompatible {}
extension Int64: JSONCompatible {}

extension UInt: JSONCompatible {}
extension UInt8: JSONCompatible {}
extension UInt16: JSONCompatible {}
extension UInt32: JSONCompatible {}
extension UInt64: JSONCompatible {}

extension Float: JSONCompatible {}// aka. Float32
extension Double: JSONCompatible {}// aka. Float64
extension NSNull: JSONCompatible {}

extension NSNumber: JSONCompatible {}


extension JSONSerialization {
    
    
    /// This method generates json object from any instance of a class or a struct, or a dictionary of valid item. **Note, This method only accept a instance of a class or a struct.**
    ///
    /// Define: A valid item is an object whose properties are all objects that conforms to JSONCompatible.
    /// - Parameter any: Any instance of a class or a struct
    /// - Returns: A json object whose root is a dictionary. If the parameter passed in is not a a instance of a class or struct, this method returns nil
    public static func jsonDictionaryObject(with any: Any) -> [String: Any]? {
        return YHJSONGenerator.JSONDict(from: any)
    }
    
    
    
    /// This method generates json object from any array(or set) of instances. **Note, This method only accept a collection of valid items.**
    ///
    /// Define: A valid item is an object whose properties are all objects that conforms to JSONCompatible.
    ///
    /// - Parameter any: A collection of valid items.
    /// - Returns: A json object whose root is an array.
    public static func jsonArrayObject(with any: Any) -> [Any]? {
        return YHJSONGenerator.JSONArray(from: any)
    }
    
    
    
    
    /// This method combines the `jsonDictionaryObject(with any: Any) -> [String: Any]?` and `jsonArrayObject(with any: Any) -> [Any]?`. In other words, it only accept a instance of a class or struct or a collection of valid items.
    ///
    /// - Parameters:
    ///   - any: Any instace
    ///   - opt: The options to write jsonObject
    /// - Returns: Data generated from JSON Object
    public static func jsonData(with any: Any, options opt: JSONSerialization.WritingOptions = []) throws -> Data {
        return try YHJSONGenerator.JSONData(from: any, options: opt)
    }
}



public struct YHJSONGenerator {
    
    public static func JSONDict(from anyStructOrObject: Any) -> [String: Any]? {
        var result = [String: Any]()
        let mirror = Mirror(reflecting: anyStructOrObject)
        guard mirror.displayStyle == .struct || mirror.displayStyle == .class || mirror.displayStyle == .dictionary else {
            print("YHJSONGenerator - Not supported object: This method only generat dictionary for a class or a struct.")
            return nil
        }
        
        if mirror.displayStyle == .dictionary, let dict = evaluateDictionary(anyStructOrObject) {
            
            for (key, value) in dict {
                if let key = key as? String, let value = evaluateJSON(value) {
                    result[key] = value
                }
            }
            return result
            
        } else {
            
            for child in mirror.children {
                guard let label = child.label, let value = evaluateJSON(child.value) else {continue}
                result[label] = value
            }
            
            return result
            
        }

        
    }
    
    
    public static func JSONArray(from anyCollection: Any) -> [Any]? {
        var result = [Any]()
        let mirror = Mirror(reflecting: anyCollection)
        
        guard mirror.displayStyle == .collection || mirror.displayStyle == .tuple || mirror.displayStyle == .set else {
            print("YHJSONGenerator - Not supported object: This method only generat dictionary for a collection or a tuple.")
            return nil
        }
        
        for child in mirror.children {
            guard let value = evaluateJSON(child.value) else {continue}
            result.append(value)
        }
        
        return result
    }
    
    
    public static func JSONData(from any: Any, options opt: JSONSerialization.WritingOptions = []) throws -> Data {
        if let json = JSONDict(from: any) {
            return try JSONSerialization.data(withJSONObject: json, options: opt)
        } else if let json = JSONArray(from: any) {
            return try JSONSerialization.data(withJSONObject: json, options: opt)
        }
        
        throw NSError(domain: "YHJSONGenerator", code: 0, userInfo: [NSLocalizedDescriptionKey: "Parameter type \"\(Mirror(reflecting: any).subjectType)\" not supported"])
    }
    
    
    // MARK: -
    // MARK: - Process Any -
    private static func evaluateDictionary(_ any: Any) -> [AnyHashable: Any]? {
        var dict: [AnyHashable: Any] = [:]
        
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .dictionary else {return nil}
        for (_, value) in mirror.children {
            let subMirror = Mirror(reflecting: value)
            if subMirror.displayStyle == .tuple, subMirror.children.count == 2 {
                let c = subMirror.children
                if let key = c[c.startIndex].value as? AnyHashable {
                    let value = c[c.index(after: c.startIndex)].value
                    dict[key] = value
                }
            }
        }
        return dict
    }
    
    
    
    /// unwrap exact value from a variable of Any type that may has an optional value inside
    ///
    /// - Parameter anyOptional: instance of "Any" type
    /// - Returns: If the object has Optional type inside, return the Optional value's unwrapped value, otherwise, return nil(Even if the object has some value that is not optional).
    private static func evaluateOptionalAndUnwrap(_ any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional else {return nil}
        return mirror.children.first?.value
    }
    
    
    
    private static func evaluateCollection(_ any: Any) -> [Any]? {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .collection || mirror.displayStyle == .set || mirror.displayStyle == .tuple else {return nil}
        return mirror.children.map{$0.value}
    }
    
    
    
    // MARK: - process to JSON -
    // MARK: dictionary
    private static func evaluateJSONDictionary(dict: [AnyHashable: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        for (key, value) in dict {
            if let strKey = key as? String {
                if let jsonVal = value as? JSONConvertible {
                    result[strKey] = jsonVal.toJSON()
                } else if let json = evaluateJSON(value) {
                    result[strKey] = json
                }
            } else {
                print("YHJSONGenerator - Not supported object: \(dict)")
                print("YHJSONGenerator - Not supported dictionary key: \(key)")
            }
            
        }
        return result
    }
    
    
    // MARK: array
    private static func evaluateJSONArray(array: [Any]) -> [Any] {
        var result: [Any] = []
        for item in array {
            if let item = item as? JSONConvertible {
                result.append(item.toJSON())
            } else if let json = evaluateJSON(item) {
                result.append(json)
            }
        }
        return result
    }
    
    
    // MARK: optional
    private static func evaluateJSONOptional(any: Any) -> Any? {
        if let item = any as? JSONConvertible {
            return item.toJSON()
        } else {
            return evaluateJSON(any)
        }
    }
    
    
    // MARK: enum
    private static func evaluateJSONEnum(_ any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .enum else {return nil}
        
        if let stringValue = (any as? AnyHashable)?.description {// if no associated value
            return stringValue
        } else {
            
            if let c = mirror.children.first, let subLabel = c.label, Mirror(reflecting: c.value).displayStyle == .tuple {
                if let vals = evaluateCollection(c.value) {
                    var arr:[JSONCompatible] = []
                    for val in vals {
                        if let jsonVal = val as? JSONConvertible {
                            arr.append(jsonVal.toJSON())
                        }
                    }
                    return [subLabel: arr]
                } else {
                    print("YHJSONGenerator - Not supported object: \(any)")
                    return nil
                }
            } else {
                return String(reflecting: any).components(separatedBy: ".").last
            }
        }
    }
    
    
    
    // MARK: all
    private static func evaluateJSON(_ any: Any) -> Any? {
        
        let mirror = Mirror(reflecting: any)
        if let jsonItem = any as? JSONConvertible {
            
            return jsonItem.toJSON()
            
        } else if let dict = evaluateDictionary(any) {
            
            return evaluateJSONDictionary(dict: dict)
            
        } else if let array = evaluateCollection(any) {
            
            return evaluateJSONArray(array: array)
            
        } else if mirror.displayStyle == .optional {
            if let unwrapped = evaluateOptionalAndUnwrap(any) {
                return evaluateJSONOptional(any: unwrapped)
            } else {
                return NSNull()
            }
            
        } else if let enumObject = evaluateJSONEnum(any) {
            
            return enumObject
            
        }
        
        if mirror.displayStyle == .struct || mirror.displayStyle == .class {
            return JSONDict(from: any)
        }
        
        return nil
    }

    
    
    
}
