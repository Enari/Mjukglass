//
//  interactiveCommandLineStuff.swift
//  Mjukglass
//
//  Created by Anton Roslund on 2017-11-28.
//  Copyright © 2017 Anton Roslund. All rights reserved.
//

import Foundation
import SwiftyTextTable
import KronoxComunicator

let bookingIntervalls = ["08:15 - 10:00",
                         "10:15 - 12:00",
                         "12:15 - 14:00",
                         "14:15 - 16:00",
                         "16:15 - 18:00",
                         "18:15 - 20:00"]

func printMyBookingsToConsole(_ bookings : [Booking]) {
    let id = TextTableColumn(header: "id")
    let date = TextTableColumn(header: "Date")
    let time = TextTableColumn(header: "Time")
    let room = TextTableColumn(header: "Room")
    let booker = TextTableColumn(header: "Booker")
    
    // Then create a table with the columns
    var table = TextTable(columns: [id, date, time, room, booker])
    table.header = "My Bookings"
    
    
    for (i, booking) in bookings.enumerated() {
        table.addRow(values: [i, booking.date, booking.time, booking.room, booking.booker])
    }
    
    
    print(table.render())
}

func printBookingsToConsole(_ rows : [[String]], headerString: String? = nil, headerDate: Date? = nil) {
    let col1 = TextTableColumn(header: "Room")
    let col2 = TextTableColumn(header: "08:15 - 10:00")
    let col3 = TextTableColumn(header: "10:15 - 12:00")
    let col4 = TextTableColumn(header: "12:15 - 14:00")
    let col5 = TextTableColumn(header: "14:15 - 16:00")
    let col6 = TextTableColumn(header: "16:15 - 18:00")
    let col7 = TextTableColumn(header: "18:15 - 20:00")
    
    // Then create a table with the columns
    var table = TextTable(columns: [col1, col2, col3, col4, col5, col6, col7])
    
    
    // Set the header of the table if we get any...
    if let header = headerString {
        table.header = "Bookings for \(header)"
    }
    else if let header = headerDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        table.header = "Bookings for \(dateFormatter.string(from: header))"
    }
    
    
    for row in rows {
        table.addRow(values: row)
    }
    
    
    print(table.render())
}

func colorBookingTable(bookings: [[String]], friends: [String] = []) -> [[String]]{
    
    var bookingWithColoredFriends : [[String]] = []
    
    for row in bookings {
        var rowWithColor : [String] = []
        
        for cell in row {
            if friends.contains(cell) {
                rowWithColor.append(StringColor.boldBlue + cell + StringColor.black)
            }
            else if cell == "Ledig"{
                rowWithColor.append(StringColor.green + cell + StringColor.black)
            }
            else if cell == "Passerad"{
                rowWithColor.append(StringColor.black + cell + StringColor.black)
            }
            else if cell.count == 5 {
                rowWithColor.append(StringColor.boldRed + cell + StringColor.black)
            }
            else
            {
                rowWithColor.append(StringColor.red + cell + StringColor.black)
            }
        }
        bookingWithColoredFriends.append(rowWithColor)
    }
    return bookingWithColoredFriends
}

func UnBookInteractive(bokningnummer : Int) {
    
    let bookingToUnbook = kronoxComunicator.getMyBookings()[bokningnummer]
    
    print("Are you sure that you want to remove your booking the \(bookingToUnbook.date) : \(bookingToUnbook.time) for room: \(bookingToUnbook.room) Y/N")
    
    if readLine()?.lowercased() != "y" {
        return
    }
    
    let result = kronoxComunicator.unBook(bokningsID: bookingToUnbook.bokningsId)
    
    if result.status == true {
        print("unbooking success")
    }
    else {
        print("unbooking failed: \(result.message)")
    }
    
}

func getUsernameAndPasswordFromConsole() -> (username: String, password: String) {
    print("Username : ", terminator: "")
    
    // Getting username and password
    let username = readLine() ?? ""
    let password = String(validatingUTF8: UnsafePointer<CChar>(getpass("Password: "))) ?? ""
    
    return (username, password)
}

func BookInteractive(date: Date, intervall: String? = nil){
    var intervallToBook = intervall
        if intervall == nil {
        let col1 = TextTableColumn(header: "id")
        let col2 = TextTableColumn(header: "Intervall")
        
        // Then create a table with the columns
        var table = TextTable(columns: [col1, col2])
        
        for (i, bookingIntervall) in bookingIntervalls.enumerated(){
            table.addRow(values: [i, bookingIntervall])
        }
        print(table.render())
            
        intervallToBook = readLine()!
    }
}
