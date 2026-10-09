//
//  RouterApp.swift
//  ImageUiDemo-urls
//
//  Created by jht2 on 9/14/23.
//

import SwiftUI

@main
struct RouterApp: App {
    @State var pageModel = PageModel();
    var body: some Scene {
        WindowGroup {
            // This is the starting page for the app
            MainView()
                .environment(pageModel)
        }
    }
}

