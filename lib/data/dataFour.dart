import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dataTwo.dart';
import 'myConfig.dart';

class OneSubmit {
  // 这里的应该是题目的顺序编号，如A，B，C这种，
  // 所以初始化的时候应该传递过来一个带有题目顺序的List,然后通过匹配problemId来获取字母编号
  late String id;
  late String problemId;
  late String submitTime; //可以按照时间排序，新的排在上面
  late String language;
  late String codeStatus;

  OneSubmit(
      {required this.problemId,
      required this.codeStatus,
      required this.language,
      required this.submitTime});

  factory OneSubmit.fromJson(dynamic oneSubmit) {
    return OneSubmit(
        problemId: oneSubmit['ProblemId'],
        codeStatus: oneSubmit['Status'],
        language: oneSubmit['Language'],
        submitTime: oneSubmit['SubmitTime']);
  }
}

class SubmitModel extends ChangeNotifier {
  List<OneSubmit> submitList = [];

  //上一次的请求时间跟这一次的请求时间至少要距离requestGap
  static const int requestGap = 60 * 3;
  DateTime? latestRequestTime;

  void cleanCacheData(){
    latestRequestTime = null;
    submitList.clear();
    notifyListeners();
  }

  Future<bool> requestSubmitData(Config config, String contestId,
      String studentNumber, List<Problem> problemList) async {
    if (latestRequestTime != null &&
        DateTime.now().difference(latestRequestTime!).inSeconds < requestGap) {
      return true;
    }
    latestRequestTime = DateTime.now();
    Map request = {
      'requestType': 'requestSubmitsInfo',
      'info': [contestId, studentNumber]
    };
    bool flag = await Config.dio
        .post(config.netPath + Config.jsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['submits'] as List;
      submitList = List.generate(tempList.length, (index) {
        return OneSubmit.fromJson(tempList[index]);
      });

      //降序排序
      submitList.sort((a, b) {
        return DateTime.parse(b.submitTime)
            .difference(DateTime.parse(a.submitTime))
            .inSeconds;
      });
      //因为status页面需要problemList数据，所以要先获取到problemList的数据,
      //但是这不算一个bug，因为如果有了提交记录，那么problem页面的submit按钮肯定已经点击过了，problemList数据自然就获取到了
      for (int i = 0; i < submitList.length; i++) {
        for (int j = 0; j < problemList.length; j++) {
          if (submitList[i].problemId == problemList[j].problemId) {
            submitList[i].problemId = String.fromCharCode(65 + j);
            break;
          }
        }
        submitList[i].id = (submitList.length - i).toString();
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    if (flag) {
      notifyListeners();
    }
    return flag;
  }
}
