//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Andrew Morgan on 22/12/2020.
//
import SwiftUI

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Text(" AI Inc.")
                List {
                    NavigationLink(destination: TextWithAI()) {
                        if #available(iOS 17.0, *) {
                            Text("Text With AI")
                                .foregroundStyle(.green)
                        } else {
                            // Fallback on earlier versions
                        }
                        }
                    NavigationLink(destination: ImagesWithAI()) {
                        if #available(iOS 17.0, *) {
                            Text("Create Images With AI")
                                .foregroundStyle(.green)
                        } else {
                            // Fallback on earlier versions
                        }
                            }
                        }
                    }
                }
    }
}

