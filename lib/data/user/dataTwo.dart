import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:owo_user/macroWidget/funcOne.dart';
import 'package:pdfx/pdfx.dart';

//这里应该不用继承ChangeNotifier吧，如果是在该类里面调用notifyListeners方法才有必要继承
class ExampleFile {
  late String exampleId;
  late String inFilePath;
  late String outFilePath;

  //将样例存放在内存中
  String inText = '';
  String outText = '';

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

  //pdf文件名，不可能每次打开题目都重新下载一遍文件，所以可以第一次打开题目的时候就将其下载下来，这样下载一次就可以了，
  //如果文件该题的pdf文件为空，那么表示还没有下载，为了防止重覆盖同名文件，这里的文件名应该是随机生成的，
  //每次保存文件的时候还应该检查是否存在同名文件，如果存在，就重新生成一个文件名
  //PdfDocument.openFile(r'C:\Users\QQ123456\Downloads\problemxiaobai.pdf'),
  String pdfFileName = '';
  late String timeLimit;
  late String memoryLimit;
  late String maxFileLimit;

  //是否已经下载样例文件
  bool isDownloadExampleFile = false;
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
    //可能是空字符串，这里是二维部分，
    if (problem['ExampleFiles'].toString().isNotEmpty) {
      List<String> tempExamples = problem['ExampleFiles'].toString().split('#');
      tempProblem.exampleFileList = List.generate(tempExamples.length,
          (index) => ExampleFile.fromJson(tempExamples[index]));
    }
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
  List<Problem> problemList = [];

//当前浏览的是哪一道题目，因为这里的默认下标是0
  int curProblem = -1;
  PdfController? pdfController;

  //上一次的请求时间跟这一次的请求时间至少要距离requestGap
  static const int requestGap = 60 * 5;
  DateTime? latestRequestTime;

  void cleanCacheData() {
    latestRequestTime = null;
    problemList.clear();
    curProblem = 0;
    notifyListeners();
  }

  //切换题目，同时下载题目和样例文件
  void switchProblem(int id, Config config, String contestId) async {
    if (curProblem != id) {
      if (problemList.isNotEmpty) {
        curProblem = id;
        if (await downloadProblemFile(config, contestId)) {
          if (pdfController == null) {
            pdfController = PdfController(
                document:
                    PdfDocument.openFile(problemList[curProblem].pdfFileName));
          } else {
            pdfController!.loadDocument(
                PdfDocument.openFile(problemList[curProblem].pdfFileName));
          }

          notifyListeners();
        } else {
          //  FIXME 这里假设下载题目描述文件一定成功
        }

        if (!problemList[curProblem].isDownloadExampleFile) {
          List<Future> funcList = [];
          for (int i = 0;
              i < problemList[curProblem].exampleFileList.length;
              i++) {
            funcList.add(downloadExampleFile(config, contestId, i, 1));
            funcList.add(downloadExampleFile(config, contestId, i, 2));
          }
          Future.wait(funcList).then((value) {
            bool flag = true;
            //只要有一个样例文件下载失败，就认定为下载失败
            for (int i = 0; i < value.length; i++) {
              if ((value[i] is bool) && (!value[i])) {
                flag = false;
                break;
              }
            }
            if (flag) {
              problemList[curProblem].isDownloadExampleFile = true;
            }
          }).catchError((onError) {
            debugPrint(onError.toString());
          });
        }
      }
      notifyListeners();
    }
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
  }

  String getExampleText(int column, int row) {
    if (row == 1) {
      return problemList[curProblem].exampleFileList[column].inText;
    }
    return problemList[curProblem].exampleFileList[column].outText;
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
    bool flag = false;
    flag = await Config.dio
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
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    if (!flag) {
      return false;
    }
    if (problemList.isEmpty) {
      return true;
    }
    switchProblem(0, config, contestId);
    return flag;
  }

// 下载题目描述文件
  Future<bool> downloadProblemFile(Config config, String contestId) async {
    if (problemList[curProblem].pdfFileName.isNotEmpty) {
      return true;
    }
    while (true) {
      String fileName = '${FuncOne.generateRandomString(10)}.pdf';
      //如果文件名已存在,就重新生成一个文件名
      if (!await config.isExistFile(config.downloadFilePath, fileName)) {
        problemList[curProblem].pdfFileName =
            config.downloadFilePath + fileName;
        break;
      }
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
      File file = File(problemList[curProblem].pdfFileName);
      await file.writeAsBytes(response.data);
      flag = true;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
    return flag;
  }

//  下载样例文件
  Future<bool> downloadExampleFile(
      Config config, String contestId, int columnIndex, int rowIndex) async {
    String filePath =
        problemList[curProblem].exampleFileList[columnIndex].inFilePath;
    if (rowIndex == 2) {
      filePath =
          problemList[curProblem].exampleFileList[columnIndex].outFilePath;
    }
    Map request = {
      'requestType': 'downloadExampleFile',
      'info': [filePath]
    };
    return await Config.dio
        .post(config.netPath + Config.jsonRequest, data: request)
        .then((value) async {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      if (rowIndex == 1) {
        // FIXME 因为现在上传的样例文件都是只有一行而已，所以换行符的问题可能存在
        problemList[curProblem].exampleFileList[columnIndex].inText =
            value.data['exampleFile'];
      } else {
        problemList[curProblem].exampleFileList[columnIndex].outText =
            value.data['exampleFile'];
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    // return flag;
  }

//  提交代码文件
//  首先选择文件(应该把config.selectAFile调成静态方法,这样就不必经过GlobalData获取config了)
  Future<List<String>> selectFile(Config config) async {
    FilePickerResult? filePickerResult =
        await config.selectAFile(ConstantData.fileSuffix);
    if (filePickerResult == null) {
      return [];
    }
    //这里比较的单位是kb
    if ((filePickerResult.files.single.size >> 10) >
        int.parse(problemList[curProblem].maxFileLimit)) {
      return [''];
    }
    String language = 'other';
    for (int i = 0; i < ConstantData.fileSuffix.length; i++) {
      if (filePickerResult.files.single.name
          .endsWith(ConstantData.fileSuffix[i])) {
        language = ConstantData.languages[i];
      }
    }
    if (language == 'other') {
      return ['', ''];
    }
    return [
      language,
      filePickerResult.files.single.path!,
      filePickerResult.files.single.name
    ];
  }

  //0表示提交成功,1表示提交失败
  Future<bool> submitCodeFile(Config config, String studentNumber,
      String contestId, List<String> list) async {
    FormData formData = FormData.fromMap({
      'requestType': 'submitCode',
      'file': await MultipartFile.fromFile(list[1],
          filename: list[2]),
      'contestId': contestId,
      'problemId': problemList[curProblem].problemId,
      'studentNumber': studentNumber,
      'language': list[0],
      'submitTime': FuncOne.getCurFormatTime()
    });
    return await Config.dio
        .post(config.netPath + Config.formRequest, data: formData)
        .then((value) {
      return value.data[Config.returnStatus] == Config.succeedStatus;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
