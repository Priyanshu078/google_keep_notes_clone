import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/authentication_cubit/authentication_cubit.dart';
import 'package:notes_app/blocs%20and%20cubits/authentication_cubit/authentication_states.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/pages/homepage.dart';
import 'package:notes_app/utils/utilities.dart';
import 'package:notes_app/widgets/mytext.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.2,
                child: Image.asset("assets/googlekeeplogo1.png"),
              ),
              SizedBox(
                height: height * 0.15,
              ),
              BlocConsumer<AuthenticationCubit, AuthenticationStates>(
                listener: (context, state) {
                  if (state is UserAuthenticated) {
                    context.read<NotesBloc>().add(FetchNotes(
                          userId: 'priyanshupaliwal',
                          notes: true,
                          trashedNotes: false,
                          archivedNotes: false,
                        ));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()));
                  } else if (state is AuthenticationErrorState) {
                    Utilities().showSnackBar(context, "Please try again !!!");
                  }
                },
                builder: (context, state) {
                  return state is AuthenticationInitial
                      ? InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {
                            Utilities()
                                .showSnackBar(context, "Please wait !!!");
                            context
                                .read<AuthenticationCubit>()
                                .signInWithGoogle();
                          },
                          child: Container(
                            height: height * 0.1,
                            width: width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? themeColorDarkMode
                                  : bottomBannerColor,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/googleImage.png"),
                                  SizedBox(
                                    width: width * 0.1,
                                  ),
                                  MyText(
                                      text: "Sign in with Google",
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge)
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            strokeWidth: 2,
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
