//
//  MainAppView.swift
//  Time Tell
//
//  Created by Pieter Yoshua Natanael on 04/12/24.
//


import SwiftUI
import CoreLocation

struct MainAppView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Sing Loop")
                }
                .tag(0)
            
           NotesView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Notes")
                }
                .tag(1)
            
        } .accentColor(Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)))
    }
}
