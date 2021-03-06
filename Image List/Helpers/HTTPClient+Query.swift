//
//  HTTPClient+Query.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

///HTTPClient+Query : Used to convert Dictionary to a queryString for URL encoding
extension HTTPClient {
   private class func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
      var components: [(String, String)] = []
      
      if let dictionary = value as? [String: Any] {
         for (nestedKey, value) in dictionary {
            components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
         }
      } else if let array = value as? [Any] {
         for value in array {
            components += queryComponents(fromKey: "\(key)[]", value: value)
         }
      } else if let value = value as? NSNumber {
         if value is Bool {
            components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
         } else {
            components.append((escape(key), escape("\(value)")))
         }
      } else if let bool = value as? Bool {
         components.append((escape(key), escape((bool ? "1" : "0"))))
      } else {
         components.append((escape(key), escape("\(value)")))
      }
      
      return components
   }
   
   /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
   ///
   /// RFC 3986 states that the following characters are "reserved" characters.
   ///
   /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
   /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
   ///
   /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
   /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
   /// should be percent-escaped in the query string.
   ///
   /// - parameter string: The string to be percent-escaped.
   ///
   /// - returns: The percent-escaped string.
   private class func escape(_ string: String) -> String {
      let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
      let subDelimitersToEncode = "!$&'()*+,;="
      
      var allowedCharacterSet = CharacterSet.urlQueryAllowed
      allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
      
      var escaped = ""
      
      escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
      
      return escaped
   }
   
   class func queryString(from parameters: [String: Any]) -> String {
      var components: [(String, String)] = []
      
      for key in parameters.keys.sorted(by: <) {
         let value = parameters[key]!
         components += queryComponents(fromKey: key, value: value)
      }
      return components.map { "\($0)=\($1)" }.joined(separator: "&")
   }
   
}
