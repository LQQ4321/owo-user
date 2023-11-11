import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/contestRouteData/problems.dart';
import 'package:owo_user/data/manager/contestRouteData/status.dart';
import 'package:owo_user/data/manager/contestRouteData/user.dart';

//一场比赛的内部数据
//这里是比赛模块的第二层，展示的页面有 :
// 1 题目 ：应该有一个题目滚动列表，然后点击相应的列表，出现对应的题目，然后就可以修改题目配置信息了(比赛期间也可能需要修改题目)
// 2 选手 ：用来操作该场比赛的参赛选手的数据信息
// 3 消息 ：用来和选手交互的模块
// 4 提交 ：显示该场比赛所有选手提交的数据
// 5 排行榜 ：显示该场比赛的排行榜(这里应该单独弄一个页面[为了更好的显示数据])
// 5.1 关于滚榜功能，还是专门弄一个全屏的页面吧，这样显示起来跟美观
// 5.2 所以有两个排行榜，一个是局部的，用来显示实时的排行榜信息；一个是全局的，比赛结束后用来滚榜
// 创建该类的目的是在ContestModel和各个路由之间再加一个中间节点
// 一是ContestModel已经很臃肿了，二是弄一个专门的节点比较方便管理，缺点就是数树的深度又深了一层
class SingleContestModel extends ChangeNotifier {
  MProblemModel mProblemModel = MProblemModel();
  Status status = Status();
  MUser mUser = MUser();
  int routeId = 0;

  //坏处就是存在冗余数据,因为这里是一个为了管理下面的路由的一个中间节点，所以它本身是不应该有数据的，而且这里依赖了上层的数据，
  //就会导致上层数据更新了，这里也无法获取到.
  //好处就是下面的路由的各个方法需要上层的数据不用每次都请求一遍,
  //所以这里的冗余数据的存在原则就是 ：上层不会对该数据更新，下层需要多次使用该数据.
  //没有页面的更新直接依赖于contestId，所以不需要专门设置一个方法来notifyListeners
  late String contestId;

  void setContestId(String id) {
    contestId = id;
    notifyListeners();
  }

  //切换路由
  Future<void> switchRouteId(int id, String startTime) async {
    if (routeId != id) {
      routeId = id;
      if (routeId == 1) {
        await statusOperate(false);
      } else if (routeId == 2 || routeId == 4) {
        await userOperate(0, [false, startTime]);
      }
      notifyListeners();
    }
  }

//  =================================problem==========================================
  Future<dynamic> problemOperate(int funcType, int num, String str) async {
    dynamic flag = false;
    if (funcType == 0) {
      mProblemModel.switchProblemId(num);
    } else if (funcType == 1) {
      flag = await mProblemModel.requestProblemList(contestId);
    } else if (funcType == 2) {
      // flag = await mProblemModel.changeProblemData(contestId, num, str);
    } else if (funcType == 3) {
      flag = await mProblemModel.createANewProblem(contestId, str);
    } else if (funcType == 4) {
      flag = await mProblemModel.deleteAProblem(contestId);
    } else if (funcType == 5) {
      //这里是int类型，应该没事的吧
      flag = await mProblemModel.uploadFiles(contestId, num);
    }
    notifyListeners();
    return flag;
  }

  Future<bool> changeProblemData(List<String> list) async {
    bool flag = await mProblemModel.changeProblemData(contestId, list);
    notifyListeners();
    return flag;
  }

//  =================================status==========================================

  Future<bool> statusOperate(bool refresh) async {
    List<String> list =
        List.generate(mProblemModel.problemList.length, (index) {
      return mProblemModel.problemList[index].problemId;
    });
    bool flag = await status.requestSubmitsInfo(contestId, refresh, list);
    notifyListeners();
    return flag;
  }

  //FIXME 该方法的正确性未测试
  Future<bool> statusDownloadCodeFile(int showStatusId) async {
    bool flag = await status.downloadCodeFile(contestId, showStatusId);
    notifyListeners();
    return flag;
  }

  void statusFilter({int option = 0}) {
    status.filter(option);
    notifyListeners();
  }

//  =================================user==========================================
  Future<dynamic> userOperate(int funcType, List<dynamic> args) async {
    dynamic flag = false;
    if (funcType == 0) {
      List<String> problem =
          List.generate(mProblemModel.problemList.length, (index) {
        return mProblemModel.problemList[index].problemId;
      });
      flag = await mUser.requestUsersInfo(contestId, args[0], problem, args[1]);
    } else if (funcType == 1) {
      mUser.rankSearchSort();
    } else if (funcType == 2) {
      mUser.userSearchSort();
    } else if (funcType == 3) {
      List<String> problem =
          List.generate(mProblemModel.problemList.length, (index) {
        return mProblemModel.problemList[index].problemId;
      });
      List<String> tempList = [];
      for (int i = 1; i < args.length; i++) {
        tempList.add(args[i]);
      }
      flag = await mUser.userOperate(contestId, args[0], tempList,
          problem: problem);
    } else if (funcType == 4) {
      flag = await mUser.addUsersFromFile(contestId);
    }
    notifyListeners();
    return flag;
  }
}
