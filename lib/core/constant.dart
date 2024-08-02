
import 'package:flutter/cupertino.dart';

class Constants {
  // static const String BaseUrlTest = "http://ci2.psprasand.com/api";
  // static const String BaseUrlDev = "http://ci2.psprasand.com/api";
  // static const String BaseUrlRelease = "http://ci2.psprasand.com/api";

  // static const String BaseUrlTest = "https://demo.klabstechindia.com/TNPSC_CI/public/index.php/api";
  // static const String BaseUrlDev = "https://demo.klabstechindia.com/TNPSC_CI/public/index.php/api";
  // static const String BaseUrlRelease = "https://demo.klabstechindia.com/TNPSC_CI/public/index.php/api";

  // static const String BaseUrlTest = "https://tnpscems.tn.gov.in//TNPSC_CI/public/index.php/login/api";
  // static const String BaseUrlDev = "https://tnpscems.tn.gov.in//TNPSC_CI/public/index.php/login/api";
  // static const String BaseUrlRelease = "https://tnpscems.tn.gov.in//TNPSC_CI/public/index.php/login/api";

  static const String BaseUrlTest = "https://tnpscems.tn.gov.in//TNPSC_CI/public/index.php/api";
  static const String BaseUrlDev = "https://tnpscems.tn.gov.in//TNPSC_CI/public/index.php/api";
  static const String BaseUrlRelease = "https://tnpscems.tn.gov.in//TNPSC_CI/public/index.php/api";

  static const String MORE_LOCATION = "";
  static const String MORE_FACEBOOK = "";
  static const String MORE_TWITTER = "";
  static const String MORE_INSTAGRAM =
      "";
  static const String MORE_SITE = "";

  static const String KEY_TOKEN_1 = "KEY_TOKEN_1";
  static String AUTH_TOKEN = "";
  static String USER_TYPE="";
  static String EXAM_TYPE="";
  static String CENTER_CODE="";
  static String USER_NAME="";
  static String USER_EMAIL="";
  static String USER_CONTACT="";
  static String USER_DISTRICT="";
  static String USER_CENTER="";
  static String USER_VENUE="";
  static String USER_ADDRESS="";
  static String USER_EXAM_DATE="";
  static String USER_MEETING_DATE="";

  static const String SecretKey = "secret_key";
  static const String VectorKey = "vector_key";
  static const String AppKey = "app_key";
  static const String AuthToken = "auth_token";
  static const String VersionCode = "app_version";
  static const String IOSVersionCode = "tnpsc_ios_app_version";
  static const String AndroidVersionCode = "tnpsc_android_app_version";
  static const String ForceUpdate = "force_update";
  static const String SaveDate = "save_date";
   /*Home*/
  static const String HOME = "Home";
  static const String EVENTS = "Event";
  static const String SURVEY = "Survey";
  static const String MORE = "More";

  static const String REGISTER = "register";
  static const String CHANGE_PASSWORD = "change_password";

  //Language
  static const String DEFAULT_LANGUAGE = "default_language";
  static const int LANGUAGE_NOTSEL = 0;
  static const int LANGUAGE_ENGLISH = 1;
  static const int LANGUAGE_TAMIL = 2;
  static const String CURRENT_LANGUAGE = 'current_language';
  static const String COUNTRY_CODE_JSON = 'country_code_json';



// DOB

  // static DateTime now = DateTime.now();
  // static String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  // ignore: non_constant_identifier_names
  static String MIN_DATETIME = '1950-01-01';




  static const String dobFormat = 'dd-MM-yyyy';
  // static const DateTimePickerLocale dobLocale = DateTimePickerLocale.en_us;

  // ApplicationId
  static const int Android = 1;

  static const int iOS = 2;

  // static const int  Web =3 ;

  //emailId
  //userid
  static const String USERID = "spuserid";

  static const String INTERNET_SPEED = 'internet_speed';
  static const int NET_SPEED_HIGH = 1;
  static const int NET_SPEED_LOW = 2;
  static const String FACILITY_SELECTED_INDEX = 'selected index';

  static const String IS_CAROUSEL_RETRY = 'is_carousel_retry';
  static const String IS_FACILITY_GROUP_RETRY = 'is_facility_group_retry';
  static const String IS_FACILITY_RETRY = 'is_facility_retry';
  static const String IS_FACILITY_DETAILS_RETRY = 'is_facility_details_retry';
  static const String IS_FACILITY_DETAILS_CATEGORY_RETRY =
      'is_facility_details_category_retry';

  static const String IS_NOTIFICATION_LIST_RETRY = 'is_notification_list_retry';

  static const String FCM_TOKEN = 'fcm_token';
  static const String FEEDBACK_TYPE_SURVEY = 'survey';
  static const String FEEDBACK_TYPE_EVENT = 'event';

  //
  static const String IS_NEW_NOTIFY_AVAIL = "is_notification_available";

  //otp resend timer count
  static const int RESEND_TIME = 30;
  static const String STATUSBAR_HEIGHT = 'statusbar_height';
  static const String REFRESH_HOMEPAGE = 'update_homepage';
  static const String REFRESH_FACILITYDETAILS = 'update_facility_details';

  //login to changepassword flow
  //login to register flow
  static bool isChangePassword = false;

  static bool iSEditClickedInProfile = false;
  static bool iSPageFromProfile = false;

  /*Question type*/
  static const int QR_TYPE_ATTENDANCE = 1;
  static const int QR_TYPE_QUESTIONBOX = 2;
  static const int QR_TYPE_ANSWERSHEET = 3;

  static const IconData delete = IconData(0xe1b9, fontFamily: 'MaterialIcons');

  static bool isChennaiCenter=false;
}
