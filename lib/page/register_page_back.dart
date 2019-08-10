/**
 *
 * Project Name: SkyRoad
 * Package Name: page
 * File Name: register_page
 * USER: Aige
 * Create Time: 2019-08-03-11:52
 *
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skyroad/common/conf/config.dart';
import 'package:skyroad/common/dao/user_dao.dart';
import 'package:skyroad/common/utils/common_utls.dart';
import 'package:skyroad/common/utils/local_storage.dart';
import 'package:skyroad/page/register_login.dart';
import 'package:skyroad/widget/gosund_button.dart';
import 'package:skyroad/widget/password_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

enum RegisterType { email, mobile }

class UserData {
  String code = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formPhoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formEmialKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailFieldKey =
      GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _phoneFieldKey =
      GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> _codeFieldKey =
      GlobalKey<FormFieldState<String>>();
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();
  RegisterType _registerType = RegisterType.mobile;
  int registerFlex = 3;
  bool check = false;

  UserData _userData = UserData();

  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Container(
            padding: EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_back),
          ),
          onPressed: () {
            setState(() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => RegisterLogin()));
            });
          },
        ),
        title: Text(CommonUtils.getLocale(context).register),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: FlutterLogo(
                  size: 100,
                ),
              )),
          Expanded(
            flex: registerFlex,
            child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: _registerType == RegisterType.mobile
                    ? _buildMobileView()
                    : _buildEmailView()),
          ),
          Expanded(
              flex: 6,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 20, top: 5, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Text(
                            '手机号码登录',
                            style: TextStyle(
                                fontSize: 14, color: Colors.greenAccent),
                          ),
                          onTap: () {
                            setState(() {
                              _registerType = RegisterType.mobile;
                              registerFlex = 3;
                            });
                          },
                        ),
                        InkWell(
                          child: Text('邮箱注册',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.greenAccent)),
                          onTap: () {
                            setState(() {
                              _registerType = RegisterType.email;
                              registerFlex = 2;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Text(CommonUtils.getLocale(context).passwd_tip),
                  _buildPrivacy(),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GosundButton(
                      child:
                          Text(CommonUtils.getLocale(context).create_account),
                      onTap: () {
                        _createAccount();
                      },
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildEmailView() {
    return Form(
        key: _formEmialKey,
        autovalidate: _autovalidate,
        child: Column(
          children: <Widget>[
            TextFormField(
              key: _emailFieldKey,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                filled: true,
                hintText: "email",
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              onSaved: (String value) {
                _userData.email = value;
              },
            ),
            SizedBox(
              height: 15,
            ),
            PasswordField(
              fieldKey: _passwordFieldKey,
              hintText: 'password',
              helperText: '8~128 characters.',
              labelText: 'Password *',
              validator: _validatePassword,
              onSaved: (String value) {
                setState(() {
                  _userData.password = value;
                });
              },
            ),
          ],
        ));
  }

  Widget _buildMobileView() {
    return Column(
      children: <Widget>[
        Form(
            key: _formPhoneKey,
            autovalidate: _autovalidate,
            child: Container(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: userController,
                    key: _phoneFieldKey,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      filled: true,
                      hintText: "phone/email",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: _validatePhone,
                    // TextInputFormatters are applied in sequence.
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      // Fit the validating format.
//                      _phoneNumberFormatter,
                    ],

                    keyboardType: TextInputType.phone,

                    onSaved: (String value) {
                      setState(() {
                        _userData.email = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        key: _codeFieldKey,
                        keyboardType: TextInputType.number,
                        validator: _validateCode,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            fillColor: Colors.blue.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_phoneFieldKey.currentState.validate()) {
                          UserDao.getCode(
                              _phoneFieldKey.currentState.value.trim());
                        }
                      },
                      child: Text('获取验证码'),
                    )
                  ]),
                  SizedBox(
                    height: 18,
                  ),
                  PasswordField(
                    validator: _validatePassword,
                    controller: pwController,
                    fieldKey: _passwordFieldKey,
                    hintText: 'password',
                    helperText: '8~128 characters.',
                    labelText: 'Password *',
                    onSaved: (String value) {
                      setState(() {
                        _userData.password = value;
                      });
                    },
                  ),
                ],
              ),
            )),
      ],
    );
  }

  ///构建隐私策略
  _buildPrivacy() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Checkbox(
            value: check,
            activeColor: Colors.blue,
            onChanged: (bool val) {
              setState(() {
                check = val;
              });
            },
          ),
          Text('By creating account,you agree to the '),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Text('Term of Use',
                  style: TextStyle(color: Colors.greenAccent)),
              onTap: () {
//                  打开团队简介
              },
            ),
            Text('  and '),
            InkWell(
              child: Text('Privicy Policy',
                  style: TextStyle(color: Colors.greenAccent)),
              onTap: () {},
            )
          ],
        )
      ],
    );
  }

  //创建账号
  _createAccount() {
    if (check) {
      if (_registerType == RegisterType.mobile) {
        if (!_formPhoneKey.currentState.validate()) {
          _autovalidate = true; // Start validating on every change.
          showInSnackBar('Please fix the errors in red before submitting.');
        } else {
          LocalStorage.save(Config.KEY_USER_NAME, _userData.email);
          LocalStorage.save(Config.KEY_PW, _userData.password);
//          注册成功VerifyAccount
//        Navigator.pushReplacement(
//            context, MaterialPageRoute(builder: (context) => VerifyAccount()));
        }
      } else if (_registerType == RegisterType.email) {
        final FormState form = _formEmialKey.currentState;
        if (!form.validate()) {
          _autovalidate = true; // Start validating on every change.
          showInSnackBar('Please fix the errors in red before submitting.');
        } else {
          form.save();
          CommonUtils.showLoadingDialog(context);
//          UserDao.register(_userData.email, _userData.password).then((res) {
//            Navigator.pop(context);
//            if (!res?.result) {
////          print(runtimeType);
//              showInSnackBar(res?.data?.data["non_field_errors"].toString());
//            } else {
//              LocalStorage.save(Config.KEY_USER_NAME, _userData.email);
//              LocalStorage.save(Config.KEY_PW, _userData.password);
////          注册成功VerifyAccount
//              Navigator.pushReplacement(context,
//                  MaterialPageRoute(builder: (context) => VerifyAccount()));
////          print(res.data);
//            }
//          });
        }
      }
    } else {
      showInSnackBar('请先确认隐私策略');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  ///验证邮箱字段
  String _validateEmail(String value) {
    final FormFieldState<String> emailFieldKey = _emailFieldKey.currentState;
    if (emailFieldKey.value == null || emailFieldKey.value.isEmpty)
      return 'Please enter a email.';
    if (!CommonUtils.regEmail(emailFieldKey.value)) {
      return 'Please enter a aaa email.';
    }
    if (emailFieldKey.value != value) return 'The passwords don\'t match';
    _userData.email = emailFieldKey.value.trim();
    return null;
  }

  ///验证电话号码
  String _validatePhone(String value) {
    RegExp phoneExp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (!phoneExp.hasMatch(value))
      return '(###) ###-#### - Enter a US phone number.';
    return null;
  }

  String _validatePassword(String value) {
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value.length < 8 || passwordField.value.length > 20)
      return 'minLength>8 ,MaxLength <20.';
    if (passwordField.value != value) return 'The passwords don\'t match';
    _userData.password = passwordField.value.trim();
    return null;
  }

//  验证码
  String _validateCode(String value) {
    final FormFieldState<String> passwordField = _codeFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a Code.';
    if (passwordField.value.length != 8) return 'Code error';
    _userData.code = passwordField.value.trim();
    return null;
  }
}
