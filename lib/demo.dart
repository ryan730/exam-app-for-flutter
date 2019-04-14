import 'package:flutter/material.dart';
import 'dart:math';

class RadioADemo extends StatefulWidget {
  final String title;
  final Map exam;
  final Map total;
  final parant;

  const RadioADemo(
  {
    Key key,
    @required this.title,
    @required this.exam,
    @required this.total,
    @required this.parant,
  }) : super(key: key);

  @override
  //State<StatefulWidget> createState() =>_Demo();
  RadioADemoState createState() =>RadioADemoState();
}

class RadioADemoState extends State<RadioADemo> {
  int groupValue = 0;
  int isRight = 0;
  List<bool> isChecks=[false,false,false,false];
  List<String> isRightArr=['to do','to doing','doing'];

  onChange(int) {
    if (int == -1) {
      isChecks = [false, false, false, false];
      isRight = 0;
    } else if (int >= 0) {
      isChecks[int] = !isChecks[int];
      List result = [];
      for (var i = 0; i < isChecks.length; i++) {
        if (isChecks[i]) {
          result.add(isRightArr[i]);
        }
      }
      //print('${widget.exam['rightKey']}====${result.join('/')}');
      if (result.join('/') == '') {
        isRight = 0;
      } else {
        isRight = (result.join('/') == '${widget.exam['rightKey']}') ? 1 : -1; // 和答案做匹配,获取正确值
      }
      var index = double.parse(widget.title).toInt();
      if (!(widget.total[index] is Map)) { // 缓存对象到外部total，listView 在disappear 时，清空 item 的状态
        widget.total[index] = {
          'master': this,
        };
      }
    }

    if(mounted) {
      setState((){});
      widget.parant.setState((){});
    }
  }

  @override
  void initState() {
    super.initState();
    var index = double.parse(widget.title).toInt();
    if(widget.total is Map && widget.total[index] is Map){
      isChecks = widget.total[index]['master'].isChecks;
      isRight = widget.total[index]['master'].isRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('--------->>>');
    return (
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 0.0, bottom: 5.0),
            decoration:BoxDecoration(
              border:Border.all(color: Colors.black26)
            ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 18.0),
                child:Text('序列号：${widget.title}',style: TextStyle(fontSize: 14.0)),
                decoration:BoxDecoration(
                  color: this.isRight == 0 ? null : this.isRight == 1
                      ? Colors.pinkAccent
                      : Colors.grey,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 18.0),
                  child:Text(widget.exam['word'],style: TextStyle(fontSize: 24.0)),
                  decoration:BoxDecoration(
                    color: this.isRight == 0 ? null : this.isRight == 1
                        ? Colors.pinkAccent
                        : Colors.grey,
                  ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width/3.2,
                        alignment: Alignment.centerLeft,
                        child: CheckboxListTile(
                          title: Text("to do"),
                          value: this.isChecks[0],
                          onChanged:(bool){this.onChange(0);},
                          dense: true,// 文字是否对齐 图标高度
                          isThreeLine: false,// 文字是否三行显示
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        )
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width/3,
                        alignment: Alignment.centerLeft,
                        child: CheckboxListTile(
                          title: Text("to doing"),
                          value:  this.isChecks[1],
                          onChanged:(bool){this.onChange(1);},
                          dense: true,// 文字是否对齐 图标高度
                          isThreeLine: false,// 文字是否三行显示
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        )
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width/3,
                        alignment: Alignment.centerLeft,
                        child: CheckboxListTile(
                          title: Text("doing"),
                          value:  this.isChecks[2],
                          onChanged:(bool){this.onChange(2);},
                          dense: true,// 文字是否对齐 图标高度
                          isThreeLine: false,// 文字是否三行显示
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        )
                    )
                  ])
            ])
    ));
  }
}
