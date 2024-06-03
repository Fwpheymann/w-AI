//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Andrew Morgan on 22/12/2020.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @ObservedObject private var data = ScrumData()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    NavigationLink(destination: TextWithAI()) {
                            Text("Text With AI")
                        }
                    }
                }
            .onAppear {
                data.load()
            }
        }
    }
}

