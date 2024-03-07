import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/response_ob.dart';
import '../../global.dart';

typedef Widget MainWidget(dynamic data, RefreshLoad reload);
typedef Widget More(dynamic data, RefreshLoad reload);
typedef Widget HeaderWidget();
typedef Widget FooterWidget(RefreshLoad reload);
typedef void SuccessCallback(ResponseOb resp);
typedef void CustomMoreCallback(ResponseOb resp);
typedef void CustomErrorCallback(ResponseOb resp);

typedef void RefreshLoad({Map<String, dynamic>? map, ReqType? requestType, bool? refreshShowLoading});


typedef ExternalRefreshWidgetbuilder(Widget widget, dynamic data);
typedef Widget ScorllableHeaderWidget(dynamic data);
typedef Widget CommunityChildWidget<T>(T? data, func, bool isList, int index, Function delete, Function replace);