# GitHub Actions: Flutter Workflows

This sample project allows you to leverage GitHub Actions to run common Flutter workflows. These are based on the workflows found in the [Flutter Gallery](https://github.com/flutter/gallery) repository. Continue reading to apply these to your Flutter project.

## Disclaimer
This is still in active development, and it currently supports iOS and Android deployments only. Please open a pull request to support other platforms.

## Usage

Create workflows in your `.github/workflows` directory. Examples are available in this repository. For more information, see the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

*Note:* Although this Flutter project works as-is, consider tailoring these workflows to your needs. If you're starting from scratch, copying and pasting will work as long as you follow the [GitHub flow](https://guides.github.com/introduction/flow/) and [release based workflow](https://lab.github.com/githubtraining/create-a-release-based-workflow).

### Protected Branches

Enable the following rules for the `main` and `release/v*` branches:
- [x] Require status checks to pass before merging
  - [x] Require branches to be up to date before merging (Recommended)
  - [x] Check security hardening
  - [x] Run static testing
  - [x] Run unit testing
  - [x] Run widget testing
- [x] Require signed commits (Recommended)
- [x] Require linear history (Recommended)
- [x] Include administrators (Recommended)

### Workflows

- All of the workflows here use the [Ensure SHA Pinned Actions](https://github.com/marketplace/actions/ensure-sha-pinned-actions) action to ensure security hardening.
- The [Get the Flutter Version Environment](https://github.com/marketplace/actions/get-the-flutter-version-environment) action requires that the [`pubspec.yaml`](pubspec.yaml) file contains an `environment:flutter:` key, which is used for installing Flutter with the correct version.

#### Continuous Integration
[![CI](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/CI/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ACI)

[`.github/workflows/ci.yml`](workflows/ci.yml)

Also known as CI, Continuous Integration runs Flutter static and dynamic tests on *every pull request* to `main` and `release/v*`, then the coverage report is stored as an artifact for reference. A comment is added to the pull request on every run as seen here, https://github.com/zgosalvez/github-actions-flutter-workflows/pull/9#issuecomment-750863281. Modify the workflow to further process the code coverage file using [code quality](https://github.com/marketplace?type=actions) or [code review](https://github.com/marketplace?category=code-review&type=actions) actions.

#### Continuous Delivery
[![CDelivery](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/CDelivery/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ACDelivery)

[`.github/workflows/cdelivery.yml`](workflows/cdelivery.yml)

Also known as CDelivery (not to be mistaken with another CD, i.e., Continuous Deployment), Continuous Delivery reruns the same Flutter static and dynamic tests from the CI on *every push* to `main` and `release/v*`, then a pre-release draft is created or updated. This ensures that the protected branches are bug-free and drafted release is updated. Manually remove the pre-release mark after it has been deployed and released to the app store.

*Note:* Since CDelivery reruns the `testing` job from CI, it will cost you additional runner minutes. If you are conscious of your budget and [require branches to be up to date before merging](https://docs.github.com/en/free-pro-team@latest/github/administering-a-repository/enabling-required-status-checks#:~:text=Require%20branches%20to%20be%20up%20to%20date%20before%20merging), you should comment the job out.

#### Deployment
[![Deployment](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/Deployment/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ADeployment)

[`.github/workflows/deployment.yml`](workflows/deployment.yml)

Deployment is triggered when the release draft (or any release) is published. It reruns the same Flutter static and dynamic tests from the CI before running Flutter's build commands. The app version used is based on the release tag, not the name. Lastly, build artifacts are uploaded as release assets.

## License
The scripts and documentation in this project are released under the [MIT License](LICENSE)