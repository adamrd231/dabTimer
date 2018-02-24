//
//  TimerListIem.swift
//  dabTimer3.0
//
//  Created by Adam Reed on 2/16/18.
//  Copyright © 2018 RD concepts. All rights reserved.
//

import UIKit

class TimerListItem: NSObject, Codable {
    
    var name = ""
    var items = [UpDownTimer]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    
    
}
