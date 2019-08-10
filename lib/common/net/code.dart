import 'package:event_bus/event_bus.dart';
import 'package:skyroad/common/event/http_error_event.dart';

///错误编码
class Code {
  ///网络错误
  static const NETWORK_ERROR = -1;

  ///网络超时
  static const NETWORK_TIMEOUT = -2;

  ///网络返回数据格式化一次
  static const NETWORK_JSON_EXCEPTION = -3;

  static const SUCCESS = 200;

  static final EventBus eventBus = new EventBus();

//  static final EventBus eventBus = new EventBus(sync: true);//使用异步操作

  static errorHandleFunction(code, message, noTip) {
//    if (noTip) {
//      return message;
//    }
    eventBus.fire(new HttpErrorEvent(code, message));
  }
}
