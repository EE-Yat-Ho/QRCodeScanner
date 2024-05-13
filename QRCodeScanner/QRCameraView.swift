//
//  QRCameraCell.swift
//  QRCodeScanner
//
//  Created by 영호 박 on 5/13/24.
//

import SwiftUI

struct QRCameraView: View {
    
    @Binding var uriFromQR: String
    
    let uriFromQRFromController = NotificationCenter.default
                .publisher(for: NSNotification.Name("URI Recognized By QR"))
    
    var body: some View {
        QRCameraRepresentable()
            .onReceive(uriFromQRFromController) { (output) in
                uriFromQR = output.object as? String ?? ""
            }
    }
}
