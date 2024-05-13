//
//  QRCameraController.swift
//  QRCodeScanner
//
//  Created by 영호 박 on 5/13/24.
//

import UIKit
import AVFoundation

final class QRCameraController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // 카메라에 QR코드가 인식되면 호출. (1초에 수십번 호출됨)
    // 인식된 이미지에서 QR 값 확인 후, 이전과 다른 uri라면 Notification.
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let uriFromQR = readableObject.stringValue else { return }
            
        if previousURI != uriFromQR {
            previousURI = uriFromQR
            NotificationCenter.default.post(name: NSNotification.Name("URI Recognized By QR"), object: uriFromQR, userInfo: nil)
            print("📷 uri from QR:", uriFromQR)
        }
    }
    
    // 실시간 캡처 활동을 관리하고, 입력 장치의 데이터 흐름을 조정하여 출력을 캡처하는 Object
    private let captureSession = AVCaptureSession()
    // 후면 카메라
    private var backCamera: AVCaptureDevice!
    // 이전 uri 저장용
    private var previousURI: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try getBackCamera()
            try setupCaptureSession()
        } catch {
            print("📷", error)
        }
        
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    // 1. 후면 카메라 가져오기
    private func getBackCamera() throws {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        guard let backCamera = session.devices.first(where: { $0.position == .back }) else {
            throw NSError(domain: "후면 카메라를 찾지 못했습니다.", code: 404)
        }
        self.backCamera = backCamera
    }
    
    // 2. 캡처 세션 설정
    private func setupCaptureSession() throws {
        // 출력 품질 설정
        captureSession.sessionPreset = .photo
        
        // 후면 카메라를 Input으로 설정
        let captureDeviceInput = try AVCaptureDeviceInput(device: backCamera)
        captureSession.addInput(captureDeviceInput)
        
        // QR 메타데이터를 Output으로 설정
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
    }
    
    // 3. 카메라 프리뷰 Layer 설정
    private func setupPreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        if #available(iOS 17.0, *) {
            cameraPreviewLayer.connection?.videoRotationAngle = 90 // 0(오른), 90(정상), 180(왼), 270(뒤집힌)
        } else {
            cameraPreviewLayer.connection?.videoOrientation = .portrait
        }
        
        cameraPreviewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height) // FullScreen 아닌 경우, 해당 부분 수정
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    // 4. Capture Session을 시작 (카메라 화면이 나오며, 동작하기 시작)
    private func startRunningCaptureSession() {
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning() // main thread 에서 호출될 시, 보라색 경고 발생
        }
    }
}
