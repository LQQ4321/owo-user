import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class ProblemItem {
  late String problemId;
  late String problemName;
  late bool pdf;
  late int timeLimit;
  late int memoryLimit;
  late int maxFileLimit;
  late bool testFiles; //样例可以没有，测试数据一定要有
  late int submitTotal;
  late int submitAc;

  ProblemItem();

  factory ProblemItem.fromJson(dynamic data) {
    ProblemItem problemItem = ProblemItem();
    problemItem.problemId = data['ID'].toString();
    problemItem.problemName = data['ProblemName'];
    problemItem.pdf = data['Pdf'];
    problemItem.timeLimit = data['TimeLimit'];
    problemItem.memoryLimit = data['MemoryLimit'];
    problemItem.maxFileLimit = data['MaxFileLimit'];
    problemItem.testFiles = (data['TestFiles'] as String).isNotEmpty;
    problemItem.submitTotal = data['SubmitTotal'];
    problemItem.submitAc = data['SubmitAc'];
    return problemItem;
  }
}

class MProblemModel {
  List<ProblemItem> problemList = [];
  int problemId = 0;

  void cleanCacheData() {
    problemId = 0;
    problemList.clear();
  }

  void switchProblemId(int id) {
    if (problemId != id) {
      problemId = id;
      // 为了避免ChangeNotifierProvider逃到层数太多，
      // 还有就是MProblemModel类中的大多数方法都需要使用ContestModel中的数据，
      // 没有必要单独notifyListeners()
      // notifyListeners();
    }
  }

  Future<bool> requestProblemList(String contestId) async {
    problemId = 0;
    Map request = {
      'requestType': 'requestProblemList',
      'info': [contestId]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      // debugPrint(value.data.toString());
      List<dynamic> tempList = value.data['problemList'];
      problemList = List.generate(tempList.length, (index) {
        return ProblemItem.fromJson(tempList[index]);
      });
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
  //不支持修改题目名称
  Future<bool> changeProblemData(
      String contestId,List<String> list) async {
    Map request = {
      'requestType': 'changeProblemConfig',
      'info': [
        contestId,
        problemList[problemId].problemId
      ]
    };
    (request['info'] as List).addAll(list);
    debugPrint(request.toString());
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      // debugPrint(value.data.toString());
      problemList[problemId].timeLimit = int.parse(list[0]);
      problemList[problemId].memoryLimit = int.parse(list[1]);
      problemList[problemId].maxFileLimit = int.parse(list[2]);
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<bool> createANewProblem(String contestId, String problemName) async {
    Map request = {
      'requestType': 'createANewProblem',
      'info': [contestId, problemName]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      // debugPrint(value.data.toString());
      problemList.add(ProblemItem.fromJson(value.data['newProblem']));
      //有新的题目被添加，需要改变当前题目的指向，默认指向新添加的题目
      problemId = problemList.length - 1;
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<bool> deleteAProblem(String contestId) async {
    Map request = {
      'requestType': 'deleteAProblem',
      'info': [contestId, problemList[problemId].problemId]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      // debugPrint(value.data.toString());
      problemList.removeAt(problemId);
      //当前题目被删除了，需要改变当前题目的指向，默认指向第一道题
      problemId = 0;
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  //因为状态比较多，所以还是用int来代替bool吧
  //0 上传文件成功,1 没有执行上传操作, 2 上传失败
  Future<int> uploadFiles(String contestId, int fileType) async {
    FilePickerResult? filePickerResult =
        await Config.selectAFile([MConstantData.fileSuffix[fileType]]);
    if (filePickerResult == null) {
      return 1;
    }
    //比较的单位是 kb (即使测试文件压缩成zip文件，也还是会很大，所以后端文件传输的限制要开大一些，或者使用其他文件传输的方法)
    if ((filePickerResult.files.single.size >> 10) > (1 << 10)) {
      return 2;
    }
    FormData formData = FormData.fromMap({
      'requestType': fileType == 0 ? 'uploadIoFiles' : 'uploadPdfFile',
      'file': await MultipartFile.fromFile(filePickerResult.files.single.path!,
          //FIXME 这里的filename可以不使用本地的文件名吗
          filename: fileType == 0 ? 'io' : 'pdf'),
      'contestId': contestId,
      'problemId': problemList[problemId].problemId
    });
    return await Config.dio
        .post(Config.netPath + Config.managerFormRequest, data: formData)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return 2;
      }
      if (fileType == 0) {
        problemList[problemId].testFiles = true;
      } else {
        problemList[problemId].pdf = true;
      }
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 2;
    });
  }
}
