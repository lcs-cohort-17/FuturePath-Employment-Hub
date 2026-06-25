import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import 'app_router.dart';


bool checkAdminAccess(BuildContext context, AuthProvider authProvider) {
  if (!authProvider.isAuthenticated) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.login,
            (route) => false,
      );
    });
    return false;
  }

  if (!authProvider.isAdmin) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.home,
            (route) => false,
      );
    });
    return false;
  }

  return true;
}