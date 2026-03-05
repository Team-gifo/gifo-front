import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'features/addgift/application/gift_packaging_bloc.dart';

void main() {
  usePathUrlStrategy();

  // get_it 의존성 초기화
  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GiftPackagingBloc>(
      // get_it에서 싱글톤 인스턴스를 가져와 BlocProvider에 주입
      create: (_) => getIt<GiftPackagingBloc>(),
      child: MaterialApp.router(
        title: 'Gifo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'PFStardust',
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            surface: Colors.white,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
