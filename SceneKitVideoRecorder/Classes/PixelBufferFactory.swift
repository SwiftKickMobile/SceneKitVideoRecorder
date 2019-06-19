//
//  PixelBufferFactory.swift
//
//  Created by Omer Karisman on 2017/08/29.
//

import UIKit

struct PixelBufferFactory {
    
    static let context = CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)
    
    static func make(with currentDrawable: CAMetalDrawable, usingBuffer pool: CVPixelBufferPool) -> CVPixelBuffer? {
        var destinationTexture = currentDrawable.texture
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pixelBuffer)
        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.init(rawValue: 0))
            let region = MTLRegionMake2D(0, 0, Int(currentDrawable.layer.drawableSize.width), Int(currentDrawable.layer.drawableSize.height))
            let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
            destinationTexture.getBytes(pixelData!, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
            
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.init(rawValue: 0))
            return pixelBuffer
        }
        return nil
    }
    
    static func imageFromCVPixelBuffer(buffer: CVPixelBuffer) -> UIImage {
        
        let ciimage = CIImage(cvPixelBuffer: buffer)
        let cgimgage = context.createCGImage(ciimage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer)))
        
        let uiimage = UIImage(cgImage: cgimgage!)
        
        return uiimage
    }
    
}

