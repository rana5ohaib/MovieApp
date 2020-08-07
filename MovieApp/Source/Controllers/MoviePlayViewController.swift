//
//  MoviePlayViewController.swift
//  MovieApp
//
//  Created by Rana Amer on 7/28/20.
//  Copyright © 2020 Hamza. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AVFoundation

class MoviePlayViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // Required View Variables
    let vcPlayer = AVPlayerViewController()
    
    var device: AVCaptureDevice?
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var cameraImage: CGImage?
    
    // Required Business logic variables
    var movieURL: URL?
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playMovie()
    }
    
    
    func observeVideoPlayback() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.replayAgain()
        }
    }
    
    func playMovie() {
        if let url = movieURL {
            player = AVPlayer(url: url)
            vcPlayer.player = player
            vcPlayer.showsPlaybackControls = false
            self.present(vcPlayer, animated: true, completion: {
                self.setupCamera()
                self.setupTimer()
                self.observeVideoPlayback()
            })
        }
    }
    
    func stopAndBringToStart() {
        self.player?.pause()
        self.player?.seek(to: CMTime.zero)
    }
    
    func replayAgain() {
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
    }

    func setupCamera() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: AVMediaType.video,
                                                               position: .front)
        device = discoverySession.devices[0]

        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch {
            print(error)
            return
        }

        let output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true

        let queue = DispatchQueue(label: "cameraQueue")
        output.setSampleBufferDelegate(self, queue: queue)
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: kCVPixelFormatType_32BGRA]

        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        captureSession?.addOutput(output)
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)

        captureSession?.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = UnsafeMutableRawPointer(CVPixelBufferGetBaseAddress(imageBuffer!))
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!)
        let width = CVPixelBufferGetWidth(imageBuffer!)
        let height = CVPixelBufferGetHeight(imageBuffer!)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newContext = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo:
        CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)

        cameraImage = newContext!.makeImage()

        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    }
    
    func setupTimer() {
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(snapshot), userInfo: nil, repeats: true)
    }
    
    @objc func snapshot() {
        
        guard let image = cameraImage else { print("NO SNAPSHOT"); return }
        
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            
            if let err = error {
                print("Failed to detect faces: ", err)
                return
            }
            
            if request.results?.count ?? 0 > 0 {
                self.player?.play()
            } else {
                self.stopAndBringToStart()
            }
        }
        
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        
        do {
            try handler.perform([request])
        }
        catch {
            print("Failed to perform request", error)
        }
    }
}
