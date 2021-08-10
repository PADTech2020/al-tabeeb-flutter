import 'dart:developer';

import 'package:flutter_svg/svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../classes/models/user.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/image_widgets.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../util/utility/global_var.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'book_page.dart';
import 'doctor_details_page.dart';

class SingleDoctorlistItem extends StatelessWidget {
  final User item;
  SingleDoctorlistItem(this.item);
  @override
  Widget build(BuildContext context) {
    String title = '';
    if (item.fullName != null) title += item.fullName;
    Size size = MediaQuery.of(context).size;
    double heigh = 145;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(DoctorDetailsPage.routeName, arguments: item.id),
      child: SizedBox(
        height: heigh,
        width: size.width,
        child: Card(
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularImageView(item.profilePhoto, dimension: 75, tapped: false),
                ],
              ),
              SizedBox(width: 5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Spacer(),
                      Text(title ?? " ", style: CustomTheme.title1, maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 5),
                      Text(item.bio ?? '', style: CustomTheme.body3, maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 5),
                      Text(item.specialty ?? '', style: CustomTheme.title3.copyWith(color: CustomTheme.accentColor)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          SizedBox(
                            height: 35,
                            child: ButtonWidget(
                              str.app.bookNow,
                              () => Navigator.of(context).pushNamed(BookPage.routeName, arguments: item.id),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainInfoDoctor extends StatelessWidget {
  final User doctor;
  MainInfoDoctor(this.doctor);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double imageWidth = size.width / 3;
    double imageHieght = imageWidth * (4 / 3);
    return Container(
      width: size.width,
      color: CustomTheme.cardBackground,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: ImageView(doctor.profilePhoto, height: imageHieght, width: imageWidth, imageHeight: 400, imageWidth: 300, tapped: false),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(doctor.specialty ?? '', style: CustomTheme.title3.copyWith(color: CustomTheme.accentColor)),
                SizedBox(height: 10),
                Text(doctor.fullName ?? "", style: CustomTheme.title1),
                SizedBox(height: 10),
                BadgeRow(doctor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BadgeRow extends StatelessWidget {
  final User doctor;
  BadgeRow(this.doctor);
  @override
  Widget build(BuildContext context) {
    Color color = Color(0xFF00A1DB);
    return doctor == null
        ? SizedBox()
        : Column(
            children: [
              if (doctor.hospital != null && doctor.hospital.isNotEmpty) ...[
                Row(
                  children: [
                    SvgPicture.asset(GlobalVar.assetsImageBase + "hospital.svg", height: 18, color: color),
                    SizedBox(width: 5),
                    Expanded(child: Text(doctor.hospital ?? '')),
                  ],
                ),
                SizedBox(height: 5),
              ],
              if (doctor.langs != null && doctor.langs.isNotEmpty) ...[
                Row(
                  children: [
                    SvgPicture.asset(GlobalVar.assetsImageBase + "translating.svg", height: 18, color: color),
                    SizedBox(width: 5),
                    Expanded(child: Text(doctor.langs.replaceAll(',', ' - ') ?? '')),
                  ],
                ),
                SizedBox(height: 5),
              ],
              if (doctor.location != null && doctor.location.isNotEmpty) ...[
                Row(
                  children: [
                    SvgPicture.asset(GlobalVar.assetsImageBase + "location.svg", height: 18, color: color),
                    SizedBox(width: 5),
                    Expanded(child: Text(doctor.location ?? '')),
                  ],
                ),
              ],
            ],
          );
  }
}

class YoutubeVideoWidget extends StatelessWidget {
  final User doctor;
  YoutubeVideoWidget(this.doctor);

  @override
  Widget build(BuildContext context) {
    if (doctor.youTubeVideoId != null && doctor.youTubeVideoId.isNotEmpty) {
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: doctor.youTubeVideoId,
        flags: YoutubePlayerFlags(
          controlsVisibleAtStart: true,
          autoPlay: false,
          enableCaption: true,
        ),
      );

      return YoutubePlayer(
        controller: _controller,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
        ],
      );
    } else
      return SizedBox();
  }
}

class BioDoctor extends StatelessWidget {
  final User doctor;
  BioDoctor(this.doctor);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (doctor.bio != null && doctor.bio.isNotEmpty)
      return Container(
        width: size.width,
        color: CustomTheme.cardBackground,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(FontAwesomeIcons.user, color: CustomTheme.accentColor, size: 28),
                SizedBox(width: 10),
                Text(str.app.bio, style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 10),
            Text(doctor.bio ?? "", style: CustomTheme.body2.copyWith(height: 1.5)),
          ],
        ),
      );
    return SizedBox();
  }
}

class EeducationalDoctorSection extends StatelessWidget {
  final User doctor;
  EeducationalDoctorSection(this.doctor);
  @override
  Widget build(BuildContext context) {
    log('dsfdsfdsfdsf ' + doctor.courses);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: CustomTheme.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(GlobalVar.assetsImageBase + "certificates.png", width: 30, color: CustomTheme.accentColor),
              SizedBox(width: 10),
              Text(str.app.educationalTitle, style: TextStyle(fontSize: 18)),
            ],
          ),
          SizedBox(height: 10),
          _educationalList(str.app.certificates, doctor.certificates),
          _educationalList(str.app.courses, doctor.courses),
          _educationalList(str.app.experiences, doctor.experiences),
        ],
      ),
    );
  }

  Widget _educationalList(String title, String data) {
    log(data);
    if (data != null && data.isNotEmpty)
      return Padding(
        padding: const EdgeInsetsDirectional.only(start: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(title + " :", style: CustomTheme.title2),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data
                    .split(',')
                    .map((e) => Row(
                          children: [
                            Text("- ", style: CustomTheme.title1),
                            Expanded(child: Text(e, style: CustomTheme.body2.copyWith(height: 1.5))),
                          ],
                        ))
                    .toList(),
              ),
            ),
            Divider(),
          ],
        ),
      );
    return SizedBox();
  }
}

class PriceTableDoctor extends StatelessWidget {
  final User doctor;
  PriceTableDoctor(this.doctor);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (doctor.meetingPrices != null && doctor.meetingPrices.length > 0) {
      List<TableRow> rowList = [
        TableRow(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
          children: [
            TableCell(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(str.app.time + " (${str.app.timeUnit})", style: CustomTheme.title3, textAlign: TextAlign.center),
            )),
            TableCell(child: Text(str.app.price + " - " + str.app.video, style: CustomTheme.title3, textAlign: TextAlign.center)),
            TableCell(child: Text(str.app.price + " - " + str.app.voice, style: CustomTheme.title3, textAlign: TextAlign.center)),
            TableCell(child: Text(str.app.price + " - " + str.app.chat, style: CustomTheme.title3, textAlign: TextAlign.center)),
          ],
        )
      ];
      int index = 0;
      doctor.meetingPrices.forEach((element) {
        index++;
        if (element.isActive)
          rowList.add(
            TableRow(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400)), color: index % 2 == 0 ? Colors.grey.shade200 : Colors.transparent),
              children: [
                TableCell(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(element.meetingDuration?.durationInMinutes.toString(), style: CustomTheme.body2, textAlign: TextAlign.center),
                )),
                TableCell(
                    child: Text("${element.videoPrice ?? ''} ${GlobalVar.appCurrency}", style: CustomTheme.numberStyle, textAlign: TextAlign.center)),
                TableCell(
                    child: Text("${element.audioPrice ?? ''} ${GlobalVar.appCurrency}", style: CustomTheme.numberStyle, textAlign: TextAlign.center)),
                TableCell(
                    child: Text("${element.chatPrice ?? ''} ${GlobalVar.appCurrency}", style: CustomTheme.numberStyle, textAlign: TextAlign.center)),
              ],
            ),
          );
      });
      return Container(
        color: CustomTheme.cardBackground,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(FontAwesomeIcons.moneyBill, color: CustomTheme.accentColor, size: 28),
                  SizedBox(width: 15),
                  Text(str.app.priceTable, style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                defaultColumnWidth: FixedColumnWidth(size.width / 4),
                children: rowList,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    }

    return SizedBox();
  }
}

class WorkTimesTableDoctor extends StatelessWidget {
  final User doctor;
  WorkTimesTableDoctor(this.doctor);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (doctor.availabilityPlans != null && doctor.availabilityPlans.length > 0) {
      List<TableRow> rowList = [
        TableRow(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
          children: [
            TableCell(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(str.app.availabilDays, style: CustomTheme.title3, textAlign: TextAlign.center),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(str.app.availabilTimes, style: CustomTheme.title3, textAlign: TextAlign.center),
            )),
          ],
        )
      ];
      int index = 0;
      doctor.availabilityPlans.forEach((element) {
        index++;
        if (element.isActive)
          rowList.add(
            TableRow(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400)), color: index % 2 == 0 ? Colors.grey.shade200 : Colors.transparent),
              children: [
                TableCell(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(element.dayOfWeekString, style: CustomTheme.body2, textAlign: TextAlign.center),
                )),
                TableCell(
                    child: Text("${element.fromHourString ?? ''} ${str.app.to} ${element.toHourString ?? ''}",
                        style: CustomTheme.body2, textAlign: TextAlign.center)),
              ],
            ),
          );
      });
      return Container(
        width: size.width,
        color: CustomTheme.cardBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 16, start: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(FontAwesomeIcons.clock, color: CustomTheme.accentColor, size: 28),
                  SizedBox(width: 10),
                  Text(str.app.workTimes, style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                defaultColumnWidth: FixedColumnWidth(size.width / 2),
                children: rowList,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    }
    return SizedBox();
  }
}
