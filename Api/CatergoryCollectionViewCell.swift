//
//  CatergoryCollectionViewCell.swift
//  Api
//
//  Created by Adithya on 29/09/24.
//

import UIKit

class CatergoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let label:UILabel = {
        let label = UILabel()
        label.text = "Latest Updates"
        label.font = UIFont(name: "Rubik Bold Italic", size: 19)
        return label
    }()
    
    private let frontView : UIView = {
        let view = UIView()
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.backgroundColor = .cyan
        imageView.addSubview(frontView)
        contentView.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        imageView.frame = CGRect(x: 0, y: 0, width : contentView.frame.width, height: contentView.frame.height)
        label.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        frontView.frame = CGRect(x: 0, y: contentView.frame.height / 2, width : contentView.frame.width, height: contentView.frame.height/2)
        frontView.roundBottomCorners(radius: 15)  // Adjust the radius value as needed



    }
    
    public func config(with model: Category){
        self.imageView.image = model.image
        self.label.text = model.title
 
        if let image = model.image,
           
            let dominantColor = image.getDominantColor() {
            let nonDominantColor = image.getNonDominantColor(from: dominantColor)

            self.contentView.backgroundColor = dominantColor
            frontView.backgroundColor = nonDominantColor ?? UIColor.gray
            frontView.alpha = 0.5

        } else {
            self.contentView.backgroundColor = UIColor.gray // Default color
        }
    }
}

extension UIImage {
    func getDominantColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        // Use Core Image filter to get dominant color
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)
        
        let filter = CIFilter(name: "CIAreaAverage", parameters: [
            kCIInputImageKey: inputImage,
            kCIInputExtentKey: extentVector
        ])
        
        guard let outputImage = filter?.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
        
        let red = CGFloat(bitmap[0]) / 255.0
        let green = CGFloat(bitmap[1]) / 255.0
        let blue = CGFloat(bitmap[2]) / 255.0
        let alpha = CGFloat(bitmap[3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func getNonDominantColor(from dominantColor: UIColor) -> UIColor? {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            // Get the RGBA components of the dominant color
            dominantColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            // Generate a complementary (inverted) color
            let invertedRed = 1.0 - red
            let invertedGreen = 1.0 - green
            let invertedBlue = 1.0 - blue

            return UIColor(red: invertedRed, green: invertedGreen, blue: invertedBlue, alpha: alpha)
        }
    
}

extension UIView {
    func roundBottomCorners(radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


