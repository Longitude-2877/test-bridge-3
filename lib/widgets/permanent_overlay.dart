import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/phone_services.dart';
import '../theme/contra_theme.dart';

class SystemTopBar extends StatefulWidget {
  const SystemTopBar({super.key});

  @override
  State<SystemTopBar> createState() => _SystemTopBarState();
}

class _SystemTopBarState extends State<SystemTopBar> {
  late final Battery _battery;
  DateTime _now = DateTime.now();
  int _batteryLevel = 100;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _battery = Battery();
    _refreshBattery();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  Future<void> _refreshBattery() async {
    try {
      final level = await _battery.batteryLevel;
      if (mounted) setState(() => _batteryLevel = level);
    } catch (_) {}
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _now.hour.toString().padLeft(2, '0');
    final m = _now.minute.toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: const BoxDecoration(
        color: ContraTheme.card,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.schedule, size: 20, color: ContraTheme.ink),
              const SizedBox(width: 6),
              Text(
                '$h:$m',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ContraTheme.ink,
                ),
              ),
            ],
          ),
          _BatteryIndicator(level: _batteryLevel),
        ],
      ),
    );
  }
}

class _BatteryIndicator extends StatelessWidget {
  final int level;
  const _BatteryIndicator({required this.level});

  @override
  Widget build(BuildContext context) {
    final litSegments = level >= 66
        ? 3
        : level >= 33
            ? 2
            : 1;
    final segmentColor = litSegments == 3
        ? ContraTheme.green
        : litSegments == 2
            ? ContraTheme.yellow
            : ContraTheme.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Container(
                width: 10,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: i < litSegments ? segmentColor : ContraTheme.bg,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: i < litSegments
                      ? [
                          BoxShadow(
                            color: segmentColor.withValues(alpha: 0.6),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              ),
          ],
        ),
        const SizedBox(width: 2),
        Container(
          width: 4,
          height: 8,
          decoration: BoxDecoration(
            color: ContraTheme.muted,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(2)),
          ),
        ),
      ],
    );
  }
}

class SystemBottomBar extends StatefulWidget {
  final VoidCallback onHome;
  final VoidCallback onBack;
  const SystemBottomBar({super.key, required this.onHome, required this.onBack});

  @override
  State<SystemBottomBar> createState() => _SystemBottomBarState();
}

class _SystemBottomBarState extends State<SystemBottomBar> {
  int _homePressCount = 0;
  DateTime _lastHomePress = DateTime.fromMillisecondsSinceEpoch(0);
  static const _windowMs = 5000;
  static const _exitCount = 7;

  void _onHomeTap() {
    final now = DateTime.now();
    if (now.difference(_lastHomePress).inMilliseconds > _windowMs) {
      _homePressCount = 0;
    }
    _lastHomePress = now;
    _homePressCount++;

    if (_homePressCount >= _exitCount) {
      HapticFeedback.heavyImpact();
      PhoneServices.exitLauncher();
      return;
    }
    widget.onHome();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavButton(
            icon: Icons.home_rounded,
            label: 'Home',
            onTap: _onHomeTap,
          ),
          _NavButton(
            icon: Icons.arrow_back_rounded,
            label: 'Back',
            onTap: widget.onBack,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: ContraTheme.ink),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ContraTheme.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}