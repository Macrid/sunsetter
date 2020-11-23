//
//  timezoneDB.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-11-23.
//

import Foundation

struct timezoneResponse: Codable {
    let gmtOffset:Int
}


/*
 {
     "status": "OK",
     "message": "",
     "countryCode": "US",
     "countryName": "United States",
     "regionName": "New York",
     "cityName": "Statue of Liberty",
     "zoneName": "America\/New_York",
     "abbreviation": "EST",
     "gmtOffset": -18000,
     "dst": "0",
     "zoneStart": 1604210400,
     "zoneEnd": 1615705200,
     "nextAbbreviation": "EDT",
     "timestamp": 1606119091,
     "formatted": "2020-11-23 08:11:31"
 }

 */
