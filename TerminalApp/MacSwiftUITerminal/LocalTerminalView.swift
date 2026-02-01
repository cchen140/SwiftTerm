//
//  LocalTerminalView.swift
//  MacSwiftUITerminal
//
//  NSViewRepresentable wrapper for SwiftTerm's LocalProcessTerminalView
//

import SwiftUI
import AppKit
import SwiftTerm

struct LocalTerminalView: NSViewRepresentable {
    typealias NSViewType = LocalProcessTerminalView

    func makeNSView(context: Context) -> LocalProcessTerminalView {
        let terminalView = LocalProcessTerminalView(frame: .zero)
        terminalView.processDelegate = context.coordinator

        // Configure terminal appearance
        terminalView.font = NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)

        // Start the shell process
        let shell = getShell()
        let shellIdiom = "-" + (shell as NSString).lastPathComponent
        terminalView.startProcess(executable: shell, execName: shellIdiom)

        return terminalView
    }

    func updateNSView(_ nsView: LocalProcessTerminalView, context: Context) {
        // Handle view updates if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    private func getShell() -> String {
        let bufsize = sysconf(_SC_GETPW_R_SIZE_MAX)
        guard bufsize != -1 else {
            return "/bin/zsh"
        }
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufsize)
        defer { buffer.deallocate() }

        var pwd = passwd()
        var result: UnsafeMutablePointer<passwd>? = UnsafeMutablePointer<passwd>.allocate(capacity: 1)

        if getpwuid_r(getuid(), &pwd, buffer, bufsize, &result) != 0 {
            return "/bin/zsh"
        }
        return String(cString: pwd.pw_shell)
    }

    class Coordinator: NSObject, LocalProcessTerminalViewDelegate {
        func sizeChanged(source: LocalProcessTerminalView, newCols: Int, newRows: Int) {
            // Terminal size changed
        }

        func setTerminalTitle(source: LocalProcessTerminalView, title: String) {
            // Update window title if needed
            if let window = source.window {
                window.title = title
            }
        }

        func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {
            // Current directory changed
        }

        func processTerminated(source: TerminalView, exitCode: Int32?) {
            // Shell process terminated
            if let code = exitCode {
                print("Process terminated with exit code: \(code)")
            }
        }
    }
}

#Preview {
    LocalTerminalView()
        .frame(width: 800, height: 600)
}
