import '../../classes/models/specialty.dart';
import '../../ui/pages/doctors/specialties_doctor_page.dart';
import '../../util/custome_widgets/image_widgets.dart';
import '../../util/utility/custom_theme.dart';
import '../../util/utility/global_var.dart';
import 'package:flutter/material.dart';

class SingelSpecialtieItme extends StatelessWidget {
  final Specialty item;
  SingelSpecialtieItme(this.item);
  @override
  Widget build(BuildContext context) {
    double dimn = 70;
    return SizedBox(
      width: 145,
      height: 170,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(SpecialtiesDoctorsPage.routeName, arguments: item);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
            child: Column(
              children: [
                ImageView(
                  item.featuredImage,
                  width: dimn,
                  height: dimn,
                  imageWidth: dimn * 2,
                  imageHeight: dimn * 2,
                  tapped: false,
                  crop: false,
                ),
                SizedBox(height: 10),
                Expanded(
                    child: Center(
                  child: Text(
                    item.title ?? "",
                    style: CustomTheme.title2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1,
                    softWrap: true,
                    maxLines: 2,
                  ),
                )),
                Container(color: Colors.grey.shade200, height: 1),
                SizedBox(height: 3),
                Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child:
                        FittedBox(child: Text("${item.doctorsCount ?? ''} " + str.app.doctor, textScaleFactor: 1, style: CustomTheme.numberStyle))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
