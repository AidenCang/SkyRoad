/**
 *
 * Project Name: SkyRoad
 * Package Name: common.localization
 * File Name: local_string
 * USER: Aige
 * Create Time: 2019-07-31-16:29
 *
 */

class GosundStringBase {
  //APP名称
  String app_name = "Gosund";

  //初始化界面
  String connetion_network;
  String version_code;

  //无网络提示
  String connetion_error;
  String connetion_title;
  String try_agin;

  //注册登录
  String register_title;
  String create_account;
  String login_account;
  String username_tip;
  String code;
  String get_code;

  //欢迎页
  String welcome_title;
  String register;
  String login;
  String passwd_tip;
  String passwd_hittext;
  String forgot_tip;

  String input_username_hit;
  String input_passwd_hit;

  String userName_tip;

  String code_sucess;
  String password_length;
  String password_label;
  String privacy_title;
  String privacy_term;
  String privacy_and;
  String privicy_policy;
  String privicy_comfirm;
  String user_empty;

  String validate_input_code;
  String validate_input_password;
  String validate_input_phone_email;
  String validate_imput_length;

  String validate_imput_passwd_match;

  String validate_imput_code_error;

  String validate_imput_fix_error;

  String password_error;

  String usrname_password_validate;

//  Forget
  String forget_password;
  String forget_resetpassword;
  String forget_resetpassword_error;
  String forget_resetpassword_success;
  String forget_password_title;
  String code_send_success;

  ///network
  @override
  String network_error_401 = "[401错误可能: 未授权 \\ 授权登录失败 \\ 登录过期]";
  @override
  String network_error_403 = "403权限错误";
  @override
  String network_error_404 = "404错误";
  @override
  String network_error_timeout = "请求超时";
  @override
  String network_error_unknown = "其他异常";
  @override
  String network_error = "网络错误";
}
