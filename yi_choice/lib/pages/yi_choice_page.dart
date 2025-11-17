import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // 用于listEquals
import '../data/liushisi_gua.dart';
import '../models/gua_model.dart';
import '../ui/gua_matrix.dart';
import '../ui/gua_detail.dart';

class YiChoicePage extends StatefulWidget {
  const YiChoicePage({super.key});

  @override
  State<YiChoicePage> createState() => _YiChoicePageState();
}

class _YiChoicePageState extends State<YiChoicePage> {
  LiuShiSiGua? currentGua; // 当前选中卦
  LiuShiSiGua? hoveredGua; // 悬停变爻后的卦
  List<LiuShiSiGua> compareList = []; // 对比列表
  bool isComparing = false; // 是否在对比状态
  final int maxCompareCount = 6; // 最大对比数

  // 点击卦：切换当前卦或添加到对比列表
  void _onGuaTap(LiuShiSiGua gua) {
    setState(() {
      if (isComparing) {
        // 对比状态：添加/移除对比卦（最多6个）
        if (compareList.any((g) => listEquals(g.hexagrams, gua.hexagrams))) {
          compareList.removeWhere((g) => listEquals(g.hexagrams, gua.hexagrams));
        } else if (compareList.length < maxCompareCount) {
          compareList.add(gua);
        }
      } else {
        // 正常状态：切换当前卦
        currentGua = gua;
        hoveredGua = null; // 切换后清空悬停卦
      }
    });
  }

  // 悬停爻：计算变爻后的卦
  void _onYaoHover(int yaoIndex) {
    if (currentGua == null) return;
    // 复制当前卦六爻，翻转指定爻
    final newHexagrams = List.from(currentGua!.hexagrams);
    newHexagrams[yaoIndex] = 1 - newHexagrams[yaoIndex];
    // 查找变爻后的卦
    final newGua = liuShiSiGua.firstWhere(
      (g) => listEquals(g.hexagrams, newHexagrams),
      orElse: () => currentGua!,
    );
    setState(() => hoveredGua = newGua);
  }

  // 离开爻悬停：清空悬停卦
  void _onYaoExit(int yaoIndex) {
    setState(() => hoveredGua = null);
  }

  // 切换对比状态
  void _toggleCompareMode() {
    setState(() {
      isComparing = !isComparing;
      if (!isComparing) compareList.clear(); // 退出时清空对比列表
    });
  }

  // 展示对比弹窗
  void _showCompareDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("对比结果"),
        content: SingleChildScrollView(
          child: Column(
            children: compareList.map((gua) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(gua.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("卦辞：${gua.guaCi}"),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("关闭"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("易经决策器"),
        actions: [
          // 对比按钮：切换状态或确认对比
          TextButton(
            onPressed: isComparing ? _showCompareDialog : _toggleCompareMode,
            child: Text(
              isComparing ? "确认对比(${compareList.length}/$maxCompareCount)" : "对比",
              style: TextStyle(color: isComparing ? Colors.red : Colors.white),
            ),
          ),
          if (isComparing)
            TextButton(
              onPressed: _toggleCompareMode,
              child: const Text("取消", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Row(
        children: [
          // 左侧：64卦矩阵（占2/3宽度）
          Expanded(
            flex: 2,
            child: GuaMatrix(
              currentGua: currentGua,
              hoveredGua: hoveredGua,
              compareList: compareList,
              isComparing: isComparing,
              onGuaTap: _onGuaTap,
              onYaoHover: _onYaoHover,
              onYaoExit: _onYaoExit,
            ),
          ),
          // 右侧：详情面板（占1/3宽度）
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey)),
              ),
              child: GuaDetail(gua: currentGua),
            ),
          ),
        ],
      ),
    );
  }
}