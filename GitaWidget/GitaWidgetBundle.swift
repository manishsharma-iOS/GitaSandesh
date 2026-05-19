//
//  GitaWidgetBundle.swift
//  GitaWidget
//
//  Created by Manish Sharma on 16/04/26.
//

import WidgetKit
import SwiftUI

//@main
struct GitaWidgetBundle: WidgetBundle {
    var body: some Widget {
        GitaWidget()
        GitaWidgetControl()
        GitaWidgetLiveActivity()
    }
}
