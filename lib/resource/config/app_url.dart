import 'dart:io';

class AppUrl {
  static var domainName = Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
  static var baseUrl = "$domainName/api";

  static var loginEndPoint = '$baseUrl/login';
  static var registerEndPoint = '$baseUrl/register';
  static var userEndPoint = '$baseUrl/users';

  static var categoryEndPoint = '$baseUrl/categories';
  static var lessonsEndPoint = '$baseUrl/lessons';


  static var contractEndpoint = '$baseUrl/contracts';

  static var jobsEndpoint = '$baseUrl/jobs';

  static var documentsTypeEndPoint = '$baseUrl/document_types';

  static var accountsEndPoint = '$baseUrl/accounts';

  static var documentsEndPoint = '$baseUrl/documents';

  static var shiftsEndPoint = '$baseUrl/shifts';

  static var appliesEndPoint = '$baseUrl/applies';

  static var confirmationsEndPoint = '$baseUrl/shift-confirmations';

  static var timeSheetEndPoint = '$baseUrl/time_sheets';

  static var invoicesEndPoint = '$baseUrl/invoices';

  static var enterpriseEndPoint = '$baseUrl/enterprises';

  static var workerEndPoint = '$baseUrl/workers';

  static var townsEndPoint = '$baseUrl/towns';

  static var passwordReset = '$baseUrl/password-reset';

}