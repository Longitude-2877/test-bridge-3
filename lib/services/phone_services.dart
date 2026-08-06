import 'package:flutter/services.dart';

class Contact {
  final String name;
  final String number;
  Contact({required this.name, required this.number});
}

class PhoneServices {
  static const _channel = MethodChannel('elders/phone');

  static Future<String?> placeCall(String number) async {
    try {
      return await _channel.invokeMethod<String>('placeCall', number);
    } catch (e) {
      return 'Failed: $e';
    }
  }

  static Future<List<Contact>> getContacts() async {
    final raw =
        await _channel.invokeListMethod<Map<dynamic, dynamic>>('getContacts');
    if (raw == null) return [];
    return raw
        .map((e) => Contact(
              name: (e['name'] as String?) ?? '',
              number: (e['number'] as String?) ?? '',
            ))
        .where((c) => c.number.isNotEmpty)
        .toList();
  }

  static Future<String?> addContact(String name, String number) async {
    try {
      await _channel.invokeMethod<void>(
        'addContact',
        {'name': name, 'number': number},
      );
      return null;
    } catch (e) {
      return 'Failed: $e';
    }
  }

  static Future<void> exitLauncher() async {
    await _channel.invokeMethod<void>('exitLauncher');
  }
}
