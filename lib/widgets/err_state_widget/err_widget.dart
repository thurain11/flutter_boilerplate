

import '../../core/ob/response_ob.dart';
import '../../global.dart';
import 'connection_timeout_widget.dart';
import 'maintain_widget.dart';
import 'no_internet_widget.dart';
import 'no_login_widget.dart';
import 'not_found_widget.dart';
import 'server_err_widget.dart';
import 'too_many_request_widget.dart';
import 'unknown_err_widget.dart';

class ErrWidget extends StatelessWidget {
  ErrState? errState;
  Function func;

  ErrWidget(this.errState, this.func);

  @override
  Widget build(BuildContext context) {
    return Card(

      child: error(),
    );
  }

  Widget error() {
    if (errState == ErrState.no_internet) {
      return NoInternetWidget(fun: () {
        func();
      });
    } else if (errState == ErrState.no_login) {
      return NoLoginWidget();
    } else if (errState == ErrState.not_found) {
      return NotFoundWidget();
    } else if (errState == ErrState.connection_timeout) {
      return ConnectionTimeoutWidget(fun: () {
        func();
      });
    } else if (errState == ErrState.too_many_request) {
      return TooManyRequestWidget(
        fun: () {
          func();
        },
      );
    } else if (errState == ErrState.server_error) {
      return ServerErrWidget(fun: () {
        func();
      });
    } else if (errState == ErrState.server_maintain) {
      return ServerMaintenance(
        fun: () {
          func();
        },
      );
    } else if (errState == ErrState.unknown_err) {
      return UnknownErrWidget(
        fun: () {
          func();
        },
      );
    } else {
      return UnknownErrWidget(
        fun: () {
          func();
        },
      );
    }
  }
}
