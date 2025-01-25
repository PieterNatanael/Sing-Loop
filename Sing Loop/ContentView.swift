//
//  ContentView.swift
//  Sing Loop
//
//  Created by Pieter Yoshua Natanael on 02/04/24.
//


import SwiftUI
import AVFoundation


// Main App View for Audio Recording and Playback
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
                .font(.title.bold())
                .padding()
                .frame(width: 233)
                .background(isRecording ? Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)) : Color.black)
                .cornerRadius(25)
                .foregroundColor(isRecording ? Color.black : Color.white)
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)),
                            Color(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
                        ]),
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: 400
                    )
                )
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 5, y: 5) // Shadow for depth
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black.opacity(0.8), lineWidth: 2) // Optional border
                )

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
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)),
                            Color(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
                        ]),
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: 400
                    )
                )
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 5, y: 5) // Shadow for depth
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black.opacity(0.8), lineWidth: 2) // Optional border
                )

//                Spacer()

                // Volume Control Button
                Button("Volume") {
                    showVolumeSlider.toggle()
                }
                .font(.title.bold())
                .padding()
                .frame(width: 233)
                .background(Color.white)
                .cornerRadius(25)
                .foregroundColor(.black)
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)),
                            Color(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
                        ]),
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: 400
                    )
                )
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 5, y: 5) // Shadow for depth
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black.opacity(0.8), lineWidth: 2) // Optional border
                )

                Spacer()
            }
            .padding()
            .sheet(isPresented: $showExplain) {
                ShowExplainView(onConfirm: {
                    showExplain = false
                })
            }
            .onAppear {
                do {
                    // Set up the audio session to support simultaneous playback and recording
                    try AVAudioSession.sharedInstance().setCategory(
                        .playAndRecord,
                        mode: .default,
                        options: [.defaultToSpeaker, .mixWithOthers, .allowBluetooth, .allowBluetoothA2DP]
                    )
                    
                    // Activate the session
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                } catch {
                    print("Error setting AVAudioSession: \(error.localizedDescription)")
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
        MainAppView()
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

                }
                
                // App Cards
                VStack {
                    

//
                    AppCardView(imageName: "timetell", appName: "TimeTell", appDescription: "Announce the time every 30 seconds, no more guessing and checking your watch, for time-sensitive tasks.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
                    Divider().background(Color.gray)

//
                    AppCardView(imageName: "insomnia", appName: "Insomnia Sheep", appDescription: "The ultimate sleep tool.", appURL: "https://apps.apple.com/id/app/insomnia-sheep/id6479727431")
                    Divider().background(Color.gray)


                }
                Spacer()
                HStack{
                    Text("App Functionality")
                        .font(.title.bold())
                    Spacer()
                }
               //app information
               Text("""
               • Press the record button to start recording sound.
               • Press the record button again to stop recording.
               • Press the play button to hear the playback in a loop.
               • Press the play button again to stop playback.
               • Each new recording will overwrite the previous one.
               • Can record while another music app is running in the background.
               • Cannot record while playback is active; the playback will stop.
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
               .font(.title.bold())
               .padding()
               .frame(maxWidth: .infinity)
               .background(Color.red)
               .cornerRadius(25)
               .foregroundColor(.black)
               .background(
                   RadialGradient(
                       gradient: Gradient(colors: [
                           Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)),
                           Color(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
                       ]),
                       center: .topLeading,
                       startRadius: 10,
                       endRadius: 400
                   )
               )
               .cornerRadius(25)
               .shadow(color: Color.black.opacity(0.4), radius: 10, x: 5, y: 5) // Shadow for depth
               .overlay(
                   RoundedRectangle(cornerRadius: 25)
                       .stroke(Color.black.opacity(0.8), lineWidth: 2) // Optional border
               )
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

