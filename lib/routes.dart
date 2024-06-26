import 'package:drive_guard/controllers/auth_session.dart';
import 'package:drive_guard/screens/map/open_map.dart';
import 'package:flutter/widgets.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/workshop/workshop_detail_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  AuthSession.routeName: (context) => const AuthSession(),
  SplashScreen1.routeName: (context) => const SplashScreen1(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  OpenMapScreen.routeName: (context) => const OpenMapScreen(),
  WorkshopDetailScreen.routeName: (context) => WorkshopDetailScreen(),
};
