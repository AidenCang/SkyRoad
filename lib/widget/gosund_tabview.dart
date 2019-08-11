import 'package:flutter/material.dart';
import 'package:skyroad/navigator/chat_page.dart';
import 'package:skyroad/navigator/drawer_page.dart';
import 'package:skyroad/navigator/home_page.dart';
import 'package:skyroad/navigator/my_page.dart';
import 'package:skyroad/navigator/smart_page.dart';

class GosundTabView extends StatefulWidget {
  @override
  _GosundTabViewState createState() => _GosundTabViewState();
}

class _GosundTabViewState extends State<GosundTabView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;

  _renderTab(icon, text) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 26.0),
          Text(
            text,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: DrawerPage(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('homepageTabView'),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[HomePage(), SmartPage(), ChatPage(), MyPage()],
          onPageChanged: (index) {
            _tabController.animateTo(index);
          },
        ),
        bottomNavigationBar: Material(
          color: Colors.blue,
//          解决IPhoneX底部重叠问题
          child: SafeArea(
              child: TabBar(
//                去掉底部指示器
            indicator: const BoxDecoration(),
            controller: _tabController,
            tabs: [
              _renderTab(Icons.home, "home"),
              _renderTab(Icons.smartphone, "Smart"),
              _renderTab(Icons.chat, "chat"),
              _renderTab(Icons.memory, "My"),
            ],
            onTap: (index) {
//              _pageController.jumpTo(MediaQuery.of(context).size.width * index);
              _pageController.jumpToPage(index);
            },
          )),
        ));
  }
}
