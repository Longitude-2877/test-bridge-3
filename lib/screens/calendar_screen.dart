import 'package:flutter/material.dart';
import '../theme/contra_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = DateTime.now();

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  void _changeMonth(int delta) {
    setState(() {
      _focused = DateTime(_focused.year, _focused.month + delta, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(_focused.year, _focused.month, 1);
    final daysInMonth = DateTime(_focused.year, _focused.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday - 1;

    final todayIsThisMonth =
        now.year == _focused.year && now.month == _focused.month;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          Row(
            children: [
              _NavIconButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _changeMonth(-1),
              ),
              Expanded(
                child: Text(
                  '${_focused.year} · ${_monthName(_focused.month)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: ContraTheme.ink,
                  ),
                ),
              ),
              _NavIconButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _changeMonth(1),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              for (final d in _weekdays)
                Expanded(
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ContraTheme.muted,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < leadingBlanks; i++) const SizedBox(),
                for (var day = 1; day <= daysInMonth; day++)
                  _DayCell(
                    day: day,
                    isToday: todayIsThisMonth && day == now.day,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[m - 1];
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  const _DayCell({required this.day, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isToday ? ContraTheme.teal : ContraTheme.card,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isToday ? Colors.transparent : const Color(0x14000000),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: isToday ? Colors.white : ContraTheme.ink,
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ContraTheme.card,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: ContraTheme.ink, size: 28),
        ),
      ),
    );
  }
}