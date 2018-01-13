//
//  main.swift
//  Mjukglass
//
//  Created by Anton Roslund on 2017-10-24.
//  Copyright © 2017 Anton Roslund. All rights reserved.
//

import Foundation
import KronoxComunicator

let friends = ["ard15003", "mtt15001", "acn15007", "sbn15005", "jni15001", "rds15001"]
let pathToSavedSessionid = URL(string : "file:///Users/enari/.mjukglass/sessionid")!

let helpString = """
                Avalible Commands are:

                login           - Logg in with oyu mdh credentials
                help            - Print this help
                mybookings      - Dislayes your bookings
                bookings [Date] - Prints the booking schedule for today. Optional aurgument Date in format YYYY-MM-DD
                unbook ID       - Lets you delete a booking made by you.

                """

var kronoxComunicator = KronoxComunicator()


if(CommandLine.arguments.count == 1){
   print(helpString)
    exit(0)
}

if(CommandLine.arguments[1] == "login")
{
    let credentials = getUsernameAndPasswordFromConsole()
    kronoxComunicator.startSession()

    print("Logining in: ", terminator: "")
    if !kronoxComunicator.login(username: credentials.username, password: credentials.password).status {
        print("Login failed")
        exit(0)
    }
    do {
        try kronoxComunicator.sessionCookie?.value.write(to: pathToSavedSessionid, atomically: false, encoding: .utf8)
    }
    catch {
        print("error writing file")
    }
    print("OK")
    exit(0)
}

let sessionIDfromFile : String?
do {
    sessionIDfromFile = try String(contentsOf: pathToSavedSessionid, encoding: .utf8)
}
catch {
    sessionIDfromFile = nil
}

if(sessionIDfromFile != nil) {
    kronoxComunicator = KronoxComunicator(JSESSIONID: sessionIDfromFile!)
}

if(!kronoxComunicator.isLoggedIn()){
    print("You are not logged in, please login")
    exit(0)
}
    
switch CommandLine.arguments[1] {
    
    case "bookings":
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = CommandLine.arguments.indices.contains(2) ? (dateFormatter.date(from: CommandLine.arguments[2]) ?? Date()) : Date()
        
        let bookings = kronoxComunicator.getBookings(date)
        let bookingsWithColor = colorBookingTable(bookings: bookings, friends: friends)
        printBookingsToConsole(bookingsWithColor, headerDate: date)
    case "mybookings":
        printMyBookingsToConsole(kronoxComunicator.getMyBookings())

    case "unbook":
        UnBookInteractive(bokningnummer: Int(CommandLine.arguments[2])!)

    default :
        print("Unknow command, use \"help\" to show avalible commands")
    
}


