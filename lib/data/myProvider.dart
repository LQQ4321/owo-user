import 'package:flutter/material.dart';

//感觉上面的顺序不太对

//1.dataModel.notifyListeners()被调用
//2.绑定在该数据上的oldWidget.data.update()方法会被调用
//3.update方法中的setState((){})会被执行
//4.从而导致ChangeNotifierProvider重新构建
//5.didUpdateWidget方法会被执行 : 给新的数据(widget.data)绑定update方法，给旧的数据(oldWidget.data)移除update方法

//  dataModel得到更新，widget还没更新

//6.因为_ChangeNotifierProviderState的build方法得到重新执行
//7.该方法中的InheritedProvider也会得到重新构建，然后updateShouldNotify方法也会运行
//8.返回true，表示依赖该数据的组件应该更新

// widget此时也得到更新，或者说重新创建的数据渲染在widget上了



//一个通用的InheritedWidget，保存需要跨组件共享的状态
class InheritedProvider<T> extends InheritedWidget {
  InheritedProvider({required this.data, required Widget child})
      : super(child: child);
  final T data;

  @override
  bool updateShouldNotify(InheritedProvider<T> oldWidget) {
    return true;
  }
}

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  ChangeNotifierProvider({Key? key, required this.data, required this.child});
  final Widget child;
  final T data;
  static T of<T>(BuildContext context, {bool listen = true}) {
    // final type = _typeOf<InheritedProvider<T>>();
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>()
        : context
        .getElementForInheritedWidgetOfExactType<InheritedProvider<T>>()
        ?.widget as InheritedProvider<T>;
    // final provider =
    //     context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
    return provider!.data;
  }

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    //  如果数据发生变化(model类调用了notifyListeners)，重新构建InheritedProvider
    setState(() {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    //  当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    //  这里有点问题，如果调用了notifyListeners，但是widget.data == oldWidget.data,
    //  那新的数据widget.data岂不是没有绑定update方法，那新的数据不是调用不了notifyListeners方法了？？？
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    //给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    //移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider(data: widget.data, child: widget.child);
  }
}

class MyConsumer<T> extends StatelessWidget {
  const MyConsumer({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext context, T? value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      ChangeNotifierProvider.of<T>(context),
    );
  }
}

// class MyConsumer<T> extends StatefulWidget {
//   MyConsumer({Key? key, required this.builder}) : super(key: key);
//   final Widget Function(BuildContext context, T? value) builder;
//   @override
//   _MyConsumerState<T> createState() => _MyConsumerState<T>();
// }
//
// class _MyConsumerState<T> extends State<MyConsumer> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.builder(context, ChangeNotifierProvider.of<T>(context));
//   }
// }