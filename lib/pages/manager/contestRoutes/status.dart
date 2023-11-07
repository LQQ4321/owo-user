import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/manager/contestRouteData/status.dart';
import 'package:owo_user/data/manager/singleContest.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/funcOne.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';
import 'package:owo_user/macroWidget/widgetThree.dart';

class MStatus extends StatelessWidget {
  const MStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int statusLength =
        ChangeNotifierProvider.of<SingleContestModel>(context)
            .status
            .showStatusList
            .length;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const _TopSortBar(),
          const SizedBox(height: 20),
          Row(
            children: List.generate(MConstantData.submitInfo.length, (index) {
              return Expanded(
                  flex: MConstantData.submitInfoFlex[index],
                  child: Center(
                    child: Text(
                      MConstantData.submitInfo[index],
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
                  itemExtent: 50,
                  itemCount: statusLength,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: index % 2 == 0
                          ? const Color(0xfff7f8fc)
                          : Colors.white,
                      child: _StatusCell(statusId: index),
                    );
                  }))
        ],
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({Key? key, required this.statusId}) : super(key: key);
  final int statusId;

  @override
  Widget build(BuildContext context) {
    StatusItem statusItem =
        ChangeNotifierProvider.of<SingleContestModel>(context)
            .status
            .showStatusList[statusId];
    return Row(
        children: List.generate(MConstantData.submitInfo.length, (index) {
      return Expanded(
          flex: MConstantData.submitInfoFlex[index],
          child: Builder(builder: (context) {
            if (index == 0 || index == 1) {
              String text = statusItem.submitTime;
              if (index == 1) {
                text = '${statusItem.studentNumber} ${statusItem.studentName}';
              }
              return SizedBox(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(2, (index) {
                  return Text(text.split(' ')[(index + 1) % 2],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: index == 0 ? Colors.black : Colors.black38,
                          fontSize: index == 0 ? 14 : 11,
                          fontWeight:
                              index == 0 ? FontWeight.w700 : FontWeight.w400));
                }),
              ));
            } else if (index == 2) {
              return Container(
                height: 30,
                width: 70,
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    color: FuncOne.getStatusColor(statusItem.status),
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: Text(
                    statusItem.status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            } else if (index == MConstantData.submitInfo.length - 1) {
              return Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.green.withAlpha(30),
                        hoverColor: Colors.grey[300],
                        highlightColor: Colors.blue,
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.file_download_outlined),
                        ),
                        onTap: () async {},
                      ),
                    ),
                  ),
                ),
              );
            }

            String text = '';
            if (index == 3) {
              text = statusItem.problemLetterId;
            } else if (index == 4) {
              text = '${statusItem.runTime} ms';
            } else if (index == 5) {
              text = '${statusItem.runMemory} MB';
            } else if (index == 6) {
              text = statusItem.language;
            } else if (index == 7) {
              text = '${statusItem.fileSize} KB';
            }
            return Center(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }));
    }));
  }
}

//筛选条件框
class _TopSortBar extends StatelessWidget {
  const _TopSortBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 300,
          height: 40,
          child: FilletCornerInput(
              //输入控制器不会因为更新而失去原来的值
              textEditingController: Status.searchController,
              iconData: Icons.search,
              hintText: 'Search Author',
              callBack: (a) {
                ChangeNotifierProvider.of<SingleContestModel>(context)
                    .statusFilter();
              }),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 120,
                child: MyPopupMenu(
                    list: const ['All', 'Accepted', 'Other'],
                    callBack: (a) {
                      ChangeNotifierProvider.of<SingleContestModel>(context)
                          .statusFilter(option: a + 1);
                    })),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                ChangeNotifierProvider.of<SingleContestModel>(context)
                    .statusOperate(true);
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith(
                      (states) => const Size(110, 40)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xff2db7f5))),
              child: const Text(
                'Refresh',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        )
      ],
    );
  }
}
