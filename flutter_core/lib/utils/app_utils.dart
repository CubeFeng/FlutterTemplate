import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
// import 'package:keyboard_actions/keyboard_actions_config.dart';

class AppUtils {
  static KeyboardActionsConfig getKeyboardActionsConfig(BuildContext context, List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardBarColor: const Color(0xFFF7F7F7),
      nextFocus: true,
      actions: List.generate(
          list.length,
          (i) => KeyboardActionsItem(
                focusNode: list[i],
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: () => node.unfocus(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.close),
                      ),
                    );
                  },
                ],
              )),
    );
  }

  static void hideKeyboard() {
    /// 关闭软键盘四种方式
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    // FocusScope.of(context).requestFocus(FocusNode());
    // FocusScope.of(context).unfocus();
    // _focusNode.unfocus();
    // FocusManager.instance.primaryFocus?.unfocus();
  }
}
