import 'dart:convert';

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
import 'package:skyroad/page/verify_account.dart';
import 'package:skyroad/widget/gosund_button.dart';
import 'package:skyroad/widget/password_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

enum RegisterType { email, mobile }

class UserData {
  String code = "";
  String phoneNumber = "";
  String email = "";
  String password = "";
}

RegExp phoneExp = RegExp(
    r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formPhoneKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
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
                child: _buildMobileView()),
          ),
          Expanded(
              flex: 4,
              child: Column(
                children: <Widget>[
//                  Text(CommonUtils.getLocale(context).passwd_tip),
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
                      hintText: CommonUtils.getLocale(context).userName_tip,
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: _validateEmailPhone,
                    // TextInputFormatters are applied in sequence.
//                    inputFormatters: <TextInputFormatter>[
//                      WhitelistingTextInputFormatter.digitsOnly,
//                      // Fit the validating format.
////                      _phoneNumberFormatter,
//                    ],

                    keyboardType: TextInputType.phone,

                    onSaved: (String value) {
                      setState(() {
                        if (CommonUtils.regEmail(value)) {
                          _userData.email = value;
                          _userData.phoneNumber = "";
                        } else {
                          _userData.phoneNumber = value;
                          _userData.email = "";
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
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
                            hintText: CommonUtils.getLocale(context).code,
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
                                  _phoneFieldKey.currentState.value.trim(),
                                  type: "register")
                              .then((value) {
                            if (value?.data?.code == 200) {
                              showInSnackBar(
                                  CommonUtils.getLocale(context).code_sucess);
                            } else {
                              print(value?.data?.code);
                              print(value?.data?.data);
                              showInSnackBar(json.encode(value?.data?.data));
                            }
                          });
                        }
                      },
                      child: Text(CommonUtils.getLocale(context).get_code),
                    )
                  ]),
                  SizedBox(
                    height: 18,
                  ),
                  PasswordField(
                    validator: _validatePassword,
                    controller: pwController,
                    fieldKey: _passwordFieldKey,
                    hintText: CommonUtils.getLocale(context).passwd_hittext,
                    helperText: CommonUtils.getLocale(context).password_length,
                    labelText: CommonUtils.getLocale(context).password_label,
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
          Text(CommonUtils.getLocale(context).privacy_title),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Text(CommonUtils.getLocale(context).privacy_term,
                  style: TextStyle(color: Colors.greenAccent)),
              onTap: () {
//                  打开团队简介
              },
            ),
            Text(CommonUtils.getLocale(context).privacy_and),
            InkWell(
              child: Text(CommonUtils.getLocale(context).privicy_policy,
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
      if (!_formPhoneKey.currentState.validate()) {
        _autovalidate = true; // Start validating on every change.
        showInSnackBar(CommonUtils.getLocale(context).validate_imput_fix_error);
      } else {
        _phoneFieldKey.currentState.save();
        CommonUtils.showLoadingDialog(context);
        var type = 'email';

        if (phoneExp.hasMatch(_phoneFieldKey.currentState.value)) {
          type = 'mobile';
        }
        UserDao.register(type, _userData.phoneNumber, _userData.email,
                _userData.password, _codeFieldKey.currentState.value)
            .then((res) {
          Navigator.pop(context);
          if (!res?.result) {
//          print(runtimeType);
            showInSnackBar(res?.data?.data["non_field_errors"].toString());
          } else {
            LocalStorage.save(Config.KEY_USER_NAME,
                type == "mobile" ? _userData.phoneNumber : _userData.email);
            LocalStorage.save(Config.KEY_PW, _userData.password);
//          注册成功VerifyAccount
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => VerifyAccount()));
//          print(res.data);
          }
        });
//          注册成功VerifyAccount
//        Navigator.pushReplacement(
//            context, MaterialPageRoute(builder: (context) => VerifyAccount()));
      }
    } else {
      showInSnackBar(CommonUtils.getLocale(context).privicy_comfirm);
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  String _validateEmailPhone(String value) {
    final FormFieldState<String> phoneFieldKey = _phoneFieldKey.currentState;

    if (phoneFieldKey.value == null || phoneFieldKey.value.isEmpty) {
      return CommonUtils.getLocale(context).user_empty;
    }
    RegExp phoneExp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (!phoneExp.hasMatch(value) && !CommonUtils.regEmail(phoneFieldKey.value))
      return CommonUtils.getLocale(context).validate_input_phone_email;
    return null;
  }

  String _validatePassword(String value) {
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return CommonUtils.getLocale(context).validate_input_password;
    if (passwordField.value.length < 8 || passwordField.value.length > 20)
      return CommonUtils.getLocale(context).validate_imput_length;
    if (passwordField.value != value)
      return CommonUtils.getLocale(context).validate_imput_passwd_match;
    _userData.password = passwordField.value.trim();
    return null;
  }

//  验证码
  String _validateCode(String value) {
    final FormFieldState<String> passwordField = _codeFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return CommonUtils.getLocale(context).validate_input_code;
    if (passwordField.value.length != 6)
      return CommonUtils.getLocale(context).validate_imput_code_error;
    _userData.code = passwordField.value.trim();
    return null;
  }
}
