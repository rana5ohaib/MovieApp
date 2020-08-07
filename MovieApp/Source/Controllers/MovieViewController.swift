//
//  ViewController.swift
//  MovieApp
//
//  Created by Rana Amer on 7/27/20.
//  Copyright © 2020 Hamza. All rights reserved.
//

import UIKit
import AVKit

class MovieViewController: UIViewController {
    
    // Required View Variables
    let vcPlayer = AVPlayerViewController()
    let imagePickerController = UIImagePickerController()
    
    // Required Business logic variables
    var movieURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func showVideoPicker() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.allowsEditing = true
        imagePickerController.videoQuality = .typeHigh
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaySegue",
            let vC = segue.destination as? MoviePlayViewController {
        
            vC.movieURL = movieURL
        }
    }
}

// MARK: - IBActions
extension MovieViewController {
    @IBAction func pick(sender: UIButton) {
        showVideoPicker()
    }
    @IBAction func play(sender: UIButton) {
        if let _ = movieURL {
            performSegue(withIdentifier: "showPlaySegue", sender: nil)
        }
    }
}

// MARK: - UIImage Picker Delegete
extension MovieViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoURL = info[.mediaURL] as? URL {
            movieURL = videoURL
            imagePickerController.dismiss(animated: true, completion: nil)
        }
    }
}

extension MovieViewController: UINavigationControllerDelegate {
    
}
