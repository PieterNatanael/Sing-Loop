//
//  ContentView.swift
//  Sing Loop
//
//  Created by Pieter Yoshua Natanael on 02/04/24.
//

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
            Color(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
                )
            .ignoresSafeArea()
            
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
                            .font(.system(size: 66.6))
                            .bold()
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
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
                .background(isRecording ? Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)) )
                
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
                .background(isPlaying ? Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)) )
               
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
