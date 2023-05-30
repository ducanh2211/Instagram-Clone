//
//  UIImage + Extenstion.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 17/05/2023.
//

import UIKit
import AVFoundation

extension UIImage {

    func crop(to desireSize: CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }

        let contextImage: UIImage = UIImage(cgImage: cgimage)

        guard let newCgImage = contextImage.cgImage else { return self }

        let contextSize: CGSize = contextImage.size

        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = desireSize.width / desireSize.height

        var cropWidth: CGFloat = desireSize.width
        var cropHeight: CGFloat = desireSize.height

        //Landscape
        if desireSize.width > desireSize.height {
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        }
        //Portrait
        else if desireSize.width < desireSize.height {
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        }
        //Square
        else {
            //Square on landscape (or square)
            if contextSize.width >= contextSize.height {
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }
            //Square on portrait
            else {
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

        // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        UIGraphicsBeginImageContextWithOptions(desireSize, false, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: desireSize.width, height: desireSize.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized ?? self
    }

    func crop(with desireAspect: CGFloat) -> UIImage {

        guard let cgimage = self.cgImage else { return self }
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        guard let newCgImage = contextImage.cgImage else { return self }
        let contextSize: CGSize = contextImage.size

        let isPortrait = contextSize.width < contextSize.height ? true : false

        var positionX: CGFloat = 0.0
        var positionY: CGFloat = 0.0
        var cropWidth: CGFloat
        var cropHeight: CGFloat

        if isPortrait {
            cropWidth = contextSize.width
            cropHeight = cropWidth / desireAspect
            positionY = (contextSize.height - cropHeight) / 2
        } else {
            cropHeight = contextSize.height
            cropWidth = cropHeight * desireAspect
            positionX = (contextSize.width - cropWidth) / 2
        }

        let rect: CGRect = CGRect(x: positionX, y: positionY, width: cropWidth, height: cropHeight)

        // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self }

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        return image
    }
}

extension UIImageView {
    func getImageFrame() -> CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat

        // Landspace image
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        }
        // Portrait image
        else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
