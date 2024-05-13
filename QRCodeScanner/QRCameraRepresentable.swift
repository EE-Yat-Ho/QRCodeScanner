//
//  QRCameraRepresentable.swift
//  QRCodeScanner
//
//  Created by 영호 박 on 5/13/24.
//

import SwiftUI

struct QRCameraRepresentable: UIViewControllerRepresentable {
    
    // 뷰컨트롤러 첫 생성
    func makeUIViewController(context: Context) -> QRCameraController {
        QRCameraController()
    }
    
    // 첫 생성 이후에는 해당 메소드가 호출.
    func updateUIViewController(_ cameraViewController: QRCameraController, context: Context) {}
    
}
