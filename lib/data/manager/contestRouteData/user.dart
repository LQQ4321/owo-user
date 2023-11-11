import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
//rank和user路由一起使用,滚榜使用的数据是和status页面共享的

class MProblemStatus {
  late String problemId;
  int submitCount = 0;
  late String problemStatus;
  late int submitTime;

  MProblemStatus(
      {required this.problemId,
      required this.submitCount,
      required this.problemStatus,
      required this.submitTime});

  factory MProblemStatus.fromJson(String data, String startTime) {
    List<String> tempList = data.split('|');
    return MProblemStatus(
        problemId: tempList[0],
        submitCount: int.parse(tempList[1]),
        problemStatus: tempList[2],
        submitTime: DateTime.parse(tempList[3])
            .difference(DateTime.parse(startTime))
            .inSeconds);
  }

  @override
  String toString() {
    return '$problemId : $submitCount : $problemStatus : $submitTime';
  }
}

class MUserItem {
  late String userId;
  late String studentNumber;
  late String studentName;
  late String schoolName;
  late String password;
  late String loginTime;
  int rankId = 1;
  int acProblemCount = 0;
  int punitiveTime = 0;
  late List<MProblemStatus> problemStatusList;

  MUserItem();

  factory MUserItem.fromJson(
      dynamic data, List<String> problem, String startTime) {
    MUserItem mUserItem = MUserItem();
    mUserItem.userId = data['ID'].toString();
    mUserItem.loginTime = data['LoginTime'];
    mUserItem.studentNumber = data['StudentNumber'];
    mUserItem.studentName = data['StudentName'];
    mUserItem.schoolName = data['SchoolName'];
    mUserItem.password = data['Password'];
    String status = data['Status'];
    //先初始化好，就是给每道题目留一个位置(不管改名选手有没有提交改题目)
    mUserItem.problemStatusList = List.generate(problem.length, (index) {
      return MProblemStatus(
          problemId: problem[index],
          submitCount: 0,
          problemStatus: '',
          submitTime: 0);
    });
    //可能存在的bug:这里假设status的格式是正常的(每一个'#'两边都要有problemStatus)
    if (status.isNotEmpty) {
      List<String> tempStatusList = status.split('#');
      for (int i = 0; i < tempStatusList.length; i++) {
        MProblemStatus mProblemStatus =
            MProblemStatus.fromJson(tempStatusList[i], startTime);
        for (int j = 0; j < mUserItem.problemStatusList.length; j++) {
          if (mUserItem.problemStatusList[j].problemId ==
              mProblemStatus.problemId) {
            mUserItem.problemStatusList[j] = mProblemStatus;
            if (mUserItem.problemStatusList[j].problemStatus ==
                    ConstantData.statusType[0] ||
                mUserItem.problemStatusList[j].problemStatus ==
                    ConstantData.statusType[1]) {
              mUserItem.acProblemCount++;
              mUserItem.punitiveTime +=
                  (mUserItem.problemStatusList[j].submitCount - 1) * 20 * 60 +
                      mUserItem.problemStatusList[j].submitTime;
            }
            break;
          }
        }
      }
    }
    for (int i = 0; i < mUserItem.problemStatusList.length; i++) {
      mUserItem.problemStatusList[i].problemId = String.fromCharCode(65 + i);
    }
    return mUserItem;
  }

  @override
  String toString() {
    return '$studentNumber - $studentName - $schoolName - $rankId - $acProblemCount - $punitiveTime - $problemStatusList}';
  }

  int compare(MUserItem mUserItem) {
    if (acProblemCount == mUserItem.acProblemCount) {
      return punitiveTime - mUserItem.punitiveTime;
    }
    return mUserItem.acProblemCount - acProblemCount;
  }
}

class MUser {
  //总数据
  List<MUserItem> allUserList = [];

  //用于rank页面显示
  List<MUserItem> rankList = [];

  //用于user页面显示
  List<MUserItem> userList = [];
  static final TextEditingController rankSearch = TextEditingController();
  static final TextEditingController userSearch = TextEditingController();
  String lastContestId = '';

  void userSearchSort() {
    userList.clear();
    if (userSearch.text.isEmpty) {
      userList = [...allUserList];
      return;
    }
    for (int i = 0; i < allUserList.length; i++) {
      if (allUserList[i].studentName.contains(userSearch.text)) {
        userList.add(allUserList[i]);
      }
    }
  }

  void rankSearchSort() {
    rankList.clear();
    if (rankSearch.text.isEmpty) {
      rankList = [...allUserList];
      return;
    }
    for (int i = 0; i < allUserList.length; i++) {
      if (allUserList[i].studentName.contains(rankSearch.text)) {
        rankList.add(allUserList[i]);
      }
    }
  }

  //{studentName,schoolName},{studentNumber,password}
  //val里面的userId是数据库中的主键，而不是userList的索引
  Future<bool> userOperate(String contestId, int option, List<String> val,
      {List<String>? problem}) async {
    String reqOption = 'changeUserInfo';
    if (option == 1) {
      reqOption = 'deleteAUser';
    } else if (option == 2) {
      reqOption = 'createAUser';
    }
    List<String> tempList = [reqOption, contestId];
    tempList.addAll(val);
    Map request = {'requestType': 'userOperate', 'info': tempList};
    debugPrint(request.toString());
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      debugPrint(value.data.toString());
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      if (option == 0) {
        for (int i = 0; i < allUserList.length; i++) {
          if (allUserList[i].userId == val[0]) {
            allUserList[i].studentName = val[1];
            allUserList[i].schoolName = val[2];
            allUserList[i].studentNumber = val[3];
            allUserList[i].password = val[4];
            break;
          }
        }
        for (int i = 0; i < rankList.length; i++) {
          if (rankList[i].userId == val[0]) {
            rankList[i].studentName = val[1];
            rankList[i].schoolName = val[2];
            rankList[i].studentNumber = val[3];
            rankList[i].password = val[4];
            break;
          }
        }
        for (int i = 0; i < rankList.length; i++) {
          if (userList[i].userId == val[0]) {
            userList[i].studentName = val[1];
            userList[i].schoolName = val[2];
            userList[i].studentNumber = val[3];
            userList[i].password = val[4];
            break;
          }
        }
      } else if (option == 1) {
        for (int i = 0; i < allUserList.length; i++) {
          if (allUserList[i].userId == val[0]) {
            allUserList.removeAt(i);
            break;
          }
        }
        for (int i = 0; i < rankList.length; i++) {
          if (rankList[i].userId == val[0]) {
            rankList.removeAt(i);
            break;
          }
        }
        for (int i = 0; i < userList.length; i++) {
          if (userList[i].userId == val[0]) {
            userList.removeAt(i);
            break;
          }
        }
      } else if (option == 2) {
        int userId = value.data['userId'];
        Map tempData = {
          'ID': userId,
          'LoginTime': '',
          'StudentName': val[0],
          'SchoolName': val[1],
          'StudentNumber': val[2],
          'Password': val[3],
          'Status': '',
        };
        allUserList.add(MUserItem.fromJson(tempData, problem!, ''));
        userList.insert(0, MUserItem.fromJson(tempData, problem!, ''));
        if (allUserList.length > 1) {
          if (allUserList[allUserList.length - 1]
                  .compare(allUserList[allUserList.length - 2]) ==
              0) {
            allUserList[allUserList.length - 1].rankId =
                allUserList[allUserList.length - 2].rankId;
          } else {
            allUserList[allUserList.length - 1].rankId = allUserList.length;
          }
        }
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<bool> requestUsersInfo(String contestId, bool refresh,
      List<String> problem, String startTime) async {
    rankSearch.clear();
    if (contestId == lastContestId && !refresh) {
      return true;
    }
    lastContestId = contestId;
    Map request = {
      'requestType': 'requestUsersInfo',
      'info': [contestId]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      // debugPrint(value.data.toString());
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['users'];
      allUserList = List.generate(tempList.length, (index) {
        return MUserItem.fromJson(tempList[index], problem, startTime);
      });
      allUserList.sort((a, b) {
        return a.compare(b);
      });
      for (int i = 1; i < allUserList.length; i++) {
        if (allUserList[i].compare(allUserList[i - 1]) == 0) {
          allUserList[i].rankId = allUserList[i - 1].rankId;
        } else {
          allUserList[i].rankId = i + 1;
        }
      }
      //将总数据拷贝到两个页面中，方便使用
      rankList = [...allUserList];
      userList = [...allUserList];
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  //因为状态比较多，所以还是用int来代替bool吧
  //0 上传文件成功,1 没有执行上传操作, 2 上传失败
  Future<int> addUsersFromFile(String contestId) async {
    FilePickerResult? filePickerResult = await Config.selectAFile(['txt']);
    if (filePickerResult == null) {
      return 1;
    }
    //比较的单位是 kb (即使测试文件压缩成zip文件，也还是会很大，所以后端文件传输的限制要开大一些，或者使用其他文件传输的方法)
    if ((filePickerResult.files.single.size >> 10) > (1 << 10)) {
      return 2;
    }
    FormData formData = FormData.fromMap({
      'requestType': 'addUsersFromFile',
      'file': await MultipartFile.fromFile(filePickerResult.files.single.path!,
          //FIXME 这里的filename可以不使用本地的文件名吗
          filename: 'whiteList.txt'),
      'contestId': contestId,
    });
    return await Config.dio
        .post(Config.netPath + Config.managerFormRequest, data: formData)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return 2;
      }
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 2;
    });
  }
}
