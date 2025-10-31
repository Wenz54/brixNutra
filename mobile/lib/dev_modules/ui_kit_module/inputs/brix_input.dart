import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/brix_theme.dart';

/// Типы инпутов Brix
enum BrixInputType {
  text,
  email,
  password,
  number,
  phone,
}

/// Переиспользуемое текстовое поле Brix Nutrition
/// 
/// Поддерживает типы: text, email, password, number, phone
/// Имеет валидацию, иконки, helper text
class BrixInput extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final BrixInputType type;
  final bool isRequired;
  final bool isEnabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autofocus;

  const BrixInput({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.helperText,
    this.controller,
    this.type = BrixInputType.text,
    this.isRequired = false,
    this.isEnabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<BrixInput> createState() => _BrixInputState();
}

class _BrixInputState extends State<BrixInput> {
  bool _isPasswordVisible = false;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  TextInputType get _keyboardType {
    switch (widget.type) {
      case BrixInputType.email:
        return TextInputType.emailAddress;
      case BrixInputType.number:
        return TextInputType.number;
      case BrixInputType.phone:
        return TextInputType.phone;
      case BrixInputType.password:
      case BrixInputType.text:
        return TextInputType.text;
    }
  }

  bool get _obscureText {
    return widget.type == BrixInputType.password && !_isPasswordVisible;
  }

  Widget? get _suffixIcon {
    if (widget.type == BrixInputType.password) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          color: BrixColors.textTertiary,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: BrixColors.textTertiary,
          size: 20,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    return null;
  }

  Widget? get _prefixIcon {
    if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        color: BrixColors.textTertiary,
        size: 20,
      );
    }
    return null;
  }

  Color get _borderColor {
    if (widget.errorText != null) {
      return BrixColors.error;
    }
    if (_isFocused) {
      return BrixColors.primary;
    }
    return BrixColors.border;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: BrixTypography.labelLarge,
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: BrixTypography.labelLarge.copyWith(
                      color: BrixColors.error,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: BrixSpacing.sm),
        ],

        // Input Field
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.isEnabled,
          autofocus: widget.autofocus,
          keyboardType: _keyboardType,
          obscureText: _obscureText,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          style: BrixTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: BrixTypography.bodyLarge.copyWith(
              color: BrixColors.textTertiary,
            ),
            prefixIcon: _prefixIcon,
            suffixIcon: _suffixIcon,
            filled: true,
            fillColor: widget.isEnabled ? BrixColors.surfaceDark : BrixColors.border,
            border: OutlineInputBorder(
              borderRadius: BrixSpacing.borderRadiusMD,
              borderSide: BorderSide(color: _borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BrixSpacing.borderRadiusMD,
              borderSide: BorderSide(color: _borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BrixSpacing.borderRadiusMD,
              borderSide: BorderSide(color: _borderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BrixSpacing.borderRadiusMD,
              borderSide: const BorderSide(color: BrixColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BrixSpacing.borderRadiusMD,
              borderSide: const BorderSide(color: BrixColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BrixSpacing.borderRadiusMD,
              borderSide: const BorderSide(color: BrixColors.border),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: BrixSpacing.lg,
              vertical: BrixSpacing.lg,
            ),
            counterText: '', // Убираем счетчик символов
          ),
        ),

        // Error or Helper Text
        if (widget.errorText != null || widget.helperText != null) ...[
          SizedBox(height: BrixSpacing.xs),
          Text(
            widget.errorText ?? widget.helperText!,
            style: BrixTypography.caption.copyWith(
              color: widget.errorText != null ? BrixColors.error : BrixColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}



