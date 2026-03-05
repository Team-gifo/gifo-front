import 'package:get_it/get_it.dart';

import '../../features/addgift/application/gift_packaging_bloc.dart';

final GetIt getIt = GetIt.instance;

// 앱 시작 시 호출하여 의존성을 등록
void setupServiceLocator() {
  // GiftPackagingBloc을 싱글톤으로 등록
  // 앱 전역에서 동일한 인스턴스를 공유하여 선물 포장 진행 상태를 유지
  getIt.registerLazySingleton<GiftPackagingBloc>(() => GiftPackagingBloc());
}
