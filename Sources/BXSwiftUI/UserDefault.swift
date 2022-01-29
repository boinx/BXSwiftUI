//**********************************************************************************************************************
//
//  UserDefault.swift
//	Property wrappers for easy access to preferences values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Combine
import Foundation


//----------------------------------------------------------------------------------------------------------------------


@propertyWrapper public struct UserDefault<T>
{
    let key:String
    let defaultValue:T
    let validator:(T)->T
	let publisher = PassthroughSubject<T,Never>()
	
	public init(_ key:String, defaultValue:T, validator:@escaping (T)->T = {$0})
    {
        self.key = key.replacingOccurrences(of:".", with:"-")	// UserDefaults doesn't like keys containing "." so replace them
        self.defaultValue = defaultValue
        self.validator = validator
        
    }

    public var wrappedValue : T
    {
        get
        {
            return UserDefaults.standard.object(forKey:key) as? T ?? defaultValue
        }
        
        set
        {
			let value = self.validator(newValue)
			UserDefaults.standard.set(value, forKey:key)
			publisher.send(newValue)
        }
    }
    
    public var projectedValue:PassthroughSubject<T,Never>
    {
		return publisher
    }
}


//----------------------------------------------------------------------------------------------------------------------


@propertyWrapper public struct EncodedUserDefault<T:Codable>
{
    let key:String
    let defaultValue:T
    let validator:(T)->T
	let publisher = PassthroughSubject<T,Never>()

    public init(_ key:String, defaultValue:T, validator:@escaping (T)->T = {$0})
    {
        self.key = key.replacingOccurrences(of:".", with:"-")	// UserDefaults doesn't like keys containing "." so replace them
        self.defaultValue = defaultValue
		self.validator = validator
   }

    public var wrappedValue : T
    {
        get
        {
			let data = UserDefaults.standard.data(forKey: key)
			let value = data.flatMap { try? JSONDecoder().decode(T.self,from:$0) }
			return value ?? defaultValue
        }
        
        set
        {
			let value = self.validator(newValue)
            let data = try? JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey:key)
            publisher.send(newValue)
        }
    }
    
    public var projectedValue:PassthroughSubject<T,Never>
    {
		return publisher
    }
}


//----------------------------------------------------------------------------------------------------------------------


@propertyWrapper public struct RawUserDefault<T:RawRepresentable>
{
    let key:String
    let defaultValue:T
    let validator:(T)->T
	let publisher = PassthroughSubject<T,Never>()

    public init(_ key:String, defaultValue:T, validator:@escaping (T)->T = {$0})
    {
        self.key = key.replacingOccurrences(of:".", with:"-")	// UserDefaults doesn't like keys containing "." so replace them
        self.defaultValue = defaultValue
		self.validator = validator
    }

    public var wrappedValue : T
    {
        get
        {
			guard let raw = UserDefaults.standard.value(forKey: key) as? T.RawValue else { return defaultValue }
			let value = T.init(rawValue:raw)
			return value ?? defaultValue
        }
        
        set
        {
			let value = self.validator(newValue)
			let raw = value.rawValue
            UserDefaults.standard.set(raw, forKey:key)
            publisher.send(newValue)
        }
    }
    
    public var projectedValue:PassthroughSubject<T,Never>
    {
		return publisher
    }
}


//----------------------------------------------------------------------------------------------------------------------
