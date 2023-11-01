import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/manager/managers.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/widgetTwo.dart';

//管理员界面,如果不是超级管理员，那就没有必要显示该界面
class Managers extends StatelessWidget {
  const Managers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ManagerItem> managerList =
        ChangeNotifierProvider.of<ManagerModel>(context).managerList;
    List<TextEditingController> textEditingControllers =
        List.generate(2, (index) => TextEditingController());
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('List of Manager',
                  style: TextStyle(
                      color: Color(0xff06174f),
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              ElevatedButton(
                  onPressed: () async {
                    int isRoot = 0;
                    bool isConfirm = false;
                    callBack(int option) {
                      isRoot = option;
                    }

                    callBack2(bool flag) {
                      isConfirm = flag;
                    }

                    //在提交表单之前，检查输入的格式是否正确
                    checkFormal<bool>() {
                      if (textEditingControllers[0].text.isEmpty ||
                          textEditingControllers[1].text.isEmpty) {
                        return false;
                      }
                      if (textEditingControllers[0].text.contains(' ') ||
                          textEditingControllers[1].text.contains(' ')) {
                        return false;
                      }
                      return true;
                    }

                    await WidgetTwo.addNewManager(
                        context,
                        textEditingControllers,
                        [callBack, callBack2, checkFormal]);
                    if (!isConfirm) {
                      return;
                    }
                    bool flag =
                        await ChangeNotifierProvider.of<ManagerModel>(context)
                            .addManager([
                      textEditingControllers[0].text,
                      textEditingControllers[1].text,
                      (isRoot == 1).toString()
                    ]);
                    if (flag) {
                      MyDialogs.oneToast(
                          ['Operate succeed', 'Add a new manager succeed'],
                          duration: 5);
                    } else {
                      MyDialogs.oneToast(
                          ['Operate fail', 'Add a new manager fail'],
                          duration: 5, infoStatus: 2);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xff00ca80))),
                  child: const Text(
                    'Add new manager',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ))
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: List.generate(MConstantData.managerInfo.length, (index) {
              return Expanded(
                  flex: MConstantData.managerInfoRatio[index],
                  child: Center(
                    child: Text(
                      MConstantData.managerInfo[index],
                      style: const TextStyle(
                          color: Color(0xffa3adb9),
                          fontWeight: FontWeight.w500,
                          fontSize: 11),
                    ),
                  ));
            }),
          ),
          const SizedBox(height: 5),
          Container(height: 1, color: const Color(0xff4454a1)),
          Expanded(
              child: ListView.builder(
                  itemCount: managerList.length,
                  itemExtent: 60,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        color: index % 2 == 0
                            ? const Color(0xfff7f8fc)
                            : Colors.white,
                        child: _ManagerCell(managerId: index));
                  }))
        ],
      ),
    );
  }
}

class _ManagerCell extends StatelessWidget {
  const _ManagerCell({Key? key, required this.managerId}) : super(key: key);
  final int managerId;

  @override
  Widget build(BuildContext context) {
    ManagerItem managerItem =
        ChangeNotifierProvider.of<ManagerModel>(context).managerList[managerId];
    List<String> list = [];
    list.add(managerItem.managerName);
    list.add(managerItem.password);
    list.add(managerItem.createContestNumber.toString());
    list.add(managerItem.isLogin ? 'Yes' : 'No');
    list.add(managerItem.isRoot ? 'Yes' : 'No');
    list.add(managerItem.lastLoginTime);
    return Row(
      children: List.generate(MConstantData.managerInfoRatio.length, (index) {
        return Expanded(
          flex: MConstantData.managerInfoRatio[index],
          child: Builder(builder: (context) {
            TextEditingController textEditingController =
                TextEditingController();
            check<bool>() {
              if (textEditingController.text.isEmpty ||
                  textEditingController.text.contains(' ')) {
                return false;
              }
              return true;
            }

            bool isConfirm = false;
            callBack(bool flag) {
              isConfirm = flag;
            }

            if (index < MConstantData.managerInfoRatio.length - 2) {
              return Align(
                alignment: Alignment.center,
                child: index < 2
                    ? TextButton(
                        onPressed: () async {
                          await WidgetTwo.changeSingleData(
                              context,
                              ['Change Data', 'name', 'lqq'],
                              textEditingController,
                              [callBack, check]);
                          if (!isConfirm) {
                            return;
                          }
                          bool flag =
                              await ChangeNotifierProvider.of<ManagerModel>(
                                      context)
                                  .changeManagerInfo(managerItem.managerName,
                                      textEditingController.text, index == 0);
                          if (flag) {
                            MyDialogs.oneToast([
                              'Operate succeed',
                              'Change info of manager succeed'
                            ], duration: 5);
                          } else {
                            MyDialogs.oneToast(
                                ['Operate fail', 'Change info of manager fail'],
                                duration: 5);
                          }
                        },
                        child: Text(
                          list[index],
                          style: TextStyle(
                              color: judgeColor(index, list[index]),
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ))
                    : Text(
                        list[index],
                        style: TextStyle(
                            color: judgeColor(index, list[index]),
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                      ),
              );
            } else if (index == MConstantData.managerInfoRatio.length - 2) {
              return Center(
                child: !list[index].contains(' ')
                    ? null
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            list[index].split(' ')[1],
                            style: const TextStyle(
                                color: Color(0xff1b224e),
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            list[index].split(' ')[0],
                            style: const TextStyle(
                                color: Color(0xffbabcd1),
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
              );
            }
            return managerItem.isRoot
                ? Container()
                : Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          await WidgetTwo.confirmInfoDialog(
                              context,
                              [
                                'Delete Operate',
                                'Are you sure to delete manager ${managerItem.managerName} ?'
                              ],
                              callBack);
                          if (!isConfirm) {
                            return;
                          }
                          bool flag =
                              await ChangeNotifierProvider.of<ManagerModel>(
                                      context)
                                  .deleteManager(managerItem.managerName);
                          if (flag) {
                            MyDialogs.oneToast([
                              'Operate Succeed',
                              'Administrator ${managerItem.managerName} has been deleted'
                            ], duration: 5);
                          } else {
                            MyDialogs.oneToast([
                              'Operate Fail',
                              'Description Failed to delete administrator ${managerItem.managerName}'
                            ], duration: 5);
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red)),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        )));
          }),
        );
      }),
    );
  }

  Color judgeColor(int index, String text) {
    if ((index == 3 || index == 4) && text == 'Yes') {
      return Colors.green;
    }
    return const Color(0xff1b224e);
  }
}
