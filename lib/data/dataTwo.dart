import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:owo_user/macroWidget/funcOne.dart';

//这里应该不用继承ChangeNotifier吧，如果是在该类里面调用notifyListeners方法才有必要继承
class ExampleFile {
  late String exampleId;
  late String inFilePath;
  late String outFilePath;

  ExampleFile(
      {required this.exampleId,
      required this.inFilePath,
      required this.outFilePath});

  factory ExampleFile.fromJson(String exampleFile) {
    List<String> list = exampleFile.split('|');
    return ExampleFile(
        exampleId: list[0], inFilePath: list[1], outFilePath: list[2]);
  }

  @override
  String toString() {
    return '$exampleId - $inFilePath - $outFilePath';
  }
}

class Problem {
  late String problemId;
  late String problemName;
  bool isAc = false; //当前用户是否通过该题目
  late bool pdf;
  late String timeLimit;
  late String memoryLimit;
  late String maxFileLimit;
  List<ExampleFile> exampleFileList = [];
  late String submitTotal;
  late String submitAc;

  Problem();

//  书写对应的解析代码
  factory Problem.fromJson(dynamic problem) {
    var tempProblem = Problem();
    tempProblem.problemId = problem['ID'].toString();
    tempProblem.problemName = problem['ProblemName'];
    tempProblem.pdf = problem['Pdf'];
    tempProblem.timeLimit = problem['TimeLimit'].toString();
    tempProblem.memoryLimit = problem['MemoryLimit'].toString();
    tempProblem.maxFileLimit = problem['MaxFileLimit'].toString();
    List<String> tempExamples = problem['ExampleFiles'].toString().split('#');
    tempProblem.exampleFileList = List.generate(tempExamples.length,
        (index) => ExampleFile.fromJson(tempExamples[index]));
    tempProblem.submitTotal = problem['SubmitTotal'].toString();
    tempProblem.submitAc = problem['SubmitAc'].toString();
    return tempProblem;
  }

  @override
  String toString() {
    return '$problemId - $problemName - $pdf - $exampleFileList';
  }
}

//应该尽量自己处理属于自己的数据
class ProblemModel extends ChangeNotifier {
  //先初始化好
  List<Problem> problemList = List.generate(0, (index) => Problem());

//当前浏览的是哪一道题目，因为这里的默认下标是0
  int curProblem = 0;

  //上一次的请求时间跟这一次的请求时间至少要距离requestGap
  static const int requestGap = 60 * 5;
  DateTime? latestRequestTime;

  void switchProblem(int id) {
    if (curProblem != id) {
      curProblem = id;
      //虽然在这里notifyListeners了，但是并没有ChangeNotifierProvider<ProblemModel>在监听，
      //就会导致数据其实已经改变了，但是没有及时渲染到界面上。
      //即使调用ChangeNotifierProvider.of<GlobalData>(context).problemModel.switchProblem(index);
      //也是无法更新数据的，因为这里的notifyListeners是传给ProblemModel的，GlobalData并没有收到该通知事件。
      //  还有一个点可以证明上面的猜想是正确的:
      //  通过ChangeNotifierProvider.of<GlobalData>(context).problemModel;来获取problemModel
      //  和通过ChangeNotifierProvider.of<ProblemModel>(context);来获取problemModel是不一样的
      //  前者调用switchProblem方法，数据没有及时渲染;后者调用，数据及时渲染到界面上了，
      //  证明前者标记了一处GlobalData监听，监听不到这里发送出去的ProblemModel类型的notifyListeners，
      //  后者标记了一处ProblemModel监听，可以监听到ProblemModel类型的notifyListeners
      //这里有两者方法解决 :
      //1.将notifyListeners放到Global类里面，这样ChangeNotifierProvider<GlobalData>就可以及时的监听到数据改变了
      //2.创建一个监听ProblemModel的ChangeNotifierProvider<ProblemModel>，这样就可以监听到了
      notifyListeners();
    }
  }

  //请求题目数据
  Future<bool> requestProblemData(Config config, String contestId) async {
    if (latestRequestTime != null &&
        DateTime.now().difference(latestRequestTime!).inSeconds < requestGap) {
      return true;
    }
    latestRequestTime = DateTime.now();
    Map request = {
      'requestType': 'requestProblemsInfo',
      'info': [contestId]
    };
    return await Config.dio
        .post(config.netPath + Config.jsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List problems = value.data['problems'] as List;
      problemList = List.generate(problems.length, (index) {
        return Problem.fromJson(problems[index]);
      });
      notifyListeners();
      // debugPrint(problemList.length.toString());
      // debugPrint(problemList.toString());
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

// 下载题目描述文件
  Future<bool> downloadProblemFile(Config config, String contestId) async {
    //先构建文件名
    String filePath =
        '${String.fromCharCode(65 + curProblem)}_problem$contestId.pdf';
    //如果能够找到准备要下载的文件,那打开其所在文件夹即可
    if (await config.isExistFile(config.downloadFilePath, filePath)) {
      config.openFolder(config.downloadFilePath);
      return true;
    }
    Map request = {
      'requestType': 'downloadPdfFile',
      'info': ['$contestId/${problemList[curProblem].problemId}/problem.pdf']
    };
    bool flag = false;
    try {
      Response response = await Config.dio.post(
          config.netPath + Config.jsonRequest,
          data: request,
          options: Options(responseType: ResponseType.bytes));
      File file = File(config.downloadFilePath + filePath);
      await file.writeAsBytes(response.data);
      flag = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    if (flag) {
      config.openFolder(config.downloadFilePath);
    }
    return flag;
  }

//  下载样例文件
  Future<bool> downloadExampleFile(
      Config config, String contestId, int columnIndex, int rowIndex) async {
    //先构建文件名
    String fileName =
        '${String.fromCharCode(65 + curProblem)}_${rowIndex == 1 ? 'in' : 'out'}${columnIndex + 1}.txt';
    if (await config.isExistFile(config.downloadFilePath, fileName)) {
      config.openFolder(config.downloadFilePath);
      return true;
    }
    debugPrint(fileName);
    String filePath =
        problemList[curProblem].exampleFileList[columnIndex].inFilePath;
    if (rowIndex == 2) {
      filePath =
          problemList[curProblem].exampleFileList[columnIndex].outFilePath;
    }
    debugPrint(filePath);
    Map request = {
      'requestType': 'downloadExampleFile',
      'info': [filePath]
    };
    // bool flag = false;
    return await Config.dio
        .post(config.netPath + Config.jsonRequest, data: request)
        .then((value) async {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      final file = File(config.downloadFilePath + fileName);
      await file.writeAsString(value.data['exampleFile']);
      config.openFolder(config.downloadFilePath);
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    // return flag;
  }

//  提交代码文件
  //0表示提交成功，1表示没有选中文件，2表示提交文件过大，3表示不支持该文件类型，4表示提交文件提交失败
  Future<int> submitCodeFile(
      Config config, String studentNumber, String contestId) async {
    FilePickerResult? filePickerResult =
        await config.selectAFile(ConstantData.fileSuffix);
    if (filePickerResult == null) {
      return 1;
    }
    //这里比较的单位是kb
    if ((filePickerResult.files.single.size >> 10) >
        int.parse(problemList[curProblem].maxFileLimit)) {
      return 2;
    }
    String language = 'other';
    for (int i = 0; i < ConstantData.fileSuffix.length; i++) {
      if (filePickerResult.files.single.name
          .endsWith(ConstantData.fileSuffix[i])) {
        language = ConstantData.languages[i];
      }
    }
    if (language == 'other') {
      return 3;
    }
    FormData formData = FormData.fromMap({
      'requestType': 'submitCode',
      'file': await MultipartFile.fromFile(filePickerResult.files.single.path!,
          filename: filePickerResult.files.single.name),
      'contestId': contestId,
      'problemId': problemList[curProblem].problemId,
      'studentNumber': studentNumber,
      'language': language,
      'submitTime': FuncOne.getCurFormatTime()
    });
    return await Config.dio
        .post(config.netPath + Config.formRequest, data: formData)
        .then((value) {
      return value.data[Config.returnStatus] == Config.succeedStatus ? 0 : 4;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 4;
    });
  }
}
