import 'package:flutter/material.dart';
import '../services/phone_services.dart';
import '../theme/contra_theme.dart';

class HomeApp {
  final IconData icon;
  final Color color;
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const HomeApp({
    required this.icon,
    required this.color,
    required this.name,
    required this.subtitle,
    required this.onTap,
  });
}

class LauncherScreen extends StatelessWidget {
  final void Function(int) onOpen;
  const LauncherScreen({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final apps = <HomeApp>[
      HomeApp(
        icon: Icons.call_rounded,
        color: ContraTheme.green,
        name: 'Call',
        subtitle: 'Dial or pick a contact',
        onTap: () => onOpen(1),
      ),
      HomeApp(
        icon: Icons.photo_camera_rounded,
        color: ContraTheme.blue,
        name: 'Camera',
        subtitle: 'Take a photo or video',
        onTap: () => onOpen(2),
      ),
      HomeApp(
        icon: Icons.calendar_month_rounded,
        color: ContraTheme.teal,
        name: 'Calendar',
        subtitle: 'See the days and date',
        onTap: () => onOpen(3),
      ),
      HomeApp(
        icon: Icons.calculate_rounded,
        color: ContraTheme.purple,
        name: 'Calculator',
        subtitle: 'Add, subtract, divide',
        onTap: () => onOpen(4),
      ),
      HomeApp(
        icon: Icons.photo_library_rounded,
        color: ContraTheme.yellow,
        name: 'Gallery',
        subtitle: 'View your photos & videos',
        onTap: () => onOpen(5),
      ),
      HomeApp(
        icon: Icons.settings_rounded,
        color: ContraTheme.ink,
        name: 'Settings',
        subtitle: 'Phone settings',
        onTap: () => PhoneServices.openSettings(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: apps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final app = apps[i];
                return _AppRow(
                  icon: app.icon,
                  color: app.color,
                  name: app.name,
                  subtitle: app.subtitle,
                  onTap: app.onTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const _AppRow({
    required this.icon,
    required this.color,
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ContraTheme.card,
      borderRadius: BorderRadius.circular(24),
      elevation: 2,
      shadowColor: const Color(0x22000000),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          // Icon takes 1/3 of the card, name takes 2/3
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 84,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(icon, size: 44, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ContraTheme.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ContraTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}