import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // 카드 배경
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: getProportionateScreenHeight(0)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                    itemCount: context.watch<UserNotifier>().approvedUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ApprovedUserTile(abaUser: context.watch<UserNotifier>().approvedUsers[index], index: index);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ApprovedUserTile extends StatefulWidget {
  final ABAUser abaUser;
  final int index;
  const ApprovedUserTile({ Key? key, required this.abaUser, required this.index }) : super(key: key);

  @override
  _ApprovedUserTileState createState() => _ApprovedUserTileState();
}

class _ApprovedUserTileState extends State<ApprovedUserTile> {
  @override
  Widget build(BuildContext context) {
    final FireStoreService store = FireStoreService();

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: ListTile(
            title: Text('${widget.abaUser.name} - ${widget.abaUser.duty}'),
            subtitle: Text('${widget.abaUser.email}\n${convertPhoneNumber(widget.abaUser.phone)}'),
            isThreeLine: true,

            trailing: Visibility(
              visible: widget.abaUser.deleteRequest,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    child: Text('탈퇴 승인'),
                    style: ElevatedButton.styleFrom(primary: Colors.blue[400]),
                    onPressed: () async {
                      // 회원 탈퇴 수락
                      await store.deleteUser(widget.abaUser.email);
                      context.read<UserNotifier>().deleteApprovedUser(widget.abaUser.email);
                    }, 
                  ),
                  SizedBox(width: getProportionateScreenWidth(10.0)),
                  ElevatedButton(
                    child: Text('탈퇴 거부'),
                    style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                    onPressed: () async {
                      // 회원 탈퇴 거절
                      await store.updateUser(widget.abaUser.email, widget.abaUser.name, widget.abaUser.phone, widget.abaUser.duty, true, false);
                      context.read<UserNotifier>().updateApprovedUser(widget.index);
                    }, 
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}







                      