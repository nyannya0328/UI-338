//
//  Intro.swift
//  UI-338 (iOS)
//
//  Created by nyannyan0328 on 2021/10/21.
//

import SwiftUI

struct Intro: Identifiable {
    var id = UUID().uuidString
    var title : String
    var subTitle : String
    var description : String
    var pic : String
    var color : Color
    var offset : CGSize = .zero

}

