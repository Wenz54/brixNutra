import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Импортируйте тему из core_module:
// import 'package:supply_diets_app/dev_modules/core_module/theme/app_theme.dart';

/// Типы инпутов Supply Diets
enum SupplyInputType {
  text,
  email,
  password,
  number,
  phone,
}

/// Переиспользуемое текстовое поле Supply Diets
/// 
/// Поддерживает типы: text, email, password, number, phone
/// Имеет валидацию, иконки, helper text
class SupplyInput extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final SupplyInputType type;
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

  const SupplyInput({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.helperText,
    this.controller,
    this.type = SupplyInputType.text,
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
  State<SupplyInput> createState() => _SupplyInputState();
}

class _SupplyInputState extends State<SupplyInput> {
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
      case SupplyInputType.email:
        return TextInputType.emailAddress;
      case SupplyInputType.number:
        return TextInputType.number;
      case SupplyInputType.phone:
        return TextInputType.phone;
      case SupplyInputType.password:
      case SupplyInputType.text:
        return TextInputType.text;
    }
  }

  bool get _obscureText {
    return widget.type == SupplyInputType.password && !_isPasswordVisible;
  }

  Widget? get _suffixIcon {
    const textTertiaryColor = Color(0xFF9E9E9E);
    
    if (widget.type == SupplyInputType.password) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          color: textTertiaryColor,
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
          color: textTertiaryColor,
          size: 20,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    return null;
  }

  Widget? get _prefixIcon {
    const textTertiaryColor = Color(0xFF9E9E9E);
    
    if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        color: textTertiaryColor,
        size: 20,
      );
    }
    return null;
  }

  Color get _borderColor {
    const errorColor = Color(0xFFE57373);
    const primaryColor = Color(0xFFD9E74C);
    const borderLightColor = Color(0xFFE0E0E0);
    
    if (widget.errorText != null) {
      return errorColor;
    }
    if (_isFocused) {
      return primaryColor;
    }
    return borderLightColor;
  }

  @override
  Widget build(BuildContext context) {
    const textLabelColor = Color(0xFF666666);
    const errorColor = Color(0xFFE57373);
    const textTertiaryColor = Color(0xFF9E9E9E);
    const bgInputColor = Color(0xFFF8F8F8);
    const borderLightColor = Color(0xFFE0E0E0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textLabelColor,
                fontFamily: 'Urbanist',
              ),
              children: [
                if (widget.isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: errorColor,
                      fontFamily: 'Urbanist',
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Urbanist',
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: _prefixIcon,
            suffixIcon: _suffixIcon,
            filled: true,
            fillColor: widget.isEnabled ? bgInputColor : borderLightColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _borderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: borderLightColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            counterText: '', // Убираем счетчик символов
          ),
        ),

        // Error or Helper Text
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText ?? widget.helperText!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: widget.errorText != null ? errorColor : textTertiaryColor,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ],
    );
  }
}





