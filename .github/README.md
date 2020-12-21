# GitHub Actions: Flutter Workflows

This sample project allows you to leverage GitHub Actions to run common Flutter workflows. These are based on the workflows found in the [Flutter Gallery](https://github.com/flutter/gallery) repository.

## Usage

Create a workflow `.yml` file in your `.github/workflows` directory. Example workflows are available in this repository. For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

## Workflows

All workflows use the [Ensure SHA Pinned Actions](https://github.com/marketplace/actions/ensure-sha-pinned-actions) action to ensure security hardening.

_Note:_ The [Get the Flutter Version Environment](https://github.com/marketplace/actions/get-the-flutter-version-environment) action requires that the [`pubspec.yaml`](pubspec.yaml) file contains an `environment:flutter:` key. This is used for installing Flutter in the workflows.

### Continuous Integration
[![CI](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/CI/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ACI)

[`.github/workflows/ci.yml`](workflows/ci.yml)

Also known as CI, Continuous Integration runs Flutter static and dynamic tests on every pull request to `main`, then the coverage report is stored as an artifact for reference. Modify the workflow to further process the code coverage file using [code quality](https://github.com/marketplace?type=actions) or [code review](https://github.com/marketplace?category=code-review&type=actions) actions.

### Continuous Delivery
[![CDelivery](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/CDelivery/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ACDelivery)

[`.github/workflows/cdelivery.yml`](workflows/cdelivery.yml)

Also known as CDelivery (not to be mistaken with another CD, Continuous Deployment), Continuous Delivery reruns the same Flutter static and dynamic tests from the CI on every push to `main`, then a pre-release draft is created. Manually, remove the pre-release mark after it has been deployed and released to the app store.

### Deployment
[![Deployment](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/Deployment/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3ADeployment)

[`.github/workflows/deployment.yml`](workflows/deployment.yml)

Deployment is triggered when the release draft is published. It reruns the same Flutter static and dynamic tests from the CI before running Flutter's build commands. The app version used is based on the release tag, not the name. Lastly, build artifacts are uploaded as release assets.

## License
The scripts and documentation in this project are released under the [MIT License](LICENSE)