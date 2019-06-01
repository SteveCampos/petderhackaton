import 'package:flutter/material.dart';

final colorList = [
  Colors.redAccent.shade100,
  Colors.blueAccent.shade100,
  Colors.amber.shade50
];


class CardAnimation extends StatefulWidget {
  @override
  _CardAnimationState createState() => _CardAnimationState();
}

class _CardAnimationState extends State<CardAnimation> with SingleTickerProviderStateMixin {
  int currentPage = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            color: colorList[currentPage],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 400.0,
                child: PageView.builder(
                    itemBuilder: (context,index){
                      return itemBuilder(index);
                    },
                  controller: _pageController,
                  pageSnapping: true,
                  //onPageChanged: _onPageChanged,
                  itemCount: 3,
                  physics: ClampingScrollPhysics(),
                ),
              )
              //_detailsBuilder(currentPage),
            ],
          )
        ],
      ),
    );
  }

  Widget _detailsBuilder(index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child){
        double value = 1;
        if (_pageController.position.haveDimensions){
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
        }
        return Expanded(
          child: Transform.translate(
            offset: Offset(0, 100 + (-value * 100)),
            child: Opacity(
                opacity: value,
                child: Container(
                  padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text("TITULO 1",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 20.0),
                      Text("DESCRIPCION 1",
                      style: TextStyle(fontSize: 18.0)),
                      SizedBox(height: 30.0),
                      Container(
                        width: 80.0,
                        height: 5.0,
                        color: Colors.black,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Read More",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900
                        ),
                      )
                    ],
                  ),
                ) ,
            ),
          ),
        );
      },
    );
  }

  Widget itemBuilder(index){

  }

}
