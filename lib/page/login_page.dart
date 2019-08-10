import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:skyroad/common/conf/config.dart';
import 'package:skyroad/common/dao/user_dao.dart';
import 'package:skyroad/common/redux/gosund_state.dart';
import 'package:skyroad/common/utils/common_utls.dart';
import 'package:skyroad/common/utils/local_storage.dart';
import 'package:skyroad/page/forgot_passwd.dart';
import 'package:skyroad/page/main_page.dart';
import 'package:skyroad/page/register_login.dart';
import 'package:skyroad/widget/gosund_button.dart';
import 'package:skyroad/widget/password_widget.dart';

class LoginPage extends StatefulWidget {
  static final String sName = "login";

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailFieldKey =
      GlobalKey<FormFieldState<String>>();
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();
  String _userName = "";
  String _password = "";
  bool _autovalidate = false;

  initParams() async {
    _userName = await LocalStorage.get(Config.KEY_USER_NAME);
    _password = await LocalStorage.get(Config.KEY_PW);
    userController.value = TextEditingValue(text: _userName ?? '');
    pwController.value = TextEditingValue(text: _password ?? '');
  }

  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GosundState>(
        onInit: (store) {
          ///第一次启动会调用,初始化Store是调用
          print("第一次启动会调用,初始化Store是调用");
        },
        onInitialBuild: (store) {
          ///第一次构建widget时调用
          print("第一次构建widget时调用");
        },

        ///当Store、widget全部更新完成就好调用
        onDidChange: (store) {
          print("当Store、widget全部更新完成就好调用");
        },

        /// StoreBuilder被移除Widget树的时候调用
        onDispose: (store) {
          print("StoreBuilder被移除Widget树的时候调用");
        },
//        Store变化之后、Widget更新之前
        onWillChange: (store) {
          print("Store变化之后、Widget更新之前");
        },

        ///控制插件Store更新是widget是否会更正更新
        rebuildOnChange: true,
        builder: (context, store) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: new IconButton(
                icon: new Container(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(Icons.arrow_back),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => RegisterLogin()));
                },
              ),
              title: Text(CommonUtils.getLocale(context).login),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50, top: 50),
                      child: FlutterLogo(
                        size: 100,
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        Form(
                            key: _formKey,
                            autovalidate: _autovalidate,
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: userController,
                                    key: _emailFieldKey,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      filled: true,
                                      hintText: CommonUtils.getLocale(context)
                                          .userName_tip,
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    validator: _validatorUserName,
//                        keyboardType: TextInputType.emailAddress,
                                    onSaved: (String value) {
                                      setState(() {
                                        _userName = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  PasswordField(
                                    validator: _validatorPassword,
                                    controller: pwController,
                                    fieldKey: _passwordFieldKey,
                                    hintText: CommonUtils.getLocale(context)
                                        .passwd_hittext,
                                    helperText: CommonUtils.getLocale(context)
                                        .password_length,
                                    labelText: CommonUtils.getLocale(context)
                                        .passwd_hittext,
                                    onSaved: (String value) {
                                      setState(() {
                                        _password = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: GosundButton(
                            child: Text(CommonUtils.getLocale(context).login),
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                _autovalidate = true;
                                CommonUtils.showLoadingDialog(context);
                                UserDao.login(_userName?.trim(),
                                        _password?.trim(), store)
                                    .then((res) {
                                  if (res?.data.code == 200 &&
                                      res?.data.result) {
//                              todo获取用户设备列表，如果网络异常，处理方式、如果设备列表为空进入添加设备页面，如果列表不为空进入主界面显示
                                    Future.delayed(Duration(seconds: 2))
                                        .then((value) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainPage()));
                                    });
                                  } else if (res?.code == 400) {
                                    Navigator.pop(context);
                                    showInSnackBar(res
                                        ?.data?.data['non_field_errors']
                                        ?.toString());
                                  }
                                }).catchError((onError) {
                                  Navigator.pop(context);
                                  showInSnackBar(CommonUtils.getLocale(context)
                                      .password_error);
                                });
                              } else {
                                showInSnackBar(CommonUtils.getLocale(context)
                                    .usrname_password_validate);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: GosundButton(
                            child: Text(
                              CommonUtils.getLocale(context).forgot_tip,
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                          ),
                        ),
                      ],
                    )),
                //方便布局站位
              ],
            ),
          );
        });
  }

  void showInSnackBar(String value) {
    _scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  ///验证邮箱字段
  String _validatorUserName(String value) {
    final FormFieldState<String> emailFieldKey = _emailFieldKey.currentState;
    if (emailFieldKey.value == null || emailFieldKey.value.isEmpty)
      return CommonUtils.getLocale(context).validate_input_phone_email;

    RegExp phoneExp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (!(CommonUtils.regEmail(emailFieldKey.value) ||
        phoneExp.hasMatch(value))) {
      return CommonUtils.getLocale(context).validate_input_phone_email;
    }
    if (emailFieldKey.value != value)
      return CommonUtils.getLocale(context).validate_imput_passwd_match;
    _userName = emailFieldKey.value;
    return null;
  }

  String _validatorPassword(String value) {
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return CommonUtils.getLocale(context).validate_input_password;
    if (passwordField.value.length < 8 || passwordField.value.length > 20)
      return CommonUtils.getLocale(context).validate_imput_length;
    if (passwordField.value != value)
      return CommonUtils.getLocale(context).validate_imput_passwd_match;
    _password = passwordField.value;
    return null;
  }
}
