//
//  WKInterfaceButton+l10n.swift
//  L10n_swift
//
//  Created by Adrian Bobrowski on 30.07.2017.
//  Copyright © 2017 Adrian Bobrowski (Decybel07), adrian071993@gmail.com. All rights reserved.
//

import WatchKit

extension WKInterfaceButton: IBL10n {

    var l10nTitle: String {
        get { self.messageForSetOnlyProperty("l10nTitle", "WKInterfaceButton") }
        set { self.setTitle(L10n.shared.string(for: newValue)) }
    }
}