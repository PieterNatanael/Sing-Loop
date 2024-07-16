//
//  ContentView.swift
//  Sing Loop
//
//  Created by Pieter Yoshua Natanael on 02/04/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    // MARK: - State Properties
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecording = false
    @State private var isPlaying = false
    @State private var showExplain: Bool = false
    @State private var showVolumeSlider: Bool = false
    @State private var volume: Float = 1.0

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)), .clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // App Title and Buttons
                HStack {
                    Text("")
                        .frame(width: 30, height: 30)
                        .padding()
                    Spacer()
                    Text("SingL00P")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        showExplain = true
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()

                // Record Button
                Button(isRecording ? "Stop Recording" : "Record") {
                    if isRecording {
                        self.stopRecording()
                    } else {
                        self.startRecording()
                    }
                }
                .font(.title2)
                .padding()
                .frame(width: 233)
                .background(isRecording ? Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)) : Color.black)
                .cornerRadius(25)
                .foregroundColor(.white)

                // Play Button
                Button(isPlaying ? "Stop" : "Play") {
                    if isPlaying {
                        self.stopPlayback()
                    } else {
                        self.startPlayback()
                    }
                }
                .font(.title.bold())
                .padding()
                .frame(width: 233)
                .background(isPlaying ? Color.red : Color.red)
                .cornerRadius(25)
                .foregroundColor(.white)

//                Spacer()

                // Volume Control Button
                Button("Volume") {
                    showVolumeSlider.toggle()
                }
                .font(.title2)
                .padding()
                .frame(width: 233)
                .background(Color.white)
                .cornerRadius(25)
                .foregroundColor(.black)

                Spacer()
            }
            .padding()
            .sheet(isPresented: $showExplain) {
                ShowExplainView(onConfirm: {
                    showExplain = false
                })
            }
            .onAppear {
                // Set up audio session
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Error setting AVAudioSession category: \(error.localizedDescription)")
                }
            }

            // Volume Slider Overlay
            if showVolumeSlider {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Slider(value: $volume, in: 0...1, step: 0.1)
                            .padding()
                            .accentColor(.red)
                            .background(Color.primary)
                            .cornerRadius(25)
                            .padding()
                            .onChange(of: volume) { newValue in
                                audioPlayer?.volume = newValue
                            }
                        Spacer()
                    }
                    .padding(.bottom)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut)
            }
        }
    }

    // MARK: - Audio Functions
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func startPlayback() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.numberOfLoops = -1 // Play on loop
            audioPlayer?.volume = volume
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Could not start playback: \(error.localizedDescription)")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }

    // MARK: - Utility Functions
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



// MARK: - App Card View
struct AppCardView: View {
    var imageName: String
    var appName: String
    var appDescription: String
    var appURL: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(7)
            
            VStack(alignment: .leading) {
                Text(appName)
                    .font(.title3)
                Text(appDescription)
                    .font(.caption)
            }
            .frame(alignment: .leading)
            
            Spacer()
            Button(action: {
                if let url = URL(string: appURL) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Try")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Explain View
struct ShowExplainView: View {
    var onConfirm: () -> Void

    var body: some View {
        ScrollView {
            VStack {
               HStack{
                   Text("")
                       .font(.title2.bold())
                   Spacer()
               }
                Spacer()
                
                HStack{
                    Text("")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                
                ZStack {
//                    Image("threedollar")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .cornerRadius(25)
//                        .clipped()
//                        .onTapGesture {
//                            if let url = URL(string: "https://b33.biz/three-dollar/") {
//                                UIApplication.shared.open(url)
//                            }
//                        }
                }
                
                // App Cards
                VStack {
                    
//                    Divider().background(Color.gray)
//                    AppCardView(imageName: "sos", appName: "SOS Light", appDescription: "SOS Light is designed to maximize the chances of getting help in emergency situations.", appURL: "https://apps.apple.com/app/s0s-light/id6504213303")
//                    Divider().background(Color.gray)
//                    
//                    
//                    Divider().background(Color.gray)
//                    AppCardView(imageName: "temptation", appName: "TemptationTrack", appDescription: "One button to track milestones, monitor progress, stay motivated.", appURL: "https://apps.apple.com/id/app/temptationtrack/id6471236988")
//                    Divider().background(Color.gray)
//                    // Add more AppCardViews here if needed
//                    // App Data
//                 
//                    
//                    AppCardView(imageName: "timetell", appName: "TimeTell", appDescription: "Announce the time every 30 seconds, no more guessing and checking your watch, for time-sensitive tasks.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
//                    Divider().background(Color.gray)
//                    
//                    AppCardView(imageName: "bodycam", appName: "BODYCam", appDescription: "Record videos effortlessly and discreetly.", appURL: "https://apps.apple.com/id/app/b0dycam/id6496689003")
//                   
//                    Divider().background(Color.gray)
//                    
//                    AppCardView(imageName: "loopspeak", appName: "LOOPSpeak", appDescription: "Type or paste your text, play in loop, and enjoy hands-free narration.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
//                    Divider().background(Color.gray)
//                    
//                    AppCardView(imageName: "insomnia", appName: "Insomnia Sheep", appDescription: "Design to ease your mind and help you relax leading up to sleep.", appURL: "https://apps.apple.com/id/app/insomnia-sheep/id6479727431")
//                    Divider().background(Color.gray)
//                    
//                    AppCardView(imageName: "dryeye", appName: "Dry Eye Read", appDescription: "The go-to solution for a comfortable reading experience, by adjusting font size and color to suit your reading experience.", appURL: "https://apps.apple.com/id/app/dry-eye-read/id6474282023")
//                    Divider().background(Color.gray)
//                    
//                    AppCardView(imageName: "iprogram", appName: "iProgramMe", appDescription: "Custom affirmations, schedule notifications, stay inspired daily.", appURL: "https://apps.apple.com/id/app/iprogramme/id6470770935")
//                    Divider().background(Color.gray)
//                    
//                    AppCardView(imageName: "worry", appName: "Worry Bin", appDescription: "A place for worry.", appURL: "https://apps.apple.com/id/app/worry-bin/id6498626727")
//                    Divider().background(Color.gray)
                
                }
                Spacer()
                HStack{
                    Text("App Functionality")
                        .font(.title.bold())
                    Spacer()
                }
               
               Text("""
               • Press the record button to start recording sound.
               • Press the record button again to stop recording.
               • Press the play button to hear the playback in a loop.
               • Press the play button again to stop playback.
               • Each new recording will overwrite the previous one.
               """)
               .font(.title3)
               .multilineTextAlignment(.leading)
               .padding()
               
               Spacer()
                HStack {
                    Text("SingLOOP is developed by Three Dollar.")
                        .font(.title3.bold())
                        .onTapGesture {
                            if let url = URL(string: "https://b33.biz/three-dollar/") {
                                UIApplication.shared.open(url)
                            }}
                    Spacer()
                }

               Button("Close") {
                   // Perform confirmation action
                   onConfirm()
               }
               .font(.title)
               .padding()
               .cornerRadius(25.0)
               .padding()
           }
           .padding()
           .cornerRadius(15.0)
           .padding()
        }
    }
}


/*
//bagus mau ada tambahan
import SwiftUI
import AVFoundation

struct ContentView: View {
    // MARK: - State Properties
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecording = false
    @State private var isPlaying = false
    @State private var showExplain: Bool = false

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),.clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // App Title and Buttons
                HStack{
                    Text("")
                        .frame(width: 30, height: 30)
                        .padding()
                        Spacer()
                        Text("SingL00P")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            showExplain = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                        }
                    
                }
                Spacer()
                
                // Record Button
                Button(isRecording ? "Stop Recording" : "Record") {
                    if isRecording {
                        self.stopRecording()
                    } else {
                        self.startRecording()
                    }
                }
                .font(.title2)
                .padding()
                .frame(width: 233)
                .background(isRecording ? Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)) : Color.white)
                .cornerRadius(25)
                .foregroundColor(.black)
                
                // Play Button
                Button(isPlaying ? "Stop " : "Play") {
                    if isPlaying {
                        self.stopPlayback()
                    } else {
                        self.startPlayback()
                    }
                }
                .font(.title.bold())
                .padding()
                .frame(width: 233)
                .background(isPlaying ? Color.red : Color.red )
                .cornerRadius(25)
                .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showExplain) {
                ShowExplainView(onConfirm: {
                    showExplain = false
                })
            }
            .onAppear {
                // Set up audio session
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Error setting AVAudioSession category: \(error.localizedDescription)")
                }
        }
        }
    }

    // MARK: - Audio Functions
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func startPlayback() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.numberOfLoops = -1 // Play on loop
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Could not start playback: \(error.localizedDescription)")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }

    // MARK: - Utility Functions
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: - App Card View
struct AppCardView: View {
    var imageName: String
    var appName: String
    var appDescription: String
    var appURL: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(7)
            
            VStack(alignment: .leading) {
                Text(appName)
                    .font(.title3)
                Text(appDescription)
                    .font(.caption)
            }
            .frame(alignment: .leading)
            
            Spacer()
            Button(action: {
                if let url = URL(string: appURL) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Try")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Explain View
struct ShowExplainView: View {
    var onConfirm: () -> Void

    var body: some View {
        ScrollView {
            VStack {
               HStack{
                   Text("Ads & App Functionality")
                       .font(.title2.bold())
                   Spacer()
               }
                Spacer()
                
                HStack{
                    Text("Ads")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                
                ZStack {
                    Image("threedollar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(25)
                        .clipped()
                        .onTapGesture {
                            if let url = URL(string: "https://b33.biz/three-dollar/") {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                
                // App Cards
                VStack {
                    
                    Divider().background(Color.gray)
                    AppCardView(imageName: "sos", appName: "SOS Light", appDescription: "SOS Light is designed to maximize the chances of getting help in emergency situations.", appURL: "https://apps.apple.com/app/s0s-light/id6504213303")
                    Divider().background(Color.gray)
                    
                    
                    Divider().background(Color.gray)
                    AppCardView(imageName: "temptation", appName: "TemptationTrack", appDescription: "One button to track milestones, monitor progress, stay motivated.", appURL: "https://apps.apple.com/id/app/temptationtrack/id6471236988")
                    Divider().background(Color.gray)
                    // Add more AppCardViews here if needed
                    // App Data
                 
                    
                    AppCardView(imageName: "timetell", appName: "TimeTell", appDescription: "Announce the time every 30 seconds, no more guessing and checking your watch, for time-sensitive tasks.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "bodycam", appName: "BODYCam", appDescription: "Record videos effortlessly and discreetly.", appURL: "https://apps.apple.com/id/app/b0dycam/id6496689003")
                   
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "loopspeak", appName: "LOOPSpeak", appDescription: "Type or paste your text, play in loop, and enjoy hands-free narration.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "insomnia", appName: "Insomnia Sheep", appDescription: "Design to ease your mind and help you relax leading up to sleep.", appURL: "https://apps.apple.com/id/app/insomnia-sheep/id6479727431")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "dryeye", appName: "Dry Eye Read", appDescription: "The go-to solution for a comfortable reading experience, by adjusting font size and color to suit your reading experience.", appURL: "https://apps.apple.com/id/app/dry-eye-read/id6474282023")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "iprogram", appName: "iProgramMe", appDescription: "Custom affirmations, schedule notifications, stay inspired daily.", appURL: "https://apps.apple.com/id/app/iprogramme/id6470770935")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "worry", appName: "Worry Bin", appDescription: "A place for worry.", appURL: "https://apps.apple.com/id/app/worry-bin/id6498626727")
                    Divider().background(Color.gray)
                
                }
                Spacer()
                HStack{
                    Text("App Functionality")
                        .font(.title.bold())
                    Spacer()
                }
               
               Text("""
               • Press the record button to start recording sound.
               • Press the record button again to stop recording.
               • Press the play button to hear the playback in a loop.
               • Press the play button again to stop playback.
               • Each new recording will overwrite the previous one.
               """)
               .font(.title3)
               .multilineTextAlignment(.leading)
               .padding()
               
               Spacer()
                HStack {
                    Text("SingLOOP is developed by Three Dollar.")
                        .font(.title3.bold())
                    Spacer()
                }

               Button("Close") {
                   // Perform confirmation action
                   onConfirm()
               }
               .font(.title)
               .padding()
               .cornerRadius(25.0)
               .padding()
           }
           .padding()
           .cornerRadius(15.0)
           .padding()
        }
    }
}

*/


/*
//udah bagus namun mau ada update AdView
import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecording = false
    @State private var isPlaying = false
    @State private var showAd: Bool = false
    @State private var showExplain: Bool = false

    var body: some View {
        ZStack {
            //BG color
            // Background Gradient
            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),.clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
//            Color(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
//                )
//            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                HStack{
                    Button(action: {
                        showAd = true
                    }) {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                           
                            .padding()
                        Spacer()
                        Text("Sing L00P")
                            .font(.largeTitle)
                            .foregroundColor(.white)
//                            .font(.system(size: 66.6))
                            
//                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
                        Spacer()
                        Button(action: {
                            showExplain = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                               
                                .padding()
                        }
                    }
                }
                Spacer()
                Button(isRecording ? "Stop Recording" : "Record") {
                    if isRecording {
                        self.stopRecording()
                    } else {
                        self.startRecording()
                    }
                }
                .font(.title2)
                
                .padding()
                .frame(width: 233)
                .background(isRecording ? Color.white : Color.white)
                
                .cornerRadius(25)
                .foregroundColor(.black)
                
                Button(isPlaying ? "Stop Playback" : "Play") {
                    if isPlaying {
                        self.stopPlayback()
                    } else {
                        self.startPlayback()
                    }
                }
                .font(.title2)
                .padding()
                .frame(width: 233)
                .background(isPlaying ? Color.red : Color.red )
               
                .cornerRadius(25)
                .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showAd) {
                ShowAdView(onConfirm: {
                    showAd = false
                })
            }
            
            .sheet(isPresented: $showExplain) {
                ShowExplainView(onConfirm: {
                    showExplain = false
                })
            }
            
            .onAppear {
                do {
                    // Workaround for low volume issue
                    try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Error setting AVAudioSession category: \(error.localizedDescription)")
                }
        }
        }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func startPlayback() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.numberOfLoops = -1 // Play on loop
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Could not start playback: \(error.localizedDescription)")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ShowAdView: View {
   var onConfirm: () -> Void

    var body: some View {
        ScrollView {
        VStack {
            Text("Ads to Support Us!")
                                .font(.title)
                                .padding()
                                .foregroundColor(.white)

                            // Your ad content here...

                            Text("Buying our apps with a one-time fee helps us keep making helpful apps.")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
            
            Text("TimeTell.")
                .font(.title)
//                           .monospaced()
                .padding()
                .foregroundColor(.white)
                .onTapGesture {
                    if let url = URL(string: "https://apps.apple.com/app/time-tell/id6479016269") {
                        UIApplication.shared.open(url)
                    }
                }
Text("Time Announcement.") // Add your 30 character description here
                  .font(.subheadline)
                  .padding(.horizontal)
                  .foregroundColor(.white)
            
               
               Text("Insomnia Sheep.")
                   .font(.title)
    //                           .monospaced()
                   .padding()
                   .foregroundColor(.white)
                   .onTapGesture {
                       if let url = URL(string: "https://apps.apple.com/id/app/insomnia-sheep/id6479727431") {
                           UIApplication.shared.open(url)
                       }
                   }
            Text("Design to Count Sheep.") // Add your 30 character description here
                                .font(.subheadline)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                          
                          Text("Dry Eye Read.")
                              .font(.title)
    //                           .monospaced()
                              .padding()
                              .foregroundColor(.white)
                              .onTapGesture {
                                  if let url = URL(string: "https://apps.apple.com/id/app/dry-eye-read/id6474282023") {
                                      UIApplication.shared.open(url)
                                  }
                              }
            Text("Read With Ease.") // Add your 30 character description here
                                .font(.subheadline)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                          
                          Text("iProgramMe.")
                              .font(.title)
    //                           .monospaced()
                              .padding()
                              .foregroundColor(.white)
                              .onTapGesture {
                                  if let url = URL(string: "https://apps.apple.com/id/app/iprogramme/id6470770935") {
                                      UIApplication.shared.open(url)
                                  }
                              }
            Text("Code Your Best Self.") // Add your 30 character description here
                                .font(.subheadline)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                          
                          Text("LoopSpeak.")
                              .font(.title)
    //                           .monospaced()
                              .padding()
                              .foregroundColor(.white)
                              .onTapGesture {
                                  if let url = URL(string: "https://apps.apple.com/id/app/loopspeak/id6473384030") {
                                      UIApplication.shared.open(url)
                                  }
                              }
            Text("Looping Reading Companion.") // Add your 30 character description here
                                .font(.subheadline)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                          
                     
                          Text("TemptationTrack.")
                              .font(.title)
    //                           .monospaced()
                              .padding()
                              .foregroundColor(.white)
                              .onTapGesture {
                                  if let url = URL(string: "https://apps.apple.com/id/app/temptationtrack/id6471236988") {
                                      UIApplication.shared.open(url)
                                  }
                              }
            Text("Empowering Progress.") // Add your 30 character description here
                                .font(.subheadline)
                                .padding(.horizontal)
                                .foregroundColor(.white)


               Spacer()

               Button("Close") {
                   // Perform confirmation action
                   onConfirm()
               }
               .font(.title)
               .padding()
               .foregroundColor(.black)
               .background(Color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
               .cornerRadius(25.0)
               .padding()
           }
           .padding()
           .background( Color(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
           ))
           .cornerRadius(15.0)
       .padding()
        }
   }
}

struct ShowExplainView: View {
   var onConfirm: () -> Void

    var body: some View {
       VStack {
           Text("Press the record button to start recording sound and press it again to stop recording. Press the play button to hear the playback in a loop, and press it again to stop playback. Each new recording will overwrite the previous one.")
               .font(.title)
               .multilineTextAlignment(.center)
//                       .monospaced()
               .padding()
               .foregroundColor(.white)



           Spacer()

           Button("Close") {
               // Perform confirmation action
               onConfirm()
           }
           .font(.title)
           .padding()
           .foregroundColor(.black)
           .background(Color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
           .cornerRadius(25.0)
           .padding()
       }
       .padding()
       .background( Color(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
                         ))
       .cornerRadius(15.0)
       .padding()
   }
}
*/
