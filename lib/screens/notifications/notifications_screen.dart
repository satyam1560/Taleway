import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/constants.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/notif/notif_repository.dart';
import '/screens/notifications/bloc/notif_bloc.dart';
import '/widgets/gradient_circle_button.dart';
import '/widgets/loading_indicator.dart';
import 'widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = '/notif';
  const NotificationScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => NotifBloc(
            authBloc: context.read<AuthBloc>(),
            notificationRepository: context.read<NotificationRepository>()),
        child: const NotificationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: gradientBackground,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<NotifBloc, NotifState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.status == NotificationsStatus.loaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      // const SizedBox(height: 5.0),
                      Padding(
                        padding: EdgeInsets.only(left: _canvas.width * 0.045),
                        child: Row(
                          children: [
                            GradientCircleButton(
                              onTap: () => Navigator.of(context).pop(),
                              icon: Icons.arrow_back,
                            ),
                            //   Spacer(),
                            const SizedBox(width: 15.0),
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.notifications?.length,
                          itemBuilder: (context, index) {
                            final notification = state.notifications?[index];
                            return NotificationTile(notification: notification);
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
              return const LoadingIndicator();
            },
          ),
        ),
      ),
    );
  }
}
