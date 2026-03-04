import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';

/// A widget that displays a row of 6 text fields for OTP entry.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    required this.onCodeChanged,
    required this.onCodeSubmitted,
    this.length = 6,
    super.key,
  });

  /// Callback when the code changes.
  final ValueChanged<String> onCodeChanged;

  /// Callback when the code is fully entered or submitted.
  final ValueChanged<String> onCodeSubmitted;

  /// Length of the OTP code.
  final int length;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    // Listen to focus changes to select all text when focused
    for (var i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }

    // Auto focus the first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // Check for paste (length > 1)
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    // Handle single char input
    if (value.isNotEmpty) {
      // Move to next field if not the last one
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field filled, unfocus and submit
        _focusNodes[index].unfocus();
        _notifyCodeSubmitted();
      }
    }

    _notifyCodeChanged();
  }

  void _handlePaste(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.isEmpty) return;

    final chars = cleanValue.split('');
    final limit = chars.length < widget.length ? chars.length : widget.length;

    for (var i = 0; i < limit; i++) {
        _controllers[i].text = chars[i];
    }
    
    // Focus logic after paste
    if (limit < widget.length) {
      _focusNodes[limit].requestFocus();
    } else {
      _focusNodes.last.unfocus();
      _notifyCodeSubmitted();
    }
    
    _notifyCodeChanged();
  }

  void _notifyCodeChanged() {
    final code = _controllers.map((c) => c.text).join();
    widget.onCodeChanged(code);
    if (code.length == widget.length) {
       _notifyCodeSubmitted();
    }
  }

  void _notifyCodeSubmitted() {
     final code = _controllers.map((c) => c.text).join();
     if (code.length == widget.length) {
       widget.onCodeSubmitted(code);
     }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: KeyboardListener(
              focusNode: FocusNode(debugLabel: "KeyHandler"), 
              // We use a focus node here just for valid focus scope, but actually 
              // we attach to the inner TextField via its focusNode.
              // So KeyboardListener wrapping TextField should use the SAME focusNode? NO.
              // KeyboardListener needs its own focusNode if it's meant to own focus, OR
              // if we wrap TextField, we rely on TextField's focus.
              
              // Actually KeyboardListener invokes onKeyEvent when its child has focus.
              // So we pass the same focus node? No, focus node can only be attached to one widget.
              // But KeyboardListener is a widget that listens to keys.
              // The typical way for "Backspace on empty" is to use `CallbackShortcuts` or `Shortcuts`.
              // BUT `KeyboardListener` works if valid focus is inside.
              
              autofocus: false,
              onKeyEvent: (event) {
                 if (event is KeyDownEvent) {
                   if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      if (_controllers[index].text.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                   }
                 }
              },
              child: _buildSingleDigitField(index, context),
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildSingleDigitField(int index, BuildContext context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

     return TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6), // Allow paste of long string
        ],
        textAlign: TextAlign.center,
        style: AppTypography.h3(), // Big digits
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(AppRadius.md),
             borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
           focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(AppRadius.md),
             borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
        onChanged: (value) => _onChanged(value, index),
        textInputAction: index == widget.length - 1 ? TextInputAction.done : TextInputAction.next,
        onSubmitted: (_) {
           if (index == widget.length - 1) {
              _notifyCodeSubmitted();
           }
        },
     );
  }
}
