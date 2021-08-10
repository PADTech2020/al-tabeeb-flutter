import '../../classes/models/meeting.dart';
import '../../classes/models/payment.dart';
import '../../classes/models/user.dart';
import '../../util/custome_widgets/button.dart';
import '../../util/custome_widgets/image_widgets.dart';
import '../../util/utility/custom_theme.dart';
import '../../util/utility/global_var.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../classes/providers/user_provider.dart';

class SingleMeetingItem extends StatefulWidget {
  final Meeting item;
  final Function reportMissedMeetingFun;
  final Function startMeetingFun;
  SingleMeetingItem(this.item, {this.reportMissedMeetingFun, this.startMeetingFun});
  @override
  _SingleMeetingItemState createState() => _SingleMeetingItemState();
}

class _SingleMeetingItemState extends State<SingleMeetingItem> {
  UserProvider userProvider;
  User user;
  Size size;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    size = MediaQuery.of(context).size;
    if (user == null) if (userProvider.user.id == widget.item.doctor.id)
      user = widget.item.user;
    else if (userProvider.user.id == widget.item.user.id) user = widget.item.doctor;
    return Container(
      width: size.width,
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: CustomTheme.cardBackground,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: user == null
          ? SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        CircularImageView(
                          user.profilePhoto,
                          dimension: 60,
                          tapped: false,
                        ),
                        SizedBox(height: 5),
                        Text("A${widget.item.id}", style: CustomTheme.body3),
                      ],
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width - 115,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(user.specialty ?? '', style: CustomTheme.body3),
                                  SizedBox(height: 5),
                                  Text(user.fullName ?? " ", style: CustomTheme.title2),
                                ],
                              ),
                              Spacer(),
                              Text(GlobalVar.doubleToString(widget.item.durationInMinutes) + ' ${str.app.minutes}'),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: size.width - 115,
                          child: FittedBox(
                            alignment: AlignmentDirectional.centerStart,
                            fit: BoxFit.scaleDown,
                            child: // for ios tester
                                RichText(
                              text: TextSpan(
                                style: CustomTheme.numberStyle.copyWith(fontSize: 14),
                                children: [
                                  TextSpan(text: GlobalVar.dateForamt(widget.item.meetingDateTime)),
                                  TextSpan(text: '    '),
                                  TextSpan(text: GlobalVar.dateForamt(widget.item.meetingDateTime, 'jm')),
                                  TextSpan(text: '  ${str.app.to}  '),
                                  TextSpan(
                                    text: GlobalVar.dateForamt(
                                        DateTime.parse(widget.item.meetingDateTime).add(
                                          Duration(minutes: widget.item.durationInMinutes),
                                        ),
                                        'jm'),
                                  ),
                                  // TextSpan(text: '  ${str.app.bookingDuration} '),
                                  // TextSpan(text: GlobalVar.doubleToString(widget.item.durationInMinutes) + ' ${str.app.timeUnitShortcut}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        widget.item.user.email == 'testdoctor@al-tabeeb.com' || widget.item.user.email == 'testuser@al-tabeeb.com'
                            ? Text(str.app.bookedAt +
                                " " +
                                GlobalVar.dateForamt(widget.item.physicalMeetingDate ?? DateTime.now(), 'yyyy-MM-dd | hh:mm'))
                            : SizedBox(height: 5),
                      ],
                    ),
                  ],
                ),
                widget.reportMissedMeetingFun != null || widget.startMeetingFun != null
                    ? SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonWidget(
                              str.app.reportMeeting,
                              () => widget.reportMissedMeetingFun(widget.item, userProvider.user.id),
                              color: CustomTheme.redColor,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            SizedBox(width: 10),
                            ButtonWidget(
                              str.app.comunicate,
                              () => widget.startMeetingFun(widget.item, user.id, user.fullName, user.profilePhoto),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: 4),
              ],
            ),
    );
  }
}

class SinglePaymentUserItem extends StatelessWidget {
  final Meeting item;
  SinglePaymentUserItem(this.item);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 16,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(3),
      decoration:
          BoxDecoration(color: CustomTheme.cardBackground, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: size.width * .30,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(str.app.billCode, style: CustomTheme.title3),
                        SizedBox(width: 5),
                        Text('BE${item.id}', style: CustomTheme.body2),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(str.app.visiteCode, style: CustomTheme.title3),
                        SizedBox(width: 5),
                        Text('A${item.id}', style: CustomTheme.body2),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * .04),
              SizedBox(
                width: size.width * .525,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(str.app.paymentAmount, style: CustomTheme.title3),
                        SizedBox(width: 5),
                        Text(GlobalVar.doubleToString(item.price) + ' ${GlobalVar.appCurrency}',
                            style: CustomTheme.numberStyle.copyWith(fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(str.app.doctorName, style: CustomTheme.title3),
                        SizedBox(width: 5),
                        Text(item.doctor.fullName, style: CustomTheme.body3),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 5),
              Text(GlobalVar.dateForamt(item.meetingDateTime)),
              Spacer(),
            ],
          )
        ],
      ),
    );
  }
}

class SinglePaymentDoctorItem extends StatelessWidget {
  final Payment item;
  SinglePaymentDoctorItem(this.item);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 24,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(3),
      decoration:
          BoxDecoration(color: CustomTheme.cardBackground, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(str.app.billCode, style: CustomTheme.body2),
                  SizedBox(width: 15),
                  Text('BE${item.id}', style: CustomTheme.title3),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(str.app.paymentAmount, style: CustomTheme.body2),
                  SizedBox(width: 15),
                  Text(GlobalVar.doubleToString(item.amount) + ' ${GlobalVar.appCurrency}',
                      style: CustomTheme.numberStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str.app.amountOfVisites, style: CustomTheme.body2),
              SizedBox(width: 15),
              Text(GlobalVar.doubleToString(item.meetingsTotalValue) + ' ${GlobalVar.appCurrency}',
                  style: CustomTheme.numberStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(str.app.visitesCode),
              ),
              Expanded(
                child: Wrap(
                  children: item.meetingsString
                      .split(',')
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(e, style: CustomTheme.title2),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(GlobalVar.dateForamt(item.createdDate)),
              Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
