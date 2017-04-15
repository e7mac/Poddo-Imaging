//
//  LayoutViewController.swift
//  Poddo Imaging
//
//  Created by Mayank Sanganeria on 4/15/17.
//  Copyright © 2017 Mayank Sanganeria. All rights reserved.
//

import UIKit
import SnapKit

enum LayoutViewControllerPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

class LayoutViewController: UIViewController {

    var paintingImage: UIImage?
    var artistImage: UIImage?

    @IBOutlet weak var paintingImageView: UIImageView!
    @IBOutlet weak var artistImageView: UIImageView!
    var artistSize = CGFloat(100.0)
    var position = LayoutViewControllerPosition.topLeft

    @IBOutlet weak var compositeView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        paintingImageView.image = paintingImage
        artistImageView.image = artistImage

        paintingImageView.snp.makeConstraints { (make) in
            if let paintingImage = paintingImage {
                make.height.equalTo(paintingImageView.snp.width).multipliedBy(paintingImage.size.height / paintingImage.size.width)
            }
        }
    }

    @IBAction func saveImage(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(compositeView.bounds.size, compositeView.isOpaque, 0.0)
        compositeView.drawHierarchy(in: compositeView.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIImageWriteToSavedPhotosAlbum(snapshotImageFromMyView!, nil,nil, nil);
        UIGraphicsEndImageContext()

        let alert = UIAlertController(title: "Saved", message: "Saved in Photos", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func changeSize(_ sender: UISlider) {
        artistSize = min(paintingImageView.bounds.size.width, paintingImageView.bounds.size.height) * CGFloat(sender.value)
        updateArtistConstraints()
    }

    @IBAction func topLeft(_ sender: Any) {
        artistImageView.snp.remakeConstraints({ (make) in
            position = .topLeft
            updateArtistConstraints()
        })
    }
    @IBAction func topRight(_ sender: Any) {
        artistImageView.snp.remakeConstraints({ (make) in
            position = .topRight
            updateArtistConstraints()
        })
    }
    @IBAction func bottomLeft(_ sender: Any) {
        artistImageView.snp.remakeConstraints({ (make) in
            position = .bottomLeft
            updateArtistConstraints()
        })
    }
    @IBAction func bottomRight(_ sender: Any) {
        position = .bottomRight
        updateArtistConstraints()
    }

    private func updateArtistConstraints() {
        artistImageView.snp.remakeConstraints({ (make) in
            make.height.width.equalTo(artistSize)
            let padding = 10
            switch position {
            case .topLeft:
                make.top.equalTo(paintingImageView).offset(padding)
                make.left.equalTo(paintingImageView).offset(padding)
                break
            case .topRight:
                make.top.equalTo(paintingImageView).offset(padding)
                make.right.equalTo(paintingImageView).offset(-padding)
                break
            case .bottomLeft:
                make.bottom.equalTo(paintingImageView).offset(-padding)
                make.left.equalTo(paintingImageView).offset(padding)
                break
            case .bottomRight:
                make.bottom.equalTo(paintingImageView).offset(-padding)
                make.right.equalTo(paintingImageView).offset(-padding)
                break
            }
        })
    }
}
