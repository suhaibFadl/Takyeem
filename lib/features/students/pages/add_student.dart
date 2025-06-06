import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/reports/models/surah.dart';
import 'package:takyeem/features/reports/widgets/snackbar_message.dart';
import 'package:takyeem/features/students/bloc/student_bloc.dart';
import 'package:takyeem/features/students/bloc/student_event.dart';
import 'package:takyeem/features/students/bloc/student_state.dart';
import 'package:takyeem/features/students/models/student.dart';
import 'package:takyeem/features/students/service/studentService.dart';

class AddStudentPage extends StatelessWidget {
  AddStudentPage({super.key});
  final _studentService = StudentService();

  Future<void> addStudent(Student student) async {
    await _studentService.addStudent(student);
  }

  bool validatePhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^(091|092|093|094)\d{7}$');
    return regex.hasMatch(phoneNumber);
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocListener<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentAddedState) {
            showTimedMessage(context, 'تم إضافة الطالب بنجاح');
            context.read<StudentBloc>().add(AddNewStudentEvent());
          }
        },
        child:
            BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
          if (state is StudentInitialState) {
            context.read<StudentBloc>().add(AddNewStudentEvent());
          }
          if (state is StudentLoadingState) {
            return LoadingIndicator(
              indicatorType: Indicator.ballClipRotatePulse,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              strokeWidth: 2,
              backgroundColor: Colors.transparent,
              pathBackgroundColor: Colors.transparent,
            );
          }
          if (state is AddNewStudentState) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
              child: ListView(
                children: [
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "إضافة طالب",
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ],
                  ),
                  const Gap(24),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'first_name',
                          keyboardType: TextInputType.name,
                          textDirection: TextDirection.rtl,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: 'الاسم الأول',
                            hintTextDirection: TextDirection.rtl,
                            contentPadding: EdgeInsets.only(right: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFF73655D)), // Secondary color or any other color
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "الاسم الأول مطلوب",
                            ),
                            FormBuilderValidators.minLength(2),
                          ]),
                        ),
                        const Gap(12),
                        FormBuilderTextField(
                          name: 'father_name',
                          keyboardType: TextInputType.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            hintText: 'اسم الأب',
                            hintTextDirection: TextDirection.rtl,
                            contentPadding: EdgeInsets.only(right: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFF73655D)), // Secondary color or any other color
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "اسم الأب مطلوب",
                            ),
                            FormBuilderValidators.minLength(2),
                          ]),
                        ),
                        const Gap(12),
                        FormBuilderTextField(
                          name: 'last_name',
                          keyboardType: TextInputType.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            hintText: 'اللقب',
                            hintTextDirection: TextDirection.rtl,
                            contentPadding: EdgeInsets.only(right: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFF73655D)), // Secondary color or any other color
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "اللقب مطلوب",
                            ),
                            FormBuilderValidators.minLength(2),
                          ]),
                        ),
                        const Gap(12),
                        FormBuilderTextField(
                          name: 'quardianPhoneNumber',
                          keyboardType: TextInputType.number,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            hintText: 'رقم هاتف ولي الأمر',
                            hintTextDirection: TextDirection.rtl,
                            contentPadding: const EdgeInsets.only(right: 8.0),
                            // errorStyle: TextStyle(
                            //   color: Colors.red,
                            // ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFF73655D)), // Secondary color or any other color
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "رقم هاتف ولي الأمر مطلوب"),
                            FormBuilderValidators.minLength(10,
                                errorText:
                                    "رقم الهاتف يجب أن يتكون من 10 أرقام"),
                            (value) {
                              if (value != null &&
                                  !validatePhoneNumber(value)) {
                                return "رقم الهاتف غير صالح";
                              }
                              return null; // Return null if the value is valid
                            },
                          ]),
                        ),
                        const Gap(12),
                        FormBuilderTextField(
                          name: 'phoneNumber',
                          keyboardType: TextInputType.number,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            hintText: 'رقم هاتف الطالب',
                            hintTextDirection: TextDirection.rtl,
                            contentPadding: EdgeInsets.only(right: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFF73655D)), // Secondary color or any other color
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (value.length < 10) {
                                return "رقم الهاتف يجب أن يتكون من 10 أرقام";
                              }

                              if (!validatePhoneNumber(value)) {
                                return "رقم الهاتف غير صالح";
                              }
                              return null;
                            }
                          ]),
                        ),
                        const Gap(16),
                        FormBuilderDateTimePicker(
                          name: 'bornDate',
                          style: Theme.of(context).textTheme.bodyMedium,
                          inputType: InputType.date,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintText: 'تاريخ الميلاد',
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              // Border around the input field
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                              borderSide: const BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                              borderSide: const BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                              borderSide: const BorderSide(
                                  color: Color(0xFF73655D)), // Secondary color
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "تاريخ الميلاد مطلوب"),
                          ]),
                          // locale: Locale('ar', 'AE'),
                        ),
                        const Gap(12),
                        FormBuilderDateTimePicker(
                          name: 'joiningDate',
                          style: Theme.of(context).textTheme.bodyMedium,
                          inputType: InputType.date,
                          initialDate: DateTime.now(),
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintText: 'تاريخ الالتحاق',
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              // Border around the input field
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                              borderSide: const BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                              borderSide: const BorderSide(
                                  color: Color(0xFF262523)), // Primary color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                              borderSide: const BorderSide(
                                  color: Color(0xFF73655D)), // Secondary color
                            ),
                          ),
                        ),
                        const Gap(12),
                        FormBuilderDropdown<int>(
                          name: 'surah_Id',
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'السورة الحالية',
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(Icons.arrow_drop_down,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          items: state.surahs
                              .map((surah) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.centerEnd,
                                    value: surah.id,
                                    child: Text(
                                      surah.name,
                                      textDirection: TextDirection.rtl,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ))
                              .toList(),
                          validator: FormBuilderValidators.required(
                            errorText: "الرجاء اختيار السورة",
                          ),
                          alignment: AlignmentDirectional.centerEnd,
                          icon: const SizedBox(),
                        ),
                        const Gap(40),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                            // color: Theme.of(context).colorScheme.secondary,
                            style: Theme.of(context).elevatedButtonTheme.style,
                            onPressed: () {
                              // Validate and save the form values
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                var formData = _formKey.currentState?.value;
                                debugPrint("******************$formData");
                                Student studentData =
                                    Student.fromJson(formData!);
                                debugPrint(
                                    "******************${studentData.surahId}");
                                context.read<StudentBloc>().add(
                                    SendStudentDataEvent(student: studentData));
                              } else {
                                // Form is invalid, show errors
                                debugPrint("Form is invalid");
                              }

                              // debugPrint(_formKeRy.currentState?.value.toString());

                              // On another side, can access all field values without saving form with instantValues
                              // _formKey.currentState?.validate();
                              // debugPrint(
                              //     _formKey.currentState?.instantValue.toString());
                            },
                            child: Text(
                              'إضـــــــافــــــة',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is StudentAddedState) {
            showTimedMessage(context, 'تم إضافة الطالب بنجاح');
            context.read<StudentBloc>().add(AddNewStudentEvent());
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
