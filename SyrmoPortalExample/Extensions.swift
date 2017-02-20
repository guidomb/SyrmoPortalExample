//
//  UIImageExtensions.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import UIKit

public extension Date {
    
    public var timeAgo: String {
        // TODO
        return "1m"
    }
    
}

extension Array {
    
    func sample() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
    
}

public extension UIImage {

    public static func overlay(backgroundImage: UIImage, foregroundImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0)
        backgroundImage.draw(in: CGRect(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height))
        foregroundImage.draw(in: CGRect(x: 0, y: 0, width: foregroundImage.size.width, height: foregroundImage.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    public func createSyrmoImageProfile(using bundle: Bundle = .main) -> UIImage? {
        guard   let placeholder = UIImage(named: "DefaultAvatar", in: bundle, compatibleWith: .none),
            let mask = UIImage(named: "AvatarMask", in: bundle, compatibleWith: .none)
            else { return .none }

        let resizedProfileImage = resizeImageToSize(size: mask.size)
        let croppedProfileImage = resizedProfileImage.doMask(mask: mask)
        let profileImageWithBorder = UIImage.overlay(backgroundImage: placeholder, foregroundImage: croppedProfileImage)
        return profileImageWithBorder
    }

    public func doMask(mask: UIImage) -> UIImage {
        let maskRef = mask.cgImage
        let mask = CGImage(maskWidth: maskRef!.width, height: maskRef!.height, bitsPerComponent: maskRef!.bitsPerComponent,
                           bitsPerPixel: maskRef!.bitsPerPixel, bytesPerRow: maskRef!.bytesPerRow, provider: maskRef!.dataProvider!, decode: nil, shouldInterpolate: false)
        let maskedImageRef = self.cgImage!.masking(mask!)
        let maskedImage = UIImage(cgImage: maskedImageRef!)
        return maskedImage
    }


    public func resizeImageToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }

}
