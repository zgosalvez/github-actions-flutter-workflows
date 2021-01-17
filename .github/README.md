# GitHub Actions: Flutter Workflows

This sample project allows you to leverage GitHub Actions to run common Flutter workflows. These are based on the workflows found in the [Flutter Gallery](https://github.com/flutter/gallery) repository. Continue reading to apply these to your Flutter project.

## Disclaimer
This is still in active development, and it currently supports iOS and Android deployments only. Please [open a pull request](CONTRIBUTING.md) to support other platforms.

## Usage

Create workflows in your `.github/workflows` directory. Examples are available in this repository. For more information, see the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

*Note:* Although this Flutter project works as-is, consider tailoring these workflows to your needs. If you're starting from scratch, copying and pasting will work as long as you follow the [GitHub flow](https://guides.github.com/introduction/flow/) and [release based workflow](https://lab.github.com/githubtraining/create-a-release-based-workflow).

### Protected Branches
Recommended rules for the `main` and `release/v*` branches:
- [x] Require status checks to pass before merging
  - [x] Require branches to be up to date before merging
  - [x] Check security hardening
  - [x] Generate coverage report
  - [x] Run static testing
  - [x] Run unit testing
  - [x] Run widget testing

### Workflows

- All of the workflows here use the [Ensure SHA Pinned Actions](https://github.com/marketplace/actions/ensure-sha-pinned-actions) action to ensure security hardening.
- The [Get the Flutter Version Environment](https://github.com/marketplace/actions/get-the-flutter-version-environment) action requires that the [`pubspec.yaml`](../pubspec.yaml#L22) file contains an `environment:flutter:` key, which is used for installing Flutter with the correct version.

#### Continuous Integration
[![CI](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/CI/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ACI)

[`.github/workflows/ci.yml`](workflows/ci.yml)

Also known as CI, Continuous Integration runs Flutter static and dynamic tests on *every pull request* to `main` and `release/v*`, then the coverage report is stored as an artifact for reference. A comment is added to the pull request on every run as seen here, [#10 (comment)](https://github.com/zgosalvez/github-actions-flutter-workflows/pull/10#issuecomment-753592566). Modify the workflow to further process the code coverage file using [code quality](https://github.com/marketplace?type=actions) or [code review](https://github.com/marketplace?category=code-review&type=actions) actions.

Testing is split into unit and widget tests. These are found in the `test/units` and `test/widgets` directories, respectively. The CI runs these in parallel to optimize for workflow throughput, especially on a large project with a considerable number of test cases.

#### Continuous Delivery
[![CDelivery](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/CDelivery/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ACDelivery)

[`.github/workflows/cdelivery.yml`](workflows/cdelivery.yml)

Also known as CDelivery (not to be mistaken with another CD, i.e., Continuous Deployment), Continuous Delivery drafts a pre-release on *every push* to `main`. For the draft to populate with the release notes, pull requests should be `main` based. Manually remove the pre-release mark after it has been deployed and released to the app store.

[`.github/workflows/pull_request-opened.yml`](workflows/pull_request-opened.yml)

To draft the release this workflow uses the [Release Drafter](https://github.com/marketplace/actions/release-drafter) action to compile the pull requests and categorizes it using the [PR Labeler](https://github.com/marketplace/actions/pr-labeler) action. Add the [`.github/release-drafter.yml`](release-drafter.yml) and [`.github/pr-labeler.yml`](pr-labeler.yml) files in your project since these are required configurations for these actions, respectively. Customize the configuration files as needed.

#### Deployment
[![Deployment](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/Deployment/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ADeployment)

[`.github/workflows/deployment.yml`](workflows/deployment.yml)

Deployment is triggered when the release draft (or any release) is published. It reruns the same Flutter static and dynamic tests from the CI before running Flutter's build commands. The app version used is based on the release tag, not the name. Lastly, build artifacts are uploaded as release assets.

### Dependabot

This includes a [`.github/dependabot.yml`](dependabot.yml) file that allows Dependabot to maintain the GitHub Actions used in these workflows. For more information, see the GitHub Documentation for [Keeping your dependencies updated automatically](https://docs.github.com/en/github/administering-a-repository/keeping-your-dependencies-updated-automatically).

## License
The scripts and documentation in this project are released under the [MIT License](LICENSE)