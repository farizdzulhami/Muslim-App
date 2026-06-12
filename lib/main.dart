import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repository/shalat_repository.dart';
import 'repository/quran_repository.dart';
import 'viewmodel/shalat_view_model.dart';
import 'viewmodel/quran_view_model.dart';
import 'view/shalat_page.dart';

import 'view/main_navigation.dart';
import 'view/login_page.dart';

import 'repository/extra_repository.dart';
import 'viewmodel/extra_view_model.dart';
import 'viewmodel/profile_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ShalatRepository>(
          create: (_) => ShalatRepository(),
        ),
        Provider<QuranRepository>(
          create: (_) => QuranRepository(),
        ),
        Provider<ExtraRepository>(
          create: (_) => ExtraRepository(),
        ),
        ChangeNotifierProvider<ShalatViewModel>(
          create: (context) =>
              ShalatViewModel(context.read<ShalatRepository>()),
        ),
        ChangeNotifierProvider<QuranViewModel>(
          create: (context) =>
              QuranViewModel(context.read<QuranRepository>()),
        ),
        ChangeNotifierProvider<ExtraViewModel>(
          create: (context) =>
              ExtraViewModel(context.read<ExtraRepository>()),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final profileViewModel = context.watch<ProfileViewModel>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Muslim App',
            themeMode: profileViewModel.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color(0xFF1565C0),
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color(0xFF1565C0),
              brightness: Brightness.dark,
            ),
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}