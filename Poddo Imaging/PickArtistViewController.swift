//
//  PickArtistViewController.swift
//  Poddo Imaging
//
//  Created by Mayank Sanganeria on 4/15/17.
//  Copyright © 2017 Mayank Sanganeria. All rights reserved.
//

import AAPhotoCircleCrop
import UIKit

class PickArtistViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AACircleCropViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var paintingImage: UIImage?

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
        let circleCropController = AACircleCropViewController()
        circleCropController.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated:true, completion: nil)
        circleCropController.delegate = self
        present(circleCropController, animated: true, completion: nil)
    }

    func circleCropDidCropImage(_ image: UIImage) {
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destination = segue.destination as! LayoutViewController
        destination.paintingImage = paintingImage
        destination.artistImage = imageView.image
     }

}
