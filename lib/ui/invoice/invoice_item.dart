import 'package:invoiceninja/utils/formatting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/redux/app/app_state.dart';
import 'package:invoiceninja/ui/app/dismissible_entity.dart';

import '../app/entity_state_label.dart';

class InvoiceItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  //final ValueChanged<bool> onCheckboxChanged;
  final InvoiceEntity invoice;
  final ClientEntity client;
  final AppState state;
  final String filter;

  const InvoiceItem({
    @required this.onDismissed,
    @required this.onTap,
    //@required this.onCheckboxChanged,
    @required this.invoice,
    @required this.client,
    @required this.state,
    @required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return DismissibleEntity(
      entity: invoice,
      onDismissed: onDismissed,
      onTap: onTap,
      child: ListTile(
        onTap: onTap,
        /*
        leading: Checkbox(
          //key: NinjaKeys.invoiceItemCheckbox(invoice.id),
          value: true,
          //onChanged: onCheckboxChanged,
          onChanged: (value) {
            return true;
          },
        ),
        */
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  client.displayName,
                  //invoice.invoiceNumber,
                  //key: NinjaKeys.clientItemClientKey(client.id),
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Text(formatNumber(invoice.amount, state, clientId: invoice.clientId),
                  style: Theme.of(context).textTheme.title),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              filter != null && filter.isNotEmpty
                  ? invoice.matchesSearchValue(filter) ?? ''
                  : invoice.invoiceNumber,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            EntityStateLabel(invoice),
          ],
        ),
      ),
    );
  }
}
