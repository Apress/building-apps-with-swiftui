//
//  LineChartController.swift
//  NiceCrypto
//
//  Created by Mehul Mohan on 17/07/19.
//  Copyright © 2019 Mehul Mohan. All rights reserved.
//

import SwiftUI
import UIKit


struct LineChartController: UIViewRepresentable {

    let lineCoordinates: [CGFloat]
    let inline: Bool
    
    func updateUIView(_ uiView: LineChart, context: UIViewRepresentableContext<LineChartController>) {
        // ..
    }
    
    func makeUIView(context: Context) -> LineChart {
        
        let lineChart = LineChart()
        
        lineChart.addLine(lineCoordinates)
        
        
        if inline {
            lineChart.y.labels.visible = false
            lineChart.x.labels.values = ["Yesterday", "Today", "Tomorrow"]
        } else {
            
            lineChart.x.labels.values = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"]
        }
        
        return lineChart
    }
}
