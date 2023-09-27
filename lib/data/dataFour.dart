import 'package:flutter/material.dart';

class OneSubmit {
  // 这里的应该是题目的顺序编号，如A，B，C这种，
  // 所以初始化的时候应该传递过来一个带有题目顺序的List,然后通过匹配problemId来获取字母编号
  late String problemId;
  late String submitTime;//可以按照时间排序，新的排在上面
  late String language;
  late String codeStatus;
}

class SubmitModel extends ChangeNotifier {
  late List<OneSubmit> submitList;
}
