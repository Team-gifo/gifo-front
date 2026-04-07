part of 'gacha_setting_bloc.dart';

// GachaSettingView에서 사용하는 UI 전용 아이템 모델
// 실제 데이터는 GiftPackagingBloc에 저장되지만, View 렌더링(이미지 파일, 색상, 선택 상태 등)
// 에 필요한 일시적인 정보를 별도로 관리합니다.
class DefaultGachaItemData extends Equatable {
  final int id;
  final Color color;
  final XFile? imageFile;
  final String itemName;
  final String percentStr;
  final bool percentOpen;

  const DefaultGachaItemData({
    required this.id,
    required this.color,
    this.imageFile,
    this.itemName = '',
    this.percentStr = '0.0',
    this.percentOpen = true,
  });

  double get percent => double.tryParse(percentStr) ?? 0.0;

  DefaultGachaItemData copyWith({
    Color? color,
    XFile? imageFile,
    String? itemName,
    String? percentStr,
    bool? percentOpen,
  }) {
    return DefaultGachaItemData(
      id: id,
      color: color ?? this.color,
      imageFile: imageFile ?? this.imageFile,
      itemName: itemName ?? this.itemName,
      percentStr: percentStr ?? this.percentStr,
      percentOpen: percentOpen ?? this.percentOpen,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    color,
    imageFile,
    itemName,
    percentStr,
    percentOpen,
  ];
}

// GachaSettingBloc의 로컬 상태
// 실제 캡슐 데이터는 GiftPackagingBloc이 보유하며, 이 State는
// View 렌더링에 필요한 UI 전용 정보(이미지, 색상 등)와 BGM, 다음 ID 등만 관리합니다.
class GachaSettingState extends Equatable {
  // View 렌더링용 UI 데이터 (이미지 파일, 색상 포함)
  final List<DefaultGachaItemData> uiItems;
  // 다음 캡슐 아이템 ID 카운터
  final int nextId;
  // 선택된 BGM
  final String selectedBgm;

  const GachaSettingState({
    this.uiItems = const <DefaultGachaItemData>[],
    this.nextId = 1,
    this.selectedBgm = '',
  });

  GachaSettingState copyWith({
    List<DefaultGachaItemData>? uiItems,
    int? nextId,
    String? selectedBgm,
  }) {
    return GachaSettingState(
      uiItems: uiItems ?? this.uiItems,
      nextId: nextId ?? this.nextId,
      selectedBgm: selectedBgm ?? this.selectedBgm,
    );
  }

  @override
  List<Object?> get props => <Object?>[uiItems, nextId, selectedBgm];
}
