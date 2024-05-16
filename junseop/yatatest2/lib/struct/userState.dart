import 'package:flutter/material.dart';

class UserState {
  bool loginState = false;
  bool nick_available = false;
  bool email_check = false;
  void set_loginState(bool set) {
    loginState = set;
  }
}
UserState user_state = new UserState();