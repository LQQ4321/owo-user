import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/dataFour.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/funcOne.dart';

class Status extends StatelessWidget {
  const Status({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<OneSubmit> submitList =
        ChangeNotifierProvider.of<SubmitModel>(context).submitList;
    return Center(
      child: Container(
        width: 800,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0)
            ]),
        child: Column(
          children: [
            Container(
              height: 30,
              margin: const EdgeInsets.only(left:15,right: 15),
              color: Colors.grey[200],
              child: Row(
                children:
                    List.generate(ConstantData.statusTitles.length, (index) {
                  return Expanded(
                      flex: (index == 2 || index == 4) ? 2 : 1,
                      child: Center(
                        child: Text(
                          ConstantData.statusTitles[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ));
                }),
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 45,
                        margin: const EdgeInsets.only(left:15,right: 15),
                        child: Row(
                            children: List.generate(5, (rowIndex) {
                          String text = '';
                          if (rowIndex == 0) {
                            text = submitList[index].id;
                          } else if (rowIndex == 1) {
                            text = submitList[index].problemId;
                          } else if (rowIndex == 2) {
                            text = submitList[index].codeStatus;
                          } else if (rowIndex == 3) {
                            text = submitList[index].language;
                          } else {
                            text = submitList[index].submitTime;
                          }
                          return Expanded(
                              flex: (rowIndex == 2 || rowIndex == 4) ? 2 : 1,
                              child: Center(
                                child: Text(
                                  text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: rowIndex == 2
                                          ? FuncOne.getStatusColor(text)
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ));
                        })),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 1,
                          // margin: const EdgeInsets.only(right: 15),
                          color: Colors.grey);
                    },
                    itemCount: submitList.length))
          ],
        ),
      ),
    );
  }
}
