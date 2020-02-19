//**********************************************************************************************************************
//
//  UserDefault.swift
//	Property wrappers for easy access to preferences values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


@propertyWrapper public struct UserDefault<T>
{
    let key:String
    let defaultValue:T
	
    public init(_ key:String, defaultValue:T)
    {
        self.key = key.replacingOccurrences(of:".", with:"-")	// UserDefaults doesn't like keys containing "." so replace them
        self.defaultValue = defaultValue
    }

    public var wrappedValue : T
    {
        get
        {
            return UserDefaults.standard.object(forKey:key) as? T ?? defaultValue
        }
        
        set
        {
			UserDefaults.standard.set(newValue, forKey:key)
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------


@propertyWrapper public struct EncodedUserDefault<T:Codable>
{
    let key:String
    let defaultValue:T

    public init(_ key:String, defaultValue:T)
    {
        self.key = key.replacingOccurrences(of:".", with:"-")	// UserDefaults doesn't like keys containing "." so replace them
        self.defaultValue = defaultValue
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
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey:key)
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------
