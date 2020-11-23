//
//  sunrisesunset.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-11-22.
//

import Foundation

struct sunResponse: Codable {
    let results:sunResults
    //let status:String
}

struct sunResults: Codable {
    let sunrise:String
    let sunset:String
}



/*
{
  "results":
  {
    "sunrise":"7:27:02 AM",
    "sunset":"5:05:55 PM",
    "solar_noon":"12:16:28 PM",
    "day_length":"9:38:53",
    "civil_twilight_begin":"6:58:14 AM",
    "civil_twilight_end":"5:34:43 PM",
    "nautical_twilight_begin":"6:25:47 AM",
    "nautical_twilight_end":"6:07:10 PM",
    "astronomical_twilight_begin":"5:54:14 AM",
    "astronomical_twilight_end":"6:38:43 PM"
  },
   "status":"OK"
}*/
