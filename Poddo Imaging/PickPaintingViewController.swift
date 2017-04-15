//
//  PickPaintingViewController.swift
//  Poddo Imaging
//
//  Created by Mayank Sanganeria on 4/15/17.
//  Copyright © 2017 Mayank Sanganeria. All rights reserved.
//

import UIKit

class PickPaintingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.isEnabled = (imageView.image != nil)
    }

    @IBAction func chooseImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PickArtistViewController
        destination.paintingImage = imageView.image
    }

}
