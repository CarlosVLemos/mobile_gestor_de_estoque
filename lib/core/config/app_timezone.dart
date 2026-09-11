import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AppTimeZoneResolver = String? Function();

final appTimeZoneResolverProvider = Provider<AppTimeZoneResolver>((ref) {
  return () {
    const raw = String.fromEnvironment('APP_TIMEZONE');
    final value = raw.trim();
    return _ianaPattern.hasMatch(value) ? value : null;
  };
});

final _ianaPattern = RegExp(
  r'^[A-Za-z]+(?:[_-][A-Za-z]+)*/[A-Za-z]+(?:[_-][A-Za-z]+)*(?:/[A-Za-z]+(?:[_-][A-Za-z]+)*)?$',
);
