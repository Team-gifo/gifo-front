part of 'gacha_setting_bloc.dart';

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
  List<Object?> get props => [
    id,
    color,
    imageFile,
    itemName,
    percentStr,
    percentOpen,
  ];
}

class GachaSettingState extends Equatable {
  final List<DefaultGachaItemData> items;
  final int nextId;
  final String playCountStr;
  final String selectedBgm;

  const GachaSettingState({
    this.items = const [],
    this.nextId = 1,
    this.playCountStr = '3',
    this.selectedBgm = '신나는 생일',
  });

  double get totalPercent {
    double total = 0.0;
    for (final DefaultGachaItemData item in items) {
      total += item.percent;
    }
    return total;
  }

  bool canComplete(String userName, String subTitle) {
    if (items.isEmpty) return false;
    if (userName.trim().isEmpty) return false;
    if (subTitle.trim().isEmpty) return false;

    final int? playCount = int.tryParse(playCountStr);
    if (playCount == null || playCount < 1) return false;

    for (final item in items) {
      final double? pct = double.tryParse(item.percentStr);
      if (item.itemName.trim().isEmpty) return false;
      if (pct == null || pct < 0.01 || pct > 100.0) return false;
    }

    final double totalPct = totalPercent;
    // 부동소수점 오차를 고려하여 99.99% ~ 100.01% 사이면 100%로 인정
    if (totalPct < 99.99 || totalPct > 100.01) return false;

    return true;
  }

  GachaSettingState copyWith({
    List<DefaultGachaItemData>? items,
    int? nextId,
    String? playCountStr,
    String? selectedBgm,
  }) {
    return GachaSettingState(
      items: items ?? this.items,
      nextId: nextId ?? this.nextId,
      playCountStr: playCountStr ?? this.playCountStr,
      selectedBgm: selectedBgm ?? this.selectedBgm,
    );
  }

  @override
  List<Object?> get props => [items, nextId, playCountStr, selectedBgm];
}
