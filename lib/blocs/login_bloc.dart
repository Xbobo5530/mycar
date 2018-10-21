import 'dart:async';

class LoginBloc {
  final _loginController = StreamController();

  Sink get storiesType => _loginController.sink;

  void close() {
    _loginController.close();
  }

  LoginBloc() {
    _loginController.stream.listen((loginType) {
      _handleLogin();
    });
  }

  void _handleLogin() {}
}
