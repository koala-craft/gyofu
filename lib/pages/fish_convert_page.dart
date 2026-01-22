import 'package:flutter/material.dart';
import 'package:gyofu/data/fish_repository.dart';

class FishConvertPage extends StatefulWidget {
  const FishConvertPage({super.key});

  @override
  State<FishConvertPage> createState() => _FishConvertPageState();
}

class _FishConvertPageState extends State<FishConvertPage> {
  final TextEditingController _controller = TextEditingController();

  String _inputText = ''; //入力文字列
  String _result = ''; //変換結果
  bool _loading = false; //ローディング画面

  final repo = FishRepository();

  void _convertFishName() {
    final input = _controller.text.trim();

    setState(() {
      _result = repo.convert(input);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Scaffoldを抜いて「中身だけ」を返す
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// 入力カード
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '魚の名前を入力',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: '例：ハマチ → ブリ',
                    filled: true,
                    fillColor: const Color(0xFFF2F4F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1E88E5),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _inputText = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                /// 変換ボタン
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _inputText.isEmpty ? null : _convertFishName,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5), // 海系ブルー
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      animationDuration: const Duration(milliseconds: 100),
                      elevation: 0,
                    ),
                    child: const Text(
                      '変換する',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// 結果カード
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _result.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    key: ValueKey(_result),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '正式名称',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _result,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _result == '該当する魚が見つかりません'
                                ? Colors.redAccent
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
