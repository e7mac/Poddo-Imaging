//
//  Artist.swift
//  Poddo Imaging
//
//  Created by Mayank Sanganeria on 4/16/17.
//  Copyright © 2017 Mayank Sanganeria. All rights reserved.
//

import UIKit

class Artist: NSObject {
    var id: String
    var image: UIImage

    static func createArtist(image: UIImage) -> Artist {
        return Artist(id: UUID().uuidString, image: image)
    }

    init(id: String, image: UIImage) {
        self.id = id
        self.image = image
    }
}
