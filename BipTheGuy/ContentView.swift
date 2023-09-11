//
//  ContentView.swift
//  BipTheGuy
//
//  Created by apple on 07.09.2023.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    @State private var selectedPhotos: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.8)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    animateImage = false //using .scaleEffect to 90% of size
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                        animateImage = true //using .scaleEffect to 100% of size
                    }
                }
                
            
            Spacer()
            
            PhotosPicker(selection: $selectedPhotos, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhotos) { newValue in
                Task{
                    do{
                        if let data = try await newValue?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                bipImage = Image(uiImage: uiImage)
                            }
                        }
                    } catch {
                        print("😡 ERROR: loading failed \(error.localizedDescription)")
                        
                    }
                    
                }
            }
            .buttonStyle(.borderedProminent)

        }
        .padding()
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("Culd not reed file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("Error: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
