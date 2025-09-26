//
//  CryptoHelper.swift
//  LionsAttendance
//
//  Created by Mata Prasad Chauhan on 01/11/17.
//

import Foundation
import CryptoSwift
import SwiftJWT

struct MyClaims: Claims {
    let email: String
}

struct MyNewClaims: Claims {
    let email: String
    let deviceId: String
    let exp: Date
    let nbf: Date
    let audience: String
    let issuer: String
    let sub: String
}


class RCryptoHelper {
    
   // private static let key = "@u$$!zz@((L@#$%^";//16 char secret key
    private static let key :String = "|<O/|)#$|<@!2021"
    
    public static func encrypt(input:String)->String? {
        
            do {
                
                let encrypted: Array<UInt8> = try AES(key: key, iv: key, padding: .pkcs5).encrypt(Array(input.utf8))
                return encrypted.toBase64()
            } catch {
                print("JWT failed.")
            }
        return nil
    }
    
    public static func decrypt(input:String)->String? {
        
            do {
                let d = Data(base64Encoded: input)
                let decrypted = try AES(key: key, iv: key, padding: .pkcs5).decrypt(
                    d!.bytes)
                return String(data: Data(decrypted), encoding: .utf8)
            } catch {
                print("JWT failed.")
            }
        return nil
    }
    
    public static func encryptNew(input:String)->String? {
        
        do {
            
            let encrypted: Array<UInt8> = try AES(key: key, iv: key, padding: .pkcs7).encrypt(Array(input.utf8))
            return encrypted.toBase64().replacingOccurrences(of: "_", with: "/")

        } catch {
            print("JWT failed.")
        }
        return nil
    }
    
    public static func decryptNew(input:String)->String? {
        
        do {
            let inputData = input.replacingOccurrences(of: "_", with: "/")
            let d = Data(base64Encoded: inputData)
            let decrypted = try AES(key: key, iv: key, padding: .pkcs7).decrypt(
                d!.bytes)
            return String(data: Data(decrypted), encoding: .utf8)
            
        } catch {
            print("JWT failed.")
        }
        return nil
    }
    
    public static func encryptedParams(_ params : [String:Any]?) -> String {
        let parameters = try! JSONSerialization.data(withJSONObject: params ?? [:], options: [])
        let decoded = String(data: parameters, encoding: .utf8) ?? ""
        print("decoded",decoded)
        return  RCryptoHelper.encrypt(input:decoded)!
    }
    
    public static func encryptedNewParams(_ data : Any?) -> String {
        
        if let dict = data as? Dictionary<String,Any> {
            let parameters = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let decoded = String(data: parameters, encoding: .utf8) ?? ""
            print("decoded",decoded)
            return  RCryptoHelper.encryptNew(input:decoded)!
        } else if let stringData = data as? String {
            return  RCryptoHelper.encryptNew(input:stringData)!
        }
        return ""
    }
    
    public static func generateJWT(emailID : String) -> String {
        
        var base64JWT = ""
        let myHeader = Header(kid: "KeyID1")
        let myClaims = MyClaims(email: emailID)
        let myJWT = JWT(header: myHeader, claims: myClaims)
        
        //if let key = RouterManager.shared.jwtKey {
            do {
                
                let data: Data = RCryptoHelper.key.data(using: .utf8)!
                let jwtSigner = JWTSigner.hs256(key: data)
                let jwtEncoder = JWTEncoder(jwtSigner: jwtSigner)
                let JWTString = try jwtEncoder.encodeToString(myJWT)

                if let data = (JWTString).data(using: String.Encoding.utf8) {
                    base64JWT = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
                    print(base64JWT)
                }
                
            }catch{
                print("JWT failed.")
            }
        //}
        
        return base64JWT
    }
    
    public static func generateNewJWT(emailId : String, deviceId: String, issuer: String, audience: String, timeComponent: Calendar.Component, timeValue: Int) -> String {
        
        var base64JWT = ""
        let myHeader = Header(kid: "KeyID1")
        var calendar = Calendar.current
        let utcTimezone = TimeZone(abbreviation: "UTC")
        calendar.timeZone = utcTimezone!
        let futureDate = calendar.date(byAdding: timeComponent, value: timeValue, to: Date()) ?? Date()
        let myClaims = MyNewClaims(email: emailId,
                                deviceId: deviceId,
                                exp: futureDate,
                                nbf: calendar.date(from: calendar.dateComponents(in: utcTimezone!, from: Date())) ?? Date(),
                                audience: audience,
                                issuer: issuer,
                                sub: emailId)
        let myJWT = JWT(header: myHeader, claims: myClaims)
        
        //if let key = RouterManager.shared.jwtKey {
        do {
            
            let data: Data = RCryptoHelper.key.data(using: .utf8)!
            let jwtSigner = JWTSigner.hs512(key: data)
            let jwtEncoder = JWTEncoder(jwtSigner: jwtSigner)
            let JWTString = try jwtEncoder.encodeToString(myJWT)
            
            if let data = (JWTString).data(using: String.Encoding.utf8) {
                base64JWT = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
                print(base64JWT)
            }
            
        }catch{
            print("JWT failed.")
        }
        //}
        
        return base64JWT
        
    }
    
}
