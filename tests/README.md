# Terraform Tests

This directory contains a set of Terraform tests categorized into `local`, `remote`, and `examples` to streamline the development and CI/CD processes.

## `./examples`

This directory contains tests for all Terraform examples in `../examples`. The following script modifies the `source` path in each example, initializes the test directory, runs the tests, and then reverts the changes.

```shell
for file in ./examples/*/*.tf; do
  sed -i.backup 's|source *= *"cloudeteer/launchpad/azurerm"|source = "../.."|g' $file
done

terraform init -test-directory=tests/examples
terraform test -test-directory=tests/examples

for file in ./examples/*/*.tf.backup; do
  mv $file ${file%.backup}
done
```

## `./local`

This directory is for tests intended to run locally during development. Use the following commands to initialize and run the tests:

```shell
terraform init -test-directory=tests/local
terraform test -test-directory=tests/local
```

## `./remote`

This directory contains tests designed to be executed by CI/CD pipelines.
To test this locally, you need to set the `ARM_SUBSCRIPTION_ID` variable because the tests actually provision real resources on Azure.
Use the following commands to initialize and run the tests:

```shell
export ARM_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
terraform init -test-directory=tests/remote
terraform test -test-directory=tests/remote
```