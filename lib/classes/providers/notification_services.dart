import 'package:elajkom/classes/models/notifications.dart';
import '../../util/utility/api_provider.dart';

class NotificationServices {
  Future<List<NotificationClass>> loadNotification(int page) async {
    var res = await ApiProvider().getRequest('/api/Notifications/$page');
    List<NotificationClass> list = [];
    res.forEach((v) => list.add(NotificationClass.fromJson(v)));
    return list.toList();
  }
}
