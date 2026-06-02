import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    this.totalCount,
    this.avatarSize = 24.0,
    this.overlap = 10.0,
  });

  final int? totalCount;
  final double avatarSize;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final visibleCount = totalCount?.clamp(0, 4) ?? 0;
    final extra = (totalCount ?? 0) - visibleCount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (visibleCount > 0)
          SizedBox(
            // ✅ garante width nunca negativo
            width:
                avatarSize +
                (visibleCount - 1) *
                    (avatarSize - overlap).clamp(0, double.infinity),
            height: avatarSize,
            child: Stack(
              children: List.generate(visibleCount, (i) {
                final colors = [
                  const Color(0xFF7F77DD),
                  const Color(0xFFD4537E),
                  const Color(0xFF1D9E75),
                  const Color(0xFFD85A30),
                ];
                return Positioned(
                  left: i * (avatarSize - overlap),
                  child: _Avatar(
                    size: avatarSize,
                    bgColor: colors[i % colors.length],
                    fgColor: colors[i % colors.length],
                    zIndex: visibleCount - i,
                  ),
                );
              }),
            ),
          ),
        if (extra > 0) ...[
          const SizedBox(width: 6),
          Flexible(
            // ✅ texto encolhe se necessário
            child: Text(
              '+$extra', // ✅ texto mais curto, sem "participantes"
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.70),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.size,
    required this.bgColor,
    required this.fgColor,
    required this.zIndex,
  });

  final double size;
  final Color bgColor;
  final Color fgColor;
  final int zIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '',
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w500,
            color: fgColor,
          ),
        ),
      ),
    );
  }
}
