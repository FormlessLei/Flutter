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
      onEnter: (_) => onHover(), // 鼠标进入时触发
      onExit: (_) => onExit(),   // 鼠标离开时触发
      child: Container(
        width: 40, // 爻宽度
        height: 20, // 爻高度
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isHovered ? Colors.yellow[200] : Colors.transparent,
          border: Border.all(
            color: isYang ? Colors.black87 : Colors.grey,
            width: 2,
          ),
          // 阳爻中间加横线，阴爻中间加空格（样式可自定义）
        ),
        child: Center(
          child: Text(
            isYang ? "—" : "--", // 阳爻/阴爻符号
            style: TextStyle(
              fontSize: 16,
              fontWeight: isYang ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}