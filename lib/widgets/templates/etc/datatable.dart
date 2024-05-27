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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: 0,
          sortAscending: true,
          showCheckboxColumn: false,
          columns: listtitle.map((title) => DataColumn(label: title)).toList(),
          rows: datalabel.map((e) {
            return DataRow(
              onSelectChanged: (bool? selected) {
                if (selected! && ontap != null) {
                  ontap!();
                }
              },
              cells: List.generate(
                title.length,
                (index) {
                  if (title[index] == "password") {
                    final password =
                        List.generate(e[title[index]].length, (index) => "*")
                            .toList()
                            .join();
                    return DataCell(
                      Text(password),
                    );
                  }
                  return DataCell(
                    Text(e[title[index]] == "" ? "-" : e[title[index]] ?? "-"),
                  );
                },
              ).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
