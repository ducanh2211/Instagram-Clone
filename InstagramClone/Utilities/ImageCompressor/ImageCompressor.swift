//
//  ImageCompressor.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 24/05/2023.
//

import UIKit

struct ImageCompressor {
    static func compress(image: UIImage, maxByte: Int,
                         completion: @escaping (UIImage?) -> ()) {

        DispatchQueue.global(qos: .userInitiated).async {
            guard let currentImageSize = image.jpegData(compressionQuality: 1.0)?.count else {
                return completion(nil)
            }

            var iterationImage: UIImage? = image
            var iterationImageSize = currentImageSize
            var iterationCompression: CGFloat = 1.0

            while iterationImageSize > maxByte && iterationCompression > 0.01 {
                let percentageDecrease = getPercentageToDecreaseTo(forDataCount: iterationImageSize)

                let canvasSize = CGSize(width: image.size.width * iterationCompression,
                                        height: image.size.height * iterationCompression)
                UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
                defer { UIGraphicsEndImageContext() }
                image.draw(in: CGRect(origin: .zero, size: canvasSize))
                iterationImage = UIGraphicsGetImageFromCurrentImageContext()

                guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
                    return completion(nil)
                }
                iterationImageSize = newImageSize
                iterationCompression -= percentageDecrease
            }
            completion(iterationImage)
        }
    }

    private static func getPercentageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
        switch dataCount {
            case 0..<5000000: return 0.03
            case 5000000..<10000000: return 0.1
            default: return 0.2
        }
    }
}
