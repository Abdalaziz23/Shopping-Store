import 'package:flutter/material.dart';
import 'package:shop_app/modules/shop_login/shop_login_screen.dart';
import 'package:shop_app/shared/components/component.dart';
import 'package:shop_app/shared/components/constant.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel{
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}
class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //const OnBoardingScreen({Key? key}) : super(key: key);
  var boardController = PageController();

  List<BoardingModel> boarding =[
    BoardingModel(
        image: 'assets/images/image.jpg',
        title: 'On Board 1 Title',
        body: 'On Board 1 body',
    ),
    BoardingModel(
        image: 'assets/images/image.jpg',
        title: 'On Board 2 Title',
        body: 'On Board 2 body',
    ),
    BoardingModel(
        image: 'assets/images/image.jpg',
        title: 'On Board 3 Title',
        body: 'On Board 3 body',
    ),
  ];
  bool isLast = false;
  void submit()
  {
    CacheHelper.savedData(key: 'onBoarding', value: true).then((value) {
      if(value){
        navigateAndFinish(context,ShopLoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: 16.0,
            ),
            child: TextButton(
                onPressed: submit,
                child: Text(
                  'SKIP',
                ),
            ),
          ),
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children:
          [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context,index) =>buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (int index)
                {
                  if(index == boarding.length-1)
                    {
                      setState(() {
                        isLast = true;
                      });
                    }else{
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      expansionFactor: 4,
                      spacing: 5.0,
                      activeDotColor: defaultColor,
                    ),
                    count: boarding.length,
                ),
                Expanded(child: Container()),
                FloatingActionButton(
                  onPressed: ()
                  {
                    if(isLast)
                    {
                      submit();
                    }else{
                      boardController.nextPage(
                        duration:  Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage(
            model.image,
          ),
          fit: BoxFit.fill,
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      Text(
        model.title,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Pacifico',
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      Text(
        model.body,
        style: TextStyle(
          fontFamily: 'Pacifico',
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
