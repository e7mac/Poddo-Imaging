//
//  PickArtistViewController.swift
//  Poddo Imaging
//
//  Created by Mayank Sanganeria on 4/15/17.
//  Copyright © 2017 Mayank Sanganeria. All rights reserved.
//

import AAPhotoCircleCrop
import UIKit
import PBImageStorage

class PickArtistViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AACircleCropViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var paintingImage: UIImage?
    @IBOutlet weak var collectionView: UICollectionView!
    var artists: [Artist] = []
    var selectedArtist: Artist?
    let imageStorage = PBImageStorage()
    @IBOutlet weak var removeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.rightBarButtonItem?.isEnabled = (selectedArtist != nil)
        removeButton.isEnabled = (selectedArtist != nil)
        loadArtists()
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
        let artist = Artist.createArtist(image: image)
        artists.append(artist)
        selectedArtist = artist
        collectionView.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = true
        removeButton.isEnabled = true
    }
    @IBAction func removeArtist(_ sender: Any) {
        if let selectedArtist = selectedArtist {
            artists = artists.filter { $0 != selectedArtist }
        }
        selectedArtist = nil
        collectionView.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = false
        removeButton.isEnabled = false
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        persistArtists()
        let destination = segue.destination as! LayoutViewController
        destination.paintingImage = paintingImage
        if let selectedArtist = selectedArtist {
            destination.artistImage = selectedArtist.image
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        let imageView = cell.viewWithTag(666) as! UIImageView
        imageView.contentMode = .scaleAspectFit
        imageView.image = artists[indexPath.row].image
        if artists[indexPath.row] == selectedArtist {
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.blue.cgColor
        } else {
            cell.layer.borderWidth = 0.0
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if artists[indexPath.row] == selectedArtist {
            selectedArtist = nil
            navigationItem.rightBarButtonItem?.isEnabled = false
            removeButton.isEnabled = false
        } else {
            selectedArtist = artists[indexPath.row]
            navigationItem.rightBarButtonItem?.isEnabled = true
            removeButton.isEnabled = true
        }
        collectionView.reloadData()
    }

    private func persistArtists() {
        var artistIds = [String]()
        for artist in artists {
            artistIds.append(artist.id)
            imageStorage?.setImage(artist.image, forKey: artist.id, diskOnly: true)
        }
        UserDefaults.standard.set(artistIds, forKey: "artistIds")
    }

    private func loadArtists() {
        let artistIds = UserDefaults.standard.value(forKey: "artistIds") as? [String]
        if let artistIds = artistIds {
            var artists = [Artist]()
            for artistId in artistIds {
                if let image = imageStorage?.image(forKey: artistId) {
                    let artist = Artist(id: artistId, image: image)
                    artists.append(artist)
                }
            }
            self.artists = artists
            collectionView.reloadData()
        }
    }
    
}
