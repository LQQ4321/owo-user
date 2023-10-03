import 'package:flutter/material.dart';
import 'package:owo_user/data/dataFive.dart';
import 'package:owo_user/data/myProvider.dart';

class News extends StatefulWidget {
  const News({Key? key, required this.editingController}) : super(key: key);
  final TextEditingController editingController;

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      margin: const EdgeInsets.only(left: 120, right: 120),
      child: Column(
        children: [
          Expanded(child: _Info()),
          Container(height: 1,color: Colors.white),
          _InputField(textEditingController: widget.editingController),
        ],
      ),
    );
  }
}


class _Info extends StatefulWidget {
  const _Info({Key? key}) : super(key: key);

  @override
  State<_Info> createState() => _InfoState();
}

class _InfoState extends State<_Info> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


// class _Info extends StatelessWidget {
//   _Info({Key? key}) : super(key: key);
//   ScrollController _scrollController = ScrollController();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView.builder(
//           controller: _scrollController,
//           itemCount: 100,
//           itemBuilder: (BuildContext context,int index){
//         return Container(
//           height: index % 2 == 0 ? 100 : 10,
//           margin: const EdgeInsets.only(left: 10,right: 10),
//           color: index % 2 == 0 ? Colors.lightBlueAccent : Colors.grey,
//         );
//       }),
//     );
//   }
// }



class _InputField extends StatefulWidget {
  const _InputField({Key? key, required this.textEditingController})
      : super(key: key);
  final TextEditingController textEditingController;

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  Color _color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  if (hasFocus) {
                    _color = Colors.lightBlueAccent;
                  } else {
                    _color = Colors.grey;
                  }
                });
              },
              child: TextField(
                controller: widget.textEditingController,
                maxLines: 3,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText:
                        'Please enter a text of less than 500 characters.',
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          )),
          Container(width: 1, height: 100,color: Colors.grey),
          const SizedBox(width: 10, height: 100),
          SizedBox(
              width: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(80, 60))),
                child: const Icon(Icons.send),
              )),
          const SizedBox(width: 10, height: 100),
        ],
      ),
    );
  }
}
