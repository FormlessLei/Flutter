import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../data/liushisi_gua.dart';
import '../ui/gua_matrix.dart';
import '../ui/gua_detail.dart';

class YiChoicePage extends StatefulWidget {
  const YiChoicePage({super.key});

  @override
  State<YiChoicePage> createState() => _YiChoicePageState();
}

class _YiChoicePageState extends State<YiChoicePage> {
  LiuShiSiGua? _currentGua; // 选中的卦
  LiuShiSiGua? _hoveredGuaGrid; // 矩阵中悬停的卦
  int? _hoveredYaoIndex; // 选中卦悬停的爻位
  List<LiuShiSiGua> _currentGuaVariants = []; // 选中卦的6个变卦
  List<LiuShiSiGua> _compareList = []; // 对比列表

  @override
  void initState() {
    super.initState();
    // 初始化：选中乾为天，并计算其6个变卦
    _currentGua = liushisiGuaList.first;
    _calculateVariants(_currentGua!);
  }

  // 计算选中卦的6个变卦（核心：反转每个爻位生成变卦）
  void _calculateVariants(LiuShiSiGua gua) {
    _currentGuaVariants = List.generate(6, (index) {
      final newYaoList = List.from(gua.yaoList);
      newYaoList[index] = newYaoList[index] == 1 ? 0 : 1; // 反转爻的阴阳
      return liushisiGuaList.firstWhere(
        (g) => listEquals(g.yaoList, newYaoList),
        orElse: () => gua,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('易经64卦矩阵')),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: GuaMatrix(
              currentGua: _currentGua,
              hoveredGuaGrid: _hoveredGuaGrid,
              hoveredYaoIndexOfCurrent: _hoveredYaoIndex,
              currentGuaVariants: _currentGuaVariants,
              compareList: _compareList,
              isComparing: _compareList.isNotEmpty,
              onGuaTap: (gua) {
                setState(() {
                  _currentGua = gua;
                  _calculateVariants(gua); // 重新计算变卦
                });
              },
              onGuaGridHover: (gua) {
                setState(() => _hoveredGuaGrid = gua);
              },
              onGuaGridExit: () {
                setState(() => _hoveredGuaGrid = null);
              },
              onCurrentGuaYaoHover: (index) {
                setState(() => _hoveredYaoIndex = index);
              },
              onCurrentGuaYaoExit: () {
                setState(() => _hoveredYaoIndex = null);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey)),
              ),
              child: GuaDetail(gua: _currentGua),
            ),
          ),
        ],
      ),
    );
  }
}
