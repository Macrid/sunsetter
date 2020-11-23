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
    
    
    @State var sunriseUTCTime:Date?
    @State var sunriselocalTime:Date?
    @State var sunsetUTCTime:Date?
    @State var sunsetlocalTime:Date?
    
    var body: some View {
        VStack{
            Text("\(stad)")
                .padding()
            
            Button(action: {
                let randomNumber = Int.random(in: 0..<870)
                let url = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?limit=1&offset=\(randomNumber)&minPopulation=1000000&excludedCountryIds=CN"
                getRandomCity(from: url)
                
            }, label: {
                Text("Boom")
            })
            
            Button(action: {
                let url = "https://api.sunrise-sunset.org/json?lat=\(latitude!)&lng=\(longitude!)&date=today"
                getSunriseSunset(from: url)
                
            }, label: {
                Text("Bam")
            })
        }
    } //BODY END
    
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
            stad = json.data[0].city
            latitude = json.data[0].latitude
            longitude = json.data[0].longitude
            print(latitude)
            print(longitude)
            
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
            
            sunriseUTCTime = json.results.sunrise
            sunsetUTCTime = json.results.sunset
            
            print(json.results.sunrise)
            print(json.results.sunset)
            
        })
        task.resume()
    }
    
    func getLocalTime(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            //have data
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
            
            sunriselocalTime = sunriseUTCTime +
            
        })
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
