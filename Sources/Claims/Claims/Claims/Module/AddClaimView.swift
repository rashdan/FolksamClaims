//
//  ContentView.swift
//  AVAudioTest
//
//  Created by Johan Torell on 2021-10-27.
//

import AVFoundation
import FolksamCommon
import SwiftUI

private enum NetworkState {
    case initial, sending, completed
}

@available(iOS 14.0, *)
struct AddClaimView: View {
    @State private var networkState = NetworkState.initial
    @State private var answer: S2TAnswer?
    @ObservedObject var audioRecorder = AudioRecorder()
    let api = S2TAPI()

    // need a public initializer ot be able to export from module - swiftui rule
    init() {
        audioRecorder.setupAudioRecorder()
    }

    func sendFile() {
        networkState = .sending
        api.sendRecordedfFile { res in
            answer = res
            networkState = .completed
        }
    }

    func onRecordClick() {
        audioRecorder.toggle()
    }

    @ViewBuilder
    func answerView() -> some View {
        switch networkState {
        case .initial:
            Text("")
        case .sending:
            ProgressView().progressViewStyle(.circular)
        case .completed:
            if let answer = answer {
                Group {
                    Text(answer.text)
                    Spacer()

                    HStack {
                        ForEach(answer.sam.triggers, id: \.self) { word in
                            Text(word)
                        }
                    }
                    Text(answer.sam.flow)

                    WrappingHStack(models: answer.pos, viewGenerator: { entity in LabelTag(entity: entity, tagColor: .purple) }, horizontalSpacing: 5, verticalSpacing: 5)
                    WrappingHStack(models: answer.ner, viewGenerator: { entity in LabelTag(entity: entity, tagColor: .green) }, horizontalSpacing: 5, verticalSpacing: 5)
                }
            } else {
                Group {}
            }
        }
    }

    var body: some View {
        let isRecording = audioRecorder.currentlyRecording
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Berätta vad som har hänt").font(.title2)
                        Spacer()
                        HStack { // TODO: race condition, only send when file is done processing (when adding sendfile to click "Stoppa")
                            Button(isRecording ? "Stoppa" : "Spela in", action: {
                                onRecordClick()
                            })
                            Button(isRecording ? "" : "Skicka", action: {
                                sendFile()
                            })
                        }

                        Spacer(minLength: 50)
                        answerView()
                    }
                    .padding(15)
                    Spacer()
                }
            }
            .navigationTitle("Anmäl skada")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                AddClaimView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
