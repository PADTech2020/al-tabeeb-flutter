import 'availabilityPlans.dart';
import 'meetingPrices.dart';

enum UserType { ADMIN, USER, DOCTOR }

class User {
  String id;
  int intId;
  String email;
  bool emailConfirmed;
  String phoneNumber;
  String address;
  String firstName;
  String lastName;
  String fullName;
  String displayName;
  String firstNameAr;
  String firstNameEn;
  String firstNameTr;
  String lastNameAr;
  String lastNameEn;
  String lastNameTr;
  String fullNameAr;
  String fullNameEn;
  String fullNameTr;
  String displayNameAr;
  String displayNameEn;
  String displayNameTr;
  String langsAr;
  String langsEn;
  String langsTr;
  String locationAr;
  String locationEn;
  String locationTr;
  String hospitalAr;
  String hospitalEn;
  String hospitalTr;
  String licenceFile;
  String cvFile;
  String passportFirstName;
  String passportLastName;
  int meetingReminder;
  int nationality;
  String nationalityString;
  int gender;
  String birthday;
  bool hasBadge1;
  bool hasBadge2;
  bool hasBadge3;
  String bio;
  String bioAr;
  String bioEn;
  String bioTr;
  String workAddress;
  int specialtyId;
  String specialty;
  String licenceIssuer;
  String college;
  int licenceStatus;
  String certificates;
  String courses;
  String experiences;
  String certificatesAr;
  String certificatesEn;
  String certificatesTr;
  String coursesAr;
  String coursesEn;
  String coursesTr;
  String experiencesAr;
  String experiencesEn;
  String experiencesTr;
  List<AvailabilityPlans> availabilityPlans;
  List<MeetingPrices> meetingPrices;
  String nameOnCard;
  String bankName;
  String ibanTl;
  String ibanUsd;
  double rate;
  int rateCount;
  double totalMinutesUsed;
  double totalMinutesGiven;
  bool isActive;
  bool hasPassword;
  String profilePhoto;
  String topics;
  int role;
  String createdDate;
  String lang;
  String countryPhoneCode;
  String youTubeVideo;
  String youTubeVideoId;
  String userTopicId;
  String langs;
  String location;
  String hospital;

  User({
    this.id,
    this.intId,
    this.email,
    this.emailConfirmed,
    this.phoneNumber,
    this.address,
    this.firstName,
    this.lastName,
    this.fullName,
    this.displayName,
    this.firstNameAr,
    this.firstNameEn,
    this.firstNameTr,
    this.lastNameAr,
    this.lastNameEn,
    this.lastNameTr,
    this.fullNameAr,
    this.fullNameEn,
    this.fullNameTr,
    this.displayNameAr,
    this.displayNameEn,
    this.displayNameTr,
    this.langsAr,
    this.langsEn,
    this.langsTr,
    this.locationAr,
    this.locationEn,
    this.locationTr,
    this.hospitalAr,
    this.hospitalEn,
    this.hospitalTr,
    this.licenceFile,
    this.cvFile,
    this.passportFirstName,
    this.passportLastName,
    this.meetingReminder,
    this.nationality,
    this.nationalityString,
    this.gender,
    this.birthday,
    this.hasBadge1,
    this.hasBadge2,
    this.hasBadge3,
    this.bio,
    this.bioAr,
    this.bioEn,
    this.bioTr,
    this.workAddress,
    this.specialtyId,
    this.specialty,
    this.licenceIssuer,
    this.college,
    this.licenceStatus,
    this.certificates,
    this.courses,
    this.experiences,
    this.certificatesAr,
    this.certificatesEn,
    this.certificatesTr,
    this.coursesAr,
    this.coursesEn,
    this.coursesTr,
    this.experiencesAr,
    this.experiencesEn,
    this.experiencesTr,
    this.availabilityPlans,
    this.meetingPrices,
    this.nameOnCard,
    this.bankName,
    this.ibanTl,
    this.ibanUsd,
    this.rate,
    this.rateCount,
    this.totalMinutesUsed,
    this.totalMinutesGiven,
    this.isActive,
    this.hasPassword,
    this.profilePhoto,
    this.topics,
    this.role,
    this.createdDate,
    this.lang,
    this.countryPhoneCode,
    this.youTubeVideo,
    this.youTubeVideoId,
    this.userTopicId,
    this.langs,
    this.location,
    this.hospital,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    intId = json['intId'];
    email = json['email'];
    emailConfirmed = json['emailConfirmed'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    displayName = json['displayName'];

    firstNameAr = json['firstNameAr'];
    firstNameEn = json['firstNameEn'];
    firstNameTr = json['firstNameTr'];
    lastNameAr = json['lastNameAr'];
    lastNameEn = json['lastNameEn'];
    lastNameTr = json['lastNameTr'];
    fullNameAr = json['fullNameAr'];
    fullNameEn = json['fullNameEn'];
    fullNameTr = json['fullNameTr'];
    displayNameAr = json['displayNameAr'];
    displayNameEn = json['displayNameEn'];
    displayNameTr = json['displayNameTr'];
    langsAr = json['langsAr'];
    langsEn = json['langsEn'];
    langsTr = json['langsTr'];
    locationAr = json['locationAr'];
    locationEn = json['locationEn'];
    locationTr = json['locationTr'];
    hospitalAr = json['hospitalAr'];
    hospitalEn = json['hospitalEn'];
    hospitalTr = json['hospitalTr'];
    licenceFile = json['licenceFile'];
    cvFile = json['cvFile'];
    passportFirstName = json['passportFirstName'];
    passportLastName = json['passportLastName'];
    meetingReminder = json['meetingReminder'];
    nationality = json['nationality'];
    nationalityString = json['nationalityString'];
    gender = json['gender'];
    birthday = json['birthday'];
    // hasBadge1 = json['hasBadge1'];
    // hasBadge2 = json['hasBadge2'];
    // hasBadge3 = json['hasBadge3'];
    bio = json['bio'];
    bioAr = json['bioAr'];
    bioEn = json['bioEn'];
    bioTr = json['bioTr'];
    workAddress = json['workAddress'];
    specialtyId = json['specialtyId'];
    specialty = json['specialty'];
    licenceIssuer = json['licenceIssuer'];
    college = json['college'];
    licenceStatus = json['licenceStatus'];
    certificates = json['certificates'];
    courses = json['courses'];
    experiences = json['experiences'];
    certificatesAr = json['certificatesAr'];
    certificatesEn = json['certificatesEn'];
    certificatesTr = json['certificatesTr'];
    coursesAr = json['coursesAr'];
    coursesEn = json['coursesEn'];
    coursesTr = json['coursesTr'];
    experiencesAr = json['experiencesAr'];
    experiencesEn = json['experiencesEn'];
    experiencesTr = json['experiencesTr'];
    if (json['availabilityPlans'] != null) {
      availabilityPlans = [];
      json['availabilityPlans'].forEach((v) {
        availabilityPlans.add(new AvailabilityPlans.fromJson(v));
      });
    }
    if (json['meetingPrices'] != null) {
      meetingPrices = [];
      json['meetingPrices'].forEach((v) {
        meetingPrices.add(new MeetingPrices.fromJson(v));
      });
    }
    nameOnCard = json['nameOnCard'];
    bankName = json['bankName'];
    ibanTl = json['ibanTl'];
    ibanUsd = json['ibanUsd'];
    rate = json['rate']?.toDouble();
    rateCount = json['rateCount'];
    totalMinutesUsed = json['totalMinutesUsed']?.toDouble();
    totalMinutesGiven = json['totalMinutesGiven']?.toDouble();
    isActive = json['isActive'];
    hasPassword = json['hasPassword'];
    profilePhoto = json['profilePhoto'];
    topics = json['topics'];
    role = json['role'];
    createdDate = json['createdDate'];
    lang = json['lang'];
    countryPhoneCode = json['countryPhoneCode'];
    youTubeVideo = json['youTubeVideo'];
    youTubeVideoId = json['youTubeVideoId'];
    userTopicId = json['userTopicId'];
    langs = json['langs'];
    location = json['location'];
    hospital = json['hospital'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['intId'] = this.intId;
    data['email'] = this.email;
    data['emailConfirmed'] = this.emailConfirmed;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['fullName'] = this.fullName;
    data['displayName'] = this.displayName;
    data['firstNameAr'] = this.firstNameAr;
    data['firstNameEn'] = this.firstNameEn;
    data['firstNameTr'] = this.firstNameTr;
    data['lastNameAr'] = this.lastNameAr;
    data['lastNameEn'] = this.lastNameEn;
    data['lastNameTr'] = this.lastNameTr;
    data['fullNameAr'] = this.fullNameAr;
    data['fullNameEn'] = this.fullNameEn;
    data['fullNameTr'] = this.fullNameTr;
    data['displayNameAr'] = this.displayNameAr;
    data['displayNameEn'] = this.displayNameEn;
    data['displayNameTr'] = this.displayNameTr;
    data['langsAr'] = this.langsAr;
    data['langsEn'] = this.langsEn;
    data['langsTr'] = this.langsTr;
    data['locationAr'] = this.locationAr;
    data['locationEn'] = this.locationEn;
    data['locationTr'] = this.locationTr;
    data['hospitalAr'] = this.hospitalAr;
    data['hospitalEn'] = this.hospitalEn;
    data['hospitalTr'] = this.hospitalTr;
    data['licenceFile'] = this.licenceFile;
    data['cvFile'] = this.cvFile;
    data['passportFirstName'] = this.passportFirstName;
    data['passportLastName'] = this.passportLastName;
    data['meetingReminder'] = this.meetingReminder;
    data['nationality'] = this.nationality;
    data['nationalityString'] = this.nationalityString;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    // data['hasBadge1'] = this.hasBadge1;
    // data['hasBadge2'] = this.hasBadge2;
    // data['hasBadge3'] = this.hasBadge3;
    data['bio'] = this.bio;
    data['bioAr'] = this.bioAr;
    data['bioEn'] = this.bioEn;
    data['bioTr'] = this.bioTr;
    data['workAddress'] = this.workAddress;
    data['specialtyId'] = this.specialtyId;
    data['specialty'] = this.specialty;
    data['licenceIssuer'] = this.licenceIssuer;
    data['college'] = this.college;
    data['licenceStatus'] = this.licenceStatus;
    data['certificates'] = this.certificates;
    data['courses'] = this.courses;
    data['experiences'] = this.experiences;
    data['certificatesAr'] = this.certificatesAr;
    data['certificatesEn'] = this.certificatesEn;
    data['certificatesTr'] = this.certificatesTr;
    data['coursesAr'] = this.coursesAr;
    data['coursesEn'] = this.coursesEn;
    data['coursesTr'] = this.coursesTr;
    data['experiencesAr'] = this.experiencesAr;
    data['experiencesEn'] = this.experiencesEn;
    data['experiencesTr'] = this.experiencesTr;
    if (this.availabilityPlans != null) {
      data['availabilityPlans'] = this.availabilityPlans.map((v) => v.toJson()).toList();
    }
    if (this.meetingPrices != null) {
      data['meetingPrices'] = this.meetingPrices.map((v) => v.toJson()).toList();
    }
    data['nameOnCard'] = this.nameOnCard;
    data['bankName'] = this.bankName;
    data['ibanTl'] = this.ibanTl;
    data['ibanUsd'] = this.ibanUsd;
    data['rate'] = this.rate;
    data['rateCount'] = this.rateCount;
    data['totalMinutesUsed'] = this.totalMinutesUsed;
    data['totalMinutesGiven'] = this.totalMinutesGiven;
    data['isActive'] = this.isActive;
    data['hasPassword'] = this.hasPassword;
    data['profilePhoto'] = this.profilePhoto;
    data['topics'] = this.topics;
    data['role'] = this.role;
    data['createdDate'] = this.createdDate;
    data['lang'] = this.lang;
    data['countryPhoneCode'] = this.countryPhoneCode;
    data['youTubeVideo'] = this.youTubeVideo;
    data['youTubeVideoId'] = this.youTubeVideoId;
    data['userTopicId'] = this.userTopicId;
    data['langs'] = this.langs;
    data['location'] = this.location;
    data['hospital'] = this.hospital;
    return data;
  }
}
