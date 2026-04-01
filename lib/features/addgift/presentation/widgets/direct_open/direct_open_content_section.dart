import 'package:flutter/material.dart';

import '../../../application/direct_open_setting/direct_open_setting_bloc.dart';
import 'after_open_card.dart';
import 'before_open_card.dart';

class DirectOpenContentSection extends StatelessWidget {
  const DirectOpenContentSection({
    super.key,
    required this.isMobile,
    required this.state,
    required this.beforeDescController,
    required this.afterNameController,
    required this.onPickBeforeImage,
    required this.onPickAfterImage,
  });

  final bool isMobile;
  final DirectOpenSettingState state;
  final TextEditingController beforeDescController;
  final TextEditingController afterNameController;
  final VoidCallback onPickBeforeImage;
  final VoidCallback onPickAfterImage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isMobile) ...<Widget>[
            BeforeOpenCard(
              isMobile: isMobile,
              imageFile: state.beforeImageFile,
              descController: beforeDescController,
              onPickImage: onPickBeforeImage,
            ),
            const SizedBox(height: 24),
            AfterOpenCard(
              isMobile: isMobile,
              imageFile: state.afterImageFile,
              nameController: afterNameController,
              onPickImage: onPickAfterImage,
            ),
          ] else ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: BeforeOpenCard(
                    isMobile: isMobile,
                    imageFile: state.beforeImageFile,
                    descController: beforeDescController,
                    onPickImage: onPickBeforeImage,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: AfterOpenCard(
                    isMobile: isMobile,
                    imageFile: state.afterImageFile,
                    nameController: afterNameController,
                    onPickImage: onPickAfterImage,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
