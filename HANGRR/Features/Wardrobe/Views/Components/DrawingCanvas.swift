import SwiftUI
import UIKit

class DrawingCanvasView: UIView {
    var baseImage: UIImage {
        didSet {
            setNeedsDisplay()
        }
    }
    private var path = UIBezierPath()
    private var points: [CGPoint] = []
    private var isDrawing = false
    private var imageRect: CGRect = .zero
    var onFinishDrawing: ((UIImage?) -> Void)?
    
    init(image: UIImage) {
        self.baseImage = image
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let availableHeight = bounds.height
        let availableWidth = bounds.width
        
        let imageSize = baseImage.size
        let imageAspect = imageSize.width / imageSize.height
        let viewAspect = availableWidth / availableHeight
        
        var drawWidth: CGFloat
        var drawHeight: CGFloat
        
        if imageAspect > viewAspect {
            drawWidth = availableWidth
            drawHeight = drawWidth / imageAspect
        } else {
            drawHeight = availableHeight
            drawWidth = drawHeight * imageAspect
        }
        
        let x = (availableWidth - drawWidth) / 2
        let y = (availableHeight - drawHeight) / 2
        
        imageRect = CGRect(x: x, y: y, width: drawWidth, height: drawHeight)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        baseImage.draw(in: imageRect)
        
        UIColor.systemBlue.withAlphaComponent(0.3).setStroke()
        path.lineWidth = 2
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        guard imageRect.contains(point) else { return }
        
        isDrawing = true
        points = [point]
        path = UIBezierPath()
        path.lineWidth = 2
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.move(to: point)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawing, let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        points.append(point)
        path.addLine(to: point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawing, let firstPoint = points.first else { return }
        isDrawing = false
        
        path.addLine(to: firstPoint)
        path.close()
        setNeedsDisplay()
        
        extractImage()
    }
    
    private func extractImage() {
        // Create a context with the original image size
        UIGraphicsBeginImageContextWithOptions(baseImage.size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Clear the context
        context.clear(CGRect(origin: .zero, size: baseImage.size))
        
        // Scale the path to match image coordinates
        let scaleX = baseImage.size.width / imageRect.width
        let scaleY = baseImage.size.height / imageRect.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            .translatedBy(x: -imageRect.minX, y: -imageRect.minY)
        
        let scaledPath = path.copy() as! UIBezierPath
        scaledPath.apply(transform)
        
        // Create mask using the path
        context.saveGState()
        scaledPath.addClip()
        
        // Draw the image only inside the path
        baseImage.draw(in: CGRect(origin: .zero, size: baseImage.size))
        context.restoreGState()
        
        // Get the masked image
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let maskedImage = maskedImage {
            onFinishDrawing?(maskedImage)
        } else {
            onFinishDrawing?(nil)
        }
    }
    
    func reset() {
        path = UIBezierPath()
        points.removeAll()
        setNeedsDisplay()
    }
}

struct DrawingCanvas: UIViewRepresentable {
    let image: UIImage
    let onFinishDrawing: (UIImage?) -> Void
    
    func makeUIView(context: Context) -> DrawingCanvasView {
        let view = DrawingCanvasView(image: image)
        view.onFinishDrawing = onFinishDrawing
        return view
    }
    
    func updateUIView(_ uiView: DrawingCanvasView, context: Context) {
        uiView.baseImage = image
    }
} 