import 'dart:developer';
import 'dart:io';
import 'package:elajkom/ui/pages/account/reset_password_page.dart';
import 'package:elajkom/ui/pages/main_page.dart';
import 'package:elajkom/ui/pages/meetings_page.dart';

import '../../classes/models/specialty.dart';
import '../../classes/models/user.dart';
import '../../ui/pages/account/singup_page.dart';
import '../../ui/pages/chat/Message_page.dart';
import '../../ui/pages/content_page.dart';
import '../../ui/pages/doctors/book_page.dart';
import '../../ui/pages/doctors/book_payment_page.dart';
import '../../ui/pages/doctors/doctor_details_page.dart';
import '../../ui/pages/doctors/specialties_doctor_page.dart';
import '../../util/custome_widgets/image_view_page.dart';
import 'package:flutter/material.dart';

import '../../ui/pages/splash_page.dart';
import 'global_var.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    log('settings.name:${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case MainPage.routeName:
        return MaterialPageRoute(builder: (_) => MainPage(settings.arguments));

      ////////////////{ doctor Section } ////////////////

      case DoctorDetailsPage.routeName:
        if (args is String) {
          return MaterialPageRoute(builder: (_) => DoctorDetailsPage(args));
        }
        return _errorRoute();

      case SpecialtiesDoctorsPage.routeName:
        if (args is Specialty) return MaterialPageRoute(builder: (_) => SpecialtiesDoctorsPage(args));
        return _errorRoute();

      case BookPage.routeName:
        if (args is User) return MaterialPageRoute(builder: (_) => BookPage(doctor: args));
        if (args is String) return MaterialPageRoute(builder: (_) => BookPage(id: args));
        return _errorRoute();

      case BookPaymentPage.routeName:
        if (args is int) return MaterialPageRoute<bool>(builder: (_) => BookPaymentPage(args));
        return _errorRoute();

      case MeetingsPage.routeName:
        return MaterialPageRoute<bool>(builder: (_) => MeetingsPage(withDrawer: args));

      case ImageViewPage.routeName:
        if (args is String || args is File) return MaterialPageRoute(builder: (_) => ImageViewPage(image: args));

        return _errorRoute();

      case MessagePage.routeName:
        if (args is List) return MaterialPageRoute(builder: (_) => MessagePage(args[0], args[1]));
        return _errorRoute();

      case SignupPage.routeName:
        return MaterialPageRoute(builder: (_) => SignupPage(args));

      case ContentPage.routeName:
        return MaterialPageRoute(builder: (_) => ContentPage(args));

      case ResetPasswordPage.routeName:
        if (args is List) return MaterialPageRoute(builder: (_) => ResetPasswordPage(args[0], args[1], args[2]));
        return _errorRoute();

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(str.msg.errorOccurred),
        ),
        body: Center(
          child: Text(str.msg.errorPageRouting),
        ),
      );
    });
  }
}
