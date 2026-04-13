part of 'direct_open_setting_bloc.dart';

class DirectOpenSettingState {
  final XFile? beforeImageFile;
  final String beforeDescription;
  final XFile? afterImageFile;
  final String afterItemName;
  final String selectedBgm;

  DirectOpenSettingState({
    this.beforeImageFile,
    this.beforeDescription = '내가 준비한 선물이 과연 무엇일까?',
    this.afterImageFile,
    this.afterItemName = '',
    this.selectedBgm = '',
  });

  DirectOpenSettingState copyWith({
    XFile? beforeImageFile,
    String? beforeDescription,
    XFile? afterImageFile,
    String? afterItemName,
    String? selectedBgm,
  }) {
    return DirectOpenSettingState(
      beforeImageFile: beforeImageFile ?? this.beforeImageFile,
      beforeDescription: beforeDescription ?? this.beforeDescription,
      afterImageFile: afterImageFile ?? this.afterImageFile,
      afterItemName: afterItemName ?? this.afterItemName,
      selectedBgm: selectedBgm ?? this.selectedBgm,
    );
  }
}
