//
//  ListeningAudioView.swift
//  CoverMusic
//
//  Created by Yunus Gündüz on 21.09.2023.
//

import SwiftUI
import AVFoundation

class Audio_manager: NSObject,ObservableObject,AVAudioPlayerDelegate{
    
    @Published var audio_player: AVAudioPlayer?
    @Published var is_playing = false
    @Published var current_time : TimeInterval = 0
    let audio_file_name = "sila_yabanci.mp3"
    
    override init(){
        super.init()
        setup_audio()
        start_timer()
    }
    func setup_audio(){
        let url = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0]
        let file_name = url.appendingPathComponent("record6.m4a")
        
        
        
        
        guard let audio_file_url = Bundle.main.url(forResource: audio_file_name, withExtension: nil) else{
            print("DEBUG: ERROR -> setup_audio ")
            return
        }
        
        do {
            // audio_player = try AVAudioPlayer(contentsOf: audio_file_url)
            audio_player = try AVAudioPlayer(contentsOf: file_name)
            audio_player?.prepareToPlay()
            audio_player?.delegate = self
            
        }catch{
            print("DEBUG: \(error.localizedDescription )")
        }
    }
    func play_audio(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
              try AVAudioSession.sharedInstance().setActive(true)
              audio_player?.play()
          } catch {
              print("Error activating AVAudioSession: \(error.localizedDescription)")
          }
    }
    func pause_video(){
        audio_player?.pause()
    }
    func format_time(_ time_interval:TimeInterval) -> String {
        let minutes = Int(time_interval / 60)
        let seconds = Int(time_interval.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d: %02d", minutes,seconds)
    }
    func start_timer(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self, self.is_playing else {return}
            self.current_time = self.audio_player?.currentTime ?? 0
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        is_playing = false
        current_time = 0
         
    }
    
}



struct ListeningAudioView: View {
    @StateObject private var audio_manager = Audio_manager()
    @State private var rotation_angle: Angle = .degrees(0)
    
    var body: some View {
        VStack{
           
            Text("record6.m4a").font(.largeTitle)
            Text(audio_manager.format_time(audio_manager.current_time))
                .font(
                    Font.custom("Inter", size: 20)
                        .weight(.medium)
                )
                .foregroundColor(.black)
                .offset(y: 200)
            
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 220,height: 57)
                    .background(Color.white)
                    .cornerRadius(28.5)
                    .shadow(color: .black.opacity(0.4), radius: 44,x:0,y:4)
                VStack{
                    
                }
                    .frame(width: 77, height: 77)
                    .background(Color.black)
                    .shadow(color: .black, radius: 50, x:0 , y:4)
                    .clipShape(Circle())
                
                Button {
                    if audio_manager.is_playing {
                        audio_manager.audio_player?.pause()
                    }else{
                        audio_manager.play_audio()
                    }
                    audio_manager.is_playing.toggle()
                } label: {
                    Image(systemName: audio_manager.is_playing ? "pause.fill": "play.fill")
                        .font(.system(size: 33))
                        .foregroundColor(.white)
                    
                }
/* back and forwad button for audio  (will add)
                HStack{
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                            .frame(width: 19,height: 19)
                            .foregroundColor(.black)
                    }.offset(x:-60)
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                            .frame(width: 19,height: 19)
                            .foregroundColor(.black)
                    }.offset(x:60)
                }
                */
                Spacer()
            }
            .offset(y:240)
            
        }
            
    
    }
}

struct ListeningAudioView_Previews: PreviewProvider {
    static var previews: some View {
        ListeningAudioView()
    }
}
