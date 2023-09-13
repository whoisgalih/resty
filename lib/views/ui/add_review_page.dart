import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/data/models/customer_review/cutomer_review_model.dart';
import 'package:resty/provider/add_review_provider.dart';
import 'package:resty/themes/colors.dart';

class AddReviewPage extends StatelessWidget {
  static const routeName = '/add_review';

  const AddReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddReviewProvider>(
      builder: (BuildContext context, AddReviewProvider state, _) {
        return Scaffold(
          appBar: AppBar(title: const Text("Add Review")),
          floatingActionButton: state.state == ResultState.loading
              ? FloatingActionButton(
                  onPressed: () {},
                  child: CircularProgressIndicator(
                    color: primaryColor[950],
                  ),
                )
              : FloatingActionButton.extended(
                  onPressed: () async {
                    if (state.formKey.currentState!.validate()) {
                      state.addReview().then((result) {
                        if (result is List<CustomerReview>) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Review added successfully"),
                              backgroundColor: primaryColor[800],
                            ),
                          );
                          Navigator.pop(context, result);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result),
                              backgroundColor: primaryColor[800],
                            ),
                          );
                        }
                      });
                    }
                  },
                  label: Text(
                    "Add Review",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  icon: const Icon(Icons.add),
                ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: state.formKey,
                child: Column(
                  children: [
                    _textField(
                      label: "Name",
                      hint: "Name",
                      context: context,
                      controller: state.nameController,
                      validator: state.nameValidator,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      label: "Review",
                      hint: "Write down your review here",
                      context: context,
                      controller: state.reviewController,
                      numberOfLines: 10,
                      validator: state.reviewValidator,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Column _textField({
    required String label,
    required String hint,
    required BuildContext context,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int? numberOfLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          minLines: numberOfLines,
          maxLines: numberOfLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}
