// ui/yao_item.dart
import 'package:flutter/material.dart';

// 新增：爻的符号常量，统一管理
class YaoSymbols {
  static const String yang = "—————"; // 阳爻符号─
  static const String yin = "——     ——"; // 阴爻符号╌
}

class YaoItem extends StatefulWidget {
  final int yaoValue; // 0=阴，1=阳
  final int yaoIndex; // 爻位
  final bool isHighlight; // 是否高亮（纯红）
  final bool isSelectedGua; // 是否为选中卦的爻
  final Function(int) onYaoHover; // 爻悬停回调
  final Function() onYaoExit; // 爻离开回调

  // 新增：爻的字体大小参数，方便外部控制
  final double fontSize;

  const YaoItem({
    super.key,
    required this.yaoValue,
    required this.yaoIndex,
    required this.isHighlight,
    required this.isSelectedGua,
    required this.onYaoHover,
    required this.onYaoExit,
    this.fontSize = 20, // 默认放大到20号字体
  });

  @override
  State<YaoItem> createState() => _YaoItemState();
}

class _YaoItemState extends State<YaoItem> {
  bool _isYaoHover = false;

  @override
  Widget build(BuildContext context) {
    // 1. 确定爻的符号和高亮颜色（保留原有逻辑）
    final String yaoSymbol = widget.yaoValue == 1
        ? YaoSymbols.yang
        : YaoSymbols.yin;
    final Color textColor = (widget.isHighlight || _isYaoHover)
        ? Colors.red
        : Colors.black87;

    // 2. 构建爻的文本组件（移除固定fontSize，改用FittedBox缩放）
    final yaoText = Text(
      yaoSymbol,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w900,
        letterSpacing: -1,
        height: 0.9, // 保留行高优化，压缩文本自身高度
      ),
      textAlign: TextAlign.center,
      softWrap: false,
      overflow: TextOverflow.clip,
    );

    return MouseRegion(
      // 保留原有交互逻辑
      onEnter: (_) {
        if (widget.isSelectedGua) {
          setState(() => _isYaoHover = true);
          widget.onYaoHover(widget.yaoIndex);
        }
      },
      onExit: (_) {
        if (widget.isSelectedGua) {
          setState(() => _isYaoHover = false);
          widget.onYaoExit();
        }
      },
      // 核心修改：移除固定height，用FittedBox让文本适配容器
      child: Container(
        alignment: Alignment.center,
        // 移除固定height：height: widget.fontSize * 1.2,
        // 可选：添加内边距，让爻与卦框有间距
        padding: const EdgeInsets.symmetric(vertical: 2),
        // 用FittedBox包裹文本，实现自适应缩放
        child: FittedBox(
          fit: BoxFit.contain, // 按容器大小等比缩放，不溢出
          child: yaoText,
        ),
      ),
    );
  }
}
