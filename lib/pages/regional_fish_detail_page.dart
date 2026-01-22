import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyofu/data/regional_fish_mock.dart';

class RegionalFishDetailPage extends StatelessWidget {
  final String fishId;

  const RegionalFishDetailPage({
    super.key,
    required this.fishId,
  });

  RegionalFish? _getFishById(String id) {
    try {
      return regionalFishMock.firstWhere((fish) => fish.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fish = _getFishById(fishId);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (fish == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('エラー'),
        ),
        body: const Center(
          child: Text('魚の情報が見つかりません'),
        ),
      );
    }

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
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '魚の詳細情報',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 詳細カード
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
                    // アイコンとタイトル
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF3B82F6).withOpacity(0.2)
                                : const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.set_meal,
                            color: Color(0xFF3B82F6),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fish.localName,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '正式名称: ${fish.formalName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 地域情報
                    _DetailItem(
                      icon: Icons.location_on_rounded,
                      label: '県名',
                      value: fish.prefecture,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _DetailItem(
                      icon: Icons.location_city_rounded,
                      label: '市区町村名',
                      value: fish.city,
                      isDark: isDark,
                    ),
                    if (fish.port != null) ...[
                      const SizedBox(height: 16),
                      _DetailItem(
                        icon: Icons.anchor_rounded,
                        label: '漁港名',
                        value: fish.port!,
                        isDark: isDark,
                      ),
                    ],
                    if (fish.notes != null && fish.notes!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.note_rounded,
                                  size: 18,
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '備考',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fish.notes!,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? Colors.white70 : const Color(0xFF64748B),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
