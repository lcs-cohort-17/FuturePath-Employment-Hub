import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../router/app_router.dart';

class NotificationBadge extends StatelessWidget {
  final Color iconColor;

  const NotificationBadge({
    super.key,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Access the Singleton service
    final notificationService = NotificationService();

    return ListenableBuilder(
      listenable: notificationService,
      builder: (context, _) {
        final unreadCount = notificationService.unreadCount;

        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none_rounded, color: iconColor, size: 26),
              onPressed: () {
                // We pass a copy of the list to ensure the route receives the correct data type
                final List<Map<String, dynamic>> currentNotifications = 
                    List<Map<String, dynamic>>.from(notificationService.notifications);
                
                Navigator.pushNamed(
                  context,
                  AppRouter.notifications,
                  arguments: currentNotifications,
                );
              },
            ),
            if (unreadCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
