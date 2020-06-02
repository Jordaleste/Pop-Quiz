//
//  CreditsView.swift
//  SwiftUI Settings Screen
//
//  Created by Rudrank Riyam on 19/04/20.
//  Copyright © 2020 Rudrank Riyam. All rights reserved.
//

import SwiftUI

struct CreditsView: View {
    var acasaURL: URL = URL(string: "https://www.acasaconsulting.com")!
    var gradientGameURL: URL = URL(string: "https://www.twitter.com/gradientsgame")!
    var triviaDBURL: URL = URL(string: "https://opentdb.com")!
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Special thank you to Dean Irwin of Acasa Consulting for providing artwork.\n\nCredit and thank you to Rudrank Riyam who designed and open sourced the settings file I have used for You Know Nothing!. Check out his Gradient Game, you will not be disappointed.")
                    .kerning(0.2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .settingsBackground()

                SettingsRow(imageName: "eyedropper.halffull", title: "Acasa Consulting") {
                    UIApplication.shared.open(self.acasaURL)
                }
                .padding()
                .settingsBackground()
                
                SettingsRow(imageName: "eyedropper.halffull", title: "Gradient Game") {
                    UIApplication.shared.open(self.gradientGameURL)
                }
                .padding()
                .settingsBackground()
                
                
                SettingsRow(imageName: "eyedropper.halffull", title: "Open Trivia Database") {
                    UIApplication.shared.open(self.triviaDBURL)
                }
                .padding()
                .settingsBackground()
            }
            .navigationBarTitle("Credits")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}
