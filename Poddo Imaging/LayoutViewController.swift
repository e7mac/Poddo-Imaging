//
//  LayoutViewController.swift
//  Poddo Imaging
//
//  Created by Mayank Sanganeria on 4/15/17.
//  Copyright © 2017 Mayank Sanganeria. All rights reserved.
//

import UIKit
import SnapKit
import UIView_draggable

class LayoutViewController: UIViewController {

    var paintingImage: UIImage?
    var artistImage: UIImage?

    @IBOutlet weak var paintingImageView: UIImageView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var compositeView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        paintingImageView.contentMode = .scaleAspectFit
        paintingImageView.image = paintingImage
        artistImageView.image = artistImage

        paintingImageView.snp.makeConstraints { (make) in
            if let paintingImage = paintingImage {
                make.height.equalTo(paintingImageView.snp.width).multipliedBy(paintingImage.size.height / paintingImage.size.width)
            }
        }
        artistImageView.isUserInteractionEnabled = true
        artistImageView.enableDragging()
        makeArtistCircular()
    }

    @IBAction func saveImage(_ sender: Any) {
        saveToPhotos(view: offscreenImageView())
        messageDone()
    }

    @IBAction func changeSize(_ sender: UISlider) {
        setArtistSizePercentage(CGFloat(sender.value))
    }

    private func setArtistSizePercentage(_ percentage: CGFloat) {
        let artistSize = min(paintingImageView.bounds.size.width, paintingImageView.bounds.size.height) * percentage
        print(artistSize)
        artistImageView.bounds = CGRect(x: 0, y: 0, width: artistSize, height: artistSize)
        makeArtistCircular()
    }

    private func offscreenImageView() -> UIView? {
        if let paintingImage = paintingImage, let artistImage = artistImage {
            let container = UIImageView(frame: CGRect(x: 0, y: 0, width: paintingImage.size.width, height: paintingImage.size.height))
            container.backgroundColor = .black
            container.image = paintingImage
            let maxDimension = max(paintingImage.size.width, paintingImage.size.height)
            let artistSize = artistImageView.bounds.size.width / paintingImageView.bounds.size.width * maxDimension
            var artistX = CGFloat(0.0)
            var artistY = CGFloat(0.0)

            let artistXInitial = artistImageView.frame.origin.x + artistImageView.bounds.size.width/2.0 - paintingImageView.bounds.size.width/2.0
            let artistYInitial = artistImageView.frame.origin.y + artistImageView.bounds.size.height/2.0 - paintingImageView.bounds.size.height/2.0
            if paintingImage.size.width > paintingImage.size.height {
                artistX = artistXInitial / paintingImageView.bounds.size.width * paintingImage.size.width
                artistY = artistYInitial / paintingImageView.bounds.size.width * paintingImage.size.width
            } else if paintingImage.size.width < paintingImage.size.height {
                artistX = artistXInitial / paintingImageView.bounds.size.height * paintingImage.size.height
                artistY = artistYInitial / paintingImageView.bounds.size.height * paintingImage.size.height
            } else if paintingImage.size.width == paintingImage.size.height {
                artistX = artistXInitial / paintingImageView.bounds.size.width * paintingImage.size.width
                artistY = artistYInitial / paintingImageView.bounds.size.height * paintingImage.size.height
            }

            artistX = artistX + paintingImage.size.width/2.0 - artistSize/2.0
            artistY = artistY + paintingImage.size.height/2.0 - artistSize/2.0

            let artistView = UIImageView(frame: CGRect(x: artistX, y: artistY, width: artistSize, height: artistSize))
            artistView.image = artistImage
            container.addSubview(artistView)
            return container
        }
        return nil
    }

    private func makeArtistCircular() {
        artistImageView.layer.cornerRadius = artistImageView.bounds.size.width / 2.0
        artistImageView.clipsToBounds = true
    }

    private func messageDone() {
        let alert = UIAlertController(title: "Saved", message: "Saved in Photos", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func saveToPhotos(view: UIView?) {
        if let view = view {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
            UIImageWriteToSavedPhotosAlbum(snapshotImageFromMyView!, nil,nil, nil);
            UIGraphicsEndImageContext()
        }
    }
}
