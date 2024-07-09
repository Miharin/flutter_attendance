import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({
    super.key,
    required this.title,
    required this.datalabel,
    this.ontap,
  });

  final List<String> title;
  final List datalabel;
  final void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    List<Widget> listtitle = title
        .map((label) => Text(label == "statusOutside"
            ? "Status Outside"
            : label == "dateTime"
                ? "Date Time"
                : label == "workplaceID"
                    ? "Workplace ID"
                    : label == "nik" || label == "ID"
                        ? label.toUpperCase()
                        : label.capitalize!))
        .toList();
    return Flexible(
      flex: 1,
      child: PaginatedDataTable(
        rowsPerPage: 25,
        sortColumnIndex: 0,
        sortAscending: true,
        showCheckboxColumn: false,
        columns: listtitle.map((title) => DataColumn(label: title)).toList(),
        source: _DataSource(data: datalabel, context: context, title: title),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List data;
  final List title;
  final BuildContext context;

  _DataSource({
    required this.data,
    required this.context,
    required this.title,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];
    return DataRow(
      cells: List.generate(
        title.length,
        (index) {
          if (title[index] == "password") {
            final password =
                List.generate(item[title[index]].length, (index) => "*")
                    .toList()
                    .join();
            return DataCell(
              Text(password),
            );
          }
          return DataCell(
            Text(item[title[index]] == "" ? "-" : item[title[index]] ?? "-"),
          );
        },
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
