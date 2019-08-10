import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skyroad/common/conf/config.dart';
import 'package:skyroad/common/dao/user_dao.dart';
import 'package:skyroad/common/utils/common_utls.dart';
import 'package:skyroad/common/utils/local_storage.dart';
import 'package:skyroad/page/register_login.dart';
import 'package:skyroad/widget/gosund_button.dart';
import 'package:skyroad/widget/password_widget.dart';

import 'login_page.dart';
/**
 *
 * Project Name: skyroad
 * Package Name: page
 * File Name: forgot_passwd
 * USER: Aige
 * Create Time: 2019-07-31-14:43
 *
 */

class UserData {
  String code = "";
  String username = "";
  String password = "";
}

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

enum RegisterType { email, mobile }

RegExp phoneExp = RegExp(
    r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

class ForgotPasswordState extends State<ForgotPassword> {
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
        title: Text(CommonUtils.getLocale(context).forget_password_title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Align(
                child: Padding(
                  child: Text(
                    CommonUtils.getLocale(context).forget_password,
                    style: TextStyle(fontSize: 20),
                  ),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                ),
              )),
          Expanded(
            flex: 4,
            child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: _buildMobileView()),
          ),
          Expanded(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Text(CommonUtils.getLocale(context).passwd_tip),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GosundButton(
                      child: Text(
                          CommonUtils.getLocale(context).forget_resetpassword),
                      onTap: () {
                        _resetAccount();
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
                      hintText: CommonUtils.getLocale(context).username_tip,
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
                        _userData.username;
                      });
                    },
                  ),
                  SizedBox(
                    height: 6,
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
                        onSaved: (value) {
                          _userData.code = value;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_phoneFieldKey.currentState.validate()) {
                          UserDao.getCode(
                                  _phoneFieldKey.currentState.value.trim())
                              .then((value) {
                            if (value?.data?.code == 200) {
                              showInSnackBar(CommonUtils.getLocale(context)
                                  .code_send_success);
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
                    height: 15,
                  ),
                  PasswordField(
                    validator: _validatePassword,
                    controller: pwController,
                    fieldKey: _passwordFieldKey,
                    hintText: CommonUtils.getLocale(context).password_label,
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

  //创建账号
  _resetAccount() {
    if (!_formPhoneKey.currentState.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar(CommonUtils.getLocale(context).validate_imput_fix_error);
    } else {
      _phoneFieldKey.currentState.save();
      CommonUtils.showLoadingDialog(context);
      var value = _codeFieldKey.currentState.value;

      UserDao.restPasswd(_userData.username, _userData.code, _userData.password)
          .then((res) {
        Navigator.pop(context);
        if (res != null && res?.data.result) {
          LocalStorage.save(Config.KEY_USER_NAME, _userData.username);
          LocalStorage.save(Config.KEY_PW, _userData.password);
          showInSnackBar(
              CommonUtils.getLocale(context).forget_resetpassword_success);
          //          注册成功VerifyAccount
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          showInSnackBar(
              CommonUtils.getLocale(context).forget_resetpassword_error);
        }
      });
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
    _userData.username = phoneFieldKey.value.trim();
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
