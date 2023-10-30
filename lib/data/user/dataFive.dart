import 'package:flutter/material.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:owo_user/macroWidget/funcOne.dart';

class OneMessage {
  // late String messageId;
  late bool isManager;
  late String text;
  late String sendTime;

  OneMessage(
      {required this.isManager, required this.text, required this.sendTime});

  factory OneMessage.fromJson(dynamic news) {
    return OneMessage(
        isManager: news['IsManager'],
        text: news['Text'],
        sendTime: news['SendTime']);
  }

  @override
  String toString() {
    return '$isManager - $text -$sendTime';
  }
}

class NewsModel extends ChangeNotifier {
  List<OneMessage> newsList = [];

  static const int requestGap = 30 * 1;
  static const int sendGap = 5 * 1;
  DateTime? latestRequestTime;
  DateTime? latestSendTime;

  static TextEditingController textEditingController = TextEditingController();
  static ScrollController scrollController = ScrollController();

  //清理缓存
  void cleanCacheData() {
    latestRequestTime = null;
    latestSendTime = null;
    textEditingController.clear();
    //需要调用这个方法吗,好像不需要，clear就可以清除输入框文本了
    // textEditingController.notifyListeners();
    newsList.clear();
    // 这里应该是需要调用notifyListeners()的，因为在GlobalData那里调用notifyListeners()，
    // 有些只监听了自己的数据变化，没有监听总的数据
    notifyListeners();
  }

  void localAddNewMessage() {
    newsList.add(OneMessage(
        isManager: false,
        text: textEditingController.text,
        sendTime: FuncOne.getCurFormatTime()));
    textEditingController.clear();
    notifyListeners();
  }

  //消息发送成功返回0；消息为空返回1；消息发送失败返回2；还没到间隔时间返回3
  Future<int> sendNews(String contestId, String studentNumber) async {
    if (textEditingController.text.trim().isEmpty) {
      return 1;
    }
    if (latestSendTime != null &&
        DateTime.now().difference(latestSendTime!).inSeconds < requestGap) {
      return 3;
    }
    latestSendTime = DateTime.now();
    Map request = {
      'requestType': 'sendNews',
      'info': [
        contestId,
        studentNumber,
        textEditingController.text,
        FuncOne.getCurFormatTime()
      ]
    };
    return await Config.dio
        .post(Config.netPath + Config.jsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return 2;
      }
      // textEditingController.clear();
      // textEditingController.notifyListeners();
      // 是不是用上面那个notifyListeners()
      // notifyListeners();
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 2;
    });
  }

  //请求消息
  Future<bool> requestNewsData(String contestId, String studentNumber) async {
    if (latestRequestTime != null &&
        DateTime.now().difference(latestRequestTime!).inSeconds < requestGap) {
      return true;
    }
    latestRequestTime = DateTime.now();
    Map request = {
      'requestType': 'requestNewsInfo',
      'info': [contestId, studentNumber]
    };
    return await Config.dio
        .post(Config.netPath + Config.jsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['news']; // as List;
      newsList = List.generate(tempList.length, (index) {
        return OneMessage.fromJson(tempList[index]);
      });
      newsList.sort((a, b) {
        return DateTime.parse(a.sendTime)
            .difference(DateTime.parse(b.sendTime))
            .inSeconds;
      });
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
