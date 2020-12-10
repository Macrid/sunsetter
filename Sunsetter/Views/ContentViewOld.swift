//
//  ContentView.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-11-20.
//

import SwiftUI
/*
struct ContentViewOld: View {
    
    @State var stad = ""
    @State var latitude:Float?
    @State var longitude:Float?
    
    @State var sunriseUTCTime:String?
    @State var sunriselocalTime:String?
    @State var sunsetUTCTime:String?
    @State var sunsetlocalTime:String?
    
   // @State var guessedTimeHourOffset:Int?
   // @State var guessedTimeMinuteOffset:Int?
    @State var currentTime = Date()
    
    @State var isSunrise = Bool.random()
    @State var guessInProgress = false
    
    var body: some View {
        VStack{
            Button(action: {
                getRandomCity()
                guessedTimeHourOffset = 0
                guessedTimeMinuteOffset = 0
                isSunrise = Bool.random()
                guessInProgress.toggle()
                
            }, label: {
                Text("Boom")
                    .font(.title)
            })
            .isHidden(guessInProgress, remove: guessInProgress)
            

            if(isSunrise)
            {
                Text("When does the sun rise in:")
                    .isHidden(!guessInProgress, remove: !guessInProgress)
            } else{
                Text("When does the sun set in:")
                    .isHidden(!guessInProgress, remove: !guessInProgress)
            }
            

            
            Text("\(stad)")
                .font(.largeTitle)
                .padding()
                
            
            DatePicker("", selection: $currentTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .isHidden(!guessInProgress, remove: !guessInProgress)
            
            Text("Sunset Time: \(sunsetlocalTime ?? "0")")
                .padding()
                .isHidden(guessInProgress, remove: guessInProgress)
            Text("Sunrise Time: \(sunriselocalTime ?? "0")")
                .padding()
            
            Button(action: {
                let df = DateFormatter()
                df.dateFormat = "HH:mm"
                var pickedTime = df.string(from: currentTime)
                
                (guessedTimeHourOffset, guessedTimeMinuteOffset) = compareTime(guessedTime: pickedTime, actualTime: sunsetlocalTime!)
                guessInProgress.toggle()
                
            }, label: {
                Text("Bam")
            })
            .isHidden(!guessInProgress, remove: !guessInProgress)
            
            Text("You were \(guessedTimeHourOffset ?? 0) hours and \(guessedTimeMinuteOffset ?? 0) minutes off")
                .padding()
                .isHidden(guessInProgress, remove: guessInProgress)
        }
    }//BODY END
    
    func getRandomCity(){
        let randomNumber = Int.random(in: 0..<870)
        let url = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?limit=1&offset=\(randomNumber)&minPopulation=1000000&excludedCountryIds=CN"
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

extension View {
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .isHidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .isHidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewOld()
    }
 }*/
