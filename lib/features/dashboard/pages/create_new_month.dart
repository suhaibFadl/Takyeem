import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:takyeem/features/dashboard/blocs/dashboard_bloc/dashboard_bloc.dart';

class CreateNewMonthPage extends StatelessWidget {
  CreateNewMonthPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
        child: ListView(
          children: [
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "إضافة شهر جديد",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
            const Gap(64),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'month_name',
                    keyboardType: TextInputType.name,
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: 'اسم الشهر',
                      hintTextDirection: TextDirection.rtl,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF262523)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF73655D)),
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "اسم الشهر مطلوب",
                      ),
                    ]),
                  ),
                  const Gap(32),
                  FormBuilderTextField(
                    name: 'year',
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: 'السنة',
                      hintTextDirection: TextDirection.rtl,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF262523)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF73655D)),
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "السنة مطلوبة",
                      ),
                      FormBuilderValidators.numeric(
                        errorText: "يجب إدخال أرقام فقط",
                      ),
                    ]),
                  ),
                  const Gap(32),
                  FormBuilderDropdown<int>(
                    name: 'shift',
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'الإزاحة',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      hintTextDirection: TextDirection.rtl,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF262523)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF73655D)),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 1,
                        child: Text('1', textAlign: TextAlign.right),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: Text('0', textAlign: TextAlign.right),
                      ),
                      DropdownMenuItem(
                        value: -1,
                        child: Text('-1', textAlign: TextAlign.right),
                      ),
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "الإزاحة مطلوبة",
                      ),
                    ]),
                  ),
                  const Gap(64),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          var formData = _formKey.currentState?.value;
                          context.read<DashboardBloc>().add(
                                CreateNewMonthEvent(
                                  monthName: formData?['month_name'],
                                  year: int.parse(formData?['year']),
                                  shift: formData?['shift'],
                                ),
                              );
                        } else {
                          debugPrint("Form is invalid");
                        }
                      },
                      child: Text(
                        'إضـــــــافــــــة',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
