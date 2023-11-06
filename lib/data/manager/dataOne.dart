import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/contests.dart';
import 'package:owo_user/data/manager/managers.dart';
import 'package:owo_user/data/manager/singleContest.dart';

//将user和manager的数据分开管理,最好就是分别创建两个文件夹，然后都可以用得到的东西就提取出来
class MGlobalData extends ChangeNotifier {
  //程序的总标题栏
  String titleText = 'owo';

  // 关于导航栏左侧的返回按钮，每个模块都有一个根，不能通过返回按钮从一个根跳到另一个根，
  // 只能从当前模块的子节点跳到上一步的节点，最多只能跳到当前模块的根
  //表示主页面的模块，只表示根节点
  int leftButtonId = 0;

  //表示子节点
  int sonPageId = 0;

  //创建一个二维数组，第一维表示根页面节点，第二维表示页面子节点
  List<List<int>> pageStatus = List.generate(3, (index) {
    return [index];
  });

  //第一个参数是操作类型 0 表示返回上一步,1 表示切换页面
  void pageStatusManager(
      {required int option, int fatherPageId = 0, int sonPageId = 0}) async {
    if (option == 0) {
      if (pageStatus[leftButtonId].length == 1) {
        return;
      } else {
        pageStatus[leftButtonId].removeLast();
        this.sonPageId = pageStatus[leftButtonId].last;
      }
    } else if (option == 1) {
      if (leftButtonId == fatherPageId) {
        if (pageStatus[leftButtonId].last == sonPageId ||
            sonPageId == fatherPageId) {
          return;
        } else {
          pageStatus[leftButtonId].add(sonPageId);
          this.sonPageId = sonPageId;
          if (sonPageId == 3) {
            singleContestModel.setContestId(contestModel
                .showContestList[contestModel.selectContestId].contestId);
            await singleContestModel.problemOperate(1, 0, '');
          }
        }
      } else {
        leftButtonId = fatherPageId;
        this.sonPageId = sonPageId > pageStatus[leftButtonId].last
            ? sonPageId
            : pageStatus[leftButtonId].last;
        if (leftButtonId == 2) {
          await managerModel.requestManagers();
        } else if (leftButtonId == 1) {
          await contestModel.requestContestList(
              managerModel.curManager.managerName,
              managerModel.curManager.isRoot);
        }
      }
    }
    notifyListeners();
  }

  void changeTitleText(String text) {
    titleText = text;
    notifyListeners();
  }

  ManagerModel managerModel = ManagerModel();
  ContestModel contestModel = ContestModel();
  SingleContestModel singleContestModel = SingleContestModel();

  void cleanCacheData() {
    leftButtonId = 0;
    managerModel.cleanCacheData();
    notifyListeners();
  }

// 记得检查当前的输入数据是否合法
//  0 表示登录成功,1 表示输入格式错误,2 表示登录失败
  Future<void> login(String netPath, String managerName, String password,
      Function(int) callBack) async {
    //如果去除首末空格后，字符串变为空，此时应该返回输入格式错误
    if (netPath.isEmpty || managerName.isEmpty || password.isEmpty) {
      callBack(1);
      return;
    }
    //去除首尾空格后，如果字符串还包含空格，那么表明输入格式错误
    if (netPath.contains(' ') ||
        managerName.contains(' ') ||
        password.contains(' ')) {
      callBack(1);
      return;
    }

    if (!await managerModel.login([managerName, password], netPath)) {
      callBack(2);
    }
  }
}

//可以给每个模块都弄一个stack，然后点击左上角的 <- 按钮，可以回头上一步，每个模块前进的深度最大是 3
// (太深了，返回到主界面就需要点击太多的时间了，用户体验就会急剧下降)
//如 contest列表页面 -> 对应比赛的problem列表页面 -> 对应的题目页面(这里可以进行相应的题目配置)

//好吧，下面来简单列举一下manager的功能
// 1. 超级用户管理其他管理员的界面 : 所有的管理员(如果不是root用户，或许可以省略掉这个模块) -> 某个管理员的详细板块
// 2. 比赛界面 : contest列表页面 -> 对应比赛的problem列表页面 -> 对应的题目页面(这里可以进行相应的题目配置)
// 2.1  如果要显示比赛的排行榜，需要的空间也会更多一些,但是其实左侧导航栏和顶部标题栏消耗的空间不会太多，
// 所以感觉没有必要新开一个路由来专门显示排行榜(这样设计起来也会简单一些,滚榜所需的空间应该还是可以满足的,
// 但是滚榜时全屏只有榜单可能效果会好一点[不管了，暂时先不开新的路由了])
// 3. 其他功能暂时想不到，后续再说
