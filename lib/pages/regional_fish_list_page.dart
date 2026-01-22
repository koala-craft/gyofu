import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyofu/data/regional_fish_mock.dart';

class RegionalFishListPage extends StatelessWidget {
  const RegionalFishListPage({super.key});

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
        child: Stack(
          children: [
            Column(
              children: [
                // ヘッダー
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: size.height * 0.04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '地域の魚情報',
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
                        '登録されている地域の魚名一覧',
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

                // リスト
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: 8,
                    ),
                    itemCount: regionalFishMock.length,
                    itemBuilder: (context, index) {
                      final fish = regionalFishMock[index];
                      return _FishListItem(
                        fish: fish,
                        isDark: isDark,
                        onTap: () {
                          context.push('/regional-fish-detail/${fish.id}');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // 追加ボタン（右下）
            Positioned(
              right: size.width * 0.06,
              bottom: size.height * 0.04,
              child: FloatingActionButton(
                onPressed: () {
                  context.push('/regional-fish-edit');
                },
                backgroundColor: const Color(0xFF3B82F6),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FishListItem extends StatelessWidget {
  final RegionalFish fish;
  final bool isDark;
  final VoidCallback onTap;

  const _FishListItem({
    required this.fish,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withOpacity(0.6)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
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
            child: Row(
              children: [
                // アイコン
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF3B82F6).withOpacity(0.2)
                        : const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.set_meal,
                    color: Color(0xFF3B82F6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // 情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fish.localName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '正式名称: ${fish.formalName}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${fish.prefecture} ${fish.city}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF94A3B8),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // 矢印アイコン
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
