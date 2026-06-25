//UIUX-017
//Onke/021 starts here
// [UIUX-017] — Place this in the admin programme detail card's onTap
context.pushNamed(
  'adminEnrolments',
  pathParameters: {'programmeId': programme.id},
  queryParameters: {'programmeName': programme.title},
);

//Onke/021 Ends Here