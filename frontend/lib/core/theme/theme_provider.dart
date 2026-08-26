import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider =
StateProvider<ThemeMode>((ref) => ThemeMode.dark);

final notificationsProvider =
StateProvider<bool>((ref) => true);

final languageProvider =
StateProvider<String>((ref) => 'English');