//
//  SwiftUIView.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/13/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ZStack {
            
//            add background image here
//            Image(decorative: "BarbellBackground")
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .edgesIgnoringSafeArea(.all)
//            .opacity(0.4)
            
            VStack {
                Text("Pop Quiz!")
                    .foregroundColor(Color.red)
                    .font(.largeTitle)
                
                Text("1. What does CSS stand for?")
                    //pass in question
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .padding()
                
                Button(action: {
                    //Highlight when selected
                    //Change value of answer when selected to A
                }) {
                    //Pass in answer A
                    Text("A: Computer Style Sheets")
                }
                .padding()
                .padding()
                .background(Color.green)
                .foregroundColor(Color.white)
                .padding()
                
                Button(action: {
                    //Highlight when selected
                    //Change value of answer when selected to B
                }) {
                    //Pass in answer B
                    Text("B: Computer Style Sheets")
                }
                .padding()
                .padding()
                .background(Color.green)
                .foregroundColor(Color.white)
                .padding()
                
                Button(action: {
                    //button action goes here
                }) {
                    //Pass in answer C
                    Text("C: Computer Style Sheets")
                }
                .padding()
                .padding()
                .background(Color.green)
                .foregroundColor(Color.white)
                .padding()
                
                Button(action: {
                    //button action goes here
                }) {
                    //Pass in answer D
                    Text("D: Computer Style Sheets")
                }
                .padding()
                .padding()
                .background(Color.green)
                .foregroundColor(Color.white)
                .padding()
                
                Button(action: {
                    //code to send to next question
                }) {
                    Text("Submit")
                }
                    
                .padding(.horizontal)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
                
            }
            
            
            
        }
    }
}








struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
