import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/manager/contests.dart';
import 'package:owo_user/data/manager/dataOne.dart';
import 'package:owo_user/data/manager/singleContest.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/pages/manager/contestRoutes/problem.dart';
import 'package:owo_user/pages/manager/contestRoutes/rank.dart';
import 'package:owo_user/pages/manager/contestRoutes/status.dart';
import 'package:owo_user/pages/manager/contestRoutes/user.dart';

//它的状态是 3
class SingleContest extends StatelessWidget {
  const SingleContest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const _TopBar(),
          const SizedBox(height: 10),
          const _MidRoute(),
          //剩下的空间如果全部归为一个模块，记得使用Expanded占据，否则子元素可能获取不到可用空间的大小
          Expanded(child: Builder(builder: (context) {
            int routeId =
                ChangeNotifierProvider.of<SingleContestModel>(context).routeId;
            if (routeId == 0) {
              return const ProblemRoute();
            } else if (routeId == 1) {
              return const MStatus();
            } else if (routeId == 2) {
              return const MRank();
            } else if(routeId == 4){
              return const MUserRoute();
            }
            return Container();
          })),
        ],
      ),
    );
  }
}

class _MidRoute extends StatelessWidget {
  const _MidRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int routeId =
        ChangeNotifierProvider.of<SingleContestModel>(context).routeId;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xffe7e8ec), width: 1.0))),
      child: Row(
        children: List.generate(MConstantData.contestRoutes.length, (index) {
          return Container(
            margin: const EdgeInsets.only(right: 50),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: routeId == index
                            ? MConstantData.fontColor[1]
                            : Colors.transparent,
                        width: 4.0))),
            child: TextButton(
              onPressed: () async {
                String startTime =
                    ChangeNotifierProvider.of<MGlobalData>(context)
                        .contestModel
                        .showContestList[
                            ChangeNotifierProvider.of<MGlobalData>(context)
                                .contestModel
                                .selectContestId]
                        .startTime;
                await ChangeNotifierProvider.of<SingleContestModel>(context)
                    .switchRouteId(index, startTime);
              },
              child: Text(
                MConstantData.contestRoutes[index],
                style: TextStyle(
                    color: MConstantData.fontColor[routeId == index ? 1 : 0],
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            ),
          );
        }),
      ),
    );
  }
}

//最上面的模块，暂时只能想到显示比赛名称
class _TopBar extends StatelessWidget {
  const _TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String contestName = ChangeNotifierProvider.of<ContestModel>(context)
        .showContestList[
            ChangeNotifierProvider.of<ContestModel>(context).selectContestId]
        .contestName;
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: Text(contestName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              )),
        ),
      ],
    );
  }
}
