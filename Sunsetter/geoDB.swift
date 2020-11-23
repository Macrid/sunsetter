//
//  geoDB.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-11-22.
//

import Foundation

struct CityResponse: Codable {
    let data:[CityData]
    //let links:[CityLinks]
    //let metadata:CityMetadata
    
}

struct CityData: Codable{
    //let id:Int
    //let wikiDataId:String
    //let type:String
    let city:String
    let name:String
    let country:String
    //let countryCode:String
    //let region:String
    //let regionCode:String
    let latitude:Float
    let longitude:Float
}

struct CityLinks: Codable{
    let rel:String
    let href:String
}

struct CityMetadata: Codable{
    let currentOffset:Int
    let totalCount:Int
}
