import Foundation
import SwiftUI
import AVFoundation
import Vision

struct IBANScannerView: UIViewControllerRepresentable {
    
    var onIBANDetected: ((String) -> Void)
    
    private let captureSession = AVCaptureSession()
    
    func stop() {
        captureSession.stopRunning()
    }
    
    func start() {
        captureSession.startRunning()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        captureSession.sessionPreset = .photo
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return viewController }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        if (captureSession.canAddOutput(videoOutput)) {
            captureSession.addOutput(videoOutput)
        } else {
            return viewController
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var parent: IBANScannerView
    var visionRequest = [VNRequest]()
    
    init(_ parent: IBANScannerView) {
        self.parent = parent
        super.init()
        setupVision()
    }
    
    func setupVision() {
        let textRequest = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        self.visionRequest = [textRequest]
    }
    
    func handleDetectedText(request: VNRequest?, error: Error?) {
        guard let observations = request?.results as? [VNRecognizedTextObservation] else { return }
        var iban: String?
        
        for observation in observations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            let text = candidate.string.replacingOccurrences(of: " ", with: "")
            print(text)
            if text.count == 27, text.starts(with: "FR"), CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: text)) {
                iban = text
                break
            }
        }
        
        if let iban = iban {
            DispatchQueue.main.async {
                self.parent.onIBANDetected(iban)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer)
        var requestOptions:[VNImageOption: Any] = [:]
        
        if let cameraData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics: cameraData]
        }
        
        guard let pixelBuffer = pixelBuffer else { return }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: requestOptions)
        do {
            try imageRequestHandler.perform(self.visionRequest)
        } catch {
            print(error)
        }
    }
}
