//
//  ContentView.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-11-20.
//

import SwiftUI

struct ContentView: View {
    
    @State var stad = "bla"
    @State var latitude:Float?
    @State var longitude:Float?
    
    @State var sunriseUTCTime:String?
    @State var sunriselocalTime:String?
    @State var sunsetUTCTime:String?
    @State var sunsetlocalTime:String?
    
    @State var guessedTimeHourOffset:Int?
    @State var guessedTimeMinuteOffset:Int?
    @State var currentTime = Date()
    
    var body: some View {
        VStack{
            Button(action: {
                let randomNumber = Int.random(in: 0..<870)
                let url = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?limit=1&offset=\(randomNumber)&minPopulation=1000000&excludedCountryIds=CN"
                getRandomCity(from: url)
                guessedTimeHourOffset = 0
                guessedTimeMinuteOffset = 0
                
            }, label: {
                Text("Boom")
                    .font(.title)
            })
            Text("\(stad)")
                .font(.largeTitle)
                .padding()
            
            DatePicker("", selection: $currentTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            
            Text("Sunset Time: \(sunsetlocalTime ?? "0")")
                .padding()
            Text("Sunrise Time: \(sunriselocalTime ?? "0")")
                .padding()
            
            Button(action: {
                let df = DateFormatter()
                df.dateFormat = "HH:mm"
                var pickedTime = df.string(from: currentTime)
                
                (guessedTimeHourOffset, guessedTimeMinuteOffset) = compareTime(guessedTime: pickedTime, actualTime: sunsetlocalTime!)
                //compareTime(guessedTime: pickedTime, actualTime: sunsetlocalTime!)
                
            }, label: {
                Text("Bam")
            })
            
            Text("You were \(guessedTimeHourOffset ?? 0) hours and \(guessedTimeMinuteOffset ?? 0) minutes off")
                .padding()
        }
    }//BODY END
    
    func getRandomCity(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            //have data
            var result: CityResponse?
            do {
                result = try JSONDecoder().decode((CityResponse.self), from: data)
            }
            catch {
                print("convert failed \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            print(json.data[0].city)
            stad = json.data[0].city + ", " + json.data[0].country
            latitude = json.data[0].latitude
            longitude = json.data[0].longitude
            print(latitude)
            print(longitude)
           
            let sunURL = "https://api.sunrise-sunset.org/json?lat=\(latitude!)&lng=\(longitude!)&date=today"
            getSunriseSunset(from: sunURL)
            
        })
        task.resume()
    }
    
    func getSunriseSunset(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            //have data
            var result: sunResponse?
            do {
                result = try JSONDecoder().decode((sunResponse.self), from: data)
            }
            catch {
                print("convert failed \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            sunriseUTCTime = timeConversion24(time12: json.results.sunrise)
            sunsetUTCTime = timeConversion24(time12: json.results.sunset)
            
            let timeURL = "http://api.timezonedb.com/v2.1/get-time-zone?key=3WMNYAOTEDF5&format=json&by=position&lat=\(latitude!)&lng=\(longitude!)"
            getLocalTime(from: timeURL)
        })
        task.resume()
    }
    
    func getLocalTime(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var result: timezoneResponse?
            do {
                result = try JSONDecoder().decode((timezoneResponse.self), from: data)
            }
            catch {
                print("convert failed \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            print(json.gmtOffset)
            sunsetlocalTime = adjustTimeOffset(time: sunsetUTCTime!, offset: Double(json.gmtOffset))
            sunriselocalTime = adjustTimeOffset(time: sunriseUTCTime!, offset: Double(json.gmtOffset))

            
        })
        task.resume()
    }
    
    func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ssa"

        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm:ss"

        let time24 = df.string(from: date!)
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
    
    func compareTime(guessedTime: String, actualTime: String) -> (sunriseDiff: Int, sunsetDiff: Int)
    {
        let calendar = Calendar.current
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        
       // guessedTimeDate = df.date(from: guessedTime)
        
        let guessedTimeDate = df.date(from: guessedTime)!
        let actualTimeDate = df.date(from: actualTime)!
        
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
            hoursOff -= 1
            minutesOff = 60 - (minutesOff * -1)
        }
        
        print(hoursOff)
        print(minutesOff)
        return (hoursOff, minutesOff)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
