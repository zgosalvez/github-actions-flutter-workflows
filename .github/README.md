# GitHub Actions: Flutter Workflows

This sample project allows you to leverage GitHub Actions to run common Flutter workflows.

## Usage

Create a workflow `.yml` file in your `.github/workflows` directory. Example workflows are available in this repository. For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

## Workflows

All workflows use the [Ensure SHA Pinned Actions](https://github.com/marketplace/actions/ensure-sha-pinned-actions) action to ensure security hardening.

### Quality Control
[![QC](https://github.com/zgosalvez/github-actions-flutter-workflow/workflows/QC/badge.svg)](https://github.com/zgosalvez/github-actions-flutter-workflow/actions?query=workflow%3AQC)

[`.github/workflows/qc.yml`](./tree/main/.github/workflows/qc.yml)

Also known as QC, Quality Control runs static analysis then Flutter testing. The coverage report is stored as an artifact for reference. Modify the workflow to further process the code coverage file using [code quality](https://github.com/marketplace?type=actions) or [code review](https://github.com/marketplace?category=code-review&type=actions) actions.