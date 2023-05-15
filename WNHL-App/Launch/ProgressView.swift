//
//  ProgressView.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-09-03.
//

import UIKit

class ProgressView: UIView {
    
    // 1
    init(frame: CGRect,
         colors: [UIColor],
         lineWidth: CGFloat
    ) {
        self.colors = colors
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    // 2
    convenience init(colors: [UIColor], lineWidth: CGFloat) {
        self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = (self.frame.width / 2);
        // 3
        let path = UIBezierPath(ovalIn:
                                    CGRect(
                                        x: -10,
                                        y: 200,
                                        // 60
                                        width: self.bounds.width,
                                        // 60
                                        height: self.bounds.width
                                    )
        )
        
        shapeLayer.path = path.cgPath
    }
    
    // 4
    let colors: [UIColor]
    let lineWidth: CGFloat
    
    // 5
    private lazy var shapeLayer: ProgressShapeLayer = {
        return ProgressShapeLayer(strokeColor: colors.first!, lineWidth: lineWidth)
    }()
    
    // MARK: - Animations
    func animateStroke() {
        
        // 1
        let startAnimation = StrokeAnimation(
            type: .start,
            beginTime: 0.25,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )
        // 2
        let endAnimation = StrokeAnimation(
            type: .end,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )
        // 3
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = [startAnimation, endAnimation]
        // 4
        shapeLayer.add(strokeAnimationGroup, forKey: nil)
        // 5
        self.layer.addSublayer(shapeLayer)
    }
    
}
