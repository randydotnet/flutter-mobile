import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:invoiceninja/data/models/serializers.dart';
import 'package:built_collection/built_collection.dart';

import 'package:invoiceninja/redux/auth/auth_state.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/data/web_client.dart';

class ExpenseRepository {
  final WebClient webClient;

  const ExpenseRepository({
    this.webClient = const WebClient(),
  });

  Future<BuiltList<ExpenseEntity>> loadList(CompanyEntity company, AuthState auth) async {

    final dynamic response = await webClient.get(
        auth.url + '/expenses?per_page=500', company.token);

    final ExpenseListResponse expenseResponse = serializers.deserializeWith(
        ExpenseListResponse.serializer, response);

    return expenseResponse.data;
  }

  Future saveData(CompanyEntity company, AuthState auth, ExpenseEntity expense, [EntityAction action]) async {

    final data = serializers.serializeWith(ExpenseEntity.serializer, expense);
    dynamic response;

    if (expense.isNew) {
      response = await webClient.post(
          auth.url + '/expenses', company.token, json.encode(data));
    } else {
      var url = auth.url + '/expenses/' + expense.id.toString();
      if (action != null) {
        url += '?action=' + action.toString();
      }
      response = await webClient.put(url, company.token, json.encode(data));
    }

    final ExpenseItemResponse expenseResponse = serializers.deserializeWith(
        ExpenseItemResponse.serializer, response);

    return expenseResponse.data;
  }
}