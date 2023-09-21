//
//  RecordingAudioView.swift
//  CoverMusic
//
//  Created by Yunus Gündüz on 21.09.2023.
//

import SwiftUI
import AVKit


struct RecordingAudioView: View {
  
    
    var body: some View {
        // allways dark mode
        VStack{
            Text("Record audio").font(.largeTitle).padding(50)
            Spacer()
            Home()//.preferredColorScheme(.dark)
            Spacer()
        }
      
    }
}

struct RecordingAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAudioView()
    }
}


struct Home:View {
    @State var record = false
    @State var session : AVAudioSession!  // creating instance for recording
    @State var recorder : AVAudioRecorder!
    @State var alert = false
    @State var audios : [URL] = [] // fetch audios
    var body: some View {
        VStack{
            List(self.audios, id: \.self){ audio in
                Text(audio.relativeString) // file names
                
            }
            
           Spacer()
            Button {
                    
                do{
                    if self.record {  // already started recording
                        self.recorder.stop()
                        self.record.toggle()
                        
                        self.get_audios() // update audios for every recording
                        
                        return
                    }
                    
                    
                    // going to record audio
                    let url = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0]
                    let file_name = url.appendingPathComponent("record\(self.audios.count + 1).m4a")
                    
                
                
                    
                    let settings = [
                        AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey : 1,
                        AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                    ]
                    self.recorder = try AVAudioRecorder(url: file_name, settings: settings)
                    self.recorder.record()
                    self.record.toggle()
                    print(recorder.url)
                    
                    
                }catch{
                    print("Debug: \(error.localizedDescription)")
                }
               
            } label: {
                ZStack{
                    Circle().fill(Color.red)
                        .frame(width: 70,height: 70)
                    if self.record {
                        Circle()
                            .stroke(Color.white,lineWidth: 6)
                            .frame(width: 85,height: 85)
                    }
                    
                }
            }
            .padding(.vertical,25)
            
            
        }
        .alert(isPresented: self.$alert, content: {
            Alert(title: Text("Error"),message: Text("Enable Access"))
        })
        
        .onAppear{
            do {
                // initializing
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                
                // request microphone permission
                self.session.requestRecordPermission { Status in
                    if !Status{
                        self.alert.toggle()
                    }else{
                        self.get_audios() // if granted permissions fetch  all audios
                        
                    }
                }
                
            }catch{
                print("DEBUG: \(error.localizedDescription )")
            }
            
            
        }
    }
    func  get_audios(){
        
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys:nil,options: .producesRelativePathURLs)
            self.audios.removeAll()  // removing all old data
            for i in result{
                self.audios.append(i)
            }
            
            
        }catch{
            print("DEBUG: \(error.localizedDescription )")
        }
     
    }
  
    
}
