// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);


//Get most frequent visitor with count.
CheckinAnalyticsController cacObj = new CheckinAnalyticsController();
cacObj.getTopVisitors();

//Get most frequent visitor with count filtered by top n.
CheckinAnalyticsController cacObj1 = new CheckinAnalyticsController(2);
cacObj1.getTopVisitors();

//Get most frequent visitor with count | Static method example.
CheckinAnalyticsController.getTopVisitorsStaticDemo(1);
