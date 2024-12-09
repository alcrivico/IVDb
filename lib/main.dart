import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/theme/app_theme.dart';
import 'package:ivdb/presentation/screens/login/login_view.dart';
import 'package:window_size/window_size.dart' as window_size;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowSize();
  }
  runApp(ProviderScope(child: MyApp()));
}

void setWindowSize() {
  const minSize = Size(400, 800);
  const maxSize = Size(2560, 1440);
  window_size.setWindowMinSize(minSize);
  window_size.setWindowMaxSize(maxSize);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().theme(),
        home: const LoginView());
  }
}
