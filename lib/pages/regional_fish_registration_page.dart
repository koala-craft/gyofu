import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegionalFishRegistrationPage extends StatefulWidget {
  const RegionalFishRegistrationPage({super.key});

  @override
  State<RegionalFishRegistrationPage> createState() =>
      _RegionalFishRegistrationPageState();
}

class _RegionalFishRegistrationPageState
    extends State<RegionalFishRegistrationPage> {
  final TextEditingController _localNameController = TextEditingController();
  final TextEditingController _formalNameController = TextEditingController();
  final TextEditingController _prefectureController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isSubmitting = false;

  String? _safeGetText(TextEditingController? controller) {
    try {
      if (controller == null) return null;
      return controller.text.trim();
    } catch (e) {
      debugPrint('Error accessing controller text: $e');
      return null;
    }
  }

  bool _validateForm() {
    final localName = _safeGetText(_localNameController);
    final formalName = _safeGetText(_formalNameController);
    final prefecture = _safeGetText(_prefectureController);
    final city = _safeGetText(_cityController);

    return localName != null &&
        localName.isNotEmpty &&
        formalName != null &&
        formalName.isNotEmpty &&
        prefecture != null &&
        prefecture.isNotEmpty &&
        city != null &&
        city.isNotEmpty;
  }

  void _submitForm() {
    if (!mounted || !_validateForm()) return;

    setState(() {
      _isSubmitting = true;
    });

    // TODO: 実際の登録処理を実装
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('地域の魚名を登録しました'),
            backgroundColor: Color(0xFF3B82F6),
          ),
        );
        // フォームをクリア
        _localNameController.clear();
        _formalNameController.clear();
        _prefectureController.clear();
        _cityController.clear();
        _portController.clear();
        _notesController.clear();
      }
    });
  }

  @override
  void dispose() {
    _localNameController.dispose();
    _formalNameController.dispose();
    _prefectureController.dispose();
    _cityController.dispose();
    _portController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0A0E27),
                  const Color(0xFF1A1F3A),
                ]
              : [
                  const Color(0xFFF8FAFC),
                  const Color(0xFFF1F5F9),
                ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '地域の魚名登録',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '地域ごとの魚のローカル名と正式名称を登録します',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF64748B),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ×ボタン
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.06),

              // フォームカード
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B).withOpacity(0.6)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ],
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF3B82F6).withOpacity(0.2)
                                : const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '魚名情報を入力',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ローカル名（必須）
                    TextField(
                      controller: _localNameController,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        labelText: 'ローカル名 *',
                        hintText: '例：ハマチ',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF94A3B8),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // 正式名称（必須）
                    TextField(
                      controller: _formalNameController,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        labelText: '正式名称 *',
                        hintText: '例：ブリ',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF94A3B8),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // 県名（必須）
                    TextField(
                      controller: _prefectureController,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        labelText: '県名 *',
                        hintText: '例：福岡県',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF94A3B8),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // 市区町村名（必須）
                    TextField(
                      controller: _cityController,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        labelText: '市区町村名 *',
                        hintText: '例：福岡市',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF94A3B8),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // 漁港名（オプション）
                    TextField(
                      controller: _portController,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        labelText: '漁港名',
                        hintText: '例：博多港',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF94A3B8),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 備考（オプション）
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        labelText: '備考',
                        hintText: '追加情報やメモ',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF94A3B8),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 登録ボタン
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: _validateForm() && !_isSubmitting
                            ? LinearGradient(
                                colors: [
                                  const Color(0xFF3B82F6),
                                  const Color(0xFF2563EB),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: _validateForm() && !_isSubmitting
                            ? null
                            : (isDark
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _validateForm() && !_isSubmitting
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6)
                                      .withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _validateForm() && !_isSubmitting
                              ? _submitForm
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          splashColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.1),
                          child: Center(
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    '登録する',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                      color: _validateForm() && !_isSubmitting
                                          ? Colors.white
                                          : (isDark
                                              ? Colors.white38
                                              : const Color(0xFF94A3B8)),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
