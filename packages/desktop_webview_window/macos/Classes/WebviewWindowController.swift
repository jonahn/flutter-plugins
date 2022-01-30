//
//  WebviewWindowController.swift
//  webview_window
//
//  Created by Bin Yang on 2021/10/15.
//

import Cocoa
import FlutterMacOS
import WebKit

class WebviewWindowController: NSPanel {
  private var methodChannel: FlutterMethodChannel

  private var viewId: Int64

  private var x, y: Int

  private var width, height: Int

  private var titleBarHeight: Int
  
  private var titleBarTopPadding: Int
  
//  private let title: String
  
  public weak var webviewPlugin: DesktopWebviewWindowPlugin?
  init(viewId: Int64, methodChannel: FlutterMethodChannel,
       width: Int, height: Int,
       x: Int, y: Int,
       title: String, titleBarHeight: Int,
       titleBarTopPadding: Int) {
    self.viewId = viewId
    self.methodChannel = methodChannel
    self.width = width
    self.height = height
    self.x = x
    self.y = y
    self.titleBarHeight = titleBarHeight
    self.titleBarTopPadding = titleBarTopPadding
      super.init(contentRect: NSRect(x: x, y:y, width: width, height: height), styleMask: NSWindow.StyleMask.init(rawValue: NSWindow.StyleMask.closable.rawValue|NSWindow.StyleMask.titled.rawValue|NSWindow.StyleMask.resizable.rawValue), backing: NSWindow.BackingStoreType.buffered, defer: true)
    self.title = title
    setupWindow();
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public var webViewController: WebViewLayoutController {
    contentViewController as! WebViewLayoutController
  }

  func setupWindow() {
    contentViewController = WebViewLayoutController(
      methodChannel: methodChannel,
      viewId: viewId, titleBarHeight: titleBarHeight,
      titleBarTopPadding: titleBarTopPadding)

    self.isReleasedWhenClosed = false
    self.delegate = self
  }

  override func keyDown(with event: NSEvent) {
    if event.charactersIgnoringModifiers == "w" && event.modifierFlags.contains(.command) {
      close()
    }
  }

  func destroy() {
    self.delegate = nil
    contentViewController = nil
  }

  func setAppearance(brightness: Int) {
    switch brightness {
    case 0:
      if #available(macOS 10.14, *) {
        self.appearance = NSAppearance(named: .darkAqua)
      } else {
        // Fallback on earlier versions
      }
      break
    case 1:
        self.appearance = NSAppearance(named: .aqua)
      break
    default:
        self.appearance = nil
      break
    }
  }

  deinit {
    #if DEBUG
      print("\(self) deinited")
    #endif
  }
}

extension WebviewWindowController: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    webViewController.destroy()
    methodChannel.invokeMethod("onWindowClose", arguments: ["id": viewId])
    DispatchQueue.main.async {
      self.webviewPlugin?.onWebviewWindowClose(viewId: self.viewId, wc: self)
    }
  }
}
