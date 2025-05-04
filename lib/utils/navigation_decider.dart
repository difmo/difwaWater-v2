import 'package:difwa/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NavigationDecider {
  static void navigateBasedOnRole(String? role) {
    switch (role) {
      case 'isUser':
        Get.offNamed(AppRoutes.userbottom);
        break;
      case 'isStoreKeeper':
        Get.offNamed(AppRoutes.storebottombar);
        break;
      default:
        Get.offNamed(AppRoutes.useronboarding);
        break;
    }
  }

  static void navigateToOnboarding() {
    Get.offNamed(AppRoutes.useronboarding);
  }
}
