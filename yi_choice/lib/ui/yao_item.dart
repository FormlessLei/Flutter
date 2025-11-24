import 'package:flutter/material.dart';

class YaoItem extends StatelessWidget {
  final bool isYang; // 是否阳爻（1=阳，0=阴）
  final int index; // 爻索引（0=初爻，5=上爻）
  final bool isHovered; // 是否被悬停
  final VoidCallback onHover; // 悬停回调
  final VoidCallback onExit; // 离开悬停回调

  const YaoItem({
    super.key,
    required this.isYang,
    required this.index,
    this.isHovered = false,
    required this.onHover,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(),
      onExit: (_) => onExit(),
      child: Container(
        width: 25, // 进一步缩小宽度，让爻更纤细
        height: 12, // 缩小高度
        margin: const EdgeInsets.symmetric(vertical: 0.5), // 极小的垂直间距
        decoration: BoxDecoration(
          // 可选：去掉背景/边框，让爻更简洁，只保留文字
          // color: isHovered ? Colors.grey[200] : Colors.transparent,
          // border: Border.all(color: Colors.black12, width: 0.5),
          borderRadius: BorderRadius.circular(2), // 小圆角，更柔和
        ),
        child: Center(
          child: Text(
            // 优化阴爻的显示：用两个短横+空格分隔，更纤细
            isYang ? "—" : "- -",
            style: TextStyle(
              fontSize: 10, // 缩小字号，减少粗度
              fontWeight: FontWeight.w300, // 字重设为细体（w100-w500可选）
              color: Colors.black87, // 稍微降低黑色浓度，更柔和
              letterSpacing: isYang ? 0 : 1, // 阴爻的两个短横间距调大一点
            ),
          ),
        ),
      ),
    );
  }
}
