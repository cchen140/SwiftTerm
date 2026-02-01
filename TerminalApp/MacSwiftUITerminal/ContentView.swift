//
//  ContentView.swift
//  MacSwiftUITerminal
//
//  Main content view hosting the terminal
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LocalTerminalView()
            .frame(minWidth: 600, minHeight: 400)
    }
}

#Preview {
    ContentView()
}
