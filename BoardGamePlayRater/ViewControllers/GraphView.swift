//
//  GraphView.swift
//  BoardGamePlayRater
//
//  Created by Maria Beutel on 8/23/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import Foundation
import UIKit

struct BarElement {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Float
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
}

class GraphView: UIView {
    
    /// the width of each bar
    var barWidth: CGFloat!
    
    /// space between each bar
    var space: CGFloat!
    
    /// space at the bottom of the bar to show the title
    private let bottomSpace: CGFloat = 30.0
    
    /// space at the top of each bar to show the value
    private let topSpace: CGFloat = 40.0
    
    /// contain all layers of the chart
    private let mainLayer: CALayer = CALayer()
    
    /// Uncomment to add scroll view:
    //private let scrollView: UIScrollView = UIScrollView()
    
    var dataEntries: [BarElement]? = nil {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            // Set bar width based on number of player bars and width of screen view:
            barWidth = round((self.layer.frame.width / CGFloat((dataEntries?.count)!)) / 2.0)
            // Set spacing width based on number of player bars and width of screen view:
            space = round(self.layer.frame.width / CGFloat((dataEntries?.count)!) / 2.0)
            
            if let dataEntries = dataEntries {
                mainLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)

                // Uncomment to change add scroll view:
                //                scrollView.contentSize = CGSize(width: (barWidth + space)*CGFloat(dataEntries.count), height: self.frame.size.height)
                //                mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)

                drawHorizontalLines()
                
                for i in 0..<dataEntries.count {
                    showBarElement(index: i, element: dataEntries[i])
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.layer.addSublayer(mainLayer)
        
        // Uncomment below to add scroll view for additional bar elements:
        //      scrollView.layer.addSublayer(mainLayer)
        //      self.addSubview(scrollView)
    }
    
// Uncomment below to add scroll view for additional bar elements:
//    override func layoutSubviews() {
//        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//    }

    private func showBarElement(index: Int, element: BarElement) {
        /// Starting x postion of the bar
        let xPos: CGFloat = space / 2.0 + CGFloat(index) * (barWidth + space)
        
        /// Starting y postion of the bar
        let yPos: CGFloat = translateHeightValueToYPosition(value: element.height)
        
        drawBar(xPos: xPos, yPos: yPos, color: element.color)
        
        /// Draw text above the bar
        drawTextValue(xPos: xPos - space/2, yPos: yPos - 30, textValue: element.textValue, color: element.color)
        
        /// Draw text below the bar
        drawTitle(xPos: xPos - space/2, yPos: mainLayer.frame.height - bottomSpace + 10, title: element.title, color: UIColor.black)
    }
    
    
    private func drawBar(xPos: CGFloat, yPos: CGFloat, color: UIColor) {
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth, height: mainLayer.frame.height - bottomSpace - yPos)
        barLayer.backgroundColor = color.cgColor
        mainLayer.addSublayer(barLayer)
    }
    
    private func drawHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let horizontalLineInfos = [["value": Float(0.0), "dashed": false]] // If need more just add within []
        for lineInfo in horizontalLineInfos {
            let xPos = CGFloat(0.0)
            let yPos = translateHeightValueToYPosition(value: (lineInfo["value"] as! Float))
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: mainLayer.frame.size.width, y: yPos))
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = 0.5
            if lineInfo["dashed"] as! Bool {
                lineLayer.lineDashPattern = [4, 4]
            }
            lineLayer.strokeColor = UIColor.lightGray.cgColor
            self.layer.insertSublayer(lineLayer, at: 0)
        }
    }
    
    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String, color: UIColor) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth+space, height: 22)
        textLayer.foregroundColor = color.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 14
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, title: String, color: UIColor) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth + space, height: 22)
        textLayer.foregroundColor = color.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 14
        textLayer.string = title
        mainLayer.addSublayer(textLayer)
    }
    
    private func translateHeightValueToYPosition(value: Float) -> CGFloat {
        let height: CGFloat = CGFloat(value) * (mainLayer.frame.height - bottomSpace - topSpace)
        return mainLayer.frame.height - bottomSpace - height
    }
}
