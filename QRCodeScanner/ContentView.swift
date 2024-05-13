//
//  ContentView.swift
//  QRCodeScanner
//
//  Created by 영호 박 on 5/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var uriFromQR: String = ""
        
    var body: some View {
        ZStack {
            // QR Scanner
            QRCameraView(uriFromQR: $uriFromQR)
            
            VStack {
                Spacer()
                
                // Scan 한 값을 보여주는 Text
                Text(uriFromQR)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .minimumScaleFactor(0.1)
                    .frame(width: UIScreen.main.bounds.width - 48, height: 48, alignment: .leading)
                    .border(Color.gray, width: 1)
                
                Spacer().frame(height: 70)
            }
        }
    }
}

#Preview {
    ContentView()
}
