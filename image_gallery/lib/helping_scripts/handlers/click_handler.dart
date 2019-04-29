import 'dart:async';

class ClickHandler {
  static bool _canClick;

  ClickHandler() {
    _canClick = true;
  }

  void clickActionOnce(action) {
    if (_canClick) {
      _canClick = false;
      action();
    }
  }

  void clickActionOnceParam(action, var parameter) {
    if (_canClick) {
      _canClick = false;
      action(parameter);
    }
  }

  void clickAction(action) {
    if (_canClick) {
      action();
    }
  }

  void clickActionParam(action, var parameter) {
    if (_canClick) {
      action(parameter);
    }
  }

  void unlock() {
    _canClick = true;
  }

  Future<bool> unlockFuture() async {
    _canClick = true;

    return true;
  }
}
