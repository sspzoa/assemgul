import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import '../../provider/api.dart';
import '../../provider/api_interface.dart';

class AppLoader {
  Future<void> load() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    setPathUrlStrategy();

    await dotenv.load(fileName: "env/.env");

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Supabase URL or Anon Key not found in .env file');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    Get.put<ApiProvider>(ProdApiProvider());

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await FlutterDisplayMode.setHighRefreshRate();
      }
    }

    FlutterNativeSplash.remove();
  }
}