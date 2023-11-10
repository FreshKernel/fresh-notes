# Contributing

The contributions are more than welcome! <br>

There are no guidelines for now.
This page will be updated in the future.

## Steps to contributing

You will need GitHub account as well as Git installed and configured with your GitHub account on your local machine

1. Fork the repository in GitHub
2. Clone the forked repository using `git`
3. Add the `upstream` repository using:
    ```
    git remote add upstream git@github.com:freshtechtips/fresh-notes-app.git
    ```
4. Open the project with your favorite IDE, usually, we prefer to use Jetbrains IDEs, but since [VS Code](https://code.visualstudio.com) is more used and has more support for Dart, then we suggest using it if you want to.
5. Create a new git branch and switch to it using:
   
    ```
    git checkout -b your-branch-name
    ```
    The `your-branch-name` is your choice
6. Make your changes
7.  Test them in the [app](../lib/main.dart)
8.  Mention the new changes in the [CHANGELOG.md](../CHANGELOG.md) in the next 
9.  Now you can send your pull request either by following the link that you will get in the command line or open your
forked repository, and you will find an option to send the pull request, you can also
open the [Pull Requests](https://github.com/freshtechtips/fresh-notes-app/pulls) tab and send new pull request
1.  Please wait for the review, and we might ask you to make more changes, then run:
```
git add .
git commit -m "Your new commit message"
git push origin your-branch-name
```

Thank you for your time and efforts to open-source community projects!!