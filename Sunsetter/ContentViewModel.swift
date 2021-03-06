//
//  viewModel.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-12-06.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    
    var cityName = ""
    var cityCountry = ""
    var latitude:Float?
    var longitude:Float?
    
    var sunriseUTCTime:String?
    var sunriselocalTime:String?
    var sunsetUTCTime:String?
    var sunsetlocalTime:String?
    
    var gmtOffset:Int?
    
    var guessedTimeHourOffset:Int?
    var guessedTimeMinuteOffset:Int?
    var currentTime = Date()
    
    @Published var rightOrWrongText:String?
    
    @Published var points:Int?
    
    @Published var isSunrise = Bool.random()
    
    @Published var loadInProgress = true
    
    @Published var currentCity:City?
    
    private init() {
        let defaults = UserDefaults.standard
        if let key = defaults.object(forKey: "points")
        {
            points = key as? Int
        }else{
            defaults.setValue(0, forKey: "points")
            points = 0
        }
    }
    
    static let shared = ContentViewModel()
    
    func getResult(guessedTime: Date){
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        
        let guessedTimeString = df.string(from: guessedTime)
        
        if(isSunrise)
        {
            (guessedTimeHourOffset, guessedTimeMinuteOffset) = compareTime(guessedTime: guessedTimeString, actualTime: self.currentCity!.sunrise)
        } else{
            (guessedTimeHourOffset, guessedTimeMinuteOffset) = compareTime(guessedTime: guessedTimeString, actualTime: self.currentCity!.sunset)
        }
        
        if(guessedTimeHourOffset == 0 && guessedTimeMinuteOffset == 0)
        {
            correctGuess()
        }
        getResultString()
    }
    
    func getResultString(){
        if (guessedTimeHourOffset == 0 && guessedTimeMinuteOffset == 0) {
            rightOrWrongText = "Wow, you got it exactly right!"
        }else {
            rightOrWrongText = "Your guess was \(guessedTimeHourOffset ?? 0) hours and \(guessedTimeMinuteOffset ?? 0) minutes off"
        }
    }
    
    func correctGuess()
    {
        let defaults = UserDefaults.standard
        self.points! += 1
        defaults.setValue(points, forKey: "points")
    }
    
    func getRandomCity(){
        DispatchQueue.main.async {
            self.loadInProgress = true
        }
        let randomNumber = Int.random(in: 0..<870)
        let url = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?limit=1&offset=\(randomNumber)&minPopulation=1000000&excludedCountryIds=CN"
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                self.getRandomCity()
                print("something went wrong")
                return
            }
            //have data
            var result: CityResponse?
            do {
                result = try JSONDecoder().decode((CityResponse.self), from: data)
            }
            catch {
                self.getRandomCity()
                print("convert failed \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            self.cityName = json.data[0].city
            self.cityCountry = json.data[0].country
            self.latitude = json.data[0].latitude
            self.longitude = json.data[0].longitude
            
            self.getSunriseSunset()
            
        })
        task.resume()
    }
    
    func getSunriseSunset(){
        let url = "https://api.sunrise-sunset.org/json?lat=\(latitude!)&lng=\(longitude!)&date=today"
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                self.getRandomCity()
                print("something went wrong")
                return
            }
            //have data
            var result: sunResponse?
            do {
                result = try JSONDecoder().decode((sunResponse.self), from: data)
            }
            catch {
                self.getRandomCity()
                print("convert failed \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            self.sunriseUTCTime = self.timeConversion24(time12: json.results.sunrise)
            self.sunsetUTCTime = self.timeConversion24(time12: json.results.sunset)
            
            self.getLocalTime()
        })
        task.resume()
    }
    
    func getLocalTime(){
        let url = "http://api.timezonedb.com/v2.1/get-time-zone?key=3WMNYAOTEDF5&format=json&by=position&lat=\(latitude!)&lng=\(longitude!)"
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                self.getRandomCity()
                print("something went wrong")
                return
            }
            
            var result: timezoneResponse?
            do {
                result = try JSONDecoder().decode((timezoneResponse.self), from: data)
            }
            catch {
                self.getRandomCity()
                print("convert failed \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            self.gmtOffset = json.gmtOffset
            self.sunsetlocalTime = self.adjustTimeOffset(time: self.sunsetUTCTime!, offset: Double(json.gmtOffset))
            self.sunriselocalTime = self.adjustTimeOffset(time: self.sunriseUTCTime!, offset: Double(json.gmtOffset))
            
            DispatchQueue.main.async {
                self.replaceCurrentCity()
            }
            
        })
        task.resume()
    }
    
    func replaceCurrentCity(){
        isSunrise = Bool.random()
        currentCity = City(name: cityName, country: cityCountry, latitude: latitude!, longitude: longitude!, sunrise: sunriselocalTime!, sunset: sunsetlocalTime!, gmtOffset: gmtOffset!)
        self.loadInProgress = false
    }
    
    func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ssa"
        
        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm:ss"
        
        let time24 = df.string(from: date ?? Date.init())
        print(time24)
        return time24
    }
    
    func adjustTimeOffset(time: String, offset: Double) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        
        var localTime = df.date(from: time)
        df.dateFormat = "HH:mm"
        localTime! += offset
        
        let localTimeString = df.string(from: localTime!)
        return localTimeString
    }
    
    func compareTime(guessedTime: String, actualTime: String) -> (hoursDiff: Int, minutesDiff: Int)
    {
        let calendar = Calendar.current
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        
        
        let guessedTimeDate = df.date(from: guessedTime)!
        let actualTimeDate = df.date(from: actualTime)!
        
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: actualTimeDate, to: guessedTimeDate)
        
        let diffComponentsReverse = Calendar.current.dateComponents([.hour, .minute], from: guessedTimeDate, to: actualTimeDate)
        
        var hoursOff = min(diffComponents.hour!, diffComponentsReverse.hour!)
        var minutesOff = diffComponents.minute!
        
        
        //WORKS FOR SUNSET AND SUNSET HOPEFULLY
        if(isSunrise == false)
        {
            if(hoursOff < 0)
            {
                hoursOff = hoursOff * -1
                if(hoursOff >= 12)
                {
                    let rest = hoursOff % 12
                    hoursOff = 12 - rest
                    
                    if(minutesOff < 0)
                    {
                        hoursOff -= 1
                        minutesOff = 60 + minutesOff
                    }
                }
                
            }
            
            if(minutesOff < 0)
            {
                minutesOff = minutesOff * -1
            }
        } else {
            
            if(hoursOff < 0)
            {
                hoursOff = hoursOff * -1
                if(hoursOff >= 12)
                {
                    let rest = hoursOff % 12
                    hoursOff = 12 - rest
                    
                    if(minutesOff > 0)
                    {
                        hoursOff -= 1
                        minutesOff = 60 - minutesOff
                    }
                }
                
            }
            
            if(minutesOff < 0)
            {
                minutesOff = minutesOff * -1
            }
        }
        /*
         if(minutesOff < 0)
         {
         minutesOff = 60 - minutesOff
         hoursOff -= 1
         
         }
         
         if(hoursOff >= 12)
         {
         hoursOff = 24 - hoursOff
         /* if(minutesOff >= 30)
         {
         minutesOff = 60 - minutesOff
         hoursOff -= 1
         }*/
         
         }
         */
        
        /*
         let guessedTimeDateComponents = calendar.dateComponents([.hour, .minute], from: guessedTimeDate)
         let actualTimeDateComponents = calendar.dateComponents([.hour, .minute], from: actualTimeDate)
         
         var hoursOff = actualTimeDateComponents.hour! - guessedTimeDateComponents.hour!
         
         var minutesOff = actualTimeDateComponents.minute! - guessedTimeDateComponents.minute!
         
         if(hoursOff < 0)
         {
         hoursOff = hoursOff * -1
         }
         if(hoursOff > 12)
         {
         hoursOff = 12 - (hoursOff-12)
         }
         
         if(minutesOff < 0)
         {
         if(hoursOff > 0)
         {
         hoursOff -= 1
         minutesOff = minutesOff * -1
         }else{
         minutesOff = 60 - (minutesOff * -1)
         }
         }
         */
        return (hoursOff, minutesOff)
    }
    
    
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
