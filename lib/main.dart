import 'package:flutter/material.dart';
import 'demo.dart';
import 'data.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    examData.data.shuffle();
    print('oooo====>>>${examData.data}');
    return MaterialApp(
      title: 'Flutter exam',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '不定式与分词-常用词汇-测试'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey scaffoldKey2 = GlobalKey();
  Map items = {}; // item key 的缓存池
  Map total = {}; // 引用计数器
  /// 重填
  void _clear(){
//    total.forEach((k, v) {
//       print("${k} is ${v['master']}");
//       v['master'].isChecks = [false, false, false, false];
//       v['master'].isRight = 0;
//       v['master'].onChange(-1); // 清空内部数据
//    });

//    total = {};
//    items.map((v){
//      if(v.currentState is RadioADemoState){
//        //print(v.currentState.onChange);
//        v.currentState.onChange(-1);
//      }
//    }).toList();
    total = {};
    items.forEach((k,v) {// 利用key 暴力清空所有 选择状态
      if(v.currentState is RadioADemoState){
        //print("${k} is ${v}");
        //print(v.currentState.onChange);
        v.currentState.onChange(-1);
      }
    });
  }
  /// 洗牌
  void _shuffle(){
    _clear();
    examData.data.shuffle();
    //new Future.delayed(const Duration(seconds: 1),(){
      this.setState((){});
    //});
  }
  /// 错误题目数量
  Map _count(){
    final List rarr = [];
    final List warr = [];
//    total.forEach((k, v) {
//     // print("${k} is ${v['master'].isRight}");
//      if(v['master'].isRight == -1){
//        rarr.add(-1);
//      }else if(v['master'].isRight == 1){
//        warr.add(0);
//      }
//    });
    items.forEach((k,v) {// 利用key 暴力清空所有 选择状态
      if(v.currentState is RadioADemoState){
        print(v.currentState.isRight);
        if(v.currentState.isRight == 1){
          rarr.add(1);
        }else if(v.currentState.isRight == -1){
          warr.add(-1);
        }
      }
    });
    return {'right':rarr.length,'wrong':warr.length};
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        duration: Duration(milliseconds: 4000),
        content: Text(
        'Version:0.0.1 \nAuthor: Ryan.zhu \nNotice: If your answer is right which will show the red background, otherwise it will show the grey background!')
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 1),(){
      _displaySnackBar(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map mcount = _count();
    final rText = '✅ 正确率: '+(mcount['wrong']).toString()+' / '+(examData.data.length).toString();
    final wText = '❎ 错题率: '+(mcount['right']).toString()+' / '+(examData.data.length).toString();
     return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            tooltip: '打乱顺序',
            onPressed: _shuffle,
            icon: Icon(Icons.extension)
          ),
        ],
      ),
//      body: Center(
//        child: ListView.custom(
//          scrollDirection: Axis.vertical,
//          childrenDelegate: SliverChildBuilderDelegate((BuildContext context, int index) {
//            return RadioADemo(
//                parant: this,
//                title: '$index',
//                exam: examData.data[index],
//                total: this.total);
//          },childCount: examData.data.length
//        ),
//        )
//      ),
      body: Center(
          child: ListView.builder(
              //key: _scaffoldKey2,
              itemCount: examData.data.length,
              //addAutomaticKeepAlives:false,
              //addRepaintBoundaries:false,
              itemBuilder: (BuildContext context, int index) {
                GlobalKey<RadioADemoState> key;
                if(this.items[examData.data[index]] is GlobalKey){
                  key= this.items[examData.data[index]];// 这里必须建立一个缓存池
                }else {
                  key= GlobalKey<RadioADemoState>();
                  this.items[examData.data[index]] = key;
                }

                var item = RadioADemo(
                    key:key,
                    parant: this,
                    title: '$index',
                    exam: examData.data[index],
                    total: this.total,
                );
                //print(key.currentWidget);
                return item;
              })
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton.extended(
        key: scaffoldKey2,
        onPressed: _clear,
        //onPressed:() => _displaySnackBar(context),
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        //如果不手动设置icon和text颜色,则默认使用foregroundColor颜色
        //icon:  Icon(Icons.flag,color: Colors.red),
        label:  Text('${rText}\n${wText}', maxLines: 2),
      )
    );
  }
}
