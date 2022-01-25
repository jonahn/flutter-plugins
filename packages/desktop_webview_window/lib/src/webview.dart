import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Handle custom message from JavaScript in your app.
typedef JavaScriptMessageHandler = void Function(String name, dynamic body);

typedef PromptHandler = String Function(String prompt, String defaultText);

typedef OnHistoryChangedCallback = void Function(
    bool canGoBack, bool canGoForward);

/// Callback when WebView start to load a URL.
/// [url] is the URL string.
typedef OnUrlRequestCallback = void Function(String url);

/// WebView open a URL,if success will call OnUrlRequestCallback
/// fail for bridge like:  window.open("js://webview?arg1=111&args2=222");
typedef UrlOpenTask = bool Function(String url);


abstract class Webview {
  Future<void> get onClose;

  ///  true if the webview is currently loading a page.
  ValueListenable<bool> get isNavigating;

  // for url open call back bridge
  static UrlOpenTask? openTask;

  /// Install a message handler that you can call from your Javascript code.
  ///
  /// available: macOS (10.10+)
  void registerJavaScriptMessageHandler(
      String name, JavaScriptMessageHandler handler);

  /// available: macOS
  void unregisterJavaScriptMessageHandler(String name);

  /// available: macOS
  void setPromptHandler(PromptHandler? handler);

  /// Navigates to the given URL.
  void launch(String url);

  /// change webview theme.
  ///
  /// available only: macOS (Brightness.dark only 10.14+)
  void setBrightness(Brightness? brightness);

  void addScriptToExecuteOnDocumentCreated(String javaScript);

  /// Append a string to the webview's user-agent.
  Future<void> setApplicationNameForUserAgent(String applicationName);

  /// Navigate to the previous page in the history.
  Future<void> back();

  /// Navigate to the next page in the history.
  Future<void> forward();

  /// Reload the current page.
  Future<void> reload();

  /// Stop all navigations and pending resource fetches.
  Future<void> stop();

  /// Register a callback that will be invoked when the webview history changes.
  void setOnHistoryChangedCallback(OnHistoryChangedCallback? callback);

  void addOnUrlRequestCallback(OnUrlRequestCallback callback);

  void removeOnUrlRequestCallback(OnUrlRequestCallback callback);

  /// Close the web view window.
  void close();

  /// evaluate JavaScript in the web view.
  Future<String?> evaluateJavaScript(String javaScript);

}
