//
//  ContentView.swift
//  CoverMusic
//
//  Created by Yunus Gündüz on 20.09.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TabView{
                
                RecordingAudioView().tabItem{
                  Label("Recording",systemImage: "mic.square")
                   
                }
                ListeningAudioView().tabItem{
                    Label("Listening",systemImage: "headphones")
                   
                }
                
            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
