// ignore_for_file: constant_identifier_names

enum OccupationType {
  CAVEATS,
  SPECIALISATION,
  ACCESSING_AUTHORITY,
  INVITATION_CUT_OFFS,
  RELATED_OCCUPATIONS,
  EMPLOYEE_STATISTICS
}

enum EOIType { SUBMITTED, LOGED, HELD, INVITED }

enum PointTestReviewType { POINTTEST, DASHBOARD, MOREMENU }

enum PointTestQuesStatus { NEXT_QUESTION, PREVIOUD_QUESTION, TEST_COMPLETION }

enum SelectedOptionType { NEXT_QUESTION, OPTION_SELECTION }

enum PointTestMode {
  NEW_TEST, // Take the new point test
  EDIT_ALL_QTEST, // Edit All point test question
  EDIT_QTEST // Edit particular point test answer
}

enum SearchCategoryType { COURSE, OCCUPATION, JOBS }

enum BookmarkType { ALL, OCCUPATION, COURSE, JOBS }

enum RecentSearchType { COURSE, OCCUPATION }

enum UnitGroupChartDataType {
  WORKERS,
  EARNINGS,
  AGEPROFILE,
  EDUCATION,
}

//subscription plan type
enum AppType { FREE_TRIAL, PAID, EXPIRED }
