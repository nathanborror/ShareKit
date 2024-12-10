#if os(macOS)
import Foundation
import AppKit

extension NSImage {
    
    public func pngData() -> Data? {
        guard let tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            return nil
        }
        
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
    public func resize(to targetSize: CGSize, interpolation: NSImageInterpolation = .high) -> Data? {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)

        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        let scaledImage = NSImage(size: scaledImageSize)
        
        scaledImage.lockFocus()
        
        NSGraphicsContext.current?.imageInterpolation = interpolation

        draw(in: CGRect(origin: .zero, size: scaledImageSize),
                   from: CGRect(origin: .zero, size: size),
                   operation: .copy,
                   fraction: 1.0)
        scaledImage.unlockFocus()

        guard let cgImage = scaledImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        return bitmapRep.representation(using: .png, properties: [:])
    }
}
#endif
