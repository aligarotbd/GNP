//
//  MyStyle.swift
//  GNP
//
//  Created by user on 11/01/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import Foundation

import GradientCircularProgress

public struct MyStyle : StyleProperty {
    /*** style properties **********************************************************************************/
    
    // Progress Size
    public var progressSize: CGFloat = 100
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 14.0
    public var startArcColor: UIColor = UIColor.clear
    public var endArcColor: UIColor = UIColor.white
    
    // Base Circular
    public var baseLineWidth: CGFloat? = 15.0
    public var baseArcColor: UIColor? = UIColor.clear
    
    // Ratio
    public var ratioLabelFont: UIFont? = UIFont(name: "Verdana-Bold", size: 16.0)
    public var ratioLabelFontColor: UIColor? = UIColor.white
    
    // Message
    public var messageLabelFont: UIFont? = UIFont.systemFont(ofSize: 16.0)
    public var messageLabelFontColor: UIColor? = UIColor.white
    
    // Background
    public var backgroundStyle: BackgroundStyles = .transparent
    
    // Dismiss
    public var dismissTimeInterval: Double? = 0.0 // 'nil' for default setting.
    
    /*** style properties **********************************************************************************/
    
    public init() {}
}
