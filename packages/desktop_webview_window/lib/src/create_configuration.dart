import 'dart:io';

class CreateConfiguration {
  final int windowWidth;
  final int windowHeight;
  final int x;
  final int y;
  /// the title of window
  final String title;

  final int titleBarHeight;

  final int titleBarTopPadding;

  final String userDataFolderWindows;

  const CreateConfiguration({
    this.windowWidth = 1280,
    this.windowHeight = 720,
    this.x = 80,
    this.y = 80,
    this.title = "",
    this.titleBarHeight = 40,
    this.titleBarTopPadding = 0,
    this.userDataFolderWindows = 'webview_window_WebView2',
  });

  factory CreateConfiguration.platform() {
    return CreateConfiguration(
      titleBarTopPadding: Platform.isMacOS ? 24 : 0,
    );
  }

  Map toMap() => {
        "windowWidth": windowWidth,
        "windowHeight": windowHeight,
        "windowX": x,
        "windowY": y,
        "title": title,
        "titleBarHeight": titleBarHeight,
        "titleBarTopPadding": titleBarTopPadding,
        "userDataFolderWindows": userDataFolderWindows,
      };
}
