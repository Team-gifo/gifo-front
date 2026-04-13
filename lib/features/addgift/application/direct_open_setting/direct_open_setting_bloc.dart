import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/gallery_item.dart';
import '../../model/gift_content.dart';
import '../../model/unboxing_content.dart';
import '../gift_packaging_bloc.dart';

part 'direct_open_setting_event.dart';
part 'direct_open_setting_state.dart';

class DirectOpenSettingBloc
    extends Bloc<DirectOpenSettingEvent, DirectOpenSettingState> {
  final GiftPackagingBloc _packagingBloc;

  DirectOpenSettingBloc(this._packagingBloc)
      : super(DirectOpenSettingState()) {
    on<InitDirectOpenSetting>(_onInit);
    on<UpdateBeforeImage>(_onUpdateBeforeImage);
    on<UpdateBeforeDescription>(_onUpdateBeforeDescription);
    on<UpdateAfterImage>(_onUpdateAfterImage);
    on<UpdateAfterItemName>(_onUpdateAfterItemName);
    on<UpdateDirectOpenBgm>(_onUpdateBgm);
    on<SubmitDirectOpenSetting>(_onSubmit);
  }

  void _pushToPackagingBloc(DirectOpenSettingState s) {
    _packagingBloc.add(
      SetUnboxingContent(
        UnboxingContent(
          beforeOpen: BeforeOpen(
            imageUrl: s.beforeImageFile?.path ?? '',
            description: s.beforeDescription,
          ),
          afterOpen: AfterOpen(
            itemName: s.afterItemName,
            imageUrl: s.afterImageFile?.path ?? '',
          ),
        ),
      ),
    );
  }

  void _onInit(
    InitDirectOpenSetting event,
    Emitter<DirectOpenSettingState> emit,
  ) {
    emit(state.copyWith(
      selectedBgm: event.initialBgm,
      beforeImageFile: event.beforeImageFile ?? state.beforeImageFile,
      beforeDescription: event.beforeDescription ?? state.beforeDescription,
      afterImageFile: event.afterImageFile ?? state.afterImageFile,
      afterItemName: event.afterItemName ?? state.afterItemName,
    ));
  }

  void _onUpdateBeforeImage(
    UpdateBeforeImage event,
    Emitter<DirectOpenSettingState> emit,
  ) {
    final DirectOpenSettingState next =
        state.copyWith(beforeImageFile: event.image);
    emit(next);
    _pushToPackagingBloc(next);
  }

  void _onUpdateBeforeDescription(
    UpdateBeforeDescription event,
    Emitter<DirectOpenSettingState> emit,
  ) {
    final DirectOpenSettingState next =
        state.copyWith(beforeDescription: event.description);
    emit(next);
    _pushToPackagingBloc(next);
  }

  void _onUpdateAfterImage(
    UpdateAfterImage event,
    Emitter<DirectOpenSettingState> emit,
  ) {
    final DirectOpenSettingState next =
        state.copyWith(afterImageFile: event.image);
    emit(next);
    _pushToPackagingBloc(next);
  }

  void _onUpdateAfterItemName(
    UpdateAfterItemName event,
    Emitter<DirectOpenSettingState> emit,
  ) {
    final DirectOpenSettingState next =
        state.copyWith(afterItemName: event.itemName);
    emit(next);
    _pushToPackagingBloc(next);
  }

  void _onUpdateBgm(
    UpdateDirectOpenBgm event,
    Emitter<DirectOpenSettingState> emit,
  ) {
    emit(state.copyWith(selectedBgm: event.bgm));
  }

  void _onSubmit(
    SubmitDirectOpenSetting event,
    Emitter<DirectOpenSettingState> emit,
  ) {
    final UnboxingContent unboxing = UnboxingContent(
      beforeOpen: BeforeOpen(
        imageUrl: state.beforeImageFile?.path ?? '',
        description: state.beforeDescription,
      ),
      afterOpen: AfterOpen(
        itemName: state.afterItemName,
        imageUrl: state.afterImageFile?.path ?? '',
      ),
    );
    _packagingBloc.add(SetUnboxingContent(unboxing));
    _packagingBloc.add(
      SubmitPackage(
        receiverName: event.receiverName,
        subTitle: event.subTitle,
        bgm: state.selectedBgm,
        gallery: event.gallery,
        content: GiftContent(unboxing: unboxing),
      ),
    );
  }
}
